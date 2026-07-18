public class AccountTriggerHandler {
    
    public static boolean isTriggerBypassed = false;
    
    /*
    * SCENARIO 9 : Bypass trigger if child account is inserted		
    * @param : accList - new inserted account list
    * @return : void
    * @doc : Create child accounts on insertion of new account
    */
    public static void createChildAcc(List<Account> accList){
        List<Account> childAccList = new List<Account>();
        for(Account a : accList){
            Account childAcc = new Account();
            childAcc.Name = a.name + ' Subbranch';
            childAcc.BillingCity = a.BillingCity;
            childAcc.BillingStateCode = a.BillingStateCode;
            childAcc.BillingPostalCode = a.BillingPostalCode;
            childAcc.BillingStreet = a.BillingStreet;
            childAcc.BillingCountryCode = a.BillingCountryCode;
            childAcc.ParentId = a.Id;
            childAccList.add(childAcc);
        }
        if(childAccList.size() > 0) insert childAccList;
    }
    
    /*
    * SCENARIO 8 : Send email to current user when account is undeleted or restored		
    * @param : accList - new restored account list
    * @return : void
    * @doc : Send email to current user on restore of deleted account
    */
    public static void sendEmailOnUndelete(List<Account> accList){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(Account a : accList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
            mail.setSubject(a.Name + ' is restored.');
            mail.setPlainTextBody('Account Owner : '+a.OwnerId +' Annual Revenue : '+ a.AnnualRevenue );
            mailList.add(mail);
        }
        Messaging.sendEmail(mailList);
    }
    /*
    * SCENARIO 7 : Send email to current user when account is deleted		
    * @param : accList - old deleted account list
    * @return : void
    * @doc : Send email to current user on deletion of account
    */
    public static void sendEmailOnDelete(List<Account> accList){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        for(Account a : accList){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
            mail.setSubject(a.Name + ' is deleted.');
            mail.setPlainTextBody('Annual Revenue : '+ a.AnnualRevenue );
            mailList.add(mail);
        }
        Messaging.sendEmail(mailList);
    }

    /*
    * SCENARIO 6 : An Active Account cannot be deleted		
    * @param : accList - updated account list
    * @return : void
    * @doc : Restrict modification of active account
    */    
    public static void restrictActiveAccDel(List<Account> accList){
        for(Account a : accList){
            if(a.Active__c == 'Yes') a.addError('Active account cannot be deleted');
        }
    }
    /*SCENARIO 2*/    
    /*
    * SCENARIO 2 : Trigger to throw error if annual revenue is less than 1000		
    * @param : accList - updated account list
    * @return : void
    * @doc : Annual Revenue can not be less than 1000
    */
    public static void verifyRevenue(List<Account> accList){
        for (Account a : accList) {
            if(a.AnnualRevenue < 1000){
                a.addError('Annual Revenue cannot be less than 1000');
            }    
        }
    }

    /*
    * SCENARIO 1 : Trigger to copy billing address to shipping address on insert of account		
    * @param : accList - new account list
    * @return : void
    * @doc : Copy Shipping address from billing address if empty
    */
    public static void updateShippingAddressOnInsert(List<Account> accList){
        for (Account a : accList) {
            if(a.ShippingAddress == null){
                a.ShippingCity = a.BillingCity;
                a.ShippingStateCode = a.BillingStateCode;
                a.ShippingPostalCode = a.BillingPostalCode;
                a.ShippingStreet = a.BillingStreet;
                a.ShippingCountryCode = a.BillingCountryCode;
            }   
        }
    }
    
    /*	
    * SCENARIO 3 : Create a contact with same name when account is inserted	
    * @param : accList - new account list
    * @return : void
    * @doc : Insert child Contact
    */
    public static void insertAscContacts(List<Account> accList){
        List<Contact> contactListToInsert = new List<Contact>();
        for (Account a : accList) {
            Contact c = new Contact();
            c.LastName = a.Name;
            c.AccountId = a.Id;
            c.Phone = a.Phone;
            contactListToInsert.add(c);
        }
        
        if(contactListToInsert.size()> 0) insert contactListToInsert;
    }
  
    /*		
    * SCENARIO 4 : If account name is modiied throw error that name modification not allowed
    * @param : accList - updated account list
    * @param : idVsAccMap - old map of id Vs Acc
    * @return : void
    * @doc : Restrict Account Name modification
    */
    public static void restrictActiveAccNameModification(List<Account> accList, Map<Id, Account> idVsAccMap){
        for(Account a : accList){
            if(idVsAccMap.get(a.Id).Name != a.Name) a.addError('Account name cannot be modified');
        }
    }
    
    /*		
    * SCENARIO 5 : If account billing address update associated contact mailing address
    * @param : accList - updated account list
    * @param : idVsAccMap - old map of id Vs Acc
    * @return : void
    * @doc : Update Mailing address of child Contacts if parent billing address changes
    */
    public static void updateMailAddForContacts(List<Account> accList, Map<Id, Account> idVsAccMap){
        Set<Id> accIds = new Set<Id>();
        for(Account a : accList){
            Account oldAcc = idVsAccMap.get(a.Id);
            if(oldAcc.BillingStreet != a.BillingStreet) accIds.add(a.Id);
        }
        List<Contact> contactsToUpdate = [Select Id,Account.BillingStateCode, Account.BillingPostalCode, Account.BillingStreet, Account.BillingCountryCode , Account.BillingCity, MailingCity, MailingStateCode, MailingCountryCode, MailingPostalCode, MailingStreet  from Contact where AccountId IN : accIds];
        for(Contact c : contactsToUpdate){
            c.MailingCity = c.Account.BillingCity;
            c.MailingStateCode = c.Account.BillingStateCode;
            c.MailingPostalCode = c.Account.BillingPostalCode;
            c.MailingStreet = c.Account.BillingStreet;
            c.MailingCountryCode = c.Account.BillingCountryCode;
        }
        if(contactsToUpdate.size()> 0) update contactsToUpdate;
    }
}