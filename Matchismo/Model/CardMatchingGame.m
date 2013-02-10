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

#define FLIP_COST -1;
#define MISMATCH_PENALTY -2;
#define MATCH_BONUS 4;

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if(!card.isUnplayable)
    {
        if(card.isFaceUp)
        {
            [self.matchCards removeObject:card];
        }
        else
        {
            self.flipCount++;
            self.score += FLIP_COST;
            [self.matchCards addObject:card];
            [self recordGameAction:[NSString stringWithFormat:@"Flipped: %@", card.contents]];
            
            if(self.matchCards.count == self.numCardsToMatch)
            {
                int matchScore = 0;
                int totalMoveScore = 0;
                
                if(self.matchCards.count == 2)
                {
                    Card *otherCard = [self.matchCards objectAtIndex:0];
                    matchScore = [card match:otherCard];
                    
                    if(matchScore > 0)
                    {
                        otherCard.unplayable = card.unplayable = YES;
                        
                        totalMoveScore = matchScore * MATCH_BONUS;
                        self.score += totalMoveScore;
                        
                        [self recordGameAction:[NSString stringWithFormat:@"Matched %@ with %@ : %d points!", card.contents, otherCard.contents, totalMoveScore]];
                        [self.matchCards removeObject:otherCard];
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        
                        totalMoveScore = MISMATCH_PENALTY;
                        self.score += totalMoveScore;
                        
                        [self recordGameAction:[NSString stringWithFormat:@"No match! %@ with %@ : %d points", card.contents, otherCard.contents, totalMoveScore]];
                    }
                    
                    [self.matchCards removeObject:card];
                }
                else if(self.matchCards.count == 3)
                {
                    Card * c1 = [self.matchCards objectAtIndex:0];
                    Card * c2 = [self.matchCards objectAtIndex:1];

                    int m1 = [card match:c1];
                    int m2 = [card match:c2];
                    int m3 = [c1 match:c2];
                    
                    if (m1>0 && m2>0 && m3>0)
                    {
                        card.unplayable = c1.unplayable = c2.unplayable = YES;
                        
                        totalMoveScore += m1 * MATCH_BONUS;
                        totalMoveScore += m2 * MATCH_BONUS;
                        totalMoveScore += m3 * MATCH_BONUS;
                        self.score += totalMoveScore;
                        
                        [self recordGameAction:[NSString stringWithFormat:@"Matched %@, %@, %@ : %d points!", card.contents, c1.contents, c2.contents, totalMoveScore]];
                        [self.matchCards removeObject:c1];
                        [self.matchCards removeObject:c2];
                    }
                    else
                    {
                        c1.faceUp = c2.faceUp = NO;
                        
                        totalMoveScore = MISMATCH_PENALTY;
                        self.score += totalMoveScore;
                        
                        [self recordGameAction:[NSString stringWithFormat:@"No match for %@, %@, %@ : %d points", card.contents, c1.contents, c2.contents, totalMoveScore]];
                        
                        [self.matchCards removeObject:c1];
                    }
                    
                    [self.matchCards removeObject:card];
                }
            }
        }
        
        card.faceUp = !card.isFaceUp;
    }
}

@end
