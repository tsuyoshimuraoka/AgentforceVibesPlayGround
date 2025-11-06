/**
 * Trigger handler for Invoice__c.
 * Manages invoice status and fires platform events.
 */
public with sharing class InvoiceTriggerHandler {

    /**
     * Handles after insert event.
     * Fires InvoiceGenerated__e platform event.
     */
    public static void handleAfterInsert(List<Invoice__c> invoices) {
        if (invoices == null || invoices.isEmpty()) return;

        List<InvoiceGenerated__e> events = new List<InvoiceGenerated__e>();
        for (Invoice__c inv : invoices) {
            InvoiceGenerated__e evt = new InvoiceGenerated__e(
                Invoice__c = inv.Id,
                AccountId__c = inv.Account__c,
                SubscriptionId__c = inv.Subscription__c,
                Total__c = inv.Total__c,
                Status__c = inv.Status__c
            );
            events.add(evt);
        }

        if (!events.isEmpty()) {
            EventBus.publish(events);
        }
    }
}
