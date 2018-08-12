import PlaygroundSupport
import AppKit
import SceneKit
import SpriteKit

/*:
 # World of Water:
 An interactive curio containing information and teachings about the world water crisis.
 
 Created by Ryan Domoslai, submitted to the Apple WWDC Scholarship on April 1, 2018.
 ## Code Structure:
 * Each room has the structure: scene class -> view class -> combined class.
 * Click actions are handled in each page's extended scene class.
 * All vector graphics are created by me, and all images used are licensed under Creative Commons.
 ## References:
 ### Shower Page:
 * [Water in Crisis: Women in India](https://thewaterproject.org/water-crisis/water-in-crisis-india-women)
 * [UNICEF: Collecting water is often a colossal waste of time for girls.](https://www.unicef.org/media/media_92690.html)
 * [Water and People: Whose right is it?](http://www.fao.org/docrep/005/Y4555E/Y4555E00.HTM)
 * [Shower Water Saving Tips](https://www.home-water-works.org/indoor-use/showers)
 ### Map Page:
 * [Bangladesh's Water Crisis - Bangladesh's Water in 2018](https://water.org/our-impact/bangladesh/)
 * [Water in Crisis - Bangladesh](https://thewaterproject.org/water-crisis/water-in-crisis-bangladesh)
 * [Water in Crisis - South Africa](https://thewaterproject.org/water-crisis/water-in-crisis-south-africa)
 * [Climate Change Adaption to Protect Human Health](http://www.who.int/globalchange/projects/adaptation/en/index1.html)
 * [Water in Crisis - Democratic Republic of Congo](https://thewaterproject.org/water-crisis/water-in-crisis-congo)
 * [Pakistain's Water Crisis: Why a National Water Policy is Needed](https://asiafoundation.org/2017/11/01/pakistans-water-crisis-national-water-policy-needed/)
 * [Egypt's Water Crisis - Recipe for Disaster](https://www.ecomena.org/egypt-water/)
 * [United Arab Emirates - Water](https://www.export.gov/article?id=United-Arab-Emirates-Water)
 * [The Heavy Price of Santiago's Privatised Water](https://www.theguardian.com/sustainable-business/2016/sep/15/chile-santiago-water-supply-drought-climate-change-privatisation-neoliberalism-human-right)
 ### R&D Page:
 * [Desal Process](http://carlsbaddesal.sdcwa.org/desal-process/)
 * [How Technology is Providing Solutions for Clean Water](https://onlinemasters.ohio.edu/how-technology-is-providing-solutions-for-clean-water/)
 * [Innovations in Smart Water Technology to Fight the Global Water Crisis](https://www.smartcity.press/innovations-in-smart-water-technology-to-fight-water-crisis/)
 ### Images:
 * [Flags of the World](http://www.mapsopensource.com/flags.html)
 Licenced under Creative Commons Attribution 3.0
 * [Desalination Plant](https://www.flickr.com/photos/somachigun/6816041887/in/photolist-boiZMz-s8DR2Q-8Mtnsk-8MtnVg-8MwrXu-saWJsv-8Mwrpj-82qxGH-7DuhEU-4SukSW-exxYt4-8LczSB-exB4JN-8Mwrab-JYxQjz-9kJtrM-bWsrmr-bWsr3a-8DwBmZ-9QqJmx-dyuKcq-8DzGQC-cdPL9G-82qvzD-4ULBrG-cdPLih-kPy9Qm-d1QV9w-exB4BN-8DzH51-8DwB2F-exxYxa-exBh2b-exDRFS-6EXok9-8HHMbf-mTJK76-8DzGPE-exB4Ly-8DzH9G-8DwAPK-5cSkwb-exxYz4-9kJtiz-exB4Hj-8DwAMa-9kJtFc-ZFnDTj-8DwBhD-8DzGsS)
 Licenced under Creative Commons Attribution 2.0
 * [Fog Trapper - Taken by Nicole Saffie](https://www.flickr.com/photos/26946475@N08/9292245749)
 Licenced under Creative Commons Attribution-NonCommercial-ShareAlike 2.0
 
*/

/// A dictionary containing the views of each page in the Playground.
var pageViews = [String: SKView]()


/**
    Used to quickly create a button, styled the same as other buttons in the Playground.
 */
class ButtonNode: SKSpriteNode {
    
    /**
        Sets the default texture of the button and enables user interaction.
    */
    override init(texture: SKTexture! = SKTexture(imageNamed: "greenButton.png"), color: NSColor, size: CGSize = CGSize(width: 160, height: 60)) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
        self.texture = texture
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    /**
     Sets the text of the button, and also formats the text to ensure it is properly aligned inside the button.
     -Parameter text: The string that will be presented in the button.
    */
    func setText(text: String) {
        let buttonText = SKLabelNode(text: text)
        self.name = text
        buttonText.fontName = "Helvetica"
        buttonText.position = CGPoint(x: 0, y: -10)
        buttonText.fontColor = SKColor.black
        buttonText.fontSize = 32
        self.addChild(buttonText)
    }
    
    /// Changes the texture of the button to that of a secondary button (ie lighter).
    func setSecondary() {
        self.texture = SKTexture(imageNamed: "lightButton.png")
    }
    
    /// Changes the texture of the button to that of a home button.
    func setHome() {
        self.texture = SKTexture(imageNamed: "HomeButton.png")
        self.size = (self.texture?.size())!
        self.name = "Home"
    }
}


/**
 The scene that the shower page uses to present nodes. Also handles the click events for the page.
 - Parameters:
    - parentView: The associated view of the shower page.
    - parentPage: The page object used to house and initialize the shower scene and shower view.
 */
class ShowerScene: SKScene {
    
    var parentView: SKView?
    var parentPage: ShowerPage?
    
    /**
     Handles the click events for the scene. Used to either interact with the scene or navigate back to the home page.
     - Parameter sender: The click recognizer for the view.
    */
    @objc func checkAction(sender: NSClickGestureRecognizer) {
        let location = sender.location(in: self.parentView)
        let clickedNodes = nodes(at: location)
        for node in clickedNodes {
            if node.name == "Home" {
                self.parentPage!.showerMinutes = 1
                self.parentPage?.subtractMinute()
                PlaygroundPage.current.liveView = self.parentPage?.homeView
            } else if node.name == "Submit" {
                self.parentPage?.calculateShower()
            }
            else if node.name == "minus" {
                self.parentPage?.subtractMinute()
            } else if node.name == "plus" {
                self.parentPage?.addMinute()
            }
        }
    }

    /**
     Initializes the parentView and parentPage class parameters.
     - Parameters:
        - parentView: The associated view of the shower page.
        - parentPage: The page object used to house and initialize the shower scene and shower view.
    */
    func addParents(parentView: SKView, parentPage: ShowerPage) {
        self.parentView = parentView
        self.parentPage = parentPage
    }
}


/**
 The class used to house and initialize the SKView and SKScene of the shower page. Also used to perform the calculations necessary for the page, and communicates with the SKView and SKScene to transfer data.
 - Parameters:
    - showerScene: The SKScene used for the page.
    - showerView: The SKView used for the page.
    - homeView: The home view of the page, used to go back to the home page.
    - showerMinutes: An int used to store the user's inputted length of shower.
    - showerMinutesLabel: An SKLabelNode used to display the showerMinutes in the showerScene.
    - currentFact: The currently presented fact. Used ensure the user does not randomly display the same fact twice in a row.
 */
class ShowerPage {
    
    var showerScene: ShowerScene?
    var showerView: SKView?
    var homeView: SCNView
    var showerMinutes: Int
    var showerMinutesLabel: SKLabelNode
    var currentFact: String
    var timer: Timer?
    
