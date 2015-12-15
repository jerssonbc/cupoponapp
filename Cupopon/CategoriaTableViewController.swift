//
//  CategoriaTableViewController.swift
//  Cupopon
//
//  Created by Jersson on 11/15/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class CategoriaTableViewController: UITableViewController {
    
    var appDelegate : AppDelegate!
    var session: NSURLSession!
    
    var cupones : [Cupon] = [Cupon]()
    var categoriaId : Int? =  nil
    
    var refrescar: UIRefreshControl!
    
    
   
    @IBAction func toggleMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    
    }
    
    
    @IBAction func toggleMenu1(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
    }
    
    func refresh(){
        print("Resfrescado")
        let myUrl = NSURL(string: Config.baseHtppURLString+"listarCupones.php");
        
        let request = NSMutableURLRequest(URL: myUrl!);
        
        request.HTTPMethod = "POST";
        
        let postString = "categoriaId=\(categoriaId!)";
        
        //encodificacion del cuerpo de la peticion
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            
            guard (error == nil) else {
                if(NSUserDefaults.standardUserDefaults().objectForKey("cupones1") != nil && self.categoriaId==1)
                {
                    print("Trabajar con data local categ 1")
                    self.cupones = Cupon.cuponesFromResults(NSUserDefaults.standardUserDefaults().objectForKey("cupones1")! as! [[String : AnyObject]] )
                    
                }
                else
                    if(NSUserDefaults.standardUserDefaults().objectForKey("cupones2") != nil && self.categoriaId==2)
                    {
                        print("Trabajar con data local categ 2")
                        self.cupones = Cupon.cuponesFromResults(NSUserDefaults.standardUserDefaults().objectForKey("cupones2")! as! [[String : AnyObject]] )
                        
                    }
                    else
                    {
                        print("Hay un error con la peticion: \(error)")
                        return
                }
                
                dispatch_async(dispatch_get_main_queue()){
                    self.tableView.reloadData()
                }
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
            
            self.cupones = Cupon.cuponesFromResults(results)
            
            if(self.categoriaId==1)
            {
                NSUserDefaults.standardUserDefaults().setObject(results, forKey: "cupones1")
            }
            else
            {
                NSUserDefaults.standardUserDefaults().setObject(results, forKey: "cupones2")
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
                self.refrescar.endRefreshing()
            }
            
            
            
        }).resume()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        
        refrescar = UIRefreshControl()
        refrescar.attributedTitle = NSAttributedString(string: "Pull para refrescar")
        refrescar.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refrescar)
        
        appDelegate =  UIApplication.sharedApplication().delegate as! AppDelegate
        
        session = NSURLSession.sharedSession()
        
        categoriaId = getCategoriaIdFromItemTag(self.tabBarItem.tag)
        print(self.tabBarItem.tag)
        print(categoriaId)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func networkStatusChanged(notification: NSNotification) {
        //let userInfo = notification.userInfo
        let status = Reach().connectionStatus()
        
        switch status {
            case .Unknown, .Offline:
                print("Not connected")
                break
            case .Online(.WWAN):
                print("Connected via WWAN")
                break
            case .Online(.WiFi):
                if(NSUserDefaults.standardUserDefaults().objectForKey("porAdquirir") != nil )
                {
                    var arreglo = NSUserDefaults.standardUserDefaults().objectForKey("porAdquirir") as! NSArray as Array
                    
                    var indices : [Int] = []
                    var respuestitas : [String] = []
                    
                    if (arreglo.count>0){
                         let idUser:Int? = Int(NSUserDefaults.standardUserDefaults().stringForKey("usuarioId")!)
                        
                        for var x = 0 ; x < arreglo.count ; x++ {
                            var rspta =  sincronizarGeneraCupones(idUser!, cupon_id: arreglo[x] )
                            
                            if (rspta[0] == "1") {
                                
                            }
                            print(rspta)
                            
                            indices.append(Int(rspta[0])!)
                            respuestitas.append(rspta[1])
                        }
                        
                        print(respuestitas)
                        
                        for var p = 0 ; p < respuestitas.count ; p++ {
                            
                            
                        }
                        
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("porAdquirir")
                        //print(("Cantidad /// "),arreglo.count)
                    }else{
                        //print(("Cantidad /// "),arreglo.count)
                    }
                    
                    
                }
                
                print("Connected via WiFi")
                break
        }
       
    }
    
    func sincronizarGeneraCupones(user_id:Int, cupon_id:AnyObject) -> Array<String>
    {
       
        
        var estadoGeneracion : String = "2"
        var  errorMessage:String = ""
        
        var cuponCodigo : String?
       
        
        
        let myUrl = NSURL(string: Config.baseHtppURLString+"obtenerCupon.php");
        
        let request = NSMutableURLRequest(URL: myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "cuponId=\(cupon_id)&userId=\(user_id)";
        

        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        let task = self.session.dataTaskWithRequest(request){ (data, response, error) in
            
            
            // GUARD: Hubo un error ?
            guard (error == nil) else {
                print("Hubo un error con la peticion de generacion de codigo : \(error)")
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
            let parsedResult: AnyObject!
            do {
                //parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
            } catch {
                parsedResult = nil
                
                print("No se pudo parser la data como JSON: '\(data)'")
                return
            }
            
            /* GUARD: Did AppCuponesDB return an error? */
            guard (parsedResult.objectForKey("status_code") == nil) else {
                print("AppCuonesDB returned an error. See the status_code and status_message in \(parsedResult)")
                return
            }
            
            cuponCodigo = parsedResult["codigoCupon"] as? String
            
            print(cuponCodigo)
            
            /* 6. Use the data! */
            
            
                if(cuponCodigo == nil)
                {
                    estadoGeneracion = "0"
                    
                }else{
                    
                    estadoGeneracion = "1"
                   
                }
            errorMessage = (parsedResult["message"] as? String)!
            
        }
        /* 7. Start the request */
        task.resume()
        
        var arreglo : [String] = []
        arreglo.append(estadoGeneracion)
        arreglo.append(errorMessage)
        
        return arreglo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // incio de funcion refrescar
       refresh()
        // fin de antes de agregar a funcion refrescar
        
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cupones.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "CuponTableViewCell"
        let cupon = cupones[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! CuponCell
        
        // set cell defaults  
       
        //cell.textLabel!.text = cupon.producto
        cell.productoName.text = cupon.producto
        cell.precioConCupon.text = "\(cupon.precioconcupon)"
        cell.productoPrecio.text = "\(cupon.precior)"
        cell.cuponDescuento.text = "\(cupon.descuento) %"
        cell.cantidadCupon.text = "\(cupon.cantidadCupon)"
        
        
        //cell.imageView!.image = UIImage(named: "Cupon Icon")
        cell.cuponImage.image = UIImage(named: "Cupon Icon")
        //cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        cell.cuponImage.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        // TAREA : Obtener la imagen poster, luego poblar el image view
        
        if let posterPath = cupon.posterCupon {
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

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // ir al detalle del cupon
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("CuponDetalleViewController") as! CuponDetalleViewController
        
        controller.cupon = cupones[indexPath.row]
        self.navigationController!.pushViewController(controller, animated: true)
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
extension CategoriaTableViewController{
    
    func getCategoriaIdFromItemTag(itemTag:Int) ->Int{
        let categorias : [String] = [
            "Destacados",
            "Tecnologia"
        ]
        let categoriaMap :[String:Int] = [
        "Destacados" : 1,
        "Tecnologia" : 2
        
        ]
        
        return categoriaMap[categorias[itemTag]]!
    }
    
    
    
}