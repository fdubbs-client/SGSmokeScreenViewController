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
@property (nonatomic, assign, getter=isUnwinding) BOOL unwinding;
@end

@implementation SGSmokeScreenViewController

- (instancetype)initWithStartingViewController:(UIViewController *)startingViewController destinationViewController:(UIViewController *)destinationViewController;
{
    if ((self = [super initWithNibName:nil bundle:nil]))
    {
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

    double totalDuration = [[self.animations valueForKeyPath:@"@sum.duration"] doubleValue];
    totalDuration += [[self.animations valueForKeyPath:@"@sum.delay"] doubleValue];
    
    for (SGSmokeScreenAnimation *animation in self.animations)
    {
        NSTimeInterval duration = animation.duration;
        NSTimeInterval delay = animation.delay;
        UIViewAnimationCurve options = animation.options;
        
        [UIView animateWithDuration:duration
							  delay:delay
							options:options
						 animations:^{
                             animation.animations(self);
                         } completion:nil];
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(totalDuration * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self removeSmokescreenIfUseCountIsZero];
    });
}

- (void)performTransition
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.view];
    
    self.startingViewController.view.hidden = YES;
    self.destinationViewController.view.hidden = YES;
    
    [self.startingViewController.navigationController presentViewController:self.destinationViewController animated:NO completion:nil];
}

- (void)unwindTransition
{
    self.unwinding = YES;
    self.startingViewController.view.hidden = YES;
    self.destinationViewController.view.hidden = YES;
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.view];
}

- (void)removeSmokescreenIfUseCountIsZero
{
    self.startingViewController.view.hidden = NO;
    self.destinationViewController.view.hidden = NO;

    [self.view removeFromSuperview];
    [self resignFirstResponder];

    if (self.isUnwinding == YES)
    {
        [self.destinationViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

@end
