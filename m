Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC82458E562
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbiHJDOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiHJDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:54 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CBA82F87
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgx1m4lzjXnR;
        Wed, 10 Aug 2022 11:10:37 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 27/36] treewide: use netdev_feature_del helpers
Date:   Wed, 10 Aug 2022 11:06:15 +0800
Message-ID: <20220810030624.34711-28-shenjian15@huawei.com>
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

Replace the '&= ~' expreesions of single feature bit by
netdev_feature_del helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  4 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  3 +-
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  6 +--
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |  2 +-
 drivers/net/ethernet/atheros/atlx/atlx.c      |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 14 +++----
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 10 ++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 34 ++++++++--------
 drivers/net/ethernet/cadence/macb_main.c      |  6 +--
 .../net/ethernet/cavium/liquidio/lio_main.c   | 20 +++++-----
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 18 ++++-----
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  2 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  5 ++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c   |  8 ++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  8 ++--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  2 +-
 drivers/net/ethernet/ibm/ibmveth.c            | 10 +++--
 drivers/net/ethernet/intel/e1000/e1000_main.c |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |  3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 28 +++++++------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  4 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  4 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 10 ++---
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  4 +-
 .../marvell/octeontx2/nic/otx2_common.c       |  3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  6 +--
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 12 +++---
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 34 ++++++++--------
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib.c |  2 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  6 +--
 .../ethernet/netronome/nfp/nfp_net_common.c   | 14 ++++---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  2 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |  2 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  2 +-
 .../net/ethernet/qlogic/qede/qede_ethtool.c   |  3 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  7 ++--
 drivers/net/ethernet/realtek/8139cp.c         |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  2 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |  3 +-
 drivers/net/ethernet/sfc/efx.c                |  4 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  9 +++--
 drivers/net/ethernet/sfc/siena/efx.c          |  4 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/macvlan.c                         |  2 +-
 drivers/net/usb/r8152.c                       |  4 +-
 drivers/net/veth.c                            |  6 +--
 drivers/net/vmxnet3/vmxnet3_drv.c             | 12 ++++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  8 ++--
 drivers/net/wireless/ath/ath6kl/main.c        |  3 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |  2 +-
 drivers/net/xen-netback/interface.c           | 10 ++---
 drivers/net/xen-netfront.c                    |  8 ++--
 drivers/s390/net/qeth_core_main.c             | 15 +++----
 drivers/s390/net/qeth_l3_main.c               |  2 +-
 net/core/dev.c                                | 39 ++++++++++---------
 net/core/skbuff.c                             |  3 +-
 net/dccp/ipv6.c                               |  5 ++-
 net/dsa/slave.c                               | 10 +++--
 net/ieee802154/core.c                         |  6 ++-
 net/ipv4/esp4_offload.c                       |  6 +--
 net/ipv4/gre_offload.c                        |  2 +-
 net/ipv4/udp_offload.c                        |  2 +-
 net/ipv6/esp6_offload.c                       |  6 +--
 net/openvswitch/vport-internal_dev.c          |  2 +-
 net/sctp/offload.c                            |  2 +-
 net/wireless/core.c                           |  6 ++-
 net/xfrm/xfrm_device.c                        |  6 +--
 92 files changed, 295 insertions(+), 254 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index e4d20673150c..8470f5ee6748 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -219,8 +219,8 @@ static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_featu
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
 	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags)) {
-		features &= ~NETIF_F_IP_CSUM;
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_IP_CSUM_BIT, &features);
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 3539769a84bb..97762bca0338 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1557,7 +1557,7 @@ static int altera_tse_probe(struct platform_device *pdev)
 	/* Scatter/gather IO is not supported,
 	 * so it is turned off
 	 */
-	ndev->hw_features &= ~NETIF_F_SG;
+	netdev_hw_feature_del(ndev, NETIF_F_SG_BIT);
 	netdev_active_features_set(ndev, ndev->hw_features);
 	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 9d7ad79804e0..1ba0e24a0cb1 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2217,7 +2217,8 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 		if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming off\n");
