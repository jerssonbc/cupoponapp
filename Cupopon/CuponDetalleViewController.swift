//
//  CuponDetalleViewController.swift
//  Cupopon
//
//  Created by Jersson on 11/24/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class CuponDetalleViewController: UIViewController {
    
    
    @IBOutlet weak var nombreProductoLabel: UILabel!
    @IBOutlet weak var imageProductoLabel: UIImageView!
    @IBOutlet weak var descuentoCuponLabel: UILabel!
    @IBOutlet weak var precioConCuponLabel: UILabel!
    @IBOutlet weak var precioProductoLabel: UILabel!
    @IBOutlet weak var infoCuponSegmentedControl: UISegmentedControl!
    @IBOutlet weak var infoProductoView: UIView!
    @IBOutlet weak var infoCondicionesView: UIView!
    @IBOutlet weak var infoEmpresaView: UIView!
    
    @IBOutlet weak var cuponesDisponiblesLabel: UILabel!
    
    
    @IBOutlet weak var condicionesTextView: UITextView!
    
    @IBOutlet weak var empresaTextView: UITextView!
    var appDelegate : AppDelegate!
    var session : NSURLSession!
    var cupon : Cupon?
    
    //var  condicion : Condicion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //obtener el delegato de a app
        appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        
        // obtener el shared URL session
        session = NSURLSession.sharedSession()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func infoCuponIndexChanged(sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex)
        {
           case 0:
                self.infoProductoView.hidden=false
                self.infoCondicionesView.hidden=true
                self.infoEmpresaView.hidden = true
                break
           case 1:
                self.infoProductoView.hidden=true
                self.infoCondicionesView.hidden=false
                self.infoEmpresaView.hidden = true
                break
            case 2:
                self.infoProductoView.hidden=true
                self.infoCondicionesView.hidden=true
                self.infoEmpresaView.hidden = false
                break
            default :
                break
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let cupon = cupon {
            // configuara algunas controels por defecto 
            nombreProductoLabel.text = cupon.producto
            print(cupon.producto)
            descuentoCuponLabel.text =  "\(cupon.descuento) %"
            precioConCuponLabel.text = "\(cupon.precioconcupon)"
            precioProductoLabel.text = "\(cupon.precior)"
            cuponesDisponiblesLabel.text = "\(cupon.cantidadCupon)"
            empresaTextView.text = cupon.empRazonSocial + " : " + cupon.empGiroNegocio + "\n" + "Telefono: " + cupon.empTelefono + "\n" +
                "Sitio Web: " + cupon.empWebSite 
            
            
            imageProductoLabel.image = UIImage(named: "Cupon Icon")
            
            // consulta para obtener las codiciones del cupon
            // 2. Construir la URL
            // 3. Configurando la peticion
            // 4. Hacer la peticion
            let myUrl = NSURL(string: "http://localhost:8080/appcupopon/scripts/listarCondiciones.php");
            
            let request = NSMutableURLRequest(URL: myUrl!);
            request.HTTPMethod = "POST";
            
            let postString = "cuponId=\(cupon.id)";
            
            //encodificacion del cuerpo de la peticion
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
            
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
                let parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
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
                
                /* GUARD: Is the "results" key in parsedResult? */
                guard let results = parsedResult["resultado"] as? [[String : AnyObject]] else {
                    print("No se encontro el key resultado en \(parsedResult)")
                    return
                }
                
                /* 6. Use the data! */
                let condiciones = Condicion.condicionesFromResults(results)
                var listaCondiciones :String = ""
                for condicion in condiciones{
                    listaCondiciones = listaCondiciones + "- "+condicion.descripcion! + ". \n"
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.condicionesTextView.text = listaCondiciones
                }
                
               
            }
            /* 7. Start the request */
            task.resume()
            
            // obtiene imagen del producto
            if let posterPath = cupon.posterCupon {
                // 1. Set the paramaters
                // 2. Construir la URL
                let baseURL = NSURL(string: "http://localhost:8080/appcupopon/img/")
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
                            self.imageProductoLabel!.image = image
                        }
                    } else {
                        print("Could not create image from \(data)")
                    }
                    
                    
                }
                /* 7. Start the request */
                task.resume()
            }
            
           // fin del imagen del cupon =====
            
            
           
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func obtenerCuponButtonTapped(sender: AnyObject) {
        let alertaObtenerCupon = UIAlertController(title: "Obtencion de Cupon", message: "Esta seguro que desea obtener un cupon para este producto?", preferredStyle: UIAlertControllerStyle.Alert);
        
        /*let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (okSelected) -&gt; Void in
            println("Ok Selected")
        }*/
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
            (action) in
           
            let idUser:Int? = Int(NSUserDefaults.standardUserDefaults().stringForKey("usuarioId")!)
          
            var cuponCodigo : String?
            // Inicio generacion de CodigoCupon
            // consulta para obtener las codiciones del cupon
            // 2. Construir la URL
            // 3. Configurando la peticion
            // 4. Hacer la peticion
            let myUrl = NSURL(string: "http://localhost:8080/appcupopon/scripts/obtenerCupon.php");
            
            let request = NSMutableURLRequest(URL: myUrl!);
            request.HTTPMethod = "POST";
            
            let postString = "cuponId=\(self.cupon!.id)&userId=\(idUser!)";
            
            print(postString)
            print(self.cupon?.id)
            print(idUser)
            
            //encodificacion del cuerpo de la peticion
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
                
                /* 6. Use the data! */
                
                dispatch_async(dispatch_get_main_queue()) {
                    if(cuponCodigo == nil)
                    {
                        let errorMessage = parsedResult["message"] as? String
                        let myAlert = UIAlertController(title: "Alerta", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert);
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
                        myAlert.addAction(okAction);
                        
                        self.presentViewController(myAlert, animated: true, completion: nil);
                    }else{
                        let controllerCodigo = self.storyboard?.instantiateViewControllerWithIdentifier("CuponGeneradoViewController") as! CuponGeneradoViewController
                        controllerCodigo.codigoCupon = cuponCodigo
                        self.navigationController!.pushViewController(controllerCodigo, animated: true)
                    }
                    
                }
                
                
            }
            /* 7. Start the request */
            task.resume()
            //Fin de generacion de CodigoCupon
            
           
            
            //print("Ok Seleccionado")
             //
        }
        
        let cancelarButton = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Default){
            (action) in
            print("Cancelar Seleccionado")
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertaObtenerCupon.addAction(okButton)
        alertaObtenerCupon.addAction(cancelarButton)
        self.presentViewController(alertaObtenerCupon, animated: true, completion: nil)
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
