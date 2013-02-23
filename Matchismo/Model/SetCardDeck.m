//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Mario Russo on 2/13/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (NSString *color in [SetCard validColors]) {
                for (NSString *fill in [SetCard validFillPatterns]) {
                    for (NSUInteger rank = 1; rank < ([SetCard maxRank] + 1); rank++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.color = color;
                        card.fillPattern = fill;
                        card.shape = shape;
                        card.rank = rank;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
