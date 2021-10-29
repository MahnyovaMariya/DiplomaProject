import UIKit

class DetailPathTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameStationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var personView: UIView!
    
    override func awakeFromNib() { super.awakeFromNib() }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameStationLabel.isHidden = false
        self.infoLabel.isHidden = false
        self.minutesLabel.isHidden = false
        self.timeLabel.isHidden = false
        self.closeLabel.isHidden = true
        self.personView.layer.sublayers?.removeAll()
        self.nameStationLabel.textColor = UIColor.black
        self.infoLabel.textColor = UIColor.black
        self.minutesLabel.textColor = UIColor.black
        self.timeLabel.textColor = UIColor.black
        self.closeLabel.textColor = UIColor.black
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
