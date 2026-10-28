package com.student.servlet;

import java.io.IOException;
import java.util.List;

import com.student.model.Student;
import com.student.util.StudentFileManager;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String action = request.getParameter("action");

            // Open the edit page
            if ("edit".equals(action)) {

                int id = Integer.parseInt(
                    request.getParameter("id"));

                Student selected = null;

                for (Student s : StudentFileManager.getAll()) {
                    if (s.getId() == id) {
                        selected = s;
                        break;
                    }
                }

                if (selected == null) {
                    response.sendError(404, "Student not found");
                    return;
                }

                request.setAttribute("student", selected);

                request.getRequestDispatcher("/edit.jsp")
                       .forward(request, response);

                return;
            }

            List<Student> allStudents =
                StudentFileManager.getAll();

            // Dashboard statistics
            int total = allStudents.size();
            int mca = 0;
            int bca = 0;
            int other = 0;

            for (Student s : allStudents) {

                if ("MCA".equals(s.getCourse())) {
                    mca++;
                } else if ("BCA".equals(s.getCourse())) {
                    bca++;
                } else {
                    other++;
                }
            }

            request.setAttribute("total", total);
            request.setAttribute("mca", mca);
            request.setAttribute("bca", bca);
            request.setAttribute("other", other);

            // Search by name or email
            String search = request.getParameter("search");

            if (search != null && !search.trim().isEmpty()) {

                String term = search.trim().toLowerCase();

                allStudents.removeIf(s ->
                    !s.getName().toLowerCase().contains(term)
                    && !s.getEmail().toLowerCase().contains(term)
                );
            }

            request.setAttribute("students", allStudents);
            request.setAttribute("search", search);

            request.getRequestDispatcher("/index.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid student ID");
        } catch (IOException e) {
            throw new ServletException(
                "Unable to read student records", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String action = request.getParameter("action");

            if ("add".equals(action) ||
                "update".equals(action)) {

                String name = request.getParameter("name");
                String email = request.getParameter("email");
                String course = request.getParameter("course");
                String ageText = request.getParameter("age");

                if (name == null || email == null ||
                    course == null || ageText == null) {

                    response.sendError(400, "All fields are required");
                    return;
                }

                name = name.trim();
                email = email.trim();
                course = course.trim();

                if (name.isEmpty() || email.isEmpty()
                    || course.isEmpty()) {

                    response.sendError(400, "All fields are required");
                    return;
                }

                // The file uses | as its field separator
                if (name.contains("|") || email.contains("|")
                    || course.contains("|")
                    || name.contains("\n") || email.contains("\n")
                    || course.contains("\n")
                    || name.contains("\r") || email.contains("\r")
                    || course.contains("\r")) {

                    response.sendError(400, "Invalid input");
                    return;
                }

                if (name.length() > 100 || email.length() > 100) {
                    response.sendError(400, "Input is too long");
                    return;
                }

                if (!email.matches(
                    "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {

                    response.sendError(400, "Invalid email");
                    return;
                }

                if (!course.equals("MCA")
                    && !course.equals("BCA")
                    && !course.equals("MBA")
                    && !course.equals("B.Tech")) {

                    response.sendError(400, "Invalid course");
                    return;
                }

                int age = Integer.parseInt(ageText);

                if (age < 16 || age > 100) {
                    response.sendError(400, "Invalid age");
                    return;
                }

                if ("add".equals(action)) {

                    StudentFileManager.add(
                        name, email, course, age);

                    response.sendRedirect(
                        request.getContextPath()
                        + "/students?msg=added");

                } else {

                    int id = Integer.parseInt(
                        request.getParameter("id"));

                    boolean updated = StudentFileManager.update(
                        id, name, email, course, age);

                    if (!updated) {
                        response.sendError(404, "Student not found");
                        return;
                    }

                    response.sendRedirect(
                        request.getContextPath()
                        + "/students?msg=updated");
                }

            } else if ("delete".equals(action)) {

                int id = Integer.parseInt(
                    request.getParameter("id"));

                boolean deleted =
                    StudentFileManager.delete(id);

                if (!deleted) {
                    response.sendError(404, "Student not found");
                    return;
                }

                response.sendRedirect(
                    request.getContextPath()
                    + "/students?msg=deleted");

            } else {
                response.sendError(400, "Invalid action");
            }

        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid number");
        } catch (IOException e) {
            throw new ServletException(
                "Unable to save student records", e);
        }
    }
}