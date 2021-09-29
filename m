Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8133741C8FF
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345766AbhI2QAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:39 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24128 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344002AbhI2P7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:44 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKLbC2T28z13Kht;
        Wed, 29 Sep 2021 23:56:39 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 011/167] net: convert the prototype of ndo_fix_features
Date:   Wed, 29 Sep 2021 23:50:58 +0800
Message-ID: <20210929155334.12454-12-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the origin type for netdev_features_t would be changed to
be unsigned long * from u64, so changes the prototype of
ndo_fix_features for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |  7 ++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  7 ++--
 drivers/net/bonding/bond_main.c               | 24 ++++++-------
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 28 +++++++--------
 drivers/net/ethernet/atheros/alx/main.c       |  8 ++---
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 14 ++++----
 .../net/ethernet/atheros/atl1e/atl1e_main.c   | 12 +++----
 drivers/net/ethernet/atheros/atlx/atl2.c      | 12 +++----
 drivers/net/ethernet/atheros/atlx/atlx.c      | 12 +++----
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 29 +++++++---------
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 27 +++++++--------
 drivers/net/ethernet/broadcom/tg3.c           |  8 ++---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 34 +++++++++----------
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 30 ++++++++--------
 .../net/ethernet/cavium/thunder/nicvf_main.c  | 10 +++---
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     | 11 +++---
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 12 +++----
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 10 +++---
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   | 12 +++----
 drivers/net/ethernet/cortina/gemini.c         |  8 ++---
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  7 ++--
 .../net/ethernet/huawei/hinic/hinic_main.c    | 10 +++---
 drivers/net/ethernet/ibm/ibmveth.c            | 10 +++---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 12 +++----
 drivers/net/ethernet/intel/e1000e/netdev.c    | 14 ++++----
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 ++---
 drivers/net/ethernet/intel/igb/igb_main.c     | 12 +++----
 drivers/net/ethernet/intel/igc/igc_main.c     | 12 +++----
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   | 10 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 ++++-----
 drivers/net/ethernet/jme.c                    |  7 ++--
 drivers/net/ethernet/marvell/mvneta.c         |  8 ++---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 12 +++----
 drivers/net/ethernet/marvell/sky2.c           | 16 ++++-----
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   | 10 +++---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 12 +++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 14 ++++----
 .../net/ethernet/neterion/vxge/vxge-main.c    | 10 +++---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c | 14 ++++----
 drivers/net/ethernet/nvidia/forcedeth.c       | 10 +++---
 .../ethernet/qlogic/netxen/netxen_nic_main.c  | 10 +++---
 drivers/net/ethernet/qlogic/qede/qede.h       |  3 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  9 ++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h   |  3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    | 15 ++++----
 drivers/net/ethernet/realtek/r8169_main.c     | 10 +++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 14 ++++----
 drivers/net/hyperv/netvsc_drv.c               | 12 +++----
 drivers/net/ipvlan/ipvlan_main.c              | 18 +++++-----
 drivers/net/macsec.c                          | 16 ++++-----
 drivers/net/macvlan.c                         | 20 +++++------
 drivers/net/team/team.c                       | 20 +++++------
 drivers/net/tun.c                             |  7 ++--
 drivers/net/veth.c                            | 10 +++---
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 10 +++---
 drivers/net/vmxnet3/vmxnet3_int.h             |  4 +--
 drivers/net/xen-netback/interface.c           | 16 ++++-----
 drivers/net/xen-netfront.c                    | 22 ++++++------
 drivers/s390/net/qeth_core.h                  |  2 +-
 drivers/s390/net/qeth_core_main.c             | 16 ++++-----
 include/linux/netdevice.h                     |  4 +--
 net/8021q/vlan_dev.c                          | 14 ++++----
 net/bridge/br_device.c                        |  5 ++-
 net/core/dev.c                                |  2 +-
 net/hsr/hsr_device.c                          |  6 ++--
 66 files changed, 349 insertions(+), 461 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index cde6db184c26..88cc24a58742 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1342,11 +1342,10 @@ static void vector_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	schedule_work(&vp->reset_tx);
 }
 
-static netdev_features_t vector_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void vector_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
-	features &= ~(NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
-	return features;
+	*features &= ~(NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM);
 }
 
 static int vector_set_features(struct net_device *dev,
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 0aa8629fdf62..488d50a82a87 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -214,14 +214,13 @@ static int ipoib_stop(struct net_device *dev)
 	return 0;
 }
 
-static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_features_t features)
+static void ipoib_fix_features(struct net_device *dev,
+			       netdev_features_t *features)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
-		features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
-
-	return features;
+		*features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
 }
 
 static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 77dc79a7f574..469509260a51 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1361,8 +1361,8 @@ static void bond_netpoll_cleanup(struct net_device *bond_dev)
 
 /*---------------------------------- IOCTL ----------------------------------*/
 
-static netdev_features_t bond_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void bond_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct bonding *bond = netdev_priv(dev);
 	struct list_head *iter;
@@ -1371,24 +1371,22 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
 	if (bond_sk_check(bond))
-		features |= BOND_TLS_FEATURES;
+		*features |= BOND_TLS_FEATURES;
 	else
-		features &= ~BOND_TLS_FEATURES;
+		*features &= ~BOND_TLS_FEATURES;
 #endif
 
-	mask = features;
+	mask = *features;
 
-	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	*features &= ~NETIF_F_ONE_FOR_ALL;
+	*features |= NETIF_F_ALL_FOR_ALL;
 
 	bond_for_each_slave(bond, slave, iter) {
-		features = netdev_increment_features(features,
-						     slave->dev->features,
-						     mask);
+		*features = netdev_increment_features(*features,
+						      slave->dev->features,
+						      mask);
 	}
-	features = netdev_add_tso_features(features, mask);
-
-	return features;
+	*features = netdev_add_tso_features(*features, mask);
 }
 
 #define BOND_VLAN_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index cc1f1a7a46ae..dff9eecac6e9 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2182,8 +2182,8 @@ static int xgbe_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	return 0;
 }
 
-static netdev_features_t xgbe_fix_features(struct net_device *netdev,
-					   netdev_features_t features)
+static void xgbe_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	netdev_features_t vxlan_base;
@@ -2191,38 +2191,36 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	vxlan_base = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_RX_UDP_TUNNEL_PORT;
 
 	if (!pdata->hw_feat.vxn)
-		return features;
+		return;
 
 	/* VXLAN CSUM requires VXLAN base */
-	if ((features & NETIF_F_GSO_UDP_TUNNEL_CSUM) &&
-	    !(features & NETIF_F_GSO_UDP_TUNNEL)) {
+	if ((*features & NETIF_F_GSO_UDP_TUNNEL_CSUM) &&
+	    !(*features & NETIF_F_GSO_UDP_TUNNEL)) {
 		netdev_notice(netdev,
 			      "forcing tx udp tunnel support\n");
-		features |= NETIF_F_GSO_UDP_TUNNEL;
+		*features |= NETIF_F_GSO_UDP_TUNNEL;
 	}
 
 	/* Can't do one without doing the other */
-	if ((features & vxlan_base) != vxlan_base) {
+	if ((*features & vxlan_base) != vxlan_base) {
 		netdev_notice(netdev,
 			      "forcing both tx and rx udp tunnel support\n");
-		features |= vxlan_base;
+		*features |= vxlan_base;
 	}
 
-	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
-		if (!(features & NETIF_F_GSO_UDP_TUNNEL_CSUM)) {
+	if (*features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+		if (!(*features & NETIF_F_GSO_UDP_TUNNEL_CSUM)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming on\n");
-			features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			*features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		}
 	} else {
-		if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM) {
+		if (*features & NETIF_F_GSO_UDP_TUNNEL_CSUM) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming off\n");
-			features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			*features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		}
 	}
-
-	return features;
 }
 
 static int xgbe_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 4ea157efca86..922c600fd292 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1097,13 +1097,11 @@ static int alx_init_sw(struct alx_priv *alx)
 }
 
 
