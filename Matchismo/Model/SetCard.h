//
//  SetCard.h
//  Matchismo
//
//  Created by Mario Russo on 2/13/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *fillPattern;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validRanks;
+ (NSArray *)validColors;
+ (NSArray *)validFillPatterns;
+ (NSArray *)validShapes;
- (int)matchCards:(NSArray *)cardsToCompare;

+ (NSUInteger)maxRank;

@end
