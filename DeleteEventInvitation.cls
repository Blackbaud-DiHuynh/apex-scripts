List<Event_Invitation__c> allInvites = [SELECT Id, Event__c FROM Event_Invitation__c WHERE Event__c='a0Go000000BWZ9Y'];

delete allInvites;