Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5B75BBD17
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiIRJuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiIRJt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B7B12753
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbs4ZSjzlVmD;
        Sun, 18 Sep 2022 17:45:45 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 13/55] treewide: replace VLAN tag feature array by const vlan features
Date:   Sun, 18 Sep 2022 09:42:54 +0000
Message-ID: <20220918094336.28958-14-shenjian15@huawei.com>
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

Replace the vlan features relative expressions by
const vlan features, make it simple to use netdev
features helpers later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/bonding/bond_main.c               |  5 ++-
 drivers/net/ethernet/amd/amd8111e.c           |  2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  6 ++--
 drivers/net/ethernet/broadcom/tg3.c           |  4 +--
 .../net/ethernet/cavium/liquidio/lio_main.c   |  4 +--
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  4 +--
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  4 +--
 drivers/net/ethernet/cisco/enic/enic_main.c   |  2 +-
 drivers/net/ethernet/freescale/gianfar.c      |  3 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  3 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  4 +--
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  4 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 32 +++++++----------
 drivers/net/ethernet/intel/ice/ice_main.c     | 36 +++++++------------
 drivers/net/ethernet/intel/igb/igb_main.c     |  4 +--
 drivers/net/ethernet/intel/igbvf/netdev.c     |  4 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  4 +--
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  6 ++--
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  3 +-
 drivers/net/ethernet/marvell/sky2.c           |  5 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  2 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 10 ++----
 .../ethernet/microchip/lan966x/lan966x_main.c |  3 +-
 drivers/net/ethernet/natsemi/ns83820.c        |  2 +-
 drivers/net/ethernet/nvidia/forcedeth.c       | 10 +++---
 drivers/net/ethernet/qualcomm/emac/emac.c     |  2 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_common.h |  7 +---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  8 ++---
 drivers/net/ethernet/via/via-rhine.c          |  4 +--
 drivers/net/ifb.c                             |  3 +-
 drivers/net/net_failover.c                    |  4 +--
 drivers/net/team/team.c                       |  7 ++--
 drivers/net/tun.c                             |  4 +--
 drivers/net/veth.c                            |  6 +---
 drivers/net/vmxnet3/vmxnet3_drv.c             |  3 +-
 drivers/s390/net/qeth_l3_main.c               |  3 +-
 drivers/staging/qlge/qlge_main.c              |  4 +--
 include/linux/if_vlan.h                       |  4 +--
 net/bridge/br_device.c                        |  3 +-
 net/core/dev.c                                |  3 +-
 net/openvswitch/vport-internal_dev.c          |  2 +-
 44 files changed, 80 insertions(+), 161 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 7cdaf25cb920..b3fadd51d733 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1484,8 +1484,7 @@ static void bond_compute_features(struct bonding *bond)
 done:
 	bond_dev->vlan_features = vlan_features;
 	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_STAG_TX;
+				    netdev_tx_vlan_features;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_enc_features |= xfrm_features;
 #endif /* CONFIG_XFRM_OFFLOAD */
