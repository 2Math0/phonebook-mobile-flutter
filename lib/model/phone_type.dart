Map<String, int> mapPhoneType = {
  'Mobile': 1,
  'Personal': 2,
  'Business': 3,
  'other': 4,
  // 'Family': 8,
  // 'Home': 5,
  // 'Main': 6,
  // 'Work Fax': 7,
};

List<String> phoneType = (mapPhoneType.keys).toList();
List<int> phoneValues = (mapPhoneType.values).toList();


// IterableZip should be used
// this map made to represent the type for Contact Card by type_id in the cloud
Map<int, String> mapPhoneTypeViewer = {
  1: 'Mobile',
  2: 'Personal',
  3: 'Business',
  4: 'other',
  // 8: 'Family',
  // 5: 'Home',
  // 6: 'Main',
  // 7: 'Work Fax',

};
