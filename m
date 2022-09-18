Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C125BBD0D
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiIRJuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiIRJt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:58 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6390D1261A
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:51 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjdM6RJczpSv8;
        Sun, 18 Sep 2022 17:47:03 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:49 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 17/55] treewide: adjust features initialization
Date:   Sun, 18 Sep 2022 09:42:58 +0000
Message-ID: <20220918094336.28958-18-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are many direclty assignment to netdev features with singe
feature bit. Replace them as to two expressions, one to reset
them to empty, one to set the feature bit.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/firewire/net.c                              | 4 +++-
 drivers/misc/sgi-xp/xpnet.c                         | 3 ++-
 drivers/net/can/dev/dev.c                           | 4 +++-
 drivers/net/ethernet/alacritech/slicoss.c           | 4 +++-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c     | 3 ++-
 drivers/net/ethernet/atheros/atlx/atl2.c            | 4 +++-
 drivers/net/ethernet/cadence/macb_main.c            | 3 ++-
 drivers/net/ethernet/engleder/tsnep_main.c          | 4 +++-
 drivers/net/ethernet/ibm/ibmveth.c                  | 3 ++-
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 +++-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c      | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 3 ++-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 6 ++++--
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c   | 3 ++-
 drivers/net/ethernet/ni/nixge.c                     | 4 +++-
 drivers/net/ethernet/renesas/sh_eth.c               | 6 ++++--
 drivers/net/ethernet/toshiba/ps3_gelic_net.c        | 3 ++-
 drivers/net/ethernet/tundra/tsi108_eth.c            | 3 ++-
 drivers/net/ethernet/xilinx/ll_temac_main.c         | 4 +++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c   | 4 +++-
 drivers/net/hamradio/bpqether.c                     | 4 +++-
 drivers/net/hyperv/netvsc_drv.c                     | 3 ++-
 drivers/net/ipa/ipa_modem.c                         | 4 +++-
 drivers/net/ntb_netdev.c                            | 4 +++-
 drivers/net/rionet.c                                | 4 +++-
 drivers/net/tap.c                                   | 2 +-
 drivers/net/virtio_net.c                            | 3 ++-
 drivers/net/wireless/ath/ath10k/mac.c               | 7 +++++--
 drivers/net/wireless/ath/ath11k/mac.c               | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c    | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c    | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c    | 4 +++-
 drivers/net/wwan/t7xx/t7xx_netdev.c                 | 4 +++-
 drivers/s390/net/qeth_core_main.c                   | 9 +++++++--
 include/net/udp.h                                   | 5 ++++-
 net/phonet/pep-gprs.c                               | 4 +++-
 36 files changed, 104 insertions(+), 40 deletions(-)

diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index af22be84034b..f13e72d1bdc6 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -24,6 +24,7 @@
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -1374,7 +1375,8 @@ static void fwnet_init_dev(struct net_device *net)
 	net->netdev_ops		= &fwnet_netdev_ops;
 	net->watchdog_timeo	= 2 * HZ;
 	net->flags		= IFF_BROADCAST | IFF_MULTICAST;
-	net->features		= NETIF_F_HIGHDMA;
+	netdev_active_features_zero(net);
+	net->features		|= NETIF_F_HIGHDMA;
 	net->addr_len		= FWNET_ALEN;
 	net->hard_header_len	= FWNET_HLEN;
 	net->type		= ARPHRD_IEEE1394;
diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 2396ba3b03bd..665e4cb5adbd 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -568,7 +568,8 @@ xpnet_init(void)
 	 * report an error if the data is not retrievable and the
 	 * packet will be dropped.
 	 */
-	xpnet_device->features = NETIF_F_HW_CSUM;
+	netdev_active_features_zero(xpnet_device);
+	xpnet_device->features |= NETIF_F_HW_CSUM;
 
 	result = register_netdev(xpnet_device);
 	if (result != 0) {
diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index c1956b1e9faf..b571c4aff3b5 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_arp.h>
 #include <linux/workqueue.h>
 #include <linux/can.h>
@@ -221,7 +222,8 @@ void can_setup(struct net_device *dev)
 
 	/* New-style flags. */
 	dev->flags = IFF_NOARP;
-	dev->features = NETIF_F_HW_CSUM;
+	netdev_active_features_zero(dev);
+	dev->features |= NETIF_F_HW_CSUM;
 }
 
 /* Allocate and setup space for the CAN network device */
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index 4cea61f16be3..54db3f827745 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/if_ether.h>
 #include <linux/crc32.h>
