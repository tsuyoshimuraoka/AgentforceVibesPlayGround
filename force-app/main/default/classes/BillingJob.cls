/**
 * Queueable class to process billing for subscriptions.
 * Designed to be called by DailyBillingScheduler.
 */
public class BillingJob implements Queueable {
    
    public void execute(QueueableContext context) {
        // Fetch subscriptions that need billing today
        List<Subscription__c> subs = [
            SELECT Id, Account__c, Pricebook2Id__c, BillingPeriod__c, StartDate__c, 
                   NextBillDate__c, Status__c, TaxMode__c, RoundingRule__c, BaseCurrencyIsoCode__c
            FROM Subscription__c
            WHERE NextBillDate__c = TODAY
              AND Status__c IN ('Active', 'Trial')
            ORDER BY NextBillDate__c ASC
        ];

        if (subs.isEmpty()) {
            System.debug('No subscriptions to bill today.');
            return;
        }

        // Process in batches
        Integer batchSize = 100; // Configurable via CMT
        for (Integer i = 0; i < subs.size(); i += batchSize) {
            Integer endIndex = Math.min(i + batchSize, subs.size());
            List<Subscription__c> batch = subs.getRange(i, endIndex);
            
            // Call billing service
            BillingService.processBatch(batch);
        }
    }
}
