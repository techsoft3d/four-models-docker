
#!/bin/sh
echo "Copying HOOPS files to public-staging/hoops..."

mkdir -p /opt/public-staging/hoops
cp /opt/hoops_communicator/web_viewer/deprecated/src/js/hoops_web_viewer.js /opt/public-staging/hoops/
cp /opt/hoops_communicator/web_viewer/deprecated/src/js/engine-wasm.js /opt/public-staging/hoops/
cp /opt/hoops_communicator/web_viewer/deprecated/src/js/engine-asmjs.js /opt/public-staging/hoops/
cp /opt/hoops_communicator/web_viewer/deprecated/src/js/engine.wasm /opt/public-staging/hoops/

echo "Copy complete. Starting main container process..."
exec ../../3rd_party/node/bin/node --expose-gc ./lib/Startup.js --config-file ../../quick_start/server_config.js
