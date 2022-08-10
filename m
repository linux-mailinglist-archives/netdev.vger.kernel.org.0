Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4884458E563
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiHJDO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiHJDN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB83782F91
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:51 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zfr3DCMzXdT5;
        Wed, 10 Aug 2022 11:09:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:45 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 13/36] treewide: replace VLAN tag feature array by const vlan features
Date:   Wed, 10 Aug 2022 11:06:01 +0800
Message-ID: <20220810030624.34711-14-shenjian15@huawei.com>
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
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 32 +++++++-----------
 drivers/net/ethernet/intel/ice/ice_main.c     | 33 +++++++------------
 drivers/net/ethernet/intel/igb/igb_main.c     | 11 +++----
 drivers/net/ethernet/intel/igbvf/netdev.c     |  4 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  4 +--
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  6 ++--
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  3 +-
 drivers/net/ethernet/marvell/sky2.c           |  5 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  2 +-
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
 43 files changed, 80 insertions(+), 155 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index a7783abec601..ca23f18fa7fc 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1499,8 +1499,7 @@ static void bond_compute_features(struct bonding *bond)
 done:
 	bond_dev->vlan_features = vlan_features;
 	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_STAG_TX;
+				    netdev_tx_vlan_features;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_enc_features |= xfrm_features;
 #endif /* CONFIG_XFRM_OFFLOAD */
@@ -5772,7 +5771,7 @@ void bond_setup(struct net_device *bond_dev)
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	bond_dev->features |= bond_dev->hw_features;
-	bond_dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
+	bond_dev->features |= netdev_tx_vlan_features;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_features |= BOND_XFRM_FEATURES;
 	/* Only enable XFRM features if this is an active-backup config */
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 5d1baa01360f..d94d982357b1 100644
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
index bbc4d7b08a49..1d647c4d1d44 100644
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
index 0e779e5dee9a..4a03b8c9f37a 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8596,7 +8596,7 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
 
 	dev->vlan_features = dev->hw_features;
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	dev->hw_features |= netdev_ctag_vlan_offload_features;
 	dev->features |= dev->hw_features;
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	dev->min_mtu = MIN_ETHERNET_PACKET_SIZE;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 075c6206325c..04c8ce4fae73 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -2193,10 +2193,8 @@ struct bnxt {
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
index 116b379031e2..3a7bb3db4e47 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17752,8 +17752,8 @@ static int tg3_init_one(struct pci_dev *pdev,
 			features |= NETIF_F_TSO_ECN;
 	}
 
-	dev->features |= features | NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+	dev->features |= features;
+	dev->features |= netdev_ctag_vlan_offload_features;
 	dev->vlan_features |= features;
 
 	/*
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 9c9c8dee0c7b..b5a963c9dc03 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3599,9 +3599,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
-		lio->dev_capability |=  NETIF_F_HW_VLAN_CTAG_FILTER |
-					NETIF_F_HW_VLAN_CTAG_RX |
-					NETIF_F_HW_VLAN_CTAG_TX;
+		lio->dev_capability |= netdev_ctag_vlan_features;
 
 		netdev->features = (lio->dev_capability & ~NETIF_F_LRO);
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 9e0c176ea7af..23524066fa9a 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2127,9 +2127,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
-		lio->dev_capability |= NETIF_F_HW_VLAN_CTAG_FILTER |
-				       NETIF_F_HW_VLAN_CTAG_RX |
-				       NETIF_F_HW_VLAN_CTAG_TX;
+		lio->dev_capability |= netdev_ctag_vlan_features;
 
 		netdev->features = (lio->dev_capability & ~NETIF_F_LRO);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 44404b711e09..eabb2a782d12 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1048,9 +1048,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_active_features_set_array(netdev, &cxgb_feature_set);
 
 		if (vlan_tso_capable(adapter)) {
-			netdev->features |=
-				NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX;
+			netdev->features |= netdev_ctag_vlan_offload_features;
 			netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
 
 			/* T204: disable TSO */
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index afed961f2334..061375f34d5d 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2894,7 +2894,7 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->watchdog_timeo = 2 * HZ;
 	enic_set_ethtool_ops(netdev);
 
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	netdev->features |= netdev_ctag_vlan_offload_features;
 	if (ENIC_SETTING(enic, LOOP)) {
 		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 		enic->loop_enable = 1;
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 72a1842794a7..d9b1928d1987 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3256,8 +3256,7 @@ static int gfar_probe(struct platform_device *ofdev)
 	}
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX;
+		dev->hw_features |= netdev_ctag_vlan_offload_features;
 		dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 	}
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 81fb68730138..b4b1b7b7143f 100644
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
index 513ec9e7f037..2e0e7bc100e8 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1601,9 +1601,7 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 	 * insertion or stripping on the hardware since it is contained
 	 * in the FTAG and not in the frame itself.
 	 */
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-			 NETIF_F_HW_VLAN_CTAG_RX |
-			 NETIF_F_HW_VLAN_CTAG_FILTER;
+	dev->features |= netdev_ctag_vlan_features;
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 007931b7fcd0..b905eced9d91 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13704,9 +13704,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	/* enable macvlan offloads */
 	netdev->hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
 
