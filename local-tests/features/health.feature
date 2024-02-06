Feature: Health
  Health get endpoint

  Scenario: Authorized token can call health
    Given an authorized token with
    And person exists
    When I create uuid '
    Then I get a 201
    Then I get a Healthy

  Scenario: Authorized token can call health
    Given an authorized token with
    And person exists
    When I create uuid '
    Then I get a 201
    Then I get a Healthy