@@ -5778,7 +5777,7 @@ void bond_setup(struct net_device *bond_dev)
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	bond_dev->features |= bond_dev->hw_features;
-	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
+	bond_dev->features |= netdev_tx_vlan_features;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_features |= BOND_XFRM_FEATURES;
 	/* Only enable XFRM features if this is an active-backup config */
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index fb6a5f64d221..a481936e80fa 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -1791,7 +1791,7 @@ static int amd8111e_probe_one(struct pci_dev *pdev,
 	SET_NETDEV_DEV(dev, &pdev->dev);
 
 #if AMD8111E_VLAN_TAG_USED
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	dev->features |= netdev_ctag_vlan_offload_features;
 #endif
 
 	lp = netdev_priv(dev);
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 1b487c071cb6..a699a7b5e242 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -1390,7 +1390,7 @@ static int atl2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_sw_init;
 
 	netdev->hw_features = NETIF_F_HW_VLAN_CTAG_RX;
-	netdev->features |= (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+	netdev->features |= netdev_ctag_vlan_offload_features;
 
 	/* Init PHY as early as possible due to power saving issue  */
 	atl2_phy_init(&adapter->hw);
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 687e2aa9c721..37b0d0b26a26 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8591,7 +8591,7 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					   NETIF_F_TSO6_BIT);
 
 	dev->vlan_features = dev->hw_features;
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	dev->hw_features |= netdev_ctag_vlan_offload_features;
 	dev->features |= dev->hw_features;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->min_mtu = MIN_ETHERNET_PACKET_SIZE;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index b1b17f911300..5e979243795a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2194,10 +2194,8 @@ struct bnxt {
 #define BNXT_TX_STATS_EXT_OFFSET(counter)		\
 	(offsetof(struct tx_port_stats_ext, counter) / 8)
 
-#define BNXT_HW_FEATURE_VLAN_ALL_RX				\
-	(NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX)
-#define BNXT_HW_FEATURE_VLAN_ALL_TX				\
-	(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX)
+#define BNXT_HW_FEATURE_VLAN_ALL_RX	netdev_rx_vlan_features
+#define BNXT_HW_FEATURE_VLAN_ALL_TX	netdev_tx_vlan_features
 
 #define I2C_DEV_ADDR_A0				0xa0
 #define I2C_DEV_ADDR_A2				0xa2
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index b83aeaf904a8..153d51c7ffbf 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17755,8 +17755,8 @@ static int tg3_init_one(struct pci_dev *pdev,
 			features |= NETIF_F_TSO_ECN;
 	}
 
-	dev->features |= features | NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+	dev->features |= features;
+	dev->features |= netdev_ctag_vlan_offload_features;
 	dev->vlan_features |= features;
 
 	/*
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 51334509ba12..27844cf7da8a 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3591,9 +3591,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
-		lio->dev_capability |=  NETIF_F_HW_VLAN_CTAG_FILTER |
-					NETIF_F_HW_VLAN_CTAG_RX |
-					NETIF_F_HW_VLAN_CTAG_TX;
+		lio->dev_capability |= netdev_ctag_vlan_features;
 
 		netdev->features = (lio->dev_capability & ~NETIF_F_LRO);
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 861ecd176404..be01b71d8738 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2117,9 +2117,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
-		lio->dev_capability |= NETIF_F_HW_VLAN_CTAG_FILTER |
-				       NETIF_F_HW_VLAN_CTAG_RX |
-				       NETIF_F_HW_VLAN_CTAG_TX;
+		lio->dev_capability |= netdev_ctag_vlan_features;
 
 		netdev->features = (lio->dev_capability & ~NETIF_F_LRO);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index c787b9122df8..7b0d0d95552f 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1042,9 +1042,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					       NETIF_F_HIGHDMA_BIT);
 
 		if (vlan_tso_capable(adapter)) {
-			netdev->features |=
-				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX;
+			netdev->features |= netdev_ctag_vlan_offload_features;
 			netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
 
 			/* T204: disable TSO */
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 9449b6b5b865..0ddc787b6381 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2885,7 +2885,7 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->watchdog_timeo = 2 * HZ;
 	enic_set_ethtool_ops(netdev);
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev->features |= netdev_ctag_vlan_offload_features;
 	if (ENIC_SETTING(enic, LOOP)) {
 		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 		enic->loop_enable = 1;
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index f2d015371e6c..430b4a0e6e7d 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3250,8 +3250,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX;
+		dev->hw_features |= netdev_ctag_vlan_offload_features;
 		dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 	}
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index b2b0d3c26fcc..efb41a3eea11 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -511,8 +511,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 	struct gfar_private *priv = netdev_priv(dev);
 	int err = 0;
 
-	if (!(changed & (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_RXCSUM)))
+	if (!(changed & (netdev_ctag_vlan_offload_features | NETIF_F_RXCSUM)))
 		return 0;
 
 	while (test_and_set_bit_lock(GFAR_RESETTING, &priv->state))
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index d0da306457d2..2adc8a82be85 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1598,9 +1598,7 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 	 * insertion or stripping on the hardware since it is contained
 	 * in the FTAG and not in the frame itself.
 	 */
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_HW_VLAN_CTAG_FILTER;
+	dev->features |= netdev_ctag_vlan_features;
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2dbe94cf3db3..3b5392750a0a 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13687,9 +13687,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	/* enable macvlan offloads */
 	netdev->hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
 
-	hw_features = hw_enc_features		|
-		      NETIF_F_HW_VLAN_CTAG_TX	|
-		      NETIF_F_HW_VLAN_CTAG_RX;
+	hw_features = hw_enc_features | netdev_ctag_vlan_offload_features;
 
 	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
 		netdev_features_set_set(hw_features, NETIF_F_NTUPLE_BIT,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 3b51eacadec5..d6e1c0438e14 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2202,20 +2202,20 @@ iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
 	 * ETH_P_8021Q so an ethertype is specified if disabling insertion and
 	 * stripping.
 	 */
-	if (features & (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX))
+	if (features & netdev_stag_vlan_offload_features)
 		vlan_ethertype = ETH_P_8021AD;
-	else if (features & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX))
+	else if (features & netdev_ctag_vlan_offload_features)
 		vlan_ethertype = ETH_P_8021Q;
-	else if (prev_features & (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX))
+	else if (prev_features & netdev_stag_vlan_offload_features)
 		vlan_ethertype = ETH_P_8021AD;
-	else if (prev_features & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX))
+	else if (prev_features & netdev_ctag_vlan_offload_features)
 		vlan_ethertype = ETH_P_8021Q;
 	else
 		vlan_ethertype = ETH_P_8021Q;
 
-	if (!(features & (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_CTAG_RX)))
+	if (!(features & netdev_rx_vlan_features))
 		enable_stripping = false;
-	if (!(features & (NETIF_F_HW_VLAN_STAG_TX | NETIF_F_HW_VLAN_CTAG_TX)))
+	if (!(features & netdev_tx_vlan_features))
 		enable_insertion = false;
 
 	if (VLAN_ALLOWED(adapter)) {
@@ -4351,10 +4351,7 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
 	return 0;
 }
 
-#define NETIF_VLAN_OFFLOAD_FEATURES	(NETIF_F_HW_VLAN_CTAG_RX | \
-					 NETIF_F_HW_VLAN_CTAG_TX | \
-					 NETIF_F_HW_VLAN_STAG_RX | \
-					 NETIF_F_HW_VLAN_STAG_TX)
+#define NETIF_VLAN_OFFLOAD_FEATURES	netdev_vlan_offload_features
 
 /**
  * iavf_set_features - set the netdev feature flags
@@ -4451,8 +4448,7 @@ iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 
 	/* Enable VLAN features if supported */
 	if (VLAN_ALLOWED(adapter)) {
-		hw_features |= (NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX);
+		hw_features |= netdev_ctag_vlan_offload_features;
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
 			&adapter->vlan_v2_caps;
@@ -4512,8 +4508,7 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 		return features;
 
 	if (VLAN_ALLOWED(adapter)) {
-		features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX;
+		features |= netdev_ctag_vlan_features;
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
 			&adapter->vlan_v2_caps;
@@ -4642,15 +4637,12 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
 					      NETIF_F_HW_VLAN_STAG_FILTER))
 		requested_features &= ~NETIF_F_HW_VLAN_STAG_FILTER;
 
