//
//  SFLegislatorVotingRecordTableViewController.m
//  Congress
//
//  Created by Daniel Cloud on 6/5/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import "SFLegislatorVotingRecordTableViewController.h"
#import "SFRollCallVote.h"
#import "SFLegislator.h"
#import "SFTableCell.h"
#import "SFCellData.h"
#import "SFCellDataTransformers.h"
#import "SFVoteDetailViewController.h"
#import "SFDateFormatterUtil.h"

SFDataTableSectionTitleGenerator const votedAtTitleBlock = ^NSArray*(NSArray *items) {
    NSArray *possibleSectionTitleValues = [items valueForKeyPath:@"votedAt"];
    possibleSectionTitleValues = [possibleSectionTitleValues sortedArrayUsingDescriptors:
                                  @[[NSSortDescriptor sortDescriptorWithKey:@"timeIntervalSince1970" ascending:NO]]];
    NSMutableArray *sectionTitleStrings = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
    for (NSDate *date in possibleSectionTitleValues) {
        [sectionTitleStrings addObject:[dateFormatter stringFromDate:date]];
    }
    NSOrderedSet *sectionTitlesSet = [NSOrderedSet orderedSetWithArray:sectionTitleStrings];
    return [sectionTitlesSet array];
};
SFDataTableSortIntoSectionsBlock const votedAtSorterBlock = ^NSUInteger(id item, NSArray *sectionTitles) {
    NSDateFormatter *dateFormatter = [SFDateFormatterUtil mediumDateNoTimeFormatter];
    NSString *dateString = [dateFormatter stringFromDate:((SFRollCallVote *)item).votedAt];
    NSUInteger index = [sectionTitles indexOfObject:dateString];
    if (index != NSNotFound) {
        return index;
    }
    return 0;
};

@interface SFLegislatorVotingRecordTableViewController ()

@end

@implementation SFLegislatorVotingRecordTableViewController

@synthesize legislator;

- (void)viewDidLoad {
    [super viewDidLoad];

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Vote List Screen"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

#pragma mark - Table view data source

// SFDataTableViewController doesn't handle this method currently
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return nil;

    SFRollCallVote *vote  = (SFRollCallVote *)[self.dataProvider itemForIndexPath:indexPath];
    if (!vote) return nil;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFRollCallVoteByLegislatorCellTransformerName];
    NSDictionary *value = @{@"vote":vote, @"legislator":self.legislator};
    SFCellData *cellData = [valueTransformer transformedValue:value];

    SFTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[SFTableCell defaultCellIdentifer]];
    [cell setCellData:cellData];
    if (cellData.persist && [cell respondsToSelector:@selector(setPersistStyle)]) {
        [cell performSelector:@selector(setPersistStyle)];
    }
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    [cell setFrame:CGRectMake(0, 0, cell.width, cellHeight)];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFVoteDetailViewController *detailViewController = [[SFVoteDetailViewController alloc] initWithNibName:nil bundle:nil];
    SFRollCallVote *vote  = (SFRollCallVote *)[self.dataProvider itemForIndexPath:indexPath];

    detailViewController.vote = vote;

    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SFBill *vote  = (SFBill *)[self.dataProvider itemForIndexPath:indexPath];
    if (!vote) return 0;
    NSValueTransformer *valueTransformer = [NSValueTransformer valueTransformerForName:SFRollCallVoteByLegislatorCellTransformerName];
    NSDictionary *value = @{@"vote":vote, @"legislator":self.legislator};
    SFCellData *cellData = [valueTransformer transformedValue:value];
    CGFloat cellHeight = [cellData heightForWidth:self.tableView.width];
    return cellHeight;
}

#pragma mark - UIDataSourceModelAssociation protocol

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    SFRollCallVote *vote;
    if ([self.dataProvider.sections count] == 0) {
        vote = (SFRollCallVote *)[self.dataProvider.items objectAtIndex:idx.row];
    }
    else
    {
        vote = (SFRollCallVote *)[[self.dataProvider.sections objectAtIndex:idx.section] objectAtIndex:idx.row];
    }
    return vote.remoteID;
}

@end
