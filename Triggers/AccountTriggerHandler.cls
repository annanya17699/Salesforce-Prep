public class AccountTriggerHandler {
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
    
    public static void restrictActiveAccDel(List<Account> accList){
        for(Account a : accList){
            if(a.Active__c == 'Yes') a.addError('Active account cannot be deleted');
        }
    }
    
    public static void verifyRevenue(List<Account> accList){
        for (Account a : accList) {
            if(a.AnnualRevenue < 1000){
                a.addError('Annual Revenue cannot be less than 1000');
            }    
        }
    }
    
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
    
    public static void restrictActiveAccNameModification(List<Account> accList, Map<Id, Account> idVsAccMap){
        for(Account a : accList){
            if(idVsAccMap.get(a.Id).Name != a.Name) a.addError('Account name cannot be modified');
        }
    }
    
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