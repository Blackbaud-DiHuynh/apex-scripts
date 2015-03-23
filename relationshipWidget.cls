MetadataService.MetadataPort service = MetadataUtils.createService();

List<String> layoutNames = new List<String>{
	Utils.addNamespace('Contact-Household Contact Layout'),
	Utils.addNamespace('Contact-Organization Contact Layout'),
	Utils.addNamespace('Account-Organization Account Layout')};

List<MetadataService.Layout> requestedLayouts = (List<MetadataService.Layout>)service.readMetadata('Layout', layoutNames).getRecords();

MetadataUtils.modifiedLayouts = new Map<String, MetadataService.Layout>();

// removing the old widget from all three layou
for (MetadataService.Layout layout: requestedLayouts){
    if (layout.fullName.contains('Contact')){
        MetadataUtils.removeSControlFromLayout(layout, 'Relationship_Contact_Tree_Widget');
    }
    else {
        MetadataUtils.removeSControlFromLayout(layout, 'Relationship_Account_Tree_Widget');
    }
}

//getting the layoutItem 
MetadataService.LayoutItem relationshipContactTreeItem = getRelationshipTreeLayoutItemForPage('Relationship_Contact_Tree');
MetadataService.LayoutItem relationshipAccountTreeItem = getRelationshipTreeLayoutItemForPage('Relationship_Account_Tree');

System.debug('0 modifiedLayouts: ' + MetadataUtils.modifiedLayouts.values());


// now modifiedLayouts should have all of the layouts that has Relationship_Contact_Tree_Widget removed
for (MetadataService.Layout l : MetadataUtils.modifiedLayouts.values()){
    if (l.fullName.contains('Contact')){
        MetadataUtils.addPagesToLayout(l, 'Relationships', new List<MetadataService.LayoutItem>{relationshipContactTreeItem});
    }
    else {
        MetadataUtils.addPagesToLayout(l, 'Relationships', new List<MetadataService.LayoutItem>{relationshipAccountTreeItem});
    }
}

System.debug('1 modifiedLayouts: ' + MetadataUtils.modifiedLayouts.values());

System.debug(service.updateMetadata(MetadataUtils.modifiedLayouts.values()));


public static MetadataService.LayoutItem getRelationshipTreeLayoutItemForPage (String page){
    MetadataService.LayoutItem item = new MetadataService.LayoutItem();
    item.height = 380;
    item.page_x = Utils.addNamespace(page);
    item.showLabel = false;
    item.width = '100%';
    return item;
}
