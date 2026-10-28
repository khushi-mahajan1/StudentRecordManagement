package com.student.util;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import com.student.model.Student;

public class StudentFileManager {

    private static final Path FOLDER =
        Paths.get(System.getProperty("user.home"),
                  "StudentRecordManagementData");

    private static final Path FILE =
        FOLDER.resolve("students.txt");

    private static void prepareFile() throws IOException {

        Files.createDirectories(FOLDER);

        if (Files.notExists(FILE)) {
            Files.createFile(FILE);
        }
    }

    // Read all student records
    public static synchronized List<Student> getAll()
            throws IOException {

        prepareFile();

        List<Student> students = new ArrayList<>();

        List<String> lines =
            Files.readAllLines(FILE, StandardCharsets.UTF_8);

        for (String line : lines) {

            String[] data = line.split("\\|", -1);

            if (data.length == 5) {
                try {
                    students.add(new Student(
                        Integer.parseInt(data[0]),
                        data[1],
                        data[2],
                        data[3],
                        Integer.parseInt(data[4])
                    ));
                } catch (NumberFormatException e) {
                    // Skip invalid records
                }
            }
        }

        return students;
    }

    // Generate a new ID
    private static int nextId(List<Student> students) {

        int max = 0;

        for (Student s : students) {
            if (s.getId() > max) {
                max = s.getId();
            }
        }

        return max + 1;
    }

    // Save records to the file
    private static void saveAll(List<Student> students)
            throws IOException {

        prepareFile();

        List<String> lines = new ArrayList<>();

        for (Student s : students) {

            lines.add(
                s.getId() + "|" +
                s.getName() + "|" +
                s.getEmail() + "|" +
                s.getCourse() + "|" +
                s.getAge()
            );
        }

        Files.write(FILE, lines, StandardCharsets.UTF_8);
    }

    // CREATE
    public static synchronized void add(
            String name, String email,
            String course, int age) throws IOException {

        List<Student> students = getAll();

        students.add(new Student(
            nextId(students), name, email, course, age
        ));

        saveAll(students);
    }

    // UPDATE
    public static synchronized boolean update(
            int id, String name, String email,
            String course, int age) throws IOException {

        List<Student> students = getAll();

        for (Student s : students) {

            if (s.getId() == id) {

                s.setName(name);
                s.setEmail(email);
                s.setCourse(course);
                s.setAge(age);

                saveAll(students);
                return true;
            }
        }

        return false;
    }

    // DELETE
    public static synchronized boolean delete(int id)
            throws IOException {

        List<Student> students = getAll();

        boolean removed = students.removeIf(
            s -> s.getId() == id
        );

        if (removed) {
            saveAll(students);
        }

        return removed;
    }
}