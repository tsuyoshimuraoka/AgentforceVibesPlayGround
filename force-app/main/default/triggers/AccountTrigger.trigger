/**
 * @description Trigger for Account object
 * @author Salesforce Developer
 * @date 2025-11-06
 */
trigger AccountTrigger on Account (before insert, before update) {
    
    if (Trigger.isBefore && Trigger.isUpdate) {
        AccountTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}