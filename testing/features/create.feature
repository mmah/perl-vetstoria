Feature: Translate multiple clients and patients to a Vetstoria V2.0 URL
         These tests assume that the Vetstoria module is set to use Smartlink version 2
         protocol but the inclusion of any supplied reason has been suppressed.

  Background:
    Given a usable Vetstoria module

  Scenario: Client/patient information from Vetstoria URL
    When I encode a URL with "<client>" and "<patient_params>"
    Then I should translate that URL back to "<expected_translation>"
    Examples:
      | client  | patient_params                    | expected_translation |
      | 22593   | 48815:37,48815:C302,48815:V199    | 22593,48815          |
      | 8805    | 48835:C302,47154:C303,47154:V196  | 8805,48835,47154     |
      | 8805    | 48835,47154,47154                 | 8805,48835,47154     |