-	if ((requested_features &
-	     (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX)) &&
-	    (requested_features &
-	     (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX)) &&
+	if ((requested_features & netdev_ctag_vlan_offload_features) &&
+	    (requested_features & netdev_stag_vlan_offload_features) &&
 	    adapter->vlan_v2_caps.offloads.ethertype_match ==
 	    VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION) {
 		netdev_warn(adapter->netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
-		requested_features &= ~(NETIF_F_HW_VLAN_STAG_RX |
-					NETIF_F_HW_VLAN_STAG_TX);
+		requested_features &= ~netdev_stag_vlan_offload_features;
 	}
 
 	return requested_features;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c3a007f720d8..d6a177b0f2c8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3348,9 +3348,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 				NETIF_F_SCTP_CRC_BIT,
 				NETIF_F_IPV6_CSUM_BIT);
 
-	vlano_features = NETIF_F_HW_VLAN_CTAG_FILTER |
-			 NETIF_F_HW_VLAN_CTAG_TX     |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+	vlano_features = netdev_ctag_vlan_features;
 
 	/* Enable CTAG/STAG filtering by default in Double VLAN Mode (DVM) */
 	if (is_dvm_ena)
@@ -3402,8 +3400,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	 * ice_fix_features() ndo callback.
 	 */
 	if (is_dvm_ena)
-		netdev->hw_features |= NETIF_F_HW_VLAN_STAG_RX |
-			NETIF_F_HW_VLAN_STAG_TX;
+		netdev->hw_features |= netdev_stag_vlan_offload_features;
 
 	/* Leave CRC / FCS stripping enabled by default, but allow the value to
 	 * be changed at runtime
@@ -5768,16 +5765,11 @@ ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
 	return err;
 }
 
-#define NETIF_VLAN_OFFLOAD_FEATURES	(NETIF_F_HW_VLAN_CTAG_RX | \
-					 NETIF_F_HW_VLAN_CTAG_TX | \
-					 NETIF_F_HW_VLAN_STAG_RX | \
-					 NETIF_F_HW_VLAN_STAG_TX)
+#define NETIF_VLAN_OFFLOAD_FEATURES	netdev_vlan_offload_features
 
-#define NETIF_VLAN_STRIPPING_FEATURES	(NETIF_F_HW_VLAN_CTAG_RX | \
-					 NETIF_F_HW_VLAN_STAG_RX)
+#define NETIF_VLAN_STRIPPING_FEATURES	netdev_vlan_offload_features
 
-#define NETIF_VLAN_FILTERING_FEATURES	(NETIF_F_HW_VLAN_CTAG_FILTER | \
-					 NETIF_F_HW_VLAN_STAG_FILTER)
+#define NETIF_VLAN_FILTERING_FEATURES	netdev_vlan_filter_features
 
 /**
  * ice_fix_features - fix the netdev features flags based on device limitations
@@ -5855,11 +5847,10 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 		}
 	}
 
-	if ((features & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX)) &&
-	    (features & (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX))) {
+	if ((features & netdev_ctag_vlan_offload_features) &&
+	    (features & netdev_stag_vlan_offload_features)) {
 		netdev_warn(netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
-		features &= ~(NETIF_F_HW_VLAN_STAG_RX |
-			      NETIF_F_HW_VLAN_STAG_TX);
+		features &= ~netdev_stag_vlan_offload_features;
 	}
 
 	if (!(netdev->features & NETIF_F_RXFCS) &&
@@ -5892,14 +5883,14 @@ ice_set_vlan_offload_features(struct ice_vsi *vsi, netdev_features_t features)
 
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
-	if (features & (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_STAG_TX))
+	if (features & netdev_stag_vlan_offload_features)
 		vlan_ethertype = ETH_P_8021AD;
-	else if (features & (NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX))
+	else if (features & netdev_ctag_vlan_offload_features)
 		vlan_ethertype = ETH_P_8021Q;
 
-	if (!(features & (NETIF_F_HW_VLAN_STAG_RX | NETIF_F_HW_VLAN_CTAG_RX)))
+	if (!(features & netdev_rx_vlan_features))
 		enable_stripping = false;
-	if (!(features & (NETIF_F_HW_VLAN_STAG_TX | NETIF_F_HW_VLAN_CTAG_TX)))
+	if (!(features & netdev_tx_vlan_features))
 		enable_insertion = false;
 
 	if (enable_stripping)
@@ -5935,8 +5926,7 @@ ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
 	/* support Single VLAN Mode (SVM) and Double VLAN Mode (DVM) by checking
 	 * if either bit is set
 	 */
-	if (features &
-	    (NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_STAG_FILTER))
+	if (features & netdev_vlan_filter_features)
 		err = vlan_ops->ena_rx_filtering(vsi);
 	else
 		err = vlan_ops->dis_rx_filtering(vsi);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index af656420ec4d..af90680f7329 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3320,9 +3320,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features |= netdev_ctag_vlan_features;
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 2964afacac72..cd16e9e259c4 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2794,9 +2794,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features |= netdev_ctag_vlan_features;
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 38f553e0411e..ea08c9fb5764 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11026,9 +11026,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->mpls_features |= gso_partial_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features |= netdev_ctag_vlan_features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 248fb4b58166..d6c848533d04 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4635,9 +4635,7 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features |= netdev_ctag_vlan_features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 1c94b41927a7..c4db48513cec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2765,11 +2765,9 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Support TSO on tag interface */
 	netdev->vlan_features |= netdev->features;
-	netdev->hw_features  |= NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_STAG_TX;
+	netdev->hw_features  |= netdev_tx_vlan_features;
 	if (pf->flags & OTX2_FLAG_RX_VLAN_SUPPORT)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX |
-				       NETIF_F_HW_VLAN_STAG_RX;
+		netdev->hw_features |= netdev_rx_vlan_features;
 	netdev->features |= netdev->hw_features;
 
 	/* HW supports tc offload but mutually exclusive with n-tuple filters */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 7fdcf33a35e7..af0cd349e575 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -647,8 +647,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->features = netdev->hw_features;
 	/* Support TSO on tag interface */
 	netdev->vlan_features |= netdev->features;
-	netdev->hw_features  |= NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_STAG_TX;
+	netdev->hw_features  |= netdev_tx_vlan_features;
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_NTUPLE;
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 90c5297c791f..2f7f8aef4553 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4346,7 +4346,7 @@ static int sky2_set_features(struct net_device *dev, netdev_features_t features)
 	if (changed & NETIF_F_RXHASH)
 		rx_set_rss(dev, features);
 
-	if (changed & (NETIF_F_HW_VLAN_CTAG_TX|NETIF_F_HW_VLAN_CTAG_RX))
+	if (changed & netdev_ctag_vlan_offload_features)
 		sky2_vlan_mode(dev, features);
 
 	return 0;
@@ -4649,8 +4649,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 		dev->hw_features |= NETIF_F_RXHASH;
 
 	if (!(hw->flags & SKY2_HW_VLAN_BROKEN)) {
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX;
+		dev->hw_features |= netdev_ctag_vlan_offload_features;
 		netdev_vlan_features_set_array(dev, &sky2_vlan_feature_set);
 	}
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 1e1d08248664..0cf3582255bb 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3901,7 +3901,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 		eth->netdev[id]->hw_features |= NETIF_F_LRO;
 
 	eth->netdev[id]->vlan_features = *eth->soc->hw_features &
-		~(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+		~netdev_ctag_vlan_offload_features;
 	eth->netdev[id]->features |= *eth->soc->hw_features;
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 98501284e3aa..900d1543645b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3381,14 +3381,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		err = mlx4_get_is_vlan_offload_disabled(mdev->dev, port,
 							&vlan_offload_disabled);
 		if (!err && vlan_offload_disabled) {
-			dev->hw_features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
-					      NETIF_F_HW_VLAN_CTAG_RX |
-					      NETIF_F_HW_VLAN_STAG_TX |
-					      NETIF_F_HW_VLAN_STAG_RX);
-			dev->features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
-					   NETIF_F_HW_VLAN_CTAG_RX |
-					   NETIF_F_HW_VLAN_STAG_TX |
-					   NETIF_F_HW_VLAN_STAG_RX);
+			dev->hw_features &= ~netdev_vlan_offload_features;
+			dev->features &= ~netdev_vlan_offload_features;
 		}
 	} else {
 		if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_PHV_EN &&
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 371fa995e9e0..1645e7cd17d2 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -753,8 +753,7 @@ static int lan966x_probe_port(struct lan966x *lan966x, u32 p,
 
 	dev->netdev_ops = &lan966x_port_netdev_ops;
 	dev->ethtool_ops = &lan966x_ethtool_ops;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_STAG_TX;
+	dev->features |= netdev_tx_vlan_features;
 	dev->needed_headroom = IFH_LEN * sizeof(u32);
 
 	eth_hw_addr_gen(dev, lan966x->base_mac, p + 1);
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 998586872599..62e57f882b7b 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -2149,7 +2149,7 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 
 #ifdef NS83820_VLAN_ACCEL_SUPPORT
 	/* We also support hardware vlan acceleration */
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	ndev->features |= netdev_ctag_vlan_offload_features;
 #endif
 
 	if (using_dac) {
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 7afbd49551bc..67c6214d19bd 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4931,7 +4931,7 @@ static netdev_features_t nv_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	/* vlan is dependent on rx checksum offload */
-	if (features & (NETIF_F_HW_VLAN_CTAG_TX|NETIF_F_HW_VLAN_CTAG_RX))
+	if (features & netdev_ctag_vlan_offload_features)
 		features |= NETIF_F_RXCSUM;
 
 	return features;
@@ -4985,7 +4985,7 @@ static int nv_set_features(struct net_device *dev, netdev_features_t features)
 		spin_unlock_irq(&np->lock);
 	}
 
-	if (changed & (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX))
+	if (changed & netdev_ctag_vlan_offload_features)
 		nv_vlan_mode(dev, features);
 
 	return 0;
@@ -5820,8 +5820,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	np->vlanctl_bits = 0;
 	if (id->driver_data & DEV_HAS_VLAN) {
 		np->vlanctl_bits = NVREG_VLANCONTROL_ENABLE;
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX |
-				    NETIF_F_HW_VLAN_CTAG_TX;
+		dev->hw_features |= netdev_ctag_vlan_offload_features;
 	}
 
 	dev->features |= dev->hw_features;
@@ -6123,8 +6122,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 		 dev->features & NETIF_F_HIGHDMA ? "highdma " : "",
 		 dev->features & (NETIF_F_IP_CSUM | NETIF_F_SG) ?
 			"csum " : "",
-		 dev->features & (NETIF_F_HW_VLAN_CTAG_RX |
-				  NETIF_F_HW_VLAN_CTAG_TX) ?
+		 dev->features & netdev_ctag_vlan_offload_features ?
 			"vlan " : "",
 		 dev->features & (NETIF_F_LOOPBACK) ?
 			"loopback " : "",
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 986a12eb1d67..e79187d50c20 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -182,7 +182,7 @@ static int emac_set_features(struct net_device *netdev,
 	/* We only need to reprogram the hardware if the VLAN tag features
 	 * have changed, and if it's already running.
 	 */
-	if (!(changed & (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX)))
+	if (!(changed & netdev_ctag_vlan_offload_features))
 		return 0;
 
 	if (!netif_running(netdev))
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
index 0f45107db8dd..1cdd996cfd48 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h
@@ -151,12 +151,7 @@ enum dma_irq_status {
 	handle_rx	= BIT(5),
 };
 
-#define NETIF_F_HW_VLAN_ALL     (NETIF_F_HW_VLAN_CTAG_RX |	\
-				 NETIF_F_HW_VLAN_STAG_RX |	\
-				 NETIF_F_HW_VLAN_CTAG_TX |	\
-				 NETIF_F_HW_VLAN_STAG_TX |	\
-				 NETIF_F_HW_VLAN_CTAG_FILTER |	\
-				 NETIF_F_HW_VLAN_STAG_FILTER)
+#define NETIF_F_HW_VLAN_ALL     netdev_all_vlan_features
 
 /* MMC control defines */
 #define SXGBE_MMC_CTRL_CNT_FRZ  0x00000008
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c60b47316770..69e55f3e2c12 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7178,11 +7178,9 @@ int stmmac_dvr_probe(struct device *device,
 	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_STAG_RX;
-	if (priv->dma_cap.vlhash) {
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-		ndev->features |= NETIF_F_HW_VLAN_STAG_FILTER;
-	}
+	ndev->features |= netdev_rx_vlan_features;
+	if (priv->dma_cap.vlhash)
+		ndev->features |= netdev_vlan_filter_features;
 	if (priv->dma_cap.vlins) {
 		ndev->features |= NETIF_F_HW_VLAN_CTAG_TX;
 		if (priv->dma_cap.dvlan)
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 5c94afc768b2..d5cfdb196ead 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -973,9 +973,7 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 					       NETIF_F_HW_CSUM_BIT);
 
 	if (rp->quirks & rqMgmt)
-		dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-				 NETIF_F_HW_VLAN_CTAG_RX |
-				 NETIF_F_HW_VLAN_CTAG_FILTER;
+		dev->features |= netdev_ctag_vlan_features;
 
 	/* dev->name not defined before register_netdev()! */
 	rc = register_netdev(dev);
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 56dcf6677cdf..2fd507897cd1 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -324,8 +324,7 @@ static void ifb_setup(struct net_device *dev)
 	dev->features |= ifb_features;
 	dev->hw_features |= dev->features;
 	dev->hw_enc_features |= dev->features;
-	dev->vlan_features |= ifb_features & ~(NETIF_F_HW_VLAN_CTAG_TX |
-					       NETIF_F_HW_VLAN_STAG_TX);
+	dev->vlan_features |= ifb_features & ~netdev_tx_vlan_features;
 
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 9adc0cbce2a8..7300e69fd509 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -745,9 +745,7 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 	failover_dev->features |= NETIF_F_NETNS_LOCAL;
 
 	failover_dev->hw_features = FAILOVER_VLAN_FEATURES |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX |
-				    NETIF_F_HW_VLAN_CTAG_FILTER;
+				    netdev_ctag_vlan_features;
 
 	failover_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	failover_dev->features |= failover_dev->hw_features;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index fa0fb4d074e7..0b345010195f 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1014,9 +1014,8 @@ static void __team_compute_features(struct team *team)
 	rcu_read_unlock();
 
 	team->dev->vlan_features = vlan_features;
-	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				     NETIF_F_HW_VLAN_CTAG_TX |
-				     NETIF_F_HW_VLAN_STAG_TX;
+	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
+	team->dev->hw_enc_features |= netdev_tx_vlan_features;
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -2181,7 +2180,7 @@ static void team_setup(struct net_device *dev)
 
 	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	dev->features |= dev->hw_features;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
+	dev->features |= netdev_tx_vlan_features;
 }
 
 static int team_newlink(struct net *src_net, struct net_device *dev,
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index be2d41f0c10d..f92041e49864 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -997,9 +997,7 @@ static int tun_net_init(struct net_device *dev)
 				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				   NETIF_F_HW_VLAN_STAG_TX_BIT);
 	dev->features = dev->hw_features | NETIF_F_LLTX;
-	dev->vlan_features = dev->features &
-			     ~(NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_HW_VLAN_STAG_TX);
+	dev->vlan_features = dev->features & ~netdev_tx_vlan_features;
 
 	tun->flags = (tun->flags & ~TUN_FEATURES) |
 		      (ifr->ifr_flags & TUN_FEATURES);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index bb88eb1d465a..2070756c2c43 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1641,11 +1641,7 @@ static void veth_setup(struct net_device *dev)
 				NETIF_F_HW_VLAN_STAG_RX_BIT);
 	dev->features |= NETIF_F_LLTX;
 	dev->features |= veth_features;
-	dev->vlan_features = dev->features &
-			     ~(NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_HW_VLAN_STAG_TX |
-			       NETIF_F_HW_VLAN_CTAG_RX |
-			       NETIF_F_HW_VLAN_STAG_RX);
+	dev->vlan_features = dev->features & ~netdev_vlan_offload_features;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = veth_dev_free;
 	dev->max_mtu = ETH_MAX_MTU;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index ea9c6f618ef9..20869331e70f 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3380,8 +3380,7 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 	}
 
 	netdev->vlan_features = netdev->hw_features &
