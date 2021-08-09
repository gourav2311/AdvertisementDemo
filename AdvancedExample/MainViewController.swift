import GoogleInteractiveMediaAds
import UIKit

class MainViewController: UIViewController {

  // Handle to TableView.
  @IBOutlet var tableView: UITableView!

  // Input field for language pop-up.
  @IBOutlet weak var languageInput: UITextField?

  // Storage point for videos.
  var videos: NSArray!
  var adsLoader: IMAAdsLoader?
 

  // Set up the app.
  override func viewDidLoad() {
    super.viewDidLoad()
    initVideos()
    setUpAdsLoader()
    tableView.tableFooterView = UIView()

    // For PiP.
    do {
      try AVAudioSession.sharedInstance().setActive(true)
      try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
    } catch {
      NSLog("Error setting background playback - PiP will not work.")
    }
  }

  // Populate the video array.
  func initVideos() {
   
    let bipThumbnail = UIImage(named: "bunny.png")

    videos = [
      
      Video(
        title: "Gourav demo for preRoll, MidRoll, PostRoll",
        thumbnail: bipThumbnail,
        video:"",
        tag: kAdRulesTag),
     
    ]
  }

  // Initialize AdsLoader.
  func setUpAdsLoader() {
    if adsLoader != nil {
      adsLoader = nil
    }
    let settings = IMASettings()
 
    settings.enableBackgroundPlayback = true
    adsLoader = IMAAdsLoader(settings: settings)
  }

 

  

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showVideo" {
      let indexPath: IndexPath! = tableView.indexPathForSelectedRow
      if indexPath != nil {
        let video = videos[indexPath.row] as! Video
        let headedTo = segue.destination as! VideoViewController
        headedTo.video = video
        headedTo.adsLoader = adsLoader
      }
    }
  }

  override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
    if tableView.indexPathForSelectedRow != nil {
      return true
    }
    return false
  }

  // Only allow one selection.
  @objc func numberOfSectionsInTableView(_ tableView: UITableView) -> NSInteger {
    return 1
  }

  // Returns the number of items to be presented in the table.
  @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return videos.count
  }

  @objc func tableView(
    _ tableView: UITableView,
    cellForRowAtIndexPath indexPath: IndexPath
  ) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(
        withIdentifier: "cell",
        for: indexPath) as! VideoTableViewCell
    let selectedVideo = videos[(indexPath as NSIndexPath).row] as! Video
    cell.populateWithVideo(selectedVideo)
    return cell
  }

}
