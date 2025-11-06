/**
 * @description Test class for AccountTriggerHandler
 * @author Salesforce Developer
 * @date 2025-11-06
 */
@isTest
private class AccountTriggerHandlerTest {
    
    /**
     * @description Test data setup
     */
    @TestSetup
    static void setupTestData() {
        // Create test accounts with various UpsellOpportunity values
        List<Account> testAccounts = new List<Account>{
            new Account(Name = 'Test Account 1', UpsellOpportunity__c = 'No'),
            new Account(Name = 'Test Account 2', UpsellOpportunity__c = 'Maybe'),
            new Account(Name = 'Test Account 3', UpsellOpportunity__c = 'Yes'),
            new Account(Name = 'Test Account 4') // No initial value
        };
        insert testAccounts;
    }
    
    /**
     * @description Test: UpsellOpportunity 'No' -> Rating 'Cold'
     */
    @isTest
    static void testUpsellOpportunityNo_UpdatesRatingToCold() {
        // Given: Account with no UpsellOpportunity
        Account testAccount = [SELECT Id, UpsellOpportunity__c, Rating FROM Account WHERE Name = 'Test Account 4' LIMIT 1];
        
        // When: Update UpsellOpportunity to 'No'
        Test.startTest();
        testAccount.UpsellOpportunity__c = 'No';
        update testAccount;
        Test.stopTest();
        
        // Then: Rating should be 'Cold'
        testAccount = [SELECT Rating FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Cold', testAccount.Rating, 'Rating should be Cold when UpsellOpportunity is No');
    }
    
    /**
     * @description Test: UpsellOpportunity 'Maybe' -> Rating 'Warm'
     */
    @isTest
    static void testUpsellOpportunityMaybe_UpdatesRatingToWarm() {
        // Given: Account with UpsellOpportunity 'No'
        Account testAccount = [SELECT Id, UpsellOpportunity__c, Rating FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
        
        // When: Update UpsellOpportunity to 'Maybe'
        Test.startTest();
        testAccount.UpsellOpportunity__c = 'Maybe';
        update testAccount;
        Test.stopTest();
        
        // Then: Rating should be 'Warm'
        testAccount = [SELECT Rating FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Warm', testAccount.Rating, 'Rating should be Warm when UpsellOpportunity is Maybe');
    }
    
    /**
     * @description Test: UpsellOpportunity 'Yes' -> Rating 'Hot'
     */
    @isTest
    static void testUpsellOpportunityYes_UpdatesRatingToHot() {
        // Given: Account with UpsellOpportunity 'Maybe'
        Account testAccount = [SELECT Id, UpsellOpportunity__c, Rating FROM Account WHERE Name = 'Test Account 2' LIMIT 1];
        
        // When: Update UpsellOpportunity to 'Yes'
        Test.startTest();
        testAccount.UpsellOpportunity__c = 'Yes';
        update testAccount;
        Test.stopTest();
        
        // Then: Rating should be 'Hot'
        testAccount = [SELECT Rating FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Hot', testAccount.Rating, 'Rating should be Hot when UpsellOpportunity is Yes');
    }
    
    /**
     * @description Test: Multiple updates in sequence
     */
    @isTest
    static void testSequentialUpdates_UpdatesRatingCorrectly() {
        // Given: Account with UpsellOpportunity 'Yes'
        Account testAccount = [SELECT Id, UpsellOpportunity__c, Rating FROM Account WHERE Name = 'Test Account 3' LIMIT 1];
        
        Test.startTest();
        
        // When: Change from Yes to Maybe
        testAccount.UpsellOpportunity__c = 'Maybe';
        update testAccount;
        testAccount = [SELECT Rating FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Warm', testAccount.Rating, 'Rating should be Warm after first update');
        
        // When: Change from Maybe to No
        testAccount.UpsellOpportunity__c = 'No';
        update testAccount;
        testAccount = [SELECT Rating FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Cold', testAccount.Rating, 'Rating should be Cold after second update');
        
        // When: Change from No to Yes
        testAccount.UpsellOpportunity__c = 'Yes';
        update testAccount;
        testAccount = [SELECT Rating FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Hot', testAccount.Rating, 'Rating should be Hot after third update');
        
        Test.stopTest();
    }
    
    /**
     * @description Test: Rating should not change if UpsellOpportunity is not updated
     */
    @isTest
    static void testNoUpsellOpportunityChange_RatingRemainsUnchanged() {
        // Given: Account with Rating already set
        Account testAccount = [SELECT Id, UpsellOpportunity__c, Rating FROM Account WHERE Name = 'Test Account 1' LIMIT 1];
        testAccount.Rating = 'Hot'; // Manually set Rating to Hot
        update testAccount;
        
        // When: Update other fields but not UpsellOpportunity
        Test.startTest();
        testAccount.Name = 'Test Account 1 Updated';
        update testAccount;
        Test.stopTest();
        
        // Then: Rating should remain 'Hot'
        testAccount = [SELECT Rating FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals('Hot', testAccount.Rating, 'Rating should remain unchanged when UpsellOpportunity is not updated');
    }
    
    /**
     * @description Test: Bulk update of multiple accounts
     */
    @isTest
    static void testBulkUpdate_UpdatesAllRatingsCorrectly() {
        // Given: Multiple accounts
        List<Account> testAccounts = [SELECT Id, UpsellOpportunity__c, Rating FROM Account ORDER BY Name];
        
        // When: Bulk update with different UpsellOpportunity values
        Test.startTest();
        testAccounts[0].UpsellOpportunity__c = 'Yes';  // Test Account 1: No -> Yes
        testAccounts[1].UpsellOpportunity__c = 'No';   // Test Account 2: Maybe -> No
        testAccounts[2].UpsellOpportunity__c = 'Maybe'; // Test Account 3: Yes -> Maybe
        testAccounts[3].UpsellOpportunity__c = 'Yes';  // Test Account 4: null -> Yes
        update testAccounts;
        Test.stopTest();
        
        // Then: All ratings should be updated correctly
        testAccounts = [SELECT Rating FROM Account WHERE Id IN :testAccounts ORDER BY Name];
        System.assertEquals('Hot', testAccounts[0].Rating, 'Account 1 Rating should be Hot');
        System.assertEquals('Cold', testAccounts[1].Rating, 'Account 2 Rating should be Cold');
        System.assertEquals('Warm', testAccounts[2].Rating, 'Account 3 Rating should be Warm');
        System.assertEquals('Hot', testAccounts[3].Rating, 'Account 4 Rating should be Hot');
    }
}
