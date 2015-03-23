MetadataService.MetadataPort service = MetadataUtils.createService();		
List<String> profileNames = new List<String>();

Profile[] ps = [SELECT Id, Name FROM Profile];

for (Profile p: ps){
    profileNames.add(p.Name);
}


MetadataService.Profile[] profiles = (MetadataService.Profile[]) service.readMetadata('Profile', getSubList(0,10,profileNames)).getRecords();

for (MetadataService.Profile profile: profiles){
    System.debug('Profile: ' + profile.fullName);

}

/// start to end-1
public static List<String> getSubList(Integer start, Integer last, List<String> bigList){
    List<String> ans = new List<String>();
    Integer i = 0;
    for (i = start; i < last; i++){
        ans.add(bigList.get(i));
    }
    return ans;
}