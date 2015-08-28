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
      
      Invoke-WebRequest http://ci.mapsforge.org/job/0.5.1/lastSuccessfulBuild/artifact/mapsforge-map-writer/build/libs/mapsforge-map-writer-0.5.1.jar `
          -OutFile .\plugins\mapsforge-map-writer-0.5.1.jar 
  }    
    
}