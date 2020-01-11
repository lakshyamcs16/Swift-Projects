//
//  ProcessInfo.m
//  TesterApp
//
//  Created by Aashna Narula on 26/12/19.
//  Copyright © 2019 Aashna Narula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOKitLib.h"

#include <sys/sysctl.h>
#include <sys/resource.h>
#include <sys/vm.h>

static void objc_println( NSString* format, ... );
static void printSysctlInfo( void );
static NSDictionary* getCpuIds( void );
static NSString* getPlatformSerialNumber( void );

int main (int argc, const char * argv[]) {
    
    objc_println(@"Beginning system data collection...");
    
    NSProcessInfo* pinfo = [NSProcessInfo processInfo];
    
    objc_println( @"NSProcessInfo:" );
    objc_println( @"\tProcess Name: %@", [pinfo processName] );
    objc_println( @"\tPID: %d", [pinfo processIdentifier] );
    objc_println( @"\tProcess GUID: %@", [pinfo globallyUniqueString] );
    objc_println( @"\tOS Version: %@", [pinfo operatingSystemVersionString] );
    objc_println( @"\tTotal Processors: %d", [pinfo processorCount] );
    objc_println( @"\tActive Processors: %d", [pinfo activeProcessorCount] );
    objc_println( @"\tTotal RAM: %ull bytes", [pinfo physicalMemory] );
    
    printSysctlInfo();
    
    objc_println( @"IOKit:" );
    NSDictionary *cpuInfo = getCpuIds();
    NSArray* keys = [[cpuInfo allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    for( id key in keys ) {
        objc_println( @"\t%@ has ID: 0x%8.8x", key, [(NSNumber*)[cpuInfo objectForKey: key] unsignedIntValue] );
    }
    
    objc_println( @"\tSerial Number: %@", getPlatformSerialNumber() );
    
    [pool drain];
    
    return 0;
}

static void objc_println( NSString* format, ... ) {
    va_list args;
    
    if (![format hasSuffix: @"\n"]) {
        format = [format stringByAppendingString: @"\n"];
    }
    
    va_start (args, format);
    NSString *body =  [[NSString alloc] initWithFormat: format
                                             arguments: args];
    va_end (args);
    
    fprintf(stderr,"%s",[body UTF8String]);
    
    [body release];
}

static void printSysctlInfo( void ) {
    objc_println( @"sysctl:" );
    
    int mib[2];
    size_t len = 0;
    char *rstring = NULL;
    unsigned int rint = 0;
    
    /* Setup the MIB data */
    mib[0] = CTL_KERN;
    mib[1] = KERN_OSTYPE;
    
    /* Get the length of the string */
    sysctl( mib, 2, NULL, &len, NULL, 0 );
    
    /* Now allocate space for the string and grab it */
    rstring = malloc( len );
    sysctl( mib, 2, rstring, &len, NULL, 0 );
    objc_println( @"\tkern.ostype: %s", rstring );
    
    /* Make sure we clean up afterwards! */
    free( rstring );
    rstring = NULL;
    
    /* Get the kernel release number */
    mib[0] = CTL_KERN;
    mib[1] = KERN_OSRELEASE;
    sysctl( mib, 2, NULL, &len, NULL, 0 );
    rstring = malloc( len );
    sysctl( mib, 2, rstring, &len, NULL, 0 );
    objc_println( @"\tkern.osrelease: %s", rstring );
    free( rstring );
    rstring = NULL;
    
    /* Get the Mac OS X Build number */
    mib[0] = CTL_KERN;
    mib[1] = KERN_OSVERSION;
    sysctl( mib, 2, NULL, &len, NULL, 0 );
    rstring = malloc( len );
    sysctl( mib, 2, rstring, &len, NULL, 0 );
    objc_println( @"\tkern.osversion: %s", rstring );
    free( rstring );
    rstring = NULL;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MODEL;
    sysctl( mib, 2, NULL, &len, NULL, 0 );
    rstring = malloc( len );
    sysctl( mib, 2, rstring, &len, NULL, 0 );
    objc_println( @"\thw.model: %s", rstring );
    free( rstring );
    rstring = NULL;
    
    sysctlbyname( "machdep.cpu.brand_string", NULL, &len, NULL, 0 );
    rstring = malloc( len );
    sysctlbyname( "machdep.cpu.brand_string", rstring, &len, NULL, 0 );
    objc_println( @"\tmachdep.cpu.brand_string: %s", rstring );
    free( rstring );
    rstring = NULL;
    
    mib[0] = CTL_HW;
    mib[1] = HW_CPU_FREQ;
    len = sizeof( rint );
    sysctl( mib, 2, &rint, &len, NULL, 0 );
    objc_println( @"\thw.cpufrequency: %u", rint );
}

static NSString* getPlatformSerialNumber( void ) {
    io_registry_entry_t     rootEntry = IORegistryEntryFromPath( kIOMasterPortDefault, "IOService:/" );
    CFTypeRef serialAsCFString = NULL;
    
    serialAsCFString = IORegistryEntryCreateCFProperty( rootEntry,
                                                       CFSTR(kIOPlatformSerialNumberKey),
                                                       kCFAllocatorDefault,
                                                       0);
    
    IOObjectRelease( rootEntry );
    return (NULL != serialAsCFString) ? [(NSString*)serialAsCFString autorelease] : nil;
}

static NSDictionary* getCpuIds( void ) {
    NSMutableDictionary*    cpuInfo = [[NSMutableDictionary alloc] init];
    CFMutableDictionaryRef  matchClasses = NULL;
    kern_return_t           kernResult = KERN_FAILURE;
    mach_port_t             machPort;
    io_iterator_t           serviceIterator;
    
    io_object_t             cpuService;
    
    kernResult = IOMasterPort( MACH_PORT_NULL, &machPort );
    if( KERN_SUCCESS != kernResult ) {
        printf( "IOMasterPort failed: %d\n", kernResult );
    }
    
    matchClasses = IOServiceNameMatching( "processor" );
    if( NULL == matchClasses ) {
        printf( "IOServiceMatching returned a NULL dictionary" );
    }
    
    kernResult = IOServiceGetMatchingServices( machPort, matchClasses, &serviceIterator );
    if( KERN_SUCCESS != kernResult ) {
        printf( "IOServiceGetMatchingServices failed: %d\n", kernResult );
    }
    
    while( (cpuService = IOIteratorNext( serviceIterator )) ) {
        CFTypeRef CPUIDAsCFNumber = NULL;
        io_name_t nameString;
        IORegistryEntryGetNameInPlane( cpuService, kIOServicePlane, nameString );
        
        CPUIDAsCFNumber = IORegistryEntrySearchCFProperty( cpuService,
                                                          kIOServicePlane,
                                                          CFSTR( "IOCPUID" ),
                                                          kCFAllocatorDefault,
                                                          kIORegistryIterateRecursively);
        
        if( NULL != CPUIDAsCFNumber ) {
            NSString* cpuName = [NSString stringWithCString:nameString];
            [cpuInfo setObject:(NSNumber*)CPUIDAsCFNumber forKey:cpuName];
        }
        
        if( NULL != CPUIDAsCFNumber ) {
            CFRelease( CPUIDAsCFNumber );
        }
    }
    
    IOObjectRelease( serviceIterator );
    
    return [cpuInfo autorelease];
}

