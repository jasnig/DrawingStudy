//
//  ViewController.swift
//  DrawingStudy
//
//  Created by jasnig on 16/5/21.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

import UIKit


class TestView: UIView {
    // setNeedsDisplay()
    // 调用这个函数会触发drawRect方法, 当这个函数被调用的时候, 系统会通知这个UIView整个界面需要重绘. 但是这个函数会直接返回, 但界面的变化不会马上返回, 需要等到下个生命周期进行重绘
    // 如果只有一部分需要重绘 可以调用这个方法 setNeedsDisplayInRect(rect: CGRect)
    
    // 这个方法里面应该只做与界面的绘制有关的工作, 不应该进行任何的数据处理或者程序的逻辑相关的任务, 以保证尽快执行完毕
    override func drawRect(rect: CGRect) {
        // 获得当前的上下文
//        let context = UIGraphicsGetCurrentContext()!
//        drawLineTest()
//        drawCircleTest()
        
        let context = UIGraphicsGetCurrentContext()
//        CGContextSetFillColorWithColor(context, UIColor.blueColor().CGColor)
        
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 5.0)
        /// phase: 起始点
        /// lengths 指定虚线和实现的宽度(从起始点按照数组的值绘制实线-虚线-实线-虚线...)
//        CGContextSetLineDash(context, 0, [5,5], 2)
        CGContextSetLineJoin(context, CGLineJoin.Round)
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, 10.0, 10.0)
        CGContextAddLineToPoint(context, 10.0, 80.0)
        CGContextAddLineToPoint(context, 80.0, 80.0)
        CGContextStrokePath(context)
//        CGContextSetRGBStrokeColor(context, r, g, b, alpha)
        
//        CGContextBeginPath(context)
//        CGContextMoveToPoint(context, 10.0, 10.0)
//        CGContextAddLineToPoint(context, 10.0, 70.0)
//        CGContextAddLineToPoint(context, 70.0, 70.0)
//        CGContextClosePath(context)
//        CGContextClip(context)
//        CGContextFillPath(context)
        // 剪裁
        ///

        
    }
    
    
    func drawCircleTest() {
        
        func radiansFromDegree(angle: Double) -> CGFloat {
            return CGFloat(angle*M_PI / 180.0)
        }
        
        let center = CGPoint(x: 80.0, y: 80.0)
        
        
        let path = UIBezierPath()
//        path.lineWidth = 10.0
        path.lineCapStyle = CGLineCap.Round
        UIColor.redColor().setFill()
        UIColor.blueColor().setStroke()
        // 从圆心处开始绘制  否则使用fill()不能形成圆形, 只会填充和弦围成的区域
        path.moveToPoint(center)
        path.addArcWithCenter(center, radius: 50.0, startAngle: radiansFromDegree(0.0), endAngle: radiansFromDegree(270), clockwise: true)
        
        //位移
        
        func setTransform(x: Int, y: Int) {
            // 移动
            var transforms = CGAffineTransformMakeTranslation(CGFloat(x), CGFloat(y))
            //缩放
            transforms = CGAffineTransformScale(transforms, 0.9, 0.8)
            let revert = CGAffineTransformInvert(transforms)
            path.applyTransform(transforms)
            
            path.stroke()
            path.fill()
            // 还原
            path.applyTransform(revert)
        }
        
        for i in 0...2 {
            for j in 0...2 {
                setTransform(i*110, y: j*110)
            }
        }
        
    }
    
    func drawLineTest() {
        // 绘制路径和内容
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: 100.0, y: 100.0))
        path.addLineToPoint(CGPoint(x: 100.0, y: 200.0))
        path.addLineToPoint(CGPoint(x: 200.0, y: 200.0))
        path.lineWidth = 5.0
        path.lineCapStyle = CGLineCap.Round
        
        // 虚线
        path.setLineDash([10.0, 10.0, 5.0], count: 3, phase: 0)
        
        //        UIColor.redColor().setStroke()
        // 封闭路径, 首尾点会连接起来
        //        path.closePath()
        // 填充指定的路径
        //        path.stroke()
        // 使用fill() 将会填充指定的路径包含的区域, 即使没有指定为closePath() 系统默认也会使用closePath()
        // 调用set()会设置fill或者stroke的颜色
        //        UIColor.redColor().set()
        UIColor.redColor().setStroke()
        path.stroke()
        UIColor.blueColor().setFill()
        path.fill()
        
    }

}