    /**
     Used to initialize the view and scene of the page. Also creates and adds nodes to the scene.
     - Parameters:
        - parentView: Used to initialize the homeView of the class.
    */
    init(parentView: SCNView) {
        // Initializing class variables
        self.homeView = parentView
        self.currentFact = ""
        showerScene = ShowerScene()
        showerView = SKView(frame: NSRect(x: 0, y: 0, width: 612, height: 600))
        showerMinutes = 0
        showerMinutesLabel = SKLabelNode(text: String(showerMinutes))
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.spawnWater), userInfo: nil, repeats: true)
        self.timer?.invalidate()
        
        // Setting the Scene
        showerScene!.size = CGSize(width: 612, height: 600)
        showerScene!.addParents(parentView: showerView!, parentPage: self)
        let gesture = NSClickGestureRecognizer(target: showerScene, action:  #selector(showerScene!.checkAction))
        showerView!.addGestureRecognizer(gesture)

        // Adding Title
        let showerTitle = SKLabelNode(text: "The Bathroom")
        showerTitle.name = showerTitle.text
        showerTitle.fontName = "Helvetica-Neue"
        showerTitle.fontSize = 48
        showerTitle.fontColor = SKColor.black
        showerTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        showerTitle.position = CGPoint(x: 40, y: 520)
        
        // Adding description
        let showerDesc = SKLabelNode(text: "How much water does your shower use?")
        showerDesc.name = showerDesc.text
        showerDesc.fontName = "HelveticaNeue-Thin"
        showerDesc.fontSize = 32
        showerDesc.fontColor = SKColor.black
        showerDesc.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        showerDesc.position = CGPoint(x: 40, y: 460)
        
        let showerGraphic = SKSpriteNode(imageNamed: "Shower.png")
        showerGraphic.size = CGSize(width: 250, height: 250)
        showerGraphic.position = CGPoint(x: 60, y: 330)
        
        let submitButton = ButtonNode(color: NSColor.orange)
        submitButton.setText(text: "Submit")
        submitButton.position = CGPoint(x: 375, y: 50)

        let homeButton = ButtonNode(color: NSColor.orange)
        homeButton.setHome()
        homeButton.position = CGPoint(x:550, y: 550)
        
        // Initializing shower minutes label
        showerMinutesLabel.name = "Shower Minutes"
        showerMinutesLabel.fontName = "HelveticaNeue"
        showerMinutesLabel.fontColor = SKColor.black
        showerMinutesLabel.fontSize = 32
        showerMinutesLabel.position = CGPoint(x: 460, y: 390)
        
        let showerMinutesDesc = SKLabelNode(text: "Duration in Minutes:")
        showerMinutesDesc.fontName = "HelveticaNeue-Thin"
        showerMinutesDesc.fontColor = SKColor.black
        showerMinutesDesc.fontSize = 18
        showerMinutesDesc.position = CGPoint(x: 250, y: 393)    // 250
        
        // Customizing Scene
        showerScene!.backgroundColor = SKColor(red: 218/255, green: 247/255, blue: 220/255, alpha: 1)
        showerScene!.addChild(showerTitle)
        showerScene!.addChild(showerDesc)
        showerScene!.addChild(showerGraphic)
        showerScene!.addChild(submitButton)
        showerScene!.addChild(homeButton)
        showerScene!.addChild(showerMinutesLabel)
        showerScene!.addChild(showerMinutesDesc)
        showerView!.presentScene(showerScene)
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        showerTitle.run(fadeIn)
        
        // Running shower water
        let minusButton = self.createMathButton(type: "minus.png")
        let plusButton = self.createMathButton(type: "plus.png")
        minusButton.position = CGPoint(x: 360, y: 400)
        plusButton.position = CGPoint(x: 560, y: 400)
        showerScene!.addChild(minusButton)
        showerScene!.addChild(plusButton)

    }
    
    /**
     Function used to generate and animate pouring water from the shower faucet. Randomly generates the location of
     the waterDrop node, and then deletes it when it is no longer visible on the screen. Run on a timer to simulate a constant flow.
    */
    @objc func spawnWater() -> Void {
        let waterDrop = SKShapeNode(circleOfRadius: 5)
        waterDrop.fillColor = NSColor.blue
        waterDrop.strokeColor = NSColor.blue
        let xPosition = arc4random_uniform(115 - 30) + 30       // Randomize position to simulate water facet
        waterDrop.position = CGPoint(x:Int(xPosition), y: 318)
        let moveWater = SKAction.move(to: CGPoint(x: Int(xPosition), y: 0), duration: 5.0)
        self.showerScene!.addChild(waterDrop)
        waterDrop.run(moveWater, completion: {
            waterDrop.removeFromParent()  // Deletes node
        })
    }
    
    /**
     Generates a math style button used to add and subtract from showerMinutes.
     - Parameter type: The name of the style of button.
    */
    func createMathButton(type: String) -> SKSpriteNode {
        let button = SKSpriteNode(color: NSColor.orange, size: CGSize(width: 137/3, height: 267/3))
        button.isUserInteractionEnabled = true
        if (type == "minus.png") {
            button.texture = SKTexture(imageNamed: type)
            button.name = "minus"
        } else if (type == "plus.png") {
            button.texture = SKTexture(imageNamed: type)
            button.name = "plus"
        }
        return button
    }
    
    /// Increments showerMinutes by 1 and updates showerMinutesLabel.
    func addMinute() {
        if (self.showerMinutes == 0) {
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.spawnWater), userInfo: nil, repeats: true)
        }
        self.showerMinutes += 1
        self.showerMinutesLabel.text = String(self.showerMinutes)
    }
    
    /// Decrements showerMinutes by 1 and updates showerMinutesLabel.
    func subtractMinute() {
        if showerMinutes != 0 {
        self.showerMinutes -= 1
        self.showerMinutesLabel.text = String(self.showerMinutes)
        }
        if (showerMinutes == 0) {
            self.timer!.invalidate()
        }
    }
    
    /**
     Used to calculate the water used (according to showerMinutes), and displays the information on the page. Also
     displays a random fact about how the water usage compares to other locations in the world.
    */
    func calculateShower() {
        var oldNode = self.showerScene!.childNode(withName: "Stats")
        if (oldNode != nil) {
            oldNode?.removeFromParent()
        }
        if (self.showerMinutes == 0){       // Both if statements can happen simultaneously.
            return
        }
        let waterAmount = Double(self.showerMinutes) * 7.9
        let usageDesc = SKLabelNode()
        usageDesc.text = "Your shower uses " + String(waterAmount) + " litres of water.\n" +
            "That..."
        usageDesc.name = "Stats"
        usageDesc.fontName = "HelveticaNeue-Thin"
        usageDesc.fontSize = 24
        usageDesc.fontColor = SKColor.black
        usageDesc.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        usageDesc.numberOfLines = 2
        usageDesc.position = CGPoint(x: 180, y: 280)
        self.showerScene!.addChild(usageDesc)
        
        oldNode = self.showerScene!.childNode(withName: "Fact")
        if (oldNode != nil) {
            oldNode?.removeFromParent()
        }
        let fact = self.randomFact()
        let factLabel = SKLabelNode()
        factLabel.text = fact
        self.currentFact = fact
        factLabel.name = "Fact"
        factLabel.fontName = "HelveticaNeue-Thin"
        factLabel.fontSize = 24
        factLabel.fontColor = SKColor.black
        factLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        factLabel.numberOfLines = 3
        factLabel.position = CGPoint(x: 180, y: 100)
        self.showerScene!.addChild(factLabel)
    }
    
    /**
     Returns a random selection from assortment of facts.
     - Returns: A new fact. If the fact is the same as the previous one presented, the function will loop until a new fact is selected.
    */
    func randomFact() -> String {
        let waterAmount = Double(self.showerMinutes) * 7.9
        let factAssortment = ["would take on average " + String(waterAmount / 0.5) + " minutes\nfor a poor woman in India to collect.", "is " + String(round((waterAmount / 47.0) * 100)) + "% the average amount of\nwater used per person daily in Africa." , "is " + String(round((waterAmount * 2.2) * 100) / 100) + " pounds of water that women in\nSub-Saharan Africa must transport in pots\nfor hours each day."]
        var fact: String
        if (self.showerScene?.childNode(withName: "Fact") != nil) {
            fact = factAssortment[Int(arc4random_uniform(UInt32(factAssortment.count)))]
        } else {
            fact = factAssortment[Int(arc4random_uniform(UInt32(factAssortment.count)))]
            while (self.currentFact == fact) {
                fact = factAssortment[Int(arc4random_uniform(UInt32(factAssortment.count)))]
            }
        }
        return fact
    }
}


/**
 The scene that the map page uses to present nodes. Also handles the click events for the page, as well as the page's zoom animation.
 - Parameters:
    - parentView: The associated view of the map page.
    - parentPage: The page object used to house and initialize the map scene and map view.
    - currentNode: The currently active map subview.
 */
class MapScene: SKScene {
    
    var parentView: SKView?
    var parentPage: MapPage?
    var currentNode: SKNode?
    
