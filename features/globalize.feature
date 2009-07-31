Feature: Globalize 2
  In order to take advantage of the many languages I speak
  As an admin
  I want to be able to globalize my site

  Background:
    Given I am logged in as an admin

  Scenario: Changing locale
    Given a page "Cool Page" exists translated to "Pagina cool"
      And I am on the index page
     When I follow "RO"
     Then I should see "Pagina cool"
     When I follow "EN"
     Then I should see "Cool Page"
     
  Scenario: Translating a page
    Given a page "Cool Page" exists
      And I am on the index page
     When I follow "Cool Page"
      And I follow "RO"
      And I fill in "Page Title" with "Pagina cool"
      And I press "Save Changes"
     Then I should be on the index page
      And I should see "Pagina cool"
     When I follow "EN"
     Then I should see "Cool Page"

  Scenario: Deleting a translation
    Given a page "Cool Page" exists translated to "Pagina cool"
      And I am on the index page
     When I follow "Cool Page"
      And I follow "RO"
      And I check "Delete RO translation"
      And I press "Save Changes"
     Then I should be on the index page
      And I should not see "Pagina cool"
     When I follow "EN"
     Then I should see "Cool Page"