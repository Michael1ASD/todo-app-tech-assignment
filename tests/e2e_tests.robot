*** Settings ***
Resource           resources.robot
Library            SeleniumLibrary
Test Setup         Open App     chrome     ${URL}   ${HEADLESS_MODE}
Test Teardown      Close browser

*** Variables ***
${URL}              https://wc-react-todo-app.netlify.app/
${HEADLESS_MODE}    False

*** Test Cases ***
Verify User Is Able To Add a Todo Task
    [Documentation]     This test verifies that a user can successfully add a new task to the todo list.
    ...                 It ensures that the task is added correctly, visible in the list,
    ...                 and that the success notification is displayed.
    ...                 The test involves generating a random task title, adding the task,
    ...                 and performing assertions to confirm the expected behavior.
    [Tags]              add_task

    ${task_title}=    Generate Todo Task Title
    Add Task To The Todo List    ${task_title}   incomplete
    Verify The Todo List Is Not Empty
    Verify a Todo Task Is Visible On The List   ${task_title}
    Verify Notification Is Shown   Task added successfully

Verify User Is Able To Remove a Todo Task
    [Documentation]     This test confirms that a user can successfully remove a task from the todo list.
    ...                 It adds a new task with a unique title, verifies its presence, deletes the task,
    ...                 and then checks that the list is empty and that the appropriate success notification
    ...                 is displayed. This ensures the delete functionality works as expected.
    [Tags]              delete_task

    ${task_title}=    Generate Todo Task Title
    Add Task To The Todo List    ${task_title}   complete
    Verify a Todo Task Is Visible On The List   ${task_title}
    Remove Task From The Todo List  ${task_title}
    Verify The Todo List Is Empty
    Verify Notification Is Shown   Todo Deleted Successfully

Verify User Is Able To Update a Todo Task
    [Documentation]     This test verifies that a user can successfully update an existing task in the todo list.
    ...                 It starts by adding a new task with a random title, confirms its presence,
    ...                 updates the task with a new title and status, and checks that a success notification appears.
    ...                 Finally, it verifies that the updated task is correctly displayed in the list,
    ...                 ensuring the update functionality works as intended.
    [Tags]              update_task

    ${task_title}=    Generate Todo Task Title
    ${updated_task_title}=    Generate Todo Task Title
    Add Task To The Todo List    ${task_title}   incomplete
    Verify a Todo Task Is Visible On The List   ${task_title}
    Update a Todo Task  ${task_title}    ${updated_task_title}    complete
    Verify Notification Is Shown   Task Updated successfully
    Verify a Todo Task Is Visible On The List   ${updated_task_title}

Verify User Is Able To Filter Out Todo Tasks By Status
    [Documentation]     This test case verifies that filtering by task status works correctly.
    ...                 It adds two tasks with different completion statuses, applies a filter to show
    ...                 only completed tasks, and then confirms that the completed task is visible while the
    ...                 incomplete task is not. This ensures the filtering functionality correctly displays
    ...                 tasks based on their status.
    [Tags]              filter

    ${task_title_incomplete}=    Generate Todo Task Title
    ${task_title_complete}=    Generate Todo Task Title
    Add Task To The Todo List    ${task_title_incomplete}   incomplete
    Add Task to The Todo List    ${task_title_complete}   complete
    Filter Out Tasks By Status    complete
    Verify a Todo Task Is Visible On The List   ${task_title_complete}
    Verify a Todo Task Is Not Visible On The List   ${task_title_incomplete}

Verify User Is Able To Complete The Todo Task
    [Documentation]     This test case verifies that a user can successfully mark a task as complete in the todo list.
    ...                 It starts by generating a unique task title, adds the task to the list, and verifies its presence.
    ...                 Then, it marks the task as complete, filters the list to show only completed tasks,
    ...                 and confirms that the task appears correctly and is in the completed state.
    ...                 This ensures that updating task status and filtering by completed tasks work as expected.
    [Tags]              update_task

    ${task_title}=    Generate Todo Task Title
    Filter Out Tasks By Status  all
    Add Task To The Todo List    ${task_title}   incomplete
    Verify a Todo Task Is Visible On The List   ${task_title}
    Mark The Task Status   ${task_title}    complete
    Filter Out Tasks By Status  complete
    Verify a Todo Task Is Visible On The List     ${task_title}
    Verify The Task Is In Status    ${task_title}   complete





