//
//  MisCuponesTableViewController.swift
//  Cupopon
//
//  Created by Jersson on 12/9/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class MisCuponesTableViewController: UITableViewController {

    var appDelegate : AppDelegate!
    var session: NSURLSession!
    
    var miCupones : [MiCupon] = [MiCupon]()
    var usuarioId : Int? =  nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        
        session = NSURLSession.sharedSession()
        
        usuarioId = Int(NSUserDefaults.standardUserDefaults().stringForKey("usuarioId")!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toogleMenuHome(sender: AnyObject) {
        let principalPage = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerVC") as! ContainerVC
        // gestiona la transicion com oun navigation controller
        let principalPageNav = UINavigationController(rootViewController: principalPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = principalPageNav
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let myUrl = NSURL(string: Config.baseHtppURLString+"misCupones.php");
        
        let request = NSMutableURLRequest(URL: myUrl!);
        
        request.HTTPMethod = "POST";
        
        let postString = "userId=\(usuarioId!)";
        print(myUrl)
        //encodificacion del cuerpo de la peticion
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            
            guard (error == nil) else {
                print("Hay un error con la peticion: \(error)")
                return
            }
            
            guard let data = data else{
                print("Ningun dato fue retornado por la peticion")
                return
            }
            
            let parsedResult : AnyObject!
            do{
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            }catch{
                parsedResult = nil
                print("No se pudo parser la data como JSON: '\(data)'")
                return
            }
            
            guard let results = parsedResult["resultado"] as? [[String:AnyObject]] else {
                print("No se encontro el key resultado en \(parsedResult)")
                return
            }
            
            self.miCupones = MiCupon.misCuponesFromResults(results)
            
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
            
            
            
        }).resume()
        
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return miCupones.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "MiCuponTableViewCell"
        let miCupon = miCupones[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! MiCuponCell

        // Configure the cell...
        
        cell.nombreProductoLabel.text    = miCupon.producto
        cell.codigoCupon.text =  miCupon.codigoCupon
        cell.descuentoCuponLabel.text = "\(miCupon.descuento) %"
        cell.precioConCuponLabel.text = "\(miCupon.precioconcupon)"
        cell.precioProductoLabel.text = "\(miCupon.precior)"
        cell.fechaTerminoCuponLabel.text = miCupon.fechaVencimiento
        
        //cell.imageView!.image = UIImage(named: "Cupon Icon")
        cell.cuponImage.image = UIImage(named: "Cupon Icon")
        //cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        cell.cuponImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        if let posterPath = miCupon.posterCupon {
            // 1. Set the paramaters
            // 2. Construir la URL
            let baseURL = NSURL(string: Config.baseImageURLString)
            let url = baseURL!.URLByAppendingPathComponent(posterPath)
            
            // 3. Configurando la peticion
            let request = NSURLRequest(URL: url)
            
            // 4. Hacer la peticion
            
            let task = session.dataTaskWithRequest(request){ (data, response, error) in
                // GUARD: Hubo un error ?
                guard (error == nil) else {
                    print("Hubo un erro con tu peticion : \(error)")
                    return
                }
                
                /* GUARD: Did we get a successful 2XX response? */
                guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                    if let response = response as? NSHTTPURLResponse {
                        print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                    } else if let response = response {
                        print("Your request returned an invalid response! Response: \(response)!")
                    } else {
                        print("Your request returned an invalid response!")
                    }
                    return
                }
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                    print("No data was returned by the request!")
                    return
                }
                
                /* 5. Parse the data */
                // No need, the data is already raw image data.
                
                /* 6. Use the data! */
                if let image = UIImage(data: data) {
                    dispatch_async(dispatch_get_main_queue()) {
                        //cell.imageView!.image = image
                        cell.cuponImage.image = image
                    }
                } else {
                    print("Could not create image from \(data)")
                }
            }
            /* 7. Start the request */
            task.resume()
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
