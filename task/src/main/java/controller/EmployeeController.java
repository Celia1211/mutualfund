package controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import dao.CustomerDao;
import dao.EmployeeDao;
import dao.FundDao;
import dao.FundPriceHistoryDao;
import dao.PositionDao;
import dao.TransactionDao;
import model.Customer;
import model.Employee;
import model.Fund;
import model.FundPriceHistory;
import model.FundPriceHistoryPK;
import model.Position;
import model.PositionPK;
import model.Transaction;
import model.User;
import service.MailService;
import util.Constants.TransactionStatus;
import util.Constants.TransactionType;
import util.Utils;

/**
 * @Prime13 Consultants
 */
@Controller
@Transactional
public class EmployeeController {

    private final SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");

    @Autowired
    private CustomerDao customerDao;

    @Autowired
    private EmployeeDao employeeDao;

    @Autowired
    private FundDao fundDao;

    @Autowired
    private TransactionDao tranDao;

    @Autowired
    private PositionDao positionDao;

    @Autowired
    private FundPriceHistoryDao fundPriceHistoryDao;

    @Autowired
    private CustomerController customerController;

    @Autowired
    private TransactionDao transactionDao;

    @Autowired
    private MailService mailService;

    @Autowired
    private ServletContext context;

    @PostConstruct
    public void init() {
        if (employeeDao.findByColumn("username", context.getInitParameter("adminUser")) == null) {
            Employee employee = new Employee();
            employee.setUsername("yangy3@andrew.cmu.edu");
            employee.setPassword(Utils.md5(context.getInitParameter("adminUserPass")));
            employee.setFirstname("Admin");
            employee.setLastname("Yang");
            employeeDao.save(employee);
        }
    }

    @RequestMapping(path = "tocreateemp", method = RequestMethod.GET)
    public String toCreateEmployee() {
        return "create-employee";
    }

    @RequestMapping(path = "tocreatecust", method = RequestMethod.GET)
    public String toCreateCust() {
        return "create-customer";
    }

    @RequestMapping(path = "tocreatefund", method = RequestMethod.GET)
    public String toCreateFund() {
        return "create-fund";
    }

    @RequestMapping(path = "toviewcust", method = RequestMethod.GET)
    public String toViewCust(@RequestParam("tabName") String tabName, @RequestParam("customerId") Long customerId,
            HttpServletRequest request) {
        
        request.setAttribute("tabName", tabName);
        if (customerDao.find(customerId) == null){
            return "error";
        }
        request.setAttribute("customer", customerDao.find(customerId));
        customerController.viewCustomerAccount(customerId, request);
        return "viewcustomer";
    }

    @RequestMapping(path = "toviewcustlist", method = RequestMethod.GET)
    public String toViewCustlist(HttpServletRequest request) {
        request.setAttribute("customerList", customerDao.getAllCustomers());
        return "viewcustomerlist";
    }

    @RequestMapping(path = "totransiday", method = RequestMethod.GET)
    public String toTransitionDay(HttpServletRequest request) {
        Date defaultTransitionDate = fundPriceHistoryDao.findMaxDate();
        if (defaultTransitionDate != null) {
            request.setAttribute("defaultTransitionDate",
                    df.format(new Date(defaultTransitionDate.getTime() + 86400000)));
        }

        List<Fund> fundList = fundDao.findAllFunds();
        for (Fund fund : fundList) {
            fund.setCurrentPrice(fundPriceHistoryDao.findCurPriceByFundId(fund.getFundId()));
        }

        request.setAttribute("fundList", fundList);
        return "transition-day";
    }

    @RequestMapping(path = "transit", method = RequestMethod.GET)
    public String transit(HttpServletRequest request) {
        return toTransitionDay(request);
    }

