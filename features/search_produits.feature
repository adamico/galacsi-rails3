Feature: search for produits by multiple criteria
  In order to know if drugs may be taken while breastfeeding
  As a user
  I want to search for produits by different criteria

  Background:
    Given the following produits exist
      | name         | state      |
      | lamotrigine  | valide     |
      | azathioprine | valide     |
      | amoxicilline | valide     |
      | tartampionat | a_valider  |
      | castorama    | brouillon  |
      | blablabla    | en_attente |

  Scenario Outline: guests search produits by name
    When I go to the homepage
      And I fill in "search[name_like]" with "<pattern>"
      And I press "Rechercher"
    Then I should see "<count_result>"
    Scenarios:
      | pattern | count_result    |
      | ine     | 3 résultats     |
      | lam     | 1 résultat      |
      | tar     | Aucun résultat. |
      | cas     | Aucun résultat. |
