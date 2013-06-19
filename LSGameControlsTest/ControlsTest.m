//
//  ControlsTest.m
//  LSJoystickTest
//
//  Created by LS on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlsTest.h"


#define JOYPAD_SPRITE_FRAMES_PLIST      @"joypad.plist"

#define JOYPAD_NEUTRAL_IMAGE            @"joypad_N.png"
#define JOYPAD_RIGHT_IMAGE              @"joypad_R.png"
#define JOYPAD_UP_RIGHT_IMAGE           @"joypad_UR.png"
#define JOYPAD_UP_IMAGE                 @"joypad_U.png"
#define JOYPAD_UP_LEFT_IMAGE            @"joypad_UL.png"
#define JOYPAD_LEFT_IMAGE               @"joypad_L.png"
#define JOYPAD_DOWN_LEFT_IMAGE          @"joypad_DL.png"
#define JOYPAD_DOWN_IMAGE               @"joypad_D.png"
#define JOYPAD_DOWN_RIGHT_IMAGE         @"joypad_DR.png"

#define JOYSTICK_BASE_IMAGE             @"thumbstick_base.png"
#define JOYSTICK_THUMB_IMAGE            @"thumbstick_thumb.png"

#define BUTTON_NORMAL_IMAGE             @"button_normal.png"
#define BUTTON_SELECTED_IMAGE           @"button_selected.png"
#define BUTTON_DISABLED_IMAGE           @"button_normal.png"

#define CONTROLS_OPACITY                255


@interface ControlsTest ()

- (void)setupJoypad;
- (void)setupJoystick;
- (void)setupButtons;
- (void)test1;
- (void)test2;

@end


@implementation ControlsTest

+ (CCScene *)scene {
    CCScene *scene = [CCScene node];
    ControlsTest *layer = [ControlsTest node];
    [scene addChild:layer];
    return scene;
}


- (void)dealloc {
    
    [super dealloc];
}


- (id)init {
    if ((self = [super init])) {
        
        wins = [[CCDirector sharedDirector] winSize];
        
        [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
        
        // Create an analogue joystick and and two buttons.
        [self test1];
        
        // Create a digital joystick and and two buttons.
        //        [self test2];
        
        //        [self scheduleUpdate];
        
        
    }
    return self;
}


- (void)update:(ccTime)dt {
    //    NSLog(@"button1.selected:%@ tapCount:%i tapDuration:%f", (button1.selected) ? @"YES" : @"NO", button1.tapCount, button1.tapDuration);
    
    //    x += leftPad.axis.x;
    //    y += leftPad.axis.y;
    //    x += rightStick.axis.x;
    //    y += rightStick.axis.y;
    //    NSLog(@"x:%f y:%f", x, y);
}


- (void)test1 {
    [self setupJoystick];
    [self setupButtons];
}


- (void)test2 {
    [self setupJoypad];
    [self setupButtons];
}


- (void)setupJoypad {
    
    // Load in the sprite frames.
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:JOYPAD_SPRITE_FRAMES_PLIST];
    
    
    // Add the sprite frames to a dictionary that we'll be passing into the joypad's initializer.
    NSMutableDictionary *spriteFrames = [NSMutableDictionary dictionary];
    [spriteFrames setObject:[frameCache spriteFrameByName:JOYPAD_NEUTRAL_IMAGE] forKey:@"Neutral"];
    [spriteFrames setObject:[frameCache spriteFrameByName:JOYPAD_RIGHT_IMAGE] forKey:@"Right"];
    [spriteFrames setObject:[frameCache spriteFrameByName:JOYPAD_UP_IMAGE] forKey:@"Up"];
    [spriteFrames setObject:[frameCache spriteFrameByName:JOYPAD_LEFT_IMAGE] forKey:@"Left"];
    [spriteFrames setObject:[frameCache spriteFrameByName:JOYPAD_DOWN_IMAGE] forKey:@"Down"];
    
    [spriteFrames setObject:[frameCache spriteFrameByName:JOYPAD_UP_RIGHT_IMAGE] forKey:@"Up Right"];
    [spriteFrames setObject:[frameCache spriteFrameByName:JOYPAD_UP_LEFT_IMAGE] forKey:@"Up Left"];
    [spriteFrames setObject:[frameCache spriteFrameByName:JOYPAD_DOWN_LEFT_IMAGE] forKey:@"Down Left"];
    [spriteFrames setObject:[frameCache spriteFrameByName:JOYPAD_DOWN_RIGHT_IMAGE] forKey:@"Down Right"];
    
    
    // Create an 8-way joypad
    leftPad = [LSJoypad joypadWithType:LSJoypadTypeEightWay spriteFrames:spriteFrames];
    [self addChild:leftPad];
    
    
    //    // Create a 4-way joypad.
    //    leftPad = [[LSJoypad alloc] initWithType:LSJoypadTypeFourWay spriteFrames:spriteFrames];
    //    [self addChild:leftPad];
    
    
    // Configure the joypad.
    leftPad.position = ccp(leftPad.sprite.boundingBox.size.width / 2.0 * 1.2, leftPad.sprite.boundingBox.size.height / 2.0 * 1.2);
    leftPad.maxRadius = leftPad.sprite.boundingBox.size.width / 2.0;
    leftPad.sprite.opacity = CONTROLS_OPACITY;
    
    
    // Enable relative positioning mode.
    //    CGRect leftPadHitTestRect = CGRectMake(0.0, 0.0, wins.width / 2.0, wins.height);
    //    [leftPad setRelativePositioningModeWithHitTestRect:leftPadHitTestRect returnToHomeOnRelease:YES homePosition:leftPad.position];
    //    leftPad.cancelIfOutsideHitTestRect = YES;
    
    
    // Add some target/actions.
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadRightPressed];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadRightReleased];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadUpRightPressed];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadUpRightReleased];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadUpPressed];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadUpReleased];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadUpLeftPressed];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadUpLeftReleased];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadLeftPressed];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadLeftReleased];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadDownLeftPressed];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadDownLeftReleased];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadDownPressed];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadDownReleased];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadDownRightPressed];
    [leftPad addTarget:self action:@selector(onJoypadDirectionPressed:events:) forControlEvents:LSControlEventJoypadDownRightReleased];
    
}