    /**
     Handles the click events for the scene. Used to either interact with the scene or navigate back to the home page.
     - Parameter sender: The click recognizer for the view.
     */
    @objc func checkAction(sender: NSClickGestureRecognizer) {
        if (self.parentPage?.isClicked)! {
            return
        }
        if (self.parentPage?.isZoomed)! {
            self.parentPage?.isClicked = true
            self.returnCamera(camera: self.parentPage!.cameraNode!)
        } else {
            let location = sender.location(in: self.parentView)
            let clickedNodes = nodes(at: location)
            for node in clickedNodes {
                if (node.name != nil) {
                    if (node.name == "Home") {
                        PlaygroundPage.current.liveView = self.parentPage?.homeView
                    } else if (parentPage?.locationPages[node.name!] != nil) {
                        self.parentPage?.isClicked = true
                        self.zoomCamera(location: location, camera: self.parentPage!.cameraNode!, node: node)
                    }
                }
            }
        }
    }
    
    /**
     Initializes the parentView and parentPage class parameters.
     - Parameters:
        - parentView: The associated view of the map page.
        - parentPage: The page object used to house and initialize the map scene and map view.
     */
    func addParents(parentView: SKView, parentPage: MapPage) {
        self.parentView = parentView
        self.parentPage = parentPage
    }
    
    /**
     Zooms the camera closer to the selected region on the map. Also applies the blur filter to the map to focus attention on the primary content.
     - Parameters:
        - location: The location of the camera
        - camera: The camera of the SKScene.
        - node: The targeted node in the scene.
    */
    func zoomCamera(location: CGPoint, camera: SKCameraNode, node: SKNode) {
        // Dont want z clipping with objects
        let move = SKAction.move(to: node.position, duration: 0.50)
        let zoom = SKAction.scale(by: 0.5, duration: 0.50)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(20.0, forKey: kCIInputRadiusKey)
        self.parentPage?.effectsNode!.filter = filter
        camera.run(move, completion: {
            self.currentNode = self.parentPage?.locationPages[node.name!]
            self.addChild(self.currentNode!)
            self.currentNode?.position = CGPoint(x: node.position.x, y: node.position.y - 100)
            self.currentNode?.alpha = 0
            let moveIn = SKAction.move(to: node.position, duration: 0.2)
            let fadeAlpha = SKAction.fadeAlpha(to: 1.0, duration: 0.2)
            let groupActions = SKAction.group([moveIn, fadeAlpha])
            self.currentNode?.run(groupActions)
            self.parentPage?.isClicked = false
        })
        camera.run(zoom)
        self.parentPage!.isZoomed = true
    }
    
    /**
     Returns the camera to it's default zoom level when closing a country's subview.
     - camera: The SKScene's camera.
    */
    func returnCamera(camera: SKCameraNode) {
        self.parentPage!.isZoomed = false
        let moveOut = SKAction.move(to: CGPoint(x: (self.currentNode?.position.x)!, y: (self.currentNode?.position.y)! - 100), duration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let groupActions = SKAction.group([moveOut, fadeOut])
        self.currentNode?.run(groupActions, completion: {
            self.currentNode?.removeFromParent()
            let filter = CIFilter(name: "CIGaussianBlur")
            filter?.setValue(0.0, forKey: kCIInputRadiusKey)
            self.parentPage?.effectsNode?.filter = filter
            self.parentPage?.isClicked = false
        })
        let move = SKAction.move(to: CGPoint(x: 612/2, y: 600/2), duration: 0.50)
        let zoom = SKAction.scale(by: 2, duration: 0.50)
        camera.run(move)
        camera.run(zoom)
    }
}


/**
 The class used to house and initialize the SKView and SKScene of the map page.
 - Parameters:
    - mapScene: The SKScene used for the page.
    - mapView: The SKView used for the page.
    - homeView: The home view of the page, used to go back to the home page.
    - cameraNode: The SKCamera used on the scene.
    - effectsNode: An SKEffectsNode, used to apply gaussianblur on elements as they enter and focus.
    - locationPages: A dictionary of SKSpriteNodes, used to house the nodes containing each region's information. Used to display the sub-pages of the page.
 */
class MapPage {
    
    var mapScene: MapScene?
    var mapView: SKView?
    var homeView: SCNView
    var cameraNode: SKCameraNode?
    var effectsNode: SKEffectNode?
    var locationPages: Dictionary<String, SKSpriteNode>
    var isZoomed: Bool?
    var isClicked: Bool?

