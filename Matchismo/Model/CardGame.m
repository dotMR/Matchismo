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

// subclass extended interface in _extension file above

@implementation CardGame

#define FLIP_COST (-1)
#define NUM_CARDS_TO_MATCH (2)

-(NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableArray *)gameHistory
{
    if(!_gameHistory) _gameHistory = [[NSMutableArray alloc] init];
    return _gameHistory;
}

-(int) flipCost
{
    return FLIP_COST;
}

-(int) numCardsToMatch
{
    return NUM_CARDS_TO_MATCH;
}

-(void)recordGameAction:(NSString *)gameMove
{
    [self.gameHistory addObject:gameMove];
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
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
            
            // hook for subclasses
            [self doThisActionOnFlippedCard:card];
        }
        
        card.faceUp = !card.isFaceUp;
    }
}

-(int) numPlayableFaceUpCards
{
    int numCards = 0;
    
    for(Card *card in self.cards)
    {
        if(card.isFaceUp && !card.isUnplayable)
        {
            numCards++;
        }
    }
    
    return numCards;
}

-(void) doThisActionOnFlippedCard:(Card *)cardJustFlipped
{
    [self recordGameAction:[NSString stringWithFormat:@"Flipped: %@", cardJustFlipped.contents]];
}

// designated initializer
-(id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    
    if(self) {
        for(int i=0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            
            if(!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    
    self.gameHistory = nil;
    [self recordGameAction:[NSString stringWithFormat:@"New Game!"]];    
    
    return self;
}

@end
