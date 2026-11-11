// conecta los datos que llegan desde Kinesis con los objetos Java que utiliza Flink para procesarlos. 
// Es decir, es el componente que convierte el JSON en un StockQuote
package com.dataeng.lakehouse;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.time.Instant;
// ObjectMapper: es la clase principal de Jackson para convertir JSON en objetos Java y viceversa
// Instant: representa un instante temporal en UTC, con precisión de nanosegundos
public class StockQuoteParser {
// static: pertenece a la clase, no a cada instancia de StockQuoteParser.
// final: la referencia de la variable no puede reasignarse a otro objeto.
// Variable de instancia: cada objeto creado a partir de una clase tiene su propia variable.
// Variable static: pertenece a la clase y es compartida por todas sus instancias.
    private static final ObjectMapper MAPPER = new ObjectMapper();

    public static StockQuote parse(String json) {

        try { // readTree() analiza el texto JSON y construye una estructura de nodos que podemos consultar
            JsonNode node = MAPPER.readTree(json);

            String ticker = node.get("TICKER").asText();

            double price = node.get("PRICE").asDouble();

            long eventTime = Instant.parse(
                    node.get("EVENT_TIME").asText()

            ).toEpochMilli();

            return new StockQuote(ticker, price, eventTime);

        } catch (Exception e) {
            throw new IllegalArgumentException(
                    "Error parsing stock quote: " + json, e
            );
        }
    }
}
