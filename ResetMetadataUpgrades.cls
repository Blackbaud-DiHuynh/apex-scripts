MetadataService.MetadataPort service = MetadataUtils.createService();


//undo12_9();
undo12_10();
//undo12_11();

// need to manually change this because we can't update anything in the DB between API callouts
//ProtectedSettingsUtils.setLastUpgradeRun('12.10');

/********************************************************************************************/
public void undo12_9(){
	List<String> customObjects12_9 = new List<String>{
		'Account', 'Campaign'
	};
	List<MetadataService.CustomObject> requestedObjects = (List<MetadataService.CustomObject>)
		service.readMetadata('CustomObject', customObjects12_9).getRecords();

	undoAccountDupeCheck(requestedObjects[0]);
	undoCampaignCreateButton(requestedObjects[1]);
	service.updateMetadata(requestedObjects);
}

public void undo12_10(){
	//undo contact summary page
	List<String> layoutNames = new List<String>();
	MetadataUtils.addLayoutsWithStartingValues('Contact-', layoutNames, service);
	List<MetadataService.Layout>requestedLayouts = (List<MetadataService.Layout>) service.readMetadata('Layout', layoutNames).getRecords();

	for (MetadataService.Layout layout :requestedLayouts){
		MetadataService.LayoutSection contactSummarySection = getSectionFromLayout('Contact Summary Section', layout);
		if (contactSummarySection != null){
			layout.layoutSections.remove(0);
		}
	}
	service.updateMetadata(requestedLayouts);
}

public void undo12_11(){
	List<String> layoutNames = new List<String>{
		MetadataUtils.addNamespaceToCustomObjectLayout('TeamRaiser_Registration__c-TeamRaiser Registration Layout'),
		'Opportunity-Pledge Installment',
		'Opportunity-Single Cash Gift Donation Layout',
		'Opportunity-Recurring Donation'
	};

	List<MetadataService.Layout>requestedLayouts = (List<MetadataService.Layout>) service.readMetadata('Layout', layoutNames).getRecords();

	undoFundraisingGoal(requestedLayouts[0]);		
	undoTeamRaiserProgressWidget(requestedLayouts[0]);
	undoMatchingGift(requestedLayouts);
	service.updateMetadata(requestedLayouts);
}

public MetadataService.LayoutSection getSectionFromLayout(String sectionLabel, MetadataService.Layout layout){
	if (layout.layoutSections != null){
		for(MetadataService.LayoutSection section : layout.layoutSections){
			if (sectionLabel.equals(section.label)){
				return section;
			}
		}
	}
	return null;
}

public void undoAccountDupeCheck(MetadataService.CustomObject acc){
	MetadataService.ActionOverride oldAction = new MetadataService.ActionOverride();
	oldAction.actionName = 'New';
	oldAction.content = Utils.addNamespace('Account_Dupe_Check_Widget');
	oldAction.type_x = 'Scontrol';
	oldAction.comment = '';

	for (MetadataService.ActionOverride action : acc.actionOverrides){
		if (action.actionName == oldAction.actionName){
			action.content = oldAction.content;
			action.comment = oldAction.comment;
			action.type_x = oldAction.type_x;
		}
	}
}

public void undoCampaignCreateButton(MetadataService.CustomObject campaign){
	MetadataService.ActionOverride oldAction = new MetadataService.ActionOverride();
	oldAction.actionName = 'New';
	oldAction.content = Utils.addNamespace('Campaign_Create_Button');
	oldAction.type_x = 'Scontrol';
	oldAction.comment = '';

	for (MetadataService.ActionOverride action : campaign.actionOverrides){
		if (action.actionName == oldAction.actionName){
			action.content = oldAction.content;
			action.comment = oldAction.comment;
			action.type_x = oldAction.type_x;
		}
	}
}

public void undoFundraisingGoal(MetadataService.Layout layout){
	MetadataService.LayoutColumn col = getColumnContainingField(layout, 'Fundraising_Goal__c');
	Integer layoutItemsIndex = getFieldIndex('Fundraising_Goal__c', col);
	col.layoutItems.remove(layoutItemsIndex);
}

public void undoTeamRaiserProgressWidget(MetadataService.Layout layout){
	String sectionLabel = 'TeamRaiser Progress';
	if (layout.layoutSections != null){
		for(Integer sectionIndex = 0; sectionIndex < layout.layoutSections.size(); sectionIndex++){
			if (sectionLabel.equals(layout.layoutSections.get(sectionIndex).label)){
				layout.layoutSections.remove(sectionIndex);
				break;
			}
		}
	}
}

public void undoMatchingGift(List<MetadataService.Layout> layouts){
    for (MetadataService.Layout layout : layouts){
        if (!layout.fullName.contains('TeamRaiser')){
            if(layout.layoutSections != null){
                MetadataService.LayoutSection section = MetadataUtils.getSectionFromLayout('Matching Gift', layout);
                MetadataService.LayoutColumn column = section.layoutColumns[1];
				for (Integer i = 0; i < column.layoutItems.size(); i++){
                    if (column.layoutItems.get(i).page_x == Utils.addNamespace('Donation_Matching_Gift_Create_Button')){
                        System.debug('Remove matching gift page from ' + layout.fullName + ' at index ' + i);
                        column.layoutItems.remove(i);
                        break;
                    }
                }
                System.debug('Adding matching gift scontrol to ' + layout.fullName);
                column.layoutItems.add(getLayoutItemForMatchingGift());
            }
    	}        
    }
}

public MetadataService.LayoutItem getLayoutItemForMatchingGift(){
    MetadataService.LayoutItem item = new MetadataService.LayoutItem();
	item.height = 25;
	item.scontrol = Utils.addNamespace('Donation_Matching_Gift_Create_Button');
	item.showLabel = false;
	item.showScrollbars = false;
	item.width = '100%';
	return item;
}

public static MetadataService.LayoutColumn getColumnContainingField(MetadataService.Layout layout, String field){
	if(layout.layoutSections != null){
		for(MetadataService.LayoutSection section : layout.layoutSections){
			if (section.layoutColumns != null){
				for(MetadataService.LayoutColumn column : section.layoutColumns){
					if(column.layoutItems != null){
						for(MetadataService.LayoutItem item : column.layoutItems){
							if(item.field != null && item.field.equals(field)){
								return column;
							}
						}
					}
				}
			}
		}
	}
	return null;
}

public static Integer getFieldIndex(String fieldName, MetadataService.LayoutColumn column){
	if(column.layoutItems == null){
		return -1;
	}
	for(Integer index = 0; index < column.layoutItems.size(); index++){
		MetadataService.LayoutItem layoutItem = column.layoutItems.get(index);
		if(layoutItem.field == fieldName){
			return index;
		}
	}
	return -1;
}