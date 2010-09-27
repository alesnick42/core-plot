#import "CPNumericData+TypeConversion.h"
#import "CPUtilities.h"
#import "complex.h"

@implementation CPNumericData(TypeConversion)

/** @brief Copies the current numeric data and converts the data to a new data type.
 *  @param newDataType The new data type format.
 *  @param newSampleBytes The number of bytes used to store each sample.
 *  @param newByteOrder The new byte order.
 *	@return A copy of the current numeric data converted to the new data type.
 **/
-(CPNumericData *)dataByConvertingToType:(CPDataTypeFormat)newDataType
                             sampleBytes:(size_t)newSampleBytes
                               byteOrder:(CFByteOrder)newByteOrder 
{
	return [self dataByConvertingToDataType:CPDataType(newDataType, newSampleBytes, newByteOrder)];
}

/** @brief Copies the current numeric data and converts the data to a new data type.
 *  @param newDataType The new data type.
 *	@return A copy of the current numeric data converted to the new data type.
 **/
-(CPNumericData *)dataByConvertingToDataType:(CPNumericDataType)newDataType
{
	CPNumericDataType myDataType = self.dataType;
	NSParameterAssert(myDataType.dataTypeFormat != CPUndefinedDataType);
	NSParameterAssert(myDataType.byteOrder != CFByteOrderUnknown);
	
	NSParameterAssert(CPDataTypeIsSupported(newDataType));
	NSParameterAssert(newDataType.dataTypeFormat != CPUndefinedDataType);
	NSParameterAssert(newDataType.byteOrder != CFByteOrderUnknown);
	
	NSData *newData = nil;
	CFByteOrder hostByteOrder = CFByteOrderGetCurrent();
	
	if ( (myDataType.dataTypeFormat == newDataType.dataTypeFormat)
		&& (myDataType.sampleBytes == newDataType.sampleBytes)
		&& (myDataType.byteOrder == newDataType.byteOrder) ) {
		
		newData = [self.data retain];
	}
	else if ( (myDataType.sampleBytes == sizeof(int8_t)) && (newDataType.sampleBytes == sizeof(int8_t)) ) {
		newData = [self.data retain];
	}
	else {
		NSUInteger sampleCount = self.data.length / myDataType.sampleBytes;
		
		newData = [[NSMutableData alloc] initWithLength:(sampleCount * newDataType.sampleBytes)];
		
		NSData *sourceData = nil;
		if ( myDataType.byteOrder != hostByteOrder ) {
			sourceData = [self.data mutableCopy];
			[self swapByteOrderForData:(NSMutableData *)sourceData sampleSize:myDataType.sampleBytes];
		}
		else {
			sourceData = [self.data retain];
		}
		
		[self convertData:sourceData dataType:&myDataType toData:(NSMutableData *)newData dataType:&newDataType];
		
		[sourceData release];
		
		if ( newDataType.byteOrder != hostByteOrder ) {
			[self swapByteOrderForData:(NSMutableData *)newData sampleSize:newDataType.sampleBytes];
		}
	}
    
    CPNumericData *result = [CPNumericData numericDataWithData:newData
													  dataType:newDataType
														 shape:self.shape];
	[newData release];
	return result;
}

#pragma mark -
#pragma mark Data conversion utilites

/** @brief Copies a data buffer and converts the data to a new data type without changing the byte order.
 *
 *	The data is assumed to be in host byte order and no byte order conversion is performed.
 *  @param sourceData The source data buffer.
 *  @param sourceDataType The data type of the source.
 *  @param destData The destination data buffer.
 *  @param destDataType The new data type.
 **/
