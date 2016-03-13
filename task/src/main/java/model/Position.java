package model;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Transient;

/**
 * @Prime13 Consultants
 */
@Entity
public class Position {

    @EmbeddedId
    private PositionPK id;

    @Column
    private Long shares = 0L;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "fundId", insertable = false, updatable = false)
    private Fund fund;

    @Transient
    private Long curSharePrice;

    public PositionPK getId() {
        return id;
    }

    public void setId(PositionPK id) {
        this.id = id;
    }

    public Long getShares() {
        return shares;
    }

    public void setShares(Long shares) {
        this.shares = shares;
    }

    public Double getCurSharePrice() {
        if (curSharePrice == null) {
            return null;
        }
        return curSharePrice / 100.0;
    }

    public void setCurSharePrice(Long curSharePrice) {
        this.curSharePrice = curSharePrice;
    }

    public Fund getFund() {
        return fund;
    }

    public void setFund(Fund fund) {
        this.fund = fund;
    }

    public Double getPresentShares() {
        if (shares == null) {
            return null;
        }
        return this.shares / 1000.0;
    }

}
