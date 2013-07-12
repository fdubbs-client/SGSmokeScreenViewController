//
//  SGSmokeScreenViewController.m
//  SGSmokeScreenView
//
//  Created by Justin Williams on 7/7/13.
//  Copyright (c) 2013 Second Gear. All rights reserved.
//

#import "SGSmokeScreenViewController.h"
#import "SGSmokeScreenAnimation.h"

@interface SGSmokeScreenViewController ()

@property (nonatomic, strong) UIViewController *startingViewController;
@property (nonatomic, strong) UIViewController *destinationViewController;
@property (nonatomic, assign) NSUInteger useCount;

- (void)incrementUseCount;
- (void)decrementUseCount;

@end

@implementation SGSmokeScreenViewController

- (instancetype)initWithStartingViewController:(UIViewController *)startingViewController destinationViewController:(UIViewController *)destinationViewController;
{
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
        self.useCount = 0;
        self.startingViewController = startingViewController;
        self.destinationViewController = destinationViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView beginAnimations:nil context:nil];
    for (SGSmokeScreenAnimation *animation in self.animations)
    {
        NSTimeInterval duration = animation.duration;
        NSTimeInterval delay = animation.delay;
        UIViewAnimationCurve curve = animation.curve;
        
        [self incrementUseCount];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelay:delay];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        animation.animations(self);
        [UIView commitAnimations];
    }
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    [self decrementUseCount];
}

- (void)performTransition
{
    self.startingViewController.view.hidden = YES;
    self.destinationViewController.view.hidden = YES;
    
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.view];
    
    [self.startingViewController.navigationController presentViewController:self.destinationViewController animated:NO completion:nil];
}

- (void)unwindTransition
{
    self.startingViewController.view.hidden = YES;
    self.destinationViewController.view.hidden = YES;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.view];
    
    [self.destinationViewController dismissViewControllerAnimated:NO completion:nil];
}



- (void)incrementUseCount
{
    self.useCount++;
}

- (void)decrementUseCount
{
    self.useCount--;
    
    [self removeSmokescreenIfUseCountIsZero];
}

- (void)removeSmokescreenIfUseCountIsZero
{
    if (self.useCount != 0)
    {
        return;
    }
    
    self.startingViewController.view.hidden = NO;
    self.destinationViewController.view.hidden = NO;
    [self.view removeFromSuperview];
}

@end
