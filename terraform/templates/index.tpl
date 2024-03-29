<!DOCTYPE html>
<html>
<head>
    <title>My Todo App</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
            font-family: Arial, sans-serif;
        }

        h1 {
            color: #333;
        }

        #taskList {
            padding: 0;
        }

        #taskList li {
            list-style: none;
            background: #ddd;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 3px;
        }

        input[type=text] {
            padding: 10px;
            border: none;
            border-radius: 3px;
            margin-right: 10px;
            margin-bottom: 20px;
        }

        button {
            padding: 10px 20px;
            border: none;
            background: #5cb85c;
            color: white;
            border-radius: 3px;
            cursor: pointer;
        }

        button:hover {
            background: #4cae4c;
        }

        .task-table {
            width: 100%;
            border-collapse: collapse;
        }

        .task-table th,
        .task-table td {
            border: 1px solid #ddd;
            padding: 8px;
        }

        .task-table th {
            padding-top: 12px;
            padding-bottom: 12px;
            text-align: left;
            background-color: #4CAF50;
            color: white;
        }

    </style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script>
        const API_URL ="http://${backend_url}"; // Terraform will replace this

        function fetchTasks() {
            $.getJSON(API_URL + '/todos', function(data) {
                var tasks = data.tasks;
                var output = '<table class="task-table">';
                output += '<tr><th>Id</th><th>Title</th><th>Description</th><th>Is it done?</th></tr>';
                for (var i in tasks) {
                    output += `<tr><td>$${tasks[i].task_id}</td><td>$${tasks[i].title}</td><td>$${tasks[i].description}</td><td>$${tasks[i].is_done}</td></tr>`;
                }
                output += '</table>';
                $('#taskList').html(output);
            });
        }

        function addTask() {
            var title = $('#title').val();
            var description = $('#description').val();
            $.ajax({
                url: API_URL + '/todos',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ 'title': title, 'description': description }),
                success: function(response) {
                    console.log(response);
                    fetchTasks();
                }
            });
        }

        function deleteTask() {
            var taskId = $('#taskId').val();
            $.ajax({
                url: API_URL + '/todos/' + taskId,
                type: 'DELETE',
                success: function(response) {
                    console.log(response);
                    fetchTasks();
                }
            });
        }

        $(document).ready(function() {
            fetchTasks();
            $('#addButton').click(addTask);
            $('#deleteButton').click(deleteTask);
        });
    </script>
</head>
<body>
    <h1>My Todo App</h1>
    <ul id="taskList"></ul>
    <h2>Add Task</h2>
    <input type="text" id="title" placeholder="Title">
    <input type="text" id="description" placeholder="Description">
    <button id="addButton">Add Task</button>
    <h2>Delete Task</h2>
    <input type="text" id="taskId" placeholder="Task Id">
    <button id="deleteButton">Delete Task</button>
</body>
</html>