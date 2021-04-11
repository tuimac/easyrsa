package com.example.restservice.controller;

import com.example.restservice.model.Book;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EasyRsaContoller {

    @GetMapping("/getCert")
    public void getCert() {
        
        return ;
    }

    @PostMapping
    public Book create(@ModelAttribute Book book) {
        bookService.save(book);
        return "book";
    }
}
