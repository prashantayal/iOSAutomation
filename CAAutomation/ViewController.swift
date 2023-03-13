//
//  ViewController.swift
//  Sample
//
//  Created by Nitin Bhatia on 10/03/23.
//

import Cocoa

let PATH = "/Users/\(NSUserName())/Documents/"

class ViewController: NSViewController {
    
    //outlets
    @IBOutlet weak var txtCompanyName: NSTextField!
    @IBOutlet weak var lblJSONPlaceholder: NSTextField!
    @IBOutlet weak var txtJSON: NSScrollView!
    @IBOutlet weak var txtDestinationPath: NSTextField!
    @IBOutlet weak var txtSourcePath: NSTextField!
    @IBOutlet weak var btnChooseSource: NSButton!
    @IBOutlet weak var btnChooseDest: NSButton!
    
    //variables
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtJSON.documentView?.layer?.cornerRadius = 4
        txtJSON.documentView?.resignFirstResponder()
        
        let fileName = "testFile1.txt"
        
        //createDirectory(folderName: "hello I")
        
        //getFiles()
        
        //        self.save(text: "Some test content to write to the file",
        //                  toDirectory: self.documentDirectory(),
        //                  withFileName: fileName)
        //self.read(fromDocumentsWithFileName: "ss-info.plist")
    }
    
    
    //MARK: btn create action
    @IBAction func btnCreateAction(_ sender: Any) {
        let srcPath = txtSourcePath.stringValue
        let destPath = txtDestinationPath.stringValue
        let folderName = txtCompanyName.stringValue
        
        createDirectory(folderName: folderName, atDest: destPath)
        
        copyFiles(from: srcPath, copyTo: destPath)
        
    }
    
    //MARK: - Choose file path action
    @IBAction func clickChoose(_ sender: NSButton) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose single directory | Our Code World";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseFiles = false;
        dialog.canChooseDirectories = true;

        if (dialog.runModal() ==  NSApplication.ModalResponse.OK) {
            let result = dialog.url

            if (result != nil) {
                let path: String = result!.path
                print(path)
                
                // source button
                if sender == btnChooseSource {
                    // provide source path to textfield
                    txtSourcePath.stringValue = path
                }
                // destination button
                else if sender == btnChooseDest {
                    // provide destination path to textfield
                    txtDestinationPath.stringValue = path.hasSuffix("/") ? path : (path + "/")
                }
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    //MARK: - this function helps to create directory
    private func createDirectory(folderName :String, atDest: String) {
        do {
            if fileManager.fileExists(atPath: atDest + folderName) {
                try fileManager.removeItem(atPath: atDest + folderName)
            }
            try fileManager.createDirectory(atPath: atDest + folderName, withIntermediateDirectories: false)
        } catch let err {
            print(err)
        }
    }
    
    //MARK: this function helps to get document directory's path
    private func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0] + "/"
    }
    
    //MARK: this function helps to copy files
    private func copyFiles(from: String, copyTo: String) {
        let contents = try? fileManager.contentsOfDirectory(atPath:  from)
        
        contents?.forEach({
            do {
                print($0)
                let ext = $0.components(separatedBy: ".").last
                
               
                
                
                try fileManager.copyItem(atPath: "\(from)/\($0)", toPath: "\(copyTo)/\(txtCompanyName.stringValue)/" + "\(txtCompanyName.stringValue).\(ext!)")
                
                
                var isDir = ObjCBool(true)
                
                if fileManager.fileExists(atPath: "\(copyTo)/\(txtCompanyName.stringValue)/" + "\(txtCompanyName.stringValue).\(ext!)",isDirectory: &isDir) && isDir.boolValue  {

                    try? fileManager.removeItem(atPath: "\(copyTo)/\(txtCompanyName.stringValue)/" + "\(txtCompanyName.stringValue).\(ext!)")


                   try? fileManager.createDirectory(atPath: "\(copyTo)/\(txtCompanyName.stringValue)/" + "\(txtCompanyName.stringValue).\(ext!)", withIntermediateDirectories: false)




                }
                
            } catch let err {
                print(err)
            }
        })
    }
    
    //MARK: this function helps to read and update plist
    private func readAndUpdatePlist(fromDocumentsWithFileName fileName: String) {
        guard let filePath = self.append(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
            return
        }
        
        do {
            
            // Example usage:
//           print( shell("""
//sed "s/COMPANYNAME/hello i am here/" \(documentDirectory())ss-info.plist > \(documentDirectory())tmp.plist
//| """
//) )
//
//            print( shell("""
//            mv \(documentDirectory())tmp.plist \(documentDirectory())ss-info.plist
// """
// ) )
//
           
            
            
            
//            let parser1 = Parser1()
//            let savedString = try String(contentsOfFile: filePath)
//            let xmlParser = XMLParser(data: savedString.data(using: .utf8)!)
//            xmlParser.delegate = parser1
//            xmlParser.shouldProcessNamespaces = true
 //           xmlParser.parse()
        } catch {
            print("Error reading saved file")
        }
    }
    
    //MARK: this function helps to create shell and run given shell command
    private func shell(_ command: String) -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"
        task.standardInput = nil
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    
    private func append(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    
   
    
    private func save(text: String,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName) else {
            return
        }
        
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
        
        print("Save successful")
    }
    
    
    
}


//handling element name
class Parser1 : NSObject, XMLParserDelegate {
    
    var articleNth = 0
    
//    func parserDidStartDocument(_ parser: XMLParser) {
//        print("Start of the document")
//        print("Line number: \(parser.lineNumber)")
//    }
//
//    func parserDidEndDocument(_ parser: XMLParser) {
//        print("End of the document")
//        print("Line number: \(parser.lineNumber)")
//    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
      // print(qName)
        
//        if (elementName=="key") {
//            articleNth += 1
//        }
//        if (elementName=="key") {
//            print("'\(elementName)' in the article element number \(articleNth)")
//        }
        
//        for (attr_key, attr_val) in attributeDict {
//                    print("Key: \(attr_key), value: \(attr_val)")
//                }
//
//        print("Namespace URI: \(namespaceURI!), qualified name: \(qName!)")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print(string)
    }
    
   

   
    
    
    
}


extension URL {
    var isDirectory: Bool {
       (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
}
