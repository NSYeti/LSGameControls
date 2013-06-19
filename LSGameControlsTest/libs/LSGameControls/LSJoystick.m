/*
 * LSGameControls: https://github.com/NSYeti/LSGameControls
 *
 * Copyright (c) 2012 Lee Scott
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "LSJoystick.h"


@implementation LSJoystick

@synthesize type;
@synthesize axis;
@synthesize angle;
@synthesize baseSprite;
@synthesize thumbSprite;
@synthesize maxRadius;
@synthesize deadZone;
@synthesize autoCentering;
@synthesize activatesOnThumbSpriteTouch;
@synthesize cancelIfOutsideHitTestRect;

- (void)dealloc {

    [super dealloc];
}


+ (id)joystickWithType:(LSJoystickType)stickType baseSprite:(CCSprite *)base thumbSprite:(CCSprite *)thumb {
    return [[[self alloc] initWithType:stickType baseSprite:base thumbSprite:thumb] autorelease];
}


- (id)init {
    return [self initWithType:LSJoystickType360 baseSprite:nil thumbSprite:nil];
}


- (id)initWithType:(LSJoystickType)stickType baseSprite:(CCSprite *)base thumbSprite:(CCSprite *)thumb {
    self = [super init];
    if (self != nil) {
        
        NSAssert(base, @"Error: base sprite must not be nil.");
        NSAssert(thumb, @"Error: thumb sprite must not be nil.");
        
        wins = [[CCDirector sharedDirector] winSize];
        
        type = stickType;
        
        baseSprite = base;
        [self addChild:baseSprite];
        
        thumbSprite = thumb;
        [self addChild:thumbSprite];
        
        maxRadius = baseSprite.boundingBox.size.width / 3.0;
        deadZone = 0.0;
        
        autoCentering = YES;
        activatesOnThumbSpriteTouch = NO;
        cancelIfOutsideHitTestRect = NO;
        
        hitTestRect = CGRectZero;
        initialPosition = CGPointZero;
        relativePositioningMode = NO;
        returnToHome = NO;
        
    }
    return self;
}


- (void)onEnter {
    [super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:NO];
}


- (void)onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super onExit];
}


- (void)setRelativePositioningModeWithHitTestRect:(CGRect)rect returnToHomeOnRelease:(BOOL)willReturn homePosition:(CGPoint)homePos {

    hitTestRect = rect;
    returnToHome = willReturn;
    initialPosition = homePos;
    relativePositioningMode = YES;
}


- (CGPoint)calculateThumbPositionForPoint:(CGPoint)point {
    
    CGPoint newPos = CGPointZero;
    
    switch (type) {
        case LSJoystickType360: {
            break;
        }
        default: {
            break;
        }
    }
    
    angle = CC_RADIANS_TO_DEGREES(ccpToAngle(point));
    if (angle < 0.0) angle += 360.0;
    if (angle == 360.0) angle = 0.0;
    angle = fabsf(angle);
    
    float distance = ccpLength(point);
    if (distance > maxRadius) {
        distance = maxRadius;
        newPos = ccpMult(ccpNormalize(point), maxRadius);
        if (!reachedMaxRadius) {
            [self sendActionsForControlEvents:LSControlEventJoystickReachedMaxRadius];
            reachedMaxRadius = YES;
        }
    }
    else {
        newPos = point;
        if (reachedMaxRadius) {
            [self sendActionsForControlEvents:LSControlEventJoystickWithinMaxRadius];
            reachedMaxRadius = NO;
        }
    }

    thumbSprite.position = newPos;
    
    if (distance > deadZone) {
        axis = CGPointMake(newPos.x / maxRadius, newPos.y / maxRadius);
    }
    else {
        axis = CGPointZero;
    }
    
    return newPos;
}


#pragma mark -
#pragma mark CCTargetedTouchDelgate
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:[[CCDirector sharedDirector] view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    BOOL willMove = NO;
    CGPoint newThumbPos = CGPointZero;
    
    if (relativePositioningMode) {
        if (CGRectContainsPoint(hitTestRect, touchPoint)) {
            self.position = touchPoint;
            willMove = YES;
        }
        touchPoint = [self convertToNodeSpace:touchPoint];
    }
    else {
        touchPoint = [self convertToNodeSpace:touchPoint];
        
        if (CGRectContainsPoint([baseSprite boundingBox], touchPoint)) {
//        if (ccpLength(touchPoint) <= maxRadius) {
            
            willMove = YES;
            
            if (activatesOnThumbSpriteTouch) {
                willMove = (CGRectContainsPoint([thumbSprite boundingBox], touchPoint)) ? YES : NO;
            }
            else {        
                willMove = YES;
            }
        }
    }
    
    if (willMove) {
        newThumbPos = [self calculateThumbPositionForPoint:touchPoint];
                
        isMoving = YES;
        touchHash = [touch hash];
        
        [self sendActionsForControlEvents:LSControlEventTouchDown];
        
        return YES;
    }
    else {
        return NO;
    }
}


- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:[[CCDirector sharedDirector] view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    BOOL willMove = YES;
    
    if ([touch hash] == touchHash && isMoving) {
        
        if (relativePositioningMode) {
            if (!CGRectContainsPoint(hitTestRect, touchPoint) && cancelIfOutsideHitTestRect) {
                willMove = NO;
                [self ccTouchCancelled:touch withEvent:event]; 
            }    
        }
        
        if (willMove) {
            touchPoint = [self convertToNodeSpace:touchPoint];
            
            [self calculateThumbPositionForPoint:touchPoint];
            
            isMoving = YES;
            
            if (CGRectContainsPoint([baseSprite boundingBox], touchPoint)) {
                [self sendActionsForControlEvents:LSControlEventTouchDragInside];
            }
            else {
                [self sendActionsForControlEvents:LSControlEventTouchDragOutside];
            }
        }      
    }
}


- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:[[CCDirector sharedDirector] view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    if ([touch hash] == touchHash) {
        isMoving = NO;        
		touchHash = 0;
        
        if (autoCentering) {
            [self calculateThumbPositionForPoint:CGPointZero];
            [self sendActionsForControlEvents:LSControlEventJoystickReturnedToCentre];
        }
        
        if (relativePositioningMode) {
            if (returnToHome) {
                self.position = initialPosition;
            }
        }
        
        touchPoint = [self convertToNodeSpace:touchPoint];
        
        if (CGRectContainsPoint([baseSprite boundingBox], touchPoint)) {
            [self sendActionsForControlEvents:LSControlEventTouchUpInside];
        }
        else {
            [self sendActionsForControlEvents:LSControlEventTouchUpOutside];
        }
	}
    
}


- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self ccTouchEnded:touch withEvent:event];
    [self sendActionsForControlEvents:LSControlEventTouchCancel];
}


@end
