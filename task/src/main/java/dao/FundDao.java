package dao;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import model.Fund;

/**
 * @Prime13 Consultants
 */
@Repository
@Transactional
public class FundDao extends GenericDao<Fund> {

    public Fund findByNameAndSymbol(String name, String symbol) {
        List<Fund> result = em
                .createQuery("SELECT e FROM Fund e WHERE e.name = :name AND e.symbol = :symbol", Fund.class)
                .setParameter("name", name).setParameter("symbol", symbol).getResultList();

        return result.isEmpty() ? null : result.get(0);
    }

    public List<Fund> findAllFunds() {
        return em.createQuery("SELECT e FROM Fund e", genericType).getResultList();
    }
}