    /**
     Used to initialize the view and scene of the page. Also creates and adds nodes to the scene.
     - Parameters:
        - parentView: Used to initialize the homeView of the class.
     */
    init(parentView: SCNView) {
        isZoomed = false
        isClicked = false
        self.homeView = parentView
        locationPages = [String: SKSpriteNode]()
        
        // Creating each page
        let bangladeshPage = self.createPage(title: "Bangladesh", imageName: "BangladeshFlag.png", 
        body: "In Bangladesh, about 4 million people lack access to\n" +
              "safe water and 85 million lack access to proper\n" +
              "sanitation. That is 53% of the population of the country.\n" +
              "One reason for this is the country's highly variable\n" +
              "climate. Warm seasons bring frequent monsoons, and\ncolder" +
              "seasons bring extreme drought. In addition, the\nsalinity " +
              "in the country's water is increasing rapidly due\nto India's " +
              "use of the Ganges river, an important source\nof water for " +
              "the Bangladesh people. These factors\nforce many to drink " +
              "groundwater instead, which has\ncaused arsenic poisoning in " +
              "an estimated\n30 million Bengali people.")

        let southAfricaPage = self.createPage(title: "South Africa", imageName: "SouthAfricaFlag.png", 
        body: "South Africa simply does not have the infrastructure to\n" +
              "support the water needs of the people of the country.\n" +
              "An estimated 5 million people lack access to water,\n" +
              "and 15 million lack access to basic sanitation. Due to\n" +
              "the poor infrastructure, the Vaal river has become\n" +
              "contaminated with sewage runoff and fecal matter,\n" +
              "increasing the risk of water borne diseases in the area.\n" +
              "The poor water conditions of the Vaal are also\n" +
              "causing wildlife to die in droves, further contaminating\n" +
              "the water supply.")

        let barbadosPage = self.createPage(title: "Barbados", imageName: "BarbadosFlag.png", 
        body: "Due to it's location and size, Barbados is a country\n" +
              "that is extremely susceptible to increased climate\n" +
              "change. In the Americas, Barbados is the country with\n" +
              "the highest rate of dengue fever among it's people.\n" +
              "With a rising sea level, the water of Barbados is\n" +
              "increasingly at risk of salinization, which could lead\n" +
              "to even more serious health problems for it's people.")

        let drCongoPage = self.createPage(title: "DR Congo", imageName: "CongoFlag.png", 
        body: "The Democratic Republic of the Congo is a country\n" +
              "with a serious lack of water infrastructure. The state\n" +
              "water utility body doesn't have the funds necessary\n" +
              "to improve and expand water pumping systems,\n" +
              "resulting in a lack of water for many rural people.\n" +
              "Needing to find their own sources of water, the rural\n" +
              "people often drink from streams and ponds, which\n" +
              "they do not realize are contaminated with waste and\n" +
              "chemicals. Imported bottled water is available,\n" +
              "but only the extreme rich are able to afford it.")

        let pakistanPage = self.createPage(title: "Pakistan", imageName: "PakistanFlag.png", 
        body: "With a rapidly increasing population, demand of water\n" +
              "in Pakistan is becoming much larger than the supply.\n" +
              "At least 80% of the water given in the country is\n" +
              "dangerous, thus the spread of water borne diseases\n" +
              "is rampant. With about 95% of the country's water\n" +
              "being used for agriculture, the country's water issues\n" +
              "will only be exacerbated with increases in population.")

        let egyptPage = self.createPage(title: "Egypt", imageName: "EgyptFlag.png", 
        body: "As a country with little arable land, Egypt's water\n" +
              "situation is very dire. The United Nations has warned\n" +
              "that Egypt could run out of water by 2025 if efforts\n" +
              "are not made to improve the country's water\n" +
              "generation and management. In recent years, Egypt\n" +
              "has faced a population explosion, meaning that\n" +
              "irrigated water has been used to meet the population\n" +
              "demand. Due to inefficient methods of harvesting\n" +
              "water and the aforementioned lack of arable land,\n" +
              "there simply isn't enough water generated via\n" +
              "irrigation. Today, untreated industrial waste is\n" +
              "frequently dumped into Egypt's Nile River, rendering\n" +
              "their primary source of water increasingly unusable.")

        let uaEmiratesPage = self.createPage(title: "UA Emirates", imageName: "UnitedArabEmiratesFlag.png", 
        body: "With a scarcity of groundwater reserves and a high\n" +
              "cost of producing water, United Arab Emirates is\n" +
              "unable to meet it's people's increasing water\n" +
              "demands. United Arab Emirates has a water\n" +
              "consumption rate of 550 litres per day, which is one\n" +
              "of the highest rates in the world. Furthermore, there\n" +
              "is little infrastructure to support collection and\n" +
              "treatment of wastewater in the country, further\n" +
              "contributing to the country's inefficient water\n" +
              "management system.")

        let chilePage = self.createPage(title: "Chile", imageName: "ChileFlag.png", 
        body: "Chile's water situation is unique due to their highly\n" +
              "privatized water sector. Chileans rely on private\n" +
              "companies for their water, which does not guarantee\n" +
              "that all people have access to water. Certain areas in\n" +
              "Chile are often subject to extreme droughts and\n" +
              "floods, which people and water companies are often\n" +
              "not prepared for. In the past, this has led to days\n" +
              "where millions do not have access to water for an\n" +
              "extended period of time. In recent years,the\n" +
              "inefficiency of the water system has led to protests,\n" +
              "with many Chileans arguing that access to water\n" +
              "should be a basic human right.")
 
        // Adding each flag to the locationPages dictionary
        locationPages[bangladeshPage.name!] = bangladeshPage
        locationPages[southAfricaPage.name!] = southAfricaPage
        locationPages[barbadosPage.name!] = barbadosPage
        locationPages[drCongoPage.name!] = drCongoPage
        locationPages[pakistanPage.name!] = pakistanPage
        locationPages[egyptPage.name!] = egyptPage
        locationPages[uaEmiratesPage.name!] = uaEmiratesPage
        locationPages[chilePage.name!] = chilePage
        
        // Initializing class variables
        mapScene = MapScene()
        mapView = SKView(frame: NSRect(x: 0, y: 0, width: 612, height: 600))
        cameraNode = SKCameraNode()
        
        // Setting the Scene
        mapScene!.size = CGSize(width: 612, height: 600)
        mapScene!.backgroundColor = SKColor(red: 170/255, green: 1, blue: 247/255, alpha: 1)
        mapScene!.addParents(parentView: mapView!, parentPage: self)
        let gesture = NSClickGestureRecognizer(target: mapScene, action: #selector(mapScene!.checkAction))
        mapView!.addGestureRecognizer(gesture)
        
        // Creating a camera
        cameraNode!.position = CGPoint(x: mapScene!.size.width / 2, y: mapScene!.size.height / 2)
        mapScene!.addChild(cameraNode!)
        mapScene!.camera = cameraNode
        
        // Adding Title
        let mapTitle = SKLabelNode(text: "The Map Room")
        mapTitle.name = mapTitle.text
        mapTitle.fontName = "HelveticaNeue"
        mapTitle.fontSize = 48
        mapTitle.fontColor = SKColor.black
        mapTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        mapTitle.position = CGPoint(x: 40, y: 520)
        mapScene!.addChild(mapTitle)
        
        // Description
        let mapDesc = SKLabelNode(text: "Click a highlighted area to learn about how water\nscarcity affects the people of the region.")
        mapDesc.name = "Map Description"
        mapDesc.fontName = "HelveticaNeue-Thin"
        mapDesc.fontSize = 24
        mapDesc.fontColor = SKColor.black
        mapDesc.numberOfLines = 2
        mapDesc.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        mapDesc.position = CGPoint(x: 40, y: 440)
        mapScene!.addChild(mapDesc)
        
        // Creates home button
        let homeButton = ButtonNode(color: NSColor.orange)
        homeButton.setHome()
        homeButton.position = CGPoint(x: 550, y: 550)
        mapScene!.addChild(homeButton)
    
        // Creates an effects node with a gaussian blur filter
        effectsNode = SKEffectNode()
        let filter = CIFilter(name: "CIGaussianBlur")
        let blurAmount = 0.0
        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        effectsNode!.filter = filter
        effectsNode!.blendMode = .alpha
        
        // Map Graphic
        let worldMapTexture = SKTexture(imageNamed: "WorldMap.png")
        let worldMapGraphic = SKSpriteNode(imageNamed: "WorldMap.png")
        worldMapGraphic.texture = worldMapTexture
        worldMapGraphic.size = worldMapTexture.size()
        worldMapGraphic.position = CGPoint(x: 305, y: 250)
        worldMapGraphic.setScale(0.65)
        effectsNode!.addChild(worldMapGraphic)
        mapScene!.addChild(effectsNode!)
        
        self.createMapMarker(name: "Egypt", position: CGPoint(x: 340, y: 265), radius: 10.0, color: NSColor.systemYellow)
        self.createMapMarker(name: "Chile", position: CGPoint(x: 170, y: 155), radius: 15.0, color: NSColor.systemOrange)
        self.createMapMarker(name: "UA Emirates", position: CGPoint(x: 390, y: 253), radius: 7.0, color: NSColor.systemPurple)
        self.createMapMarker(name: "DR Congo", position: CGPoint(x:328, y: 204), radius: 15.0, color: NSColor.systemGreen)
        self.createMapMarker(name: "Pakistan", position: CGPoint(x: 406, y: 264), radius: 9.0, color: NSColor.systemRed)
        self.createMapMarker(name: "Bangladesh", position: CGPoint(x: 445, y: 260), radius: 8.0, color: NSColor.systemBlue)
        self.createMapMarker(name: "South Africa", position: CGPoint(x: 335, y: 150), radius: 10.0, color: NSColor.systemPink)
        self.createMapMarker(name: "Barbados", position: CGPoint(x: 190, y: 245), radius: 15.0, color: NSColor.systemPink)
        
        mapView!.presentScene(mapScene)
    }
    
    /**
     Used to create sub pages for each region on the map. Each one is stylistically identical, and is placed inside the locationPages dictionary.
     - Parameters:
        - title: The title of the page.
        - imageName: The name of the country's flag to be displayed on the page.
        - body: The information displayed in the body of the page.
     - Returns:
        - SKSpriteNode: The parentNode housing the created sub page.
    */
    func createPage(title: String, imageName: String, body: String ) -> SKSpriteNode {
        let parentNode = SKSpriteNode()
        let pageTitle = SKLabelNode(text: title)
        pageTitle.name = pageTitle.text
        pageTitle.fontName = "HelveticaNeue-Bold"
        pageTitle.fontSize = 48
        pageTitle.fontColor = SKColor.black
        pageTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        pageTitle.position = CGPoint(x: -270 , y: 220)
        parentNode.addChild(pageTitle)
        
        let desc = SKLabelNode(text: body)
        desc.name = "Body"
        desc.fontName = "HelveticaNeue-Light"
        desc.fontSize = 24
        desc.fontColor = SKColor.black
        desc.numberOfLines = 20
        desc.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        desc.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        desc.position = CGPoint(x: -270, y: 145)
        parentNode.addChild(desc)
        
        let image = SKSpriteNode(imageNamed: imageName)
        let newX = CGFloat(150)
        let newY = (newX / image.size.width) * image.size.height    // Keeps ratio of image
        image.scale(to: CGSize(width: newX, height: newY))
        image.position = CGPoint(x: 200, y: 235)
        parentNode.addChild(image)
        
        parentNode.name = pageTitle.name
        parentNode.setScale(0.5)

        return parentNode
    }
    
    /**
     Used to create a map marker on the map, which represents a clickable area of the map. The function also adds the map marker to the page's mapScene.
     - Parameters:
        - name: The name of the map marker, connecting it to it's related page.
        - position: The location of the marker on the map.
        - radius: The radius of the marker's circle.
        - color: The color of the marker's circle.
    */
    func createMapMarker(name: String, position: CGPoint, radius: CGFloat, color: NSColor) {
        let mapMarker = SKShapeNode(circleOfRadius: radius)
        mapMarker.fillColor = color
        mapMarker.strokeColor = color
        mapMarker.position = position
        mapMarker.name = name
        mapMarker.alpha = 0.6
        self.effectsNode!.addChild(mapMarker)
    }
}


/**
 The scene that the research page uses to present nodes. Creates modals for the page, as well as handles the animations needed.
 - Parameters:
    - parentView: The associated view of the research page.
    - parentPage: The page object used to house and initialize the research scene and research view.
    - activeModal: The modal currently displayed on the screen.
    - researchModal: The modal for the research sub page.
    - fogModal: The modal for the fog sub page.
    - timer: The timer used to animate the research sub page diagram.
 */
class ResearchScene: SKScene {
    