@@ -1778,7 +1779,8 @@ static int slic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	pci_set_drvdata(pdev, dev);
 	dev->irq = pdev->irq;
 	dev->netdev_ops = &slic_netdev_ops;
-	dev->hw_features = NETIF_F_RXCSUM;
+	netdev_hw_features_zero(dev);
+	dev->hw_features |= NETIF_F_RXCSUM;
 	dev->features |= dev->hw_features;
 
 	dev->ethtool_ops = &slic_ethtool_ops;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index d678db5bce42..3e7afde26d4c 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -378,7 +378,8 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 				     NETIF_F_RXCSUM_BIT, NETIF_F_RXHASH_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_LRO_BIT,
 				     NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
-	self->ndev->gso_partial_features = NETIF_F_GSO_UDP_L4;
+	netdev_gso_partial_features_zero(self->ndev);
+	self->ndev->gso_partial_features |= NETIF_F_GSO_UDP_L4;
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index a699a7b5e242..dca59c1943fe 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -22,6 +22,7 @@
 #include <linux/mii.h>
 #include <linux/net.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/pm.h>
@@ -1389,7 +1390,8 @@ static int atl2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_sw_init;
 
-	netdev->hw_features = NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
 	netdev->features |= netdev_ctag_vlan_offload_features;
 
 	/* Init PHY as early as possible due to power saving issue  */
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 009e8d098cf7..138f385887b5 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4052,7 +4052,8 @@ static int macb_init(struct platform_device *pdev)
 	}
 
 	/* Set features */
-	dev->hw_features = NETIF_F_SG;
+	netdev_hw_features_zero(dev);
+	dev->hw_features |= NETIF_F_SG;
 
 	/* Check LSO capability */
 	if (GEM_BFEXT(PBUF_LSO, gem_readl(bp, DCFG6)))
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index bed01cc80b20..f454f7f9a0c5 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -24,6 +24,7 @@
 #include <linux/of_mdio.h>
 #include <linux/interrupt.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/phy.h>
 #include <linux/iopoll.h>
 
@@ -1281,7 +1282,8 @@ static int tsnep_probe(struct platform_device *pdev)
 
 	netdev->netdev_ops = &tsnep_netdev_ops;
 	netdev->ethtool_ops = &tsnep_ethtool_ops;
-	netdev->features = NETIF_F_SG;
+	netdev_active_features_zero(netdev);
+	netdev->features |= NETIF_F_SG;
 	netdev->hw_features = netdev->features;
 	netdev->hw_features |= NETIF_F_LOOPBACK;
 
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 7beb7b168dae..f8802bb1e117 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1679,7 +1679,8 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->netdev_ops = &ibmveth_netdev_ops;
 	netdev->ethtool_ops = &netdev_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->dev);
-	netdev->hw_features = NETIF_F_SG;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_SG;
 	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL)
 		netdev_hw_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
 					   NETIF_F_IPV6_CSUM_BIT,
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 97f080c66dd4..f9c945ecb133 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -10,6 +10,7 @@
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/vmalloc.h>
@@ -1064,7 +1065,8 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	octep_set_ethtool_ops(netdev);
 	netif_carrier_off(netdev);
 
-	netdev->hw_features = NETIF_F_SG;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_SG;
 	netdev->features |= netdev->hw_features;
 	netdev->min_mtu = OCTEP_MIN_MTU;
 	netdev->max_mtu = OCTEP_MAX_MTU;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 900d1543645b..1b224f28f1f1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3337,7 +3337,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		netdev_active_features_set_set(dev, NETIF_F_GSO_UDP_TUNNEL_BIT,
 					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
 					       NETIF_F_GSO_PARTIAL_BIT);
