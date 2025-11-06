/**
 * Queueable class to process dunning steps for overdue invoices.
 * Called by DailyBillingScheduler.
 */
public class DunningJob implements Queueable {
    
    public void execute(QueueableContext context) {
        // Fetch invoices that are past due and not yet processed
        List<Invoice__c> invoices = [
            SELECT Id, Account__c, Subscription__c, Status__c, Total__c
            FROM Invoice__c
            WHERE Status__c = 'Failed'
              AND LastBilledAt__c < LAST_N_DAYS:30
            ORDER BY LastBilledAt__c ASC
        ];

        if (invoices.isEmpty()) {
            System.debug('No invoices to dunning process.');
            return;
        }

        // Process in batches
        Integer batchSize = 100; // Configurable via CMT
        for (Integer i = 0; i < invoices.size(); i += batchSize) {
            Integer endIndex = Math.min(i + batchSize, invoices.size());
            List<Invoice__c> batch = invoices.getRange(i, endIndex);
            
            // Call dunning service
            DunningService.processBatch(batch);
        }
    }
}