    var parentView: SKView?
    var parentPage: ResearchPage?
    var activeModal: SKNode?
    var researchModal: SKNode?
    var fogModal: SKNode?
    var timer: Timer?
    
    /**
     Handles the click events for the scene. Used to either open modals within the scene or navigate back to the home page.
     - Parameter sender: The click recognizer for the view.
     */
    @objc func checkAction(sender: NSClickGestureRecognizer) {
        if (activeModal != nil) {
            // First remove all animated nodes from diagram
            for node in self.children {
                if (node.name == "Diagram") {
                    node.removeFromParent()
                }
            }
            self.timer?.invalidate()
            // Exit modal
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let moveOut = SKAction.move(to: CGPoint(x: 312, y: 0), duration: 0.2)
            self.activeModal?.run(moveOut)
            self.activeModal?.run(fadeOut, completion: {
                self.activeModal?.removeFromParent()
                self.activeModal = nil
                let filter = CIFilter(name: "CIGaussianBlur")
                let blurAmount = 0.0
                filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
                self.parentPage?.effectsNode.filter = filter
            })
        } else {
            let location = sender.location(in: self.parentView)
            let clickedNodes = nodes(at: location)
            for node in clickedNodes {
                if (node.name != nil) {
                    if (node.name == "Home") {
                        PlaygroundPage.current.liveView = self.parentPage?.homeView
                    } else if (node.name == "Desalination") {
                        activeModal = researchModal
                        self.presentResearchModal()
                    } else if (node.name == "Fog Catching") {
                        self.activeModal = fogModal
                        self.presentFogModal()
                    }
                }
            }
        }
    }
    
    /**
     Initializes the parents of the class.
     - Parameters:
        - parentView: The parent view of the scene.
        - parentPage: The parent ResearchPage of the scene, which houses the scene.
    */
    func addParents(parentView: SKView, parentPage: ResearchPage) {
        self.parentView = parentView
        self.parentPage = parentPage
    }
    
    /**
     Creates a modal used to display the research sub page, and it's respective diagram.
     - Parameters:
        - firstImageNamed: The image to be displayed in the modal.
        - firstBody: The body string of the modal.
     - Returns:
        - SKNode: The node housing the research modal.
    */
    func createResearchModal(firstImageNamed: String, firstBody: String) -> SKNode {
        let baseNode = SKNode()
        
        let modalBackground = SKSpriteNode(color: NSColor.white, size: CGSize(width: 550, height: 520))
        modalBackground.alpha = 0.8
        baseNode.addChild(modalBackground)
        baseNode.position = CGPoint(x: 312, y: 0)
        
        let diagram = SKSpriteNode(imageNamed: "DesalinationDiagram.png")
        diagram.setScale(0.4)
        diagram.position = CGPoint(x: -75, y: -100)
        baseNode.addChild(diagram)
        
        let pageTitle = SKLabelNode(text: "Desalination")
        pageTitle.fontName = "HelveticaNeue"
        pageTitle.fontSize = 48
        pageTitle.fontColor = SKColor.black
        pageTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        pageTitle.position = CGPoint(x: -250 , y: 200)
        baseNode.addChild(pageTitle)
        
        let desc = SKLabelNode(text: firstBody)
        desc.fontName = "HelveticaNeue-Thin"
        desc.fontSize = 16
        desc.fontColor = SKColor.black
        desc.numberOfLines = 20
        desc.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        desc.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        desc.position = CGPoint(x: -40, y: 100)
        baseNode.addChild(desc)
        
        let solidLabel = SKLabelNode(text: "Solids are filtered out.")
        solidLabel.fontName = "HelveticaNeue-Thin"
        solidLabel.fontSize = 14
        solidLabel.fontColor = SKColor.black
        solidLabel.position = CGPoint(x: -120, y: -80)
        baseNode.addChild(solidLabel)
        
        let osmosisLabel = SKLabelNode(text: "Reverse osmosis\n" +
        "separates salt\n" +
        "from the water.")
        osmosisLabel.fontName = "HelveticaNeue-Thin"
        osmosisLabel.numberOfLines = 3
        osmosisLabel.fontSize = 14
        osmosisLabel.fontColor = SKColor.black
        osmosisLabel.position = CGPoint(x: 0, y: -80)
        baseNode.addChild(osmosisLabel)
        
        let chemLabel = SKLabelNode(text: "Chemicals\npurify the water.")
        chemLabel.fontName = "HelveticaNeue-Thin"
        chemLabel.numberOfLines = 2
        chemLabel.fontSize = 14
        chemLabel.fontColor = SKColor.black
        chemLabel.position = CGPoint(x: 100, y: -80)
        baseNode.addChild(chemLabel)
        
        let safeLabel = SKLabelNode(text: "The water is now safe\nfor consumption!")
        safeLabel.fontName = "HelveticaNeue-Thin"
        safeLabel.numberOfLines = 2
        safeLabel.fontSize = 14
        safeLabel.fontColor = SKColor.black
        safeLabel.position = CGPoint(x: 180, y: -200)
        baseNode.addChild(safeLabel)
        
        let firstImage = SKSpriteNode(imageNamed: firstImageNamed)
        let newX = CGFloat(200)
        let newY = (newX / firstImage.size.width) * firstImage.size.height
        firstImage.scale(to: CGSize(width: newX, height: newY))
        firstImage.position = CGPoint(x: -150, y: 100)
        baseNode.addChild(firstImage)
        
        return baseNode
    }
    
    /**
     Creates a modal used to display the fog sub page, and it's respective graphic.
     - Returns:
        - SKNode: The node housing the fog modal.
    */
    func createFogModal() -> SKNode {
        let baseNode = SKNode()
        
        let modalBackground = SKSpriteNode(color: NSColor.white, size: CGSize(width: 550, height: 520))
        modalBackground.alpha = 0.8
        baseNode.addChild(modalBackground)
        baseNode.position = CGPoint(x: 312, y: 0)
        
        let pageTitle = SKLabelNode(text: "Fog Catching")
        pageTitle.fontName = "HelveticaNeue"
        pageTitle.fontSize = 48
        pageTitle.fontColor = SKColor.black
        pageTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        pageTitle.position = CGPoint(x: -250 , y: 200)
        baseNode.addChild(pageTitle)
        
        let desc = SKLabelNode(text: "In arid areas with plenty of fog, people are\n" +
            "using fog catching nets to harvest water out\n" +
            "of the fog. Originating in Chile during the\n" +
            "1950’s, water from fog is trapped by forcing\n" +
            "the fog through large mesh fences, where it\n" +
            "condenses and drips down into a container.\n" +
            "The technique has been particularly useful in\n" +
            "the Sahara desert, where many women have\n" +
            "to devote large parts of their day to collecting\n" +
            "water.")
        desc.fontName = "HelveticaNeue-Thin"
        desc.fontSize = 16
        desc.fontColor = SKColor.black
        desc.numberOfLines = 20
        desc.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        desc.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        desc.position = CGPoint(x: -40, y: 170)
        baseNode.addChild(desc)
        
        let image = SKSpriteNode(imageNamed: "FogNetPhoto.png")
        let newX = CGFloat(200)
        let newY = (newX / image.size.width) * image.size.height
        image.scale(to: CGSize(width: newX, height: newY))
        image.position = CGPoint(x: -150, y: 100)
        baseNode.addChild(image)
        
        let fogNet = SKSpriteNode(imageNamed: "FogNet.png")
        fogNet.setScale(2.3)
        fogNet.position = CGPoint(x: 0, y: -157)
        baseNode.addChild(fogNet)
        
        let steamCloud = SKSpriteNode(imageNamed: "SteamCloud.png")
        steamCloud.setScale(1.5)
        steamCloud.position = CGPoint(x: -80, y: -150)
        baseNode.addChild(steamCloud)
        
        let steamCloudTwo = SKSpriteNode(imageNamed: "SteamCloud.png")
        steamCloudTwo.setScale(1.8)
        steamCloudTwo.position = CGPoint(x: 40, y: -100)
        baseNode.addChild(steamCloudTwo)
        return baseNode
    }
    
