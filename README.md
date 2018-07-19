# ruby-websocket

Ruby で WebSocket サーバーを実装する。

明確な要件がないため、機能としては `Ping-Pong` のみ。

## Usage
### Requirement
### Install
### Run

## Architecture

### フレームワーク／ライブラリ

WebSocket サーバーを実現するフレームワークやライブラリとしては、以下のものがある。

* [Rails の Action Cable](https://railsguides.jp/action_cable_overview.html)
* [EM-WebSocket](https://github.com/igrigorik/em-websocket)
* [faye-websocket](https://github.com/faye/faye-websocket-node)

`Rails` の `Action Cable` は「クライアント側の JavaScript フレームワークとサーバー側の Ruby フレームワークを同時に提供するフルスタックのフレームワーク」であるため、基本的に、クライアント側を自由に構成する（例えば、 Python 等により実装）ことができない。  
※ フレームワークの思想として、Web アプリケーションにおいて WebSocket を実装するのに最適化されているものと思料。

`EM-WebSocket` は古くからある `EventMachine` ベースのライブラリであるが、[継続的な開発が停止されている模様](https://github.com/igrigorik/em-websocket/releases)。

今回は `faye-websocket` を採用する。

### 可用性および耐障害性

WebSocket サーバーの可用性および耐障害性を担保するためには、サーバーを冗長構成にする必要がある。

WebSocket サーバーをスケールアウトできるようにするため、一斉配信するメッセージ等のステートを Redis に保存し、 Redis の Pub/Sub を利用して中継サーバーとして機能させる。

![WebSocket サーバーの冗長化](images/websocket-redundancy.svg "WebSocket サーバーの冗長化")

なお、GCP における Redis のマネージドサービスとして [Cloud Memorystore](https://cloud.google.com/memorystore/) がある（ただし、2018年7月時点ではベータ版）。 

### コンテナ化

環境に依存せず実行できるようにアプリケーションをコンテナ化する。

なお、現状はコンテナ実行時にサーバー証明書の発行を行うため、所定のドメインでアクセスされるサーバーでのみ実行可。[今後、対応予定](https://github.com/chronushadow/ruby-websocket/issues/4)

### WebSocket 通信の暗号化

[全体アーキテクチャ](https://github.com/chronushadow/ros-websocket)のとおり、今回は WebSocket サーバー内で SSL 認証を行う。

サーバー証明書の発行・インストール・更新を自動化すべく（ついでに無料で・・・）、[Let's Encrypt](https://letsencrypt.org/) を導入する。
コンテナ実行時、サーバー証明書を発行＆インストールしてから、WebSocket サーバーを起動して証明書を参照（SSL を有効化）する。
