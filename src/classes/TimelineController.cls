/**
* @author Florian Hoehn
* @date 11/05/2014
* @description component controller to select timeline data
*/
public with sharing class TimelineController {
  /**
  * @description name of the Timeline that is used for the component
  */
  public String timelineName {get; set;}

  /**
  * @description id of the record for the parent record for the timeline
  */
  public Id timelineParentId {get; set;}

  /**
  * @description trigger
  */
  public String doThis {
    get {
      this.timelineItems = new List<TimelineItem>();
      this.getTimelineDefinitionsToAddToTimelineItems();
      return 'done';
    }
  }

  /**
  * @description items for the timeline
  */
  public List<TimelineItem> timelineItems {get; set;}

  /**
  * @author Florian Hoehn
  * @date 11/05/2014
  * @description constructor
  */
  public TimelineController() {}

  /**
  * @author Florian Hoehn
  * @date 11/05/2014
  * @description gets all timelineDefinitions, selects the sObjects and adds them to the timelineItems
  */
  private void getTimelineDefinitionsToAddToTimelineItems() {
    Timeline__c timeline = [SELECT Id,
                                   (SELECT Id, SObject_API_Name__c, Record_Type_Name__c,
                                           Timeline_Date_API_Name__c, Field_API_Names__c,
                                           Lookup_API_Name__c
                                      FROM Timeline_Definition__r)
                              FROM Timeline__c
                             WHERE Name =: this.timelineName
                             LIMIT 1];
    for(Timeline_Definition__c timelineDefinition : timeline.Timeline_Definition__r) {
      this.addTimelineItems(timelineDefinition);
    }
  }

  /**
  * @author Florian Hoehn
  * @date 11/05/2014
  * @description adds selected sObjects to timelineItems
  * @param Timeline_Definition__c timelineDefinition  defines the fields and sObject for the query
  */
  private void addTimelineItems(Timeline_Definition__c timelineDefinition) {
    for(SObject timelineObject : Database.query(this.getQueryStringForTimelineDefinition(timelineDefinition))) {
      TimelineItem timelineItem = new TimelineItem(timelineObject, timelineDefinition);
      timelineItems.add(timelineItem);
    }
  }

  /**
  * @author Florian Hoehn
  * @date 11/05/2014
  * @description gets query string for the SOQL of the timelineDefinitions
  * @return String query  returns query for this timelineDefinitions
  * @param Timeline_Definition__c timelineDefinition  defines the fields and sObject for the query
  */
  private String getQueryStringForTimelineDefinition(Timeline_Definition__c timelineDefinition) {
    String query = 'SELECT ' + timelineDefinition.Field_API_Names__c.replaceAll(';', ',') +
                   ' FROM ' + timelineDefinition.SObject_API_Name__c  +
                   ' WHERE ' + timelineDefinition.Lookup_API_Name__c + '=\'' + this.timelineParentId + '\'' +
                   (timelineDefinition.Record_Type_Name__c != null ? ' AND RecordType.Name = \'' + timelineDefinition.Record_Type_Name__c + '\'' : '') +
                   ' ORDER BY ' + timelineDefinition.Timeline_Date_API_Name__c + ' DESC LIMIT 1';
    return query;
  }
}