Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B919958E54C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiHJDOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiHJDNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:51 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6264A81B3B
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:48 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgv24ThzjXkZ;
        Wed, 10 Aug 2022 11:10:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:46 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 17/36] treewide: adjust features initialization
Date:   Wed, 10 Aug 2022 11:06:05 +0800
Message-ID: <20220810030624.34711-18-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220810030624.34711-1-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are many direclty single bit assignment to netdev features.
Adjust these expressions, so can use netdev features helpers later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                       | 5 ++++-
 drivers/firewire/net.c                              | 4 +++-
 drivers/infiniband/hw/hfi1/vnic_main.c              | 4 +++-
 drivers/misc/sgi-xp/xpnet.c                         | 3 ++-
 drivers/net/can/dev/dev.c                           | 4 +++-
 drivers/net/ethernet/alacritech/slicoss.c           | 4 +++-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c            | 4 +++-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c     | 3 ++-
 drivers/net/ethernet/atheros/atlx/atl2.c            | 4 +++-
 drivers/net/ethernet/cadence/macb_main.c            | 4 +++-
 drivers/net/ethernet/davicom/dm9000.c               | 4 +++-
 drivers/net/ethernet/engleder/tsnep_main.c          | 4 +++-
 drivers/net/ethernet/ibm/ibmveth.c                  | 3 ++-
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 +++-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c      | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   | 4 +++-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 7 +++++--
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c   | 3 ++-
 drivers/net/ethernet/ni/nixge.c                     | 4 +++-
 drivers/net/ethernet/renesas/sh_eth.c               | 6 ++++--
 drivers/net/ethernet/sun/sunhme.c                   | 7 +++++--
 drivers/net/ethernet/toshiba/ps3_gelic_net.c        | 6 ++++--
 drivers/net/ethernet/toshiba/spider_net.c           | 3 ++-
 drivers/net/ethernet/tundra/tsi108_eth.c            | 3 ++-
 drivers/net/ethernet/xilinx/ll_temac_main.c         | 4 +++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c   | 4 +++-
 drivers/net/hamradio/bpqether.c                     | 4 +++-
 drivers/net/hyperv/netvsc_drv.c                     | 3 ++-
 drivers/net/ipa/ipa_modem.c                         | 4 +++-
 drivers/net/ntb_netdev.c                            | 4 +++-
 drivers/net/rionet.c                                | 4 +++-
 drivers/net/tap.c                                   | 2 +-
 drivers/net/thunderbolt.c                           | 3 ++-
 drivers/net/usb/smsc95xx.c                          | 4 +++-
 drivers/net/virtio_net.c                            | 4 +++-
 drivers/net/wireless/ath/ath10k/mac.c               | 7 +++++--
 drivers/net/wireless/ath/ath11k/mac.c               | 4 +++-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c   | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c   | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c    | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c    | 4 +++-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c    | 4 +++-
 drivers/net/wwan/t7xx/t7xx_netdev.c                 | 4 +++-
 drivers/s390/net/qeth_core_main.c                   | 7 +++++--
 include/net/udp.h                                   | 4 +++-
 net/phonet/pep-gprs.c                               | 4 +++-
 46 files changed, 138 insertions(+), 52 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 1d59522a50d8..d797758850e1 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1628,7 +1628,10 @@ static void vector_eth_configure(
 		.bpf			= NULL
 	});
 
-	dev->features = dev->hw_features = (NETIF_F_SG | NETIF_F_FRAGLIST);
+	netdev_active_features_zero(dev);
+	dev->features |= NETIF_F_SG;
+	dev->features |= NETIF_F_FRAGLIST;
+	dev->features = dev->hw_features;
 	INIT_WORK(&vp->reset_tx, vector_reset_tx);
 
 	timer_setup(&vp->tl, vector_timer_expire, 0);
diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index af22be84034b..e73c8793599b 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -24,6 +24,7 @@
 #include <linux/moduleparam.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index 3650fababf25..52f805909ce3 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -588,7 +588,9 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
 	rn->free_rdma_netdev = hfi1_vnic_free_rn;
 	rn->set_id = hfi1_vnic_set_vesw_id;
 
-	netdev->features = NETIF_F_HIGHDMA | NETIF_F_SG;
+	netdev_active_features_zero(netdev);
+	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->features |= NETIF_F_SG;
 	netdev->hw_features = netdev->features;
 	netdev->vlan_features = netdev->features;
 	netdev->watchdog_timeo = msecs_to_jiffies(HFI_TX_TIMEOUT_MS);
diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 50644f83e78c..8547652c7b59 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -569,7 +569,8 @@ xpnet_init(void)
 	 * report an error if the data is not retrievable and the
 	 * packet will be dropped.
 	 */
-	xpnet_device->features = NETIF_F_HW_CSUM;
+	netdev_active_features_zero(xpnet_device);
+	xpnet_device->features |= NETIF_F_HW_CSUM;
 
 	result = register_netdev(xpnet_device);
 	if (result != 0) {
diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index c1956b1e9faf..4243e65b2c68 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
index ce353b0c02a3..a52e3bc855e4 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index ce0e2fa3eb63..eb0b205b49af 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -121,6 +121,7 @@
 #include <linux/interrupt.h>
 #include <linux/clk.h>
 #include <linux/if_ether.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <net/vxlan.h>
@@ -2183,7 +2184,8 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	netdev_features_t vxlan_base;
 
-	vxlan_base = NETIF_F_GSO_UDP_TUNNEL;
+	netdev_features_zero(&vxlan_base);
+	vxlan_base |= NETIF_F_GSO_UDP_TUNNEL;
 	vxlan_base |= NETIF_F_RX_UDP_TUNNEL_PORT;
 
 	if (!pdata->hw_feat.vxn)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index a8de1fb20a3f..e2fe6f2507d3 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -386,7 +386,8 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	self->ndev->hw_features |= *aq_hw_caps->hw_features;
 	self->ndev->features = *aq_hw_caps->hw_features;
 	netdev_vlan_features_set_array(self->ndev, &aq_nic_vlan_feature_set);
-	self->ndev->gso_partial_features = NETIF_F_GSO_UDP_L4;
+	netdev_gso_partial_features_zero(self->ndev);
+	self->ndev->gso_partial_features |= NETIF_F_GSO_UDP_L4;
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 1d647c4d1d44..15df55325aae 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -22,6 +22,7 @@
 #include <linux/mii.h>
 #include <linux/net.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
index 4cac5e3a1929..1f84d3bc42c9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -21,6 +21,7 @@
 #include <linux/gpio/consumer.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
@@ -4051,7 +4052,8 @@ static int macb_init(struct platform_device *pdev)
 	}
 
 	/* Set features */
-	dev->hw_features = NETIF_F_SG;
+	netdev_hw_features_zero(dev);
+	dev->hw_features |= NETIF_F_SG;
 
 	/* Check LSO capability */
 	if (GEM_BFEXT(PBUF_LSO, gem_readl(bp, DCFG6)))
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 363490713825..fec097064e52 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/ioport.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/skbuff.h>
@@ -1644,7 +1645,8 @@ dm9000_probe(struct platform_device *pdev)
 
 	/* dm9000a/b are capable of hardware checksum offload */
 	if (db->type == TYPE_DM9000A || db->type == TYPE_DM9000B) {
-		ndev->hw_features = NETIF_F_RXCSUM;
+		netdev_hw_features_zero(ndev);
+		ndev->hw_features |= NETIF_F_RXCSUM;
 		ndev->hw_features |= NETIF_F_IP_CSUM;
 		ndev->features |= ndev->hw_features;
 	}
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index cb069a0af7b9..8e58b36a826d 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -24,6 +24,7 @@
 #include <linux/of_mdio.h>
 #include <linux/interrupt.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/phy.h>
 #include <linux/iopoll.h>
 
@@ -1224,7 +1225,8 @@ static int tsnep_probe(struct platform_device *pdev)
 
 	netdev->netdev_ops = &tsnep_netdev_ops;
 	netdev->ethtool_ops = &tsnep_ethtool_ops;
-	netdev->features = NETIF_F_SG;
+	netdev_active_features_zero(netdev);
+	netdev->features |= NETIF_F_SG;
 	netdev->hw_features = netdev->features;
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 3533ae7c92f7..c59bbbcd094e 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1684,7 +1684,8 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->netdev_ops = &ibmveth_netdev_ops;
 	netdev->ethtool_ops = &netdev_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->dev);
-	netdev->hw_features = NETIF_F_SG;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_SG;
 	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL)
 		netdev_hw_features_set_array(netdev, &ibmveth_hw_feature_set);
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 97f080c66dd4..42973668ca53 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -10,6 +10,7 @@
 #include <linux/pci.h>
 #include <linux/aer.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
