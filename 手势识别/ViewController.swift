
//2016-7-25

import UIKit
//基础控制器
class ViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet var im: UIImageView!
    var lastScaleFactor : CGFloat! = 1  //放大、缩小
    var netRotation : CGFloat = 0;//旋转
    var netTranslation : CGPoint = CGPoint(x: 0, y: 0)//平移
    var images : NSArray = ["1","2","3"]// 图片数组
    var imageIndex : Int = 0 //数组下标
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGestureRecognizerDelegate
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        //设置手势点击数,双击：点2下
        tapGesture.numberOfTapsRequired = 2
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        //手势为捏的姿势:按住option按钮配合鼠标来做这个动作在虚拟器上
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinchGesture:")
        //self.view.addGestureRecognizer(pinchGesture)
        
        //旋转手势:按住option按钮配合鼠标来做这个动作在虚拟器上
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: "handleRotateGesture:")
        self.view.addGestureRecognizer(rotateGesture)
        
        //拖手势  同一对象加入托手势时，滑动手势不能用。
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        self.view.addGestureRecognizer(panGesture)
        
        //划动手势
        //右划
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        self.view.addGestureRecognizer(swipeGesture)
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target: self, action: "handleLongpressGesture:")
        //长按时间为1秒
        longpressGesutre.minimumPressDuration = 1
        //允许15秒运动
        longpressGesutre.allowableMovement = 15
        //所需触摸手指个数
        longpressGesutre.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(longpressGesutre)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //双击屏幕时会调用此方法,放大和缩小图片
    func handleTapGesture(sender: UITapGestureRecognizer){
        //判断imageView的内容模式是否是UIViewContentModeScaleAspectFit,该模式是原比例，按照图片原时比例显示大小
        if im.contentMode == UIViewContentMode.ScaleAspectFit{
            //把imageView模式改成UIViewContentModeCenter，按照图片原先的大小显示中心的一部分在imageView
            im.contentMode = UIViewContentMode.Center
        }else{
            im.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    
    //捏的手势，使图片放大和缩小，捏的动作是一个连续的动作
    func handlePinchGesture(sender: UIPinchGestureRecognizer){
        let factor = sender.scale
        if sender.state == .Began{
            print(factor)
        }
        if sender.state == .Changed{
            print(factor)
        }
//        if factor > 1{
            //图片放大
//            im.transform = CGAffineTransformMakeScale(lastScaleFactor+factor-1, lastScaleFactor+factor-1)
            im.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor)

//        }else{
//            //缩小
//            im.transform = CGAffineTransformMakeScale(lastScaleFactor*factor, lastScaleFactor*factor)
//        }
        //状态是否结束，如果结束保存数据
        if sender.state == UIGestureRecognizerState.Ended{
//            if factor > 1{
//                lastScaleFactor = lastScaleFactor + factor - 1
//            }else{
                lastScaleFactor = lastScaleFactor * factor
//            }
        }
    }
    
    //旋转手势
    func handleRotateGesture(sender: UIRotationGestureRecognizer){
        //浮点类型，得到sender的旋转度数
        let rotation : CGFloat = sender.rotation
        if sender.state == .Changed{
            print(rotation)
        }
        //旋转角度CGAffineTransformMakeRotation,改变图像角度
        im.transform = CGAffineTransformMakeRotation(rotation+netRotation)
//        im.transform = CGAffineTransformMakeRotation(rotation)
        //状态结束，保存数据
        if sender.state == UIGestureRecognizerState.Ended{
            netRotation += rotation
        }
    }
    //拖手势
    func handlePanGesture(sender: UIPanGestureRecognizer){
        //得到拖的过程中的xy坐标
        
        let translation : CGPoint = sender.translationInView(im)
        //平移图片CGAffineTransformMakeTranslation
        im.transform = CGAffineTransformMakeTranslation(netTranslation.x+translation.x, netTranslation.y+translation.y)
        if sender.state == UIGestureRecognizerState.Ended{
            netTranslation.x += translation.x
            netTranslation.y += translation.y
        }
    }
    //划动手势
    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        //划动的方向
        let direction = sender.direction
        //判断是上下左右
        switch (direction){
        case UISwipeGestureRecognizerDirection.Left:
            print("Left")
            imageIndex++;//下标++
            break
        case UISwipeGestureRecognizerDirection.Right:
            print("Right")
            imageIndex--;//下标--
            break
        case UISwipeGestureRecognizerDirection.Up:
            print("Up")
            break
        case UISwipeGestureRecognizerDirection.Down:
            print("Down")
            break
        default:
            break;
        }
        //得到不越界不<0的下标
        imageIndex = imageIndex < 0 ? images.count-1:imageIndex%images.count
        //imageView显示图片
        im.image = UIImage(named: images[imageIndex] as! String)
    }
    
    //长按手势
    func handleLongpressGesture(sender : UILongPressGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.Began{
            //创建警告
//            var actionSheet = UIActionSheet(title: "Image options", delegate: self, cancelButtonTitle: "cancel", destructiveButtonTitle: "ok", otherButtonTitles: "other")
//            actionSheet.showInView(self.view)
            let alertV = UIAlertController(title: "长按", message: "开始了", preferredStyle: UIAlertControllerStyle.Alert)
            let alertA = UIAlertAction(title: "OK", style: .Destructive, handler: nil)
            alertV.addAction(alertA)
            self.presentViewController(alertV, animated: true, completion: nil)
        }
    }
}
//到这里就差不多