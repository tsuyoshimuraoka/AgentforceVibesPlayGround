/**
 * Trigger handler for Subscription__c.
 * Manages lifecycle events, status updates, and next bill date calculations.
 */
public with sharing class SubscriptionTriggerHandler {

    /**
     * Handles after insert and after update events.
     * Updates status and next bill date.
     */
    public static void handleAfter(List<Subscription__c> subs) {
        if (subs == null || subs.isEmpty()) return;

        for (Subscription__c sub : subs) {
            // Validate
            SubscriptionDomain.validate(sub);

            // Update status
            SubscriptionDomain.updateStatus(sub);

            // Calculate next bill date
            if (sub.NextBillDate__c == null) {
                sub.NextBillDate__c = SubscriptionDomain.calculateNextBillDate(sub);
            }
        }
    }

    /**
     * Handles before insert and before update.
     * Sets default values and validates.
     */
    public static void handleBefore(List<Subscription__c> subs) {
        if (subs == null || subs.isEmpty()) return;

        for (Subscription__c sub : subs) {
            // Set defaults
            if (sub.BaseCurrencyIsoCode__c == null) {
                sub.BaseCurrencyIsoCode__c = 'USD'; // Default fallback
            }

            // Validate
            SubscriptionDomain.validate(sub);
        }
    }
}
