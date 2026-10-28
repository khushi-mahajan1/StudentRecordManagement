<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.student.model.Student" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
    List<Student> students =
        (List<Student>) request.getAttribute("students");

    if (students == null) {
        students = Collections.emptyList();
    }

    String search = request.getParameter("search");
    if (search == null) search = "";

    String msg = request.getParameter("msg");

    int total = students.size();
    int mca = 0, bca = 0, other = 0;

    for (Student st : students) {
        String course = st.getCourse();

        if ("MCA".equalsIgnoreCase(course)) {
            mca++;
        } else if ("BCA".equalsIgnoreCase(course)) {
            bca++;
        } else {
            other++;
        }
    }

    String ctx = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>StudentHub - Student Record Management</title>

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: "Segoe UI", Arial, sans-serif;
    background: #f1f5fb;
    color: #1e293b;
}

.layout {
    display: flex;
    min-height: 100vh;
}

.sidebar {
    width: 230px;
    flex-shrink: 0;
    background: #172554;
    color: white;
    padding: 28px 18px;
}

.logo {
    font-size: 25px;
    font-weight: bold;
    margin-bottom: 35px;
}

.logo span {
    color: #60a5fa;
}

.nav-title {
    color: #94a3b8;
    font-size: 11px;
    letter-spacing: 1px;
    margin: 25px 10px 12px;
}

.nav-link {
    display: block;
    color: #e2e8f0;
    text-decoration: none;
    padding: 13px;
    margin: 5px 0;
    border-radius: 8px;
    font-size: 14px;
}

.nav-link:hover,
.nav-link.active {
    background: #2563eb;
    color: white;
}

.sidebar-footer {
    margin-top: 40px;
    padding-top: 18px;
    border-top: 1px solid #334155;
    color: #cbd5e1;
    font-size: 12px;
    line-height: 1.8;
}

.main {
    flex: 1;
    min-width: 0;
    padding: 30px;
}

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    margin-bottom: 28px;
}

h1 {
    color: #172554;
    margin: 0;
    font-size: 29px;
}

.subtitle {
    color: #64748b;
    font-size: 14px;
    margin-top: 8px;
}

.admin {
    background: white;
    padding: 12px 16px;
    border-radius: 9px;
    border: 1px solid #e2e8f0;
    font-size: 13px;
}

.stats {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 16px;
    margin-bottom: 25px;
}

.stat-card {
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 13px;
    padding: 20px;
    box-shadow: 0 4px 15px #0f172a08;
}

.stat-label {
    color: #64748b;
    font-size: 13px;
    font-weight: 600;
}

.stat-number {
    font-size: 30px;
    font-weight: bold;
    color: #172554;
    margin-top: 18px;
}

.panel {
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 13px;
    padding: 24px;
    margin-bottom: 24px;
    scroll-margin-top: 15px;
}

.panel h2 {
    font-size: 19px;
    color: #172554;
    margin: 0 0 8px;
}

.panel-description {
    font-size: 13px;
    color: #64748b;
    margin: 0 0 22px;
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 18px;
}

label {
    display: block;
    margin-bottom: 8px;
    font-size: 13px;
    font-weight: 600;
}

input,
select {
    width: 100%;
    padding: 12px;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    font-family: inherit;
    font-size: 13px;
    background: white;
}

input:focus,
select:focus {
    outline: none;
    border-color: #2563eb;
    box-shadow: 0 0 0 3px #dbeafe;
}

.btn {
    display: inline-block;
    padding: 11px 15px;
    border: none;
    border-radius: 8px;
    background: #2563eb;
    color: white;
    font-size: 12px;
    font-weight: bold;
    text-decoration: none;
    cursor: pointer;
}

.btn:hover {
    background: #1d4ed8;
}

.btn-gray {
    background: #64748b;
}

.btn-gray:hover {
    background: #475569;
}

.btn-red {
    background: #fee2e2;
    color: #b91c1c;
}