-				~(NETIF_F_HW_VLAN_CTAG_TX |
-				  NETIF_F_HW_VLAN_CTAG_RX);
+				~netdev_ctag_vlan_offload_features;
 	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d42303884636..a857091c4248 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1906,8 +1906,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		return -ENODEV;
 
 	card->dev->needed_headroom = headroom;
-	card->dev->features |=	NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX;
+	card->dev->features |= netdev_ctag_vlan_offload_features;
 
 	netif_keep_dst(card->dev);
 	if (card->dev->hw_features & netdev_general_tso_features)
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index bf685aee0fbf..11df4ec829c1 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4580,9 +4580,7 @@ static int qlge_probe(struct pci_dev *pdev,
 	ndev->features = ndev->hw_features;
 	ndev->vlan_features = ndev->hw_features;
 	/* vlan gets same features (except vlan filter) */
-	ndev->vlan_features &= ~(NETIF_F_HW_VLAN_CTAG_FILTER |
-				 NETIF_F_HW_VLAN_CTAG_TX |
-				 NETIF_F_HW_VLAN_CTAG_RX);
+	ndev->vlan_features &= ~netdev_ctag_vlan_features;
 
 	if (test_bit(QL_DMA64, &qdev->flags))
 		ndev->features |= NETIF_F_HIGHDMA;
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index e00c4ee81ff7..890ea73b4ffb 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -741,9 +741,7 @@ static inline netdev_features_t vlan_features_check(struct sk_buff *skb,
 		 * sure that only devices supporting NETIF_F_HW_CSUM will
 		 * have checksum offloading support.
 		 */
-		features &= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-			    NETIF_F_FRAGLIST | NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_HW_VLAN_STAG_TX;
+		features &= netdev_multi_tags_features_mask;
 	}
 
 	return features;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index aa67b4a1270a..7f2869ab25c6 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -500,8 +500,7 @@ void br_dev_setup(struct net_device *dev)
 				       NETIF_F_NETNS_LOCAL_BIT,
 				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				       NETIF_F_HW_VLAN_STAG_TX_BIT);