- (void)setupJoystick {
    
    // Create the sprites for the thumb and base.
    CCSprite *rightStickBase = [CCSprite spriteWithFile:JOYSTICK_BASE_IMAGE];
    CCSprite *rightStickThumb = [CCSprite spriteWithFile:JOYSTICK_THUMB_IMAGE];
    
    
    // Create the joystick.
    rightStick = [LSJoystick joystickWithType:LSJoystickType360 baseSprite:rightStickBase thumbSprite:rightStickThumb];
    [self addChild:rightStick];
    
    
    // Configure the joystick.
    rightStick.position = ccp(rightStick.baseSprite.boundingBox.size.width / 2.0 * 1.2, rightStick.baseSprite.boundingBox.size.height / 2.0 * 1.2);
    rightStick.baseSprite.opacity = CONTROLS_OPACITY;
    rightStick.thumbSprite.opacity = CONTROLS_OPACITY;
    //    rightStick.maxRadius = 50.0;
    //    rightStick.deadZone = 20.0;
    //    rightStick.autoCentering = NO;
    //    rightStick.activatesOnThumbSpriteTouch = YES;
    
    
    // Enable relative positioning mode.
    //    CGRect rightStickHitTestRect = CGRectMake(wins.width / 2.0, 0.0, wins.width / 2.0, wins.height);
    //    [rightStick setRelativePositioningModeWithHitTestRect:rightStickHitTestRect returnToHomeOnRelease:YES homePosition:rightStick.position];
    //    rightStick.cancelIfOutsideHitTestRect = YES;
    
    
    // Add some target/actions.
    [rightStick addTarget:self action:@selector(onStickReturnedToCentre:events:) forControlEvents:LSControlEventJoystickReturnedToCentre];
    [rightStick addTarget:self action:@selector(onStickReachedMaxRadius:events:) forControlEvents:LSControlEventJoystickReachedMaxRadius];
    [rightStick addTarget:self action:@selector(onStickWithinMaxRadius:events:) forControlEvents:LSControlEventJoystickWithinMaxRadius];
    
}


