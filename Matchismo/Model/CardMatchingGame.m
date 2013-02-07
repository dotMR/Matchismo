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
@property (strong, nonatomic) NSMutableArray *gameHistory;
@property (nonatomic) int score;
@property (nonatomic) int flipCount;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)gameHistory
{
    if(!_gameHistory) _gameHistory = [[NSMutableArray alloc] init];
    return _gameHistory;
}

- (void)recordGameAction:(NSString *)gameMove
{
    [self.gameHistory addObject:gameMove];
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
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
    int moveScore;
    
    if(!card.isUnplayable) {
        
        if(!card.isFaceUp) {
            self.flipCount++;
            moveScore = FLIP_COST;
            self.score += moveScore;
            
            [self recordGameAction:[NSString stringWithFormat:@"Found %@ : %d points", card.contents, moveScore]];
            
            for (Card *otherCard in self.cards) {
                if(otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    
                    if(matchScore) {
                        otherCard.unplayable = card.unplayable = YES;
                        
                        moveScore = matchScore * MATCH_BONUS;
                        self.score += moveScore;
                        
                        [self recordGameAction:[NSString stringWithFormat:@"Matched %@ with %@ : %d points!", card.contents, otherCard.contents, moveScore]];
                    } else {
                        otherCard.faceUp = NO;
                        
                        moveScore = MISMATCH_PENALTY;
                        self.score += moveScore;
                        
                        [self recordGameAction:[NSString stringWithFormat:@"No match! %@ with %@ : %d points", card.contents, otherCard.contents, moveScore]];
                    }
                    break;
                }
            }
        }
        
        card.faceUp = !card.isFaceUp;
    }
}

@end
