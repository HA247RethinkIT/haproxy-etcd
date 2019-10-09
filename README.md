# haproxy-etcd for a Percona Galera Cluster in Docker

Simple proxy to load balance between 3 etcd containers named etcd1, etcd2 & etcd3 as described below

## To use in docker stack or docker compose
```yaml
services:

  haproxy-etcd:
    image: ha247/haproxy-etcd
    networks:
      - etcd
    deploy:
      replicas: 2
      update_config:
        parallelism: 1
        delay: 10s
        failure_action: rollback

  etcd1:
    image: quay.io/coreos/etcd:v3.3.13
    restart: always
    volumes:
      - etcd:/etcd-data
    deploy:
      mode: global
      placement:
        constraints: [ node.hostname == host1 ]
    environment:
      ETCD_NAME: node1
      ETCD_DATA_DIR: /etcd-data/etcd.etcd
      ETCDCTL_API: 3
      ETCD_DEBUG: 0
      ETCD_INITIAL_ADVERTISE_PEER_URLS: http://etcd1:2380
      ETCD_INITIAL_CLUSTER: node3=http://etcd3:2380,node1=http://etcd1:2380,node2=http://etcd2:2380
      ETCD_INITIAL_CLUSTER_STATE: new
      ETCD_INITIAL_CLUSTER_TOKEN: etcd-cluster
      ETCD_LISTEN_CLIENT_URLS: http://0.0.0.0:2379
      ETCD_LISTEN_PEER_URLS: http://0.0.0.0:2380
      ETCD_ADVERTISE_CLIENT_URLS: http://etcd1:2379
    networks:
      - etcd
  etcd2:
    image: quay.io/coreos/etcd:v3.3.13
    restart: always
    volumes:
      - etcd:/etcd-data
    deploy:
      mode: global
      placement:
        constraints: [ node.hostname == host2 ]
    environment:
      ETCD_NAME: node2
      ETCD_DATA_DIR: /etcd-data/etcd.etcd
      ETCDCTL_API: 3
      ETCD_DEBUG: 0
      ETCD_INITIAL_ADVERTISE_PEER_URLS: http://etcd2:2380
      ETCD_INITIAL_CLUSTER: node3=http://etcd3:2380,node1=http://etcd1:2380,node2=http://etcd2:2380
      ETCD_INITIAL_CLUSTER_STATE: new
      ETCD_INITIAL_CLUSTER_TOKEN: etcd-cluster
      ETCD_LISTEN_CLIENT_URLS: http://0.0.0.0:2379
      ETCD_LISTEN_PEER_URLS: http://0.0.0.0:2380
      ETCD_ADVERTISE_CLIENT_URLS: http://etcd2:2379
    networks:
      - etcd
  etcd3:
    image: quay.io/coreos/etcd:v3.3.13
    restart: always
    volumes:
      - etcd:/etcd-data
    deploy:
      mode: global
      placement:
        constraints: [ node.hostname == host3 ]
    environment:
      ETCD_NAME: node3
      ETCD_DATA_DIR: /etcd-data/etcd.etcd
      ETCDCTL_API: 3
      ETCD_DEBUG: 0
      ETCD_INITIAL_ADVERTISE_PEER_URLS: http://etcd3:2380
      ETCD_INITIAL_CLUSTER: node3=http://etcd3:2380,node1=http://etcd1:2380,node2=http://etcd2:2380
      ETCD_INITIAL_CLUSTER_STATE: new
      ETCD_INITIAL_CLUSTER_TOKEN: etcd-cluster
      ETCD_LISTEN_CLIENT_URLS: http://0.0.0.0:2379
      ETCD_LISTEN_PEER_URLS: http://0.0.0.0:2380
      ETCD_ADVERTISE_CLIENT_URLS: http://etcd3:2379
    networks:
      - etcd
```