-static netdev_features_t alx_fix_features(struct net_device *netdev,
-					  netdev_features_t features)
+static void alx_fix_features(struct net_device *netdev,
+			     netdev_features_t *features)
 {
 	if (netdev->mtu > ALX_MAX_TSO_PKT_SIZE)
-		features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
-
-	return features;
+		*features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
 }
 
 static void alx_netif_stop(struct alx_priv *alx)
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 1c258e4ddc96..66c0985adb43 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -504,8 +504,8 @@ static void atl1c_set_rxbufsize(struct atl1c_adapter *adapter,
 	adapter->rx_frag_size = roundup_pow_of_two(head_size);
 }
 
-static netdev_features_t atl1c_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void atl1c_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 	struct atl1c_hw *hw = &adapter->hw;
@@ -514,17 +514,15 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
 	if (hw->nic_type != athr_mt) {
 		if (netdev->mtu > MAX_TSO_FRAME_SIZE)
-			features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+			*features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
 	}
-
-	return features;
 }
 
 static int atl1c_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 2e22483a9040..ea99949c91eb 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -382,19 +382,17 @@ static int atl1e_set_mac_addr(struct net_device *netdev, void *p)
 	return 0;
 }
 
-static netdev_features_t atl1e_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void atl1e_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int atl1e_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index b69298ddb647..c4d303ce284c 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -371,19 +371,17 @@ static void atl2_restore_vlan(struct atl2_adapter *adapter)
 	atl2_vlan_mode(adapter->netdev, adapter->netdev->features);
 }
 
-static netdev_features_t atl2_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void atl2_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int atl2_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index 0941d07d0833..3b0dbc3a5896 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -237,19 +237,17 @@ static void atlx_restore_vlan(struct atlx_adapter *adapter)
 	atlx_vlan_mode(adapter->netdev, adapter->netdev->features);
 }
 
-static netdev_features_t atlx_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void atlx_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int atlx_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index b5d954cb409a..d74510306068 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4899,38 +4899,35 @@ int bnx2x_change_mtu(struct net_device *dev, int new_mtu)
 	return bnx2x_reload_if_running(dev);
 }
 
-netdev_features_t bnx2x_fix_features(struct net_device *dev,
-				     netdev_features_t features)
+void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 
 	if (pci_num_vf(bp->pdev)) {
-		netdev_features_t changed = dev->features ^ features;
+		netdev_features_t changed = dev->features ^ *features;
 
 		/* Revert the requested changes in features if they
 		 * would require internal reload of PF in bnx2x_set_features().
 		 */
-		if (!(features & NETIF_F_RXCSUM) && !bp->disable_tpa) {
-			features &= ~NETIF_F_RXCSUM;
-			features |= dev->features & NETIF_F_RXCSUM;
+		if (!(*features & NETIF_F_RXCSUM) && !bp->disable_tpa) {
+			*features &= ~NETIF_F_RXCSUM;
+			*features |= dev->features & NETIF_F_RXCSUM;
 		}
 
 		if (changed & NETIF_F_LOOPBACK) {
-			features &= ~NETIF_F_LOOPBACK;
-			features |= dev->features & NETIF_F_LOOPBACK;
+			*features &= ~NETIF_F_LOOPBACK;
+			*features |= dev->features & NETIF_F_LOOPBACK;
 		}
 	}
 
 	/* TPA requires Rx CSUM offloading */
-	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_LRO;
+	if (!(*features & NETIF_F_RXCSUM))
+		*features &= ~NETIF_F_LRO;
 
-	if (!(features & NETIF_F_GRO) || !bnx2x_mtu_allows_gro(dev->mtu))
-		features &= ~NETIF_F_GRO_HW;
-	if (features & NETIF_F_GRO_HW)
-		features &= ~NETIF_F_LRO;
-
-	return features;
+	if (!(*features & NETIF_F_GRO) || !bnx2x_mtu_allows_gro(dev->mtu))
+		*features &= ~NETIF_F_GRO_HW;
+	if (*features & NETIF_F_GRO_HW)
+		*features &= ~NETIF_F_LRO;
 }
 
 int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index d8b1824c334d..4c66ef3e04bf 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -606,8 +606,7 @@ int bnx2x_change_mtu(struct net_device *dev, int new_mtu);
 int bnx2x_fcoe_get_wwn(struct net_device *dev, u64 *wwn, int type);
 #endif
 
-netdev_features_t bnx2x_fix_features(struct net_device *dev,
-				     netdev_features_t features);
+void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features);
 int bnx2x_set_features(struct net_device *dev, netdev_features_t features);
 
 /**
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4689d053aff8..7d9166876e95 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10894,39 +10894,38 @@ static bool bnxt_rfs_capable(struct bnxt *bp)
 #endif
 }
 
-static netdev_features_t bnxt_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void bnxt_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	netdev_features_t vlan_features;
 
-	if ((features & NETIF_F_NTUPLE) && !bnxt_rfs_capable(bp))
-		features &= ~NETIF_F_NTUPLE;
+	if ((*features & NETIF_F_NTUPLE) && !bnxt_rfs_capable(bp))
+		*features &= ~NETIF_F_NTUPLE;
 
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
-		features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		*features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
 
-	if (!(features & NETIF_F_GRO))
-		features &= ~NETIF_F_GRO_HW;
+	if (!(*features & NETIF_F_GRO))
+		*features &= ~NETIF_F_GRO_HW;
 
-	if (features & NETIF_F_GRO_HW)
-		features &= ~NETIF_F_LRO;
+	if (*features & NETIF_F_GRO_HW)
+		*features &= ~NETIF_F_LRO;
 
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
 	 */
-	vlan_features = features & BNXT_HW_FEATURE_VLAN_ALL_RX;
+	vlan_features = *features & BNXT_HW_FEATURE_VLAN_ALL_RX;
 	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
 		if (dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)
-			features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
+			*features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
 		else if (vlan_features)
-			features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
+			*features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
 	}
 #ifdef CONFIG_BNXT_SRIOV
 	if (BNXT_VF(bp) && bp->vf.vlan)
-		features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
+		*features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
 #endif
-	return features;
 }
 
 static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5e0e0e70d801..df0d6a35f093 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8302,15 +8302,13 @@ static void tg3_set_loopback(struct net_device *dev, netdev_features_t features)
 	}
 }
 
-static netdev_features_t tg3_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void tg3_fix_features(struct net_device *dev,
+			     netdev_features_t *features)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
 	if (dev->mtu > ETH_DATA_LEN && tg3_flag(tp, 5780_CLASS))
