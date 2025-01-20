Feature: Login API

  Scenario: Successful login with valid credentials
    Given I have a valid username and password
    When I send a POST request to "/auth/login"
    Then I should receive a 200 status code