*** Settings ***
Library         SeleniumLibrary
Library         BuiltIn
Library         String

*** Variables ***
${NO_TODOS_LABEL}           xpath=//p[text()='No Todos']
${ADD_TASK_BUTTON}          xpath=//button[text()='Add Task']
${TASK_TITLE_INPUT}         xpath=//input[@id="title"]
${TASK_STATUS_DROPDOWN}     xpath=//select[@id="type"]
${POPUP_ADD_TASK_BUTTON}    xpath=//button[@type="submit"]
${CANCEL_BUTTON}            xpath=//button[@type="submit" and text()='Add Task']
${TASKS_FILTER}             xpath=//select[@id="status"]

*** Keywords ***
Wait For Element And Click
    [Documentation]     This keyword waits until the specified element is enabled and clickable,
    ...                 then performs a click action.
    ...                 Accepted Arguments:
    ...                 - ${locator}: A locator expression (such as XPath, CSS selector, ID, etc.)
    [Arguments]         ${locator}
    Wait Until Element Is Enabled    ${locator}  timeout=10s
    Click Element   ${locator}

Wait For Element And Clear
    [Documentation]     This keyword waits until the specified element is enabled,
    ...                 then clears any existing text inside it.
    ...                 Accepted Arguments:
    ...                 - ${locator}: A locator expression (such as XPath, CSS selector, ID, etc.)
    [Arguments]         ${locator}
    Wait Until Element Is Enabled    ${locator}  timeout=10s
    Clear Element Text  ${locator}

Wait For Element And Input Text
    [Documentation]     This keyword waits until the specified element is visible and enabled,
    ...                 clears any existing text inside it, and then inputs the provided text.
    ...                 Accepted Arguments:
    ...                 - ${locator}: A locator expression (such as XPath, CSS selector, ID, etc.)
    ...                 - ${text}: The text string to input into the element.
    [Arguments]         ${locator}      ${text}
    Wait For Element And Clear          ${locator}
    Input Text          ${locator}      ${text}

Select Option From Dropdown
    [Documentation]     This keyword waits until the dropdown element is enabled, clicks to open it,
    ...                 then waits until the desired option is enabled, and finally selects the option
    ...                 by clicking on it.
    ...                 Accepted Arguments:
    ...                 - ${dropdown_locator}: The locator for the dropdown element (XPath, CSS, ID, etc.).
    ...                 - ${option}: The locator for the option to select within the dropdown.
    [Arguments]  ${dropdown_locator}     ${option}
    Wait Until Element Is Enabled       ${dropdown_locator}
    Click Element   ${dropdown_locator}
    Wait Until Element Is Enabled       ${option}
    Click Element   ${option}

Open Selected Browser
    [Documentation]     Opens a new browser session with the specified browser type, applying custom options.
    ...                 Initializes browser options, then opens the browser with these options.
    ...                 Accepted Arguments:
    ...                 - ${browser}: The name of the browser to open (e.g., chrome).
    ...                 - ${headless_mode}: Boolean indicating whether to run in headless mode (True/False).
    [Arguments]         ${browser}     ${headless_mode}
    ${options}  Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()   sys, selenium.webdriver
    IF    ${headless_mode} == True
        Call method     ${options}      add_argument        --headless
    END
    Call Method     ${options}      add_argument        --start-maximized
    Open Browser    browser=${browser}  options=${options}

Open App
    [Documentation]     Opens the application in the specified browser and navigates to the given URL.
    ...                 It initializes the browser with the desired settings, then navigates to the provided URL.
    ...                 Accepted Arguments:
    ...                 - ${browser}: The name of the browser to use (e.g., chrome, firefox).
    ...                 - ${URL}: The URL to open in the browser.
    ...                 - ${headless_mode}: Boolean indicating whether to run in headless mode (True/False).
    [Arguments]         ${browser}     ${url}   ${headless_mode}
    Open Selected Browser   ${browser}  ${headless_mode}
    Go To   ${url}

Open Add Todo Task Popup
    [Documentation]     Waits for the "Add Task" button to be clickable and then clicks it to open the task creation popup.
    Wait For Element And Click      ${ADD_TASK_BUTTON}

