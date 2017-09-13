package com.xapi.payment.service;

import java.util.Collection;

import com.xapi.payment.model.Payment;

public interface PaymentService {
	public Collection<Payment> getAll(Long userId);

	public Payment placePayment(Payment payment);

	public Payment calculate(Payment payment, Boolean calculatePayee);

	public Payment createPayment(Long userId, Long accountId, Long payeeId, Object paymentPayeeAmounts);

	public Payment createPayment(Payment payment);
}
