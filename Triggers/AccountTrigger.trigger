trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    //SCENARIO 1 : Trigger to copy billing address to shipping address on insert of account
    //SCENARIO 2 : Trigger to throw error if annual revenue is less than 1000
    //SCENARIO 3 : Create a contact with same name when account is inserted
    //SCENARIO 4 : If account name is modiied throw error that name modification not allowed
    //SCENARIO 5 : If account billing address update associated contact mailing address
    //SCENARIO 6 : An Active Account cannot be deleted
    //SCENARIO 7 : Send email to current user when account is deleted
    //SCENARIO 8 : Send email to current user when account is undeleted or restored
    //SCENARIO 9 : Bypass trigger if child account is inserted
    
    /*INSERT EVENT*/
    if(trigger.isInsert){
        /*BEFORE INSERT EVENT*/
        if(trigger.isBefore){
            /*SCENARIO 2*/
            AccountTriggerHandler.verifyRevenue(trigger.new);
            /*SCENARIO 1*/
            AccountTriggerHandler.updateShippingAddressOnInsert(trigger.new);
        }
        /*AFTER INSERT EVENT*/
        else if(Trigger.isAfter){
            /*SCENARIO 3*/
            AccountTriggerHandler.insertAscContacts(trigger.new);
            /*SCENARIO 9*/
            if(!AccountTriggerHandler.isTriggerBypassed){
                AccountTriggerHandler.isTriggerBypassed = true;
                AccountTriggerHandler.createChildAcc(trigger.new);
            }
        }
    }
    /*UPDATE EVENT*/
    else if(trigger.isUpdate){
        /*BEFORE UPDATE EVENT*/
        if(trigger.isBefore){
            /*SCENARIO 4*/
            AccountTriggerHandler.restrictActiveAccNameModification(trigger.new, trigger.oldMap);
        }
        /*AFTER UPDATE EVENT*/
        else if(trigger.isAfter){
            /*SCENARIO 5*/
            AccountTriggerHandler.updateMailAddForContacts(trigger.new, trigger.oldMap);
        }
    }
    /*DELETE EVENT*/
    else if(trigger.isDelete){
        /*BEFORE DELETE EVENT*/
        if(trigger.isBefore){
            /*SCENARIO 6*/
            AccountTriggerHandler.restrictActiveAccDel(trigger.old);
        }
        /*AFTER DELETE EVENT*/
        else if(trigger.isAfter){
            /*SCENARIO 7*/
            AccountTriggerHandler.sendEmailOnDelete(trigger.old);
        }
    }
    /*AFTER UNDELETE EVENT*/
    else if(trigger.isUndelete && trigger.isAfter){
        /*SCENARIO 8*/
        AccountTriggerHandler.sendEmailOnUndelete(trigger.new);
    }
}