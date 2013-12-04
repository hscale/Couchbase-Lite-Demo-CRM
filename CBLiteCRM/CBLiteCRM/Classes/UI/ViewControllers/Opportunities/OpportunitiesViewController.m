//
//  OpportunitiesViewController.m
//  CBLiteCRM
//
//  Created by Danil on 26/11/13.
//  Copyright (c) 2013 Danil. All rights reserved.
//

#import "OpportunitiesViewController.h"
#import "OpportunityDetailesViewController.h"

//Data
#import "DataStore.h"
#import "OpportunitiesStore.h"
#import "Opportunity.h"

@interface OpportunitiesViewController ()
@property(nonatomic, strong) Opportunity* selectedCellData;

@end

@implementation OpportunitiesViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.selectedCellData = [self opportForPath:indexPath];
    [self performSegueWithIdentifier:@"opportDetails" sender:tableView];
}

- (Opportunity*)opportForPath:(NSIndexPath*)indexPath{
    Opportunity* opp;
    CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
    if (self.filteredSource.count == 0){
        opp = [Opportunity modelForDocument: row.document];
    } else {
        opp = self.filteredSource[indexPath.row];
    }
    return opp;
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[UINavigationController class]] && [sender isKindOfClass:[UITableView class]]){
        UINavigationController* navc = (UINavigationController*)segue.destinationViewController;
        OpportunityDetailesViewController* vc = (OpportunityDetailesViewController*)navc.topViewController;
        vc.currentOpport = self.selectedCellData;
    }
}

- (void) updateQuery
{
    self.dataSource.query = [[[DataStore sharedInstance].opportunitiesStore queryOpportunities] asLiveQuery];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OpportunityCell"];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OpportunityCell"];

    Opportunity *opportunity = self.filteredSource[indexPath.row];
    cell.textLabel.text = [opportunity getValueOfProperty:@"title"];
    return cell;
}

#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredSource removeAllObjects];
    for (CBLQueryRow* row in self.dataSource.rows) {
        Opportunity *opportunity = [Opportunity modelForDocument:row.document];
        NSString *title = [opportunity getValueOfProperty:@"title"];
        if ([title rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound)
            [self.filteredSource addObject:opportunity];
    }
}

@end
