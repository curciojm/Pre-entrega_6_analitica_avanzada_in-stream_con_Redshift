// objeto que acumule temporalmente los valores recibidos para luego hacer los calculos


package com.dataeng.lakehouse;

import java.io.Serializable;

// implements Serializable: indica que los objetos de esta clase pueden serializarse, 
// es decir, convertirse en una representación que permita almacenarlos o transmitirlos
public class StockAccumulator implements Serializable {
// serialVersionUID: es un identificador de versión de la clase serializable.
// Permite verificar la compatibilidad entre versiones durante la deserialización
    private static final long serialVersionUID = 1L;

    private String ticker;
    private long tradeCount;
    private double sumPrice;
    private double maxPrice;
    private double minPrice;
// this en Java hace referencia al objeto actual, es decir, a la instancia de la clase en la que estamos trabajando
// El constructor inicializa el objeto cuando se crea una instancia
// getters permiten consultar los atributos y los setters permiten modificarlos
    public StockAccumulator() {
        this.tradeCount = 0;
        this.sumPrice = 0.0;
        // infinity asi cualquier precio valido seria mayor que el inicial
        this.maxPrice = Double.NEGATIVE_INFINITY;
        this.minPrice = Double.POSITIVE_INFINITY;
    }

    public String getTicker() {
        return ticker;
    }

    public void setTicker(String ticker) {
        // this es atributo de la instancia y la segunda el parametro del metodo
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
