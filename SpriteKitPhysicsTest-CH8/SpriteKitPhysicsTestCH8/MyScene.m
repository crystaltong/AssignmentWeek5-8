//
//  MyScene.m
//  SpriteKitPhysicsTestCH8
//
//  Created by Crystal on 3/14/14.
//  Copyright (c) 2014 Crystal. All rights reserved.
//

#import "MyScene.h"
#define ARC4RANDOM_MAX      0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max)
{
    return floorf(((double)arc4random() / ARC4RANDOM_MAX) *
    (max-min) + min);
}
//commit again
@implementation MyScene
{
    SKSpriteNode *_square;
    SKSpriteNode *_circle;
    SKSpriteNode *_octagon;
    
    NSTimeInterval _dt;
    NSTimeInterval _lastUpdateTime;
    CGVector _windForce;
    BOOL _blowing;
    NSTimeInterval _timeUntilSwitchWindDirection;
}

-(instancetype) initWithSize:(CGSize)size

{
    if(self = [super initWithSize:size])
    {
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        //adds boundary to the edge of the screen, it defines edges of shape
        
        _square = [SKSpriteNode spriteNodeWithImageNamed:@"square"];
        _square.position = CGPointMake(self.size.width* 0.25, self.size.height *0.50);
        
        [self addChild:_square];
        
        _square.physicsBody =
        [SKPhysicsBody bodyWithRectangleOfSize:_square.size];
        
        _circle = [SKSpriteNode spriteNodeWithImageNamed:@"circle"];
        _circle.position = CGPointMake(self.size.width * 0.50, self.size.height * 0.50);
        
        [self addChild:_circle];
        
        _circle.physicsBody =
        [SKPhysicsBody bodyWithCircleOfRadius:_circle.size.width/2];
        //this asks for the radius, so its the width divided by 2
        //physics added will add gravity to circle and drop
        
        _circle.physicsBody.dynamic = NO;

        
        _octagon = [SKSpriteNode spriteNodeWithImageNamed:@"octagon"];
        _octagon.position = CGPointMake(self.size.width * 0.75, self.size.height * 0.5);
        [self addChild:_octagon];
        
        //1
        CGMutablePathRef octagonPath = CGPathCreateMutable();
        
        //2 starting point of drawing
        CGPathMoveToPoint(
                          octagonPath, nil, -_octagon.size.width/4,-_octagon.size.height/2);
        
        
        //3 draw on all eight corners
        
        //1
        CGPathAddLineToPoint(octagonPath, nil, -_octagon.size.width/2, - _octagon.size.height/4);
        //2
        CGPathAddLineToPoint(octagonPath, nil, -_octagon.size.width/2, _octagon.size.height/4);
        //3
        CGPathAddLineToPoint(octagonPath, nil,-_octagon.size.width/4, _octagon.size.height/2);
        //4
        CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/4, _octagon.size.height/2);
        
        //5
        CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/2, _octagon.size.height/4);
        
        //6
        CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/2, -_octagon.size.height/4);
        
        //7
        CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/4, -_octagon.size.height/2);
        
        //8
        CGPathAddLineToPoint(
                          octagonPath, nil, -_octagon.size.width/4,-_octagon.size.height/2);
        
        
        //4
        _octagon.physicsBody =
        [SKPhysicsBody bodyWithPolygonFromPath:octagonPath];
        
        //5
        CGPathRelease(octagonPath);
        
       
    
    
    //add 100 particles
        [self runAction:
         [SKAction repeatAction:
          [SKAction sequence:
          @[[SKAction performSelector:@selector(spawnSand)
                             onTarget:self],
            [SKAction waitForDuration:0.02]
            ]]
         
                  count:100]
        ];

}//InItWithSize
    
    return self;
    
}//Instance type
    
- (void)spawnSand
    {
        //create small ball body
        SKSpriteNode *sand =
        
        [SKSpriteNode spriteNodeWithImageNamed:@"sand"];
        sand.position = CGPointMake(
                                    (float)(arc4random()%(int)self.size.width),
                                    self.size.height - sand.size.height);
        sand.physicsBody =
        [SKPhysicsBody bodyWithCircleOfRadius:sand.size.width/2];
        
        sand.name = @"sand";
        [self addChild:sand];
        
        
        //level of bouncyness
        sand.physicsBody.restitution = 1.0;
        
        sand.physicsBody.density = 20.0;
    }//spawnSand

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event


//applying an Impulse to particle images of each vector point

{for (SKSpriteNode *node in self.children){
    if ([node.name isEqualToString:@"sand"])
        [node.physicsBody applyImpulse: CGVectorMake(0, arc4random()%50)];
}//SKSpritenodechildren
    
    
    //SHAKE- moves screen 10 pixels, 5 times
    SKAction *shake = [SKAction moveByX:0 y:10 duration:0.05];
                       [self runAction:
                        [SKAction repeatAction:
                         [SKAction sequence:@[shake, [shake reversedAction]]]
                                         count:5]];
    
    //get touches location in scene
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInNode:self];
    [_circle removeAllActions];
    [_circle runAction: [SKAction moveTo:touchLocation duration:1]];
    
    }//touches began
    
- (void)update:(NSTimeInterval)currentTime
    {
        //1
        if (_lastUpdateTime) {
            _dt =currentTime - _lastUpdateTime;
        }//if
        else{_dt = 0;
        }//-dt-0
        _lastUpdateTime = currentTime;
        
        //2
        _timeUntilSwitchWindDirection -= _dt;
        if (_timeUntilSwitchWindDirection <= 0) {
            _timeUntilSwitchWindDirection = ScalarRandomRange(1, 5);
            
            
            _windForce = CGVectorMake(ScalarRandomRange(-50, 50), 0); //x=-50, 50
            //y= 0
            
            NSLog(@"Wind force: %0.2f, %0.2f",
                  _windForce.dx, _windForce.dy);
            
        }//timeUntilSwitchDirection
        
        //4 don't understand pg. 226
        for (SKSpriteNode *node in self.children)
            [node.physicsBody applyForce:_windForce];
        
    }//NSTimeInterval Current Time else



@end