    @RequestMapping(path = "transit", method = RequestMethod.POST)
    public String transit(@RequestParam("fundId") Long[] fundIds, @RequestParam("date") String strDate,
            @RequestParam("price") String[] prices, HttpServletRequest request) {
        List<String> errorMsgs = new ArrayList<>();
        request.setAttribute("errorMsgs", errorMsgs);

        Utils.checkDateFormta(strDate, errorMsgs);
        Utils.checkDoubleInputStr(prices, errorMsgs);
        if (!errorMsgs.isEmpty()) {
            return toTransitionDay(request);
        }

        try {
            Date prevExecuteDate = fundPriceHistoryDao.findMaxDate();
            Date executeDate = df.parse(strDate);
            if (prevExecuteDate != null && executeDate.compareTo(prevExecuteDate) <= 0) {
                errorMsgs.add("Transition day cannot be before or same as the last transition day");
                return toTransitionDay(request);
            }

            dealCashTransaction(executeDate);
            dealFundTransaction(fundIds, prices, executeDate);

        } catch (ParseException e) {
            e.printStackTrace();
        }

        if (errorMsgs.isEmpty()) {
            request.setAttribute("message", "Transaction Complete!");
        }

        return toTransitionDay(request);
    }

    private void dealFundTransaction(Long[] fundIds, String[] prices, Date executeDate) {
        for (int i = 0; i < fundIds.length; i++) {
            Long fundId = fundIds[i];
            FundPriceHistory fundPriceHistory = new FundPriceHistory();
            if (StringUtils.isEmpty(prices[i])) {
                continue;
            }
            Double price = Double.parseDouble(prices[i]);

            fundPriceHistory.setId(new FundPriceHistoryPK(fundIds[i], executeDate));
            fundPriceHistory.setPrice((long) (price * 100));
            fundPriceHistoryDao.save(fundPriceHistory);
            for (Transaction trans : transactionDao.findPendingFundTrans(fundId, executeDate)) {
                Customer customer = customerDao.find(trans.getCustomerId());
                Position position = null;
                if (trans.getFund() != null) {
                    position = positionDao.find(new PositionPK(trans.getCustomerId(), trans.getFund().getFundId()));
                    if (position == null) {
                        position = new Position();
                        position.setId(new PositionPK(trans.getCustomerId(), trans.getFund().getFundId()));
                        positionDao.save(position);
                    }
                }

                if (trans.getTransactionType() == TransactionType.BUY) {
                    long shares = (long) (trans.getPresentAmount() / price * 1000);
                    position.setShares(position.getShares() + shares);
                    customer.setCash(customer.getCash() - trans.getAmount());
                    trans.setShares(shares);
                    trans.setSharePrice((long) (price * 100));
                }

                if (trans.getTransactionType() == TransactionType.SELL) {
                    long amount = (long) (price * trans.getPresentShares() * 100);
                    position.setShares(position.getShares() - trans.getShares());
                    customer.setCash(customer.getCash() + amount);
                    trans.setSharePrice((long) (price * 100));
                    trans.setAmount(amount);
                }

                trans.setExecuteDate(executeDate);
                trans.setStatus(TransactionStatus.COMPLETED);
            }
        }
    }

    private void dealCashTransaction(Date executeDate) {
        for (Transaction trans : tranDao.findPendingCashTrans(executeDate)) {
            Customer customer = customerDao.find(trans.getCustomerId());
            if (trans.getTransactionType() == TransactionType.DEPOSIT) {
                customer.setCash(customer.getCash() + trans.getAmount());
            }

            if (trans.getTransactionType() == TransactionType.REQUEST_CHECK) {
                customer.setCash(customer.getCash() - trans.getAmount());
            }

            trans.setExecuteDate(executeDate);
            trans.setStatus(TransactionStatus.COMPLETED);
        }
    }

    @RequestMapping(path = "createEmployee", method = RequestMethod.GET)
    public synchronized String createEmployee() {
        return toCreateEmployee();
    }

    @RequestMapping(path = "createEmployee", method = RequestMethod.POST)
    @Transactional(propagation = Propagation.SUPPORTS)
    public synchronized String createEmployee(@RequestParam("userName") String userName,
            @RequestParam("firstName") String firstName, @RequestParam("lastName") String lastName,
            HttpServletRequest request) {

        List<String> errorMsgs = new ArrayList<>();
        request.setAttribute("errorMsgs", errorMsgs);

        Utils.checkRequiredField(userName, "User Name", errorMsgs);
        Utils.checkMailFormat(userName, errorMsgs);

        Utils.checkRequiredField(firstName, "First Name", errorMsgs);
        Utils.checkRequiredField(lastName, "Last Name", errorMsgs);

        if (employeeDao.findByColumn("username", userName) != null
                || customerDao.findByColumn("username", userName) != null) {
            errorMsgs.add("User Name exists!");
        }

        if (!errorMsgs.isEmpty()) {
            return "create-employee";
        }

        String password = Utils.randomPassword(10);

        Employee emp = new Employee();
        emp.setUsername(userName);
        emp.setFirstname(firstName);
        emp.setLastname(lastName);
        emp.setPassword(Utils.md5(password));

        employeeDao.save(emp);
        mailService.sendMail("New Employee Password", userName, password);
        request.setAttribute("message", "Success!");

        return "create-employee";
    }

