/**
 * Scheduled Apex class to trigger daily billing jobs.
 * Runs once per day at configured hour.
 */
global class DailyBillingScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        // Get config
        Billing_Config__mdt config = [
            SELECT DailyScheduleHour__c, BatchSize__c, MaxConcurrency__c
            FROM Billing_Config__mdt
            LIMIT 1
        ];
        
        // Fire queueables in parallel
        List<AsyncApexJob> jobs = new List<AsyncApexJob>();
        
        // 1. Billing job
        BillingJob bj = new BillingJob();
        jobs.add(System.enqueueJob(bj));
        
        // 2. Dunning job
        DunningJob dj = new DunningJob();
        jobs.add(System.enqueueJob(dj));
        
        // 3. Retry payments job
        RetryFailedPaymentsJob rj = new RetryFailedPaymentsJob();
        jobs.add(System.enqueueJob(rj));
    }
}