-			features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_feature_del(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					   &features);
 		}
 	}
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 71acce12baec..53ca1fb4c989 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -270,13 +270,13 @@ static netdev_features_t aq_ndev_fix_features(struct net_device *ndev,
 	struct bpf_prog *prog;
 
 	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 
 	prog = READ_ONCE(aq_nic->xdp_prog);
 	if (prog && !prog->aux->xdp_has_frags &&
 	    aq_nic->xdp_prog && features & NETIF_F_LRO) {
 		netdev_err(ndev, "LRO is not supported with single buffer XDP, disabling\n");
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 	}
 
 	return features;
@@ -505,7 +505,7 @@ static int aq_xdp_setup(struct net_device *ndev, struct bpf_prog *prog,
 		if (prog && ndev->features & NETIF_F_LRO) {
 			netdev_err(ndev,
 				   "LRO is not supported with single buffer XDP, disabling\n");
-			ndev->features &= ~NETIF_F_LRO;
+			netdev_active_feature_del(ndev, NETIF_F_LRO_BIT);
 		}
 	}
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 01ab8bec3d4d..2113fa44026d 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -517,7 +517,7 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	if (hw->nic_type != athr_mt) {
 		if (netdev->mtu > MAX_TSO_FRAME_SIZE)
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 1e275e1006b3..43a64706bda6 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -392,7 +392,7 @@ static netdev_features_t atl1e_fix_features(struct net_device *netdev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 47b323c13448..81995490aa1d 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -382,7 +382,7 @@ static netdev_features_t atl2_fix_features(struct net_device *netdev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index 199b190ae23a..f9b0eddbe2ec 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -247,7 +247,7 @@ static netdev_features_t atlx_fix_features(struct net_device *netdev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 8455b0679670..d15ec211150c 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8609,7 +8609,7 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->max_mtu = MAX_ETHERNET_JUMBO_PACKET_SIZE;
 
 	if (!(bp->flags & BNX2_FLAG_CAN_KEEP_VLAN))
-		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_hw_feature_del(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	if ((rc = register_netdev(dev))) {
 		dev_err(&pdev->dev, "Cannot register net device\n");
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index a1f3f6552101..7534fff7e676 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4891,7 +4891,7 @@ int bnx2x_change_mtu(struct net_device *dev, int new_mtu)
 	dev->mtu = new_mtu;
 
 	if (!bnx2x_mtu_allows_gro(new_mtu))
-		dev->features &= ~NETIF_F_GRO_HW;
+		netdev_active_feature_del(dev, NETIF_F_GRO_HW_BIT);
 
 	if (IS_PF(bp) && SHMEM2_HAS(bp, curr_cfg))
 		SHMEM2_WR(bp, curr_cfg, CURR_CFG_MET_OS);
@@ -4911,14 +4911,14 @@ netdev_features_t bnx2x_fix_features(struct net_device *dev,
 		 * would require internal reload of PF in bnx2x_set_features().
 		 */
 		if (!(features & NETIF_F_RXCSUM) && !bp->disable_tpa) {
-			features &= ~NETIF_F_RXCSUM;
+			netdev_feature_del(NETIF_F_RXCSUM_BIT, &features);
 			if (dev->features & NETIF_F_RXCSUM)
 				netdev_feature_add(NETIF_F_RXCSUM_BIT,
 						   &features);
 		}
 
 		if (changed & NETIF_F_LOOPBACK) {
-			features &= ~NETIF_F_LOOPBACK;
+			netdev_feature_del(NETIF_F_LOOPBACK_BIT, &features);
 			if (dev->features & NETIF_F_LOOPBACK)
 				netdev_feature_add(NETIF_F_LOOPBACK_BIT,
 						   &features);
@@ -4927,12 +4927,12 @@ netdev_features_t bnx2x_fix_features(struct net_device *dev,
 
 	/* TPA requires Rx CSUM offloading */
 	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 
 	if (!(features & NETIF_F_GRO) || !bnx2x_mtu_allows_gro(dev->mtu))
-		features &= ~NETIF_F_GRO_HW;
+		netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 	if (features & NETIF_F_GRO_HW)
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 
 	return features;
 }
@@ -4960,7 +4960,7 @@ int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 	}
 
 	/* Don't care about GRO changes */
-	changes &= ~NETIF_F_GRO;
+	netdev_feature_del(NETIF_F_GRO_BIT, &changes);
 
 	if (changes)
 		bnx2x_reload = true;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 92a1e370eac6..2c460493ccac 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12350,10 +12350,10 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 	/* Set TPA flags */
 	if (bp->disable_tpa) {
-		bp->dev->hw_features &= ~NETIF_F_LRO;
-		bp->dev->hw_features &= ~NETIF_F_GRO_HW;
-		bp->dev->features &= ~NETIF_F_LRO;
-		bp->dev->features &= ~NETIF_F_GRO_HW;
+		netdev_hw_feature_del(bp->dev, NETIF_F_LRO_BIT);
+		netdev_hw_feature_del(bp->dev, NETIF_F_GRO_HW_BIT);
+		netdev_active_feature_del(bp->dev, NETIF_F_LRO_BIT);
+		netdev_active_feature_del(bp->dev, NETIF_F_GRO_HW_BIT);
 	}
 
 	if (CHIP_IS_E1(bp))
@@ -13282,7 +13282,7 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 	netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (dev->features & NETIF_F_LRO)
-		dev->features &= ~NETIF_F_GRO_HW;
+		netdev_active_feature_del(dev, NETIF_F_GRO_HW_BIT);
 
 	/* Add Loopback capability to the device */
 	netdev_hw_feature_add(dev, NETIF_F_LOOPBACK_BIT);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 258d9491a2f7..e426aa407ed8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6511,8 +6511,8 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 
 			bp->flags &= ~BNXT_FLAG_AGG_RINGS;
 			bp->flags |= BNXT_FLAG_NO_AGG_RINGS;
-			bp->dev->hw_features &= ~NETIF_F_LRO;
-			bp->dev->features &= ~NETIF_F_LRO;
+			netdev_hw_feature_del(bp->dev, NETIF_F_LRO_BIT);
+			netdev_active_feature_del(bp->dev, NETIF_F_LRO_BIT);
 			bnxt_set_ring_params(bp);
 		}
 	}
@@ -10444,7 +10444,7 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	if ((bp->flags & BNXT_FLAG_RFS) &&
 	    !(bp->flags & BNXT_FLAG_USING_MSIX)) {
 		/* disable RFS if falling back to INTA */
-		bp->dev->hw_features &= ~NETIF_F_NTUPLE;
+		netdev_hw_feature_del(bp->dev, NETIF_F_NTUPLE_BIT);
 		bp->flags &= ~BNXT_FLAG_RFS;
 	}
 
@@ -11177,23 +11177,23 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	netdev_features_t vlan_features;
 
 	if ((features & NETIF_F_NTUPLE) && !bnxt_rfs_capable(bp))
-		features &= ~NETIF_F_NTUPLE;
+		netdev_feature_del(NETIF_F_NTUPLE_BIT, &features);
 
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS) {
-		features &= ~NETIF_F_LRO;
-		features &= ~NETIF_F_GRO_HW;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
+		netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 	}
 
 	if (!(bp->flags & BNXT_FLAG_TPA)) {
-		features &= ~NETIF_F_LRO;
-		features &= ~NETIF_F_GRO_HW;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
+		netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 	}
 
 	if (!(features & NETIF_F_GRO))
-		features &= ~NETIF_F_GRO_HW;
+		netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 
 	if (features & NETIF_F_GRO_HW)
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
@@ -12263,8 +12263,8 @@ static void bnxt_set_dflt_rfs(struct bnxt *bp)
 {
 	struct net_device *dev = bp->dev;
 
-	dev->hw_features &= ~NETIF_F_NTUPLE;
-	dev->features &= ~NETIF_F_NTUPLE;
+	netdev_hw_feature_del(dev, NETIF_F_NTUPLE_BIT);
+	netdev_active_feature_del(dev, NETIF_F_NTUPLE_BIT);
 	bp->flags &= ~BNXT_FLAG_RFS;
 	if (bnxt_rfs_supported(bp)) {
 		netdev_hw_feature_add(dev, NETIF_F_NTUPLE_BIT);
@@ -13276,10 +13276,10 @@ static int bnxt_get_dflt_rings(struct bnxt *bp, int *max_rx, int *max_tx,
 			return rc;
 		}
 		bp->flags |= BNXT_FLAG_NO_AGG_RINGS;
-		bp->dev->hw_features &= ~NETIF_F_LRO;
-		bp->dev->hw_features &= ~NETIF_F_GRO_HW;
-		bp->dev->features &= ~NETIF_F_LRO;
-		bp->dev->features &= ~NETIF_F_GRO_HW;
+		netdev_hw_feature_del(bp->dev, NETIF_F_LRO_BIT);
+		netdev_hw_feature_del(bp->dev, NETIF_F_GRO_HW_BIT);
+		netdev_active_feature_del(bp->dev, NETIF_F_LRO_BIT);
+		netdev_active_feature_del(bp->dev, NETIF_F_GRO_HW_BIT);
 		bnxt_set_ring_params(bp);
 	}
 
@@ -13657,7 +13657,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (dev->features & NETIF_F_GRO_HW)
-		dev->features &= ~NETIF_F_LRO;
+		netdev_active_feature_del(dev, NETIF_F_LRO_BIT);
 	dev->priv_flags |= IFF_UNICAST_FLT;
 
 #ifdef CONFIG_BNXT_SRIOV
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 22553f3d69d6..fcac8394cb48 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2149,7 +2149,7 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 	 * apart from the last must be a multiple of 8 bytes in size.
 	 */
 	if (!IS_ALIGNED(skb_headlen(skb) - hdrlen, MACB_TX_LEN_ALIGN)) {
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 		return features;
 	}
 
@@ -2160,7 +2160,7 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
 		if (!IS_ALIGNED(skb_frag_size(frag), MACB_TX_LEN_ALIGN)) {
-			features &= ~NETIF_F_TSO;
+			netdev_feature_del(NETIF_F_TSO_BIT, &features);
 			return features;
 		}
 	}
@@ -4065,7 +4065,7 @@ static int macb_init(struct platform_device *pdev)
 		netdev_hw_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	}
 	if (bp->caps & MACB_CAPS_SG_DISABLED)
-		dev->hw_features &= ~NETIF_F_SG;
+		netdev_hw_feature_del(dev, NETIF_F_SG_BIT);
 	dev->features = dev->hw_features;
 
 	/* Check RX Flow Filters support.
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index aa2e0d3537a3..fb12fcf85d0f 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2722,29 +2722,29 @@ static netdev_features_t liquidio_fix_features(struct net_device *netdev,
 
 	if ((request & NETIF_F_RXCSUM) &&
 	    !(lio->dev_capability & NETIF_F_RXCSUM))
-		request &= ~NETIF_F_RXCSUM;
+		netdev_feature_del(NETIF_F_RXCSUM_BIT, &request);
 
 	if ((request & NETIF_F_HW_CSUM) &&
 	    !(lio->dev_capability & NETIF_F_HW_CSUM))
-		request &= ~NETIF_F_HW_CSUM;
+		netdev_feature_del(NETIF_F_HW_CSUM_BIT, &request);
 
 	if ((request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
-		request &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &request);
 
 	if ((request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
-		request &= ~NETIF_F_TSO6;
+		netdev_feature_del(NETIF_F_TSO6_BIT, &request);
 
 	if ((request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
-		request &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &request);
 
 	/*Disable LRO if RXCSUM is off */
 	if (!(request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
 	    (lio->dev_capability & NETIF_F_LRO))
-		request &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &request);
 
 	if ((request & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    !(lio->dev_capability & NETIF_F_HW_VLAN_CTAG_FILTER))
-		request &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, &request);
 
 	return request;
 }
@@ -3591,7 +3591,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					  &lio->enc_dev_capability);
 
 		netdev->hw_enc_features = lio->enc_dev_capability;
-		netdev->hw_enc_features &= ~NETIF_F_LRO;
+		netdev_hw_enc_feature_del(netdev, NETIF_F_LRO_BIT);
 
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
@@ -3603,11 +3603,11 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		netdev_features_set(&lio->dev_capability, netdev_ctag_vlan_features);
 
 		netdev->features = lio->dev_capability;
-		netdev->features &= ~NETIF_F_LRO;
+		netdev_active_feature_del(netdev, NETIF_F_LRO_BIT);
 
 		netdev->hw_features = lio->dev_capability;
 		/*HW_VLAN_RX and HW_VLAN_FILTER is always on*/
-		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_hw_feature_del(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 		/* MTU range: 68 - 16000 */
 		netdev->min_mtu = LIO_MIN_MTU_SIZE;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 6ee1032b3dad..4d88cb7e1516 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1820,25 +1820,25 @@ static netdev_features_t liquidio_fix_features(struct net_device *netdev,
 
 	if ((request & NETIF_F_RXCSUM) &&
 	    !(lio->dev_capability & NETIF_F_RXCSUM))
-		request &= ~NETIF_F_RXCSUM;
+		netdev_feature_del(NETIF_F_RXCSUM_BIT, &request);
 
 	if ((request & NETIF_F_HW_CSUM) &&
 	    !(lio->dev_capability & NETIF_F_HW_CSUM))
-		request &= ~NETIF_F_HW_CSUM;
+		netdev_feature_del(NETIF_F_HW_CSUM_BIT, &request);
 
 	if ((request & NETIF_F_TSO) && !(lio->dev_capability & NETIF_F_TSO))
-		request &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &request);
 
 	if ((request & NETIF_F_TSO6) && !(lio->dev_capability & NETIF_F_TSO6))
-		request &= ~NETIF_F_TSO6;
+		netdev_feature_del(NETIF_F_TSO6_BIT, &request);
 
 	if ((request & NETIF_F_LRO) && !(lio->dev_capability & NETIF_F_LRO))
-		request &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &request);
 
 	/* Disable LRO if RXCSUM is off */
 	if (!(request & NETIF_F_RXCSUM) && (netdev->features & NETIF_F_LRO) &&
 	    (lio->dev_capability & NETIF_F_LRO))
-		request &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &request);
 
 	return request;
 }
@@ -2123,7 +2123,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					  &lio->enc_dev_capability);
 
 		netdev->hw_enc_features = lio->enc_dev_capability;
-		netdev->hw_enc_features &= ~NETIF_F_LRO;
+		netdev_hw_enc_feature_del(netdev, NETIF_F_LRO_BIT);
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
 		netdev->vlan_features = lio->dev_capability;
@@ -2131,10 +2131,10 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		netdev_features_set(&lio->dev_capability, netdev_ctag_vlan_features);
 
 		netdev->features = lio->dev_capability;
-		netdev->features &= ~NETIF_F_LRO;
+		netdev_active_feature_del(netdev, NETIF_F_LRO_BIT);
 
 		netdev->hw_features = lio->dev_capability;
