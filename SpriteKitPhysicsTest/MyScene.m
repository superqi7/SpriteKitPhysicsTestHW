//
//  MyScene.m
//  SpriteKitPhysicsTest
//
//  Created by Xiaoqi Liu on 3/1/14.
//  Copyright (c) 2014 Xiaoqi Liu. All rights reserved.
//

#import "MyScene.h"
#define ARC4RANDOM_MAX   0x100000000
static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max)
{
    return floorf(((double)arc4random()/ARC4RANDOM_MAX)*(max-min)+min);
}

NSTimeInterval _dt;
NSTimeInterval _lastUpdateTime;
CGVector _windForce;
BOOL _blowing;
NSTimeInterval _timeUntilSwitchWindDirection;

@implementation MyScene

{
    SKSpriteNode *_octagon;
    SKSpriteNode *_circle;
    SKSpriteNode *_triangle;
    
    
}

-(instancetype)initWithSize:(CGSize)size {
    
       if (self = [super initWithSize:(CGSize)size]) {
          
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];

        _octagon = [SKSpriteNode spriteNodeWithImageNamed:@"octagon"];
        _octagon.position = CGPointMake(self.size.width *0.25, self.size.height * 0.50);
//        _octagon.physicsBody = [
//                               SKPhysicsBody bodyWithRectangleOfSize:_octagon.size];
           [self addChild:_octagon];
          
           CGMutablePathRef octagonPath = CGPathCreateMutable();
           CGPathMoveToPoint(octagonPath, nil, _octagon.size.width/4, _octagon.size.height/2);
           CGPathAddLineToPoint(octagonPath, nil, -_octagon.size.width/4, _octagon.size.height/2);
           CGPathAddLineToPoint(octagonPath, nil, -_octagon.size.width/2, _octagon.size.height/4);
           CGPathAddLineToPoint(octagonPath, nil, -_octagon.size.width/2, -_octagon.size.height/4);
           CGPathAddLineToPoint(octagonPath, nil, -_octagon.size.width/4, -_octagon.size.height/2);
           CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/4, -_octagon.size.height/2);
           CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/2, -_octagon.size.height/4);
           CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/2, _octagon.size.height/4);
           CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/4, -_octagon.size.height/2);
           _octagon.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:octagonPath];
//           [_octagon.physicsBody setDynamic:NO];
                   CGPathRelease(octagonPath);

        
        
        _circle = [SKSpriteNode spriteNodeWithImageNamed:@"circle"];
        _circle.position = CGPointMake(self.size.width *0.50, self.size.height *0.50);
        _circle.physicsBody = [
                               SKPhysicsBody bodyWithCircleOfRadius:_circle.size.width/2];
           [_circle.physicsBody setDynamic:NO];

        [self addChild:_circle];
        
        _triangle = [SKSpriteNode spriteNodeWithImageNamed:@"triangle"];
        _triangle.position = CGPointMake(self.size.width*0.75, self.size.height *0.5);
          
        
           
           [self addChild:_triangle];
           
           CGMutablePathRef trianglePath = CGPathCreateMutable();
           CGPathMoveToPoint(trianglePath, nil, -_triangle.size.width/2, -_triangle.size.height/2);
           CGPathAddLineToPoint(trianglePath, nil, _triangle.size.width/2, -_triangle.size.height/2);
           CGPathAddLineToPoint(trianglePath, nil, 0, _triangle.size.height/2);
           CGPathAddLineToPoint(trianglePath, nil, -_triangle.size.width/2, -_triangle.size.height/2);
           _triangle.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:trianglePath];
           CGPathRelease(trianglePath);
           
           
   [self runAction:
           [SKAction repeatAction:
            [SKAction sequence:@[[SKAction performSelector:@selector(spawnSand) onTarget:self],
                                 [SKAction waitForDuration:0.02]]]
            count:100]
    ];
            }
        
   
    return self;
}

-(void)spawnSand{

    SKSpriteNode *sand = [SKSpriteNode spriteNodeWithImageNamed:@"sand"];
    sand.position = CGPointMake((float)(arc4random()%(int)self.size.width), self.size.height-sand.size.height);
    sand.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sand.size.width/2];
    sand.name = @"sand";
    sand.physicsBody.restitution = 1.0;
    sand.physicsBody.density = 20.0;
    [self addChild:sand];
   }

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    for (SKSpriteNode *node in self.children) {
        if ([node.name isEqualToString:@"sand"]) {
            [node.physicsBody applyImpulse:CGVectorMake(0, arc4random()%50)];
        }
    }
    SKAction *shake = [SKAction moveByX:0 y:10 duration:0.05];
    [self runAction:[SKAction repeatAction:[SKAction sequence:@[shake,[shake reversedAction]]] count:5]];

}


-(void)update:(NSTimeInterval)currentTime
{
    if (_lastUpdateTime) {
        _dt = currentTime - _lastUpdateTime;
    }else{
        _dt = 0;
    }
    _lastUpdateTime = currentTime;
    
    if (_timeUntilSwitchWindDirection<=0) {
        _timeUntilSwitchWindDirection = ScalarRandomRange(1, 5);
        _windForce = CGVectorMake(50, 0);
        NSLog(@"Wind Force: %0.2f, %0.2f", _windForce.dx, _windForce.dy);
    }
    for (SKSpriteNode *node in self.children) {
        [node.physicsBody applyForce:_windForce];
    }


}



@end
