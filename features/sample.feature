#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Feature: Sample
    Background:
        Given I have deployed the business network definition ..
        And I have added the following participants of type org.bank.Customer
            | customerId      | firstName | lastName |
            | alice@email.com | Alice     | A        |
            | bob@email.com   | Bob       | B        |
        And I have added the following assets of type org.bank.Account
            | accountId | owner           | balance |
            | 1         | alice@email.com | 10      |
            | 2         | bob@email.com   | 20      |
        And I have issued the participant org.bank.Customer#alice@email.com with the identity alice1
        And I have issued the participant org.bank.Customer#bob@email.com with the identity bob1

    # Scenario: Alice can only read her own account
    #     When I use the identity alice1
    #     Then I should have the following assets of type org.bank.Account
    #         | accountId | owner           | balance |
    #         | 1         | alice@email.com | 10      |
    #     And I should not have the following assets of type org.bank.Account
    #         | accountId | owner         | balance |
    #         | 2         | bob@email.com | 20      |

    # Scenario: Bob can only read his own account
    #     When I use the identity bob1
    #     Then I should have the following assets of type org.bank.Account
    #         | accountId | owner           | balance |
    #         | 2         | bob@email.com | 20      |
    #     And I should not have the following assets of type org.bank.Account
    #         | accountId | owner         | balance |
    #         | 1         | alice@email.com | 10      |
    # # -- AccountTransfer

    Scenario: Alice can submit AccountTransfer from her Account
        When I use the identity alice1
        And I submit the following transaction of type org.bank.AccountTransfer
            | from | to | amount |
            | 1    | 2  | 5      |
        And I should have the following assets of type org.bank.Account
            | accountId | owner           | balance |
            | 1         | alice@email.com | 5       |
        And I use the identity bob1
        Then I should have the following assets of type org.bank.Account
            | accountId | owner         | balance |
            | 2         | bob@email.com | 25      |

    Scenario: Alice should not be able to create AccountTransfer from Bob's account
        When I use the identity alice1
        And I submit the following transaction of type org.bank.AccountTransfer
            | from | to | amount |
            | 2    | 1  | 5      |
        Then I should get an error matching /AccessException: Participant 'org.bank.Customer#alice@email.com' does not have 'CREATE' access to resource/
    
    Scenario: Issueing AccountTransfer transaction should emit a "TransferCompleted" event
        When I use the identity alice1
        And I submit the following transaction of type org.bank.AccountTransfer
            | from | to | amount |
            | 1    | 2  | 5      |
        Then I should have received the following event of type org.bank.TransferCompleted
            | amount |
            | 5      |

    Scenario: Customer should not be able to create AccountTransfer with negative amount
        When I use the identity alice1
        And I submit the following transaction of type org.bank.AccountTransfer
            | from | to | amount |
            | 1    | 2  | -5      |
        Then I should get an error matching /Value is outside lower bound/
    # Background:
    #     Given I have deployed the business network definition ..
    #     And I have added the following participants of type org.bank.SampleParticipant
    #         | participantId   | firstName | lastName |
    #         | alice@email.com | Alice     | A        |
    #         | bob@email.com   | Bob       | B        |
    #     And I have added the following assets of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 1       | alice@email.com | 10    |
    #         | 2       | bob@email.com   | 20    |
    #     And I have issued the participant org.bank.SampleParticipant#alice@email.com with the identity alice1
    #     And I have issued the participant org.bank.SampleParticipant#bob@email.com with the identity bob1

    # Scenario: Alice can read all of the assets
    #     When I use the identity alice1
    #     Then I should have the following assets of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 1       | alice@email.com | 10    |
    #         | 2       | bob@email.com   | 20    |

    # Scenario: Bob can read all of the assets
    #     When I use the identity alice1
    #     Then I should have the following assets of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 1       | alice@email.com | 10    |
    #         | 2       | bob@email.com   | 20    |

    # Scenario: Alice can add assets that she owns
    #     When I use the identity alice1
    #     And I add the following asset of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 3       | alice@email.com | 30    |
    #     Then I should have the following assets of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 3       | alice@email.com | 30    |

    # Scenario: Alice cannot add assets that Bob owns
    #     When I use the identity alice1
    #     And I add the following asset of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 3       | bob@email.com   | 30    |
    #     Then I should get an error matching /does not have .* access to resource/

    # Scenario: Bob can add assets that he owns
    #     When I use the identity bob1
    #     And I add the following asset of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 4       | bob@email.com   | 40    |
    #     Then I should have the following assets of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 4       | bob@email.com   | 40    |

    # Scenario: Bob cannot add assets that Alice owns
    #     When I use the identity bob1
    #     And I add the following asset of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 4       | alice@email.com | 40    |
    #     Then I should get an error matching /does not have .* access to resource/

    # Scenario: Alice can update her assets
    #     When I use the identity alice1
    #     And I update the following asset of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 1       | alice@email.com | 50    |
    #     Then I should have the following assets of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 1       | alice@email.com | 50    |

    # Scenario: Alice cannot update Bob's assets
    #     When I use the identity alice1
    #     And I update the following asset of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 2       | bob@email.com   | 50    |
    #     Then I should get an error matching /does not have .* access to resource/

    # Scenario: Bob can update his assets
    #     When I use the identity bob1
    #     And I update the following asset of type org.bank.SampleAsset
    #         | assetId | owner         | value |
    #         | 2       | bob@email.com | 60    |
    #     Then I should have the following assets of type org.bank.SampleAsset
    #         | assetId | owner         | value |
    #         | 2       | bob@email.com | 60    |

    # Scenario: Bob cannot update Alice's assets
    #     When I use the identity bob1
    #     And I update the following asset of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 1       | alice@email.com | 60    |
    #     Then I should get an error matching /does not have .* access to resource/

    # Scenario: Alice can remove her assets
    #     When I use the identity alice1
    #     And I remove the following asset of type org.bank.SampleAsset
    #         | assetId |
    #         | 1       |
    #     Then I should not have the following assets of type org.bank.SampleAsset
    #         | assetId |
    #         | 1       |

    # Scenario: Alice cannot remove Bob's assets
    #     When I use the identity alice1
    #     And I remove the following asset of type org.bank.SampleAsset
    #         | assetId |
    #         | 2       |
    #     Then I should get an error matching /does not have .* access to resource/

    # Scenario: Bob can remove his assets
    #     When I use the identity bob1
    #     And I remove the following asset of type org.bank.SampleAsset
    #         | assetId |
    #         | 2       |
    #     Then I should not have the following assets of type org.bank.SampleAsset
    #         | assetId |
    #         | 2       |

    # Scenario: Bob cannot remove Alice's assets
    #     When I use the identity bob1
    #     And I remove the following asset of type org.bank.SampleAsset
    #         | assetId |
    #         | 1       |
    #     Then I should get an error matching /does not have .* access to resource/

    # Scenario: Alice can submit a transaction for her assets
    #     When I use the identity alice1
    #     And I submit the following transaction of type org.bank.SampleTransaction
    #         | asset | newValue |
    #         | 1     | 50       |
    #     Then I should have the following assets of type org.bank.SampleAsset
    #         | assetId | owner           | value |
    #         | 1       | alice@email.com | 50    |
    #     And I should have received the following event of type org.bank.SampleEvent
    #         | asset   | oldValue | newValue |
    #         | 1       | 10       | 50       |

    # Scenario: Alice cannot submit a transaction for Bob's assets
    #     When I use the identity alice1
    #     And I submit the following transaction of type org.bank.SampleTransaction
    #         | asset | newValue |
    #         | 2     | 50       |
    #     Then I should get an error matching /does not have .* access to resource/

    # Scenario: Bob can submit a transaction for his assets
    #     When I use the identity bob1
    #     And I submit the following transaction of type org.bank.SampleTransaction
    #         | asset | newValue |
    #         | 2     | 60       |
    #     Then I should have the following assets of type org.bank.SampleAsset
    #         | assetId | owner         | value |
    #         | 2       | bob@email.com | 60    |
    #     And I should have received the following event of type org.bank.SampleEvent
    #         | asset   | oldValue | newValue |
    #         | 2       | 20       | 60       |

    # Scenario: Bob cannot submit a transaction for Alice's assets
    #     When I use the identity bob1
    #     And I submit the following transaction of type org.bank.SampleTransaction
    #         | asset | newValue |
    #         | 1     | 60       |
    #     Then I should get an error matching /does not have .* access to resource/
