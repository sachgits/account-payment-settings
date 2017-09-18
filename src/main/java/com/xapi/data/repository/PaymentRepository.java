package com.xapi.data.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;

import com.xapi.data.model.Payment;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
//	JpaRepository, CrudRepository
	public List<Payment> findByUserId(Long userId);
	public Payment findById(Long Id);
}