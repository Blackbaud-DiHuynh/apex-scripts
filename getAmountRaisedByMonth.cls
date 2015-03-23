TeamRaiserProgressWidgetController controller = new TeamRaiserProgressWidgetController();
List<AggregateResult> totalAmountPerMonth = 
			[SELECT SUM(Amount) totalRaised, 
				calendar_month(CloseDate) month, 
				calendar_year(CloseDate) year, 
				StageName stage
			FROM Opportunity 
			WHERE TeamRaiser_Registration__c='a0jo0000001I18l'
			GROUP BY calendar_year(CloseDate) , calendar_month(CloseDate), StageName
			ORDER BY calendar_year(CloseDate), calendar_month(CloseDate)];

List<Date> allMonths = TeamRaiserProgressWidgetController.convertAggregatesToDates(totalAmountPerMonth);
List<Date> displayMonths = TeamRaiserProgressWidgetController.getDisplayMonths(allMonths.get(allMonths.size()-1));
List<String> formattedDisplayMonths = TeamRaiserProgressWidgetController.getFormattedMonths(displayMonths);

System.debug(TeamRaiserProgressWidgetController.getAmountRaisedByDisplayMonth (totalAmountPerMonth, displayMonths, 'Received'));	
