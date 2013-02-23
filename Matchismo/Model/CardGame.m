//
//  CardGame.m
//  Matchismo
//
//  Created by Mario Russo on 2/22/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "CardGame.h"
#import "CardGame_extension.h"
#import "Deck.h"

// NOTE: extended interface for subclasses in _extension file above

@implementation CardGame

-(NSMutableArray *)dealtCards
{
    if(!_dealtCards) _dealtCards = [[NSMutableArray alloc] init];
    return _dealtCards;
}

-(NSMutableArray *)gameHistory
{
    if(!_gameHistory) _gameHistory = [[NSMutableArray alloc] init];
    return _gameHistory;
}

-(int) flipCost
{
    #define FLIP_COST (-1)
    return FLIP_COST;
}

-(int) numCardsToMatch
{
    #define NUM_CARDS_TO_MATCH (2)
    return NUM_CARDS_TO_MATCH;
}

-(void)recordGameAction:(NSString *)gameMove
{
    [self.gameHistory addObject:gameMove];
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.dealtCards.count) ? self.dealtCards[index] : nil;
}

-(void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if(!card.isUnplayable)
    {
        if(!card.isFaceUp)
        {
            self.flipCount++;
            self.score += [self flipCost];
            
            [self recordGameAction:[NSString stringWithFormat:@"Flipped: %@", card.contents]];
            
            // hook for subclasses
            [self doThisActionOnFlippedCard:card];
        }
        
        card.faceUp = !card.isFaceUp;
    }
}

-(void) removeDealtCardAtIndex:(NSUInteger)index
{
    [self.dealtCards removeObject:[self cardAtIndex:index]];
}

-(void) dealNewCards:(NSUInteger) numNewCards
{
    for (int i=0; i<numNewCards; i=i+1) { [self dealCard]; }
    [self recordGameAction: [NSString stringWithFormat:@"Dealt %d Cards", numNewCards]];
    
    if( ![self deckHasMoreCards] ) { [self recordGameAction:@"The Deck is Empty"]; }
}

-(BOOL) deckHasMoreCards
{
    return ![self.deck isEmpty];
}

-(void) dealCard
{
    Card *newCard = [self.deck drawRandomCard];
    
    if(newCard)
    {
        [self.dealtCards addObject:newCard];
    }
}

- (NSUInteger) numDealtCards
{
    return [self.dealtCards count];
}

-(int) numPlayableFaceUpCards
{
    int numCards = 0;
    
    for(Card *card in self.dealtCards)
    {
        if(card.isFaceUp && !card.isUnplayable)
        {
            numCards++;
        }
    }
    
    return numCards;
}

// designated initializer
-(id) initGameWithNumCards:(NSUInteger)numCards usingDeck:(Deck *)deck
{
    self = [super init];
    self.deck = deck;
    
    if(self) {
        for(int i=0; i < numCards; i++) {
            Card *card = [self.deck drawRandomCard];
            
            if(!card) {
                self = nil;
            } else {
                self.dealtCards[i] = card;
            }
        }
    }
    
    self.gameHistory = nil;
    [self recordGameAction:[NSString stringWithFormat:@"New Game!"]];    
    
    return self;
}

// abstract hook for subclasses
-(void) doThisActionOnFlippedCard:(Card *)cardJustFlipped { }
-(void) doThisActionToUpdateUI { }

@end
