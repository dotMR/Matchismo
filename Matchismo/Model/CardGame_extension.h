//
//  CardGame_CardGame_extension.h
//  Matchismo
//
//  Created by Mario Russo on 2/22/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "CardGame.h"

@interface CardGame ()

// redeclaring as writable for subclasses
@property (nonatomic) int score;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) NSMutableArray *gameHistory;

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *matchCards;
@end
