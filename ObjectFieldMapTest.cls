Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Recurring_Gift__c').getDescribe().fields.getMap();
Map<String, String> updatedFieldMap = new Map<String, String>();
for(String st: fieldMap.keySet()){
	updatedFieldmap.put(st, fieldMap.get(st).getDescribe().getLabel());
}

String prefix = Recurring_Gift__c.SObjectType.getDescribe().getKeyPrefix();
PageReference pageToLook = new PageReference(baseURL(prefix, null));
String html = pageToLook.getContent().toString();
Matcher m = Pattern.compile('<label for="(.*?)">(<span class="requiredMark">\\*</span>)?(.*?)</label>').matcher(html);
Map<String, String> labelToField = new Map<String, String>();

while(m.find()){
	System.debug(m.group(3) + ' ----> ' + m.group(1));
}

private static String baseUrl(String keyPrefix, Id recordTypeID){
	return '/' + keyPrefix + '/e?RecordType=' + (recordTypeID == null ? '' : recordTypeID);
}