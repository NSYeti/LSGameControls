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

#import <Foundation/Foundation.h>
#import "LSControl.h"


enum {
    LSJoypadTypeEightWay              = 0,
    LSJoypadTypeFourWay               = 1
};
typedef int LSJoypadType;


enum {
    LSJoypadDirectionNeutral,
    LSJoypadDirectionRight,
    LSJoypadDirectionUpRight,
    LSJoypadDirectionUp,
    LSJoypadDirectionUpLeft,
    LSJoypadDirectionLeft,
    LSJoypadDirectionDownLeft,
    LSJoypadDirectionDown,
    LSJoypadDirectionDownRight
};
typedef int LSJoypadDirection;


//
//  DIGITAL JOYPAD CLASS
//  --------------------
//

@interface LSJoypad : LSControl <CCTargetedTouchDelegate> {

    CGSize wins;
    
    LSJoypadType type;
    LSJoypadDirection previousDirection;
    LSJoypadDirection direction;
    
    CGPoint axis;
    
    float angle;
    float maxRadius;
    float deadZone;
    
    BOOL isMoving;
    BOOL directionHeld;
    
    int touchHash;
    
    CCSprite *sprite;
    NSDictionary *spriteFrames;
    
    CGRect hitTestRect;
    CGPoint initialPosition;
    BOOL returnToHome;
    BOOL relativePositioningMode;
    BOOL cancelIfOutsideHitTestRect;
    
}

// The type of joypad.
@property (nonatomic, readonly) LSJoypadType type;

// Position vector of the joypad. Ranges from -1.0 to +1.0
@property (nonatomic, readonly) CGPoint axis;

// Direction of the joypad as an enumerated type.
@property (nonatomic, readonly) LSJoypadDirection direction;

// Sprite for the joypad.
@property (nonatomic, readonly) CCSprite *sprite;

// Maximum amount the user's finger can be moved in any direction from the joypad's centre point.
// Defaults to half the width of the sprite's bounding box.
@property (nonatomic, assign) float maxRadius;

// Amount of 'slack' the user's finger has to be moved through in order to register a direction change. Defaults to 20.0
@property (nonatomic, assign) float deadZone;


#pragma mark -
#pragma mark Initializers

// Initializes the joypad with a type and a dictionary of CCSpriteFrames for each unique direction.
//
// The dictionary passed in to 'frames' must contain sprite frames for the following keys:
//
// KEYS:
// @"Neutral"
// @"Right"
// @"Up Right"
// @"Up"
// @"Up Left"
// @"Left"
// @"Down Left"
// @"Down"
// @"Down Right"
//
// NOTES: if not using the 8-way joypad then only pass in sprite frames for the directions on the joypad that you will actually need.
// For example - the 'LSJoypadTypeFourWay' type only requires sprite frames for right, up, left, down, and neutral directions.
+ (id)joypadWithType:(LSJoypadType)padType spriteFrames:(NSDictionary *)frames;
- (id)initWithType:(LSJoypadType)padType spriteFrames:(NSDictionary *)frames;


// Initializes the joypad with a type and a dictionary of CCSprites for each unique direction.
//
// The dictionary passed in to 'spritesDict' must contain sprites for the following keys:
//
// KEYS:
// @"Neutral"
// @"Right"
// @"Up Right"
// @"Up"
// @"Up Left"
// @"Left"
// @"Down Left"
// @"Down"
// @"Down Right"
//
// NOTES: if not using the 8-way joypad then only pass in sprites for the directions on the joypad that you will actually need.
// For example - the 'LSJoypadTypeFourWay' type only requires sprites for the right, up, left, down, and neutral directions.
- (id)initWithType:(LSJoypadType)padType sprites:(NSDictionary *)spritesDict;

// Initializes the joypad with a type and a single static sprite.
- (id)initWithType:(LSJoypadType)padType sprite:(CCSprite *)theSprite;


// Enables positioning of the whole joypad relative to where the user's initial touch is located - similar to how Gameloft's joysticks work.
//
// The rectangle passed into 'rect' determines the area of the screen for this joypad that will be tested for touches.
//
// Passing YES into 'willReturn' will reset the position of the whole joypad when the user lifts their finger off the screen to the 
// position passed into 'homePos'. If passing 'NO' into 'willReturn' then 'homePos' is ignored and CGPointZero can be safely passed in.
//
// If using more than one joypad ensure that each joypad's hit test rect has its own exclusive area of the screen.
//
// DUAL JOYPADS EXAMPLE:
//
//      rect 1         rect 2
// +--------------+--------------+
// |              |              |
// |              |              | 
// |              |              |
// |    __        |        __    |    
// |   |  |       |       |  |   |    
// | --+  +--     |     --+  +-- |    
// ||   {}   |    |    |   {}   ||    
// | --+  +--     |     --+  +-- |    
// |   |__|       |       |__|   |    
// +--------------+--------------+
//         width of screen
//
- (void)setRelativePositioningModeWithHitTestRect:(CGRect)rect returnToHomeOnRelease:(BOOL)willReturn homePosition:(CGPoint)homePos;

// Whether the touch sequence and joypad movement will be cancelled if the user's finger moves outside of the hit test rect.
//
// NOTE: This is meant to be used in conjunction with the 'setRelativePositioningModeWithHitTestRect:...' method above.
@property (nonatomic, assign) BOOL cancelIfOutsideHitTestRect;


@end
