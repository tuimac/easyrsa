package com.example.restservice.model;

public class Book {

    private final int bookId;
    private final String title;
    private final String content;

    public Book(int bookId, String title, String content) {
        this.bookId = bookId;
        this.title = title;
        this.content = content;
    }

    public int getBookId() {
        return this.bookId;
    }

    public String getTitle() {
        return this.title;
    }

    public String getContent() {
        return this.content;
    }
}