index c73fcb4a15f3..37abb1ed9bd4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3367,7 +3367,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
 		netdev_hw_features_set_array(dev, &mlx4_gso_feature_set);
 		netdev_active_features_set_array(dev, &mlx4_gso_feature_set);
-		dev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_gso_partial_features_zero(dev);
+		dev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev_hw_enc_features_zero(dev);
 		netdev_hw_enc_features_set_array(dev, &mlx4_hw_enc_feature_set);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3c8d059c8484..e516a2805c0d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -37,6 +37,7 @@
 #include <linux/bpf.h>
 #include <linux/if_bridge.h>
 #include <linux/filter.h>
+#include <linux/netdev_features_helper.h>
 #include <net/page_pool.h>
 #include <net/xdp_sock_drv.h>
 #include "eswitch.h"
@@ -4925,7 +4926,8 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
 		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_gso_partial_features_zero(netdev);
+		netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL;
 		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 29611221990f..e306b58b643c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/interrupt.h>
 #include <linux/ip.h>
@@ -2351,7 +2352,8 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	if (nn->cap & NFP_NET_CFG_CTRL_LIVE_ADDR)
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	netdev->hw_features = NETIF_F_HIGHDMA;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_HIGHDMA;
 	if (nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY) {
 		netdev->hw_features |= NETIF_F_RXCSUM;
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
@@ -2378,7 +2380,8 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 			netdev->hw_features |= NETIF_F_GSO_PARTIAL;
 
-			netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_gso_partial_features_zero(netdev);
+			netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		}
 		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_VXLAN;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 48da1da1c704..66f0a9de53ad 100644
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
index 4b3482ce90a1..f70feffbf2ba 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -7,6 +7,7 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
index 67ade78fb767..d42adef5a143 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/mdio-bitbang.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index f8868f79ee95..f9fcca2adcf4 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -31,6 +31,7 @@
 #include <linux/random.h>
 #include <linux/errno.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/mm.h>
@@ -2784,7 +2785,8 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG;
+	netdev_hw_features_zero(dev);
+	dev->hw_features |= NETIF_F_SG;
 	dev->hw_features |= NETIF_F_HW_CSUM;
 	dev->features |= dev->hw_features;
 	dev->features |= NETIF_F_RXCSUM;
@@ -3106,7 +3108,8 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG;
+	netdev_hw_features_zero(dev);
+	dev->hw_features |= NETIF_F_SG;
 	dev->hw_features |= NETIF_F_HW_CSUM;
 	dev->features |= dev->hw_features;
 	dev->features |= NETIF_F_RXCSUM;
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 5def0b3bf8ef..45c0cb3c9a48 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1461,10 +1461,12 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 	int status;
 	u64 v1, v2;
 
-	netdev->hw_features = NETIF_F_IP_CSUM;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_IP_CSUM;
 	netdev->hw_features |= NETIF_F_RXCSUM;
 
-	netdev->features = NETIF_F_IP_CSUM;
+	netdev_active_features_zero(netdev);
+	netdev->features |= NETIF_F_IP_CSUM;
 	if (GELIC_CARD_RX_CSUM_DEFAULT)
 		netdev->features |= NETIF_F_RXCSUM;
 
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index e2e0e18fcdc8..03dc5fb10a2b 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2275,7 +2275,8 @@ spider_net_setup_netdev(struct spider_net_card *card)
 
 	spider_net_setup_netdev_ops(netdev);
 
-	netdev->hw_features = NETIF_F_RXCSUM;
+	netdev_hw_features_zero(netdev);
+	netdev->hw_features |= NETIF_F_RXCSUM;
 	netdev->hw_features |= NETIF_F_IP_CSUM;
 	if (SPIDER_NET_RX_CSUM_DEFAULT)
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
index 3f6b9dfca095..e3299bb3a1e6 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
index 1760930ec0c4..cac3437991ae 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -27,6 +27,7 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/of_platform.h>
@@ -1835,7 +1836,8 @@ static int axienet_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
-	ndev->features = NETIF_F_SG;
+	netdev_active_features_zero(ndev);
+	ndev->features |= NETIF_F_SG;
 	ndev->netdev_ops = &axienet_netdev_ops;
 	ndev->ethtool_ops = &axienet_ethtool_ops;
 
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 30af0081e2be..3b5d82b09675 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -60,6 +60,7 @@
 #include <net/ax25.h>
 #include <linux/inet.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
