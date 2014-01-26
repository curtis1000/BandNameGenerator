//
//  Word.h
//  BandNameGenerator
//
//  Created by Curtis Branum on 1/25/14.
//  Copyright (c) 2014 Morsekode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSNumber * classification;
@property (nonatomic, retain) NSNumber * status;

@end