- (void)setupButtons {
    
    
    // ########
    // BUTTON 1
    // ########
    
    
    // Create the sprites.
    CCSprite *normal = [CCSprite spriteWithFile:BUTTON_NORMAL_IMAGE];
    CCSprite *selected = [CCSprite spriteWithFile:BUTTON_SELECTED_IMAGE];
    CCSprite *disabled = [CCSprite spriteWithFile:BUTTON_DISABLED_IMAGE];
    
    
    // Create a normal button.
    button1 = [LSButton buttonWithType:LSButtonTypeNormal normalSprite:normal selectedSprite:selected disabledSprite:disabled];
    [self addChild:button1];
    
    
    //    // Create a toggle button.
    //    button1 = [LSButton buttonWithType:LSButtonTypeToggle normalSprite:normal selectedSprite:selected disabledSprite:disabled];
    //    [self addChild:button1];
    
    
    // Configure the button.
    button1.position = ccp(wins.width - button1.normalSprite.boundingBox.size.width / 2.0 * 1.5, button1.normalSprite.boundingBox.size.height / 2.0 * 1.5);
    button1.normalSprite.opacity = CONTROLS_OPACITY;
    button1.selectedSprite.opacity = CONTROLS_OPACITY;
    button1.disabledSprite.opacity = CONTROLS_OPACITY;
    //    button1.repeatRate = 10;
    
    
    // Add some target/actions.
    [button1 addTarget:self action:@selector(onButtonTouchDown:events:) forControlEvents:LSControlEventTouchDown];
    [button1 addTarget:self action:@selector(onButtonTouchDownRepeat:events:) forControlEvents:LSControlEventTouchDownRepeat];
    [button1 addTarget:self action:@selector(onButtonTouchDragInside:events:) forControlEvents:LSControlEventTouchDragInside];
    [button1 addTarget:self action:@selector(onButtonTouchDragOutside:events:) forControlEvents:LSControlEventTouchDragOutside];
    [button1 addTarget:self action:@selector(onButtonTouchUpInside:events:) forControlEvents:LSControlEventTouchUpInside];
    [button1 addTarget:self action:@selector(onButtonTouchUpOutside:events:) forControlEvents:LSControlEventTouchUpOutside];
    [button1 addTarget:self action:@selector(onButtonTouchCancel:events:) forControlEvents:LSControlEventTouchCancel];
    
    
    
    // ########
    // BUTTON 2
    // ########
    
    
    // Create the sprites.
    CCSprite *normal2 = [CCSprite spriteWithFile:BUTTON_NORMAL_IMAGE];
    CCSprite *selected2 = [CCSprite spriteWithFile:BUTTON_SELECTED_IMAGE];
    CCSprite *disabled2 = [CCSprite spriteWithFile:BUTTON_DISABLED_IMAGE];
    
    
    // Create a normal button.
    button2 = [LSButton buttonWithType:LSButtonTypeNormal normalSprite:normal2 selectedSprite:selected2 disabledSprite:disabled2];
    [self addChild:button2];
    
    
    //    // Create a toggle button.
    //    button2 = [LSButton buttonWithType:LSButtonTypeToggle normalSprite:normal2 selectedSprite:selected2 disabledSprite:disabled];
    //    [self addChild:button2];
    
    
    // Configure the button.
    button2.position = ccp(button1.position.x - button2.normalSprite.boundingBox.size.width / 2.0 * 2.0, button2.normalSprite.boundingBox.size.height / 2.0 * 1.5);
    button2.normalSprite.opacity = CONTROLS_OPACITY;
    button2.selectedSprite.opacity = CONTROLS_OPACITY;
    button2.disabledSprite.opacity = CONTROLS_OPACITY;
    //    button2.repeatRate = 10;
    
    
    // Add some target/actions.
    [button2 addTarget:self action:@selector(onButtonTouchDown:events:) forControlEvents:LSControlEventTouchDown];
    [button2 addTarget:self action:@selector(onButtonTouchDownRepeat:events:) forControlEvents:LSControlEventTouchDownRepeat];
    [button2 addTarget:self action:@selector(onButtonTouchDragInside:events:) forControlEvents:LSControlEventTouchDragInside];
    [button2 addTarget:self action:@selector(onButtonTouchDragOutside:events:) forControlEvents:LSControlEventTouchDragOutside];
    [button2 addTarget:self action:@selector(onButtonTouchUpInside:events:) forControlEvents:LSControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(onButtonTouchUpOutside:events:) forControlEvents:LSControlEventTouchUpOutside];
    [button2 addTarget:self action:@selector(onButtonTouchCancel:events:) forControlEvents:LSControlEventTouchCancel];
    
}


