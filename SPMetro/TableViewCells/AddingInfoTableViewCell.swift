import UIKit

class AddingInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var calculatedTimeLabel: UILabel!
    @IBOutlet weak var transfersLabel: UILabel!
    @IBOutlet weak var calculatedTransfersLabel: UILabel!
    @IBOutlet weak var closeStationLabel: UILabel!
    @IBOutlet weak var calculatedCloseStationLabel: UILabel!
    @IBOutlet weak var buildButton: UIButton!
    @IBAction func buildPathButton(_ sender: Any) {}
    
    override func awakeFromNib() { super.awakeFromNib() }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
