Feature: CLI

  Scenario: some test scenario
    When I run `yaml-pathfinder too_short ./yamls/**/*.yaml`
    Then the output should contain "yamls/en.yml:135"