    /**
     Presents the modal when the user clicks on the research modal button. Organized this way because the modal opening
     is smoother when the modal is created before presenting it.
    */
    func presentResearchModal() {
        self.addChild(self.activeModal!)
        self.activeModal?.alpha = 0.0
        let fadeAlpha = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        let moveUp = SKAction.move(to: CGPoint(x: 312, y: 300), duration: 0.5)
        self.activeModal?.run(fadeAlpha)
        self.activeModal?.run(moveUp)
        let filter = CIFilter(name: "CIGaussianBlur")
        let blurAmount = 20.0
        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        self.parentPage?.effectsNode.filter = filter
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.spawnWaterFlow), userInfo: nil, repeats: true)
    }
    
    /**
     Presents the modal when the user clicks on the fog modal button. Organized this way because the modal opening
     is smoother when the modal is created before presenting it.
    */
    func presentFogModal() {
        self.addChild(self.activeModal!)
        self.activeModal?.alpha = 0.0
        let fadeAlpha = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        let moveUp = SKAction.move(to: CGPoint(x: 312, y: 300), duration: 0.5)
        self.activeModal?.run(fadeAlpha)
        self.activeModal?.run(moveUp)
        let filter = CIFilter(name: "CIGaussianBlur")
        let blurAmount = 20.0
        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        self.parentPage?.effectsNode.filter = filter
    }
    
    /**
     Spawns the moving water, falling solids, falling salt water, and the falling chemicals for the research modal diagram.
    */
    @objc func spawnWaterFlow() {
        // First flowing water
        let waterDrop = SKShapeNode(circleOfRadius: 3)
        waterDrop.name = "Diagram"
        waterDrop.fillColor = NSColor.blue
        waterDrop.strokeColor = NSColor.blue
        waterDrop.position = CGPoint(x:50, y: 157)
        let moveWater = SKAction.move(to: CGPoint(x: 430, y: 153), duration: 6.0)
        self.addChild(waterDrop)
        waterDrop.run(moveWater, completion: {
            waterDrop.removeFromParent()
        })
        
        // Removing solids
        let solidDrop = SKShapeNode(circleOfRadius: 3)
        solidDrop.name = "Diagram"
        solidDrop.fillColor = NSColor.brown
        solidDrop.strokeColor = NSColor.brown
        let xPosition = Int(arc4random_uniform(220 - 160) + 160)
        solidDrop.position = CGPoint(x: xPosition, y: 100)
        let moveDown = SKAction.move(to: CGPoint(x: xPosition, y: 0), duration: 1.0)
        self.addChild(solidDrop)
        solidDrop.run(moveDown, completion: {
            solidDrop.removeFromParent()
        })
        
        // Removing Brine
        let brineDrop = SKShapeNode(circleOfRadius: 3)
        brineDrop.name = "Diagram"
        brineDrop.fillColor = NSColor.lightGray
        brineDrop.strokeColor = NSColor.lightGray
        let brineXPosition = Int(arc4random_uniform(360 - 320) + 320)
        brineDrop.position = CGPoint(x: brineXPosition, y: 100)
        let brineMoveDown = SKAction.move(to: CGPoint(x: brineXPosition, y: 0), duration: 1.0)
        self.addChild(brineDrop)
        brineDrop.run(brineMoveDown, completion: {
            brineDrop.removeFromParent()
        })
        
        // Adding Chemicals
        let chemDrop = SKShapeNode(circleOfRadius: 1.5)
        chemDrop.name = "Diagram"
        chemDrop.fillColor = NSColor.systemPink
        chemDrop.strokeColor = NSColor.systemPink
        chemDrop.position = CGPoint(x: 387, y: 200)
        let chemMoveDown = SKAction.move(to: CGPoint(x: 387, y: 180), duration: 1)
        self.addChild(chemDrop)
        chemDrop.run(chemMoveDown, completion: {
            chemDrop.removeFromParent()
        })
    }
}


/**
 Class used to house the researchScene and researchView.
 - Parameters:
    - researchScene: The page's ResearchScene, an extended SKScene.
    - researchView: The page's SKView.
    - homeView: The page's parent home view.
    - effectsNode: The page's effectsNode, used to blur the background when the modal is in the foreground.
*/
class ResearchPage {
    
    var researchScene: ResearchScene?
    var researchView: SKView?
    var homeView: SCNView
    let effectsNode: SKEffectNode
    
    /**
     Initializes the research page, creates both modals for future presentation.
     - Parameters:
        - parentView: The parent view of the ResearchPage.
     */
    init(parentView: SCNView) {
        // Initializing class variables
        self.homeView = parentView
        researchScene = ResearchScene()
        researchView = SKView(frame: NSRect(x: 0, y: 0, width: 612, height: 600))
        effectsNode = SKEffectNode()
        
        // Creating effectsNode
        let filter = CIFilter(name: "CIGaussianBlur")
        let blurAmount = 0.0
        filter?.setValue(blurAmount, forKey: kCIInputRadiusKey)
        effectsNode.filter = filter
        effectsNode.blendMode = .alpha
        
        // Setting the Scene
        researchScene!.size = CGSize(width: 612, height: 600)
        researchScene!.addParents(parentView: researchView!, parentPage: self)
        let gesture = NSClickGestureRecognizer(target: researchScene, action: #selector(researchScene!.checkAction))
        researchView!.addGestureRecognizer(gesture)
        
        // Adding Workbench graphic
        let workBench = SKSpriteNode(imageNamed: "WorkBench.png")
        effectsNode.addChild(workBench)
        workBench.setScale(6.4)
        workBench.position = CGPoint(x: 312, y: 150)
        
        // Adding Title
        let researchTitle = SKLabelNode(text: "The R&D Room")
        researchTitle.name = researchTitle.text
        researchTitle.fontName = "Helvetica-Neue"
        researchTitle.fontSize = 48
        researchTitle.fontColor = SKColor.white
        researchTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        researchTitle.position = CGPoint(x: 40, y: 520)
        
        // Adding Description
        let researchDesc = SKLabelNode(text: "A few things made to reduce water scarcity.")
        researchDesc.name = researchDesc.text
        researchDesc.fontName = "HelveticaNeue-Thin"
        researchDesc.numberOfLines = 1
        researchDesc.fontSize = 28
        researchDesc.fontColor = SKColor.white
        researchDesc.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        researchDesc.position = CGPoint(x: 40, y: 480)
        
        // Adding Buttons
        let homeButton = ButtonNode(color: NSColor.orange)
        homeButton.setHome()
        homeButton.position = CGPoint(x: 550, y: 550)
        effectsNode.addChild(homeButton)
        
        let researchButton = ButtonNode(color: NSColor.orange)
        researchButton.setText(text: "Desalination")
        researchButton.size = CGSize(width: 200.0, height: 100.0)
        researchButton.position = CGPoint(x: 190, y: 300)
        effectsNode.addChild(researchButton)
        
        let helpButton = ButtonNode(color: NSColor.orange)
        helpButton.setSecondary()
        helpButton.setText(text: "Fog Catching")
        helpButton.size = CGSize(width: 200.0, height: 100.0)
        helpButton.position = CGPoint(x: 444, y: 300)
        effectsNode.addChild(helpButton)
        
        researchScene!.backgroundColor = SKColor(red: 169/255, green: 188/255, blue: 208/255, alpha: 1)
        effectsNode.addChild(researchTitle)
        effectsNode.addChild(researchDesc)
        researchScene!.addChild(effectsNode)
        researchView!.presentScene(researchScene)
        let fadeIn = SKAction.fadeIn(withDuration: 0.4)
        researchScene!.run(fadeIn)
        
        self.researchScene?.researchModal = self.researchScene?.createResearchModal(firstImageNamed: "Desalination.png",
            firstBody: "Desalination is a way some countries are\n" +
            "tackling their water shortages. In Israel, almost\n" +
            "half of the water used is desalinated water. As\n" +
            "a result their water shortages have been\n" +
            "significantly minimized in recent years.")
        self.researchScene?.fogModal  = self.researchScene?.createFogModal()
    }
}


/**
 Class that generates and houses all data pertaining to rendering the house scene.
 - Parameters:
    - sceneView: The house's SCNView.
    - scene: The house's SCNScene.
    - spriteView: The house's overlay SKView.
    - spriteScene: The house's overlay SKScene, used to display intro information.
    - cameraNode: The SCNCamera used to display the house scene.
    - sceneLightNode: Used to light the house scene.
 */
class HouseModel {
    // Declare sceneKit variables
    var sceneView: SCNView?
    var scene: SCNScene?
    // Declare spriteKit variables
    var spriteView: SKView
    var spriteScene: SKScene
    // Camera
    var cameraNode: SCNNode
    // Lighting Node
    var sceneLightNode: SCNNode
    
