//
//  LinearRegression.swift
//  LinearRegression
//
//  Created by Phillip Porch on 10/5/14.
//
//

import Foundation

struct regressionInput {
    var xValue: Double
    var yValue: Double
}

func linearRegression (array: [regressionInput]) -> (intercept: Double, slope: Double, correlation: Double)
{
    var intercept = 0.0
    var slope = 0.0
    var correlation = 0.0
    var sumX = 0.0
    var sumY = 0.0
    var sumXY = 0.0
    var sumX2 = 0.0
    var sumY2 = 0.0
    let numberOfItems = Double(array.count)
    
    for arrayItem in array as [regressionInput]  {
        sumX += arrayItem.xValue
        sumY += arrayItem.yValue
        sumXY += (arrayItem.xValue * arrayItem.yValue)
        sumX2 += (arrayItem.xValue * arrayItem.xValue)
        sumY2 += (arrayItem.yValue * arrayItem.yValue)
    }
    
    slope = ((numberOfItems * sumXY) - (sumX * sumY)) / ((numberOfItems * sumX2) - (sumX * sumX))
    
    intercept = ((sumY * sumX2) - (sumX * sumXY)) / ((numberOfItems * sumX2) - (sumX * sumX))

    correlation = ((numberOfItems * sumXY) - (sumX * sumY)) / (sqrt(numberOfItems * sumX2 - (sumX * sumX)) * sqrt(numberOfItems * sumY2 - (sumY * sumY)))
    
    return (intercept, slope, correlation)
}



