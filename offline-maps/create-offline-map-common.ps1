#
# Shared functions
#

Add-Type -assembly "system.io.compression.filesystem"


function initEnvironment([string] $stateName) {
    
  # Remove old files (if exists)
  Remove-Item $stateName*.pbf
    
  # We need Osmosis tool
  if (!(Test-Path .\osmosis)) {
      echo "Downloading Osmosis..."
      
      Invoke-WebRequest http://bretth.dev.openstreetmap.org/osmosis-build/osmosis-0.41.zip -OutFile .\osmosis.zip
      [io.compression.zipfile]::ExtractToDirectory($PSScriptRoot + "\osmosis.zip", $PSScriptRoot)
  
      Rename-Item -path .\osmosis-0.41 -newname .\osmosis
      Remove-Item .\osmosis.zip 
  };
  
  # We need MapsForge plugin
  if (!(Test-Path .\plugins)) {    
      New-Item plugins -type directory
  }
  if (!(Test-Path .\plugins\mapsforge-map-writer-0.5.1.jar)) {
      echo "Downloading MapsForge plugin..."
      
      Invoke-WebRequest https://repo1.maven.org/maven2/org/mapsforge/mapsforge-map-writer/0.5.1/mapsforge-map-writer-0.5.1-jar-with-dependencies.jar `
          -OutFile .\plugins\mapsforge-map-writer-0.5.1.jar 
  }    
    
}