#pragma mark -
#pragma mark Joypad target actions

- (void)onJoypadDirectionPressed:(LSJoypad *)sender events:(LSControlEvents)events {
    
    NSMutableString *string = [NSMutableString stringWithFormat:@"onJoypadDirectionPressed:%@ events:%i - ", sender, events];
    
    switch (events) {
        case LSControlEventJoypadRightPressed: {
            [string appendFormat:@"right pressed"];
            break;
        }
        case LSControlEventJoypadRightReleased: {
            [string appendFormat:@"right released"];
            break;
        }
        case LSControlEventJoypadUpRightPressed: {
            [string appendFormat:@"up right pressed"];
            break;
        }
        case LSControlEventJoypadUpRightReleased: {
            [string appendFormat:@"up right released"];
            break;
        }
        case LSControlEventJoypadUpPressed: {
            [string appendFormat:@"up pressed"];
            break;
        }
        case LSControlEventJoypadUpReleased: {
            [string appendFormat:@"up released"];
            break;
        }
        case LSControlEventJoypadUpLeftPressed: {
            [string appendFormat:@"up left pressed"];
            break;
        }
        case LSControlEventJoypadUpLeftReleased: {
            [string appendFormat:@"up released"];
            break;
        }
        case LSControlEventJoypadLeftPressed: {
            [string appendFormat:@"left pressed"];
            break;
        }
        case LSControlEventJoypadLeftReleased: {
            [string appendFormat:@"left released"];
            break;
        }
        case LSControlEventJoypadDownLeftPressed: {
            [string appendFormat:@"down left pressed"];
            break;
        }
        case LSControlEventJoypadDownLeftReleased: {
            [string appendFormat:@"down left released"];
            break;
        }
        case LSControlEventJoypadDownPressed: {
            [string appendFormat:@"down pressed"];
            break;
        }
        case LSControlEventJoypadDownReleased: {
            [string appendFormat:@"down released"];
            break;
        }
        case LSControlEventJoypadDownRightPressed: {
            [string appendFormat:@"down right pressed"];
            break;
        }
        case LSControlEventJoypadDownRightReleased: {
            [string appendFormat:@"down right released"];
            break;
        }
        default: {
            break;
        }
    }
    
    NSLog(@"%@", string);
}


#pragma mark -
#pragma mark Joystick target actions

- (void)onStickReturnedToCentre:(LSJoystick *)sender events:(LSControlEvents)events {
    NSLog(@"onStickReturnedToCentre:%@ events:%i", sender, events);
}


- (void)onStickReachedMaxRadius:(LSJoystick *)sender events:(LSControlEvents)events {
    NSLog(@"onStickReachedMaxRadius:%@ events:%i", sender, events);
}


- (void)onStickWithinMaxRadius:(LSJoystick *)sender events:(LSControlEvents)events {
    NSLog(@"onStickWithinMaxRadius:%@ events:%i", sender, events);
}


#pragma mark -
#pragma mark Button target actions

- (void)onButtonTouchDown:(LSButton *)sender events:(LSControlEvents)events {
    NSLog(@"onButtonTouchDown:%@ events:%i", sender, events);
}


- (void)onButtonTouchDownRepeat:(LSButton *)sender events:(LSControlEvents)events {
    NSLog(@"onButtonTouchDownRepeat:%@ events:%i", sender, events);
}


- (void)onButtonTouchDragInside:(LSButton *)sender events:(LSControlEvents)events {
    NSLog(@"onButtonTouchDragInside:%@ events:%i", sender, events);
}


- (void)onButtonTouchDragOutside:(LSButton *)sender events:(LSControlEvents)events {
    NSLog(@"onButtonTouchDragOutside:%@ events:%i", sender, events);
}


- (void)onButtonTouchUpInside:(LSButton *)sender events:(LSControlEvents)events {
    NSLog(@"onButtonTouchUpInside:%@ events:%i", sender, events);
}


- (void)onButtonTouchUpOutside:(LSButton *)sender events:(LSControlEvents)events {
    NSLog(@"onButtonTouchUpOutside:%@ events:%i", sender, events);
}


- (void)onButtonTouchCancel:(LSButton *)sender events:(LSControlEvents)events {
    NSLog(@"onButtonTouchCancel:%@ events:%i", sender, events);
}


@end
