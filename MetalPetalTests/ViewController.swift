//
//  ViewController.swift
//  MetalPetalTests
//
//  Created by Omar Juarez Ortiz on 2020-03-03.
//  Copyright © 2020 Omar Juarez Ortiz. All rights reserved.
//

import UIKit
import MetalPetal

class ViewController: UIViewController {

    var context: MTIContext!
    
    @IBOutlet weak var renderView: MTIImageView!
    var inputImage: MTIImage!
    var saturationFilter: MTISaturationFilter!
    var outputAspectRatio: G8OutputAspectRatio = .ar9by16 //<--- change this to any other aspect ratio and it will work fine.
    
    var displayLink: CADisplayLink!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        //ORIENATION IS LOCKED IN UINavigationController+OrientationLock.swift
        do {
            try context = MTIContext(device: MTLCreateSystemDefaultDevice()!)
            renderView.context = context
        }catch{
            print ("no context")
        }
        print("HOLA")
        renderView.contentMode = .scaleAspectFit
        renderView.resizingMode = .aspect
        //RENDER TIMER
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.displayLinkDidRefresh(link:)))
        self.displayLink.preferredFramesPerSecond = 24
        self.displayLink.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        
        
        inputImage = MTIImage(cgImage: UIImage(named: "testImage")!.cgImage!, options: [.SRGB: false], isOpaque: true)
        saturationFilter = MTISaturationFilter()
        
        
        
        
        
        //MARK: Orientation Listener
        let nof = NotificationCenter.default
        nof.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: .main) {[weak self] notif in
            self?.updateAspectRatioOnRotation()
            self?.adjustRenderingViewOrientation()
        }
        
        
    }
    
    @objc func displayLinkDidRefresh(link: CADisplayLink) {
        DispatchQueue.main.async {
            self.saturationFilter.saturation = Float(1.0 + sin(CFAbsoluteTimeGetCurrent() * 2.0))
            self.saturationFilter.inputImage = self.inputImage
            
            self.renderView.image = cropTo(image: self.saturationFilter.outputImage!, targetAspectRatio: self.outputAspectRatio)
        }
    }
    
    //1
    func updateAspectRatioOnRotation(){
        let o = UIDevice.current.orientation
        if o.isFlat {return}
        //Invert the output aspect ratio. For examlpe if current Aspect ratio is 9by16, it inverts to 16by9
        if o.isLandscape != self.outputAspectRatio.isLandscape() {
            outputAspectRatio = outputAspectRatio.getInverse()
        }
    }
    //2
    func adjustRenderingViewOrientation(){
        //Do the proper RenderView Rotation if it's an iPhone or similar.
        
        let isiPad =  UIDevice.current.userInterfaceIdiom == .pad ? true : false
        if isiPad {
            return
        }
        let o = UIDevice.current.orientation
        
        var angle:Double = 0;
        if (o == .landscapeLeft ){angle = .pi/2}
        else if (o == .landscapeRight ){angle = -.pi/2}
        else if (o == .portraitUpsideDown || o == .faceUp ){ return}
        DispatchQueue.main.async {
            let rot = CGAffineTransform(rotationAngle: (CGFloat)(angle))
            self.renderView.transform = rot
            self.renderView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.renderView.center = self.view.center
            self.renderView.setNeedsDisplay()
        }
    }
    
    

}

