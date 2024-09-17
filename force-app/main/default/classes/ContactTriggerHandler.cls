public class ContactTriggerHandler {
    public static void afterUpdate(List<Contact> contactList) {
        // Step 1: Collect Account Ids from updated Contacts
        Set<Id> accountIds = new Set<Id>();
        for (Contact c : contactList) {
            if (c.AccountId != null) {
                accountIds.add(c.AccountId);
            }
        }
        System.debug('Account Ids: ' + accountIds);

        // Step 2: Query related Accounts with Contacts
        List<Account> accounts = [SELECT Id, Name, Phone,
         (SELECT Id, FirstName, LastName, Phone, AccountId FROM Contacts) 
         FROM Account WHERE Id IN :accountIds];
        
        List<Account> accountsToUpdate = new List<Account>(); // Create a separate list to hold the updated accounts

        // Step 3: Update Account Phone with Contact Phone
        for (Account a : accounts) {
            if (!a.Contacts.isEmpty()) {
                for (Contact c : a.Contacts) {
                    if (c.Phone != null) {
                        a.Phone = c.Phone;
                        accountsToUpdate.add(a); // Add the account to the update list
                    }
                }
            }
        }

        // Step 4: Perform the update operation
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

        public static void afterAccountUpdated(List<Account> accountList) {
            // Step 1: Collect Account Ids from updated Accounts
            Set<Id> accountIds = new Set<Id>();
            for (Account acc : accountList) {
                if (acc.Id != null && acc.Phone != null) {
                    accountIds.add(acc.Id);
                }
            }

            // Step 2: Query related Accounts with Contacts
            List<Account> accounts = [SELECT Id, Name, Phone,
             (SELECT Id, FirstName, LastName, Phone, AccountId FROM Contacts) 
             FROM Account WHERE Id IN :accountIds];

            List<Contact> contactList = new List<Contact>(); // Create a separate list to hold the contacts to be updated
            // Step 3: Update Contact Phone with Account Phone
            for (Account a : accounts) {
                if (!a.Contacts.isEmpty()) {
                    for (Contact c : a.Contacts) {
                        if (a.Phone != null) {
                            c.Phone = a.Phone;
                            contactList.add(c); // Add the contact to the update list
                        }
                    }
                }
            }

            // Step 4: Perform the update operation
            if (!contactList.isEmpty()) {
                if (Schema.sObjectType.Contact.isUpdateable()) {
                    update contactList;
                }
            }
        }
}