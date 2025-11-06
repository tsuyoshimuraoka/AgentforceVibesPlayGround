/**
 * Domain layer for Invoice business logic.
 * Handles invoice creation, totals calculation, and status management.
 */
public with sharing class InvoiceDomain {

    /**
     * Calculates subtotal, tax, and total for an invoice.
     * Assumes InvoiceLine__c records exist and are populated.
     */
    public static void calculateTotals(Invoice__c inv) {
        if (inv == null) return;

        Decimal subtotal = 0;
        Decimal taxAmount = 0;
        Decimal total = 0;

        // Sum lines (this would typically be done via SOQL with aggregate queries)
        // For now we simulate by assuming lines are already calculated
        // In real implementation, you'd fetch InvoiceLine__c records and sum them up

        // Placeholder logic - in practice, this would query InvoiceLine__c and sum fields
        // Example:
        // List<InvoiceLine__c> lines = [SELECT Subtotal__c, TaxAmount__c FROM InvoiceLine__c WHERE Invoice__c = :inv.Id];
        // for (InvoiceLine__c line : lines) {
        //     subtotal += line.Subtotal__c;
        //     taxAmount += line.TaxAmount__c;
        // }
        // total = subtotal + taxAmount;

        // For now, just assign placeholder values
        inv.Subtotal__c = subtotal;
        inv.TaxAmount__c = taxAmount;
        inv.Total__c = total;
    }

    /**
     * Sets invoice status based on amount and payment history.
     * Called during creation or after payment processing.
     */
    public static void updateStatus(Invoice__c inv) {
        if (inv == null) return;

        // If no amount, draft
        if (inv.Total__c == null || inv.Total__c == 0) {
            inv.Status__c = 'Draft';
        }
        // If paid or failed, leave as-is
        else if (inv.Status__c == 'Paid' || inv.Status__c == 'Failed') {
            // Do nothing
        }
        // Otherwise, default to posted
        else {
            inv.Status__c = 'Posted';
        }
    }
}