    @RequestMapping(path = "createFund", method = RequestMethod.GET)
    public String createFund() {
        return toCreateFund();
    }

    @RequestMapping(path = "createFund", method = RequestMethod.POST)
    public synchronized String createFund(@RequestParam("name") String fundName, @RequestParam("symbol") String symbol,
            HttpServletRequest request) {
        List<String> errorMsgs = new ArrayList<>();
        request.setAttribute("errorMsgs", errorMsgs);

        Utils.checkRequiredField(fundName, "Fund Name", errorMsgs);
        Utils.checkRequiredField(symbol, "Fund Ticker", errorMsgs);
        if (symbol != null && symbol.length() > 5) {
            errorMsgs.add("The length of the fund ticker should not be greater than 5 characters");
        }

        if (!errorMsgs.isEmpty()) {
            return "create-fund";
        }

        if (fundDao.findByColumn("name", fundName) != null) {
            errorMsgs.add("Fund Name exists!");
        }

        if (fundDao.findByColumn("symbol", symbol) != null) {
            errorMsgs.add("Fund Ticker exists!");
        }

        if (errorMsgs.isEmpty()) {
            Fund fund = new Fund();
            fund.setName(fundName);
            fund.setSymbol(symbol);

            fundDao.save(fund);

            request.setAttribute("message", "Success!");
        }

        return "create-fund";

    }

    @RequestMapping(path = "depositCheck", method = RequestMethod.GET)
    public String depositCheck(HttpServletRequest request) {
        request.setAttribute("tabName", "deposit");
        return "viewcustomer";
    }

    @RequestMapping(path = "depositCheck", method = RequestMethod.POST)
    public String depositCheck(@RequestParam("customerId") Long customerId,
            @RequestParam("depositamount") String depositAmount, HttpServletRequest request) {
        List<String> errorMsgs = new ArrayList<>();
        request.setAttribute("depositErrorMsgs", errorMsgs);

        Utils.checkDoubleInputStr(depositAmount, "Deposit Amount", errorMsgs);
        if (!errorMsgs.isEmpty()) {
            return toViewCust("deposit", customerId, request);
        }
        Double val = Double.valueOf(depositAmount);
        if (val > 100000) {
            errorMsgs.add("Amount deposied should be less than 100,000");
        }
        if(!val.toString().matches("^[-|+]?\\d*([.]\\d{0,2})?$")) {
        	errorMsgs.add("Amount deposied should be at most two decimal points");
        }
        if (!errorMsgs.isEmpty()) {
            return toViewCust("deposit", customerId, request);
        }

        Long longDepositAmount = (long) (Double.valueOf(depositAmount) * 100);

        Transaction tran = new Transaction();
        tran.setCustomerId(customerId);
        tran.setOrderDate(new Date());
        tran.setStatus(TransactionStatus.PENDING);
        tran.setTransactionType(TransactionType.DEPOSIT);
        tran.setAmount(longDepositAmount);

        tranDao.save(tran);
        request.setAttribute("depositMessage", "Deposit check complete!");
        return toViewCust("deposit", customerId, request);
    }

    @RequestMapping(path = "createCustomer", method = RequestMethod.GET)
    public synchronized String createCustomer() {
        return toCreateCust();
    }

