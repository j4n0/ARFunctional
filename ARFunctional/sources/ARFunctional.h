
// BSD License. Created by jano@jano.com.es

/** Container. */
@protocol ARContainer

/** 
 * Returns `TRUE` when `block(object)` returns `TRUE` for every collection's 
 * object.
 * @param block Block. Can't be nil.
 */
-(BOOL) and: (BOOL(^)(id object))block;

/** 
 * Return `TRUE` when `block(object)` returns `TRUE` for at least one 
 * collection's object.
 * @param block Block. Can't be nil.
 */
-(BOOL) or: (BOOL(^)(id object))block;

/** 
 * Call the block passing each of the objects.
 * @param block Block. Can't be nil.
 */
-(void) each: (void (^)(id object))block;

/** 
 * Returns the first object for which the block returns true.
 * @param block Block. Can't be nil.
 */
-(id) find: (BOOL(^)(id object))block;

/** 
 * Apply the block to each object and return the results in a collection of the 
 * same type.
 * @param block Block. Can't be nil.
 */
-(instancetype) map: (id(^)(id object))block;

/**
 * Reduces the collection to one value by running `result=block(first,second)`,
 * then `result=block(result,next)` until the end of the list.
 *
 * - If collection is empty, block(nil,nil) is returned.
 * - If collection has one element, block(element,nil) is returned.
 *
 * @param block Block. Can't be nil.
 */
-(id) reduce: (id(^)(id a, id b))block;

/** 
 * Returns a collection containing the objects for the given key path.
 * @param keypath Key path.
 */
-(instancetype) pluck: (NSString*)keypath;

/** 
 * Returns an array of partitions of the original collection with up to 'size' 
 * elements each. If size is 0, an empty array is returned.
 * @param numberOfPartitions Number of partitions
 */
-(NSArray*) split: (NSUInteger)numberOfPartitions;

/** 
 * Returns a collection with the objects for which the block returns true.
 * @param block Block. Can't be nil.
 */
-(instancetype) where: (BOOL(^)(id object))block;

@end


/** Mutable Element Container. */
@protocol ARMutableElementContainer <NSObject>
/** 
 * Add the given object.
 * @param object Object.
 */
-(void) addObject:(id)object;
@end

/** Container of elements. */
@protocol ARElementContainer <ARContainer>
/** Return a mutable version of this container. */
+(id<ARMutableElementContainer>) emptyMutable;
@end


/** Mutable Element Container. */
@protocol ARMutableMapContainer <NSObject>
/** 
 * Add the given object. 
 * @param anObject Object.
 * @param aKey Key.
 */
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end

/** Mutable Map Container. */
@protocol ARMapContainer <ARContainer>
/** Return a mutable version of this container. */
+(id<ARMutableMapContainer>) emptyMutable;
@end

