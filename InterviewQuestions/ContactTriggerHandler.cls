public class ContactTriggerHandler {
    public static boolean bypassTrigger = false;
	//Trigger to create account if contact is created without account
    public static void insertAccount(List<Contact> contacts){
        List<Account> accList =  new List<Account>();
        Map<Integer, Id> contactIndexMap = new Map<Integer, Id>();
        for(Contact c : contacts){
            if(c.AccountId == null){
                Account a = new Account();
                a.Name =  c.Lastname;
                a.Phone = c.Phone;
                accList.add(a);
                contactIndexMap.put(accList.size()-1, c.id);
            }
        }
        if(accList.size() > 0) insert accList;
        
        List<Contact> updateContact = new List<Contact>();
        for(Integer i=0; i<accList.size(); i++){
            Contact con = new Contact();
            con.AccountId = accList[i].Id;
            con.Id = contactIndexMap.get(i);
            updateContact.add(con);
        }
        if(updateContact.size() > 0) update updateContact;
    }
}