-		dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_gso_partial_features_zero(dev);
+		dev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev_hw_enc_features_zero(dev);
 		netdev_hw_enc_features_set_set(dev, NETIF_F_IP_CSUM_BIT,
 					       NETIF_F_IPV6_CSUM_BIT,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 42dc65abfcd7..a73d730ad55d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4925,7 +4925,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 		netdev_hw_enc_features_set_set(netdev,
 					       NETIF_F_GSO_UDP_TUNNEL_BIT,
 					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
-		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_gso_partial_features_zero(netdev);
+		netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev_vlan_features_set_set(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT,
 					     NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 3faf52d7b1d8..befbb4ed1152 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2355,7 +2355,8 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	if (nn->cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	netdev->hw_features = NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_HIGHDMA;
 	if (nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY) {
 		netdev->hw_features |= NETIF_F_RXCSUM;
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
@@ -2382,7 +2383,8 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 						   NETIF_F_GSO_UDP_TUNNEL_BIT,
 						   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
 						   NETIF_F_GSO_PARTIAL_BIT);
-			netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_gso_partial_features_zero(netdev);
+			netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		}
 		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_VXLAN;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index def04c617c0f..75a3ad2bc241 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -345,7 +345,8 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	if (repr_cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	netdev->hw_features = NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_HIGHDMA;
 	if (repr_cap & NFP_NET_CFG_CTRL_RXCSUM_ANY)
 		netdev->hw_features |= NETIF_F_RXCSUM;
 	if (repr_cap & NFP_NET_CFG_CTRL_TXCSUM)
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index cf2929fa525e..e72d43de2b5c 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -7,6 +7,7 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of_address.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
@@ -1274,7 +1275,8 @@ static int nixge_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
-	ndev->features = NETIF_F_SG;
+	netdev_active_features_zero(ndev);
+	ndev->features |= NETIF_F_SG;
 	ndev->netdev_ops = &nixge_netdev_ops;
 	ndev->ethtool_ops = &nixge_ethtool_ops;
 
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 67ade78fb767..e650e83ffae1 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/mdio-bitbang.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
@@ -3291,8 +3292,9 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	ndev->min_mtu = ETH_MIN_MTU;
 
 	if (mdp->cd->rx_csum) {
-		ndev->features = NETIF_F_RXCSUM;
-		ndev->hw_features = NETIF_F_RXCSUM;
+		netdev_active_features_zero(ndev);
+		ndev->features |= NETIF_F_RXCSUM;
+		ndev->hw_features = ndev->features;
 	}
 
 	/* set function */
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 9e9eb2f4efda..4b00ff0760f7 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1465,7 +1465,8 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 	netdev_hw_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
 				   NETIF_F_RXCSUM_BIT);
 
-	netdev->features = NETIF_F_IP_CSUM;
+	netdev_active_features_zero(netdev);
+	netdev->features |= NETIF_F_IP_CSUM;
 	if (GELIC_CARD_RX_CSUM_DEFAULT)
 		netdev->features |= NETIF_F_RXCSUM;
 
diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 5251fc324221..785f4f3bd0ee 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1610,7 +1610,8 @@ tsi108_init_one(struct platform_device *pdev)
 	 * a new function skb_csum_dev() in net/core/skbuff.c).
 	 */
 
-	dev->features = NETIF_F_HIGHDMA;
+	netdev_active_features_zero(dev);
+	dev->features |= NETIF_F_HIGHDMA;
 
 	spin_lock_init(&data->txlock);
 	spin_lock_init(&data->misclock);
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 3f6b9dfca095..5ea65e482bc1 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_ether.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -1395,7 +1396,8 @@ static int temac_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-	ndev->features = NETIF_F_SG;
+	netdev_active_features_zero(ndev);
+	ndev->features |= NETIF_F_SG;
 	ndev->netdev_ops = &temac_netdev_ops;
 	ndev->ethtool_ops = &temac_ethtool_ops;
 #if 0
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9fde5941a469..1a8c17e18977 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -27,6 +27,7 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
@@ -1861,7 +1862,8 @@ static int axienet_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG;
+	netdev_active_features_zero(ndev);
+	ndev->features |= NETIF_F_SG;
 	ndev->netdev_ops = &axienet_netdev_ops;
 	ndev->ethtool_ops = &axienet_ethtool_ops;
 
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 30af0081e2be..6151308474df 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -60,6 +60,7 @@
 #include <net/ax25.h>
 #include <linux/inet.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
@@ -458,7 +459,8 @@ static void bpq_setup(struct net_device *dev)
 	dev->needs_free_netdev = true;
 
 	dev->flags      = 0;
-	dev->features	= NETIF_F_LLTX;	/* Allow recursion */
+	netdev_active_features_zero(dev);
+	dev->features	|= NETIF_F_LLTX;	/* Allow recursion */
 
 #if IS_ENABLED(CONFIG_AX25)
 	dev->header_ops      = &ax25_header_ops;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f438a98cd2f4..c19f659dbb4c 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1165,7 +1165,8 @@ static void netvsc_init_settings(struct net_device *dev)
 	ndc->speed = SPEED_UNKNOWN;
 	ndc->duplex = DUPLEX_FULL;
 
-	dev->features = NETIF_F_LRO;
+	netdev_active_features_zero(dev);
+	dev->features |= NETIF_F_LRO;
 }
 
 static int netvsc_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index c8b1c4d9c507..92b19130db17 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -7,6 +7,7 @@
 #include <linux/errno.h>
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/skbuff.h>
 #include <linux/if_rmnet.h>
 #include <linux/etherdevice.h>
@@ -223,7 +224,8 @@ static void ipa_modem_netdev_setup(struct net_device *netdev)
 	netdev->needed_headroom = sizeof(struct rmnet_map_header);
 	netdev->needed_tailroom = IPA_NETDEV_TAILROOM;
 	netdev->watchdog_timeo = IPA_NETDEV_TIMEOUT * HZ;
-	netdev->hw_features = NETIF_F_SG;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_SG;
 }
 
 /** ipa_modem_suspend() - suspend callback
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 464d88ca8ab0..99a59be05310 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -50,6 +50,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/module.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/pci.h>
 #include <linux/ntb.h>
 #include <linux/ntb_transport.h>
@@ -420,7 +421,8 @@ static int ntb_netdev_probe(struct device *client_dev)
 	dev = netdev_priv(ndev);
 	dev->ndev = ndev;
 	dev->pdev = pdev;
-	ndev->features = NETIF_F_HIGHDMA;
+	netdev_active_features_zero(ndev);
+	ndev->features |= NETIF_F_HIGHDMA;
 
 	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index fbcb9d05da64..cc854ef32160 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -16,6 +16,7 @@
 #include <linux/rio_ids.h>
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/crc32.h>
@@ -515,7 +516,8 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 	/* MTU range: 68 - 4082 */
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = RIONET_MAX_MTU;
-	ndev->features = NETIF_F_LLTX;
+	netdev_active_features_zero(ndev);
+	ndev->features |= NETIF_F_LLTX;
 	SET_NETDEV_DEV(ndev, &mport->dev);
 	ndev->ethtool_ops = &rionet_ethtool_ops;
 
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index abd499a8f289..ae374e68dcc7 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -949,7 +949,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	features = tap->dev->features;
 
 	if (arg & TUN_F_CSUM) {
-		feature_mask = NETIF_F_HW_CSUM;
+		feature_mask |= NETIF_F_HW_CSUM;
 
 		if (arg & (TUN_F_TSO4 | TUN_F_TSO6)) {
 			if (arg & TUN_F_TSO_ECN)
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4423073021e5..c8c520953ef0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3712,7 +3712,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
 			   IFF_TX_SKB_NO_LINEAR;
 	dev->netdev_ops = &virtnet_netdev;
-	dev->features = NETIF_F_HIGHDMA;
+	netdev_active_features_zero(dev);
+	dev->features |= NETIF_F_HIGHDMA;
 
 	dev->ethtool_ops = &virtnet_ethtool_ops;
 	SET_NETDEV_DEV(dev, &vdev->dev);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 23381a9db6ae..d15d0588362a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -13,6 +13,7 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/bitfield.h>
+#include <linux/netdev_feature_helpers.h>
 
 #include "hif.h"
 #include "core.h"
@@ -10214,8 +10215,10 @@ int ath10k_mac_register(struct ath10k *ar)
 	if (ar->hw_params.dynamic_sar_support)
 		ar->hw->wiphy->sar_capa = &ath10k_sar_capa;
 
-	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
-		ar->hw->netdev_features = NETIF_F_HW_CSUM;
+	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		netdev_features_zero(ar->hw->netdev_features);
+		ar->hw->netdev_features |= NETIF_F_HW_CSUM;
+	}
 
 	if (IS_ENABLED(CONFIG_ATH10K_DFS_CERTIFIED)) {
 		/* Init ath dfs pattern detector */
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 7e91e347c9ff..fe8b61c8ad70 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/bitfield.h>
 #include <linux/inetdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/if_inet6.h>
 #include <net/ipv6.h>
 
@@ -8895,7 +8896,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ath11k_reg_init(ar);
 
 	if (!test_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags)) {
-		ar->hw->netdev_features = NETIF_F_HW_CSUM;
+		netdev_features_zero(ar->hw->netdev_features);
+		ar->hw->netdev_features |= NETIF_F_HW_CSUM;
 		ieee80211_hw_set(ar->hw, SW_CRYPTO_CONTROL);
 		ieee80211_hw_set(ar->hw, SUPPORT_FAST_XMIT);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 07a1fea94f66..031feef1f19f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -10,6 +10,7 @@
 #include <linux/etherdevice.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/netdev_feature_helpers.h>
 #include "mt7615.h"
 #include "mac.h"
 #include "mcu.h"
@@ -366,7 +367,8 @@ mt7615_init_wiphy(struct ieee80211_hw *hw)
 	hw->max_rates = 3;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 11;
-	hw->netdev_features = NETIF_F_RXCSUM;
+	netdev_features_zero(hw->netdev_features);
+	hw->netdev_features |= NETIF_F_RXCSUM;
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index cc2aac86bcfb..243d06f2cb0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -4,6 +4,7 @@
 #include <linux/etherdevice.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/thermal.h>
 #include "mt7915.h"
 #include "mac.h"
@@ -329,7 +330,8 @@ mt7915_init_wiphy(struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
-	hw->netdev_features = NETIF_F_RXCSUM;
+	netdev_features_zero(hw->netdev_features);
+	hw->netdev_features |= NETIF_F_RXCSUM;
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index cd960e23770f..8335cef92528 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2020 MediaTek Inc. */
 
 #include <linux/etherdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include "mt7921.h"
 #include "mac.h"
 #include "mcu.h"
@@ -54,7 +55,8 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
-	hw->netdev_features = NETIF_F_RXCSUM;
+	netdev_features_zero(hw->netdev_features);
+	hw->netdev_features |= NETIF_F_RXCSUM;
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index c6b6547f2c6f..c68ec3f186df 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
@@ -172,7 +173,8 @@ static void t7xx_ccmni_wwan_setup(struct net_device *dev)
 
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 
-	dev->features = NETIF_F_VLAN_CHALLENGED;
+	netdev_active_features_zero(dev);
+	dev->features |= NETIF_F_VLAN_CHALLENGED;
 
 	dev->features |= NETIF_F_SG;
 	dev->hw_features |= NETIF_F_SG;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 65b9c10c1a08..7307f08e6688 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6765,8 +6765,13 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 					   netdev_features_t changed,
 					   netdev_features_t actual)
 {
-	netdev_features_t ipv6_features = NETIF_F_TSO6;
-	netdev_features_t ipv4_features = NETIF_F_TSO;
+	netdev_features_t ipv6_features;
+	netdev_features_t ipv4_features;
+
+	netdev_features_zero(ipv6_features);
+	netdev_features_zero(ipv4_features);
+	ipv6_features |= NETIF_F_TSO6;
+	ipv4_features |= NETIF_F_TSO;
 
 	if (!card->info.has_lp2lp_cso_v6)
 		ipv6_features |= NETIF_F_IPV6_CSUM;
diff --git a/include/net/udp.h b/include/net/udp.h
index 13887234a241..0fdf944b3675 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -457,9 +457,12 @@ void udpv6_encap_enable(void);
 static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 					      struct sk_buff *skb, bool ipv4)
 {
-	netdev_features_t features = NETIF_F_SG;
+	netdev_features_t features;
 	struct sk_buff *segs;
 
+	netdev_features_zero(features);
+	features |= NETIF_F_SG;
+
 	/* Avoid csum recalculation by skb_segment unless userspace explicitly
 	 * asks for the final checksum values
 	 */
diff --git a/net/phonet/pep-gprs.c b/net/phonet/pep-gprs.c
index 1f5df0432d37..954bad64a451 100644
--- a/net/phonet/pep-gprs.c
+++ b/net/phonet/pep-gprs.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_ether.h>
 #include <linux/if_arp.h>
 #include <net/sock.h>
@@ -212,7 +213,8 @@ static const struct net_device_ops gprs_netdev_ops = {
 
 static void gprs_setup(struct net_device *dev)
 {
-	dev->features		= NETIF_F_FRAGLIST;
+	netdev_active_features_zero(dev);
+	dev->features		|= NETIF_F_FRAGLIST;
 	dev->type		= ARPHRD_PHONET_PIPE;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
 	dev->mtu		= GPRS_DEFAULT_MTU;
-- 
2.33.0

