<table width="900px" align="center">
    <tbody>
        <tr valign="top">
            <td width="300px" align="center">
            <span><strong>Twitter</strong></span><br><br />
            <a href="https://twitter.com/bccnodes" target="_blank" rel="noopener noreferrer">
            <img height="70px" src="https://github.com/berkcaNode/berkcaNode/blob/main/twitter.png">
            </td>
            <td width="300px" align="center">
            <span><strong>Website</strong></span><br><br />
            <a href="https://bccnodes.net/" target="_blank" rel="noopener noreferrer">
            <img height="70px" src="https://github.com/berkcaNode/berkcaNode/blob/main/web.png">
            </td>
            <td width="300px" align="center">
            <span><strong>BccNodes Explorer</strong></span><br><br />
            <a href="https://explorer.bccnodes.com/" target="_blank" rel="noopener noreferrer">
            <img height="70px" src="https://github.com/berkcaNode/berkcaNode/blob/main/exp%20(1).png">
            </td>
        </tr>
    </tbody>
</table>

# Chain4Energy Mainnet Manuel node kurulumu

<p align="center">
  <img height="220" height="auto" src="c4e.png">
</p>

C4E Discord:
>- [Discord](https://discord.gg/chain4energy)

Explorer:
>- https://explorer.bccnodes.com/chain4energy

## Sistem Gereksinimleri

| Node Tipi | CPU |  RAM  | Depolama  |     OS       | GO Version|
|-----------|-----|-------|-----------|--------------|-----------|
| Testnet   |  4  | 16GB  |   300GB   | Ubuntu 20.04 | Go v1.19.1|

## Gerekli güncellemeleri ve araçları kurunuz
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt-get install make build-essential gcc git jq chrony screen -y
```
## Go yükleyin (tek komut)
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.19.1"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
  source $HOME/.bash_profile
fi
```
>> `go version` çıktısı `go version go1.19.1 linux/amd64` olmalıdır

## Moniker ismimizi atayalım
```
NODENAME=<MONIKER_ISMINIZI_GİRİN>
```

## Github reposunun bir kopyasını oluşturun ve kurun
```
git clone --depth 1 --branch  v1.0.1  https://github.com/chain4energy/c4e-chain.git
cd c4e-chain
make install

```

## Versiyonu kontrol edelim; v1.0.1 olmalı
```
c4ed version
```

## Nodeu çalıştırmaya hazırlanalım
```
c4ed config keyring-backend test
c4ed config chain-id perun-1
c4ed init $NODENAME --chain-id perun-1
c4ed config node tcp://localhost:26657
```
Cüzdan oluşturalım veya var olan cüzdanı geri getirelim

```c4ed keys add CÜZDANİSMİ```             #Yeni oluşturmak için

``` c4ed keys add CÜZDANİSMİ --recover ``` #Cüzdan kelimlerinizi kullanarak geri getirmek için



## Genesis ve addrbook yükleyelim
```
wget https://raw.githubusercontent.com/chain4energy/c4e-chains/main/perun-1/genesis.json -O $HOME/.c4e-chain/config/genesis.json
wget https://snapshots.nodestake.top/c4e/addrbook.json -O $HOME/.c4e-chain/config/addrbook.json

```

## Peers ayarlayalım
```
peers="96b621f209eb2244e6b0976a8918e1f6536d9a3d@34.208.153.193:26656,c1bfac5b59966c2fc97d48540b9614f34785fbf3@57.128.144.137:26656,f5d50df79f2aa5a9d18576147f59b8807347b6f9@66.70.178.78:26656,85acd1e5580c950f5ede07c3da4bd814d42cf323@95.179.190.59:26656,fe9a629d1bb3e1e958b2013b6747e3dbbd7ba8d3@149.102.130.176:26656,37f3f290c59dcce9109ac828e9839dc9c22be718@188.34.134.24:26656,bb9cbee9c391f5b0744d5da0ea1abc17ed0ca1b2@159.69.56.25:26656,2f6141859c28c088514b46f7783509aeeb87553f@141.94.193.12:11656"

sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" ~/.c4e-chain/config/config.toml
```

## Minimum gas değerini ayarlayalım
```
sed -i 's|^minimum-gas-prices *=.*|minimum-gas-prices = "0.0001uc4e"|g' $HOME/.c4e-chain/config/app.toml
```

## Pruning Yapılandıralım ( İsteğe bağlı)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.c4e-chain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.c4e-chain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.c4e-chain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.c4e-chain/config/app.toml
```
## Indexer'ı devre dışı bırakalım ( İsteğe bağlı)
```
indexer="null"
sed -i -e "s/^indexer *=.*/indexer = \"$indexer\"/" $HOME/.c4e-chain/config/config.toml
```

## Zincir verilerini sıfırlayalım
```
c4ed tendermint unsafe-reset-all --home $HOME/.c4e-chain
```


## Servis Oluşturalım
```
sudo tee  /etc/systemd/system/c4ed.service /dev/null <<EOF
[Unit]
Description=c4ed
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=$(which c4ed) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Nodeu Başlatalım
```
sudo systemctl daemon-reload && systemctl enable c4ed
sudo systemctl restart c4ed && journalctl -o cat -fu c4ed
```
## Senkronizasyon durumunu kotnrol edelim ve çıktı false olduğunda discrod kanalından token alıp validator oluşturalım
```
c4ed status 2>&1 | jq .SyncInfo
```

## Validator Oluşturalım
>> Cüzdan bakiyesini kontrol etmek için; `uptickd query bank balances CÜZDANADRESİNİZ`
```
c4ed tx staking create-validator \
  --amount 1999000uc4e \
  --from wallet \
  --commission-max-change-rate "0.01" \
  --commission-max-rate "0.2" \
  --commission-rate "0.07" \
  --min-self-delegation "1" \
  --pubkey  $(c4ed tendermint show-validator) \
  --moniker $NODENAME \
  --chain-id perun-1 \
  --fees 250uc4e
```

### İşe yarar komutlar
Logları kontrol et
```
journalctl -fu c4ed -o cat
```

Servisi başlat
```
sudo systemctl start c4ed
```

Servisi durdur
```
sudo systemctl stop c4ed
```

Servisi yeniden başlat
```
sudo systemctl restart c4ed
```
Delegate stake
```
c4ed tx staking delegate $(c4ed keys show wallet --bech val -a) 10000000uc4e --from=wallet --chain-id=perun-1 --gas=auto
```

# BccNodes API && RPC && STATE-SYNC && ADDRBOOK 

### Endpoints:
>- [BccNodes API endpoint](https://c4e.api.bccnodes.com/)

>- [BccNodes RPC endpoint](https://c4e.rpc.bccnodes.com/)

>- [BccNodes gRPC endpoint](https://c4e.grpc.bccnodes.com:20090)

### State Sync 

```
NA
```

### Addrbook
```
wget -O $HOME/.c4e-chain/config/addrbook.json "https://raw.githubusercontent.com/BccNodes/Testnet-Guides/main/Chain4Energy%20Mainnet/addrbook.json"

```

