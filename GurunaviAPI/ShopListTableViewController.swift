//
//  ShopListTableViewController.swift
//  GurunaviAPI
//
//  Created by 佐藤大介 on 2018/05/04.
//  Copyright © 2018年 sato daisuke. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ShopListTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    var rests: [Restaurant] = []
    var selectedRest: Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        
        textField.delegate = self
        tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")

    }
    
    @IBAction func tapSearchButton(_ sender: UIButton) {
        getData()
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCell
        let restaurant = self.rests[indexPath.row]
        cell.nameLabel.text = restaurant.name
        
        let imageString = restaurant.imageURL
        if let unwrappedImageString = imageString {
            let myURL = URL(string: unwrappedImageString)
            cell.restaurantImageView.sd_setImage(with: myURL)
        } else {
            cell.restaurantImageView.image = UIImage(named: "default_image.png")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRest = self.rests[indexPath.row]
        self.performSegue(withIdentifier: "ShowWebViewController", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        webViewController.selectedRest = self.selectedRest
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getData() {
        let params: [String: String] = [
            "keyid": "f03837e2efeaf7fff867adf9afcc3851",
            "format": "json",
            "name": textField.text!
        ]
        let url = "https://api.gnavi.co.jp/RestSearchAPI/20150630/"
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default)
            .responseJSON { (response) -> Void in
                if let object = response.result.value {
                    let jsonObject = JSON(object)
                    let restJson = jsonObject["rest"].array
                    self.rests = []
                    for rest in restJson! {
                        let restaurant = Restaurant()
                        restaurant.name = rest["name"].string
                        restaurant.url = rest["url"].string
                        restaurant.imageURL = rest["image_url"]["shop_image1"].string
                        self.rests.append(restaurant)
                    }
                    self.tableView.reloadData()
                }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
