Tested on:
- Python 3.13.5
- Robot Framework 7.2.2
- Robot Framework Selenium Library 6.7.1
- Chrome 138.0.7204.50
- Chrome driver https://googlechromelabs.github.io/chrome-for-testing/#stable

Requirements:
- Install Python, Robot Framework, Robot Framework Selenium library
- Internet connection

Add Python, Robot Framework, Chromedriver binaries to the PATH

To run tests in terminal from the main project directory use the command:
robot --outputdir tests/reports -v tests/e2e_tests.robot

To run tests in terminal in headless mode from the main project directory use the command:
robot --outputdir tests/reports -v HEADLESS_MODE:True tests/e2e_tests.robot 