index 6bf8d63132a1..b83a966b73db 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1163,7 +1163,8 @@ static void netvsc_init_settings(struct net_device *dev)
 	ndc->speed = SPEED_UNKNOWN;
 	ndc->duplex = DUPLEX_FULL;
 
-	dev->features = NETIF_F_LRO;
+	netdev_active_features_zero(dev);
+	dev->features |= NETIF_F_LRO;
 }
 
 static int netvsc_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index c8b1c4d9c507..b7d16d16d523 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -7,6 +7,7 @@
 #include <linux/errno.h>
 #include <linux/if_arp.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
index 80bdc07f2cd3..2075e0b9f175 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -50,6 +50,7 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
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
index 39e61e07e489..9f0175b73fd7 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -16,6 +16,7 @@
 #include <linux/rio_ids.h>
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
index 53865533d7a9..496de424121e 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -953,7 +953,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	features = tap->dev->features;
 
 	if (arg & TUN_F_CSUM) {
-		feature_mask = NETIF_F_HW_CSUM;
+		feature_mask |= NETIF_F_HW_CSUM;
 
 		if (arg & (TUN_F_TSO4 | TUN_F_TSO6)) {
 			if (arg & TUN_F_TSO_ECN)
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index baed53386606..5fad8f09d69f 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1268,7 +1268,8 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 	 */
 	dev->hw_features = NETIF_F_ALL_TSO;
 	netdev_hw_features_set_array(dev, &tbnet_hw_feature_set);
-	dev->features = dev->hw_features | NETIF_F_HIGHDMA;
+	dev->features = dev->hw_features;
+	dev->features |= NETIF_F_HIGHDMA;
 	dev->hard_header_len += sizeof(struct thunderbolt_ip_frame_header);
 
 	netif_napi_add(dev, &net->napi, tbnet_poll, NAPI_POLL_WEIGHT);
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 10cf0a68980e..d7c8b9d6ba29 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/kmod.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
@@ -1085,7 +1086,8 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (DEFAULT_RX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_RXCSUM;
 
-	dev->net->hw_features = NETIF_F_IP_CSUM;
+	netdev_hw_features_zero(dev->net);
+	dev->net->hw_features |= NETIF_F_IP_CSUM;
 	dev->net->hw_features |= NETIF_F_RXCSUM;
 	set_bit(EVENT_NO_IP_ALIGN, &dev->flags);
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 3d8f4da73bd7..4fb30d9534f4 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -5,6 +5,7 @@
  */
 //#define DEBUG
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/module.h>
@@ -3502,7 +3503,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE |
 			   IFF_TX_SKB_NO_LINEAR;
 	dev->netdev_ops = &virtnet_netdev;
-	dev->features = NETIF_F_HIGHDMA;
+	netdev_active_features_zero(dev);
+	dev->features |= NETIF_F_HIGHDMA;
 
 	dev->ethtool_ops = &virtnet_ethtool_ops;
 	SET_NETDEV_DEV(dev, &vdev->dev);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 9dd3b8fba4b0..4d9cd3df3095 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -13,6 +13,7 @@
 #include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/bitfield.h>
+#include <linux/netdev_features_helper.h>
 
 #include "hif.h"
 #include "core.h"
@@ -10210,8 +10211,10 @@ int ath10k_mac_register(struct ath10k *ar)
 	if (ar->hw_params.dynamic_sar_support)
 		ar->hw->wiphy->sar_capa = &ath10k_sar_capa;
 
-	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
-		ar->hw->netdev_features = NETIF_F_HW_CSUM;
+	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
+		netdev_features_zero(&ar->hw->netdev_features);
+		ar->hw->netdev_features |= NETIF_F_HW_CSUM;
+	}
 
 	if (IS_ENABLED(CONFIG_ATH10K_DFS_CERTIFIED)) {
 		/* Init ath dfs pattern detector */
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 7e91e347c9ff..2b78b47e0a90 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8,6 +8,7 @@
 #include <linux/etherdevice.h>
 #include <linux/bitfield.h>
 #include <linux/inetdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <net/if_inet6.h>
 #include <net/ipv6.h>
 
@@ -8895,7 +8896,8 @@ static int __ath11k_mac_register(struct ath11k *ar)
 	ath11k_reg_init(ar);
 
 	if (!test_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags)) {
-		ar->hw->netdev_features = NETIF_F_HW_CSUM;
+		netdev_features_zero(&ar->hw->netdev_features);
+		ar->hw->netdev_features |= NETIF_F_HW_CSUM;
 		ieee80211_hw_set(ar->hw, SW_CRYPTO_CONTROL);
 		ieee80211_hw_set(ar->hw, SUPPORT_FAST_XMIT);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 5f0bba0cfdf6..53c41f48ecf8 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -15,6 +15,7 @@
 #include <linux/sched.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 
@@ -97,7 +98,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
 
 	if (priv->trans->max_skb_frags) {
-		hw->netdev_features = NETIF_F_HIGHDMA;
+		netdev_features_zero(&hw->netdev_features);
+		hw->netdev_features |= NETIF_F_HIGHDMA;
 		hw->netdev_features |= NETIF_F_SG;
 	}
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5fbeb262a90b..1c6bb3317a30 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -8,6 +8,7 @@
 #include <linux/slab.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/if_arp.h>
@@ -319,7 +320,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		ieee80211_hw_set(hw, USES_RSS);
 
 	if (mvm->trans->max_skb_frags) {
-		hw->netdev_features = NETIF_F_HIGHDMA;
+		netdev_features_zero(&hw->netdev_features);
+		hw->netdev_features |= NETIF_F_HIGHDMA;
 		hw->netdev_features |= NETIF_F_SG;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index 07a1fea94f66..bc2e309d45ed 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -10,6 +10,7 @@
 #include <linux/etherdevice.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/netdev_features_helper.h>
 #include "mt7615.h"
 #include "mac.h"
 #include "mcu.h"
@@ -366,7 +367,8 @@ mt7615_init_wiphy(struct ieee80211_hw *hw)
 	hw->max_rates = 3;
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 11;
-	hw->netdev_features = NETIF_F_RXCSUM;
+	netdev_features_zero(&hw->netdev_features);
+	hw->netdev_features |= NETIF_F_RXCSUM;
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index cc2aac86bcfb..bc35271f41da 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -4,6 +4,7 @@
 #include <linux/etherdevice.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/thermal.h>
 #include "mt7915.h"
 #include "mac.h"
@@ -329,7 +330,8 @@ mt7915_init_wiphy(struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
-	hw->netdev_features = NETIF_F_RXCSUM;
+	netdev_features_zero(&hw->netdev_features);
+	hw->netdev_features |= NETIF_F_RXCSUM;
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index cd960e23770f..7824ee8e29cc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -2,6 +2,7 @@
 /* Copyright (C) 2020 MediaTek Inc. */
 
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include "mt7921.h"
 #include "mac.h"
 #include "mcu.h"
@@ -54,7 +55,8 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	hw->queues = 4;
 	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
-	hw->netdev_features = NETIF_F_RXCSUM;
+	netdev_features_zero(&hw->netdev_features);
+	hw->netdev_features |= NETIF_F_RXCSUM;
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index c6b6547f2c6f..52a77a224a64 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_features_helper.h>
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
index 1ee35c5cb0bd..1a903161c46c 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6839,8 +6839,11 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 					   netdev_features_t changed,
 					   netdev_features_t actual)
 {
-	netdev_features_t ipv6_features = NETIF_F_TSO6;
-	netdev_features_t ipv4_features = NETIF_F_TSO;
+	netdev_features_t ipv6_features = netdev_empty_features;
+	netdev_features_t ipv4_features = netdev_empty_features;
+
+	ipv6_features |= NETIF_F_TSO6;
+	ipv4_features |= NETIF_F_TSO;
 
 	if (!card->info.has_lp2lp_cso_v6)
 		ipv6_features |= NETIF_F_IPV6_CSUM;
diff --git a/include/net/udp.h b/include/net/udp.h
index 13887234a241..46d7527cae38 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -457,9 +457,11 @@ void udpv6_encap_enable(void);
 static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 					      struct sk_buff *skb, bool ipv4)
 {
-	netdev_features_t features = NETIF_F_SG;
+	netdev_features_t features = netdev_empty_features;
 	struct sk_buff *segs;
 
+	features |= NETIF_F_SG;
+
 	/* Avoid csum recalculation by skb_segment unless userspace explicitly
 	 * asks for the final checksum values
 	 */
diff --git a/net/phonet/pep-gprs.c b/net/phonet/pep-gprs.c
index 1f5df0432d37..0b09b1ba0c05 100644
--- a/net/phonet/pep-gprs.c
+++ b/net/phonet/pep-gprs.c
@@ -11,6 +11,7 @@
 
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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

