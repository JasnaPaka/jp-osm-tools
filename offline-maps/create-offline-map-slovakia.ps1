#
# Create offline map of Slovakia based on data from OpenStreetMap project 
#
# Author:  Pavel Cvrcek <jasnapaka@jasnapaka.com>
# Version: 1.0
#

echo "Inicializing environment..."

. ".\create-offline-map-common.ps1"
initEnvironment "slovakia";

# We need contour lines (downloading pregenerated data for Slovakia)
echo "Downloading contour lines for Slovakia..."
Invoke-WebRequest http://osm.jasnapaka.com/stahnout/slovakia_srtm3.osm.pbf -OutFile slovakia_srtm3.osm.pbf

# Download OSM data
echo "Downloading OSM data for Slovakia (it takes a few minutes)..."
Invoke-WebRequest http://download.geofabrik.de/europe/slovakia-latest.osm.pbf -OutFile slovakia-latest.osm.pbf

# Generate map
echo "Generate offline map file..."
Osmosis\bin\osmosis.bat --rb file="slovakia-latest.osm.pbf" --sort-0.6 --rb slovakia_srtm3.osm.pbf --sort-0.6 --merge --wb slovakia_merge.pbf
Osmosis\bin\osmosis.bat --rb file=slovakia_merge.pbf --mapfile-writer file=slovakia.osm.map type=hd tag-conf-file=tag-mapping.xml

# Clean
Remove-Item slovakia_srtm3.osm.pbf
Remove-Item slovakia-latest.osm.pbf
Remove-Item slovakia_merge.pbf