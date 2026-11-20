# OpenClaw on GitHub Codespaces (private test setup)

This is a no-Render-billing test path for the existing repository. It does **not** provide an always-on server.

## Start it

1. Open this repository on GitHub.
2. Choose **Code → Codespaces → Create codespace on codespaces-gateway**.
3. Wait for the Codespace to finish creating. The devcontainer installs the OpenClaw CLI and starts the Gateway.
4. In the Codespaces **Ports** tab, open port **18789**. It is configured as **Private**, so it is not intentionally public to everyone.
5. The Gateway token is stored in `~/.openclaw/codespaces-gateway-token`. Read it in the Codespaces terminal with:
   ```sh
   cat ~/.openclaw/codespaces-gateway-token
   ```
6. Paste that token into the OpenClaw Control UI when prompted.

## Important limits

- GitHub Codespaces usage is subject to the account's included quota and any applicable billing settings. This setup does not guarantee unlimited free use.
- A stopped or deleted Codespace is not an always-on Gateway. The Gateway is unavailable while the Codespace is stopped.
- OpenClaw can start without a model provider using `--allow-unconfigured`, but it will not generate AI answers until a supported model provider is configured.
- Do not change port 18789 visibility to Public. Keep the Gateway token private and never commit it to GitHub.
- This test setup does not change the existing Render deployment files.

## Troubleshooting

Check the startup log:

```sh
tail -n 100 ~/openclaw-gateway.log
```

Restart the Gateway by stopping the running process in the terminal and running:

```sh
bash .devcontainer/start-gateway.sh
```
