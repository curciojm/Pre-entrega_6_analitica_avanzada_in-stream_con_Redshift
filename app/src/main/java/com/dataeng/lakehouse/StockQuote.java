package com.dataeng.lakehouse;

import java.io.Serializable;

public class StockQuote implements Serializable {

    private static final long serialVersionUID = 1L;

    private String ticker;
    private double price;
    private long eventTime;

    public StockQuote() {
    }

    public StockQuote(String ticker, double price, long eventTime) {
        this.ticker = ticker;
        this.price = price;
        this.eventTime = eventTime;
    }

    public String getTicker() {
        return ticker;
    }

    public void setTicker(String ticker) {
        this.ticker = ticker;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public long getEventTime() {
        return eventTime;
    }

    public void setEventTime(long eventTime) {
        this.eventTime = eventTime;
    }

    @Override
    public String toString() {
        return "StockQuote{" +
                "ticker='" + ticker + '\'' +
                ", price=" + price +
                ", eventTime=" + eventTime +
                '}';
    }
}
