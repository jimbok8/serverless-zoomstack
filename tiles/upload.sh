# Download the Zoomstack mbtiles file from the OS
# (order at https://www.ordnancesurvey.co.uk/opendatadownload/products.html)
wget '_YOUR_ZOOMSTACK_DOWNLOAD_URL'

# Rename file to something friendlier
mv *.mbtiles* /data/oszoom/oszoom.mbtiles

# Use mb-util to explode the mbtiles to a directory in pbf format
# (mb-util can be downloaded from https://github.com/mapbox/mbutil)
mb-util /data/oszoom/oszoom.mbtiles /data/oszoom/20190912 --image_format pbf --silent

# Copy the tiles up to our bucket with the all-important metadata
time aws s3 cp /data/oszoom/20190912 s3://tiles.zoomstack.xyz/oszoom/20190912/ --recursive --content-type application/x-protobuf --content-encoding 'gzip' --quiet

# Prepare the tile.json file using information from s3://tiles.zoomstack.xyz/oszoom/20190912/metadata.json
# IMPORTANT: be sure to change metadata to remove gzip encoding and set type to applicaton/json

# Copy up the oszoom.json file to the bucket
aws s3 cp oszoom.json s3://tiles.zoomstack.xyz/oszoom/oszoom.json --content-type application/json --cache-control max-age=3600

# Copy the sprites up to the bucket
aws s3 cp sprites s3://tiles.zoomstack.xyz/oszoom/sprites --recursive --quiet

# Copy the fonts up to the bucket (again, setting the correct headers, note that these files are not compressed)
aws s3 cp fonts s3://tiles.zoomstack.xyz/oszoom/fonts --recursive --content-type application/x-protobuf --quiet

# Copy the map application up to the www bucket
aws s3 cp ../map/ s3://www.zoomstack.xyz/ --recursive --quiet
