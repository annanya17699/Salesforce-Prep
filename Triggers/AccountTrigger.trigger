trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    /*INSERT EVENT*/
    if(trigger.isInsert){
        /*BEFORE INSERT EVENT*/
        if(trigger.isBefore){
            AccountTriggerHandler.verifyRevenue(trigger.new);
            AccountTriggerHandler.updateShippingAddressOnInsert(trigger.new);
        }
        /*AFTER INSERT EVENT*/
        else if(Trigger.isAfter){
            AccountTriggerHandler.insertAscContacts(trigger.new);
            if(!AccountTriggerHandler.isTriggerBypassed){
                AccountTriggerHandler.isTriggerBypassed = true;
                AccountTriggerHandler.createChildAcc(trigger.new);
            }
        }
    }
    /*UPDATE EVENT*/
    else if(trigger.isUpdate){
        if(trigger.isBefore){
            AccountTriggerHandler.restrictActiveAccNameModification(trigger.new, trigger.oldMap);
        }
        /*AFTER UPDATE EVENT*/
        else if(trigger.isAfter){
            AccountTriggerHandler.updateMailAddForContacts(trigger.new, trigger.oldMap);
        }
    }
    /*DELETE EVENT*/
    else if(trigger.isDelete){
        /*BEFORE DELETE EVENT*/
        if(trigger.isBefore){
            AccountTriggerHandler.restrictActiveAccDel(trigger.old);
        }
        /*AFTER DELETE EVENT*/
        else if(trigger.isAfter){
            AccountTriggerHandler.sendEmailOnDelete(trigger.old);
        }
    }
    /*AFTER UNDELETE EVENT*/
    else if(trigger.isUndelete && trigger.isAfter){
        AccountTriggerHandler.sendEmailOnUndelete(trigger.new);
    }
}