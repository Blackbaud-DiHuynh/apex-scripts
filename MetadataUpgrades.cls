MetadataService.MetadataPort service = MetadataUtils.createService();


List<String> layoutNames = new List<String>{
	MetadataUtils.addNamespace('Contact-Household Contact Layout'),
	MetadataUtils.addNamespace('Contact-Organization Contact Layout'),
	MetadataUtils.addNamespace('Account-Organization Account Layout')};

List<MetadataService.Layout> requestedLayouts = (List<MetadataService.Layout>)
service.readMetadata('Layout', layoutNames).getRecords();

MetadataService.QuickAction addRelationshipForContact = MobileUpgrades.getAddRelationshipAction('Contact.Add_Relationship_From_Contact', 'MobileAddRelationshipFromContact');

MetadataService.QuickAction addRelationshipForAccount = MobileUpgrades.getAddRelationshipAction('Account.Add_Relationship_From_Account', 'MobileAddRelationshipFromAccount');

service.updateMetadata(new List<MetadataService.Layout>{hhLayout});
