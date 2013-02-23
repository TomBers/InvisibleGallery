//
//  DetailViewController.m
//  IG
//
//  Created by Andrew Naylor on 23/02/2013.
//
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    }
    return self;
}

- (IBAction)donePressed {
	NSLog(@"Done Pressed");
	[self.parentViewController.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)setWebTarget:(NSString *)resource {
	UIWebView *webView = (UIWebView *) self.view;
	
	NSURL *url = [[NSBundle mainBundle] URLForResource:resource withExtension:@"html"];
	
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
