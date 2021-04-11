package com.example.restservice.service;

import java.io.File;

public class EasyRsaService {
    public File getCert() {
        Process process = new ProcessBuilder("/root/gen-certs.sh").start();
        
    }
}