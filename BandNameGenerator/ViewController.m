//
//  ViewController.m
//  BandNameGenerator
//
//  Created by Curtis Branum on 1/7/14.
//  Copyright (c) 2014 Morsekode. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *buttonGenerate;
@property (nonatomic, strong) UILabel *labelBandName;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.buttonGenerate = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.buttonGenerate.frame = CGRectMake(20.0f, 80.0f, 280.0f, 4.0f);
    [self.buttonGenerate setTitle:@"Generate" forState:UIControlStateNormal];
    [self.view addSubview:self.buttonGenerate];
    
    self.labelBandName = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 23.0f)];
    self.labelBandName.center = self.view.center;
    [self.view addSubview:self.labelBandName];
    
    // setup event handler
    [self.buttonGenerate addTarget:self action:@selector(handleGenerate:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleGenerate: (UIButton *)buttonParam
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
    
    NSString *bandName = [NSString stringWithFormat:@"%@ %@", adjective, noun];
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

@end
