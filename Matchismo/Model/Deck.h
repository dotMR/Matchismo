//
//  Deck.h
//  Matchismo
//
//  Created by Mario Russo on 2/6/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;


@end
