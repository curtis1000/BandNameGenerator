//
//  Word.m
//  BandNameGenerator
//
//  Created by Curtis Branum on 1/25/14.
//  Copyright (c) 2014 Morsekode. All rights reserved.
//

#import "Word.h"

@implementation Word

@dynamic value;
@dynamic classification;
@dynamic status;

// Statuses
NSInteger const NOT_REVIEWED = 1;
NSInteger const DENIED = 2;
NSInteger const APPROVED = 3;

// Classification
NSInteger const ADJECTIVE = 1;
NSInteger const NOUN = 2;

@end
