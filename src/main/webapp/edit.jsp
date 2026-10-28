<%@ page import="com.student.model.Student" %>

<%!
    private String esc(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    Student s = (Student) request.getAttribute("student");

    if (s == null) {
        response.sendRedirect(
            request.getContextPath() + "/students");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Edit Student | StudentHub</title>

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 35px 15px;
            background: #f4f7fc;
            color: #1e293b;
            font-family: "Segoe UI", Arial, sans-serif;
        }

        .box {
            max-width: 600px;
            margin: 25px auto;
            padding: 32px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 18px;
            box-shadow: 0 12px 35px #1e3a8a10;
        }

        h1 {
            color: #1d4ed8;
            font-size: 26px;
        }

        p {
            color: #64748b;
            font-size: 14px;
        }

        label {
            display: block;
            margin: 18px 0 8px;
            font-weight: 600;
            font-size: 13px;
        }

        input, select {
            width: 100%;
            padding: 13px;
            border: 1px solid #dbe3ef;
            border-radius: 9px;
            background: white;
            font-size: 14px;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px #dbeafe;
        }

        button, a {
            display: inline-block;
            padding: 12px 17px;
            margin-top: 23px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: white;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
        }

        a { background: #64748b; }

        .id {
            display: inline-block;
            background: #dbeafe;
            color: #1d4ed8;
            padding: 7px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
    </style>
</head>

<body>

<div class="box">

    <span class="id">STUDENT ID: <%= s.getId() %></span>

    <h1>Edit Student Details</h1>
    <p>Update the information and save your changes.</p>

    <form action="<%= request.getContextPath() %>/students"
          method="post">

        <input type="hidden" name="action" value="update">

        <input type="hidden" name="id"
               value="<%= s.getId() %>">

        <label>Full Name</label>
        <input type="text" name="name" maxlength="100"
               value="<%= esc(s.getName()) %>" required>

        <label>Email Address</label>
        <input type="email" name="email" maxlength="100"
               value="<%= esc(s.getEmail()) %>" required>

        <label>Course</label>
        <select name="course" required>

            <option value="MCA"
                <%= "MCA".equals(s.getCourse()) ? "selected" : "" %>>
                MCA
            </option>

            <option value="BCA"
                <%= "BCA".equals(s.getCourse()) ? "selected" : "" %>>
                BCA
            </option>

            <option value="MBA"
                <%= "MBA".equals(s.getCourse()) ? "selected" : "" %>>
                MBA
            </option>

            <option value="B.Tech"
                <%= "B.Tech".equals(s.getCourse()) ? "selected" : "" %>>
                B.Tech
            </option>

        </select>

        <label>Age</label>
        <input type="number" name="age" min="16" max="100"
               value="<%= s.getAge() %>" required>

        <button type="submit">Save Changes</button>

        <a href="<%= request.getContextPath() %>/students">
            Cancel
        </a>

    </form>

</div>

</body>
</html>