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
            <a href="https://bccnodes.com/" target="_blank" rel="noopener noreferrer">
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

# Nibiru Chain Manuel node kurulumu

<p align="center">
  <img height="220" height="auto" src="nibiru.png">
</p>

Orijinal Döküman:
>- [Doğrulayıcı kurulum talimatları](https://docs.nibiru.fi/run-nodes/validators/)

Explorer:
>- https://explorer.bccnodes.com/nibiru

## Sistem Gereksinimleri
```
4 CPU 8 RAM 100 GB
```

## Gerekli güncellemeleri ve araçları kurunuz
```
sudo apt update && sudo apt upgrade -y
```
```
sudo apt install curl build-essential git wget jq make gcc tmux chrony -y
```
## Go yükleyin (tek komut)
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.2"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```
## Moniker ismimizi atayalım
```
NODENAME=<MONIKER_ISMINIZI_GİRİN>
```

## Github reposunun bir kopyasını oluşturun ve kurun
```
cd $HOME
git clone https://github.com/NibiruChain/nibiru.git
cd nibiru
git checkout v0.15.0
make install
```

## Versiyonu kontrol edelim; v0.15.0 olmalı
```
nibid version
```

## Nodeu çalıştırmaya hazırlanalım
```
nibid config keyring-backend test
nibid config chain-id nibiru-testnet-1
nibid init $NODENAME --chain-id nibiru-testnet-1
nibid config node tcp://localhost:26657


```
Cüzdan oluşturalım veya var olan cüzdanı geri getirelim

```nibid keys add CÜZDANİSMİ```             #Yeni oluşturmak için

``` nibid keys add CÜZDANİSMİ --recover ``` #Cüzdan kelimlerinizi kullanarak geri getirmek için



## Genesis ve addrbook yükleyelim
```
curl -s https://rpc.testnet-1.nibiru.fi/genesis | jq -r .result.genesis > genesis.json
cp genesis.json $HOME/.nibid/config/genesis.json
```

## Peers ayarlayalım
```
PEERS="5c30c7e8240f2c4108822020ae95d7b5da727e54@65.108.75.107:19656,0e74d23d31bde15e0706e1e4bf0e87c70ae75ec8@154.26.137.8:26656,da6cabfdbb17e1eb03ae3fbf9fab2f9444e2eec8@194.5.152.22:26656,eb3cefa339eea87f2b7ce6f64b1ebff273d10903@193.46.243.254:26656,833a4ce4b51c81bbbb41dad7ff9733080e8232e9@154.26.132.181:26656,5eecfdf089428a5a8e52d05d18aae1ad8503d14c@65.108.141.109:19656,cb3c8df3e1d8942de9908bc1e5bb371a5671c404@89.163.231.30:36656,6c36e166abed836e188c28bbec8d60b235def7d7@45.142.214.97:26656,095cc77588be94bc2988b4dba86bfb001ec925ff@135.181.111.204:26656,2fc98a228dee1826d67e8a2dbd553989118a49cc@5.9.22.14:60656,a4264e666b89f2a6ac59dbf4e33e23e9cbe8c51b@194.233.74.26:26656,ff597c3eea5fe832825586cce4ed00cb7798d4b5@65.109.53.53:26656,95514d97c9d0776478bee64353d986583a95c72e@185.135.137.193:26656,5e65a3d32678a7206d006f899be707c130a9ada1@162.55.234.70:55356,8641bef617e5b38290be2eee2ea031a36855c901@65.108.216.139:26656,722f2c0a8d0aaabbc3b8701d98ab9766686f63ac@95.216.142.94:36656,04dcccb784be8380a4849e32c3bbb9e8ea8b9a95@45.91.171.75:23656,3cc4ba658dde90f2276455bb64a4efb666e1bc22@38.242.224.226:46656,456c75e3d465d34a22a976afb17e96e85947de75@167.99.36.201:26656,7ddc65049ebdab36cef6ceb96af4f57af5804a88@77.37.176.99:16656,461254f281d96b7a78a8cb12de6190d3e79dadb0@88.99.13.85:26656,2dd0bc113f2f457effe3d0e091d80303fddf3c6a@161.35.16.147:46656,23a18fe03c6c1b0ccc7eb0d53716ef2ba5887fd3@194.5.152.200:26656,b6b0a2ed2d3101dd7ee4aef4aa00fa43d21e4b16@142.132.130.196:36656,3dbaa4a9b957ac296e197083d120f94112c45607@161.97.115.131:26656,efc3cb98f4033d230c971921b8f25b8ee1239b7c@14.29.132.178:26656,31b592b7b8e37af2a077c630a96851fe73b7386f@138.201.251.62:26656"


sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.nibid/config/config.toml
```

## Blok süresi parametrelerini ayarlayalım
```
 sed -i 's/timeout_propose =.*/timeout_propose = "100ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_propose_delta =.*/timeout_propose_delta = "500ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_prevote =.*/timeout_prevote = "100ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_prevote_delta =.*/timeout_prevote_delta = "500ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_precommit =.*/timeout_precommit = "100ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_precommit_delta =.*/timeout_precommit_delta = "500ms"/g' $HOME/.nibid/config/config.toml
 sed -i 's/timeout_commit =.*/timeout_commit = "1s"/g' $HOME/.nibid/config/config.toml
 sed -i 's/skip_timeout_commit =.*/skip_timeout_commit = false/g' $HOME/.nibid/config/config.toml
```

## Pruning Yapılandıralım ( İsteğe bağlı)
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.nibid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.nibid/config/app.toml
```

## Zincir verilerini sıfırlayalım
```
nibid tendermint unsafe-reset-all --home $HOME/.nibid
```


## Servis Oluşturalım
```
sudo tee /etc/systemd/system/nibid.service > /dev/null <<EOF
[Unit]
Description=nibid
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nibid) start --home $HOME/.nibid
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Nodeu Başlatalım
```
sudo systemctl daemon-reload
sudo systemctl enable nibid
sudo systemctl restart nibid && sudo journalctl -u nibid -f -o cat
```
## Senkronizasyon durumunu kotnrol edelim ve çıktı false olduğunda discrod kanalından token alıp validator oluşturalım
```
nibid status 2>&1 | jq .SyncInfo
```

