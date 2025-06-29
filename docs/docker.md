# Using mc.sh inside Docker

If you use Docker to run Minecraft Bedrock Server from a Linux image (e.g. [itzg/minecraft-bedrock-server](https://github.com/itzg/minecraft-bedrock-server)), then this script will probably *just work*.

I use [itzg/minecraft-bedrock-server](https://github.com/itzg/minecraft-bedrock-server) to run Minecraft Bedrock.

In the following example, I demonstrate using `/data` and `/addons` for a live server.

```bash
docker run --rm \
    --name minecraft \
    -e EULA=TRUE \
    -p 19132:19132/udp \
    -p 19132:19132/tcp \
    -v minecraft-data:/data \
    -v minecraft-addons:/addons \
    itzg/minecraft-bedrock-server
```

Copy `mc.sh` to `/addons` and invoke it inside the minecraft bedrock server container.

## Example

The following example adds [camouflage-doors](https://www.curseforge.com/minecraft-bedrock/addons/camouflage-door-addon) to a world called `my-cool-world` which is served from the docker container called `minecraft-red`.

```bash
docker exec -it minecraft-red /addons/mc.sh enable resource camouflage-doors my-cool-world
```