/**
 
 1. 首先要获取到一个上下文用来作为"画布", 获取的方法有如下几种
    * 重写了UIView的drawRect()方法时, 当这个view的内容需要更新的时候会调用这个方法, 所以系统在这个方法里面系统会默认提供一个上下文, 可以通过UIGraphicsGetCurrentContext()
        (在Mac OS中需要CGContextRef myContext = [[NSGraphicsContext currentContext] graphicsPort];)
    * 重写了UIView的drawRect()方法时, 在这个方法里面系统会默认提供一个上下文, 很多时候并不需要使用上下文这个参数就可以绘图
    * 在其他地方可以通过UIGraphicsBeginImageContextWithOptions()获取到
    通过UIGraphicsBeginImageContextWithOptions()获取到的图形上下文的坐标系和UIKit相同
 2. 在获取到的上下文上选择绘图方式来绘制图形, 可以使用UIKit或者Quartz 2D
 3.
 Quartz 2D
 CGContextSaveGState -> 会将当前上下文的状态(state, 有些可以设置的属性并不属于state,将不会被保存,比如说path)拷贝一份并且push到上下文栈中
 CGContextRestoreGState -> 会pop出刚刚保存的上下文的备份, 并且设置为当前的上下文, 完成后恢复为原来状态
 坐标系: 和数学中的直角坐标系相同, 原点在左下角, UIKit中的坐标系的原点在左上角, 所以使用Quartz 2D绘图的时候要注意进行坐标系的转换
 内存管理: 在oc中需要我们自己来管理, 即当调用含有create或者copy的函数获得上下文的时候, 需要在使用完后手动release, 但在swift中我们不用管理了
 
 Path: 
  * 这种方法直接创建一个path然后绘制, 但是不会返回这个path
    CGContextBeginPath -> 创建路径, 这个时候没有起始点, 需要先指定起始点
    CGContextMoveToPoint -> 指定起始点或者移动到新的点
    CGContextAddLineToPoint -> 从当前的点到指定的点之间画一条线
    CGContextAddArc -> 圆弧
    CGContextAddArcToPoint -> 会在当前点和指定点与坐标系平行的直线做切线画圆弧
    CGContextAddCurveToPoint -> 画曲线(bezier)
    CGContextClosePath -> 将起始点和结束点连接起来形成封闭的路径
    CGContextAddEllipseInRect -> 椭圆
    // 常用的绘制的方法 stroke方式   -> "描边"即只绘制路径
    CGContextStrokePath -> 绘制路径
    CGContextStrokeRect -> 绘制指定的CGRect
    CGContextStrokeRectWithWidth -> 
    ...
    
    // fill方式 -> "填充"即绘制路径包括的所有区域(所有路径都会被当作closePath处理)
 
    Filling有两种模式
    * nonzero winding number(默认) -> 如果两个路径有重叠的时候, 绘制方向相同的话, 那么重叠部分的绘制可能不是我们希望的
    * even-odd -> 不受绘制方向的影响
    CGContextEOFillPath
    CGContextFillPath
    CGContextFillRect
    CGContextFillRects
    CGContextFillEllipseInRect 
    ...
   * 这种方法会返回path 作用和上面一一对应
    CGPathCreateMutable
 
 
 Stroke模式下可以设置的属性
 CGContextSetLineWidth -> 线宽度
 CGContextSetLineJoin -> 线的连接点的样式
 CGContextSetLineCap -> 端点的样式
 CGContextSetLineDash -> 虚线
 CGContextSetStrokeColorWithColor -> 颜色
 ...
 
 Blend Modes -> 设置Quartz怎样在背景上应用绘制的点(默认为normal模式)
    result = (alpha * foreground) + (1 - alpha) * background
 CGContextSetBlendMode
 
        CGBlendMode
         case Normal -> 这种就类似于直接将两张图片放在一起, 重叠部分会被最上层的显示
         case Multiply -> 这种模式, 重叠部分会相互影响
         ...
 
 CGContextClip -> 剪裁???
 
 
 
 Color and Color Spaces
 /**简单的说就是我们设置的color数值需要依耐与指定的颜色空间才能正常显示, 相同的颜色数值在不同的颜色空间里面可能是不同的
 iOS中支持的设置颜色空间的方法是device color space
 //创建颜色空间
 CGColorSpaceCreateDeviceGray
 CGColorSpaceCreateDeviceRGB 
 CGColorSpaceCreateDeviceCMYK
 
 // 设置颜色空间值的方法
 CGContextSetFillColorSpace
 CGContextSetRGBStrokeColor
 CGContextSetRGBFillColor
 ...
 个人比较习惯用这个, 颜色空间值是由CGColor指定的
 CGContextSetStrokeColorWithColor
 CGContextSetFillColorWithColor
 
 
 */
 
 
 /**Transforms
 
  * Affine Transforms 和上面对应的效果一样
 CGAffineTransformMake -> 一般不会用到, 因为需要自己进行矩阵运算来得到结果
 CGAffineTransformMakeTranslation
 CGAffineTransformTranslate
 CGAffineTransformMakeRotation
 CGAffineTransformRotate
 CGAffineTransformMakeScale
 CGAffineTransformScale
 CGContextConcatCTM -> 混合使用多重transform时需要调用
 CGAffineTransformIdentity -> 原始的transform
 
 CGAffineTransformInvert ->恢复为改变前的transform, 但是一般使用 CGContextSaveGState
 CGContextRestoreGState 
 
 只改变指定位置的transform
 CGSizeApplyAffineTransform
 CGRectApplyAffineTransform
 
 // 比较
 CGAffineTransformEqualToTransform
 CGAffineTransformIsIdentity
 */
 
 /**
 阴影
 CGContextSetShadow -> 设置shadow后所有绘制的对象都会有一个阴影, 默认颜色为 1/3透明度的黑色
 CGContextSetShadowWithColor -> 设置shadow颜色
 绘制阴影的步骤
    * 保存上下文
    * 设置阴影
    * 绘制所有的内容
    * reStore上下文
 
 */
 */
class ViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    let test = ProgressView()

    @IBAction func slideAction(sender: UISlider) {
//        test.progress = Double(sender.value)
        let imageView = UIImageView(frame: CGRect(x: 200.0, y: 200.0, width: 100.0, height: 100.0))
        let image = snapView(view)
        let cutmage = cutImage(image, cutRect: CGRect(x: 20.0, y: 20.0, width: 50.0, height: 60.0))
        imageView.image = cutmage
        
        view.addSubview(imageView)
        
        
//        let snapShotView  = view.resizableSnapshotViewFromRect(view.bounds, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
//        view.addSubview(snapShotView)

    }
    
    func cutImage(image: UIImage, cutRect: CGRect) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(cutRect.size, false, 0.0)
        // 获取上下文
        let context = UIGraphicsGetCurrentContext()
        // 转换坐标原点到左下角
        CGContextTranslateCTM(context, 0.0, cutRect.size.height)
        CGContextScaleCTM(context, 1.0, -1.0)
        // 设置绘制模式
        CGContextSetBlendMode(context, .Copy)
        // 绘图
        
        CGContextDrawImage(context, cutRect, image.CGImage)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        testResizeImage()
//        testCircleView()
        testDrawing()
        
    }
    
    func testDrawing() {
        let testView = TestView(frame: CGRect(x: 100.0, y: 100.0, width: 100.0, height: 100.0))
//        testView.backgroundColor = UIColor.redColor()
        view.addSubview(testView)
    }
    
    
    func testCircleView() {
        let testView = UIView(frame: CGRect(x: 100.0, y: 200.0, width: 100.0, height: 200.0))
        testView.backgroundColor = UIColor.greenColor()
//        testView.layer.cornerRadius = 20.0
//        testView.layer.masksToBounds = true
        let layer = CAShapeLayer()
        // 这里byRoundingCorners -> 指定圆角
        layer.path = UIBezierPath(roundedRect: testView.bounds, byRoundingCorners: [UIRectCorner.TopLeft, .TopRight], cornerRadii: CGSize(width: 20, height: 20)).CGPath
        testView.layer.mask = layer
        
        view.addSubview(testView)
        
        
        let imageView = UIImageView(frame: CGRect(x: 200.0, y: 200.0, width: 100.0, height: 100.0))
        imageView.contentMode = .ScaleAspectFit
//        let image = snapView(testView)
//        let cutmage = cutImage(image, cutRect: CGRect(x: 0.0, y: 10.0, width: 50.0, height: 30.0))
        let image = imageFromColor(UIColor.redColor(), size: CGSize(width: 100.0, height: 100.0))
        imageView.image = image
        
        view.addSubview(imageView)
    }
    
    func testResizeImage() {
        
        let imageView = UIImageView(frame: CGRect(x: 100.0, y: 100.0, width: 100.0, height: 100.0))
        view.addSubview(imageView)
        let retriveImage = resizeImage(UIImage(named: "1")!, toWidth: 100.0, withHeight: 100.0)
        print(retriveImage)
        imageView.image = retriveImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func imageFromColor(color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let rect = CGRect(origin: CGPointZero, size: size)
//        color.setFill()
//        UIRectFill(rect)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    // 截屏
    func snapView(targetView: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, false, 0)
        targetView.drawViewHierarchyInRect(targetView.bounds, afterScreenUpdates: true)
        
        let snapdImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapdImage
        /**
         注意: 可以使用view.resizableSnapshotViewFromRect(view.bounds, afterScreenUpdates: false, withCapInsets: UIEdgeInsetsZero)
         这个方法直接获取到截屏后并且拉伸的view
         */
        
    }
    
    // 缩放图片
    func resizeImage(image: UIImage, toWidth width: CGFloat, withHeight height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        // 开启一个上下文
        /// 设置为false 表示背景不透明 -> 黑色
        /// 设置为 0 -> 可以自适应不同的屏幕的scale显示
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // 获取上下文
        let context = UIGraphicsGetCurrentContext()
        // 转换坐标原点到左下角
        CGContextTranslateCTM(context, 0.0, height)
        CGContextScaleCTM(context, 1.0, -1.0)
        // 设置绘制模式
        CGContextSetBlendMode(context, .Copy)
        // 绘图
        CGContextDrawImage(context, CGRect(origin: CGPointZero, size: size), image.CGImage)
        
//        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        // 取得图片
        let retrivedImage = UIGraphicsGetImageFromCurrentImageContext()
        // 结束上下文
        UIGraphicsEndImageContext()
        return retrivedImage
    }
    
    


}


class ProgressView: UIView {
    var progress: Double = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override func drawRect(rect: CGRect) {
        func radiansFrom(degree: Double) -> CGFloat {
            return CGFloat(degree*M_PI / 180.0)
        }
//        let center = CGPoint(x: rect.width*0.5, y: rect.height*0.5)
//        let path = UIBezierPath()
//        UIColor.redColor().setFill()
//        UIColor.blueColor().setStroke()
//        // 从圆心处开始绘制  否则使用fill()不能形成圆形, 只会填充和弦围成的区域
//        path.moveToPoint(center)
//        path.addArcWithCenter(center, radius: rect.width*0.5, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(progress * 2*M_PI - M_PI_2), clockwise: true)
//        path.fill()
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextMoveToPoint(context, rect.width*0.5, rect.height*0.5)
        // C语言中 0 == true 否则 == false
        CGContextAddArc(context, rect.width*0.5, rect.height*0.5, rect.width*0.5, CGFloat(-M_PI_2), CGFloat(progress * 2*M_PI - M_PI_2), 0)
        UIColor.redColor().setFill()
        CGContextDrawPath(context, .Fill)
    }
}
