
// BSD License. Created by jano@jano.com.es

#import "ARFunctional.h"

/** Functional methods for NSArray. */
@interface NSArray(Functional) <ARElementContainer>

/** 
 * Call the block passing the object and the object index.
 * @param block Block. Can't be nil.
 */
- (void) eachWithIndex: (void (^)(id object, int index))block;

/** 
 * Return the given number of elements from the beginning of the collection. 
 * @param numberOfElements Number of elements.
 */
- (instancetype) head: (NSUInteger)numberOfElements;

/** 
 * Return the given number of elements from the end of the collection.
 * @param numberOfElements Number of elements.
 */
- (instancetype) tail: (NSUInteger)numberOfElements;

/** 
 * Calls the block for each object until the block returns true. 
 * @param block Block. Can't be nil.
 */
-(void) until: (BOOL(^)(id object))block;

@end


@interface NSMutableArray(Functional)<ARMutableElementContainer>
@end
