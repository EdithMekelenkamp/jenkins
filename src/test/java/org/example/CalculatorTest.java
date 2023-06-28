package org.example;

import org.junit.Before;
import org.junit.Test;
import org.junit.jupiter.api.Assertions;

public class CalculatorTest {

    Calculator calculator;

    @Before
    public void setUp(){
        calculator = new Calculator();
    }
    @Test
    public void test(){
        Assertions.assertEquals(20, calculator.calculate(10, 10));
    }
}