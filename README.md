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