-	hw_features = hw_enc_features		|
-		      NETIF_F_HW_VLAN_CTAG_TX	|
-		      NETIF_F_HW_VLAN_CTAG_RX;
+	hw_features = hw_enc_features | netdev_ctag_vlan_offload_features;
 
 	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
 		hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index afea95a58fbd..efbd889eea1a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2125,20 +2125,20 @@ iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
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
@@ -4226,10 +4226,7 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
 	return 0;
 }
 
-#define NETIF_VLAN_OFFLOAD_FEATURES	(NETIF_F_HW_VLAN_CTAG_RX | \
-					 NETIF_F_HW_VLAN_CTAG_TX | \
-					 NETIF_F_HW_VLAN_STAG_RX | \
-					 NETIF_F_HW_VLAN_STAG_TX)
+#define NETIF_VLAN_OFFLOAD_FEATURES	netdev_vlan_offload_features
 
 /**
  * iavf_set_features - set the netdev feature flags
@@ -4326,8 +4323,7 @@ iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 
 	/* Enable VLAN features if supported */
 	if (VLAN_ALLOWED(adapter)) {
-		hw_features |= (NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX);
+		hw_features |= netdev_ctag_vlan_offload_features;
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
 			&adapter->vlan_v2_caps;
@@ -4387,8 +4383,7 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 		return features;
 
 	if (VLAN_ALLOWED(adapter)) {
-		features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_TX;
+		features |= netdev_ctag_vlan_features;
 	} else if (VLAN_V2_ALLOWED(adapter)) {
 		struct virtchnl_vlan_caps *vlan_v2_caps =
 			&adapter->vlan_v2_caps;
@@ -4517,15 +4512,12 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
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
index 81d8e3057808..5c9333da4dfc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3351,9 +3351,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	netdev_features_zero(&csumo_features);
 	netdev_features_set_array(&ice_csumo_feature_set, &csumo_features);
 
-	vlano_features = NETIF_F_HW_VLAN_CTAG_FILTER |
-			 NETIF_F_HW_VLAN_CTAG_TX     |
-			 NETIF_F_HW_VLAN_CTAG_RX;
+	vlano_features = netdev_ctag_vlan_features;
 
 	/* Enable CTAG/STAG filtering by default in Double VLAN Mode (DVM) */
 	if (is_dvm_ena)
@@ -3390,8 +3388,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	 * ice_fix_features() ndo callback.
 	 */
 	if (is_dvm_ena)
-		netdev->hw_features |= NETIF_F_HW_VLAN_STAG_RX |
-			NETIF_F_HW_VLAN_STAG_TX;
+		netdev->hw_features |= netdev_stag_vlan_offload_features;
 }
 
 /**
@@ -5730,13 +5727,9 @@ ice_fdb_del(struct ndmsg *ndm, __always_unused struct nlattr *tb[],
 	return err;
 }
 
-#define NETIF_VLAN_OFFLOAD_FEATURES	(NETIF_F_HW_VLAN_CTAG_RX | \
-					 NETIF_F_HW_VLAN_CTAG_TX | \
-					 NETIF_F_HW_VLAN_STAG_RX | \
-					 NETIF_F_HW_VLAN_STAG_TX)
+#define NETIF_VLAN_OFFLOAD_FEATURES	netdev_vlan_offload_features
 
-#define NETIF_VLAN_FILTERING_FEATURES	(NETIF_F_HW_VLAN_CTAG_FILTER | \
-					 NETIF_F_HW_VLAN_STAG_FILTER)
+#define NETIF_VLAN_FILTERING_FEATURES	netdev_vlan_filter_features
 
 /**
  * ice_fix_features - fix the netdev features flags based on device limitations
@@ -5814,11 +5807,10 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
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
 
 	return features;
@@ -5843,14 +5835,14 @@ ice_set_vlan_offload_features(struct ice_vsi *vsi, netdev_features_t features)
 
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
@@ -5886,8 +5878,7 @@ ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
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
index 2fd8d8c94305..578663a47c93 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3310,10 +3310,9 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
 
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features |
-			       NETIF_F_HW_VLAN_CTAG_RX |
-			       NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_RXALL;
+	netdev->hw_features |= netdev->features;
+	netdev->hw_features |= netdev_ctag_vlan_offload_features;
+	netdev->hw_features |= NETIF_F_RXALL;
 
 	if (hw->mac.type >= e1000_i350)
 		netdev->hw_features |= NETIF_F_NTUPLE;
@@ -3325,9 +3324,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features |= netdev_ctag_vlan_features;
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 362e26df28b0..07c725474e32 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2803,9 +2803,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features |= netdev_ctag_vlan_features;
 
 	/* MTU range: 68 - 9216 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 98db7c46e89c..db008c8281ed 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11046,9 +11046,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->mpls_features |= gso_partial_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features |= netdev_ctag_vlan_features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 095159721a96..d46ab40b2b98 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4645,9 +4645,7 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
-			    NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features |= netdev_ctag_vlan_features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index a228447cbb2e..172c715415fa 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2719,11 +2719,9 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
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
index 08c82c0d41a4..9aa8fe79bb2b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -653,8 +653,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->features = netdev->hw_features;
 	/* Support TSO on tag interface */
 	netdev->vlan_features |= netdev->features;
-	netdev->hw_features  |= NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_STAG_TX;
+	netdev->hw_features  |= netdev_tx_vlan_features;
 	netdev->features |= netdev->hw_features;
 
 	netdev->hw_features |= NETIF_F_NTUPLE;
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index e3b3b2c7aff3..c9a4b1db43eb 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4346,7 +4346,7 @@ static int sky2_set_features(struct net_device *dev, netdev_features_t features)
 	if (changed & NETIF_F_RXHASH)
 		rx_set_rss(dev, features);
 
-	if (changed & (NETIF_F_HW_VLAN_CTAG_TX|NETIF_F_HW_VLAN_CTAG_RX))
+	if (changed & netdev_ctag_vlan_offload_features)
 		sky2_vlan_mode(dev, features);
 
 	return 0;
@@ -4653,8 +4653,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 		dev->hw_features |= NETIF_F_RXHASH;
 
 	if (!(hw->flags & SKY2_HW_VLAN_BROKEN)) {
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX;
+		dev->hw_features |= netdev_ctag_vlan_offload_features;
 		netdev_vlan_features_set_array(dev, &sky2_vlan_feature_set);
 	}
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 92c1de636128..e412cc11ed58 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3900,7 +3900,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 		eth->netdev[id]->hw_features |= NETIF_F_LRO;
 
 	eth->netdev[id]->vlan_features = *eth->soc->hw_features &
-		~(NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX);
+		~netdev_ctag_vlan_offload_features;
 	eth->netdev[id]->features |= *eth->soc->hw_features;
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 1d6e3b641b2e..738eaa88279a 100644
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
index 49ea130c9067..dba583d60d8e 100644
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
index 71c5363084e6..5b957cdc118e 100644
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
@@ -5824,8 +5824,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	np->vlanctl_bits = 0;
 	if (id->driver_data & DEV_HAS_VLAN) {
 		np->vlanctl_bits = NVREG_VLANCONTROL_ENABLE;
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX |
-				    NETIF_F_HW_VLAN_CTAG_TX;
+		dev->hw_features |= netdev_ctag_vlan_offload_features;
 	}
 
 	dev->features |= dev->hw_features;
@@ -6127,8 +6126,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
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
index c302d50324fb..15ffa63415e1 100644
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
index 0fb2070f592a..6ddacc6a7f7a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7198,11 +7198,9 @@ int stmmac_dvr_probe(struct device *device,
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
index 509c5e9b29df..1d795114c264 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -971,9 +971,7 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 		dev->features |= NETIF_F_SG|NETIF_F_HW_CSUM;
 
 	if (rp->quirks & rqMgmt)
-		dev->features |= NETIF_F_HW_VLAN_CTAG_TX |
-				 NETIF_F_HW_VLAN_CTAG_RX |
-				 NETIF_F_HW_VLAN_CTAG_FILTER;
+		dev->features |= netdev_ctag_vlan_features;
 
 	/* dev->name not defined before register_netdev()! */
 	rc = register_netdev(dev);
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 92ffd1b9849b..656a54a9f6e8 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -328,8 +328,7 @@ static void ifb_setup(struct net_device *dev)
 	dev->features |= ifb_features;
 	dev->hw_features |= dev->features;
 	dev->hw_enc_features |= dev->features;
-	dev->vlan_features |= ifb_features & ~(NETIF_F_HW_VLAN_CTAG_TX |
-					       NETIF_F_HW_VLAN_STAG_TX);
+	dev->vlan_features |= ifb_features & ~netdev_tx_vlan_features;
 
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index d6c2082d0993..50033364b2bd 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -755,9 +755,7 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 	failover_dev->features |= NETIF_F_NETNS_LOCAL;
 
 	failover_dev->hw_features = FAILOVER_VLAN_FEATURES |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX |
-				    NETIF_F_HW_VLAN_CTAG_FILTER;
+				    netdev_ctag_vlan_features;
 
 	failover_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	failover_dev->features |= failover_dev->hw_features;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 452d414dff62..eec3c8112d3f 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1024,9 +1024,8 @@ static void __team_compute_features(struct team *team)
 	rcu_read_unlock();
 
 	team->dev->vlan_features = vlan_features;
-	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				     NETIF_F_HW_VLAN_CTAG_TX |
-				     NETIF_F_HW_VLAN_STAG_TX;
+	team->dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
+	team->dev->hw_enc_features |= netdev_tx_vlan_features;
 	team->dev->hard_header_len = max_hard_header_len;
 
 	team->dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
@@ -2191,7 +2190,7 @@ static void team_setup(struct net_device *dev)
 
 	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	dev->features |= dev->hw_features;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
+	dev->features |= netdev_tx_vlan_features;
 }
 
 static int team_newlink(struct net *src_net, struct net_device *dev,
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d34d930a3029..194757bbd2b3 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1004,9 +1004,7 @@ static int tun_net_init(struct net_device *dev)
 	dev->hw_features = TUN_USER_FEATURES;
 	netdev_hw_features_set_array(dev, &tun_hw_feature_set);
 	dev->features = dev->hw_features | NETIF_F_LLTX;
-	dev->vlan_features = dev->features &
-			     ~(NETIF_F_HW_VLAN_CTAG_TX |
-			       NETIF_F_HW_VLAN_STAG_TX);
+	dev->vlan_features = dev->features & ~netdev_tx_vlan_features;
 
 	tun->flags = (tun->flags & ~TUN_FEATURES) |
 		      (ifr->ifr_flags & TUN_FEATURES);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 6de15832dafe..5978baef9695 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1650,11 +1650,7 @@ static void veth_setup(struct net_device *dev)
 	netdev_features_set_array(&veth_feature_set, &veth_features);
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
index b2f3fb5a29d5..ede0a87ca982 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3388,8 +3388,7 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 	}
 
 	netdev->vlan_features = netdev->hw_features &
-				~(NETIF_F_HW_VLAN_CTAG_TX |
-				  NETIF_F_HW_VLAN_CTAG_RX);
+				~netdev_ctag_vlan_offload_features;
 	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 639c05a175ba..f7b30abac5e9 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1907,8 +1907,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		return -ENODEV;
 
 	card->dev->needed_headroom = headroom;
-	card->dev->features |=	NETIF_F_HW_VLAN_CTAG_TX |
-				NETIF_F_HW_VLAN_CTAG_RX;
+	card->dev->features |= netdev_ctag_vlan_offload_features;
 
 	netif_keep_dst(card->dev);
 	if (card->dev->hw_features & netdev_general_tso_features)
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index a3576a11443d..89ce268d9d81 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4583,9 +4583,7 @@ static int qlge_probe(struct pci_dev *pdev,
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
index 8f78e6d297b8..1d5e13e2acb8 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -507,8 +507,7 @@ void br_dev_setup(struct net_device *dev)
 	netdev_features_set_array(&br_common_feature_set, &common_features);
 	dev->features = common_features;
 	netdev_active_features_set_array(dev, &br_feature_set);
-	dev->hw_features = common_features | NETIF_F_HW_VLAN_CTAG_TX |
-			   NETIF_F_HW_VLAN_STAG_TX;
+	dev->hw_features = common_features | netdev_tx_vlan_features;
 	dev->vlan_features = common_features;
 
 	br->dev = dev;
diff --git a/net/core/dev.c b/net/core/dev.c
index ae2c44624732..101a9d63d2fc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3565,8 +3565,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	if (skb_vlan_tagged(skb))
 		features = netdev_intersect_features(features,
 						     dev->vlan_features |
-						     NETIF_F_HW_VLAN_CTAG_TX |
-						     NETIF_F_HW_VLAN_STAG_TX);
+						     netdev_tx_vlan_features);
 
 	if (dev->netdev_ops->ndo_features_check)
 		features &= dev->netdev_ops->ndo_features_check(skb, dev,
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 1e401624908b..0459fe97ddd9 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -121,7 +121,7 @@ static void do_setup(struct net_device *netdev)
 
 	netdev->vlan_features = netdev->features;
 	netdev->hw_enc_features = netdev->features;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_STAG_TX;
+	netdev->features |= netdev_tx_vlan_features;
 	netdev->hw_features = netdev->features & ~NETIF_F_LLTX;
 
 	eth_hw_addr_random(netdev);
-- 
2.33.0

