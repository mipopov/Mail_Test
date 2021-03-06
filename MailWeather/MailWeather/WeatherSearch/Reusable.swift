import Foundation
import UIKit

protocol Reusable {
    static var nib: UINib {get}
    static var reuseIdentifire:String {get}
}

extension Reusable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static var reuseIdentifire:String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UICollectionViewCell: Reusable {}
