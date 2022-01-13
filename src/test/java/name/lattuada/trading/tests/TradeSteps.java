package name.lattuada.trading.tests;

import io.cucumber.java.en.And;
import io.cucumber.java.en.Given;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import name.lattuada.trading.model.EOrderType;
import name.lattuada.trading.model.dto.OrderDTO;
import name.lattuada.trading.model.dto.SecurityDTO;
import name.lattuada.trading.model.dto.TradeDTO;
import name.lattuada.trading.model.dto.UserDTO;
import org.apache.commons.lang3.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.client.HttpClientErrorException;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class TradeSteps {

    private static final Logger logger = LoggerFactory.getLogger(CucumberTest.class);
    private final RestUtility restUtility;
    private final Map<String, SecurityDTO> securityMap;
    private final Map<String, UserDTO> userMap;
    private OrderDTO buyOrder;
    private OrderDTO sellOrder;

    boolean badrequest;

    TradeSteps() {
        restUtility = new RestUtility();
        securityMap = new HashMap<>();
        userMap = new HashMap<>();
    }

    @Given("one security {string} and two users {string} and {string} exist")
    public void oneSecurityAndTwoUsers(String securityName, String userName1, String userName2) {
        logger.trace("Got securityName = \"{}\"; username1 = \"{}\"; username2 = \"{}\"",
                securityName, userName1, userName2);
        createSecurity(securityName);
        createUser(userName1);
        createUser(userName2);
        badrequest = false;
    }

    @Given("two securities {string} and {string} and two users {string} and {string} exist")
    public void twoSecuritiesAndTwoUsers(String securityName1, String securityName2, String userName1, String userName2) {
        logger.trace("Got securityName1 = \"{}\"; securityName2 = \"{}\"; username1 = \"{}\"; username2 = \"{}\"",
                securityName1, securityName2, userName1, userName2);
        createSecurity(securityName1);
        createSecurity(securityName2);
        createUser(userName1);
        createUser(userName2);
        badrequest = false;
    }

    @Given("one security {string} and three users {string}, {string} and {string} exist")
    public void oneSecurityAndThreeUsersExist(String securityName, String userName1, String userName2, String userName3) {
        logger.trace("Got securityName = \"{}\"; username1 = \"{}\"; username2 = \"{}\"; username3 = \"{}\"",
                securityName, userName1, userName2, userName3);
        createSecurity(securityName);
        createUser(userName1);
        createUser(userName2);
        createUser(userName3);
        badrequest = false;
    }

    @When("user {string} puts a {string} order for security {string} with a price of {double} and quantity of {long}")
    @And("user {string} puts a {string} order for security {string} with a price of {double} and a quantity of {long}")
    public void userPutAnOrder(String userName, String orderType, String securityName, Double price, Long quantity) {
        logger.trace("Got username = \"{}\"; orderType = \"{}\"; securityName = \"{}\"; price = \"{}\"; quantity = \"{}\"",
                userName, EOrderType.valueOf(orderType.toUpperCase(Locale.ROOT)), securityName, price, quantity);
        assertTrue(String.format("Unknown user \"%s\"", userName),
                userMap.containsKey(userName));
        assertTrue(String.format("Unknown security \"%s\"", securityName),
                securityMap.containsKey(securityName));
        createOrder(userName,
                EOrderType.valueOf(orderType.toUpperCase(Locale.ROOT)),
                securityName,
                price,
                quantity);
    }

    @Then("a trade occurs with the price of {double} and quantity of {long}")
    public void aTradeOccursWithThePriceOfAndQuantityOf(Double price, Long quantity) {
        logger.trace("Got price = \"{}\"; quantity = \"{}\"",
                price, quantity);
        TradeDTO trade = restUtility.get("api/trades/orderBuyId/" + buyOrder.getId().toString()
                        + "/orderSellId/" + sellOrder.getId().toString(),
                TradeDTO.class);
        assertEquals("Price not expected", price, trade.getPrice());
        assertEquals("Quantity not expected", quantity, trade.getQuantity());
    }

    @Then("no trades occur")
    public void noTradesOccur() {
        assertThatThrownBy(() -> restUtility.get("api/trades/orderBuyId/" + buyOrder.getId().toString()
                        + "/orderSellId/" + sellOrder.getId().toString(),
                TradeDTO.class)).isInstanceOf(HttpClientErrorException.NotFound.class);
    }

    @Then("bad request")
    public void badRequest() {
        assertEquals("Bad request not generated", badrequest, true);
    }

    private void createUser(String userName) {
        UserDTO userDTO = new UserDTO();
        userDTO.setUsername(userName);
        userDTO.setPassword(RandomStringUtils.randomAlphanumeric(64));
        UserDTO userReturned = restUtility.post("api/users",
                userDTO,
                UserDTO.class);
        userMap.put(userName, userReturned);
        logger.info("User created: {}", userReturned);
    }

    private void createSecurity(String securityName) {
        SecurityDTO securityDTO = new SecurityDTO();
        securityDTO.setName(securityName);
        SecurityDTO securityReturned = restUtility.post("api/securities",
                securityDTO,
                SecurityDTO.class);
        securityMap.put(securityName, securityReturned);
        logger.info("Security created: {}", securityReturned);
    }

    private void createOrder(String userName,
                             EOrderType orderType,
                             String securityName,
                             Double price,
                             Long quantity) {
        OrderDTO orderDTO = new OrderDTO();
        orderDTO.setUserId(userMap.get(userName).getId());
        orderDTO.setSecurityId(securityMap.get(securityName).getId());
        orderDTO.setType(orderType);
        orderDTO.setPrice(price);
        orderDTO.setQuantity(quantity);

        try {
            switch (orderType) {
                case BUY -> {
                    buyOrder = restUtility.post("api/orders",
                            orderDTO,
                            OrderDTO.class);
                    logger.info("Order created: {}", buyOrder);
                }
                case SELL -> {
                    sellOrder = restUtility.post("api/orders",
                            orderDTO,
                            OrderDTO.class);
                    logger.info("Order created: {}", sellOrder);
                }
            }
        } catch (HttpClientErrorException.BadRequest badRequest) {
            badrequest = true;
        }
    }

}
