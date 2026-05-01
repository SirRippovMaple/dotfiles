#!/bin/bash
# <swiftbar.title>GUS Sprint</swiftbar.title>

SPRINT=$(sf data query --target-org gus --query "
  SELECT Name FROM ADM_Sprint__c
  WHERE Scrum_Team__c IN (
    SELECT Id FROM ADM_Scrum_Team__c WHERE Name = 'CDP Strategic Partners'
  )
  AND Start_Date__c <= TODAY AND End_Date__c >= TODAY
" --json 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(d['result']['records'][0]['Name'])" 2>/dev/null)

echo "${SPRINT:-Sprint ???}"