Input Title In Todo Task
    [Documentation]     Waits for the task title input field to be ready, then inputs the provided task title.
    ...                 Accepted Arguments:
    ...                 - ${title}: The task title string to input into the field.
    [Arguments]         ${title}
    Wait For Element And Input Text     ${TASK_TITLE_INPUT}     ${title}

Set Task Status
    [Documentation]     Selects the specified status from the task status dropdown.
    ...                 Waits for the dropdown to be enabled and then selects the desired option.
    ...                 Accepted Arguments:
    ...                 - ${status}: The status option to select ("incomplete", "complete").
    [Arguments]         ${status}
    Wait For Element And Click  ${TASK_STATUS_DROPDOWN}
    IF  $status == 'complete'
        Wait For Element And Click  xpath=//select[@id='type']/option[@value="complete"]
    ELSE IF  $status == 'incomplete'
        Wait For Element And Click  xpath=//select[@id='type']/option[@value="incomplete"]
    END

Confirm Add/Update Todo Task
    [Documentation]     Waits for the confirmation button (add/update) in the todo task popup to be clickable,
    ...                 then clicks it to confirm the addition or update of the task.
    Wait For Element And Click      ${POPUP_ADD_TASK_BUTTON}

Add Task To The Todo List
    [Documentation]     Adds a new task to the todo list with the specified title and status.
    ...                 It opens the popup to add a task, inputs the task title, sets its status
    ...                 (e.g., incomplete or complete), confirms the addition,
    ...                 and verifies that a success notification is shown.
    ...                 Accepted Arguments:
    ...                 - ${title}: The title of the task to be added.
    ...                 - ${status}: The status of the task; 'incomplete' or 'complete'.
    [Arguments]     ${title}    ${status}
    Open Add Todo Task Popup
    Input Title In Todo Task    ${title}
    Set Task Status             ${status}
    Confirm Add/Update Todo Task
    Verify notification is shown    Task added successfully

Remove Task From The Todo List
    [Documentation]     Waits for the delete icon associated with the task title to be clickable,
    ...                 then clicks it to remove the task.
    ...                 Accepted Arguments:
    ...                 - ${title}: The title of the task to be removed.
    [Arguments]         ${title}
    Wait For Element And Click      xpath=//p[text()='${title}']//ancestor::div[@class='todoItem_item__fnR7B']//div[@class='todoItem_icon__+DYyU'][1]

Remove All Todo Tasks From The List
    [Documentation]    Removes all tasks from the todo list until none are visible.
    WHILE    ${True}
        ${exists}=      Run Keyword And Return Status
        ...             Element Should Be Visible       xpath=//div[@class='todoItem_icon__+DYyU'][1]
        IF              ${exists} == False             BREAK
    Wait For Element And Click   xpath=//div[@class="todoItem_icon__+DYyU"]
    END
    Verify The Todo List Is Empty

Open Edit Todo Task Popup
    [Documentation]     Waits for the edit icon associated with the task with the specified title
    ...                 and clicks it to open the edit popup.
    ...                 Accepted Arguments:
    ...                 - ${title}: The title of the task to edit.
    [Arguments]         ${title}
    Wait For Element And Click      xpath=//p[text()='${title}']//ancestor::div[@class='todoItem_item__fnR7B']//div[@class='todoItem_icon__+DYyU'][2]

Update a todo task
    [Documentation]     Opens the edit popup for the task with the current title, updates the task's title and status,
    ...                 then confirms the update.
    ...                 Accepted Arguments:
    ...                 - ${current_title}: The current title of the task to update.
    ...                 - ${updated_title}: The new title to set for the task.
    ...                 - ${updated_status}: The new status ('incomplete', 'complete') to set.
    [Arguments]         ${current_title}    ${updated_title}    ${updated_status}
    Open Edit Todo Task Popup   ${current_title}
    Input Title In Todo Task    ${updated_title}
    Set Task Status             ${updated_status}
    Confirm Add/Update Todo Task

