package dao;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import model.Customer;

/**
 * @Prime13 Consultants
 */
@Repository
@Transactional
public class CustomerDao extends GenericDao<Customer> {
    public List<Customer> getAllCustomers() {
        return em.createQuery("SELECT e FROM Customer e", genericType).getResultList();
    }
    

}
