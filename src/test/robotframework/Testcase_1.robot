*** Settings ***
Documentation
...    Login Test Case.


***Variables***
${Browser}  Chrome
${URL}  https://google.com/
Library    Selenium2Library

*** Test Cases ***
TC_001 Browser Start and Close
	Open Browser  https://google.com    ff
	Close Browser