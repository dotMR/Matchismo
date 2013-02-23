//
//  Card.h
//  Matchismo
//
//  Created by Mario Russo on 2/6/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;

- (int)match:(Card *)otherCard;

@end
