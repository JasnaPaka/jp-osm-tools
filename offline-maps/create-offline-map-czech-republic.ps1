#
# Create offline map of Czech Republic based on data from OpenStreetMap project 
#
# Author:  Pavel Cvrcek <jasnapaka@jasnapaka.com>
# Version: 1.0
#

echo "Inicializing environment..."

Add-Type -assembly "system.io.compression.filesystem"

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

# We need contour lines (downloading pregenerated data for Czech republic)
if (!(Test-Path .\czech_republic_srtm3.osm.pbf)) {
    echo "Downloading contour lines for Czech Republic..."
    Invoke-WebRequest http://osm.jasnapaka.com/stahnout/czech_republic_srtm3.osm.pbf -OutFile czech_republic_srtm3.osm.pbf
}


# Generate map
echo "Downloading OSM data for Czech Republic (it takes a few minutes)..."
Invoke-WebRequest http://download.geofabrik.de/europe/czech-republic-latest.osm.pbf -OutFile czech-republic-latest.osm.pbf
echo "Generate offline map file..."
Osmosis\bin\osmosis.bat --rb file="czech-republic-latest.osm.pbf" --sort-0.6 --rb czech_republic_srtm3.osm.pbf --sort-0.6 --merge --wb czech_republic_merge.pbf
Osmosis\bin\osmosis.bat --rb file=czech_republic_merge.pbf --mapfile-writer file=czech_republic.osm.map type=hd tag-conf-file=tag-mapping.xml

# Clean
Rename-Item czech-republic-latest.osm.pbf
Rename-Item czech_republic_merge.pbf