    @RequestMapping(path = "createCustomer", method = RequestMethod.POST)
    public synchronized String createCustomer(@RequestParam("userName") String userName,
            @RequestParam("firstName") String firstName, @RequestParam("lastName") String lastName,
            @RequestParam("Addr1") String addr1, @RequestParam("Addr2") String addr2,
            @RequestParam("state") String state, @RequestParam("city") String city, @RequestParam("zip") String zip,
            HttpServletRequest request) {

        List<String> errorMsgs = new ArrayList<>();
        request.setAttribute("errorMsgs", errorMsgs);

        Utils.checkRequiredField(userName, "User Name", errorMsgs);
        Utils.checkMailFormat(userName, errorMsgs);

        Utils.checkRequiredField(firstName, "First Name", errorMsgs);
        Utils.checkRequiredField(lastName, "Last Name", errorMsgs);
        Utils.checkRequiredField(addr1, "Address Line 1", errorMsgs);
        Utils.checkRequiredField(state, "state", errorMsgs);
        Utils.checkRequiredField(city, "city", errorMsgs);
        Utils.checkRequiredField(zip, "zip", errorMsgs);

        if (employeeDao.findByColumn("username", userName) != null
                || customerDao.findByColumn("username", userName) != null) {
            errorMsgs.add("User Name exists!");
        }

        if (!errorMsgs.isEmpty()) {
            return "create-customer";
        }

        String password = Utils.randomPassword(10);

        Customer customer = new Customer();
        customer.setUsername(userName);
        customer.setFirstname(firstName);
        customer.setLastname(lastName);
        customer.setPassword(Utils.md5(password));
        customer.setAddrLine1(addr1);
        customer.setAddrLine2(addr2);
        customer.setState(state);
        customer.setCity(city);
        customer.setZip(zip);

        customerDao.save(customer);
        mailService.sendMail("New Customer Password", userName, password);
        request.setAttribute("message", "Create Customer Success!");
        return "create-customer";
    }

    @RequestMapping(path = "resetCustPassword", method = RequestMethod.GET)
    public String resetCustPassword(HttpServletRequest request) {
        request.setAttribute("tabName", "resetpass");
        return "viewcustomer";
    }

    @RequestMapping(path = "resetCustPassword", method = RequestMethod.POST)
    public String resetCustPassword(@RequestParam("customerId") String customerIdStr, HttpServletRequest request) {
        Long customerId = Long.valueOf(customerIdStr);

        User user = customerDao.find(customerId);
        String newPassword = Utils.randomPassword(10);

        user.setPassword(Utils.md5(newPassword));

        mailService.sendMail("New Customer Password", user.getUsername(), newPassword);
        request.setAttribute("message", "Reset Customer Password Success!");
        request.setAttribute("tabName", "resetpass");
        return toViewCust("resetpass", customerId, request);
    }

    @RequestMapping(path = "viewCustomer", method = RequestMethod.GET)
    public String viewCustomer(HttpServletRequest request) {
        return toViewCustlist(request);
    }

    @RequestMapping(path = "viewCustomer", method = RequestMethod.POST)
    public String viewCustomer(@RequestParam("customerId") String customerIdStr, HttpServletRequest request) {
        Long customerId = Long.valueOf(customerIdStr);
        if (customerDao.find(customerId) == null){
            return "error";
        }
        request.setAttribute("customer", customerDao.find(customerId));
        return "viewcustomer";
    }

    @RequestMapping(path = "researchCustomer", method = RequestMethod.GET)
    public String researchCustomer(HttpServletRequest request) {
        return toViewCustlist(request);
    }

    @RequestMapping(path = "researchCustomer", method = RequestMethod.POST)
    public String researchCustomer(@RequestParam("searchBy") String option, @RequestParam("value") String value,
            HttpServletRequest request) {
        request.setAttribute("customerList", customerDao.fuzzySearchByColumn(option, value));
        return "viewcustomerlist";
    }

    @RequestMapping(path = "tochgpwd", method = RequestMethod.GET)
    public String toChangePassword() {
        return "changepassword";
    }

    @RequestMapping(path = "changepassword", method = RequestMethod.GET)
    public String changePassword() {
        return toChangePassword();
    }

    @RequestMapping(path = "changepassword", method = RequestMethod.POST)
    public String changePassword(@RequestParam("oldPassword") String oldPassword,
            @RequestParam("newPassword") String newPassword, @RequestParam("confirmPassword") String confirmPassword,
            HttpServletRequest request) {
        List<String> errorMsgs = new ArrayList<>();
        request.setAttribute("errorMsgs", errorMsgs);

        User user = (User) request.getSession().getAttribute("user");
        Utils.changePasswordCheck(oldPassword, user.getPassword(), newPassword, confirmPassword, errorMsgs);

        if (!errorMsgs.isEmpty()) {
            return "changepassword";
        }

        user.setPassword(Utils.md5(newPassword));

        employeeDao.update(user);
        request.setAttribute("message", "Change password success!");
        return "changepassword";

    }
}