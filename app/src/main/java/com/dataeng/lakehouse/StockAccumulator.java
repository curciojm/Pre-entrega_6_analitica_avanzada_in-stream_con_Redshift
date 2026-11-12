package com.dataeng.lakehouse;

import java.io.Serializable;

public class StockAccumulator implements Serializable {
    private static final long serialVersionUID = 1L;

    private String ticker;
    private long tradeCount;
    private double sumPrice;
    private double maxPrice;
    private double minPrice;
    public StockAccumulator() {
        this.tradeCount = 0;
        this.sumPrice = 0.0;
        this.maxPrice = Double.NEGATIVE_INFINITY;
        this.minPrice = Double.POSITIVE_INFINITY;
    }

    public String getTicker() {
        return ticker;
    }

    public void setTicker(String ticker) {
        this.ticker = ticker;
    }

    public long getTradeCount() {
        return tradeCount;
    }

    public void setTradeCount(long tradeCount) {
        this.tradeCount = tradeCount;
    }

    public double getSumPrice() {
        return sumPrice;
    }

    public void setSumPrice(double sumPrice) {
        this.sumPrice = sumPrice;
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
}
