package model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Transient;

/**
 * @Prime13 Consultants
 */
@Entity
public class Fund {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long fundId;

    @Column(length = 255, unique = true)
    private String name;

    @Column(length = 255, unique = true)
    private String symbol;

    @Transient
    private Long currentPrice;

    @Transient
    private double increaseRate;

    public double getIncreaseRate() {
        return increaseRate;
    }

    public void setIncreaseRate(double increaseRate) {
        this.increaseRate = increaseRate;
    }

    public Long getFundId() {
        return fundId;
    }

    public void setFundId(Long fundId) {
        this.fundId = fundId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public Double getCurrentPrice() {
        if (currentPrice == null) {
            return null;
        }
        return currentPrice / 100.0;
    }

    public void setCurrentPrice(Long currentPrice) {
        this.currentPrice = currentPrice;
    }

}
