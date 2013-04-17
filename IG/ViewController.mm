//
//  ViewController.m
//  IG
//
//  Created by Tom Berman on 07/03/2013.
//  Copyright (c) 2013 Tom Berman. All rights reserved.
//

#import "ViewController.h"
#import "Tutorial2/Tutorial2ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagesMediaToLoad
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    Tutorial2ViewController* tutorialViewController = [[Tutorial2ViewController alloc] initWithNibName:@"Tutorial2" bundle:nil];
    tutorialViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:tutorialViewController animated:YES];
}

@end
