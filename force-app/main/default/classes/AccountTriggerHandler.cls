/**
 * @description Handler class for Account trigger
 * @author Salesforce Developer
 * @date 2025-11-06
 */
public with sharing class AccountTriggerHandler {
    
    /**
     * @description Handles the before update event for Account records
     * Updates Rating field based on UpsellOpportunity__c field value
     * @param newAccounts List of new Account records
     * @param oldAccountsMap Map of old Account records
     */
    public static void handleBeforeUpdate(List<Account> newAccounts, Map<Id, Account> oldAccountsMap) {
        updateRatingBasedOnUpsellOpportunity(newAccounts, oldAccountsMap);
    }
    
    /**
     * @description Updates Account Rating based on Upsell Opportunity value
     * Mapping:
     * - No -> Cold
     * - Maybe -> Warm
     * - Yes -> Hot
     * @param newAccounts List of new Account records
     * @param oldAccountsMap Map of old Account records
     */
    private static void updateRatingBasedOnUpsellOpportunity(
        List<Account> newAccounts, 
        Map<Id, Account> oldAccountsMap
    ) {
        for (Account newAccount : newAccounts) {
            Account oldAccount = oldAccountsMap.get(newAccount.Id);
            
            // Check if UpsellOpportunity__c field has changed
            if (hasUpsellOpportunityChanged(newAccount, oldAccount)) {
                // Update Rating based on new UpsellOpportunity__c value
                newAccount.Rating = getRatingFromUpsellOpportunity(newAccount.UpsellOpportunity__c);
            }
        }
    }
    
    /**
     * @description Checks if UpsellOpportunity__c field has changed
     * @param newAccount New Account record
     * @param oldAccount Old Account record
     * @return Boolean indicating if the field changed
     */
    private static Boolean hasUpsellOpportunityChanged(Account newAccount, Account oldAccount) {
        return newAccount.UpsellOpportunity__c != oldAccount.UpsellOpportunity__c;
    }
    
    /**
     * @description Maps UpsellOpportunity__c value to Rating value
     * @param upsellOpportunity The Upsell Opportunity value
     * @return Rating value (Hot, Warm, Cold, or null)
     */
    private static String getRatingFromUpsellOpportunity(String upsellOpportunity) {
        if (String.isBlank(upsellOpportunity)) {
            return null;
        }
        
        switch on upsellOpportunity {
            when 'Yes' {
                return 'Hot';
            }
            when 'Maybe' {
                return 'Warm';
            }
            when 'No' {
                return 'Cold';
            }
            when else {
                return null;
            }
        }
    }
}
