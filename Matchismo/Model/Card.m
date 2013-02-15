//
//  Card.m
//  Matchismo
//
//  Created by Mario Russo on 2/6/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "Card.h"

@implementation Card

- (NSString *) description
{
    return self.contents;
}

- (int)match:(Card *)otherCard
{
    int score = 0;
    
    if([otherCard.contents isEqualToString:self.contents]) {
        score = 1;
    }
    
    return score;
}

@end
