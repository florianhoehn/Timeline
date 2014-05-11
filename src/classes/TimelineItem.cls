/**
* @author Florian Hoehn
* @date 11/05/2014
* @description wrapper class for the timelineItems
*/
public class TimelineItem {
  /**
  * @description
  */
  public String type {get; set;}

  /**
  * @description
  */
  public String timelineDate {get; set;}

  /**
  * @description
  */
  //public TimelineUser owner {get; set;}

  /**
  * @description
  */
  public String json {get; set;}

  /**
  * @author Florian Hoehn
  * @date 11/05/2014
  * @description constructor
  */
  public TimelineItem(SObject timelineObject, Timeline_Definition__c timelineDefinition) {
    //this.type = timelineObject.getSObjectType();
    //this.timelineDate = timelineObject.get(timelineDefinition.Timeline_Date_API_Name__c);
    //this.owner = new TimelineUser()
    this.json = System.JSON.serialize(timelineObject);
  }
}