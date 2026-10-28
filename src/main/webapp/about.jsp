<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>About Project | StudentHub</title>

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            background: #f4f7fc;
            color: #1e293b;
            font-family: "Segoe UI", Arial, sans-serif;
            padding: 35px 15px;
        }

        .card {
            max-width: 800px;
            margin: 20px auto;
            background: white;
            padding: 35px;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            box-shadow: 0 12px 35px #1e3a8a10;
        }

        h1 { color: #1d4ed8; }

        h2 {
            color: #1e40af;
            margin-top: 28px;
        }

        p, li {
            color: #64748b;
            line-height: 1.8;
        }

        .tag {
            display: inline-block;
            padding: 8px 12px;
            margin: 5px;
            border-radius: 20px;
            background: #dbeafe;
            color: #1d4ed8;
            font-size: 13px;
            font-weight: bold;
        }

        a {
            display: inline-block;
            margin-top: 25px;
            padding: 12px 18px;
            background: #2563eb;
            color: white;
            border-radius: 8px;
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="card">

    <h1>StudentHub</h1>
    <p>Student Record Management System</p>

    <h2>Project Overview</h2>

    <p>
        StudentHub is a Java-based web application developed to manage
        student information through a simple and user-friendly interface.
        It allows users to add, view, search, update and delete student
        records.
    </p>

    <h2>Project Objectives</h2>

    <ul>
        <li>Manage student details efficiently.</li>
        <li>Demonstrate client-server communication.</li>
        <li>Use JSP and Servlets to create dynamic web pages.</li>
        <li>Implement CRUD operations using Java file handling.</li>
    </ul>

    <h2>Technologies Used</h2>

    <span class="tag">Java</span>
    <span class="tag">JSP</span>
    <span class="tag">Servlets</span>
    <span class="tag">HTML</span>
    <span class="tag">CSS</span>
    <span class="tag">Apache Tomcat</span>
    <span class="tag">File Handling</span>

    <h2>Storage Method</h2>

    <p>
        Student records are stored in a local text file. The project
        does not require MySQL or another database server.
    </p>

    <a href="<%= request.getContextPath() %>/students">
        Back to Dashboard
    </a>

</div>

</body>
</html>