set -e

for GAME_NAME in `find src -mindepth 1 -type d -printf "%f\n"`
do
  make GAME_NAME=$GAME_NAME
done