Filter out tasks by status
    [Documentation]     Selects the specified status from the filter dropdown to display tasks with that status.
    ...                 Waits for the dropdown option corresponding to the given status
     ...                 Accepted Arguments:
    ...                 - ${status}: The status value to filter by: "all", "complete", or "incomplete".
    [Arguments]         ${status}
    IF  $status == 'all'
        Wait For Element And Click      xpath=//select[@id="status"]/option[@value="all"]
    ELSE IF     $status == 'incomplete'
        Wait For Element And Click      xpath=//select[@id="status"]/option[@value="incomplete"]
    ELSE IF     $status == 'complete'
        Wait For Element And Click      xpath=//select[@id="status"]/option[@value="complete"]
    END

Verify The Todo List Is Empty
    [Documentation]     Waits until the label or element indicating an empty todo list is visible,
    ...                 confirming that all tasks have been removed.
    Wait Until Element Is Visible        ${NO_TODOS_LABEL}

Verify The Todo List Is Not Empty
    [Documentation]     Waits until the label or element indicating the todo list is empty is no longer visible,
    ...                 confirming that there are remaining tasks.
    Wait Until Element Is Not Visible      ${NO_TODOS_LABEL}

Verify a Todo Task Is Visible On The List
    [Documentation]     Waits until the task with the specified title is visible on the list.
    ...                 Accepted Arguments:
    ...                 - ${title}: The title of the task to verify.
    [Arguments]         ${title}
    Wait Until Element Is Visible        xpath=//p[text()='${title}' and contains(@class, 'todoItem')]

Verify a Todo Task Is Not Visible On The List
    [Documentation]     Waits until the task with the specified title is no longer visible on the list.
    ...                 Ensures the task has been removed or hidden.
    ...                 Accepted Arguments:
    ...                 - ${title}: The title of the task to verify is not visible.
    [Arguments]         ${title}
    Wait Until Element Is Not Visible        xpath=//p[text()='${title}' and contains(@class, 'todoItem')]

Verify notification is shown
    [Documentation]     Waits until a notification with the specified content is visible,
    ...                 verifying that the notification message appears.
    ...                 Accepted Arguments:
    ...                 - ${content}: The exact text content expected to be shown in the notification.
    [Arguments]         ${content}
    Wait Until Element Is Visible       xpath=//div[@role='status' and text()='${content}']

Verify The Task Is In Status
    [Documentation]     Verifies that the task with the given title has the specified status
    ...                 by checking the background color style.
    ...                 Accepted Arguments:
    ...                 - ${title}: The title of the task to verify.
    ...                 - ${status}: The expected status ('incomplete' or 'complete').
    [Arguments]         ${title}    ${status}
    IF  $status == 'incomplete'
        Wait Until Element Is Enabled   xpath=//p[text()='${title}']//ancestor::div[@class='todoItem_item__fnR7B']//div[@class="todoItem_svgBox__z1vm6" and @style='background: rgb(222, 223, 225);']
    ELSE IF     $status == 'complete'
        Wait Until Element Is Enabled   xpath=//p[text()='${title}']//ancestor::div[@class='todoItem_item__fnR7B']//div[@class="todoItem_svgBox__z1vm6" and @style='background: rgb(100, 111, 240);']
    END

Mark The Task Status
    [Documentation]     Toggles the status of the task with the given title to the expected status.
    ...                 Accepted Arguments:
    ...                 - ${title}: The title of the task to be toggled.
    ...                 - ${expected_status}: The desired status after toggling ('complete' or 'incomplete').
    [Arguments]         ${title}     ${expected_status}
    IF  $expected_status == 'complete'
        Verify The Task Is In Status    ${title}    incomplete
        Wait For Element And Click      xpath=//p[text()='${title}']//ancestor::div[@class='todoItem_item__fnR7B']//div[@class="todoItem_svgBox__z1vm6"]
        Verify The Task Is In Status    ${title}    complete

    ELSE IF     $expected_status == 'incomplete'
        Verify The Task Is In Status    ${title}    complete
        Wait For Element And Click      xpath=//p[text()='${title}']//ancestor::div[@class='todoItem_item__fnR7B']//div[@class="todoItem_svgBox__z1vm6"]
        Verify The Task Is In Status    ${title}    incomplete
    END

Generate Todo Task Title
    [Arguments]      ${string_length}=10
    ${title}=    Generate Random String      ${string_length}
    RETURN  ${title}

