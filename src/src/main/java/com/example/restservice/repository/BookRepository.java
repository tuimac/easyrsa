package com.example.restservice.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

interface BookRepository extends JpaRepository<Book, Long> {
    @Query("select ")
	
}
