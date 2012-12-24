
// BSD License. Created by jano@jano.com.es

#import <SenTestingKit/SenTestingKit.h>
#import "NSSet+Functional.h"

/** Test for the NSSet(Functional) category. */
@interface NSSetTest : SenTestCase
@property (readonly) NSSet *input;
@end

@implementation NSSetTest

-(NSSet*)input {
    return [NSSet setWithArray:@[@1,@2,@3]];
}

- (void)testAnd {
    NSSet *input = [self input];
    BOOL output = [input and:^BOOL(id object) {
        return [(NSNumber*)object intValue] % 2 == 0;
    }];
    STAssertFalse(output, nil);
}

- (void)testEach {
    NSSet *input = [self input];
    __block NSInteger max;
    [input each:^(id object) {
        if (max<[(NSNumber*)object intValue]){
            max = [(NSNumber*)object intValue];
        }
    }];
    STAssertTrue((max==3), @"should be 3");
    STAssertThrows([[NSSet new] each:nil], nil);
}

- (void)testFind {
    NSSet *input = [self input];
    id output = [input find:^BOOL(id object) {
        return [(NSNumber*)object intValue] %2 == 0;
    }];
    STAssertTrue(([(NSNumber*)output isEqualToNumber:@2]), nil);
    STAssertThrows([[NSSet setWithArray:@[]] find:nil], nil);
}

- (void)testMap {
    NSSet *input = [self input];
    NSSet *output = [input map:^id(id object) {
        return [NSNumber numberWithInt:[(NSNumber*)object intValue]-1];
    }];
    STAssertTrue(([output isEqualToSet:[NSSet setWithArray:@[@0,@1,@2]]]), @"should be equal");
    STAssertThrows([[NSSet new] map:nil], nil);
}

- (void)testOr {
    NSSet *input = [self input];
    BOOL output = [input or:^BOOL(id object) {
        return [(NSNumber*)object intValue] % 2 == 0;
    }];
    STAssertTrue(output, nil);
}

- (void)testPluck {
    NSSet *input = [NSSet setWithArray:@[[self input]]];
    NSSet *result = [input pluck:@"@count"];
    STAssertTrue(([(NSNumber*)[result anyObject] isEqualToNumber:@3]), nil);
    STAssertThrows([[NSSet new] map:nil], nil);
}

- (void)testReduce {
    NSSet *input = [self input];
    NSNumber *result = [input reduce:^(id a, id b){
        return [NSNumber numberWithInt:[a intValue]+[b intValue]];
    }];
    STAssertTrue(([result intValue]==6), @"should be 6");
    STAssertThrows([[NSSet new] map:nil], nil);
}

- (void)testSplit {
    NSSet *input = [NSSet setWithArray:@[ @1, @2, @3, @4, @5, @6, @7, @8 ]];
    NSArray *result = [input split:3];
    STAssertTrue( ([[result objectAtIndex:0] count]==3), nil );
    STAssertTrue( ([[result objectAtIndex:1] count]==3), nil );
    STAssertTrue( ([[result objectAtIndex:2] count]==2), nil );
    result = [input split:0];
    STAssertTrue( ([result count]==0), nil);
}

- (void)testWhereTrue {
    NSSet *input = [self input];
    NSSet *result = [input where:^BOOL(id object) {
        return [(NSNumber*)object intValue]%2==0;
    }];
    STAssertTrue(([result count]==1), nil);
    STAssertThrows([[NSSet new]where:nil], nil);
}

@end











