//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Mario Russo on 2/6/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *matchCards;
@property (strong, nonatomic) NSMutableArray *gameHistory;
@property (nonatomic) int score;
@property (nonatomic) int flipCount;
@end

@implementation CardMatchingGame

@synthesize numCardsToMatch = _numCardsToMatch;

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)matchCards
{
    if(!_matchCards) _matchCards = [[NSMutableArray alloc] init];
    return _matchCards;
}

- (NSMutableArray *)gameHistory
{
    if(!_gameHistory) _gameHistory = [[NSMutableArray alloc] init];
    return _gameHistory;
}

- (void) setNumCardsToMatch:(int) numCards
{
    _numCardsToMatch = numCards;
    [self recordGameAction:[NSString stringWithFormat:@"Match %d cards!",self.numCardsToMatch]];
    
}

- (void)recordGameAction:(NSString *)gameMove
{
    [self.gameHistory addObject:gameMove];
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck usingNumCardsToMatch:(int)numToMatch
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
        
        self.numCardsToMatch = numToMatch;
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

- (int) numPlayableFaceUpCards
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

#define FLIP_COST (-1)
#define MISMATCH_PENALTY (-2)
#define MATCH_BONUS (4)

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if(!card.isUnplayable)
    {
        if(!card.isFaceUp)
        {
            self.flipCount++;
            self.score += FLIP_COST;
            [self recordGameAction:[NSString stringWithFormat:@"Flipped: %@", card.contents]];
            
            if(self.numPlayableFaceUpCards == (self.numCardsToMatch-1))
            {
                int totalMoveScore = 0;
                BOOL matchFailed = FALSE;
                NSMutableArray * cardsMatched = [[NSMutableArray alloc] init];
                
                for(Card *thisCard in self.cards)
                {
                    if(thisCard.isFaceUp && !thisCard.isUnplayable && ![card isEqual:thisCard])
                    {
                        [cardsMatched addObject:thisCard];
                        int thisMatchScore = [card match:thisCard];
                        
                        if(thisMatchScore > 0)
                        {
                            matchFailed = FALSE;
                            totalMoveScore += thisMatchScore * MATCH_BONUS;
                        }
                        else
                        {
                            matchFailed = TRUE;
                            totalMoveScore = MISMATCH_PENALTY;
                            break;
                        }
                    }
                }
                
                NSString * action = [[NSString alloc] init];
                
                if(matchFailed)
                {
                    action = [NSString stringWithFormat: @"No match for %@, %@ : %d points", card.contents,[cardsMatched componentsJoinedByString:@", "], totalMoveScore];
                    
                    for(Card *c in cardsMatched)
                    {
                        c.faceUp = NO;
                    }
                }
                else
                {
                    action = [NSString stringWithFormat: @"Matched %@, %@ for %d points!", card.contents, [cardsMatched componentsJoinedByString:@", "], totalMoveScore];
                    
                    card.unplayable = YES;
                    
                    for(Card *c in cardsMatched)
                    {
                        c.faceUp = c.unplayable = YES;
                    }
                }
                
                self.score += totalMoveScore;
                [self recordGameAction:action];
                [cardsMatched removeAllObjects];
            }
        }
        
        card.faceUp = !card.isFaceUp;
    }
}

@end
