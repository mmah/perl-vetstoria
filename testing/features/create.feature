Feature: Translate multiple clients and patients to a Vetstoria V2.0 URL
         These tests assume that the Vetstoria module is set to use Smartlink version 2
         protocol but the inclusion of any supplied reason has been suppressed.
         
  Background:
    Given a usable Vetstoria module

  Scenario: Translate an example client/patient information to a Vetstoria URL.  This is a single pet which is repeated due to multiple reminder services.
    When given the client and patient parameters "22593" and ("48815:37","48815:C302","48815:V199")
    Then the encoded url should translate back to "22593" and ("48815")

  Scenario: Translate an example client/patient information to a Vetstoria URL.  This example has multiple pets
    When given the client and patient parameters "8805" and ("48835:C302","47154:C303","47154:V196")
    Then the encoded url should translate back to "8805" and ("48835","47154")

  Scenario: Translate an example client/patient information to a Vetstoria URL.  This example has multiple pets without reason codes
    When given the client and patient parameters "8805" and ("48835","47154","47154")
    Then the encoded url should translate back to "8805" and ("48835","47154")
