import Foundation
import MetalPetal

public enum G8OutputAspectRatio: String{
    case arOriginal = "ORI"
    case ar1by1 = "1:1"
    //Portrait
    case ar3by4 = "3:4"
    case ar9by16 = "9:16"
    //Landscape
    case ar4by3 = "4:3"
    case ar16by9 = "16:9"
    
    func isLandscape() -> Bool{
        switch self {
            case .arOriginal:
                return false
            case .ar1by1:
                return false
            //Portrait
            case .ar3by4:
                return false
            case .ar9by16:
                return false
            //Landscape
            case .ar4by3:
                return true
            case .ar16by9:
                return true
        }
    }
    
    func getInverse() -> G8OutputAspectRatio{
        switch self {
            case .arOriginal:
                return .arOriginal
            case .ar1by1:
                return .ar1by1
            //Portrait
            case .ar3by4:
                return .ar4by3
            case .ar9by16:
                return .ar16by9
            //Landscape
            case .ar4by3:
                return .ar3by4
            case .ar16by9:
                return .ar9by16
        }
    }
    func getRatio()->CGFloat{
        switch self {
            case .arOriginal:
                return CGFloat(0.0)
            case .ar1by1:
                return (CGFloat(1.0)/CGFloat(1.0))
            //Portrait
            case .ar3by4:
                return (CGFloat(3.0)/CGFloat(4.0))
            case .ar9by16:
                return (CGFloat(9.0)/CGFloat(16.0))
            //Landscape
            case .ar4by3:
                return (CGFloat(4.0)/CGFloat(3.0))
            case .ar16by9:
                return (CGFloat(16.0)/CGFloat(9.0))
        }
    }
}

public func cropTo(image: MTIImage, targetAspectRatio: G8OutputAspectRatio) -> MTIImage{
    if targetAspectRatio == .arOriginal {return image}

    let inputSize = CGSize(width: image.extent.size.width, height: image.extent.size.height)
    let inputRatio = image.extent.size.width / image.extent.size.height
    
    let targetRatio = targetAspectRatio.getRatio()
    
    var offset: CGFloat
    var cropFrame: CGRect = CGRect(x: 0, y: 0, width: inputSize.width, height: inputSize.height) //default

        if (inputRatio > targetRatio) {
            offset = (inputRatio - targetRatio) * inputSize.height / inputSize.width;
            cropFrame = CGRect(x:offset/2, y:0.0, width:1.0 - offset, height:1.0);
            
        }
        else {
            offset = (1/inputRatio - 1/targetRatio) * inputSize.width / inputSize.height;
            cropFrame = CGRect(x:0.0, y:offset/2, width:1.0, height:1.0 - offset);
        }
    
    let cropFilter = MTICropFilter()
    cropFilter.cropRegion = MTICropRegion.init(bounds: cropFrame, unit: .percentage)
    cropFilter.inputImage  = image
    return cropFilter.outputImage!
    
}
