//
//  UnretinaViewController.m
//  Unretiner
//
//  Created by Stuart Hall on 31/07/11.
//

#import "UnretinaViewController.h"
#import "NSURL+Unretina.h"

@implementation UnretinaViewController

static NSString* const kRetinaString = @"@2x";
static NSString* const kHdString = @"-hd";

@synthesize checkBox;

#pragma mark - Initialisation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    id s = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (s == self) {
        // Register for drag and drop
        [[self view] registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    }
    
    return s;
}

#pragma mark - Memory Management

- (void)dealloc {
    self.checkBox = nil;
    [super dealloc];
}

#pragma mark - Private Methods

// Retrieves a folder to save to
- (NSURL*)getSaveFolder:(NSURL*)url {
    NSOpenPanel *panel = [NSOpenPanel openPanel]; 
    [panel setCanChooseDirectories:YES]; 
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setDirectoryURL:url];
    panel.prompt = @"Export Here";
    panel.title = @"Select folder to save converted files.";
    if ([panel runModal] == NSOKButton) {
        // Got it, return the URL
        return [panel URL];
    }
    
    return nil;
}

- (BOOL)isDirectory:(NSURL*)url {
    // Determine if it is a directory
    return CFURLHasDirectoryPath((CFURLRef)url);
}

- (void)unretinaUrls:(NSArray*)urls savePath:(NSURL*)savePath errors:(NSMutableArray*)errors warnings:(NSMutableArray*)warnings recursive:(BOOL)recursive {
    // Parse each file passed in
    for (NSURL* url in urls) {
        if (url) {
            BOOL directory = [self isDirectory:url];
            if (recursive && directory) {
                // Folder and we want to jump into it, grab the urls
                NSFileManager* fileManager = [NSFileManager defaultManager];
                NSArray* contents = [fileManager contentsOfDirectoryAtURL:url includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles | NSDirectoryEnumerationSkipsSubdirectoryDescendants error:nil];
                
                // Parse them, but don't go into any further sub folders
                [self unretinaUrls:contents savePath:savePath errors:errors warnings:warnings recursive:NO];
            }
            else if (!directory) {
                // Parse the file
                [url unretina:savePath errors:errors warnings:warnings overwrite:[checkBox state]];
            }
        }
    }
}

#pragma mark - public methods

// Converts an array of URLs to non retina files
- (void)unretinaUrls:(NSArray*)urls {
    // Extract the default export folder
    if ([urls count] > 0) {
        NSURL* firstUrl = [urls objectAtIndex:0];
        if (![self isDirectory:firstUrl]) {
            firstUrl = [firstUrl URLByDeletingLastPathComponent];
        }
        NSURL* savePath = [self getSaveFolder:firstUrl];
            
        if (savePath) {
            // Arrays to store warnings and errors
            NSMutableArray* errors = [NSMutableArray array];
            NSMutableArray* warnings = [NSMutableArray array];
            
            // Do it!
            [self unretinaUrls:urls savePath:savePath errors:errors warnings:warnings recursive:YES];
            
            // Show the results
            if ([errors count] > 0 || [warnings count] > 0) {
                NSMutableString* message = [NSMutableString string];
                if ([warnings count] > 0) {
                    [message appendString:@"Please check the following warnings:\r\n\r\n"];
                    for (NSString* s in warnings) {
                        [message appendFormat:@"%@\r\n", s];
                    }
                    [message appendString:@"\r\n\r\n"];
                }
                
                if ([errors count] > 0) {
                    [message appendString:@"The following errors occured:\r\n\r\n"];
                    for (NSString* s in errors) {
                        [message appendFormat:@"%@\r\n", s];
                    }
                }
                
                NSRunAlertPanel(@"Conversion Complete.", 
                                message,
                                @"OK", nil, nil);
            }
        }
    }
}

#pragma mark - View Events

- (IBAction)onSelectFolder:(id)sender {  
    // Select the files to convert
	NSOpenPanel *panel = [NSOpenPanel openPanel]; 
	[panel setCanChooseDirectories:YES]; 
	[panel setCanChooseFiles:YES];
	[panel setAllowsMultipleSelection:YES];
	[panel setDelegate:self];
	[panel setCanCreateDirectories:YES];
	panel.title = @"Select @2x or -hd retina files";
    if ([panel runModal] == NSOKButton) {
        // Success, process all the files
        [self unretinaUrls:panel.URLs];
    }
}

#pragma mark - NSOpenSavePanelDelegate

- (BOOL)allowFile:(NSString*)filename {
    // Allow directories
    NSURL* url = [NSURL fileURLWithPath:filename];
    if (url && [self isDirectory:url])
        return YES;
    
    // See if the file is a retina image
    return url && [url isRetinaImage];
}

- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)url {
    // Only enable valid files
	return [self allowFile:[url path]];
}

- (BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename {
    // Only show valid files
	return [self allowFile:filename];
}

#pragma mark - Drag and Drop

- (void)filesDropped:(NSArray*)urls {
    // Process them
    [self unretinaUrls:urls];
}

@end