## Validator Oluşturalım
>> Cüzdan bakiyesini kontrol etmek için; nibid query bank balances CÜZDANADRESİNİZ
```
nibid tx staking create-validator \
--chain-id nibiru-testnet-1 \
--commission-rate 0.05 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.1 \
--min-self-delegation "1000000" \
--amount 9000000unibi \
--pubkey $(nibid tendermint show-validator) \
--moniker "$NODENAME" \
--from wallet \
--fees 5000unibi
```

### İşe yarar komutlar
Logları kontrol et
```
journalctl -fu nibid -o cat
```

Servisi başlat
```
sudo systemctl start nibid
```

Servisi durdur
```
sudo systemctl stop nibid
```

Servisi yeniden başlat
```
sudo systemctl restart nibid
```
Delegate stake
```
nibid tx staking delegate $(nibid keys show wallet --bech val -a) 10000000unibi --from=wallet --chain-id=okp4-nemeton --gas=auto
```

# BccNodes API && RPC && STATE-SYNC

Endpoints:
>- [BccNodes API endpoint](https://nibiru.api.bccnodes.com/)

>- [BccNodes RPC endpoint](https://nibiru.rpc.bccnodes.com/)

### State Sync (NodeJumper'dan alıntıdır)

```
sudo systemctl stop nibid

cp $HOME/.nibid/data/priv_validator_state.json $HOME/.nibid/priv_validator_state.json.backup
nibid tendermint unsafe-reset-all --home $HOME/.nibid --keep-addr-book

SNAP_RPC="https://nibiru-testnet.nodejumper.io:443"

LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)

echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

peers="b32bb87364a52df3efcbe9eacc178c96b35c823a@nibiru-testnet.nodejumper.io:26656"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/.nibid/config/config.toml

sed -i -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.nibid/config/config.toml

mv $HOME/.nibid/priv_validator_state.json.backup $HOME/.nibid/data/priv_validator_state.json

sudo systemctl restart nibid
sudo journalctl -u nibid -f --no-hostname -o cat
```
