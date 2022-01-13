Feature: 00 Smoke Tests

  Scenario: Basic trading Buy Sell
    Given one security "WSB" and two users "Diamond" and "Paper" exist
    When user "Diamond" puts a "buy" order for security "WSB" with a price of 101 and quantity of 50
    And user "Paper" puts a "sell" order for security "WSB" with a price of 100 and a quantity of 100
    Then a trade occurs with the price of 100 and quantity of 50

  Scenario: Basic trading Sell Buy
    Given one security "SEC" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "SEC" with a price of 100 and a quantity of 100
    And user "User1" puts a "buy" order for security "SEC" with a price of 101 and quantity of 50
    Then a trade occurs with the price of 100 and quantity of 50

  Scenario: No trades occur
    Given one security "NTR" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "NTR" with a price of 100 and a quantity of 100
    And user "User1" puts a "buy" order for security "NTR" with a price of 99 and quantity of 50
    Then no trades occur

  Scenario: Negative quantity buy
    Given one security "AMZN" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "AMZN" with a price of 100 and a quantity of 100
    And user "User1" puts a "buy" order for security "AMZN" with a price of 99 and quantity of -1
    Then bad request

  Scenario: Negative quantity sell
    Given one security "NTR" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "NTR" with a price of 100 and a quantity of -1
    And user "User1" puts a "buy" order for security "NTR" with a price of 99 and quantity of 100
    Then bad request

  Scenario: Negative price buy
    Given one security "SEC" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "SEC" with a price of 100 and a quantity of 100
    And user "User1" puts a "buy" order for security "SEC" with a price of -1 and quantity of 50
    Then bad request

  Scenario: Negative price sell
    Given one security "TSLA" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "TSLA" with a price of -1 and a quantity of 100
    And user "User1" puts a "buy" order for security "TSLA" with a price of 99 and quantity of 50
    Then bad request

  Scenario: Null quantity buy
    Given one security "WSB" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "WSB" with a price of 100 and a quantity of 100
    And user "User1" puts a "buy" order for security "WSB" with a price of 99 and quantity of 0
    Then bad request

  Scenario: Null quantity sell
    Given one security "GOOGL" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "GOOGL" with a price of 100 and a quantity of 0
    And user "User1" puts a "buy" order for security "GOOGL" with a price of 99 and quantity of 100
    Then bad request

  Scenario: Null price buy
    Given one security "SEC" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "SEC" with a price of 100 and a quantity of 100
    And user "User1" puts a "buy" order for security "SEC" with a price of 0 and quantity of 50
    Then bad request

  Scenario: Null price sell
    Given one security "NTR" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "NTR" with a price of 0 and a quantity of 100
    And user "User1" puts a "buy" order for security "NTR" with a price of 99 and quantity of 50
    Then bad request

  Scenario: Fractional price sell
    Given one security "GOOG" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "GOOG" with a price of 92.5 and a quantity of 100
    And user "User1" puts a "buy" order for security "GOOG" with a price of 99 and quantity of 50
    Then a trade occurs with the price of 92.5 and quantity of 50

  Scenario: Fractional price buy
    Given one security "FB" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "FB" with a price of 100 and a quantity of 100
    And user "User1" puts a "buy" order for security "FB" with a price of 100.5 and quantity of 50
    Then a trade occurs with the price of 100 and quantity of 50

  Scenario: Over demand
    Given one security "AAPL" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "AAPL" with a price of 100 and a quantity of 100
    And user "User1" puts a "buy" order for security "AAPL" with a price of 101 and quantity of 101
    Then a trade occurs with the price of 100 and quantity of 100

  Scenario: Over over demand
    Given one security "NTR" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "NTR" with a price of 100 and a quantity of 100
    And user "User1" puts a "buy" order for security "NTR" with a price of 101 and quantity of 10100
    Then a trade occurs with the price of 100 and quantity of 100

  Scenario: Different securities
    Given two securities "AAPL" and "WSB" and two users "User1" and "User2" exist
    When user "User2" puts a "sell" order for security "WSB" with a price of 100 and a quantity of 50
    And user "User1" puts a "buy" order for security "AAPL" with a price of 101 and quantity of 100
    Then no trades occur

  Scenario: All the apple shares
    Given one security "AAPL" and two users "User1" and "User2" exist
    When user "User2" puts a "buy" order for security "AAPL" with a price of 175 and a quantity of 16334000000
    And user "User1" puts a "sell" order for security "AAPL" with a price of 100 and quantity of 16334000000
    Then a trade occurs with the price of 100 and quantity of 16334000000

  Scenario: Most expensive share
    Given one security "BRK" and two users "User1" and "User2" exist
    When user "User2" puts a "buy" order for security "BRK" with a price of 445000 and a quantity of 50
    And user "User1" puts a "sell" order for security "BRK" with a price of 445000 and quantity of 100
    Then a trade occurs with the price of 445000 and quantity of 50

  Scenario: Three users #1
    Given one security "TSM" and three users "User1", "User2" and "User3" exist
    When user "User1" puts a "buy" order for security "TSM" with a price of 117 and a quantity of 100
    And user "User2" puts a "sell" order for security "TSM" with a price of 113 and quantity of 100
    And user "User3" puts a "sell" order for security "TSM" with a price of 115 and quantity of 100
    Then a trade occurs with the price of 113 and quantity of 100

  Scenario: Three users #2
    Given one security "TSM" and three users "User1", "User2" and "User3" exist
    When user "User1" puts a "buy" order for security "TSM" with a price of 117 and a quantity of 100
    And user "User2" puts a "sell" order for security "TSM" with a price of 115 and quantity of 100
    And user "User3" puts a "sell" order for security "TSM" with a price of 113 and quantity of 100
    Then a trade occurs with the price of 113 and quantity of 100

  Scenario: Three users #3
    Given one security "TSM" and three users "User1", "User2" and "User3" exist
    When user "User1" puts a "sell" order for security "TSM" with a price of 113 and a quantity of 100
    And user "User2" puts a "buy" order for security "TSM" with a price of 115 and quantity of 100
    And user "User3" puts a "buy" order for security "TSM" with a price of 117 and quantity of 100
    Then a trade occurs with the price of 113 and quantity of 100