    /**
     Initializes the house, and pieces together the house model. Refer to inline comments for specifics.
     */
    init() {
        // Initialize sceneKit
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width:612, height: 600))
        sceneView!.backgroundColor = NSColor(red: 11/255, green: 253/255, blue: 249/255, alpha: 1)
        scene = SCNScene()
        sceneView!.scene = scene
        // Initialize spriteKit
        spriteView = SKView(frame: CGRect(x: 0, y: 0, width: 624, height: 600))
        spriteScene = SKScene(size: CGSize(width: 612, height: 600))
        // Spritekit title
        let textBack = SKSpriteNode(color: NSColor.white, size: CGSize(width: 612, height: 150))
        textBack.alpha = 0.7
        textBack.position = CGPoint(x: 306, y: 530)
        self.spriteScene.addChild(textBack)
        
        // Spritekit overlay related additions
        let title = SKLabelNode(text: "World of Water")
        title.fontName = "HelveticaNeue-Bold"
        title.fontSize = 48
        title.fontColor = SKColor.black
        title.position = CGPoint(x: 306, y: 550)
        self.spriteScene.addChild(title)
        
        let desc = SKLabelNode(text: "Click on a room and learn about the world water crisis.")
        desc.fontName = "HelveticaNeue-Thin"
        desc.fontSize = 26
        desc.fontColor = SKColor.black
        desc.position = CGPoint(x: 306, y: 500)
        self.spriteScene.addChild(desc)
        
        let showerLabel = SKLabelNode(text: "Shower Room")
        showerLabel.fontName = "HelveticaNeue-Bold"
        showerLabel.fontSize = 26
        showerLabel.fontColor = SKColor.white
        showerLabel.position = CGPoint(x: 160, y: 400)
        self.spriteScene.addChild(showerLabel)
        
        let mapLabel = SKLabelNode(text: "Map Room")
        mapLabel.fontName = "HelveticaNeue-Bold"
        mapLabel.fontSize = 26
        mapLabel.fontColor = SKColor.white
        mapLabel.position = CGPoint(x: 400, y: 400)
        self.spriteScene.addChild(mapLabel)
        
        let researchLabel = SKLabelNode(text: "R&D Room")
        researchLabel.fontName = "HelveticaNeue-Bold"
        researchLabel.fontSize = 26
        researchLabel.fontColor = SKColor.white
        researchLabel.position = CGPoint(x: 400, y: 270)
        self.spriteScene.addChild(researchLabel)
        
        sceneView!.overlaySKScene = self.spriteScene
        // Camera
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        // Effects
        cameraNode.position = SCNVector3(x:-0.25, y:0.5, z: 3)
        self.scene?.rootNode.addChildNode(cameraNode)
        
        // Primary Lighting
        sceneLightNode = SCNNode()
        sceneLightNode.light = SCNLight()
        sceneLightNode.light?.type = SCNLight.LightType.omni
        sceneLightNode.position = SCNVector3(-1,6,5)
        sceneLightNode.light?.color = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.scene?.rootNode.addChildNode(sceneLightNode)
        
        // sets up camera for sceneView
        sceneView!.allowsCameraControl = false
        let clickGesture = NSClickGestureRecognizer(target: self, action:  #selector(self.checkAction))
        sceneView!.addGestureRecognizer(clickGesture)
        
        // Mountains
        let mountain = Mountain()
        mountain.setPosition(x: -10, z: -40)
        mountain.getNode().rotation = SCNVector4(0, 1, 0, 0.9)
        let secondMountain = Mountain()
        secondMountain.setPosition(x: 10, z: -40)
        secondMountain.getNode().rotation = SCNVector4(0, 1, 0, 0.9)
        self.scene!.rootNode.addChildNode(mountain.getNode())
        self.scene!.rootNode.addChildNode(secondMountain.getNode())
        
        // Creating House
        let houseBaseNode = House()
        self.scene!.rootNode.addChildNode(houseBaseNode.houseNode)
        // Scenery
        let grass = SCNFloor()
        let grassNode = SCNNode(geometry: grass)
        grass.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name("Grass.png"))
        grass.reflectivity = 0
        grassNode.rotation = SCNVector4(0, 1, 0, 0.9)
        grassNode.position = SCNVector3(0, -0.60, 0)
        self.scene!.rootNode.addChildNode(grassNode)
    }
    
    /**
     Handles click gestures, and calls the function to transition the program to the next page.
     - Parameters:
        - sender: The NSClickGestureRecognizer of the scene used to trigger the checkAction function.
     */
    @objc func checkAction(sender: NSClickGestureRecognizer) {
        let location = sender.location(in: self.sceneView)
        let nodes = self.sceneView?.hitTest(location, options: nil)
        if nodes!.count > 0 {
            for node in nodes! {
                if (node.node.name == "Shower") {
                    animateCamera(pageName: "Shower")
                } else if (node.node.name == "Map") {
                    animateCamera(pageName: "Map")
                } else if (node.node.name == "Research") {
                    animateCamera(pageName: "Research")
                }
            }
        }
    }
    
    /**
     Animates the camera when transitioning to a new page so that the transition is less abrupt.
     After the animation, transitions to the next page.
     - Parameters:
        - pageName: The name of the page that the program is transitioning to.
    */
    func animateCamera(pageName: String) {
        // Dont want z clipping with objects
        let blueCover = SKSpriteNode(color: NSColor.cyan, size: CGSize(width: 1280, height: 600))
        blueCover.position = CGPoint(x: 612, y: 0)
        let moveUp = SKAction.move(to: CGPoint(x: 612, y: 300), duration: 0.2)
        self.spriteScene.addChild(blueCover)
        blueCover.run(moveUp, completion: {
            PlaygroundPage.current.liveView = pageViews[pageName]
            blueCover.removeFromParent()
        })
    }
}


/**
 Class for creating mountains in the house scene. Purely for additional visual flair.
 - Parameters:
    - mountainNode: The node the mountain is created to.
 */
class Mountain {
    
    private var mountainNode: SCNNode
    
    /**
     Creates the mountain geometry, and sets the material of the mountain to that of the Mountains.png image.
    */
    init() {
        let mountain = SCNPyramid(width: 0.1, height: 20, length: 30)
        mountainNode = SCNNode(geometry: mountain)
        mountainNode.position = SCNVector3(0,-0.1,0)
        mountain.firstMaterial?.diffuse.contents = NSColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1)
        mountain.firstMaterial?.diffuse.contents = NSColor(red: 255, green: 204, blue: 102, alpha: 1)
        let mountainMaterial = SCNMaterial()
        mountainMaterial.isDoubleSided = false
        mountainMaterial.diffuse.contents = NSImage(named: NSImage.Name("Mountains.png"))
        mountainNode.geometry?.materials = [mountainMaterial]
    }
    
    /**
     Used to set the position of the mountain from outside of the class.
     - Parameters:
        - x: The new x coordinate of the mountain.
        - z: The new z coordinate of the mountain.
    */
    func setPosition(x: Double, z: Double) {
        self.mountainNode.position = SCNVector3(x, -0.45, z)
    }
    
    /// - Returns: The mountainNode.
    func getNode() -> SCNNode {
        return self.mountainNode
    }
}

/**
 Class used for combining all the smallest pieces of the house.
 - Parameters:
    - houseNode: The base node that all house geometry is a child of.
    - houseBaseNode: The node of the primary block of the house.
    - houseLeftNode: The node of the left side of the house.
 */
class House {
    var houseNode: SCNNode
    var houseBaseNode: SCNNode
    var houseLeftNode: SCNNode
    
