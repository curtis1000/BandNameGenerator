//
//  ViewController.m
//  BandNameGenerator
//
//  Created by Curtis Branum on 1/7/14.
//  Copyright (c) 2014 Morsekode. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UILabel *labelBandName;
@end

@implementation ViewController

- (NSUInteger)supportedInterfaceOrientations
{
    // Support only portrait mode
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // lighten up the status bar text color
    [self setNeedsStatusBarAppearanceUpdate];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    
	// the band name uilabel that will dynamically change its text content
    self.labelBandName = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 0.0f, 300.0f, 250.0f)];
    self.labelBandName.center = self.view.center;
    self.labelBandName.textColor = [UIColor whiteColor];
    [self.labelBandName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:38]];
    [self.labelBandName setNumberOfLines:2];
    self.labelBandName.textAlignment = NSTextAlignmentCenter;
    [self.labelBandName setText: [self getRandomBandName]];
    [self.view addSubview:self.labelBandName];
    
    // setup event handler for tapping anywhere on screen
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGenerate:)];
    [self.view addGestureRecognizer:gr];
    
    //add background image
    UIImage *background = [UIImage imageNamed: @"Background.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage: background];
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    // scale/align background - we want 100% width and vertical center
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = imageView.frame;
    frame.size.width = self.view.bounds.size.width;
    CGFloat imageHeight = frame.size.height;
    
    // if the image is taller than the view, origin.y should be -1 * (half the image height - half the view height)
    if (imageHeight > screenHeight) {
        CGFloat originY = -1 * (imageHeight/2 - screenHeight/2);
        frame.origin.y = originY;
    }
    imageView.frame = frame;
    
    // split view into thirds with two red lines, first @ 1/3 view height, 2nd @ 2/3 view height
    NSInteger lineMargin = 20;
    UIColor *lineColor = [UIColor redColor];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(lineMargin, (self.view.bounds.size.height * .33), self.view.bounds.size.width - (lineMargin * 2), 1)];
    lineView1.backgroundColor = lineColor;
    [self.view addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(lineMargin, (self.view.bounds.size.height * .66), self.view.bounds.size.width - (lineMargin * 2), 1)];
    lineView2.backgroundColor = lineColor;
    [self.view addSubview:lineView2];
    
    // footer text
    UILabel *footerText = [[UILabel alloc] initWithFrame:CGRectMake(8.0f, (self.view.bounds.size.height * .9), 300.0f, 50.0f)];
    footerText.textColor = [UIColor whiteColor];
    [footerText setFont:[UIFont fontWithName:@"GillSans-Light" size:18]];
    footerText.textAlignment = NSTextAlignmentCenter;
    [footerText setText:[@"Shake or tap to generate" uppercaseString]];
    [self.view addSubview:footerText];
    
}

// we need two method signatures for handleGenerate because it is called in the two different contexts
- (void)handleGenerate: (id *)param
{

    [self handleGenerate];
}

- (void)handleGenerate
{
    
    [self.labelBandName setText:[self getRandomBandName]];
}

- (NSString *)getRandomBandName
{
    // Path to the plist (Supporting Files/WordsDictionary.plist)
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"WordsDictionary" ofType:@"plist"];
    
    // Build the array from the plist
    NSDictionary *wordsDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    NSArray *adjectives = [wordsDictionary objectForKey:@"Adjectives"];
    NSArray *nouns = [wordsDictionary objectForKey:@"Nouns"];
    
    NSString *adjective = [self getRandomStringFromArray:adjectives];
    NSString *noun = [self getRandomStringFromArray:nouns];
    
    // concatenate adjective and noun to form band name
    NSString *bandName = [NSString stringWithFormat:@"%@\n%@", adjective, noun];
    
    // max length of any single word
    NSInteger maxLength = 13;
    
    // if either word exceeds max length, try again
    if ([adjective length] > maxLength || [noun length] > maxLength) {
        return [self getRandomBandName];
    }
    
    // if band name contains invalid characters, try again
    NSString *invalidCharacters = @"-";
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:invalidCharacters];
    NSRange range = [bandName rangeOfCharacterFromSet:cset];
    if (range.location != NSNotFound) {
        return [self getRandomBandName];
    }
    
    return bandName;
}

- (NSString *)getRandomStringFromArray: (NSArray *)paramArray
{
    NSString *randomString = [paramArray objectAtIndex: arc4random() % [paramArray count]];
    return randomString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// the following 4 methods support shaking gesture
// as described: http://stackoverflow.com/a/2405692

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        [self handleGenerate];
    }
}

// lighten up the status bar text color
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
