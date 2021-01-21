import Preferences

class PurpleSwitchTableCell: PSSwitchTableCell {
    
    override var control: UIControl! {
        get {
            if let control = super.control as? UISwitch {
                control.onTintColor = .systemPurple
            }
            return super.control
        }
        set {
            super.control = newValue
        }
    }
    
}
