package com.dataeng.lakehouse;

import java.util.HashMap;
import java.util.Map;

import org.apache.hadoop.conf.Configuration;

import org.apache.iceberg.CatalogUtil;
import org.apache.iceberg.Schema;
import org.apache.iceberg.PartitionSpec;
import org.apache.iceberg.Table;
import org.apache.iceberg.catalog.Catalog;
import org.apache.iceberg.catalog.Namespace;
import org.apache.iceberg.catalog.TableIdentifier;
import org.apache.iceberg.flink.CatalogLoader;
import org.apache.iceberg.flink.TableLoader;
import org.apache.iceberg.types.Types;

public class IcebergTableManager {

    private static final String TABLE_NAME = "stock_aggregations";

    public static TableLoader createTableIfNotExists(
            String awsRegion,
            String bucketName,
            String databaseName
    ) throws Exception {

        Map<String, String> properties = new HashMap<>();

        properties.put(
            "warehouse",
            "s3://" + bucketName + "/warehouse"
        );

        properties.put(
            "io-impl",
            "org.apache.iceberg.aws.s3.S3FileIO"
        );

        properties.put("client.region", awsRegion);

        Configuration hadoopConf = new Configuration();

        CatalogLoader catalogLoader = CatalogLoader.custom(
            "glue",
            properties,
            hadoopConf,
            "org.apache.iceberg.aws.glue.GlueCatalog"
        );

        Catalog catalog = catalogLoader.loadCatalog();

        try {

            Namespace namespace = Namespace.of(databaseName);

            TableIdentifier tableIdentifier = TableIdentifier.of(
                namespace,
                TABLE_NAME
            );

            if (!catalog.tableExists(tableIdentifier)) {

                Schema schema = new Schema(
                    Types.NestedField.required(
                        1, "ticker", Types.StringType.get()
                    ),
                    Types.NestedField.required(
                        2, "window_start", Types.TimestampType.withZone()
                    ),
                    Types.NestedField.required(
                        3, "window_end", Types.TimestampType.withZone()
                    ),
                    Types.NestedField.required(
                        4, "trade_count", Types.LongType.get()
                    ),
                    Types.NestedField.required(
                        5, "avg_price", Types.DoubleType.get()
                    ),
                    Types.NestedField.required(
                        6, "max_price", Types.DoubleType.get()
                    ),
                    Types.NestedField.required(
                        7, "min_price", Types.DoubleType.get()
                    )
                );

                PartitionSpec partitionSpec = PartitionSpec
                    .builderFor(schema)
                    .day("window_start")
                    .build();

                Table table = catalog.createTable(
                    tableIdentifier,
                    schema,
                    partitionSpec
                );

                System.out.println(
                    "Tabla Iceberg creada: " + table.name()
                );

            } else {

                System.out.println(
                    "La tabla Iceberg ya existe: " + TABLE_NAME
                );
            }

            return TableLoader.fromCatalog(
                catalogLoader,
                tableIdentifier
            );

        } finally {

            if (catalog instanceof AutoCloseable) {
                ((AutoCloseable) catalog).close();
            }
        }
    }
}