-	dev->hw_features = common_features | NETIF_F_HW_VLAN_CTAG_TX |
-			   NETIF_F_HW_VLAN_STAG_TX;
+	dev->hw_features = common_features | netdev_tx_vlan_features;
 	dev->vlan_features = common_features;
 
 	br->dev = dev;
diff --git a/net/core/dev.c b/net/core/dev.c
index 302ae1fdca85..a53e5362cc89 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3564,8 +3564,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	if (skb_vlan_tagged(skb))
 		features = netdev_intersect_features(features,
 						     dev->vlan_features |
-						     NETIF_F_HW_VLAN_CTAG_TX |
-						     NETIF_F_HW_VLAN_STAG_TX);
+						     netdev_tx_vlan_features);
 
 	if (dev->netdev_ops->ndo_features_check)
 		features &= dev->netdev_ops->ndo_features_check(skb, dev,
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index c3ef955e2a3a..402594e1cdb0 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -118,7 +118,7 @@ static void do_setup(struct net_device *netdev)
 
 	netdev->vlan_features = netdev->features;
 	netdev->hw_enc_features = netdev->features;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
+	netdev->features |= netdev_tx_vlan_features;
 	netdev->hw_features = netdev->features & ~NETIF_F_LLTX;
 
 	eth_hw_addr_random(netdev);
-- 
2.33.0

