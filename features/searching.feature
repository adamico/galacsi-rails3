Feature: search for fiches by multiple criteria
  In order to know if drugs may be taken while breastfeeding
  As a user
  I want to search for fiches by different criteria

  Background:
    Given the following dcis exist
      | name         |
      | lamotrigine  |
      | azathioprine |
      | amoxicilline |
      | tartampionat |
      | castorama    |
      | blablabla    |

  Scenario Outline: guests search dcis by name
    When I go to the homepage
      And I fill in "search[name_like]" with "<pattern>"
      And I press "Rechercher"
    Then I should see "<count_result>"
    Scenarios:
      | pattern | count_result    |
      | ine     | 3 résultats     |
      | lam     | 1 résultat      |
      | tar     | 1 résultat |
      | cas     | 1 résultat |