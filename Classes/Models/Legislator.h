//
//  Legislator.h
//  Congress
//
//  Created by Daniel Cloud on 1/8/13.
//  Copyright (c) 2013 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SynchronizedObject.h"


@interface Legislator : SynchronizedObject <SynchronizedObject>

@property (nonatomic, retain) NSString * bioguide_id;
@property (nonatomic, retain) NSString * crp_id;
@property (nonatomic, retain) NSString * chamber;
@property (nonatomic, retain) NSString * congress_office;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * govtrack_id;
@property (nonatomic, retain) NSNumber * district;
@property (nonatomic) BOOL in_office;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * middle_name;
@property (nonatomic, retain) NSString * name_suffix;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * state_abbr;
@property (nonatomic, retain) NSString * state_name;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * twitter_id;
@property (nonatomic, retain) NSURL * website;
@property (nonatomic, retain) NSURL * youtube_url;
@property (nonatomic, retain) NSURL * contact_form;


@property (readonly) NSString *full_name;
@property (readonly) NSString *titled_name;
@property (readonly) NSString *party_name;
@property (readonly) NSString *full_title;

@end
