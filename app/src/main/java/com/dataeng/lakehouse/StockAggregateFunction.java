// calculos y genera el stockaggregate
// implementa AggregateFunction de flink


package com.dataeng.lakehouse;

import org.apache.flink.api.common.functions.AggregateFunction;

public class StockAggregateFunction
        implements AggregateFunction<
                StockQuote,
                StockAccumulator,
                StockAggregate> {
// Cuando Flink necesita iniciar una agregación, invoca este método para obtener el estado inicial.
    @Override
    public StockAccumulator createAccumulator() {
        return new StockAccumulator();
    }
// add acumula la cotizacion
    @Override
    public StockAccumulator add(
            StockQuote quote,
            StockAccumulator accumulator) {

        accumulator.setTicker(quote.getTicker());

        accumulator.setTradeCount(
                accumulator.getTradeCount() + 1
        );

        accumulator.setSumPrice(
                accumulator.getSumPrice() + quote.getPrice()
        );

        accumulator.setMaxPrice(
                Math.max(
                        accumulator.getMaxPrice(),
                        quote.getPrice()
                )
        );

        accumulator.setMinPrice(
                Math.min(
                        accumulator.getMinPrice(),
                        quote.getPrice()
                )
        );

        return accumulator;
    }

    @Override
    public StockAggregate getResult(
            StockAccumulator accumulator) {
// operador ternario condicion ? valor_si_verdadero : valor_si_falso;
// en el ejemplo evita que el resultado del acumulador sea 0, si tradecount es mayor que cero hace la operacion sino devuelve 0
        double average = accumulator.getTradeCount() > 0
                ? accumulator.getSumPrice() / accumulator.getTradeCount()
                : 0.0;

        return new StockAggregate(
                accumulator.getTicker(),
                0L,
                0L,
                accumulator.getTradeCount(),
                average,
                accumulator.getMaxPrice(),
                accumulator.getMinPrice()
        );
    }
// Flink puede tener agregaciones parciales que luego necesita combinar para obtener un resultado conjunto
// todo se acumula en a
    @Override
    public StockAccumulator merge(
            StockAccumulator a,
            StockAccumulator b) {

        a.setTradeCount(
                a.getTradeCount() + b.getTradeCount()
        );

        a.setSumPrice(
                a.getSumPrice() + b.getSumPrice()
        );

        a.setMaxPrice(
                Math.max(a.getMaxPrice(), b.getMaxPrice())
        );

        a.setMinPrice(
                Math.min(a.getMinPrice(), b.getMinPrice())
        );

        return a;
    }
}