.btn-red:hover {
    background: #fecaca;
}

.btn-small {
    padding: 8px 10px;
}

.form-actions {
    margin-top: 22px;
}

.alert {
    padding: 14px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-size: 13px;
    background: #dcfce7;
    color: #166534;
}

.search-form {
    display: flex;
    gap: 10px;
    max-width: 550px;
    margin-bottom: 22px;
}

.search-form input {
    flex: 1;
}

.table-wrap {
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 680px;
    border-collapse: collapse;
}

th {
    background: #f8fafc;
    color: #64748b;
    text-align: left;
    font-size: 11px;
    padding: 14px 12px;
    border-bottom: 1px solid #e2e8f0;
}

td {
    padding: 14px 12px;
    font-size: 13px;
    border-bottom: 1px solid #edf2f7;
}

tbody tr:hover {
    background: #f8fbff;
}

.badge {
    display: inline-block;
    padding: 6px 10px;
    background: #dbeafe;
    color: #1d4ed8;
    border-radius: 20px;
    font-size: 11px;
    font-weight: bold;
}

.avatar {
    display: inline-grid;
    place-items: center;
    width: 35px;
    height: 35px;
    border-radius: 50%;
    margin-right: 8px;
    background: #dbeafe;
    color: #1d4ed8;
    font-weight: bold;
    vertical-align: middle;
}

.student-name {
    font-weight: 600;
}

.actions {
    display: flex;
    gap: 7px;
    align-items: center;
}

.actions form {
    margin: 0;
}

.empty {
    padding: 30px;
    text-align: center;
    color: #64748b;
}

.footer {
    text-align: center;
    padding: 15px;
    color: #94a3b8;
    font-size: 12px;
}

