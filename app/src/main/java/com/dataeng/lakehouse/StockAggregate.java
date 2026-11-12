package com.dataeng.lakehouse;

import java.io.Serializable;

public class StockAggregate implements Serializable {

    private static final long serialVersionUID = 1L;

    private String ticker;
    private long windowStart;
    private long windowEnd;

    private long tradeCount;
    private double avgPrice;
    private double maxPrice;
    private double minPrice;

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

    @Override
    public String toString() {
        return "StockAggregate{" +
                "ticker='" + ticker + '\'' +
                ", windowStart=" + windowStart +
                ", windowEnd=" + windowEnd +
                ", tradeCount=" + tradeCount +
                ", avgPrice=" + avgPrice +
                ", maxPrice=" + maxPrice +
                ", minPrice=" + minPrice +
                '}';
    }
}
