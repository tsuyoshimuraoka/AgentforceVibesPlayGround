/**
 * Queueable class to retry failed payments.
 * Called by DailyBillingScheduler.
 */
public class RetryFailedPaymentsJob implements Queueable {
    
    public void execute(QueueableContext context) {
        // Fetch failed payments that are eligible for retry
        List<Payment__c> payments = [
            SELECT Id, Invoice__c, Result__c, Attempts__c, LastAttemptAt__c
            FROM Payment__c
            WHERE Result__c = 'TemporaryFailure'
              AND LastAttemptAt__c < LAST_N_DAYS:7
            ORDER BY LastAttemptAt__c ASC
        ];

        if (payments.isEmpty()) {
            System.debug('No payments to retry.');
            return;
        }

        // Process in batches
        Integer batchSize = 100; // Configurable via CMT
        for (Integer i = 0; i < payments.size(); i += batchSize) {
            Integer endIndex = Math.min(i + batchSize, payments.size());
            List<Payment__c> batch = payments.getRange(i, endIndex);
            
            // Call retry service
            PaymentService.retryBatch(batch);
        }
    }
}