-		features &= ~NETIF_F_ALL_TSO;
-
-	return features;
+		*features &= ~NETIF_F_ALL_TSO;
 }
 
 static int tg3_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index dafc79bd34f4..43c256ad2790 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2718,38 +2718,36 @@ static const struct udp_tunnel_nic_info liquidio_udp_tunnels = {
  * @request: features requested
  * Return: updated features list
  */
-static netdev_features_t liquidio_fix_features(struct net_device *netdev,
-					       netdev_features_t request)
+static void liquidio_fix_features(struct net_device *netdev,
+				  netdev_features_t *request)
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if ((request & NETIF_F_RXCSUM) &&
+	if ((*request & NETIF_F_RXCSUM) &&
 	    !(lio->dev_capability & NETIF_F_RXCSUM))
-		request &= ~NETIF_F_RXCSUM;
+		*request &= ~NETIF_F_RXCSUM;
 
-	if ((request & NETIF_F_HW_CSUM) &&
+	if ((*request & NETIF_F_HW_CSUM) &&
 	    !(lio->dev_capability & NETIF_F_HW_CSUM))
-		request &= ~NETIF_F_HW_CSUM;
+		*request &= ~NETIF_F_HW_CSUM;
 
-	if ((request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
-		request &= ~NETIF_F_TSO;
+	if ((*request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
+		*request &= ~NETIF_F_TSO;
 
-	if ((request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
-		request &= ~NETIF_F_TSO6;
+	if ((*request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
+		*request &= ~NETIF_F_TSO6;
 
-	if ((request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
-		request &= ~NETIF_F_LRO;
+	if ((*request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
+		*request &= ~NETIF_F_LRO;
 
 	/*Disable LRO if RXCSUM is off */
-	if (!(request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
+	if (!(*request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
 	    (lio->dev_capability & NETIF_F_LRO))
-		request &= ~NETIF_F_LRO;
+		*request &= ~NETIF_F_LRO;
 
-	if ((request & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if ((*request & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    !(lio->dev_capability & NETIF_F_HW_VLAN_CTAG_FILTER))
-		request &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-
-	return request;
+		*request &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
 /**
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index f6396ac64006..1c4c039dff9b 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1815,34 +1815,32 @@ static const struct udp_tunnel_nic_info liquidio_udp_tunnels = {
  * @param request features requested
  * @returns updated features list
  */
-static netdev_features_t liquidio_fix_features(struct net_device *netdev,
-					       netdev_features_t request)
+static void liquidio_fix_features(struct net_device *netdev,
+				  netdev_features_t *request)
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if ((request & NETIF_F_RXCSUM) &&
+	if ((*request & NETIF_F_RXCSUM) &&
 	    !(lio->dev_capability & NETIF_F_RXCSUM))
-		request &= ~NETIF_F_RXCSUM;
+		*request &= ~NETIF_F_RXCSUM;
 
-	if ((request & NETIF_F_HW_CSUM) &&
+	if ((*request & NETIF_F_HW_CSUM) &&
 	    !(lio->dev_capability & NETIF_F_HW_CSUM))
-		request &= ~NETIF_F_HW_CSUM;
+		*request &= ~NETIF_F_HW_CSUM;
 
-	if ((request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
-		request &= ~NETIF_F_TSO;
+	if ((*request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
+		*request &= ~NETIF_F_TSO;
 
-	if ((request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
-		request &= ~NETIF_F_TSO6;
+	if ((*request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
+		*request &= ~NETIF_F_TSO6;
 
-	if ((request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
-		request &= ~NETIF_F_LRO;
+	if ((*request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
+		*request &= ~NETIF_F_LRO;
 
 	/* Disable LRO if RXCSUM is off */
-	if (!(request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
+	if (!(*request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
 	    (lio->dev_capability & NETIF_F_LRO))
-		request &= ~NETIF_F_LRO;
-
-	return request;
+		*request &= ~NETIF_F_LRO;
 }
 
 /** \brief Net device set features
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 2b87565781a0..781138a71458 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1773,16 +1773,14 @@ static int nicvf_config_loopback(struct nicvf *nic,
 	return nicvf_send_msg_to_pf(nic, &mbx);
 }
 
-static netdev_features_t nicvf_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void nicvf_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 
-	if ((features & NETIF_F_LOOPBACK) &&
+	if ((*features & NETIF_F_LOOPBACK) &&
 	    netif_running(netdev) && !nic->loopback_supported)
-		features &= ~NETIF_F_LOOPBACK;
-
-	return features;
+		*features &= ~NETIF_F_LOOPBACK;
 }
 
 static int nicvf_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index d246eee4b6d5..3fcd628fa449 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -858,19 +858,16 @@ static int t1_set_mac_addr(struct net_device *dev, void *p)
 	return 0;
 }
 
-static netdev_features_t t1_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void t1_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int t1_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 38e47703f9ab..140b40e5c54c 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2593,19 +2593,17 @@ static int cxgb_set_mac_addr(struct net_device *dev, void *p)
 	return 0;
 }
 
-static netdev_features_t cxgb_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void cxgb_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index a654169b9dfc..238416724a7c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3851,14 +3851,12 @@ static void cxgb_features_check(struct sk_buff *skb, struct net_device *dev,
 	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
-static netdev_features_t cxgb_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void cxgb_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	/* Disable GRO, if RX_CSUM is disabled */
-	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_GRO;
-
-	return features;
+	if (!(*features & NETIF_F_RXCSUM))
+		*features &= ~NETIF_F_GRO;
 }
 
 static const struct net_device_ops cxgb4_netdev_ops = {
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 4920a80a0460..6d46d460a0a1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1173,19 +1173,17 @@ static int cxgb4vf_change_mtu(struct net_device *dev, int new_mtu)
 	return ret;
 }
 
-static netdev_features_t cxgb4vf_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void cxgb4vf_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	/*
 	 * Since there is no support for separate rx/tx vlan accel
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int cxgb4vf_set_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 6e745ca4c433..44397d1f44e4 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1976,13 +1976,11 @@ static int gmac_change_mtu(struct net_device *netdev, int new_mtu)
 	return 0;
 }
 
-static netdev_features_t gmac_fix_features(struct net_device *netdev,
-					   netdev_features_t features)
+static void gmac_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	if (netdev->mtu + ETH_HLEN + VLAN_HLEN > MTU_SIZE_BIT_MASK)
-		features &= ~GMAC_OFFLOAD_FEATURES;
-
-	return features;
+		*features &= ~GMAC_OFFLOAD_FEATURES;
 }
 
 static int gmac_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 343c605c4be8..1e08c18c813f 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1793,20 +1793,19 @@ static int hns_nic_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t hns_nic_fix_features(
-		struct net_device *netdev, netdev_features_t features)
+static void hns_nic_fix_features(struct net_device *netdev,
+				 netdev_features_t *features)
 {
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		features &= ~(NETIF_F_TSO | NETIF_F_TSO6 |
+		*features &= ~(NETIF_F_TSO | NETIF_F_TSO6 |
 				NETIF_F_HW_VLAN_CTAG_FILTER);
 		break;
 	default:
 		break;
 	}
-	return features;
 }
 
 static int hns_nic_uc_sync(struct net_device *netdev, const unsigned char *addr)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 9965e8d5d0a9..cce66faa477c 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -888,18 +888,16 @@ static int hinic_set_features(struct net_device *netdev,
 			    features, false);
 }
 
-static netdev_features_t hinic_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void hinic_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!(*features & NETIF_F_RXCSUM)) {
 		netif_info(nic_dev, drv, netdev, "disabling LRO as RXCSUM is off\n");
-		features &= ~NETIF_F_LRO;
+		*features &= ~NETIF_F_LRO;
 	}
-
-	return features;
 }
 
 static const struct net_device_ops hinic_netdev_ops = {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 3aedb680adb8..7884d17d666f 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -742,8 +742,8 @@ static void netdev_get_drvinfo(struct net_device *dev,
 	strlcpy(info->version, ibmveth_driver_version, sizeof(info->version));
 }
 
-static netdev_features_t ibmveth_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void ibmveth_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	/*
 	 * Since the ibmveth firmware interface does not have the
@@ -754,10 +754,8 @@ static netdev_features_t ibmveth_fix_features(struct net_device *dev,
 	 * checksummed.
 	 */
 
-	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_CSUM_MASK;
-
-	return features;
+	if (!(*features & NETIF_F_RXCSUM))
+		*features &= ~NETIF_F_CSUM_MASK;
 }
 
 static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index bed4f040face..e333ca1e7395 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -787,18 +787,16 @@ static int e1000_is_need_ioport(struct pci_dev *pdev)
 	}
 }
 
-static netdev_features_t e1000_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void e1000_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int e1000_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 900b3ab998bd..5dd183e0cb0f 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7287,25 +7287,23 @@ static void e1000_eeprom_checks(struct e1000_adapter *adapter)
 	}
 }
 
-static netdev_features_t e1000_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void e1000_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 
 	/* Jumbo frame workaround on 82579 and newer requires CRC be stripped */
 	if ((hw->mac.type >= e1000_pch2lan) && (netdev->mtu > ETH_DATA_LEN))
-		features &= ~NETIF_F_RXFCS;
+		*features &= ~NETIF_F_RXFCS;
 
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int e1000_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index b066f1864b3f..9a086211af4a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3437,17 +3437,15 @@ static void iavf_features_check(struct sk_buff *skb, struct net_device *dev,
  *
  * Returns fixed-up features bits
  **/
-static netdev_features_t iavf_fix_features(struct net_device *netdev,
-					   netdev_features_t features)
+static void iavf_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
 	if (!(adapter->vf_res->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN))
-		features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
+		*features &= ~(NETIF_F_HW_VLAN_CTAG_TX |
 			      NETIF_F_HW_VLAN_CTAG_RX |
 			      NETIF_F_HW_VLAN_CTAG_FILTER);
-
-	return features;
 }
 
 static const struct net_device_ops iavf_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 82b59adf8034..2e4a53c76c60 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2433,18 +2433,16 @@ void igb_reset(struct igb_adapter *adapter)
 	igb_get_phy_info(hw);
 }
 
-static netdev_features_t igb_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+static void igb_fix_features(struct net_device *netdev,
+			     netdev_features_t *features)
 {
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int igb_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index fdb3ed051456..13b89a742ebc 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4915,18 +4915,16 @@ static void igc_get_stats64(struct net_device *netdev,
 	spin_unlock(&adapter->stats64_lock);
 }
 
-static netdev_features_t igc_fix_features(struct net_device *netdev,
-					  netdev_features_t features)
+static void igc_fix_features(struct net_device *netdev,
+			     netdev_features_t *features)
 {
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_CTAG_TX;
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int igc_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 1588376d4c67..34c1bfc75b7b 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -293,17 +293,15 @@ ixgb_reset(struct ixgb_adapter *adapter)
 	}
 }
 
-static netdev_features_t
-ixgb_fix_features(struct net_device *netdev, netdev_features_t features)
+static void ixgb_fix_features(struct net_device *netdev,
+			      netdev_features_t *features)
 {
 	/*
 	 * Tx VLAN insertion does not work per HW design when Rx stripping is
 	 * disabled.
 	 */
-	if (!(features & NETIF_F_HW_VLAN_CTAG_RX))
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-
-	return features;
+	if (!(*features & NETIF_F_HW_VLAN_CTAG_RX))
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 }
 
 static int
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index e39d3983a455..c43c99a44914 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9682,25 +9682,23 @@ void ixgbe_do_reset(struct net_device *netdev)
 		ixgbe_reset(adapter);
 }
 
-static netdev_features_t ixgbe_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void ixgbe_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
 	/* If Rx checksum is disabled, then RSC/LRO should also be disabled */
-	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_LRO;
+	if (!(*features & NETIF_F_RXCSUM))
+		*features &= ~NETIF_F_LRO;
 
 	/* Turn off LRO if not RSC capable */
 	if (!(adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE))
-		features &= ~NETIF_F_LRO;
+		*features &= ~NETIF_F_LRO;
 
-	if (adapter->xdp_prog && (features & NETIF_F_LRO)) {
+	if (adapter->xdp_prog && (*features & NETIF_F_LRO)) {
 		e_dev_err("LRO is not supported with XDP\n");
-		features &= ~NETIF_F_LRO;
+		*features &= ~NETIF_F_LRO;
 	}
-
-	return features;
 }
 
 static void ixgbe_reset_l2fw_offload(struct ixgbe_adapter *adapter)
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 1bdc4f23e1e5..11749bd7276d 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2659,12 +2659,11 @@ jme_set_msglevel(struct net_device *netdev, u32 value)
 	jme->msg_enable = value;
 }
 
-static netdev_features_t
-jme_fix_features(struct net_device *netdev, netdev_features_t features)
+static void jme_fix_features(struct net_device *netdev,
+			     netdev_features_t *features)
 {
 	if (netdev->mtu > 1900)
-		features &= ~(NETIF_F_ALL_TSO | NETIF_F_CSUM_MASK);
-	return features;
+		*features &= ~(NETIF_F_ALL_TSO | NETIF_F_CSUM_MASK);
 }
 
 static int
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 9d460a270601..a4093977cd2b 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3770,19 +3770,17 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 }
 
-static netdev_features_t mvneta_fix_features(struct net_device *dev,
-					     netdev_features_t features)
+static void mvneta_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 
 	if (pp->tx_csum_limit && dev->mtu > pp->tx_csum_limit) {
-		features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
+		*features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
 		netdev_info(dev,
 			    "Disable IP checksum for MTU greater than %dB\n",
 			    pp->tx_csum_limit);
 	}
-
-	return features;
 }
 
 /* Get mac address */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index ab07964dbf0a..cf4513ec02e6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1813,15 +1813,13 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
-static netdev_features_t otx2_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void otx2_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
-	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_STAG_RX;
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX)
+		*features |= NETIF_F_HW_VLAN_STAG_RX;
 	else
-		features &= ~NETIF_F_HW_VLAN_STAG_RX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_STAG_RX;
 }
 
 static void otx2_set_rx_mode(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 3cb9c1271328..8b1af582c250 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4358,8 +4358,8 @@ static int sky2_set_eeprom(struct net_device *dev, struct ethtool_eeprom *eeprom
 	return sky2_vpd_write(sky2->hw, cap, data, eeprom->offset, eeprom->len);
 }
 
-static netdev_features_t sky2_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void sky2_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	const struct sky2_port *sky2 = netdev_priv(dev);
 	const struct sky2_hw *hw = sky2->hw;
@@ -4369,18 +4369,16 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 	 */
 	if (dev->mtu > ETH_DATA_LEN && hw->chip_id == CHIP_ID_YUKON_EC_U) {
 		netdev_info(dev, "checksum offload not possible with jumbo frames\n");
-		features &= ~(NETIF_F_TSO | NETIF_F_SG | NETIF_F_CSUM_MASK);
+		*features &= ~(NETIF_F_TSO | NETIF_F_SG | NETIF_F_CSUM_MASK);
 	}
 
 	/* Some hardware requires receive checksum for RSS to work. */
-	if ( (features & NETIF_F_RXHASH) &&
-	     !(features & NETIF_F_RXCSUM) &&
-	     (sky2->hw->flags & SKY2_HW_RSS_CHKSUM)) {
+	if ((*features & NETIF_F_RXHASH) &&
+	    !(*features & NETIF_F_RXCSUM) &&
+	    (sky2->hw->flags & SKY2_HW_RSS_CHKSUM)) {
 		netdev_info(dev, "receive hashing forces receive checksum\n");
-		features |= NETIF_F_RXCSUM;
+		*features |= NETIF_F_RXCSUM;
 	}
-
-	return features;
 }
 
 static int sky2_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 398c23cec815..6a6ef1c29657 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2021,21 +2021,19 @@ static int mtk_hwlro_get_fdir_all(struct net_device *dev,
 	return 0;
 }
 
-static netdev_features_t mtk_fix_features(struct net_device *dev,
-					  netdev_features_t features)
+static void mtk_fix_features(struct net_device *dev,
+			     netdev_features_t *features)
 {
-	if (!(features & NETIF_F_LRO)) {
+	if (!(*features & NETIF_F_LRO)) {
 		struct mtk_mac *mac = netdev_priv(dev);
 		int ip_cnt = mtk_hwlro_get_ip_cnt(mac);
 
 		if (ip_cnt) {
 			netdev_info(dev, "RX flow is programmed, LRO should keep on\n");
 
-			features |= NETIF_F_LRO;
+			*features |= NETIF_F_LRO;
 		}
 	}
-
-	return features;
 }
 
 static int mtk_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 354c63aa726d..5d95e878bad2 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2493,8 +2493,8 @@ static int mlx4_en_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	}
 }
 
-static netdev_features_t mlx4_en_fix_features(struct net_device *netdev,
-					      netdev_features_t features)
+static void mlx4_en_fix_features(struct net_device *netdev,
+				 netdev_features_t *features)
 {
 	struct mlx4_en_priv *en_priv = netdev_priv(netdev);
 	struct mlx4_en_dev *mdev = en_priv->mdev;
@@ -2503,13 +2503,11 @@ static netdev_features_t mlx4_en_fix_features(struct net_device *netdev,
 	 * enable/disable make sure S-TAG flag is always in same state as
 	 * C-TAG.
 	 */
-	if (features & NETIF_F_HW_VLAN_CTAG_RX &&
+	if (*features & NETIF_F_HW_VLAN_CTAG_RX &&
 	    !(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
-		features |= NETIF_F_HW_VLAN_STAG_RX;
+		*features |= NETIF_F_HW_VLAN_STAG_RX;
 	else
-		features &= ~NETIF_F_HW_VLAN_STAG_RX;
-
-	return features;
+		*features &= ~NETIF_F_HW_VLAN_STAG_RX;
 }
 
 static int mlx4_en_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 6fdc2a793c1f..4092210fb079 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3397,8 +3397,8 @@ static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev
 	return features;
 }
 
-static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
-					    netdev_features_t features)
+static void mlx5e_fix_features(struct net_device *netdev,
+			       netdev_features_t *features)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_params *params;
@@ -3410,20 +3410,20 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		/* HW strips the outer C-tag header, this is a problem
 		 * for S-tag traffic.
 		 */
-		features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		*features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 		if (!params->vlan_strip_disable)
 			netdev_warn(netdev, "Dropping C-tag vlan stripping offload due to S-tag vlan\n");
 	}
 
 	if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
-		if (features & NETIF_F_LRO) {
+		if (*features & NETIF_F_LRO) {
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
-			features &= ~NETIF_F_LRO;
+			*features &= ~NETIF_F_LRO;
 		}
 	}
 
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-		features &= ~NETIF_F_RXHASH;
+		*features &= ~NETIF_F_RXHASH;
 		if (netdev->features & NETIF_F_RXHASH)
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
 	}
@@ -3432,8 +3432,6 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		features = mlx5e_fix_uplink_rep_features(netdev, features);
 
 	mutex_unlock(&priv->state_lock);
-
-	return features;
 }
 
 static bool mlx5e_xsk_validate_mtu(struct net_device *netdev,
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index df4a3f3da83a..5f720e97a558 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2639,19 +2639,17 @@ static void vxge_poll_vp_lockup(struct timer_list *t)
 	mod_timer(&vdev->vp_lockup_timer, jiffies + HZ / 1000);
 }
 
-static netdev_features_t vxge_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void vxge_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = dev->features ^ *features;
 
 	/* Enabling RTH requires some of the logic in vxge_device_register and a
 	 * vpath reset.  Due to these restrictions, only allow modification
 	 * while the interface is down.
 	 */
 	if ((changed & NETIF_F_RXHASH) && netif_running(dev))
-		features ^= NETIF_F_RXHASH;
-
-	return features;
+		*features ^= NETIF_F_RXHASH;
 }
 
 static int vxge_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index f04b79f04a9d..fcb2e30e8ac7 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -232,11 +232,11 @@ static int nfp_repr_open(struct net_device *netdev)
 	return err;
 }
 
-static netdev_features_t
-nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
+static void nfp_repr_fix_features(struct net_device *netdev,
+				  netdev_features_t *features)
 {
 	struct nfp_repr *repr = netdev_priv(netdev);
-	netdev_features_t old_features = features;
+	netdev_features_t old_features = *features;
 	netdev_features_t lower_features;
 	struct net_device *lower_dev;
 
@@ -246,11 +246,9 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	if (lower_features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM))
 		lower_features |= NETIF_F_HW_CSUM;
 
-	netdev_intersect_features(&features, features, lower_features);
-	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_HW_TC);
-	features |= NETIF_F_LLTX;
-
-	return features;
+	netdev_intersect_features(features, *features, lower_features);
+	*features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_HW_TC);
+	*features |= NETIF_F_LLTX;
 }
 
 const struct net_device_ops nfp_repr_netdev_ops = {
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index ef3fb4cc90af..e1f16988cb75 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4920,14 +4920,12 @@ static int nv_set_loopback(struct net_device *dev, netdev_features_t features)
 	return retval;
 }
 
-static netdev_features_t nv_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void nv_fix_features(struct net_device *dev,
+			    netdev_features_t *features)
 {
 	/* vlan is dependent on rx checksum offload */
-	if (features & (NETIF_F_HW_VLAN_CTAG_TX|NETIF_F_HW_VLAN_CTAG_RX))
-		features |= NETIF_F_RXCSUM;
-
-	return features;
+	if (*features & (NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX))
+		*features |= NETIF_F_RXCSUM;
 }
 
 static void nv_vlan_mode(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 344ea1143454..251668839926 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -517,16 +517,14 @@ static void netxen_set_multicast_list(struct net_device *dev)
 	adapter->set_multi(dev);
 }
 
-static netdev_features_t netxen_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void netxen_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
-	if (!(features & NETIF_F_RXCSUM)) {
+	if (!(*features & NETIF_F_RXCSUM)) {
 		netdev_info(dev, "disabling LRO as RXCSUM is off\n");
 
-		features &= ~NETIF_F_LRO;
+		*features &= ~NETIF_F_LRO;
 	}
-
-	return features;
 }
 
 static int netxen_set_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index c1f26a2e374d..ada71452d454 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -545,8 +545,7 @@ int qede_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid);
 void qede_vlan_mark_nonconfigured(struct qede_dev *edev);
 int qede_configure_vlan_filters(struct qede_dev *edev);
 
-netdev_features_t qede_fix_features(struct net_device *dev,
-				    netdev_features_t features);
+void qede_fix_features(struct net_device *dev, netdev_features_t *features);
 int qede_set_features(struct net_device *dev, netdev_features_t features);
 void qede_set_rx_mode(struct net_device *ndev);
 void qede_config_rx_mode(struct net_device *ndev);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index f99b085b56a5..ea89a3afa206 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -910,16 +910,13 @@ static void qede_set_features_reload(struct qede_dev *edev,
 	edev->ndev->features = args->u.features;
 }
 
-netdev_features_t qede_fix_features(struct net_device *dev,
-				    netdev_features_t features)
+void qede_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 
 	if (edev->xdp_prog || edev->ndev->mtu > PAGE_SIZE ||
-	    !(features & NETIF_F_GRO))
-		features &= ~NETIF_F_GRO_HW;
-
-	return features;
+	    !(*features & NETIF_F_GRO))
+		*features &= ~NETIF_F_GRO_HW;
 }
 
 int qede_set_features(struct net_device *dev, netdev_features_t features)
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
index be7abee160e7..7fbf895becdd 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
@@ -1622,8 +1622,7 @@ int qlcnic_82xx_read_phys_port_id(struct qlcnic_adapter *);
 int qlcnic_fw_cmd_set_mtu(struct qlcnic_adapter *adapter, int mtu);
 int qlcnic_fw_cmd_set_drv_version(struct qlcnic_adapter *, u32);
 int qlcnic_change_mtu(struct net_device *netdev, int new_mtu);
-netdev_features_t qlcnic_fix_features(struct net_device *netdev,
-	netdev_features_t features);
+void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features);
 int qlcnic_set_features(struct net_device *netdev, netdev_features_t features);
 int qlcnic_config_bridged_mode(struct qlcnic_adapter *adapter, u32 enable);
 void qlcnic_update_cmd_producer(struct qlcnic_host_tx_ring *);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 4b8bc46f55c2..e6ed7f8413b4 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1053,8 +1053,7 @@ static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 	return features;
 }
 
-netdev_features_t qlcnic_fix_features(struct net_device *netdev,
-	netdev_features_t features)
+void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed;
@@ -1062,10 +1061,10 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 	if (qlcnic_82xx_check(adapter) &&
 	    (adapter->flags & QLCNIC_ESWITCH_ENABLED)) {
 		if (adapter->flags & QLCNIC_APP_CHANGED_FLAGS) {
-			features = qlcnic_process_flags(adapter, features);
+			*features = qlcnic_process_flags(adapter, *features);
 		} else {
-			changed = features ^ netdev->features;
-			features ^= changed & (NETIF_F_RXCSUM |
+			changed = *features ^ netdev->features;
+			*features ^= changed & (NETIF_F_RXCSUM |
 					       NETIF_F_IP_CSUM |
 					       NETIF_F_IPV6_CSUM |
 					       NETIF_F_TSO |
@@ -1073,10 +1072,8 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 		}
 	}
 
-	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_LRO;
-
-	return features;
+	if (!(*features & NETIF_F_RXCSUM))
+		*features &= ~NETIF_F_LRO;
 }
 
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3d753ddd1a89..8affae2b55a6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1431,19 +1431,17 @@ static int rtl8169_get_regs_len(struct net_device *dev)
 	return R8169_REGS_SIZE;
 }
 
-static netdev_features_t rtl8169_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void rtl8169_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (dev->mtu > TD_MSS_MAX)
-		features &= ~NETIF_F_ALL_TSO;
+		*features &= ~NETIF_F_ALL_TSO;
 
 	if (dev->mtu > ETH_DATA_LEN &&
 	    tp->mac_version > RTL_GIGA_MAC_VER_06)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_ALL_TSO);
-
-	return features;
+		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_ALL_TSO);
 }
 
 static void rtl_set_rx_config_features(struct rtl8169_private *tp,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fd4c6517125e..aa977cac3c10 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5461,16 +5461,16 @@ static int stmmac_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static netdev_features_t stmmac_fix_features(struct net_device *dev,
-					     netdev_features_t features)
+static void stmmac_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 
 	if (priv->plat->rx_coe == STMMAC_RX_COE_NONE)
-		features &= ~NETIF_F_RXCSUM;
+		*features &= ~NETIF_F_RXCSUM;
 
 	if (!priv->plat->tx_coe)
-		features &= ~NETIF_F_CSUM_MASK;
+		*features &= ~NETIF_F_CSUM_MASK;
 
 	/* Some GMAC devices have a bugged Jumbo frame support that
 	 * needs to have the Tx COE disabled for oversized frames
@@ -5478,17 +5478,15 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 	 * the TX csum insertion in the TDES and not use SF.
 	 */
 	if (priv->plat->bugged_jumbo && (dev->mtu > ETH_DATA_LEN))
-		features &= ~NETIF_F_CSUM_MASK;
+		*features &= ~NETIF_F_CSUM_MASK;
 
 	/* Disable tso if asked by ethtool */
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
-		if (features & NETIF_F_TSO)
+		if (*features & NETIF_F_TSO)
 			priv->tso = true;
 		else
 			priv->tso = false;
 	}
-
-	return features;
 }
 
 static int stmmac_set_features(struct net_device *netdev,
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 382bebc2420d..5371328422ec 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1919,21 +1919,19 @@ static int netvsc_set_ringparam(struct net_device *ndev,
 	return ret;
 }
 
-static netdev_features_t netvsc_fix_features(struct net_device *ndev,
-					     netdev_features_t features)
+static void netvsc_fix_features(struct net_device *ndev,
+				netdev_features_t *features)
 {
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
 
 	if (!nvdev || nvdev->destroy)
-		return features;
+		return;
 
-	if ((features & NETIF_F_LRO) && netvsc_xdp_get(nvdev)) {
-		features ^= NETIF_F_LRO;
+	if ((*features & NETIF_F_LRO) && netvsc_xdp_get(nvdev)) {
+		*features ^= NETIF_F_LRO;
 		netdev_info(ndev, "Skip LRO - unsupported with XDP\n");
 	}
-
-	return features;
 }
 
 static int netvsc_set_features(struct net_device *ndev,
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index c0b21a5580d5..8fcc91c0b0f4 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -235,19 +235,17 @@ static netdev_tx_t ipvlan_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-static netdev_features_t ipvlan_fix_features(struct net_device *dev,
-					     netdev_features_t features)
+static void ipvlan_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 
-	features |= NETIF_F_ALL_FOR_ALL;
-	features &= (ipvlan->sfeatures | ~IPVLAN_FEATURES);
-	features = netdev_increment_features(ipvlan->phy_dev->features,
-					     features, features);
-	features |= IPVLAN_ALWAYS_ON;
-	features &= (IPVLAN_FEATURES | IPVLAN_ALWAYS_ON);
-
-	return features;
+	*features |= NETIF_F_ALL_FOR_ALL;
+	*features &= (ipvlan->sfeatures | ~IPVLAN_FEATURES);
+	*features = netdev_increment_features(ipvlan->phy_dev->features,
+					      *features, *features);
+	*features |= IPVLAN_ALWAYS_ON;
+	*features &= (IPVLAN_FEATURES | IPVLAN_ALWAYS_ON);
 }
 
 static void ipvlan_change_rx_flags(struct net_device *dev, int change)
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 93dc48b9b4f2..601b833a40bd 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3470,20 +3470,20 @@ static void macsec_dev_uninit(struct net_device *dev)
 	free_percpu(dev->tstats);
 }
 
-static netdev_features_t macsec_fix_features(struct net_device *dev,
-					     netdev_features_t features)
+static void macsec_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 
-	if (macsec_is_offloaded(macsec))
-		return REAL_DEV_FEATURES(real_dev);
+	if (macsec_is_offloaded(macsec)) {
+		*features = REAL_DEV_FEATURES(real_dev);
+		return;
+	}
 
-	features &= (real_dev->features & SW_MACSEC_FEATURES) |
+	*features &= (real_dev->features & SW_MACSEC_FEATURES) |
 		    NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES;
-	features |= NETIF_F_LLTX;
-
-	return features;
+	*features |= NETIF_F_LLTX;
 }
 
 static int macsec_dev_open(struct net_device *dev)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 35f46ad040b0..27cd9c08bb1e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1067,23 +1067,21 @@ static int macvlan_ethtool_get_ts_info(struct net_device *dev,
 	return 0;
 }
 
-static netdev_features_t macvlan_fix_features(struct net_device *dev,
-					      netdev_features_t features)
+static void macvlan_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	netdev_features_t lowerdev_features = vlan->lowerdev->features;
 	netdev_features_t mask;
 
-	features |= NETIF_F_ALL_FOR_ALL;
-	features &= (vlan->set_features | ~MACVLAN_FEATURES);
-	mask = features;
+	*features |= NETIF_F_ALL_FOR_ALL;
+	*features &= (vlan->set_features | ~MACVLAN_FEATURES);
+	mask = *features;
 
-	lowerdev_features &= (features | ~NETIF_F_LRO);
-	features = netdev_increment_features(lowerdev_features, features, mask);
-	features |= ALWAYS_ON_FEATURES;
-	features &= (ALWAYS_ON_FEATURES | MACVLAN_FEATURES);
-
-	return features;
+	lowerdev_features &= (*features | ~NETIF_F_LRO);
+	*features = netdev_increment_features(lowerdev_features, *features, mask);
+	*features |= ALWAYS_ON_FEATURES;
+	*features &= (ALWAYS_ON_FEATURES | MACVLAN_FEATURES);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index dd7917cab2b1..340be925d4eb 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1995,28 +1995,26 @@ static int team_del_slave(struct net_device *dev, struct net_device *port_dev)
 	return err;
 }
 
-static netdev_features_t team_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void team_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct team_port *port;
 	struct team *team = netdev_priv(dev);
 	netdev_features_t mask;
 
-	mask = features;
-	features &= ~NETIF_F_ONE_FOR_ALL;
-	features |= NETIF_F_ALL_FOR_ALL;
+	mask = *features;
+	*features &= ~NETIF_F_ONE_FOR_ALL;
+	*features |= NETIF_F_ALL_FOR_ALL;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
-		features = netdev_increment_features(features,
-						     port->dev->features,
-						     mask);
+		*features = netdev_increment_features(*features,
+						      port->dev->features,
+						      mask);
 	}
 	rcu_read_unlock();
 
-	features = netdev_add_tso_features(features, mask);
-
-	return features;
+	*features = netdev_add_tso_features(*features, mask);
 }
 
 static int team_change_carrier(struct net_device *dev, bool new_carrier)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index fecc9a1d293a..d89a9874eb37 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1079,12 +1079,13 @@ static void tun_net_mclist(struct net_device *dev)
 	 */
 }
 
-static netdev_features_t tun_net_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void tun_net_fix_features(struct net_device *dev,
+				 netdev_features_t *features)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
-	return (features & tun->set_features) | (features & ~TUN_USER_FEATURES);
+	*features = (*features & tun->set_features) |
+			(*features & ~TUN_USER_FEATURES);
 }
 
 static void tun_set_headroom(struct net_device *dev, int new_hr)
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 50eb43e5bf45..82c900d7ba7b 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1382,8 +1382,8 @@ static int veth_get_iflink(const struct net_device *dev)
 	return iflink;
 }
 
-static netdev_features_t veth_fix_features(struct net_device *dev,
-					   netdev_features_t features)
+static void veth_fix_features(struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	struct net_device *peer;
@@ -1393,12 +1393,10 @@ static netdev_features_t veth_fix_features(struct net_device *dev,
 		struct veth_priv *peer_priv = netdev_priv(peer);
 
 		if (peer_priv->_xdp_prog)
-			features &= ~NETIF_F_GSO_SOFTWARE;
+			*features &= ~NETIF_F_GSO_SOFTWARE;
 	}
 	if (priv->_xdp_prog)
-		features |= NETIF_F_GRO;
-
-	return features;
+		*features |= NETIF_F_GRO;
 }
 
 static int veth_set_features(struct net_device *dev,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index e840547cd19e..6a5827c21c63 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -246,14 +246,12 @@ vmxnet3_get_strings(struct net_device *netdev, u32 stringset, u8 *buf)
 		ethtool_sprintf(&buf, vmxnet3_global_stats[i].desc);
 }
 
-netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
-				       netdev_features_t features)
+void vmxnet3_fix_features(struct net_device *netdev,
+			  netdev_features_t *features)
 {
 	/* If Rx checksum is disabled, then LRO should also be disabled */
-	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_LRO;
-
-	return features;
+	if (!(*features & NETIF_F_RXCSUM))
+		*features &= ~NETIF_F_LRO;
 }
 
 void vmxnet3_features_check(struct sk_buff *skb, struct net_device *netdev,
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index a711759ebb00..aed4e1bf9298 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -475,8 +475,8 @@ vmxnet3_tq_destroy_all(struct vmxnet3_adapter *adapter);
 void
 vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 
-netdev_features_t
-vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
+void
+vmxnet3_fix_features(struct net_device *netdev, netdev_features_t *features);
 
 void
 vmxnet3_features_check(struct sk_buff *skb,
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index c58996c1e230..f964f0a402a6 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -374,23 +374,21 @@ static int xenvif_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 }
 
-static netdev_features_t xenvif_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void xenvif_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct xenvif *vif = netdev_priv(dev);
 
 	if (!vif->can_sg)
-		features &= ~NETIF_F_SG;
+		*features &= ~NETIF_F_SG;
 	if (~(vif->gso_mask) & GSO_BIT(TCPV4))
-		features &= ~NETIF_F_TSO;
+		*features &= ~NETIF_F_TSO;
 	if (~(vif->gso_mask) & GSO_BIT(TCPV6))
-		features &= ~NETIF_F_TSO6;
+		*features &= ~NETIF_F_TSO6;
 	if (!vif->ip_csum)
-		features &= ~NETIF_F_IP_CSUM;
+		*features &= ~NETIF_F_IP_CSUM;
 	if (!vif->ipv6_csum)
-		features &= ~NETIF_F_IPV6_CSUM;
-
-	return features;
+		*features &= ~NETIF_F_IPV6_CSUM;
 }
 
 static const struct xenvif_stat {
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 65c134ac2be5..79752f16277a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1386,29 +1386,27 @@ static void xennet_release_rx_bufs(struct netfront_queue *queue)
 	spin_unlock_bh(&queue->rx_lock);
 }
 
-static netdev_features_t xennet_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void xennet_fix_features(struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct netfront_info *np = netdev_priv(dev);
 
-	if (features & NETIF_F_SG &&
+	if (*features & NETIF_F_SG &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-sg", 0))
-		features &= ~NETIF_F_SG;
+		*features &= ~NETIF_F_SG;
 
-	if (features & NETIF_F_IPV6_CSUM &&
+	if (*features & NETIF_F_IPV6_CSUM &&
 	    !xenbus_read_unsigned(np->xbdev->otherend,
 				  "feature-ipv6-csum-offload", 0))
-		features &= ~NETIF_F_IPV6_CSUM;
+		*features &= ~NETIF_F_IPV6_CSUM;
 
-	if (features & NETIF_F_TSO &&
+	if (*features & NETIF_F_TSO &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv4", 0))
-		features &= ~NETIF_F_TSO;
+		*features &= ~NETIF_F_TSO;
 
-	if (features & NETIF_F_TSO6 &&
+	if (*features & NETIF_F_TSO6 &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv6", 0))
-		features &= ~NETIF_F_TSO6;
-
-	return features;
+		*features &= ~NETIF_F_TSO6;
 }
 
 static int xennet_set_features(struct net_device *dev,
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 58bd0dc43695..5fd8151b355b 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1093,7 +1093,7 @@ int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
 int qeth_setassparms_cb(struct qeth_card *, struct qeth_reply *, unsigned long);
 int qeth_set_features(struct net_device *, netdev_features_t);
 void qeth_enable_hw_features(struct net_device *dev);
-netdev_features_t qeth_fix_features(struct net_device *, netdev_features_t);
+void qeth_fix_features(struct net_device *dev, netdev_features_t *features);
 void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
 			 netdev_features_t *features);
 void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 46b5ad0171fa..6a1941e5fd51 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6923,26 +6923,24 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 }
 EXPORT_SYMBOL_GPL(qeth_set_features);
 
-netdev_features_t qeth_fix_features(struct net_device *dev,
-				    netdev_features_t features)
+void qeth_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct qeth_card *card = dev->ml_priv;
 
 	QETH_CARD_TEXT(card, 2, "fixfeat");
 	if (!qeth_is_supported(card, IPA_OUTBOUND_CHECKSUM))
-		features &= ~NETIF_F_IP_CSUM;
+		*features &= ~NETIF_F_IP_CSUM;
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6))
-		features &= ~NETIF_F_IPV6_CSUM;
+		*features &= ~NETIF_F_IPV6_CSUM;
 	if (!qeth_is_supported(card, IPA_INBOUND_CHECKSUM) &&
 	    !qeth_is_supported6(card, IPA_INBOUND_CHECKSUM_V6))
-		features &= ~NETIF_F_RXCSUM;
+		*features &= ~NETIF_F_RXCSUM;
 	if (!qeth_is_supported(card, IPA_OUTBOUND_TSO))
-		features &= ~NETIF_F_TSO;
+		*features &= ~NETIF_F_TSO;
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_TSO))
-		features &= ~NETIF_F_TSO6;
+		*features &= ~NETIF_F_TSO6;
 
-	QETH_CARD_HEX(card, 2, &features, sizeof(features));
-	return features;
+	QETH_CARD_HEX(card, 2, features, sizeof(*features));
 }
 EXPORT_SYMBOL_GPL(qeth_fix_features);
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d62edd4c99a9..43eb57fa9434 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1481,8 +1481,8 @@ struct net_device_ops {
 						      bool all_slaves);
 	struct net_device*	(*ndo_sk_get_lower_dev)(struct net_device *dev,
 							struct sock *sk);
-	netdev_features_t	(*ndo_fix_features)(struct net_device *dev,
-						    netdev_features_t features);
+	void			(*ndo_fix_features)(struct net_device *dev,
+						    netdev_features_t *features);
 	int			(*ndo_set_features)(struct net_device *dev,
 						    netdev_features_t features);
 	int			(*ndo_neigh_construct)(struct net_device *dev,
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 2987201ec93d..9f90a587d4e5 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -633,11 +633,11 @@ void vlan_dev_uninit(struct net_device *dev)
 	}
 }
 
-static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void vlan_dev_fix_features(struct net_device *dev,
+				  netdev_features_t *features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	netdev_features_t old_features = features;
+	netdev_features_t old_features = *features;
 	netdev_features_t lower_features;
 
 	netdev_intersect_features(&lower_features,
@@ -649,11 +649,9 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	 */
 	if (lower_features & (NETIF_F_IP_CSUM|NETIF_F_IPV6_CSUM))
 		lower_features |= NETIF_F_HW_CSUM;
-	netdev_intersect_features(&features, features, lower_features);
-	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
-	features |= NETIF_F_LLTX;
-
-	return features;
+	netdev_intersect_features(features, *features, lower_features);
+	*features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
+	*features |= NETIF_F_LLTX;
 }
 
 static int vlan_ethtool_get_link_ksettings(struct net_device *dev,
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8d6bab244c4a..622559aff2dd 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -288,12 +288,11 @@ static int br_get_link_ksettings(struct net_device *dev,
 	return 0;
 }
 
-static netdev_features_t br_fix_features(struct net_device *dev,
-	netdev_features_t features)
+static void br_fix_features(struct net_device *dev, netdev_features_t *features)
 {
 	struct net_bridge *br = netdev_priv(dev);
 
-	return br_features_recompute(br, features);
+	*features = br_features_recompute(br, *features);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/net/core/dev.c b/net/core/dev.c
index 8f6316bee565..8a2de66e709b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9933,7 +9933,7 @@ int __netdev_update_features(struct net_device *dev)
 	netdev_get_wanted_features(dev, &features);
 
 	if (dev->netdev_ops->ndo_fix_features)
-		features = dev->netdev_ops->ndo_fix_features(dev, features);
+		dev->netdev_ops->ndo_fix_features(dev, &features);
 
 	/* driver might be less strict about feature dependencies */
 	features = netdev_fix_features(dev, features);
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 26c32407f029..acaf48a1e136 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -201,12 +201,12 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 	return features;
 }
 
-static netdev_features_t hsr_fix_features(struct net_device *dev,
-					  netdev_features_t features)
+static void hsr_fix_features(struct net_device *dev,
+			     netdev_features_t *features)
 {
 	struct hsr_priv *hsr = netdev_priv(dev);
 
-	return hsr_features_recompute(hsr, features);
+	*features = hsr_features_recompute(hsr, *features);
 }
 
 static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
-- 
2.33.0