-		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_hw_feature_del(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 		/* MTU range: 68 - 16000 */
 		netdev->min_mtu = LIO_MIN_MTU_SIZE;
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 67ad6c5e539f..373df6adcf6a 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1780,7 +1780,7 @@ static netdev_features_t nicvf_fix_features(struct net_device *netdev,
 
 	if ((features & NETIF_F_LOOPBACK) &&
 	    netif_running(netdev) && !nic->loopback_supported)
-		features &= ~NETIF_F_LOOPBACK;
+		netdev_feature_del(NETIF_F_LOOPBACK_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 80cc1f6fcfef..c00f4120e453 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -873,7 +873,7 @@ static netdev_features_t t1_fix_features(struct net_device *dev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index c6d08aceffa0..4c363379d995 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2245,7 +2245,8 @@ static int cxgb_siocdevprivate(struct net_device *dev,
 				netdev_wanted_feature_add(dev,
 							  NETIF_F_GRO_BIT);
 			else
-				dev->wanted_features &= ~NETIF_F_GRO;
+				netdev_wanted_feature_del(dev,
+							  NETIF_F_GRO_BIT);
 			netdev_update_features(dev);
 		}
 
@@ -2597,7 +2598,7 @@ static netdev_features_t cxgb_fix_features(struct net_device *dev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
index a885f8d96e2f..13865ba2694a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
@@ -110,10 +110,10 @@ int cxgb_fcoe_disable(struct net_device *netdev)
 
 	fcoe->flags &= ~CXGB_FCOE_ENABLED;
 
-	netdev->features &= ~NETIF_F_FCOE_CRC;
-	netdev->vlan_features &= ~NETIF_F_FCOE_CRC;
-	netdev->features &= ~NETIF_F_FCOE_MTU;
-	netdev->vlan_features &= ~NETIF_F_FCOE_MTU;
+	netdev_active_feature_del(netdev, NETIF_F_FCOE_CRC_BIT);
+	netdev_vlan_feature_del(netdev, NETIF_F_FCOE_CRC_BIT);
+	netdev_active_feature_del(netdev, NETIF_F_FCOE_MTU_BIT);
+	netdev_vlan_feature_del(netdev, NETIF_F_FCOE_MTU_BIT);
 
 	netdev_features_change(netdev);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 316fa87237b2..14a119232481 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3860,7 +3860,7 @@ static netdev_features_t cxgb_fix_features(struct net_device *dev,
 {
 	/* Disable GRO, if RX_CSUM is disabled */
 	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_GRO;
+		netdev_feature_del(NETIF_F_GRO_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index a96a45e8e805..a6056a80058a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1184,7 +1184,7 @@ static netdev_features_t cxgb4vf_fix_features(struct net_device *dev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 5e67f4cd4285..1b401125aaf0 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2896,7 +2896,7 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_active_features_set(netdev, netdev_ctag_vlan_offload_features);
 	if (ENIC_SETTING(enic, LOOP)) {
-		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_active_feature_del(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 		enic->loop_enable = 1;
 		enic->loop_tag = enic->config.loop_tag;
 		dev_info(dev, "loopback tag=0x%04x\n", enic->loop_tag);
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index ed6339b57841..ba54b89149a9 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5081,7 +5081,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		 * to Lancer and BE3 HW. Disable TSO6 feature.
 		 */
 		if (!skyhawk_chip(adapter) && is_ipv6_ext_hdr(skb))
-			features &= ~NETIF_F_TSO6;
+			netdev_feature_del(NETIF_F_TSO6_BIT, &features);
 
 		/* Lancer cannot handle the packet with MSS less than 256.
 		 * Also it can't handle a TSO packet with a single segment
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 17525ce5f682..ce160fa7fc46 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1947,15 +1947,15 @@ static int ftgmac100_probe(struct platform_device *pdev)
 
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
-		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+		netdev_hw_feature_del(netdev, NETIF_F_HW_CSUM_BIT);
 
 	/* AST2600 tx checksum with NCSI is broken */
 	if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
-		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+		netdev_hw_feature_del(netdev, NETIF_F_HW_CSUM_BIT);
 
 	if (np && of_get_property(np, "no-hw-checksum", NULL)) {
-		netdev->hw_features &= ~NETIF_F_HW_CSUM;
-		netdev->hw_features &= ~NETIF_F_RXCSUM;
+		netdev_hw_feature_del(netdev, NETIF_F_HW_CSUM_BIT);
+		netdev_hw_feature_del(netdev, NETIF_F_RXCSUM_BIT);
 	}
 	netdev_active_features_set(netdev, netdev->hw_features);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 30f231610e61..105ed4d4aab5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3316,7 +3316,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev_hw_features_set(netdev, netdev->features);
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
-		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_feature_del(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	netdev_features_zero(&vlan_off_features);
 	netdev_features_set_array(&hns3_vlan_off_feature_set,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 4e49e2c4b409..544c4e499d38 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -872,7 +872,7 @@ static netdev_features_t hinic_fix_features(struct net_device *netdev,
 	/* If Rx checksum is disabled, then LRO should also be disabled */
 	if (!(features & NETIF_F_RXCSUM)) {
 		netif_info(nic_dev, drv, netdev, "disabling LRO as RXCSUM is off\n");
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 4687a22434ed..8c1398f8b059 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -794,7 +794,8 @@ static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
 					   set_attr, clr_attr, &ret_attr);
 
 			if (data == 1)
-				dev->features &= ~NETIF_F_IP_CSUM;
+				netdev_active_feature_del(dev,
+							  NETIF_F_IP_CSUM_BIT);
 
 		} else {
 			adapter->fw_ipv4_csum_support = data;
@@ -812,7 +813,8 @@ static int ibmveth_set_csum_offload(struct net_device *dev, u32 data)
 					   set_attr6, clr_attr6, &ret_attr);
 
 			if (data == 1)
-				dev->features &= ~NETIF_F_IPV6_CSUM;
+				netdev_active_feature_del(dev,
+							  NETIF_F_IPV6_CSUM_BIT);
 
 		} else
 			adapter->fw_ipv6_csum_support = data;
@@ -884,7 +886,7 @@ static int ibmveth_set_tso(struct net_device *dev, u32 data)
 		 * support tcp6/ipv6
 		 */
 		if (data == 1) {
-			dev->features &= ~NETIF_F_TSO6;
+			netdev_active_feature_del(dev, NETIF_F_TSO6_BIT);
 			netdev_info(dev, "TSO feature requires all partitions to have updated driver");
 		}
 		adapter->large_send = data;
@@ -908,7 +910,7 @@ static int ibmveth_set_features(struct net_device *dev,
 		rc1 = ibmveth_set_csum_offload(dev, rx_csum);
 		if (rc1 && !adapter->rx_csum) {
 			dev->features = features & ~NETIF_F_CSUM_MASK;
-			dev->features &= ~NETIF_F_RXCSUM;
+			netdev_active_feature_del(dev, NETIF_F_RXCSUM_BIT);
 		}
 	}
 
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index acf68d405812..3958edb44a1d 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -796,7 +796,7 @@ static netdev_features_t e1000_fix_features(struct net_device *netdev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a2b28da7a56e..1e51c751ff3b 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7297,7 +7297,7 @@ static netdev_features_t e1000_fix_features(struct net_device *netdev,
 
 	/* Jumbo frame workaround on 82579 and newer requires CRC be stripped */
 	if ((hw->mac.type >= e1000_pch2lan) && (netdev->mtu > ETH_DATA_LEN))
-		features &= ~NETIF_F_RXFCS;
+		netdev_feature_del(NETIF_F_RXFCS_BIT, &features);
 
 	/* Since there is no support for separate Rx/Tx vlan accel
 	 * enable/disable make sure Tx flag is always in same state as Rx.
@@ -7305,7 +7305,7 @@ static netdev_features_t e1000_fix_features(struct net_device *netdev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 3362f26d7f99..db6501c8ea39 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -772,7 +772,7 @@ static int fm10k_tso(struct fm10k_ring *tx_ring,
 	return 1;
 
 err_vxlan:
-	tx_ring->netdev->features &= ~NETIF_F_GSO_UDP_TUNNEL;
+	netdev_active_feature_del(tx_ring->netdev, NETIF_F_GSO_UDP_TUNNEL_BIT);
 	if (net_ratelimit())
 		netdev_err(tx_ring->netdev,
 			   "TSO requested for unsupported tunnel, disabling offload\n");
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index d5be43c80c14..dbb40065aeba 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -305,7 +305,8 @@ static int fm10k_handle_reset(struct fm10k_intfc *interface)
 		}
 
 		if (hw->mac.vlan_override)
-			netdev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_active_feature_del(netdev,
+						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		else
 			netdev_active_feature_add(netdev,
 						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 25a2b77ffd6f..2377a01904ac 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13720,7 +13720,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
-	netdev->features &= ~NETIF_F_HW_TC;
+	netdev_active_feature_del(netdev, NETIF_F_HW_TC_BIT);
 
 	if (vsi->type == I40E_VSI_MAIN) {
 		SET_NETDEV_DEV(netdev, &pf->pdev->dev);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index ae8471342166..38b4756e0992 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4504,31 +4504,37 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_CTAG_TX_BIT))
-		requested_features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+				   &requested_features);
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_CTAG_RX_BIT))
-		requested_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+				   &requested_features);
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_STAG_TX_BIT))
-		requested_features &= ~NETIF_F_HW_VLAN_STAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_STAG_TX_BIT,
+				   &requested_features);
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_STAG_RX_BIT))
-		requested_features &= ~NETIF_F_HW_VLAN_STAG_RX;
+		netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT,
+				   &requested_features);
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
-		requested_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   &requested_features);
 
 	if (!IAVF_NETDEV_VLAN_FEATURE_ALLOWED(requested_features,
 					      allowed_features,
 					      NETIF_F_HW_VLAN_STAG_FILTER_BIT))
-		requested_features &= ~NETIF_F_HW_VLAN_STAG_FILTER;
+		netdev_feature_del(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+				   &requested_features);
 
 	if ((requested_features & netdev_ctag_vlan_offload_features) &&
 	    (requested_features & netdev_stag_vlan_offload_features) &&
@@ -4686,16 +4692,16 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	if (netdev->wanted_features) {
 		if (!(netdev->wanted_features & NETIF_F_TSO) ||
 		    netdev->mtu < 576)
-			netdev->features &= ~NETIF_F_TSO;
+			netdev_active_feature_del(netdev, NETIF_F_TSO_BIT);
 		if (!(netdev->wanted_features & NETIF_F_TSO6) ||
 		    netdev->mtu < 576)
-			netdev->features &= ~NETIF_F_TSO6;
+			netdev_active_feature_del(netdev, NETIF_F_TSO6_BIT);
 		if (!(netdev->wanted_features & NETIF_F_TSO_ECN))
-			netdev->features &= ~NETIF_F_TSO_ECN;
+			netdev_active_feature_del(netdev, NETIF_F_TSO_ECN_BIT);
 		if (!(netdev->wanted_features & NETIF_F_GRO))
-			netdev->features &= ~NETIF_F_GRO;
+			netdev_active_feature_del(netdev, NETIF_F_GRO_BIT);
 		if (!(netdev->wanted_features & NETIF_F_GSO))
-			netdev->features &= ~NETIF_F_GSO;
+			netdev_active_feature_del(netdev, NETIF_F_GSO_BIT);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 56bca0d7b0f5..1bb120db96cc 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1880,7 +1880,7 @@ static void iavf_netdev_features_vlan_strip_set(struct net_device *netdev,
 	if (enable)
 		netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	else
-		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_active_feature_del(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index c6b1d30ba2f6..cb109bc49c31 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2441,7 +2441,7 @@ static netdev_features_t igb_fix_features(struct net_device *netdev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
@@ -2543,7 +2543,7 @@ igb_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
 	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 7d04d87157de..09a7b7631950 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2656,7 +2656,7 @@ igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
 	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c594dfeb5dfd..0d7f99a58a00 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4943,7 +4943,7 @@ static netdev_features_t igc_fix_features(struct net_device *netdev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
@@ -5011,7 +5011,7 @@ igc_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
 	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 7630db8cc290..82a7373268c8 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -302,7 +302,7 @@ ixgb_fix_features(struct net_device *netdev, netdev_features_t features)
 	 * disabled.
 	 */
 	if (!(features & NETIF_F_HW_VLAN_CTAG_RX))
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index 603a910aa611..dd180400b454 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -898,7 +898,7 @@ int ixgbe_fcoe_disable(struct net_device *netdev)
 
 	/* disable FCoE and notify stack */
 	adapter->flags &= ~IXGBE_FLAG_FCOE_ENABLED;
-	netdev->features &= ~NETIF_F_FCOE_MTU;
+	netdev_active_feature_del(netdev, NETIF_F_FCOE_MTU_BIT);
 
 	netdev_features_change(netdev);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 727df1a82ec0..05ce8c4fdd99 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4922,7 +4922,7 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 		hw->addr_ctrl.user_set_promisc = true;
 		fctrl |= (IXGBE_FCTRL_UPE | IXGBE_FCTRL_MPE);
 		vmolr |= IXGBE_VMOLR_MPE;
-		features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, &features);
 	} else {
 		if (netdev->flags & IFF_ALLMULTI) {
 			fctrl |= IXGBE_FCTRL_MPE;
@@ -9837,15 +9837,15 @@ static netdev_features_t ixgbe_fix_features(struct net_device *netdev,
 
 	/* If Rx checksum is disabled, then RSC/LRO should also be disabled */
 	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 
 	/* Turn off LRO if not RSC capable */
 	if (!(adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE))
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 
 	if (adapter->xdp_prog && (features & NETIF_F_LRO)) {
 		e_dev_err("LRO is not supported with XDP\n");
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 	}
 
 	return features;
@@ -10259,7 +10259,7 @@ ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 #ifdef CONFIG_IXGBE_IPSEC
 		if (!secpath_exists(skb))
 #endif
-			features &= ~NETIF_F_TSO;
+			netdev_feature_del(NETIF_F_TSO_BIT, &features);
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index bca192bf7ed9..2ccee2e984ec 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4437,7 +4437,7 @@ ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
 	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c2a77f161286..dc67d93c6e44 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3848,8 +3848,8 @@ static netdev_features_t mvneta_fix_features(struct net_device *dev,
 	struct mvneta_port *pp = netdev_priv(dev);
 
 	if (pp->tx_csum_limit && dev->mtu > pp->tx_csum_limit) {
-		features &= ~NETIF_F_IP_CSUM;
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_IP_CSUM_BIT, &features);
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 		netdev_info(dev,
 			    "Disable IP checksum for MTU greater than %dB\n",
 			    pp->tx_csum_limit);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index fb8db5888d2f..2d08af351de8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/interrupt.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <net/tso.h>
 
@@ -496,7 +497,7 @@ void otx2_setup_segmentation(struct otx2_nic *pfvf)
 	mutex_unlock(&pfvf->mbox.lock);
 	netdev_info(pfvf->netdev,
 		    "Failed to get LSO index for UDP GSO offload, disabling\n");
-	pfvf->netdev->hw_features &= ~NETIF_F_GSO_UDP_L4;
+	netdev_hw_feature_del(pfvf->netdev, NETIF_F_GSO_UDP_L4_BIT);
 }
 
 void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index ef2d175f586b..9b68a79fc6e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1860,7 +1860,7 @@ static netdev_features_t otx2_fix_features(struct net_device *dev,
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
 		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_STAG_RX;
+		netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index caaa3692e2b8..74b91fddd036 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -2681,7 +2681,7 @@ static void sky2_rx_checksum(struct sky2_port *sky2, u32 status)
 		 * It will be reenabled on next ndo_set_features, but if it's
 		 * really broken, will get disabled again
 		 */
-		sky2->netdev->features &= ~NETIF_F_RXCSUM;
+		netdev_active_feature_del(sky2->netdev, NETIF_F_RXCSUM_BIT);
 		sky2_write32(sky2->hw, Q_ADDR(rxqaddr[sky2->port], Q_CSR),
 			     BMU_DIS_RX_CHKSUM);
 	}
@@ -4316,8 +4316,8 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 	 */
 	if (dev->mtu > ETH_DATA_LEN && hw->chip_id == CHIP_ID_YUKON_EC_U) {
 		netdev_info(dev, "checksum offload not possible with jumbo frames\n");
-		features &= ~NETIF_F_TSO;
-		features &= ~NETIF_F_SG;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
+		netdev_feature_del(NETIF_F_SG_BIT, &features);
 		features &= ~NETIF_F_CSUM_MASK;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 113944e047ab..ba8fdfc3b33a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2510,7 +2510,7 @@ static netdev_features_t mlx4_en_fix_features(struct net_device *netdev,
 	    !(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
 		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, &features);
 	else
-		features &= ~NETIF_F_HW_VLAN_STAG_RX;
+		netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT, &features);
 
 	return features;
 }
@@ -3565,7 +3565,8 @@ int mlx4_en_reset_config(struct net_device *dev,
 			netdev_active_feature_add(dev,
 						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		else
-			dev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_active_feature_del(dev,
+						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	} else if (ts_config.rx_filter == HWTSTAMP_FILTER_NONE) {
 		/* RX time-stamping is OFF, update the RX vlan offload
 		 * to the latest wanted state
@@ -3574,14 +3575,15 @@ int mlx4_en_reset_config(struct net_device *dev,
 			netdev_active_feature_add(dev,
 						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		else
-			dev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_active_feature_del(dev,
+						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
 
 	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT)) {
 		if (features & NETIF_F_RXFCS)
 			netdev_active_feature_add(dev, NETIF_F_RXFCS_BIT);
 		else
-			dev->features &= ~NETIF_F_RXFCS;
+			netdev_active_feature_del(dev, NETIF_F_RXFCS_BIT);
 	}
 
 	/* RX vlan offload and RX time-stamping can't co-exist !
@@ -3591,7 +3593,7 @@ int mlx4_en_reset_config(struct net_device *dev,
 	if (ts_config.rx_filter != HWTSTAMP_FILTER_NONE) {
 		if (dev->features & NETIF_F_HW_VLAN_CTAG_RX)
 			en_warn(priv, "Turning off RX vlan offload since RX time-stamping is ON\n");
-		dev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_active_feature_del(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
 
 	if (port_up) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index e2a9b9be5c1f..c4b12191cfed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1279,7 +1279,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 	if (err) {
 		mlx5_core_err(priv->fs->mdev, "Failed to create arfs tables, err=%d\n",
 			      err);
-		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
+		netdev_hw_feature_del(priv->netdev, NETIF_F_NTUPLE_BIT);
 	}
 
 	err = mlx5e_create_inner_ttc_table(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ddedeac29935..bfbbc3bc152b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3890,19 +3890,19 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 static netdev_features_t mlx5e_fix_uplink_rep_features(struct net_device *netdev,
 						       netdev_features_t features)
 {
-	features &= ~NETIF_F_HW_TLS_RX;
+	netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, &features);
 	if (netdev->features & NETIF_F_HW_TLS_RX)
 		netdev_warn(netdev, "Disabling hw_tls_rx, not supported in switchdev mode\n");
 
-	features &= ~NETIF_F_HW_TLS_TX;
+	netdev_feature_del(NETIF_F_HW_TLS_TX_BIT, &features);
 	if (netdev->features & NETIF_F_HW_TLS_TX)
 		netdev_warn(netdev, "Disabling hw_tls_tx, not supported in switchdev mode\n");
 
-	features &= ~NETIF_F_NTUPLE;
+	netdev_feature_del(NETIF_F_NTUPLE_BIT, &features);
 	if (netdev->features & NETIF_F_NTUPLE)
 		netdev_warn(netdev, "Disabling ntuple, not supported in switchdev mode\n");
 
-	features &= ~NETIF_F_GRO_HW;
+	netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 	if (netdev->features & NETIF_F_GRO_HW)
 		netdev_warn(netdev, "Disabling HW_GRO, not supported in switchdev mode\n");
 
@@ -3922,7 +3922,7 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		/* HW strips the outer C-tag header, this is a problem
 		 * for S-tag traffic.
 		 */
-		features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_RX_BIT, &features);
 		if (!params->vlan_strip_disable)
 			netdev_warn(netdev, "Dropping C-tag vlan stripping offload due to S-tag vlan\n");
 	}
@@ -3930,22 +3930,22 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 	if (!MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_STRIDING_RQ)) {
 		if (features & NETIF_F_LRO) {
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
-			features &= ~NETIF_F_LRO;
+			netdev_feature_del(NETIF_F_LRO_BIT, &features);
 		}
 		if (features & NETIF_F_GRO_HW) {
 			netdev_warn(netdev, "Disabling HW-GRO, not supported in legacy RQ\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
 	if (params->xdp_prog) {
 		if (features & NETIF_F_LRO) {
 			netdev_warn(netdev, "LRO is incompatible with XDP\n");
-			features &= ~NETIF_F_LRO;
+			netdev_feature_del(NETIF_F_LRO_BIT, &features);
 		}
 		if (features & NETIF_F_GRO_HW) {
 			netdev_warn(netdev, "HW GRO is incompatible with XDP\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
@@ -3953,23 +3953,23 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		if (features & NETIF_F_LRO) {
 			netdev_warn(netdev, "LRO is incompatible with AF_XDP (%u XSKs are active)\n",
 				    priv->xsk.refcnt);
-			features &= ~NETIF_F_LRO;
+			netdev_feature_del(NETIF_F_LRO_BIT, &features);
 		}
 		if (features & NETIF_F_GRO_HW) {
 			netdev_warn(netdev, "HW GRO is incompatible with AF_XDP (%u XSKs are active)\n",
 				    priv->xsk.refcnt);
-			features &= ~NETIF_F_GRO_HW;
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-		features &= ~NETIF_F_RXHASH;
+		netdev_feature_del(NETIF_F_RXHASH_BIT, &features);
 		if (netdev->features & NETIF_F_RXHASH)
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
 
 		if (features & NETIF_F_GRO_HW) {
 			netdev_warn(netdev, "Disabling HW-GRO, not supported when CQE compress is active\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
@@ -4975,10 +4975,10 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	/* Defaults */
 	if (fcs_enabled)
-		netdev->features  &= ~NETIF_F_RXALL;
-	netdev->features  &= ~NETIF_F_LRO;
-	netdev->features  &= ~NETIF_F_GRO_HW;
-	netdev->features  &= ~NETIF_F_RXFCS;
+		netdev_active_feature_del(netdev, NETIF_F_RXALL_BIT);
+	netdev_active_feature_del(netdev, NETIF_F_LRO_BIT);
+	netdev_active_feature_del(netdev, NETIF_F_GRO_HW_BIT);
+	netdev_active_feature_del(netdev, NETIF_F_RXFCS_BIT);
 
 #define FT_CAP(f) MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive.f)
 	if (FT_CAP(flow_modify_en) &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index d859b58c4c8b..71a0b7db41c7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -336,7 +336,7 @@ static int mlx5i_create_flow_steering(struct mlx5e_priv *priv)
 	if (err) {
 		netdev_err(priv->netdev, "Failed to create arfs tables, err=%d\n",
 			   err);
-		priv->netdev->hw_features &= ~NETIF_F_NTUPLE;
+		netdev_hw_feature_del(priv->netdev, NETIF_F_NTUPLE_BIT);
 	}
 
 	err = mlx5e_create_ttc_table(priv);
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index c6dd11c872f9..285688a88a0e 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2901,7 +2901,7 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 	struct myri10ge_slice_state *ss;
 	netdev_tx_t status;
 
-	features &= ~NETIF_F_TSO6;
+	netdev_feature_del(NETIF_F_TSO6_BIT, &features);
 	segs = skb_gso_segment(skb, features);
 	if (IS_ERR(segs))
 		goto drop;
@@ -3878,9 +3878,9 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_vlan_features_set(netdev, mgp->features);
 	if (mgp->fw_ver_tiny < 37)
-		netdev->vlan_features &= ~NETIF_F_TSO6;
+		netdev_vlan_feature_del(netdev, NETIF_F_TSO6_BIT);
 	if (mgp->fw_ver_tiny < 32)
-		netdev->vlan_features &= ~NETIF_F_TSO;
+		netdev_vlan_feature_del(netdev, NETIF_F_TSO_BIT);
 
 	/* make sure we can get an irq, and that MSI can be
 	 * setup (if available). */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 071e0c6aa219..9bda15a858d6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1759,13 +1759,17 @@ nfp_net_fix_features(struct net_device *netdev,
 	if ((features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    (features & NETIF_F_HW_VLAN_STAG_RX)) {
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
-			features &= ~NETIF_F_HW_VLAN_CTAG_RX;
-			netdev->wanted_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_feature_del(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					   &features);
+			netdev_wanted_feature_del(netdev,
+						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 			netdev_warn(netdev,
 				    "S-tag and C-tag stripping can't be enabled at the same time. Enabling S-tag stripping and disabling C-tag stripping\n");
 		} else if (netdev->features & NETIF_F_HW_VLAN_STAG_RX) {
-			features &= ~NETIF_F_HW_VLAN_STAG_RX;
-			netdev->wanted_features &= ~NETIF_F_HW_VLAN_STAG_RX;
+			netdev_feature_del(NETIF_F_HW_VLAN_STAG_RX_BIT,
+					   &features);
+			netdev_wanted_feature_del(netdev,
+						  NETIF_F_HW_VLAN_STAG_RX_BIT);
 			netdev_warn(netdev,
 				    "S-tag and C-tag stripping can't be enabled at the same time. Enabling C-tag stripping and disabling S-tag stripping\n");
 		}
@@ -2431,7 +2435,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	/* C-Tag strip and S-Tag strip can't be supported simultaneously,
 	 * so enable C-Tag strip and disable S-Tag strip by default.
 	 */
-	netdev->features &= ~NETIF_F_HW_VLAN_STAG_RX;
+	netdev_active_feature_del(netdev, NETIF_F_HW_VLAN_STAG_RX_BIT);
 	nn->dp.ctrl &= ~NFP_NET_CFG_CTRL_RXQINQ;
 
 	/* Finalise the netdev setup */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index b8a8aa917fdd..acee5eeb4d2e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -391,7 +391,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	/* C-Tag strip and S-Tag strip can't be supported simultaneously,
 	 * so enable C-Tag strip and disable S-Tag strip by default.
 	 */
-	netdev->features &= ~NETIF_F_HW_VLAN_STAG_RX;
+	netdev_active_feature_del(netdev, NETIF_F_HW_VLAN_STAG_RX_BIT);
 	netif_set_tso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
 
 	netdev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
index 81fc5a6e3221..4652884248be 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
@@ -477,7 +477,7 @@ void pch_gbe_check_options(struct pch_gbe_adapter *adapter)
 		val = XsumRX;
 		pch_gbe_validate_option(&val, &opt, adapter);
 		if (!val)
-			dev->features &= ~NETIF_F_RXCSUM;
+			netdev_active_feature_del(dev, NETIF_F_RXCSUM_BIT);
 	}
 	{ /* Checksum Offload Enable/Disable */
 		static const struct pch_gbe_option opt = {
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index ce1bb941fd85..20fa5204b15c 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -526,7 +526,7 @@ static netdev_features_t netxen_fix_features(struct net_device *dev,
 	if (!(features & NETIF_F_RXCSUM)) {
 		netdev_info(dev, "disabling LRO as RXCSUM is off\n");
 
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 97a7ab0826ed..dd8bd6ec734a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -7,6 +7,7 @@
 #include <linux/version.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/string.h>
@@ -1044,7 +1045,7 @@ int qede_change_mtu(struct net_device *ndev, int new_mtu)
 		   "Configuring MTU size of %d\n", new_mtu);
 
 	if (new_mtu > PAGE_SIZE)
-		ndev->features &= ~NETIF_F_GRO_HW;
+		netdev_active_feature_del(ndev, NETIF_F_GRO_HW_BIT);
 
 	/* Set the mtu field and re-start the interface if needed */
 	args.u.mtu = new_mtu;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 3010833ddde3..9ec8daa60d6d 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -917,7 +917,7 @@ netdev_features_t qede_fix_features(struct net_device *dev,
 
 	if (edev->xdp_prog || edev->ndev->mtu > PAGE_SIZE ||
 	    !(features & NETIF_F_GRO))
-		features &= ~NETIF_F_GRO_HW;
+		netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 64ba47a8629b..832a4dc8d89c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -1583,7 +1583,7 @@ static int qede_alloc_mem_rxq(struct qede_dev *edev, struct qede_rx_queue *rxq)
 		rxq->rx_buf_seg_size = roundup_pow_of_two(size);
 	} else {
 		rxq->rx_buf_seg_size = PAGE_SIZE;
-		edev->ndev->features &= ~NETIF_F_GRO_HW;
+		netdev_active_feature_del(edev->ndev, NETIF_F_GRO_HW_BIT);
 	}
 
 	/* Allocate the parallel driver ring for Rx buffers */
@@ -2472,7 +2472,7 @@ static int qede_load(struct qede_dev *edev, enum qede_load_mode mode,
 		goto err2;
 
 	if (qede_alloc_arfs(edev)) {
-		edev->ndev->features &= ~NETIF_F_NTUPLE;
+		netdev_active_feature_del(edev->ndev, NETIF_F_NTUPLE_BIT);
 		edev->dev_info.common.b_arfs_capable = false;
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index ab7e234132ed..503d18280559 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1042,12 +1042,13 @@ static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 		adapter->rx_csum = 1;
 		if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
 			if (!(offload_flags & BIT_1))
-				features &= ~NETIF_F_TSO;
+				netdev_feature_del(NETIF_F_TSO_BIT, &features);
 			else
 				netdev_feature_add(NETIF_F_TSO_BIT, &features);
 
 			if (!(offload_flags & BIT_2))
-				features &= ~NETIF_F_TSO6;
+				netdev_feature_del(NETIF_F_TSO6_BIT,
+						   &features);
 			else
 				netdev_feature_add(NETIF_F_TSO6_BIT,
 						   &features);
@@ -1085,7 +1086,7 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 	}
 
 	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 778c75b76950..63f4ef15ebba 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1862,7 +1862,7 @@ static netdev_features_t cp_features_check(struct sk_buff *skb,
 					   netdev_features_t features)
 {
 	if (skb_shinfo(skb)->gso_size > MSSMask)
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 
 	return vlan_features_check(skb, features);
 }
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d0887e74167f..d9f92be3e246 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5440,7 +5440,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (tp->mac_version == RTL_GIGA_MAC_VER_05)
 		/* Disallow toggling */
-		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_hw_feature_del(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	if (rtl_chip_supports_csum_v2(tp))
 		netdev_hw_feature_add(dev, NETIF_F_IPV6_CSUM_BIT);
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 4a3cbc1c50ec..ede1ec1c7d2f 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -246,7 +246,8 @@ static int efx_ef10_vadaptor_alloc_set_features(struct efx_nic *efx)
 		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				   &efx->fixed_features);
 	else
-		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   &efx->fixed_features);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 5134fbd0382a..77aee7b35585 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1030,13 +1030,13 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
-	net_dev->features &= ~NETIF_F_RXALL;
+	netdev_active_feature_del(net_dev, NETIF_F_RXALL_BIT);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_del(net_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index b803b8688c60..1ef24fb2315d 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2918,7 +2918,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_del(net_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = ef4_register_netdev(efx);
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 4ff6586116ee..dc6342710233 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1330,9 +1330,12 @@ int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 		(EFX_FILTER_MATCH_OUTER_VID | EFX_FILTER_MATCH_LOC_MAC_IG)))) {
 		netif_info(efx, probe, net_dev,
 			   "VLAN filters are not supported in this firmware variant\n");
-		net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		net_dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_del(net_dev,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   &efx->fixed_features);
+		netdev_hw_feature_del(net_dev,
+				      NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 
 	table->entry = vzalloc(array_size(EFX_MCDI_FILTER_TBL_ROWS,
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index d5818151bb04..a18f5fc16b20 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -1012,13 +1012,13 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 			       net_dev->features & ~efx->fixed_features);
 
 	/* Disable receiving frames with bad FCS, by default. */
-	net_dev->features &= ~NETIF_F_RXALL;
+	netdev_active_feature_del(net_dev, NETIF_F_RXALL_BIT);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
 	 * receive VLAN tagged packets due to vPort restrictions).
 	 */
-	net_dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_del(net_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_active_features_set(net_dev, efx->fixed_features);
 
 	rc = efx_register_netdev(efx);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4d722a6ed2ca..8028c1e4d65b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5606,7 +5606,7 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 	struct stmmac_priv *priv = netdev_priv(dev);
 
 	if (priv->plat->rx_coe == STMMAC_RX_COE_NONE)
-		features &= ~NETIF_F_RXCSUM;
+		netdev_feature_del(NETIF_F_RXCSUM_BIT, &features);
 
 	if (!priv->plat->tx_coe)
 		features &= ~NETIF_F_CSUM_MASK;
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index f8aced92d2a9..7813677b63c9 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1275,7 +1275,7 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 		skb_shinfo(skb)->gso_size = datalen;
 		skb_shinfo(skb)->gso_segs = gso_segs;
 	}
-	features &= ~NETIF_F_TSO;
+	netdev_feature_del(NETIF_F_TSO_BIT, &features);
 	segs = skb_gso_segment(skb, features);
 	if (IS_ERR(segs))
 		goto out_dropped;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index fb32c1f045e6..4040481def57 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1999,7 +1999,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 
 	/* Disable TX checksum offload by default due to HW bug */
 	if (common->pdata.quirks & AM65_CPSW_QUIRK_I2027_NO_TX_CSUM)
-		port->ndev->features &= ~NETIF_F_HW_CSUM;
+		netdev_active_feature_del(port->ndev, NETIF_F_HW_CSUM_BIT);
 
 	ndev_priv->stats = netdev_alloc_pcpu_stats(struct am65_cpsw_ndev_stats);
 	if (!ndev_priv->stats)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 1fc6941fe633..16d2763fc227 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1109,7 +1109,7 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	mask = features;
 
 	tmp = features;
-	tmp &= ~NETIF_F_LRO;
+	netdev_feature_del(NETIF_F_LRO_BIT, &tmp);
 	lowerdev_features &= tmp;
 	features = netdev_increment_features(lowerdev_features, features, mask);
 	netdev_features_set(&features, ALWAYS_ON_FEATURES);
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 218e10ee5442..52489af158e6 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9704,8 +9704,8 @@ static int rtl8152_probe(struct usb_interface *intf,
 	netdev_vlan_features_set_array(netdev, &r8152_vlan_feature_set);
 
 	if (tp->version == RTL_VER_01) {
-		netdev->features &= ~NETIF_F_RXCSUM;
-		netdev->hw_features &= ~NETIF_F_RXCSUM;
+		netdev_active_feature_del(netdev, NETIF_F_RXCSUM_BIT);
+		netdev_hw_feature_del(netdev, NETIF_F_RXCSUM_BIT);
 	}
 
 	tp->lenovo_macpassthru = rtl8152_supports_lenovo_macpassthru(udev);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index fe9bc2f94672..ef4bb4e63d70 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1175,7 +1175,7 @@ static void veth_disable_xdp(struct net_device *dev)
 		 * enabled it, clear it now
 		 */
 		if (!veth_gro_requested(dev) && netif_running(dev)) {
-			dev->features &= ~NETIF_F_GRO;
+			netdev_active_feature_del(dev, NETIF_F_GRO_BIT);
 			netdev_features_change(dev);
 		}
 	}
@@ -1690,8 +1690,8 @@ static struct rtnl_link_ops veth_link_ops;
 
 static void veth_disable_gro(struct net_device *dev)
 {
-	dev->features &= ~NETIF_F_GRO;
-	dev->wanted_features &= ~NETIF_F_GRO;
+	netdev_active_feature_del(dev, NETIF_F_GRO_BIT);
+	netdev_wanted_feature_del(dev, NETIF_F_GRO_BIT);
 	netdev_update_features(dev);
 }
 
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index f08209bf2274..b86820386f60 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3377,13 +3377,17 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_VXLAN_CHECKSUM_OFFLOAD)) &&
 		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_GENEVE_TSO)) &&
 		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_VXLAN_TSO))) {
-			netdev->hw_enc_features &= ~NETIF_F_GSO_UDP_TUNNEL;
-			netdev->hw_features &= ~NETIF_F_GSO_UDP_TUNNEL;
+			netdev_hw_enc_feature_del(netdev,
+						  NETIF_F_GSO_UDP_TUNNEL_BIT);
+			netdev_hw_feature_del(netdev,
+					      NETIF_F_GSO_UDP_TUNNEL_BIT);
 		}
 		if (!(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD)) &&
 		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD))) {
-			netdev->hw_enc_features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
-			netdev->hw_features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_hw_enc_feature_del(netdev,
+						  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+			netdev_hw_feature_del(netdev,
+					      NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 		}
 	}
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 0444dedf75e7..dc54367e4e92 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -251,7 +251,7 @@ netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
 {
 	/* If Rx checksum is disabled, then LRO should also be disabled */
 	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 
 	return features;
 }
@@ -372,11 +372,13 @@ static void vmxnet3_enable_encap_offloads(struct net_device *netdev, netdev_feat
 		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_VXLAN_CHECKSUM_OFFLOAD)) &&
 		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_GENEVE_TSO)) &&
 		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_VXLAN_TSO))) {
-			netdev->hw_enc_features &= ~NETIF_F_GSO_UDP_TUNNEL;
+			netdev_hw_enc_feature_del(netdev,
+						  NETIF_F_GSO_UDP_TUNNEL_BIT);
 		}
 		if (!(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_GENEVE_OUTER_CHECKSUM_OFFLOAD)) &&
 		    !(adapter->dev_caps[0] & (1UL << VMXNET3_CAP_VXLAN_OUTER_CHECKSUM_OFFLOAD))) {
-			netdev->hw_enc_features &= ~NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_hw_enc_feature_del(netdev,
+						  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 		}
 	}
 }
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 4dbfdd1a8097..4cf7801da3f5 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1133,7 +1133,8 @@ static int ath6kl_set_features(struct net_device *dev,
 							 vif->fw_vif_idx,
 							 ar->rx_meta_ver, 0, 0);
 		if (err) {
-			dev->features = features & ~NETIF_F_RXCSUM;
+			dev->features = features;
+			netdev_active_feature_del(dev, NETIF_F_RXCSUM_BIT);
 			return err;
 		}
 	} else if (!(features & NETIF_F_RXCSUM) &&
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ad0d49866f38..b9726d8af8f3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -608,7 +608,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	    && (toe_ol & TOE_TX_CSUM_OL) != 0)
 		netdev_active_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
 	else
-		ndev->features &= ~NETIF_F_IP_CSUM;
+		netdev_active_feature_del(ndev, NETIF_F_IP_CSUM_BIT);
 
 	if (brcmf_cfg80211_up(ndev)) {
 		bphy_err(drvr, "failed to bring up cfg80211\n");
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index b2e50d1a6cc2..475de5418861 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -366,15 +366,15 @@ static netdev_features_t xenvif_fix_features(struct net_device *dev,
 	struct xenvif *vif = netdev_priv(dev);
 
 	if (!vif->can_sg)
-		features &= ~NETIF_F_SG;
+		netdev_feature_del(NETIF_F_SG_BIT, &features);
 	if (~(vif->gso_mask) & GSO_BIT(TCPV4))
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 	if (~(vif->gso_mask) & GSO_BIT(TCPV6))
-		features &= ~NETIF_F_TSO6;
+		netdev_feature_del(NETIF_F_TSO6_BIT, &features);
 	if (!vif->ip_csum)
-		features &= ~NETIF_F_IP_CSUM;
+		netdev_feature_del(NETIF_F_IP_CSUM_BIT, &features);
 	if (!vif->ipv6_csum)
-		features &= ~NETIF_F_IPV6_CSUM;
+		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 1b089e6ef929..aa88d5fd7d5f 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1476,20 +1476,20 @@ static netdev_features_t xennet_fix_features(struct net_device *dev,
 
 	if (features & NETIF_F_SG &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-sg", 0))
-		features &= ~NETIF_F_SG;
+		netdev_feature_del(NETIF_F_SG_BIT, &features);
 
 	if (features & NETIF_F_IPV6_CSUM &&
 	    !xenbus_read_unsigned(np->xbdev->otherend,
 				  "feature-ipv6-csum-offload", 0))
-		features &= ~NETIF_F_IPV6_CSUM;
+		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, &features);
 
 	if (features & NETIF_F_TSO &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv4", 0))
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 
 	if (features & NETIF_F_TSO6 &&
 	    !xenbus_read_unsigned(np->xbdev->otherend, "feature-gso-tcpv6", 0))
-		features &= ~NETIF_F_TSO6;
+		netdev_feature_del(NETIF_F_TSO6_BIT, &features);
 
 	return features;
 }
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 39e0bd7ba519..8118c2dae6c9 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6825,7 +6825,8 @@ void qeth_enable_hw_features(struct net_device *dev)
 	dev->features &= ~dev->hw_features;
 	/* toggle VLAN filter, so that VIDs are re-programmed: */
 	if (IS_LAYER2(card) && IS_VM_NIC(card)) {
-		dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_del(dev,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 		netdev_wanted_feature_add(dev,
 					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
@@ -6917,16 +6918,16 @@ netdev_features_t qeth_fix_features(struct net_device *dev,
 
 	QETH_CARD_TEXT(card, 2, "fixfeat");
 	if (!qeth_is_supported(card, IPA_OUTBOUND_CHECKSUM))
-		features &= ~NETIF_F_IP_CSUM;
+		netdev_feature_del(NETIF_F_IP_CSUM_BIT, &features);
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6))
-		features &= ~NETIF_F_IPV6_CSUM;
+		netdev_feature_del(NETIF_F_IPV6_CSUM_BIT, &features);
 	if (!qeth_is_supported(card, IPA_INBOUND_CHECKSUM) &&
 	    !qeth_is_supported6(card, IPA_INBOUND_CHECKSUM_V6))
-		features &= ~NETIF_F_RXCSUM;
+		netdev_feature_del(NETIF_F_RXCSUM_BIT, &features);
 	if (!qeth_is_supported(card, IPA_OUTBOUND_TSO))
-		features &= ~NETIF_F_TSO;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 	if (!qeth_is_supported6(card, IPA_OUTBOUND_TSO))
-		features &= ~NETIF_F_TSO6;
+		netdev_feature_del(NETIF_F_TSO6_BIT, &features);
 
 	QETH_CARD_HEX(card, 2, &features, sizeof(features));
 	return features;
@@ -6984,7 +6985,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 
 		/* linearize only if resulting skb allocations are order-0: */
 		if (SKB_DATA_ALIGN(hroom + doffset + hsize) <= SKB_MAX_HEAD(0))
-			features &= ~NETIF_F_SG;
+			netdev_feature_del(NETIF_F_SG_BIT, &features);
 	}
 
 	return vlan_features_check(skb, features);
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index daa1b6f2b47e..f91066cb9e72 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1809,7 +1809,7 @@ static netdev_features_t qeth_l3_osa_features_check(struct sk_buff *skb,
 						    netdev_features_t features)
 {
 	if (vlan_get_protocol(skb) != htons(ETH_P_IP))
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	return qeth_features_check(skb, dev, features);
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 6589b3c7c70c..7ba5ac96bbeb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1586,7 +1586,7 @@ void dev_disable_lro(struct net_device *dev)
 	struct net_device *lower_dev;
 	struct list_head *iter;
 
-	dev->wanted_features &= ~NETIF_F_LRO;
+	netdev_wanted_feature_del(dev, NETIF_F_LRO_BIT);
 	netdev_update_features(dev);
 
 	if (unlikely(dev->features & NETIF_F_LRO))
@@ -1607,7 +1607,7 @@ EXPORT_SYMBOL(dev_disable_lro);
  */
 static void dev_disable_gro_hw(struct net_device *dev)
 {
-	dev->wanted_features &= ~NETIF_F_GRO_HW;
+	netdev_wanted_feature_del(dev, NETIF_F_GRO_HW_BIT);
 	netdev_update_features(dev);
 
 	if (unlikely(dev->features & NETIF_F_GRO_HW))
@@ -3401,7 +3401,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		partial_features = dev->features & dev->gso_partial_features;
 		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, &partial_features);
 		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
-			features &= ~NETIF_F_GSO_PARTIAL;
+			netdev_feature_del(NETIF_F_GSO_PARTIAL_BIT, &features);
 	}
 
 	BUILD_BUG_ON(SKB_GSO_CB_OFFSET +
@@ -3491,7 +3491,7 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 		features &= ~netdev_csum_gso_features_mask;
 	}
 	if (illegal_highdma(skb->dev, skb))
-		features &= ~NETIF_F_SG;
+		netdev_feature_del(NETIF_F_SG_BIT, &features);
 
 	return features;
 }
@@ -3542,7 +3542,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 				    inner_ip_hdr(skb) : ip_hdr(skb);
 
 		if (!(iph->frag_off & htons(IP_DF)))
-			features &= ~NETIF_F_TSO_MANGLEID;
+			netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT,
+					   &features);
 	}
 
 	return features;
@@ -9622,30 +9623,30 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
 					!(features & NETIF_F_IP_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO;
-		features &= ~NETIF_F_TSO_ECN;
+		netdev_feature_del(NETIF_F_TSO_BIT, &features);
+		netdev_feature_del(NETIF_F_TSO_ECN_BIT, &features);
 	}
 
 	if ((features & NETIF_F_TSO6) && !(features & NETIF_F_HW_CSUM) &&
 					 !(features & NETIF_F_IPV6_CSUM)) {
 		netdev_dbg(dev, "Dropping TSO6 features since no CSUM feature.\n");
-		features &= ~NETIF_F_TSO6;
+		netdev_feature_del(NETIF_F_TSO6_BIT, &features);
 	}
 
 	/* TSO with IPv4 ID mangling requires IPv4 TSO be enabled */
 	if ((features & NETIF_F_TSO_MANGLEID) && !(features & NETIF_F_TSO))
-		features &= ~NETIF_F_TSO_MANGLEID;
+		netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT, &features);
 
 	/* TSO ECN requires that TSO is present as well. */
 	tmp = NETIF_F_ALL_TSO;
-	tmp &= ~NETIF_F_TSO_ECN;
+	netdev_feature_del(NETIF_F_TSO_ECN_BIT, &tmp);
 	if (!(features & tmp) && (features & NETIF_F_TSO_ECN))
-		features &= ~NETIF_F_TSO_ECN;
+		netdev_feature_del(NETIF_F_TSO_ECN_BIT, &features);
 
 	/* Software GSO depends on SG. */
 	if ((features & NETIF_F_GSO) && !(features & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping NETIF_F_GSO since no SG feature.\n");
-		features &= ~NETIF_F_GSO;
+		netdev_feature_del(NETIF_F_GSO_BIT, &features);
 	}
 
 	/* GSO partial features require GSO partial be set */
@@ -9664,7 +9665,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		 */
 		if (features & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping NETIF_F_GRO_HW since no RXCSUM feature.\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
@@ -9672,18 +9673,18 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if (features & NETIF_F_RXFCS) {
 		if (features & NETIF_F_LRO) {
 			netdev_dbg(dev, "Dropping LRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_LRO;
+			netdev_feature_del(NETIF_F_LRO_BIT, &features);
 		}
 
 		if (features & NETIF_F_GRO_HW) {
 			netdev_dbg(dev, "Dropping HW-GRO feature since RX-FCS is requested.\n");
-			features &= ~NETIF_F_GRO_HW;
+			netdev_feature_del(NETIF_F_GRO_HW_BIT, &features);
 		}
 	}
 
 	if ((features & NETIF_F_GRO_HW) && (features & NETIF_F_LRO)) {
 		netdev_dbg(dev, "Dropping LRO feature since HW-GRO is requested.\n");
-		features &= ~NETIF_F_LRO;
+		netdev_feature_del(NETIF_F_LRO_BIT, &features);
 	}
 
 	if (features & NETIF_F_HW_TLS_TX) {
@@ -9693,13 +9694,13 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 
 		if (!ip_csum && !hw_csum) {
 			netdev_dbg(dev, "Dropping TLS TX HW offload feature since no CSUM feature.\n");
-			features &= ~NETIF_F_HW_TLS_TX;
+			netdev_feature_del(NETIF_F_HW_TLS_TX_BIT, &features);
 		}
 	}
 
 	if ((features & NETIF_F_HW_TLS_RX) && !(features & NETIF_F_RXCSUM)) {
 		netdev_dbg(dev, "Dropping TLS RX HW offload feature since no RXCSUM feature.\n");
-		features &= ~NETIF_F_HW_TLS_RX;
+		netdev_feature_del(NETIF_F_HW_TLS_RX_BIT, &features);
 	}
 
 	return features;
@@ -11170,7 +11171,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	/* If one device supports hw checksumming, set for all. */
 	if (all & NETIF_F_HW_CSUM) {
 		tmp = NETIF_F_CSUM_MASK;
-		tmp &= ~NETIF_F_HW_CSUM;
+		netdev_feature_del(NETIF_F_HW_CSUM_BIT, &tmp);
 		all &= ~tmp;
 	}
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 955d7640dde6..338ef07b8f42 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -61,6 +61,7 @@
 #include <linux/if_vlan.h>
 #include <linux/mpls.h>
 #include <linux/kcov.h>
+#include <linux/netdev_features_helper.h>
 
 #include <net/protocol.h>
 #include <net/dst.h>
@@ -4043,7 +4044,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		 * skbs; we do so by disabling SG.
 		 */
 		if (mss != GSO_BY_FRAGS && mss != skb_headlen(head_skb))
-			features &= ~NETIF_F_SG;
+			netdev_feature_del(NETIF_F_SG_BIT, &features);
 	}
 
 	__skb_push(head_skb, doffset);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 84fdb991bee5..1bd21a30f662 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/random.h>
 #include <linux/slab.h>
 #include <linux/xfrm.h>
@@ -490,8 +491,8 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 
 	ip6_dst_store(newsk, dst, NULL, NULL);
 	newsk->sk_route_caps = dst->dev->features;
-	newsk->sk_route_caps &= ~NETIF_F_IP_CSUM;
-	newsk->sk_route_caps &= ~NETIF_F_TSO;
+	netdev_feature_del(NETIF_F_IP_CSUM_BIT, &newsk->sk_route_caps);
+	netdev_feature_del(NETIF_F_TSO_BIT, &newsk->sk_route_caps);
 	newdp6 = (struct dccp6_sock *)newsk;
 	newinet = inet_sk(newsk);
 	newinet->pinet6 = &newdp6->inet6;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 7ed3699bdc4d..d61daaa12f92 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1678,7 +1678,8 @@ int dsa_slave_manage_vlan_filtering(struct net_device *slave,
 		err = vlan_for_each(slave, dsa_slave_restore_vlan, slave);
 		if (err) {
 			vlan_for_each(slave, dsa_slave_clear_vlan, slave);
-			slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_active_feature_del(slave,
+						  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 			return err;
 		}
 	} else {
@@ -1686,7 +1687,8 @@ int dsa_slave_manage_vlan_filtering(struct net_device *slave,
 		if (err)
 			return err;
 
-		slave->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_del(slave,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 
 	return 0;
@@ -2294,8 +2296,8 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	netdev_hw_feature_add(slave, NETIF_F_HW_TC_BIT);
 	netdev_active_feature_add(slave, NETIF_F_LLTX_BIT);
 	if (slave->needed_tailroom) {
-		slave->features &= ~NETIF_F_SG;
-		slave->features &= ~NETIF_F_FRAGLIST;
+		netdev_active_feature_del(slave, NETIF_F_SG_BIT);
+		netdev_active_feature_del(slave, NETIF_F_FRAGLIST_BIT);
 	}
 	if (ds->needs_standalone_vlan_filtering)
 		netdev_active_feature_add(slave,
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index 8eda70f58682..fe454f71ec6e 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -205,7 +205,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 	list_for_each_entry(wpan_dev, &rdev->wpan_dev_list, list) {
 		if (!wpan_dev->netdev)
 			continue;
-		wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+		netdev_active_feature_del(wpan_dev->netdev,
+					  NETIF_F_NETNS_LOCAL_BIT);
 		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
 		if (err)
 			break;
@@ -222,7 +223,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 						     list) {
 			if (!wpan_dev->netdev)
 				continue;
-			wpan_dev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+			netdev_active_feature_del(wpan_dev->netdev,
+						  NETIF_F_NETNS_LOCAL_BIT);
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
 			WARN_ON(err);
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 2931b3385bc9..619240be4b5e 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -220,12 +220,12 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
 	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev) {
 		esp_features = features & ~NETIF_F_CSUM_MASK;
-		esp_features &= ~NETIF_F_SG;
-		esp_features &= ~NETIF_F_SCTP_CRC;
+		netdev_feature_del(NETIF_F_SG_BIT, &esp_features);
+		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &esp_features);
 	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
 		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM)) {
 		esp_features = features & ~NETIF_F_CSUM_MASK;
-		esp_features  &= ~NETIF_F_SCTP_CRC;
+		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &esp_features);
 	}
 
 	xo->flags |= XFRM_GSO_SEGMENT;
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 07073fa35205..0b3f5a3ed86b 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -46,7 +46,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 
 	features &= skb->dev->hw_enc_features;
 	if (need_csum)
-		features &= ~NETIF_F_SCTP_CRC;
+		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &features);
 
 	need_ipsec = skb_dst(skb) && dst_xfrm(skb_dst(skb));
 	/* Try to offload checksum if possible */
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index b699b89e592b..2ac8360a2922 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -70,7 +70,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 
 	features &= skb->dev->hw_enc_features;
 	if (need_csum)
-		features &= ~NETIF_F_SCTP_CRC;
+		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &features);
 
 	/* The only checksum offload we care about from here on out is the
 	 * outer one so strip the existing checksum feature flags and
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 95b5c26abad5..8c09c2cec0f5 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -258,11 +258,11 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 
 	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev) {
 		esp_features = features & ~NETIF_F_CSUM_MASK;
-		esp_features &= ~NETIF_F_SG;
-		esp_features &= ~NETIF_F_SCTP_CRC;
+		netdev_feature_del(NETIF_F_SG_BIT, &esp_features);
+		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &esp_features);
 	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM)) {
 		esp_features = features & ~NETIF_F_CSUM_MASK;
-		esp_features  &= ~NETIF_F_SCTP_CRC;
+		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &esp_features);
 	}
 
 	xo->flags |= XFRM_GSO_SEGMENT;
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 4baf9c563c87..e33d496d26a0 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -124,7 +124,7 @@ static void do_setup(struct net_device *netdev)
 	netdev->hw_enc_features = netdev->features;
 	netdev_active_features_set(netdev, netdev_tx_vlan_features);
 	netdev->hw_features = netdev->features;
-	netdev->hw_features &= ~NETIF_F_LLTX;
+	netdev_hw_feature_del(netdev, NETIF_F_LLTX_BIT);
 
 	eth_hw_addr_random(netdev);
 }
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index ad77e0362188..a70619d0c207 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -73,7 +73,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 
 	tmp = features;
 	netdev_feature_add(NETIF_F_HW_CSUM_BIT, &tmp);
-	tmp &= ~NETIF_F_SG;
+	netdev_feature_del(NETIF_F_SG_BIT, &tmp);
 	segs = skb_segment(skb, tmp);
 	if (IS_ERR(segs))
 		goto out;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 57504e859573..7d43401ecb2f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -165,7 +165,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->netdev)
 			continue;
-		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+		netdev_active_feature_del(wdev->netdev,
+					  NETIF_F_NETNS_LOCAL_BIT);
 		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
 		if (err)
 			break;
@@ -182,7 +183,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 						     list) {
 			if (!wdev->netdev)
 				continue;
-			wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+			netdev_active_feature_del(wdev->netdev,
+						  NETIF_F_NETNS_LOCAL_BIT);
 			err = dev_change_net_namespace(wdev->netdev, net,
 							"wlan%d");
 			WARN_ON(err);
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index c492b2952d6a..63ad940853e0 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -115,7 +115,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 
 	if (!(features & NETIF_F_HW_ESP)) {
 		esp_features = features;
-		esp_features &= ~NETIF_F_SG;
+		netdev_feature_del(NETIF_F_SG_BIT, &esp_features);
 		esp_features &= ~NETIF_F_CSUM_MASK;
 	}
 
@@ -142,8 +142,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		struct sk_buff *segs;
 
 		/* Packet got rerouted, fixup features and segment it. */
-		esp_features &= ~NETIF_F_HW_ESP;
-		esp_features &= ~NETIF_F_GSO_ESP;
+		netdev_feature_del(NETIF_F_HW_ESP_BIT, &esp_features);
+		netdev_feature_del(NETIF_F_GSO_ESP_BIT, &esp_features);
 
 		segs = skb_gso_segment(skb, esp_features);
 		if (IS_ERR(segs)) {
-- 
2.33.0

