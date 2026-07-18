public class AccountTriggerHandler {
    //Account trigger to set account rating as'hot' if industry is banking or healthcare
    public static void updateRating(List<Account> accList){
        for(Account a : accList){
            if(a.Industry == 'Banking' || a.Industry == 'Healthcare') a.rating = 'Hot';
        }
    }
}