## Rehberlerim hakkında genel açıklama

<p align="center">
  <img height="190" height="auto" src="Ollo Testnet/port.PNG">
</p>
 
 Tüm rehberlerimde default portları kullanıyorum; 

`26656`
p2p networking port to connect to the tendermint network
On a validator this port needs to be exposed to sentry nodes
On a sentry node 68 this port needs to be exposed to the open internet
`26657`
Tendermint RPC port
This should be shielded from the open internet
`26658`
Out of process ABCI app
This should be shielded from the open internet
Some optional ports that might be used by gaiad are as follows:

`26660`
Prometheus 13 stats server
Stats about the gaiad process
Needs to be enabled in the config file 29.
This should be shielded from the open internet
`1317`
Light Client Daemon
For automated management of anything you can do with the CLI
This should be shielded from the open internet

Eğer resimdeki gibi Error: `failed to listen on 127.0.0.1:26657: listen tcp 127.0.0.1:26657: bind: address already in use` hatası alırsanız aşağıdaki komutta `.ollo` olan klasör ismini projeye göre düzenleyerek portları değiştirebilirsiniz, nodea restart attıktan sonra problem çözülecektir;

```
CUSTOM_PORT=10
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}660\"%" $HOME/.ollo/config/config.toml

sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}317\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}091\"%" $HOME/.ollo/config/app.toml
```
