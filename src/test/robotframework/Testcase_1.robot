*** Settings ***
Documentation   Open a browser test case
Library         SeleniumLibrary

*** Variables ***
${TEXT}         Hello world
${URL}          https://www.example.com

*** Test Cases ***
Log Test
    Log To Console    ${TEXT}