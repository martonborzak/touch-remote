# Setting up your environment

The software of the remote is written in [Qt](https://www.qt.io/). In order to get the code running on your machine you should download and install Qt for Windows, Mac or Linux the [Qt open source license edition](https://www.qt.io/download-qt-installer). When running the installer, make sure you select the following components (versions at the time of writing this document):

## Mac OSX

  - macOS
  - Sources
  - Qt Virtual Keyboard
  * You can select iOS if you wish to run it on your Apple mobile device too

## Windows

  - All MSVC entries
  - MinGW 7.3.0 64-bit
  - Sources
  - Qt Virtual Keyboard
  - Qt Debug Information Files
  
## Linux (Ubuntu)

  - Desktop gcc 64-bit
  - Sources
  - Qt Virtual Keyboard
  - Qt Network Authorization
  
  * Getting error: cannot find -lGL & collect2: error: Id returned 1 exit status ? **Fix**: sudo apt-get install libgles2-mesa-dev
  
The Developer and Designer Tools are preselected and you can leave that.

> In case you need to add, remove or change components post-install, open the file "MaintenanceTool.exe" in the root of the Install directory (C:\Qt by default)

After setting up your environment you can continue to configure your remote app project according to the information below.


# How to get it runnig on your computer

1. After installing Qt follow below steps;

2. Edit the [config.json](./remote/config.json) file. Enter your Home Assistant ip:port, your token, rooms and your entitites.

3. Install the font [Open Sans](https://fonts.google.com/specimen/Open+Sans) 

That's it you're ready to try it out.


# How does the remote app work
I'll do my best to explain how I built the app. If something is not clear, please let me know. There's also a [discord channel](http://chat.yio-remote.com) and [forum](https://community.yio-remote.com) where we can talk about the remote. 


## Configuration
config.json has all the configuration. This file is generated by the setup app. It can also be edited manually.


**Integration**
The integration that should be loaded. At the moment only one integration can be loaded. The name of the integration should match with the filename under /integrations. The application automatically loads the integration file based on this configuration.


**Integration config**
This json entry name should match the integration name and file as above. This entry various from integration to integration. For Home Assistant one entry is required: ip address and port. Token is optional.


**Areas**
List of areas that your setup has.


**Entities**
List of entities that you want to control. Each entity has a type and data. The type holds the name of the entity. This should match up with the entities listed in **supported_entities** variable in main.qml.
The data part holds all the entitites that you have configured.


## Integrations
An integration is a connection and communication between the remote and a home automation software. This could be for example: Home Assistant, Homey, Domoticz, OpenHab, etc. The integration's filename should match with the value defined in the configuration json. The integration is loaded automatically when the app launches. If you'd like to develop an integration, create a file in the integrations directory: for example homeassistant.qml.


## Components
A component is a support to control an entity, for example: lights. For every component, there should be a directory with the entity's name under /components. Minium 3 files are necessary for a component to work:
- Button.qml This is the graphical representation of the component.
- Main.qml This is the main component file that loads the integration and hold all the entities from the configuration file
- [integration name].qml This is the integration file. IF there are more integrations, there should be an integration file for each one. File name should match the files in /integrations


## Translations
The folder translations contain multiple .json files. With scalability in mind, each file represents a language, for example: en-us.json, pt-br.json or nl-nl.json.


## Colors
Colors are defined in main.qml. Two color schemes are defined. One dark and one light. A boolean **darkMode** is switched to change between the colors.


## Software update
At every startup and every 2 hours a script checks if there's a new version on github. A red circle will appear in the status bar when there's a new version. If auto updated is on, it will automatically update the software. There is a bash script that downloads the file and replaces it.

A variable **_current_version** is defined in main.qml. This sould be updated with every release.


## Supported components
supported_entitites variable holds all the supported components. When a new component is added, the name should also be added to this variable. A variable named entities_[entity] should be also created for each supported entity.


## Websocket server
The app creates a websocket server that is used to communicate with a python script running in the background controlling the brightness, haptic motor, monitoring the battery etc.



# Folder structure
```
app folder
↳ basic_ui
  Contains basic UI elements like charging screen, status bar etc.

  ↳ main_navigation
    Contains files for the navigation that appears on the bottom of the screen

↳ components
Folder for the various components that control an entity: for example light. Each component has its own subfolder.

  ↳ light
    Button.qml
    This is the UI for the component. It has an open and closed state.
    
    Main.qml
    This is the main qml file for the component.
    This file gets loaded after the configuration is loaded in main.qml. When the component is loaded it looks for which integration to load and loads it.
    It has two variables:
    - entities: holds the entities that are defined in the config.json file
    - ComponentIntegration: object that holds the loaded integration
    
    homeassistant.qml
    There should be a file for every integration. The name should match the file in /integrations.
    This file gets the data from the main integration and processes it.
  
↳ images

↳ integrations
  Integration files for various hubs. Each integration should have its own file. The name of the file should match with the integration configured in config.json

↳ scrips
  Various javascript files.
  helper.js - helper functions
  softwareupdate.js - software update check
  websocket.js - functions that communicate with the python script controlling the display, wifi, haptic motor, etc.

↳ sources
  C++ files.
  jsonfile - reads the json files
  launcher - executes bash scripts
  main - main cpp file for the app
  
↳ translations
  contains various json files where each file represents a language.

MainContaner.qml
The main container for the app. It has the following components:
- statusbar
- main content area
- navigation bar
- mini media player
- popup and loading screens and notifications

config.json
Main configuration file

main.qml
Main qml file

translations.json
Translations for languages.
``` 
