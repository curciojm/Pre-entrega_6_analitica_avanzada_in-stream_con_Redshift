package com.dataeng.lakehouse;

import java.io.Serializable;
// acordate que public es una clase que permite que sea utilizada por otro, private no
public class StockAggregate implements Serializable {

    private static final long serialVersionUID = 1L;

    private String ticker;
    private long windowStart;
    private long windowEnd;

    private long tradeCount;
    private double avgPrice;
    private double maxPrice;
    private double minPrice;
// Constructor, crea un objeto
    public StockAggregate() {
    }

    public StockAggregate(
            String ticker,
            long windowStart,
            long windowEnd,
            long tradeCount,
            double avgPrice,
            double maxPrice,
            double minPrice) {

        this.ticker = ticker;
        this.windowStart = windowStart;
        this.windowEnd = windowEnd;
        this.tradeCount = tradeCount;
        this.avgPrice = avgPrice;
        this.maxPrice = maxPrice;
        this.minPrice = minPrice;
    }

    public String getTicker() {
        return ticker;
    }

    public void setTicker(String ticker) {
        this.ticker = ticker;
    }

    public long getWindowStart() {
        return windowStart;
    }

    public void setWindowStart(long windowStart) {
        this.windowStart = windowStart;
    }

    public long getWindowEnd() {
        return windowEnd;
    }

    public void setWindowEnd(long windowEnd) {
        this.windowEnd = windowEnd;
    }

    public long getTradeCount() {
        return tradeCount;
    }
// void es una palabra reservada que indica que un método no devuelve ningún valor al terminar su ejecución
// con void aca decimos que recibe lo que sea
// si dice ej double decimos que ese va a ser el valor
    public void setTradeCount(long tradeCount) {
        this.tradeCount = tradeCount;
    }

    public double getAvgPrice() {
        return avgPrice;
    }

    public void setAvgPrice(double avgPrice) {
        this.avgPrice = avgPrice;
    }

    public double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(double maxPrice) {
        this.maxPrice = maxPrice;
    }

    public double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(double minPrice) {
        this.minPrice = minPrice;
    }
// estos van a ser los valores que va a devolver el constructor
    @Override // signfica sobrescribir con string, especialmente útil para depuración y registros (logs)
    public String toString() {
        return "StockAggregate{" +
                "ticker='" + ticker + '\'' +
                // necesitamos identificar a qué intervalo temporal corresponde cada agregación por eso necesitamos la ventana...
                // ... para que consuma athena
                // ademas para la partition key en iceberg
                ", windowStart=" + windowStart +
                ", windowEnd=" + windowEnd +
                ", tradeCount=" + tradeCount +
                ", avgPrice=" + avgPrice +
                ", maxPrice=" + maxPrice +
                ", minPrice=" + minPrice +
                '}';
    }
}
