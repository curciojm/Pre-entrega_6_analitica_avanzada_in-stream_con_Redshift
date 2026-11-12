import json
import random
import time
import uuid

import boto3
from botocore.exceptions import BotoCoreError, ClientError
from datetime import datetime, timezone


AWS_REGION = "us-east-2"
STREAM_NAME = "dev-kinesis-lakehouse-stream"

TICKERS = {
    "AAPL": 273.45,
    "MSFT": 510.20,
    "GOOGL": 285.30,
    "AMZN": 245.80,
}

EVENTS_PER_BATCH = 20
INTERVAL_SECONDS = 2


kinesis = boto3.client(
    "kinesis",
    region_name=AWS_REGION
)

def generate_quote(ticker, base_price):
    """Generate one stock quote event."""

    price = round(
        base_price * random.uniform(0.995, 1.005),
        2
    )

    event_time = datetime.now(
        timezone.utc
    ).isoformat(timespec="milliseconds").replace("+00:00", "Z")

    return {
        "TICKER": ticker,
        "PRICE": price,
        "EVENT_TIME": event_time
    }

def send_batch():
    records = []

    for _ in range(EVENTS_PER_BATCH):
        ticker = random.choice(list(TICKERS.keys()))
        quote = generate_quote(ticker, TICKERS[ticker])

        records.append({
            "Data": json.dumps(quote).encode("utf-8"),
            "PartitionKey": ticker
        })

    response = kinesis.put_records(
        StreamName=STREAM_NAME,
        Records=records
    )

    failed = response["FailedRecordCount"]

    successful = len(records) - failed

    print(
        f"Enviados: {successful} | "
        f"Fallidos: {failed}"
    )

    if failed:
        for record, result in zip(records, response["Records"]):
            if "ErrorCode" in result:
                print(
                    f"Error para {record['PartitionKey']}: "
                    f"{result['ErrorCode']} - "
                    f"{result.get('ErrorMessage', '')}"
                )


def main():
    print(f"Productor iniciado: {STREAM_NAME}")
    print("Presioná Ctrl+C para detenerlo.\n")

    try:
        while True:
            send_batch()
            time.sleep(INTERVAL_SECONDS)

    except KeyboardInterrupt:
        print("\nProductor detenido.")

    except (BotoCoreError, ClientError) as error:
        print(f"Error de AWS: {error}")


if __name__ == "__main__":
    main()
