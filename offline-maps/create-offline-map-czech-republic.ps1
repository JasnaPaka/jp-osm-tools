#
# Create offline map of Czech Republic based on data from OpenStreetMap project 
#
# Author:  Pavel Cvrcek <jasnapaka@jasnapaka.com>
# Version: 1.0
#

echo "Inicializing environment..."

. ".\create-offline-map-common.ps1"
initEnvironment;

# We need contour lines (downloading pregenerated data for Czech republic)
echo "Downloading contour lines for Czech Republic..."
Invoke-WebRequest http://osm.jasnapaka.com/stahnout/czech_republic_srtm3.osm.pbf -OutFile czech_republic_srtm3.osm.pbf

# Download OSM data
echo "Downloading OSM data for Czech Republic (it takes a few minutes)..."
Invoke-WebRequest http://download.geofabrik.de/europe/czech-republic-latest.osm.pbf -OutFile czech-republic-latest.osm.pbf

# Generate map
echo "Generate offline map file..."
Osmosis\bin\osmosis.bat --rb file="czech-republic-latest.osm.pbf" --sort-0.6 --rb czech_republic_srtm3.osm.pbf --sort-0.6 --merge --wb czech_republic_merge.pbf
Osmosis\bin\osmosis.bat --rb file=czech_republic_merge.pbf --mapfile-writer file=czech_republic.osm.map type=hd tag-conf-file=tag-mapping.xml

# Clean
Remove-Item czech_republic_srtm3.osm.pbf
Remove-Item czech-republic-latest.osm.pbf
Remove-Item czech_republic_merge.pbf