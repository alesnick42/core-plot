#import "CPTDefinitions.h"
#import "CPTPlot.h"
#import <Foundation/Foundation.h>

/// @file

@class CPTColor;
@class CPTFill;
@class CPTMutableNumericData;
@class CPTNumericData;
@class CPTPieChart;
@class CPTTextLayer;
@class CPTLineStyle;

/// @ingroup plotBindingsPieChart
/// @{
extern NSString *const CPTPieChartBindingPieSliceWidthValues;
extern NSString *const CPTPieChartBindingPieSliceFills;
extern NSString *const CPTPieChartBindingPieSliceRadialOffsets;
/// @}

/**
 *  @brief Enumeration of pie chart data source field types.
 **/
typedef enum _CPTPieChartField {
    CPTPieChartFieldSliceWidth,           ///< Pie slice width.
    CPTPieChartFieldSliceWidthNormalized, ///< Pie slice width normalized [0, 1].
    CPTPieChartFieldSliceWidthSum         ///< Cumulative sum of pie slice widths.
}
CPTPieChartField;

/**
 *  @brief Enumeration of pie slice drawing directions.
 **/
typedef enum _CPTPieDirection {
    CPTPieDirectionClockwise,       ///< Pie slices are drawn in a clockwise direction.
    CPTPieDirectionCounterClockwise ///< Pie slices are drawn in a counter-clockwise direction.
}
CPTPieDirection;

#pragma mark -

/**
 *  @brief A pie chart data source.
 **/
@protocol CPTPieChartDataSource<CPTPlotDataSource>
@optional

/// @name Slice Style
/// @{

/** @brief @optional Gets a range of slice fills for the given pie chart.
 *  @param pieChart The pie chart.
 *  @param indexRange The range of the data indexes of interest.
 *  @return The pie slice fill for the slice with the given index.
 **/
-(NSArray *)sliceFillsForPieChart:(CPTPieChart *)pieChart recordIndexRange:(NSRange)indexRange;

/** @brief @optional Gets a fill for the given pie chart slice.
 *  This method will not be called if
 *  @link CPTPieChartDataSource::sliceFillsForPieChart:recordIndexRange: -sliceFillsForPieChart:recordIndexRange: @endlink
 *  is also implemented in the datasource.
 *  @param pieChart The pie chart.
 *  @param idx The data index of interest.
 *  @return The pie slice fill for the slice with the given index.
 **/
-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx;

/// @}

/// @name Slice Layout
/// @{

/** @brief @optional Gets a range of slice offsets for the given pie chart.
 *  @param pieChart The pie chart.
 *  @param indexRange The range of the data indexes of interest.
 *  @return An array of radial offsets.
 **/
-(NSArray *)radialOffsetsForPieChart:(CPTPieChart *)pieChart recordIndexRange:(NSRange)indexRange;

/** @brief @optional Offsets the slice radially from the center point. Can be used to @quote{explode} the chart.
 *  This method will not be called if
 *  @link CPTPieChartDataSource::radialOffsetsForPieChart:recordIndexRange: -radialOffsetsForPieChart:recordIndexRange: @endlink
 *  is also implemented in the datasource.
 *  @param pieChart The pie chart.
 *  @param idx The data index of interest.
 *  @return The radial offset in view coordinates. Zero is no offset.
 **/
-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx;

/// @}

/// @name Legends
/// @{

/** @brief @optional Gets the legend title for the given pie chart slice.
 *  @param pieChart The pie chart.
 *  @param idx The data index of interest.
 *  @return The title text for the legend entry for the point with the given index.
 **/
-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)idx;

/// @}
@end

#pragma mark -

/**
 *  @brief Pie chart delegate.
 **/
@protocol CPTPieChartDelegate<CPTPlotDelegate>

@optional

/// @name Slice Selection
/// @{

/** @brief @optional Informs the delegate that a pie slice was
 *  @if MacOnly clicked. @endif
 *  @if iOSOnly touched. @endif
 *  @param plot The pie chart.
 *  @param idx The index of the
 *  @if MacOnly clicked pie slice. @endif
 *  @if iOSOnly touched pie slice. @endif
 **/
-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx;

/** @brief @optional Informs the delegate that a pie slice was
 *  @if MacOnly clicked. @endif
 *  @if iOSOnly touched. @endif
 *  @param plot The pie chart.
 *  @param idx The index of the
 *  @if MacOnly clicked pie slice. @endif
 *  @if iOSOnly touched pie slice. @endif
 *  @param event The event that triggered the selection.
 **/
-(void)pieChart:(CPTPieChart *)plot sliceWasSelectedAtRecordIndex:(NSUInteger)idx withEvent:(CPTNativeEvent *)event;

/// @}

@end

#pragma mark -

@interface CPTPieChart : CPTPlot {
    @private
    CGFloat pieRadius;
    CGFloat pieInnerRadius;
    CGFloat startAngle;
    CGFloat endAngle;
    CPTPieDirection sliceDirection;
    CGPoint centerAnchor;
    CPTLineStyle *borderLineStyle;
    CPTFill *overlayFill;
    BOOL labelRotationRelativeToRadius;
}

@property (nonatomic, readwrite) CGFloat pieRadius;
@property (nonatomic, readwrite) CGFloat pieInnerRadius;
@property (nonatomic, readwrite) CGFloat startAngle;
@property (nonatomic, readwrite) CGFloat endAngle;
@property (nonatomic, readwrite) CPTPieDirection sliceDirection;
@property (nonatomic, readwrite) CGPoint centerAnchor;
@property (nonatomic, readwrite, copy) CPTLineStyle *borderLineStyle;
@property (nonatomic, readwrite, copy) CPTFill *overlayFill;
@property (nonatomic, readwrite, assign) BOOL labelRotationRelativeToRadius;

/** @brief Searches the pie slices for one corresponding to the given angle.
 *  Throws an exception if no such pie slice exists.
 *  @param angle An angle in radians.
 *  @return The index of the pie slice that matches the given angle.
 **/
-(NSUInteger)pieSliceIndexAtAngle:(CGFloat)angle;

/** @brief Computes the halfway-point between the starting and ending angles of a given pie slice.
 *  @param angle A pie slice index.
 *  @return The angle that is halfway between the slice's starting and ending angles, or zero if
 *  an angle matching the given index cannot be found.
 **/
-(CGFloat)medianAngleForPieSliceIndex:(NSUInteger)index;

/// @name Factory Methods
/// @{
+(CPTColor *)defaultPieSliceColorForIndex:(NSUInteger)pieSliceIndex;
/// @}

@end