    /**
     Creates and combines pieces of the house. Refer to inline comments for further details.
    */
    init() {
        // Main Chunk of House
        let houseBase = SCNBox(width: 1, height: 1, length: 2, chamferRadius: 0)
        houseBaseNode = SCNNode(geometry: houseBase)
        houseBaseNode.name = "Research"
        houseBaseNode.position = SCNVector3(0,-0.1,0)
        houseBase.firstMaterial?.diffuse.contents = NSColor(red: 255.0/255.0, green: 170/255.0, blue: 100, alpha: 1)
        houseBase.firstMaterial?.specular.contents = NSColor(red: 255, green: 204, blue: 102, alpha: 1)
        houseBase.widthSegmentCount = 4
        houseBase.heightSegmentCount = 4
        houseBase.lengthSegmentCount = 4
        
        // Materials For Main Chunk of House
        let garageMaterial = SCNMaterial()
        garageMaterial.isDoubleSided = false
        garageMaterial.diffuse.contents = NSImage(named: NSImage.Name("Garage"))
        
        let sideMaterial = SCNMaterial()
        sideMaterial.isDoubleSided = false
        sideMaterial.diffuse.contents = NSImage(named: NSImage.Name("Side Brick.png"))
        houseBaseNode.geometry?.materials = [sideMaterial,  sideMaterial, sideMaterial, garageMaterial, sideMaterial, sideMaterial]
        
        // Jutting Out Chunk
        let houseLeft = SCNBox(width: 0.6, height: 1, length: 1, chamferRadius: 0)
        houseLeftNode = SCNNode(geometry: houseLeft)
        houseLeftNode.name = "Shower"
        houseLeftNode.position = SCNVector3(-0.8, -0.1, -0.5)
        houseLeft.firstMaterial?.diffuse.contents = NSColor(red: 255.0/255.0, green: 170/255.0, blue: 100, alpha: 1)
        houseLeft.firstMaterial?.specular.contents = NSColor(red: 255, green: 204, blue: 102, alpha: 1)
        houseLeft.widthSegmentCount = 4
        houseLeft.heightSegmentCount = 4
        houseLeft.lengthSegmentCount = 4
        
        let houseLeftUpper = SCNBox(width: 0.6, height: 0.6, length: 1, chamferRadius: 0)
        let houseLeftUpperNode = SCNNode(geometry: houseLeftUpper)
        houseLeftUpperNode.name = "Shower"
        houseLeftUpperNode.position = SCNVector3(-0.8, 0.7, -0.5)
        houseLeftUpper.firstMaterial?.diffuse.contents = NSColor(red: 255.0/255.0, green: 170/255.0, blue: 100, alpha: 1)
        houseLeftUpper.firstMaterial?.specular.contents = NSColor(red: 255, green: 204, blue: 102, alpha: 1)
        houseLeftUpper.widthSegmentCount = 4
        houseLeftUpper.heightSegmentCount = 4
        houseLeftUpper.lengthSegmentCount = 4
        
        // For Map Room
        let houseBaseUpper = SCNBox(width: 1, height: 0.6, length: 2, chamferRadius: 0)
        let houseBaseUpperNode = SCNNode(geometry: houseBaseUpper)
        houseBaseUpperNode.name = "Map"
        houseBaseUpperNode.position = SCNVector3(0,0.7,0)
        houseBaseUpper.firstMaterial?.diffuse.contents = NSColor(red: 255.0/255.0, green: 170/255.0, blue: 100, alpha: 1)
        houseBaseUpper.firstMaterial?.specular.contents = NSColor(red: 255, green: 204, blue: 102, alpha: 1)
        
        let mapRoomFrontMaterial = SCNMaterial()
        mapRoomFrontMaterial.isDoubleSided = false
        mapRoomFrontMaterial.diffuse.contents = NSImage(named: NSImage.Name("MapRoom Front.png"))
        let mapRoomSideMaterial = SCNMaterial()
        mapRoomSideMaterial.isDoubleSided = false
        mapRoomSideMaterial.diffuse.contents = NSImage(named: NSImage.Name("MapRoomSide.png"))
        houseBaseUpper.widthSegmentCount = 4
        houseBaseUpper.heightSegmentCount = 4
        houseBaseUpper.lengthSegmentCount = 4
        houseBaseUpperNode.geometry?.materials = [mapRoomSideMaterial,  mapRoomSideMaterial, mapRoomSideMaterial, mapRoomFrontMaterial, mapRoomSideMaterial, mapRoomSideMaterial]
        
        //Material for Jutting Out Chunk
        let doorMaterial = SCNMaterial()
        doorMaterial.isDoubleSided = false
        doorMaterial.diffuse.contents = NSImage(named: NSImage.Name("FrontDoor.png"))
        
        let sideChunkMaterial = SCNMaterial()
        sideChunkMaterial.isDoubleSided = false
        sideChunkMaterial.diffuse.contents = NSImage(named: NSImage.Name("ShowerRoomSide.png")) // Same texture
        
        let showerRoomFrontMaterial = SCNMaterial()
        showerRoomFrontMaterial.isDoubleSided = false
        showerRoomFrontMaterial.diffuse.contents = NSImage(named: NSImage.Name("ShowerRoomFront.png"))
        
        let showerRoomSideMaterial = SCNMaterial()
        showerRoomSideMaterial.isDoubleSided = false
        showerRoomSideMaterial.diffuse.contents = NSImage(named: NSImage.Name("ShowerRoomSide.png"))
        
        houseLeftNode.geometry?.materials = [sideChunkMaterial, sideChunkMaterial, sideChunkMaterial, doorMaterial, sideChunkMaterial, sideChunkMaterial]
        houseLeftUpperNode.geometry?.materials = [showerRoomSideMaterial, showerRoomSideMaterial, showerRoomSideMaterial, showerRoomFrontMaterial, showerRoomSideMaterial, showerRoomSideMaterial]
        
        // Jutting Out Roof
        let houseLeftRoof = SCNPyramid(width: 1.8, height: 0.5, length: 1.2)
        let houseLeftRoofNode = SCNNode(geometry: houseLeftRoof)
        houseLeftRoofNode.position = SCNVector3(-0.4, 1, -0.5)
        houseLeftRoof.firstMaterial?.diffuse.contents = NSColor(red: 255.0/255.0, green: 170/255.0, blue: 2/255.0, alpha: 1)
        houseLeftRoof.firstMaterial?.specular.contents = NSColor(red: 255, green: 204, blue: 102, alpha: 1)
        
        // Main Chunk Roof
        let houseBaseRoof = SCNPyramid(width: 1.5, height: 1, length: 2.2)
        let houseBaseRoofNode = SCNNode(geometry: houseBaseRoof)
        houseBaseRoofNode.position = SCNVector3(0, 1, 0)
        houseBaseRoof.firstMaterial?.diffuse.contents = NSColor(red: 255.0/255.0, green: 170/255.0, blue: 2/255.0, alpha: 1)
        houseBaseRoof.firstMaterial?.specular.contents = NSColor(red: 255, green: 204, blue: 102, alpha: 1)
        
        // Materials for Roof
        let roofMaterial = SCNMaterial()
        roofMaterial.isDoubleSided = false
        roofMaterial.diffuse.contents = NSImage(named: NSImage.Name("Roof.png"))
        houseBaseRoofNode.geometry?.materials = [roofMaterial]
        houseLeftRoofNode.geometry?.materials = [roofMaterial]
        
        //Driveway
        let driveway = SCNBox(width:3, height: 0.1, length: 0.85, chamferRadius: 0)
        driveway.firstMaterial?.diffuse.contents = NSColor.gray
        driveway.firstMaterial?.specular.contents = NSColor(red: 255, green: 204, blue: 102, alpha: 1)
        let drivewayNode = SCNNode(geometry: driveway)
        drivewayNode.position = SCNVector3(-2,-0.63,0.5)
        
        // Adding it all together
        houseNode = SCNNode()
        houseNode.addChildNode(houseBaseNode)
        houseNode.addChildNode(houseBaseUpperNode)
        houseNode.addChildNode(houseLeftNode)
        houseNode.addChildNode(houseLeftUpperNode)
        houseNode.addChildNode(houseLeftRoofNode)
        houseNode.addChildNode(houseBaseRoofNode)
        houseNode.addChildNode(drivewayNode)
        houseNode.rotation = SCNVector4(0, 1, 0, 0.9)
    }
}

// Creating Objects and starting the playground.
var house = HouseModel()
let shower = ShowerPage(parentView: house.sceneView!)
var map = MapPage(parentView: house.sceneView!)
var research = ResearchPage(parentView: house.sceneView!)
pageViews["Shower"] = shower.showerView
pageViews["Map"] = map.mapView
pageViews["Research"] = research.researchView

PlaygroundPage.current.liveView = house.sceneView