-(void)convertData:(NSData *)sourceData
		  dataType:(CPNumericDataType *)sourceDataType
			toData:(NSMutableData *)destData
		  dataType:(CPNumericDataType *)destDataType
{
	NSUInteger sampleCount = sourceData.length / sourceDataType->sampleBytes;
	
	// Code generated with "CPNumericData+TypeConversions_Generation.py"
	// ========================================================================
	
	switch ( sourceDataType->dataTypeFormat ) {
		case CPUndefinedDataType:
			break;
		case CPIntegerDataType:
			switch ( sourceDataType->sampleBytes ) {
				case sizeof(int8_t):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // int8_t -> int8_t
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(int8_t));
								}
									break;
								case sizeof(int16_t): { // int8_t -> int16_t
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // int8_t -> int32_t
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // int8_t -> int64_t
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // int8_t -> uint8_t
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // int8_t -> uint16_t
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // int8_t -> uint32_t
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // int8_t -> uint64_t
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // int8_t -> float
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // int8_t -> double
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // int8_t -> float complex
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // int8_t -> double complex
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // int8_t -> NSDecimal
									const int8_t *fromBytes = (int8_t *)sourceData.bytes;
									const int8_t *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromChar(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
				case sizeof(int16_t):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // int16_t -> int8_t
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // int16_t -> int16_t
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(int16_t));
								}
									break;
								case sizeof(int32_t): { // int16_t -> int32_t
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // int16_t -> int64_t
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // int16_t -> uint8_t
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // int16_t -> uint16_t
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // int16_t -> uint32_t
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // int16_t -> uint64_t
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // int16_t -> float
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // int16_t -> double
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // int16_t -> float complex
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // int16_t -> double complex
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // int16_t -> NSDecimal
									const int16_t *fromBytes = (int16_t *)sourceData.bytes;
									const int16_t *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromShort(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
				case sizeof(int32_t):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // int32_t -> int8_t
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // int32_t -> int16_t
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // int32_t -> int32_t
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(int32_t));
								}
									break;
								case sizeof(int64_t): { // int32_t -> int64_t
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // int32_t -> uint8_t
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // int32_t -> uint16_t
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // int32_t -> uint32_t
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // int32_t -> uint64_t
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // int32_t -> float
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // int32_t -> double
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // int32_t -> float complex
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // int32_t -> double complex
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // int32_t -> NSDecimal
									const int32_t *fromBytes = (int32_t *)sourceData.bytes;
									const int32_t *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromLong(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
				case sizeof(int64_t):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // int64_t -> int8_t
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // int64_t -> int16_t
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // int64_t -> int32_t
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // int64_t -> int64_t
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(int64_t));
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // int64_t -> uint8_t
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // int64_t -> uint16_t
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // int64_t -> uint32_t
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // int64_t -> uint64_t
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // int64_t -> float
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // int64_t -> double
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // int64_t -> float complex
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // int64_t -> double complex
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // int64_t -> NSDecimal
									const int64_t *fromBytes = (int64_t *)sourceData.bytes;
									const int64_t *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromLongLong(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
			}
			break;
		case CPUnsignedIntegerDataType:
			switch ( sourceDataType->sampleBytes ) {
				case sizeof(uint8_t):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // uint8_t -> int8_t
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // uint8_t -> int16_t
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // uint8_t -> int32_t
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // uint8_t -> int64_t
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // uint8_t -> uint8_t
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(uint8_t));
								}
									break;
								case sizeof(uint16_t): { // uint8_t -> uint16_t
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // uint8_t -> uint32_t
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // uint8_t -> uint64_t
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // uint8_t -> float
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // uint8_t -> double
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // uint8_t -> float complex
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // uint8_t -> double complex
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // uint8_t -> NSDecimal
									const uint8_t *fromBytes = (uint8_t *)sourceData.bytes;
									const uint8_t *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromUnsignedChar(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
				case sizeof(uint16_t):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // uint16_t -> int8_t
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // uint16_t -> int16_t
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // uint16_t -> int32_t
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // uint16_t -> int64_t
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // uint16_t -> uint8_t
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // uint16_t -> uint16_t
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(uint16_t));
								}
									break;
								case sizeof(uint32_t): { // uint16_t -> uint32_t
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // uint16_t -> uint64_t
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // uint16_t -> float
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // uint16_t -> double
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // uint16_t -> float complex
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // uint16_t -> double complex
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // uint16_t -> NSDecimal
									const uint16_t *fromBytes = (uint16_t *)sourceData.bytes;
									const uint16_t *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromUnsignedShort(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
				case sizeof(uint32_t):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // uint32_t -> int8_t
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // uint32_t -> int16_t
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // uint32_t -> int32_t
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // uint32_t -> int64_t
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // uint32_t -> uint8_t
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // uint32_t -> uint16_t
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // uint32_t -> uint32_t
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(uint32_t));
								}
									break;
								case sizeof(uint64_t): { // uint32_t -> uint64_t
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // uint32_t -> float
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // uint32_t -> double
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // uint32_t -> float complex
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // uint32_t -> double complex
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // uint32_t -> NSDecimal
									const uint32_t *fromBytes = (uint32_t *)sourceData.bytes;
									const uint32_t *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromUnsignedLong(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
				case sizeof(uint64_t):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // uint64_t -> int8_t
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // uint64_t -> int16_t
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // uint64_t -> int32_t
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // uint64_t -> int64_t
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // uint64_t -> uint8_t
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // uint64_t -> uint16_t
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // uint64_t -> uint32_t
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // uint64_t -> uint64_t
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(uint64_t));
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // uint64_t -> float
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // uint64_t -> double
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // uint64_t -> float complex
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // uint64_t -> double complex
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // uint64_t -> NSDecimal
									const uint64_t *fromBytes = (uint64_t *)sourceData.bytes;
									const uint64_t *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromUnsignedLongLong(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
			}
			break;
		case CPFloatingPointDataType:
			switch ( sourceDataType->sampleBytes ) {
				case sizeof(float):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // float -> int8_t
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // float -> int16_t
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // float -> int32_t
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // float -> int64_t
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // float -> uint8_t
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // float -> uint16_t
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // float -> uint32_t
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // float -> uint64_t
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // float -> float
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(float));
								}
									break;
								case sizeof(double): { // float -> double
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // float -> float complex
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // float -> double complex
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // float -> NSDecimal
									const float *fromBytes = (float *)sourceData.bytes;
									const float *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromFloat(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
				case sizeof(double):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // double -> int8_t
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // double -> int16_t
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // double -> int32_t
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // double -> int64_t
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // double -> uint8_t
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // double -> uint16_t
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // double -> uint32_t
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // double -> uint64_t
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // double -> float
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // double -> double
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(double));
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // double -> float complex
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // double -> double complex
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // double -> NSDecimal
									const double *fromBytes = (double *)sourceData.bytes;
									const double *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromDouble(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
			}
			break;
		case CPComplexFloatingPointDataType:
			switch ( sourceDataType->sampleBytes ) {
				case sizeof(float complex):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // float complex -> int8_t
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // float complex -> int16_t
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // float complex -> int32_t
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // float complex -> int64_t
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // float complex -> uint8_t
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // float complex -> uint16_t
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // float complex -> uint32_t
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // float complex -> uint64_t
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // float complex -> float
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // float complex -> double
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // float complex -> float complex
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(float complex));
								}
									break;
								case sizeof(double complex): { // float complex -> double complex
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double complex)*fromBytes++;
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // float complex -> NSDecimal
									const float complex *fromBytes = (float complex *)sourceData.bytes;
									const float complex *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromFloat(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
				case sizeof(double complex):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // double complex -> int8_t
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int8_t)*fromBytes++;
								}
									break;
								case sizeof(int16_t): { // double complex -> int16_t
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int16_t)*fromBytes++;
								}
									break;
								case sizeof(int32_t): { // double complex -> int32_t
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int32_t)*fromBytes++;
								}
									break;
								case sizeof(int64_t): { // double complex -> int64_t
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (int64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // double complex -> uint8_t
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint8_t)*fromBytes++;
								}
									break;
								case sizeof(uint16_t): { // double complex -> uint16_t
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint16_t)*fromBytes++;
								}
									break;
								case sizeof(uint32_t): { // double complex -> uint32_t
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint32_t)*fromBytes++;
								}
									break;
								case sizeof(uint64_t): { // double complex -> uint64_t
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (uint64_t)*fromBytes++;
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // double complex -> float
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float)*fromBytes++;
								}
									break;
								case sizeof(double): { // double complex -> double
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (double)*fromBytes++;
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // double complex -> float complex
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = (float complex)*fromBytes++;
								}
									break;
								case sizeof(double complex): { // double complex -> double complex
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(double complex));
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // double complex -> NSDecimal
									const double complex *fromBytes = (double complex *)sourceData.bytes;
									const double complex *lastSample = fromBytes + sampleCount;
									NSDecimal *toBytes = (NSDecimal *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFromDouble(*fromBytes++);
								}
									break;
							}
							break;
					}
					break;
			}
			break;
		case CPDecimalDataType:
			switch ( sourceDataType->sampleBytes ) {
				case sizeof(NSDecimal):
					switch ( destDataType->dataTypeFormat ) {
						case CPUndefinedDataType:
							break;
						case CPIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(int8_t): { // NSDecimal -> int8_t
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									int8_t *toBytes = (int8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalCharValue(*fromBytes++);
								}
									break;
								case sizeof(int16_t): { // NSDecimal -> int16_t
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									int16_t *toBytes = (int16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalShortValue(*fromBytes++);
								}
									break;
								case sizeof(int32_t): { // NSDecimal -> int32_t
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									int32_t *toBytes = (int32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalLongValue(*fromBytes++);
								}
									break;
								case sizeof(int64_t): { // NSDecimal -> int64_t
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									int64_t *toBytes = (int64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalLongLongValue(*fromBytes++);
								}
									break;
							}
							break;
						case CPUnsignedIntegerDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(uint8_t): { // NSDecimal -> uint8_t
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									uint8_t *toBytes = (uint8_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalUnsignedCharValue(*fromBytes++);
								}
									break;
								case sizeof(uint16_t): { // NSDecimal -> uint16_t
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									uint16_t *toBytes = (uint16_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalUnsignedShortValue(*fromBytes++);
								}
									break;
								case sizeof(uint32_t): { // NSDecimal -> uint32_t
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									uint32_t *toBytes = (uint32_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalUnsignedLongValue(*fromBytes++);
								}
									break;
								case sizeof(uint64_t): { // NSDecimal -> uint64_t
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									uint64_t *toBytes = (uint64_t *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalUnsignedLongLongValue(*fromBytes++);
								}
									break;
							}
							break;
						case CPFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float): { // NSDecimal -> float
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									float *toBytes = (float *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFloatValue(*fromBytes++);
								}
									break;
								case sizeof(double): { // NSDecimal -> double
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									double *toBytes = (double *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalDoubleValue(*fromBytes++);
								}
									break;
							}
							break;
						case CPComplexFloatingPointDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(float complex): { // NSDecimal -> float complex
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									float complex *toBytes = (float complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalFloatValue(*fromBytes++);
								}
									break;
								case sizeof(double complex): { // NSDecimal -> double complex
									const NSDecimal *fromBytes = (NSDecimal *)sourceData.bytes;
									const NSDecimal *lastSample = fromBytes + sampleCount;
									double complex *toBytes = (double complex *)destData.mutableBytes;
									while ( fromBytes < lastSample ) *toBytes++ = CPDecimalDoubleValue(*fromBytes++);
								}
									break;
							}
							break;
						case CPDecimalDataType:
							switch ( destDataType->sampleBytes ) {
								case sizeof(NSDecimal): { // NSDecimal -> NSDecimal
									memcpy(destData.mutableBytes, sourceData.bytes, sampleCount * sizeof(NSDecimal));
								}
									break;
							}
							break;
					}
					break;
			}
			break;
	}
	
	// End of code generated with "CPNumericData+TypeConversions_Generation.py"
	// ========================================================================
}

/** @brief Swaps the byte order for each sample stored in a data buffer.
 *  @param sourceData The data buffer.
 *  @param sampleSize The number of bytes in each sample stored in sourceData.
 **/
-(void)swapByteOrderForData:(NSMutableData *)sourceData sampleSize:(size_t)sampleSize
{
	NSUInteger sampleCount;
	switch ( sampleSize ) {
		case sizeof(uint16_t): {
			uint16_t *samples = (uint16_t *)sourceData.mutableBytes;
			sampleCount = sourceData.length / sampleSize;
			uint16_t *lastSample = samples + sampleCount;
			
			while ( samples < lastSample ) {
				uint16_t swapped = CFSwapInt16(*samples);
				*samples++ = swapped;
			}
		}
			break;
		case sizeof(uint32_t): {
			uint32_t *samples = (uint32_t *)sourceData.mutableBytes;
			sampleCount = sourceData.length / sampleSize;
			uint32_t *lastSample = samples + sampleCount;
			
			while ( samples < lastSample ) {
				uint32_t swapped = CFSwapInt32(*samples);
				*samples++ = swapped;
			}
		}
			break;
		case sizeof(uint64_t): {
			uint64_t *samples = (uint64_t *)sourceData.mutableBytes;
			sampleCount = sourceData.length / sampleSize;
			uint64_t *lastSample = samples + sampleCount;
			
			while ( samples < lastSample ) {
				uint64_t swapped = CFSwapInt64(*samples);
				*samples++ = swapped;
			}
		}
			break;
		default:
			// do nothing
			break;
	}
}

@end
