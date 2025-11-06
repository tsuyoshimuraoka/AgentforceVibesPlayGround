Part 1 Apex Classes Created

- Domain Layer:
  - SubscriptionDomain.cls: Core validation and lifecycle logic
  - InvoiceDomain.cls: Invoice totals and status logic
- Trigger Handlers:
  - SubscriptionTriggerHandler.cls: Manages status and next bill date
  - InvoiceTriggerHandler.cls: Fires platform events
- Scheduling & Jobs:
  - DailyBillingScheduler.cls: Entry point for daily jobs
  - BillingJob.cls: Processes billing for subscriptions
  - DunningJob.cls: Processes overdue invoices
  - RetryFailedPaymentsJob.cls: Retries temporary failures
- Interfaces/Abstractions (TBD):
  - IPaymentGateway.cls (to be added)
  - IProrationService.cls (to be added)
- Future Services (TBD):
  - BillingService.cls
  - ProrationService.cls
  - PaymentGatewayService.cls
  - DunningService.cls
  - CurrencyService.cls
  - TaxService.cls
  - RoundingService.cls

Next in Part 1:

- Add basic test classes for domain/logic
- Add LWC Jest tests
- Add seed script
- Add README notes for deployment and usage
