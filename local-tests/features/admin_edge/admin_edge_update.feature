Feature: Admin edge
  Admin edge delete endpoint

  Scenario: Authorized service token can delete admin edge
    Given an authorized token with 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.DELETE' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    And ems publish eventing succeeds
    And a node is created with:'{"nodeId": "9b77863e-fbd1-5b2e-bc8b-e18147c1627a"}'
    And person exists with payload '{ "userId":"9b77863e-fbd1-4b2e-bc8b-e18147c1627f"}'
    And admin edge created with uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f', action 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.POST' and payload '{"rolePermId": "9b77863e-fbd1-4b2e-bc8b-e18147c1627a"}'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 200
    And events published with:
      | key             | value                                   |
      | source          | registry@hpoc-local.hpoc-sa.com         |
      | specversion     | 1.0                                     |
      | type            | hpoc.core.relation.v1.RegistryNodeEvent |
      | datacontenttype | application/x-protobuf                  |

  Scenario: Authorized token can delete admin edge between person and node with ems event publish failed
    Given an authorized token with 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.DELETE' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    And ems publish eventing has server error
    And a node is created with:'{"nodeId": "9b77863e-fbd1-5b2e-bc8b-e18147c1627a"}'
    And person exists with payload '{ "userId":"9b77863e-fbd1-4b2e-bc8b-e18147c1627f"}'
    And admin edge created with uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f', action 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.POST' and payload '{"rolePermId": "9b77863e-fbd1-4b2e-bc8b-e18147c1627a"}'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 200
    And events published with:
      | key             | value                                   |
      | source          | registry@hpoc-local.hpoc-sa.com         |
      | specversion     | 1.0                                     |
      | type            | hpoc.core.relation.v1.RegistryNodeEvent |
      | datacontenttype | application/x-protobuf                  |

  Scenario: Authorized token can delete admin edge with feature flag oc-rel-registry_release_ems-person-event is disabled for event publish to ems
    Given an authorized token with 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.DELETE' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    And I have FF of '50ae9c55-8ae9-47f1-8072-5a247d934947'
    And a node is created with:'{"nodeId": "9b77863e-fbd1-5b2e-bc8b-e18147c1627a"}'
    And person exists with payload '{ "userId":"9b77863e-fbd1-4b2e-bc8b-e18147c1627f"}'
    And admin edge created with uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f', action 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.POST' and payload '{"rolePermId": "9b77863e-fbd1-4b2e-bc8b-e18147c1627a"}'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 200

  Scenario: Delete admin edge succeed with user token
    Given an authorized token with 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.DELETE' in '5c1c2547bf965dee00465a3b' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    And ems publish eventing succeeds
    And a node is created with:'{"nodeId": "9b77863e-fbd1-5b2e-bc8b-e18147c1627a"}'
    And person exists with payload '{ "userId":"9b77863e-fbd1-4b2e-bc8b-e18147c1627f"}'
    And admin edge created with uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f', action 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.POST' and payload '{"rolePermId": "9b77863e-fbd1-4b2e-bc8b-e18147c1627a"}'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 200
    And events published with:
      | key             | value                                   |
      | source          | registry@hpoc-local.hpoc-sa.com         |
      | specversion     | 1.0                                     |
      | type            | hpoc.core.relation.v1.RegistryNodeEvent |
      | datacontenttype | application/x-protobuf                  |

  Scenario: Delete admin edge succeed with new action code
    Given an authorized token with 'hpoc/core.relation/registry/node/{uuid}/admin/{userId}.DELETE' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    And I have FF of 'new-action-code'
    And a node is created with:'{"nodeId": "9b77863e-fbd1-5b2e-bc8b-e18147c1627a", "action": "hpoc/core.relation/registry/node.POST"}'
    And person exists with payload '{ "userId":"9b77863e-fbd1-4b2e-bc8b-e18147c1627f", "action":"hpoc/core.relation/registry/person.POST"}'
    And admin edge created with uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f', action 'hpoc/core.relation/registry/node/{uuid}/admin/{userId}.POST' and payload '{"rolePermId": "9b77863e-fbd1-4b2e-bc8b-e18147c1627a"}'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 200
    And events published with:
      | key             | value                                   |
      | source          | registry@hpoc-local.hpoc-sa.com         |
      | specversion     | 1.0                                     |
      | type            | hpoc.core.relation.v1.RegistryNodeEvent |
      | datacontenttype | application/x-protobuf                  |

  Scenario: Delete admin edge succeed with new action code and user token
    Given an authorized token with 'hpoc/core.relation/registry/node/{uuid}/admin/{userId}.DELETE' in '5c1c2547bf965dee00465a3b' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    And I have FF of 'new-action-code'
    And a node is created with:'{"nodeId": "9b77863e-fbd1-5b2e-bc8b-e18147c1627a", "action": "hpoc/core.relation/registry/node.POST"}'
    And person exists with payload '{ "userId":"9b77863e-fbd1-4b2e-bc8b-e18147c1627f", "action":"hpoc/core.relation/registry/person.POST"}'
    And admin edge created with uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f', action 'hpoc/core.relation/registry/node/{uuid}/admin/{userId}.POST' and payload '{"rolePermId": "9b77863e-fbd1-4b2e-bc8b-e18147c1627a"}'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 200
    And events published with:
      | key             | value                                   |
      | source          | registry@hpoc-local.hpoc-sa.com         |
      | specversion     | 1.0                                     |
      | type            | hpoc.core.relation.v1.RegistryNodeEvent |
      | datacontenttype | application/x-protobuf                  |

  Scenario: Authorized token can't delete admin edge with invalid node ID
    Given an authorized token with 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.DELETE' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    When I delete admin edge between uuid '!invalid' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 400

  Scenario: Authorized token can't delete admin edge with invalid user ID
    Given an authorized token with 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.DELETE' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '!invalid'
    Then I get a 400

  Scenario: Expired token can't delete a admin edge
    Given an expired token
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 401

  Scenario: Authorization in header but token does not have access to endpoint
    Given an authorized token with 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.GET' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 403

  Scenario: Unauthorized token can't delete admin edge
    Given an unauthorized token for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 403

  Scenario: Delete a admin edge with new action code with feature behind oc-rel-registry_release_ocrs-558-use-new-action-code disabled
    Given an authorized token with 'hpoc/core.relation/registry/node/{uuid}/admin/{userId}.DELETE' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    When I create a admin edge with uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f' and payload '{"rolePermId": "9b77863e-fbd1-4b2e-bc8b-e18147c1627a"}'
    Then I get a 403

  Scenario: Authorized token can't delete admin edge for non existing admin edge
    Given an authorized token with 'hpoc/core.relation/registry/ocrel-registry/node/{nodeId}/admin/{adminId}.DELETE' for 'registry-relationship.api.non-prod-uw2.hponecloud.io'
    When I delete admin edge between uuid '9b77863e-fbd1-5b2e-bc8b-e18147c1627a' and userId '9b77863e-fbd1-4b2e-bc8b-e18147c1627f'
    Then I get a 404

