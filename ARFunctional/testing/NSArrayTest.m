
// BSD License. Created by jano@jano.com.es

#import <SenTestingKit/SenTestingKit.h>
#import "NSArray+Functional.h"

/** Test for the NSArray(Functional) category. */
@interface NSArrayTest : SenTestCase
@property (readonly) NSArray *input;
@end

@implementation NSArrayTest

-(NSArray*)input {
    return @[@1,@2,@3];
}

- (void)testAnd {
    NSArray *input = [self input];
    BOOL output = [input and:^BOOL(id object) {
        return [(NSNumber*)object intValue] % 2 == 0;
    }];
    STAssertFalse(output, nil);
}

- (void)testOr {
    NSArray *input = [self input];
    BOOL output = [input or:^BOOL(id object) {
        return [(NSNumber*)object intValue] % 2 == 0;
    }];
    STAssertTrue(output, nil);
}

- (void)testEach {
    NSArray *input = [self input];
    __block NSInteger max;
    [input each:^(id object) {
        if (max<[(NSNumber*)object intValue]){
            max = [(NSNumber*)object intValue];
        }
    }];
    STAssertTrue((max==3), @"should be 3");
    STAssertThrows([@[] each:nil], nil);
}

- (void)testEachWithIndex {
    NSArray *input = [self input];
    __block NSInteger max;
    const NSInteger size = [input count];
    [input eachWithIndex:^(id object, int index) {
        if (index==size-1) max = [(NSNumber*)object intValue];
    }];
    STAssertTrue((max==3), @"should be 3");
    STAssertThrows([@[] eachWithIndex:nil], nil);
}

- (void)testFind {
    NSArray *input = [self input];
    id output = [input find:^BOOL(id object) {
        return [(NSNumber*)object intValue] %2 == 0;
    }];
    STAssertTrue(([(NSNumber*)output isEqualToNumber:@2]), nil);
    STAssertThrows([@[] find:nil], nil);
}

- (void)testHead {
    NSArray *input = [self input];
    NSArray *output = [input head:2];
    STAssertTrue(([output isEqualToArray:@[@1,@2]]), nil);
}

- (void)testMap {
    NSArray *input = [self input];
    NSArray *output = [input map:^id(id object) {
        return [NSNumber numberWithInt:[(NSNumber*)object intValue]-1];
    }];
    STAssertTrue(([output isEqualToArray:@[@0,@1,@2]]), @"should be equal");
    STAssertThrows([@[] map:nil], nil);
}

- (void)testPluck {
    NSArray *input = @[[self input]];
    NSArray *result = [input pluck:@"@count"];
    STAssertTrue(([(NSNumber*)[result lastObject] isEqualToNumber:@3]), nil);
    STAssertThrows([@[] pluck:nil], nil);
}

- (void)testReduce {
    NSArray *input = [self input];
    NSNumber *result = [input reduce:^(id a, id b){
        return [NSNumber numberWithInt:[a intValue]+[b intValue]];
    }];
    STAssertTrue(([result intValue]==6), @"should be 6");
    STAssertThrows([@[] reduce:nil], nil);
}

- (void)testSplit {
    NSArray *input = @[ @1, @2, @3, @4, @5, @6, @7, @8 ];
    NSArray *result = [input split:3];
    STAssertTrue( ([[result objectAtIndex:0] isEqualToArray:@[@1,@2,@3]]), nil );
    STAssertTrue( ([[result objectAtIndex:1] isEqualToArray:@[@4,@5,@6]]), nil );
    STAssertTrue( ([[result objectAtIndex:2] isEqualToArray:@[@7,@8]]), nil );
    result = [input split:0];
    STAssertTrue( ([result count]==0), nil);
}

- (void)testTail {
    NSArray *input = [self input];
    NSArray *output = [input tail:2];
    STAssertTrue(([output isEqualToArray:@[@2,@3]]), nil);
}

- (void)testUntil {
    NSArray *input = [self input];
    [input until:^(id object) {
        BOOL result = [(NSNumber*)object intValue] %2 == 0;
        if (!result) NSLog(@"until %@",object);
        return result;
    }];
    STAssertThrows([@[] until:nil], nil);
}

- (void)testWhere {
    NSArray *input = [self input];
    NSArray *result = [input where:^BOOL(id object) {
        return [(NSNumber*)object intValue]%2==0;
    }];
    STAssertTrue(([result count]==1), nil);
    STAssertThrows([@[] where:nil], nil);
}

@end
