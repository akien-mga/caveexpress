#include "DarwinObjc.h"
#include <SDL.h>
#include <SDL_platform.h>
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#include <sys/stat.h>
#include <unistd.h>

static void uncaughtExceptionHandler (NSException *exception)
{
	NSLog(@"CRASH: %@", exception);
	NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
}

void darwinInit ()
{
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	char *basePath = SDL_GetBasePath();
	if (basePath != nullptr) {
		chdir(basePath);
		SDL_free(basePath);
	}
}

char* darwinGetHomeDirectory (const std::string& app)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSArray *array = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	char *retval = NULL;

	if ([array count] > 0) {  // we only want the first item in the list.
		NSString *str = [array objectAtIndex:0];
		const char *base = [str UTF8String];
		if (base) {
			const size_t len = SDL_strlen(base) + SDL_strlen(app.c_str()) + 3;
			retval = (char *) SDL_malloc(len);
			if (retval == NULL) {
				SDL_OutOfMemory();
			} else {
				char *ptr;
				SDL_snprintf(retval, len, "%s/%s/", base, app.c_str());
				for (ptr = retval+1; *ptr; ptr++) {
					if (*ptr == '/') {
						*ptr = '\0';
						mkdir(retval, 0700);
						*ptr = '/';
					}
				}
				mkdir(retval, 0700);
			}
		}
	}

	[pool release];
	return retval;
}

void darwinRequestUserAttention(bool critical)
{
	@autoreleasepool
	{
		if (critical) {
			[NSApp requestUserAttention:NSCriticalRequest];
			return;
		}
		[NSApp requestUserAttention:NSInformationalRequest];
	}
}