//
//  CardGame.h
//  Matchismo
//
//  Created by Mario Russo on 2/22/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardGame : NSObject

// designated initializer
-(id) initGameWithNumCards:(NSUInteger)numCards usingDeck:(Deck *)deck;

// read-only display properties
@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int flipCount;
@property (nonatomic, readonly) NSUInteger numDealtCards;
@property (nonatomic, readonly) NSMutableArray *gameHistory;
@property (nonatomic, readonly) NSMutableArray *matchCards;

-(Card *) cardAtIndex:(NSUInteger)index;
-(void) flipCardAtIndex:(NSUInteger)index;
-(void) removeDealtCardAtIndex:(NSUInteger)index;
-(BOOL) deckHasMoreCards;
-(void) dealNewCards:(NSUInteger) numNewCards;
-(void) recordGameAction:(NSString *)gameMove;
-(int) numPlayableFaceUpCards;

// override in subclass if different value/type is required
-(int) flipCost;
-(int) numCardsToMatch;

// abstract - for subclasses to implement (useful for matching and scoring logic or changes to UI)
-(void) doThisActionOnFlippedCard:(Card *)cardJustFlipped;

@end

