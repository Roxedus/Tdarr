set METEOR_PROFILE=100
set METEOR_DEBUG_BUILD=1
set NODE_OPTIONS=--max-old-space-size=6040
meteor build --server localhost:8265 --directory ../tdarr-${{ matrix.os }} --architecture os.windows.x86_64