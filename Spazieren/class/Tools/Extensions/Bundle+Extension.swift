
import Foundation

extension Bundle{
    //
//    func namespace()-> String{
//        return infoDictionary?["CFBundleName"] as? String ?? ""
//    }
    var namespace:String{
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}