@media (max-width: 1000px) {
    .stats {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .main {
        padding: 20px;
    }
}

@media (max-width: 650px) {
    .layout {
        display: block;
    }

    .sidebar {
        width: 100%;
    }

    .sidebar-footer {
        display: none;
    }

    .main {
        padding: 14px;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .topbar {
        align-items: flex-start;
        flex-direction: column;
    }

    .panel {
        padding: 17px;
    }
}
</style>
</head>

<body>
<div class="layout">

    <aside class="sidebar">
        <div class="logo">Student<span>Hub</span></div>

        <div class="nav-title">MAIN MENU</div>

        <a class="nav-link active" href="<%= ctx %>/students">
            Dashboard
        </a>

        <a class="nav-link" href="#add-student">
            + Add Student
        </a>

        <a class="nav-link" href="#student-records">
            Student Records
        </a>

        <div class="nav-title">INFORMATION</div>

        <a class="nav-link" href="<%= ctx %>/about.jsp">
            About Project
        </a>

        <div class="sidebar-footer">
            <strong>StudentHub</strong><br>
            Student Record Management<br>
            MCA AIP Mini Project
        </div>
    </aside>

    <main class="main">

        <div class="topbar">
            <div>
                <h1>Dashboard</h1>
                <p class="subtitle">
                    Manage student information in one place.
                </p>
            </div>

            <div class="admin">Administrator</div>
        </div>

        <% if ("added".equals(msg)) { %>
            <div class="alert">Student added successfully!</div>
        <% } else if ("updated".equals(msg)) { %>
            <div class="alert">Student updated successfully!</div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert">Student deleted successfully!</div>
        <% } %>

        <div class="stats">

            <div class="stat-card">
                <div class="stat-label">Total Students</div>
                <div class="stat-number"><%= total %></div>
            </div>

            <div class="stat-card">
                <div class="stat-label">MCA Students</div>
                <div class="stat-number"><%= mca %></div>
            </div>

            <div class="stat-card">
                <div class="stat-label">BCA Students</div>
                <div class="stat-number"><%= bca %></div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Other Courses</div>
                <div class="stat-number"><%= other %></div>
            </div>

        </div>

        <section class="panel" id="add-student">

            <h2>Register New Student</h2>
            <p class="panel-description">
                Enter the student details below.
            </p>

            <form action="<%= ctx %>/students" method="post">

                <input type="hidden" name="action" value="add">

                <div class="form-grid">

                    <div>
                        <label for="name">Full Name</label>
                        <input id="name"
                               type="text"
                               name="name"
                               maxlength="100"
                               placeholder="Enter full name"
                               required>
                    </div>

                    <div>
                        <label for="email">Email Address</label>
                        <input id="email"
                               type="email"
                               name="email"
                               maxlength="100"
                               placeholder="student@gmail.com"
                               required>
                    </div>

                    <div>
                        <label for="course">Course</label>
                        <select id="course" name="course" required>
                            <option value="">Select course</option>
                            <option value="MCA">MCA</option>
                            <option value="BCA">BCA</option>
                            <option value="MBA">MBA</option>
                            <option value="B.Tech">B.Tech</option>
                        </select>
                    </div>

                    <div>
                        <label for="age">Age</label>
                        <input id="age"
                               type="number"
                               name="age"
                               min="16"
                               max="100"
                               placeholder="Enter age"
                               required>
                    </div>

                </div>

                <div class="form-actions">
                    <button class="btn" type="submit">
                        + Add Student
                    </button>
                </div>

            </form>
        </section>

        <section class="panel" id="student-records">

            <h2>Student Records</h2>
            <p class="panel-description">
                Search, update or delete student information.
            </p>

            <form class="search-form"
                  action="<%= ctx %>/students"
                  method="get">

                <input type="text"
                       name="search"
                       value="<%= esc(search) %>"
                       placeholder="Search by name or email">

                <button class="btn" type="submit">Search</button>

                <a class="btn btn-gray" href="<%= ctx %>/students">
                    Reset
                </a>

            </form>

            <div class="table-wrap">
                <table>

                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Student</th>
                            <th>Email</th>
                            <th>Course</th>
                            <th>Age</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>

                    <% if (!students.isEmpty()) { %>

                        <% for (Student s : students) { %>

                            <tr>
                                <td>
                                    <strong>
                                        #<%= s.getId() %>
                                    </strong>
                                </td>

                                <td>
                                    <span class="avatar"><%= esc(
                                        s.getName() == null ||
                                        s.getName().trim().isEmpty()
                                        ? "S"
                                        : s.getName().trim()
                                            .substring(0, 1)
                                            .toUpperCase()
                                    ) %></span>

                                    <span class="student-name">
                                        <%= esc(s.getName()) %>
                                    </span>
                                </td>

                                <td><%= esc(s.getEmail()) %></td>

                                <td>
                                    <span class="badge">
                                        <%= esc(s.getCourse()) %>
                                    </span>
                                </td>

                                <td><%= s.getAge() %></td>

                                <td>
                                    <div class="actions">

                                        <a class="btn btn-small"
                                           href="<%= ctx %>/students?action=edit&amp;id=<%= s.getId() %>">
                                            Edit
                                        </a>

                                        <form action="<%= ctx %>/students"
                                              method="post"
                                              onsubmit="return confirm('Are you sure you want to delete this student?');">

                                            <input type="hidden"
                                                   name="action"
                                                   value="delete">

                                            <input type="hidden"
                                                   name="id"
                                                   value="<%= s.getId() %>">

                                            <button type="submit"
                                                    class="btn btn-red btn-small">
                                                Delete
                                            </button>

                                        </form>

                                    </div>
                                </td>
                            </tr>

                        <% } %>

                    <% } else { %>

                        <tr>
                            <td colspan="6" class="empty">
                                <strong>No student records found.</strong>
                                <p>Add a student using the form above.</p>
                            </td>
                        </tr>

                    <% } %>

                    </tbody>
                </table>
            </div>
        </section>

        <div class="footer">
            StudentHub | MCA AIP Mini Project<br>
            Developed using Java, JSP, Servlets and File Handling
        </div>

    </main>
</div>
</body>
</html>