/**
 * Domain layer for Subscription business logic.
 * Handles validation, lifecycle transitions, and core subscription rules.
 */
public with sharing class SubscriptionDomain {
    
    /**
     * Validates a subscription before insert/update.
     * Ensures required fields are populated and dates are sensible.
     */
    public static void validate(Subscription__c sub) {
        // Required fields
        if (sub.Account__c == null) {
            throw new IllegalArgumentException('Account is required.');
        }
        if (sub.StartDate__c == null) {
            throw new IllegalArgumentException('Start Date is required.');
        }
        if (sub.BillingPeriod__c == null) {
            throw new IllegalArgumentException('Billing Period is required.');
        }

        // Date consistency
        if (sub.EndDate__c != null && sub.StartDate__c > sub.EndDate__c) {
            throw new IllegalArgumentException('End Date cannot be before Start Date.');
        }

        // Trial period
        if (sub.TrialEndDate__c != null && sub.StartDate__c > sub.TrialEndDate__c) {
            throw new IllegalArgumentException('Trial End Date cannot be before Start Date.');
        }

        // Status transitions
        if (sub.Status__c == null) {
            sub.Status__c = 'Active'; // Default
        }
        
        // Versioning for concurrency
        if (sub.Id != null && sub.Version__c == null) {
            sub.Version__c = 0;
        }
    }

    /**
     * Updates subscription status based on lifecycle events.
     * Called from triggers and services.
     */
    public static void updateStatus(Subscription__c sub) {
        if (sub.IsPaused__c) {
            sub.Status__c = 'Paused';
        } else if (sub.CancelDate__c != null) {
            sub.Status__c = 'Canceled';
        } else if (sub.TrialEndDate__c != null && System.today() > sub.TrialEndDate__c) {
            sub.Status__c = 'Active';
        } else if (sub.Status__c == 'Trial' && sub.TrialEndDate__c != null && System.today() > sub.TrialEndDate__c) {
            sub.Status__c = 'Active';
        }
    }

    /**
     * Calculates next bill date based on billing period and start date.
     * Used in triggers to set NextBillDate__c.
     */
    public static Date calculateNextBillDate(Subscription__c sub) {
        if (sub.StartDate__c == null || sub.BillingPeriod__c == null) return null;

        Date startDate = sub.StartDate__c;
        Date nextBill = startDate;

        if (sub.BillingPeriod__c == 'Monthly') {
            nextBill = startDate.addMonths(1);
        } else if (sub.BillingPeriod__c == 'Yearly') {
            nextBill = startDate.addYears(1);
        } else {
            // Custom: Return start date + 30 days
            nextBill = startDate.addDays(30);
        }

        return nextBill;
    }
}
