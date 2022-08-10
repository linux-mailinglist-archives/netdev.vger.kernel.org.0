Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B4C58E55B
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiHJDOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiHJDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14C882F88
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2ZhH6mVGzlVnD;
        Wed, 10 Aug 2022 11:10:55 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 29/36] treewide: use netdev_features_xor helpers
Date:   Wed, 10 Aug 2022 11:06:17 +0800
Message-ID: <20220810030624.34711-30-shenjian15@huawei.com>
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

Replace the '^' expressions of features by netdev_features_xor
helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c      |  2 +-
 drivers/net/ethernet/asix/ax88796c_main.c             |  2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c       |  3 ++-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c       |  3 ++-
 drivers/net/ethernet/atheros/atlx/atl2.c              |  3 ++-
 drivers/net/ethernet/atheros/atlx/atlx.c              |  3 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c       |  5 +++--
 drivers/net/ethernet/broadcom/tg3.c                   |  2 +-
 drivers/net/ethernet/brocade/bna/bnad.c               |  2 +-
 drivers/net/ethernet/cadence/macb_main.c              |  2 +-
 drivers/net/ethernet/calxeda/xgmac.c                  |  2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c    |  3 ++-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c      |  2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c             |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c       |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c       |  2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  2 +-
 drivers/net/ethernet/davicom/dm9000.c                 |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c              |  3 ++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c      |  2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c          |  2 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c       |  2 +-
 drivers/net/ethernet/freescale/fec_main.c             |  4 ++--
 drivers/net/ethernet/freescale/gianfar_ethtool.c      |  3 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c       |  3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_main.c        | 10 ++++++++--
 drivers/net/ethernet/ibm/ibmvnic.c                    |  2 +-
 drivers/net/ethernet/intel/e100.c                     |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c         |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c            |  2 +-
 drivers/net/ethernet/intel/ice/ice_main.c             |  6 +++---
 drivers/net/ethernet/intel/igb/igb_main.c             |  3 ++-
 drivers/net/ethernet/intel/igc/igc_main.c             |  3 ++-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c           |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c         |  3 ++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c  |  2 +-
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c  |  2 +-
 drivers/net/ethernet/marvell/sky2.c                   |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c        |  3 ++-
 drivers/net/ethernet/mscc/ocelot_net.c                |  2 +-
 drivers/net/ethernet/neterion/s2io.c                  |  2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c   |  3 ++-
 drivers/net/ethernet/nvidia/forcedeth.c               |  2 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c  |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c        |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c        |  6 +++---
 drivers/net/ethernet/qualcomm/emac/emac.c             |  2 +-
 drivers/net/ethernet/realtek/8139cp.c                 |  2 +-
 drivers/net/ethernet/realtek/8139too.c                |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c              |  2 +-
 drivers/net/ethernet/renesas/sh_eth.c                 |  2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c       |  2 +-
 drivers/net/ethernet/sfc/efx_common.c                 |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c                 |  2 +-
 drivers/net/ethernet/sfc/siena/efx_common.c           |  2 +-
 drivers/net/hyperv/netvsc_drv.c                       |  2 +-
 drivers/net/usb/aqc111.c                              |  2 +-
 drivers/net/usb/ax88179_178a.c                        |  2 +-
 drivers/net/usb/r8152.c                               |  2 +-
 drivers/net/veth.c                                    |  2 +-
 drivers/net/virtio_net.c                              |  4 ++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c                 |  2 +-
 drivers/s390/net/qeth_core_main.c                     | 11 ++++++-----
 drivers/staging/qlge/qlge_main.c                      |  2 +-
 net/core/dev.c                                        |  2 +-
 69 files changed, 102 insertions(+), 81 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 53ca1fb4c989..e05b285442f1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -237,7 +237,7 @@ static int aq_ndev_set_features(struct net_device *ndev,
 		}
 	}
 
-	if ((aq_nic->ndev->features ^ features) & NETIF_F_RXCSUM) {
+	if (netdev_active_features_xor(aq_nic->ndev, features) & NETIF_F_RXCSUM) {
 		err = aq_nic->aq_hw_ops->hw_set_offload(aq_nic->aq_hw,
 							aq_cfg);
 
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index b6c193dbee99..73c1d4a5856d 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -924,7 +924,7 @@ static int
 ax88796c_set_features(struct net_device *ndev, netdev_features_t features)
 {
 	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
-	netdev_features_t changed = features ^ ndev->features;
+	netdev_features_t changed = netdev_active_features_xor(ndev, features);
 
 	if (!(changed & ax88796c_features))
 		return 0;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 06f6de7dbb85..416185f1533a 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -530,7 +530,8 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 static int atl1c_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		atl1c_vlan_mode(netdev, features);
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 43a64706bda6..15c299cc6514 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -400,7 +400,8 @@ static netdev_features_t atl1e_fix_features(struct net_device *netdev,
 static int atl1e_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		atl1e_vlan_mode(netdev, features);
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 81995490aa1d..929cf069b567 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -390,7 +390,8 @@ static netdev_features_t atl2_fix_features(struct net_device *netdev,
 static int atl2_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		atl2_vlan_mode(netdev, features);
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index f9b0eddbe2ec..19495e1c91c4 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -255,7 +255,8 @@ static netdev_features_t atlx_fix_features(struct net_device *netdev,
 static int atlx_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		atlx_vlan_mode(netdev, features);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 7534fff7e676..d4de430b71cf 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4905,7 +4905,8 @@ netdev_features_t bnx2x_fix_features(struct net_device *dev,
 	struct bnx2x *bp = netdev_priv(dev);
 
 	if (pci_num_vf(bp->pdev)) {
-		netdev_features_t changed = dev->features ^ features;
+		netdev_features_t changed = netdev_active_features_xor(dev,
+								       features);
 
 		/* Revert the requested changes in features if they
 		 * would require internal reload of PF in bnx2x_set_features().
@@ -4940,7 +4941,7 @@ netdev_features_t bnx2x_fix_features(struct net_device *dev,
 int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct bnx2x *bp = netdev_priv(dev);
-	netdev_features_t changes = features ^ dev->features;
+	netdev_features_t changes = netdev_active_features_xor(dev, features);
 	bool bnx2x_reload = false;
 	int rc;
 
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 25171a645e73..eee309801b1f 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8315,7 +8315,7 @@ static netdev_features_t tg3_fix_features(struct net_device *dev,
 
 static int tg3_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 
 	if ((changed & NETIF_F_LOOPBACK) && netif_running(dev))
 		tg3_set_loopback(dev, features);
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index e0732e92657b..649e1a6946e2 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3347,7 +3347,7 @@ bnad_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 static int bnad_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct bnad *bnad = netdev_priv(dev);
-	netdev_features_t changed = features ^ dev->features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 
 	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) && netif_running(dev)) {
 		unsigned long flags;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index fcac8394cb48..b662f91c9b5d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3743,7 +3743,7 @@ static int macb_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct macb *bp = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 
 	/* TX checksum offload */
 	if (changed & NETIF_F_HW_CSUM)
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index fc3d688c1228..181c875ffda4 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1492,7 +1492,7 @@ static int xgmac_set_features(struct net_device *dev, netdev_features_t features
 	u32 ctrl;
 	struct xgmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = priv->base;
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 
 	if (!(changed & NETIF_F_RXCSUM))
 		return 0;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 4d88cb7e1516..45bc4d71d353 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1850,7 +1850,8 @@ static netdev_features_t liquidio_fix_features(struct net_device *netdev,
 static int liquidio_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 	struct lio *lio = netdev_priv(netdev);
 
 	if (!(changed & NETIF_F_LRO))
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 373df6adcf6a..52d810f4b39c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1789,7 +1789,7 @@ static int nicvf_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct nicvf *nic = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		nicvf_config_vlan_stripping(nic, features);
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index c00f4120e453..d9e2bf1eccf3 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -880,7 +880,7 @@ static netdev_features_t t1_fix_features(struct net_device *dev,
 
 static int t1_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	struct adapter *adapter = dev->ml_priv;
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 4c363379d995..1284e3d9c9c5 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2605,7 +2605,7 @@ static netdev_features_t cxgb_fix_features(struct net_device *dev,
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		cxgb_vlan_mode(dev, features);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index bddc7f6f0d23..f77984b79a30 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1273,7 +1273,7 @@ int cxgb4_set_rspq_intr_params(struct sge_rspq *q,
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	const struct port_info *pi = netdev_priv(dev);
 	int err;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index a6056a80058a..f99cc9715317 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1193,7 +1193,7 @@ static int cxgb4vf_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct port_info *pi = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		t4vf_set_rxmode(pi->adapter, pi->viid, -1, -1, -1, -1,
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 8d3e3b3413d3..22bc1f9da086 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -587,7 +587,7 @@ static int dm9000_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct board_info *dm = to_dm9000_board(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	unsigned long flags;
 
 	if (!(changed & NETIF_F_RXCSUM))
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index ce160fa7fc46..50f5fdcbedb4 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1597,7 +1597,8 @@ static int ftgmac100_set_features(struct net_device *netdev,
 				  netdev_features_t features)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 
 	if (!netif_running(netdev))
 		return 0;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 40c24fa45506..9781948df963 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2422,7 +2422,7 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 				  netdev_features_t features)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	netdev_features_t changed = features ^ net_dev->features;
+	netdev_features_t changed = netdev_active_features_xor(net_dev, features);
 	bool enable;
 	int err;
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4470a4a3e4c3..40e7ab38ed01 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2644,7 +2644,7 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(ndev, features);
 	int err = 0;
 
 	if (changed & NETIF_F_RXHASH)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 897932f08672..7f21068667b7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -708,7 +708,7 @@ static int enetc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 static int enetc_pf_set_features(struct net_device *ndev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(ndev, features);
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index c656c9744305..57cf1d83d125 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3378,7 +3378,7 @@ static inline void fec_enet_set_netdev_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 
 	netdev->features = features;
 
@@ -3395,7 +3395,7 @@ static int fec_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 
 	if (netif_running(netdev) && changed & NETIF_F_RXCSUM) {
 		napi_disable(&fep->napi);
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 8c541070ffe0..47e644b65ac7 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/net_tstamp.h>
 #include <linux/skbuff.h>
@@ -507,7 +508,7 @@ static int gfar_spauseparam(struct net_device *dev,
 
 int gfar_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	struct gfar_private *priv = netdev_priv(dev);
 	int err = 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 7b47f4328ac9..a1363608a3fc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2405,7 +2405,8 @@ static int hns3_nic_do_ioctl(struct net_device *netdev,
 static int hns3_nic_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
 	bool enable;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 544c4e499d38..c6c7087971ee 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1072,12 +1072,17 @@ static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change)
 {
-	netdev_features_t changed = force_change ? ~0 : pre_features ^ features;
 	netdev_features_t failed_features = netdev_empty_features;
 	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
+	netdev_features_t changed;
 	int ret = 0;
 	int err = 0;
 
+	if (force_change)
+		netdev_features_fill(&changed);
+	else
+		changed = netdev_features_xor(pre_features, features);
+
 	if (changed & NETIF_F_TSO) {
 		ret = hinic_port_set_tso(nic_dev, (features & NETIF_F_TSO) ?
 					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
@@ -1119,7 +1124,8 @@ static int set_features(struct hinic_dev *nic_dev,
 	}
 
 	if (err) {
-		nic_dev->netdev->features = features ^ failed_features;
+		nic_dev->netdev->features = netdev_features_xor(features,
+								failed_features);
 		return -EIO;
 	}
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 538bfc2fe829..09bd2505b39a 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4901,7 +4901,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		/* disable features no longer supported */
 		adapter->netdev->features &= adapter->netdev->hw_features;
 		/* turn on features now supported if previously enabled */
-		tmp = old_hw_features ^ adapter->netdev->hw_features;
+		tmp = netdev_hw_features_xor(adapter->netdev, old_hw_features);
 		tmp &= adapter->netdev->hw_features;
 		tmp &= adapter->netdev->wanted_features;
 		netdev_active_features_set(adapter->netdev, tmp);
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 960411b8d77c..8e1b8fe9a04f 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2804,7 +2804,7 @@ static int e100_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct nic *nic = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 
 	if (!(changed & NETIF_F_RXFCS && changed & NETIF_F_RXALL))
 		return 0;
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 3958edb44a1d..af3fe857ec4e 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -805,7 +805,7 @@ static int e1000_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		e1000_vlan_mode(netdev, features);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 158222876102..22cfd3fcbf1a 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7324,7 +7324,7 @@ static int e1000_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 	netdev_features_t changeable;
 
 	if (changed & netdev_general_tso_features)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 9078659838a9..9b9c73817692 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5915,7 +5915,7 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 
 	current_vlan_features = netdev->features & NETIF_VLAN_OFFLOAD_FEATURES;
 	requested_vlan_features = features & NETIF_VLAN_OFFLOAD_FEATURES;
-	diff = current_vlan_features ^ requested_vlan_features;
+	diff = netdev_features_xor(current_vlan_features, requested_vlan_features);
 	if (diff) {
 		err = ice_set_vlan_offload_features(vsi, features);
 		if (err)
@@ -5925,7 +5925,7 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	current_vlan_features = netdev->features &
 		NETIF_VLAN_FILTERING_FEATURES;
 	requested_vlan_features = features & NETIF_VLAN_FILTERING_FEATURES;
-	diff = current_vlan_features ^ requested_vlan_features;
+	diff = netdev_features_xor(current_vlan_features, requested_vlan_features);
 	if (diff) {
 		err = ice_set_vlan_filtering_features(vsi, features);
 		if (err)
@@ -5969,7 +5969,7 @@ static int ice_set_loopback(struct ice_vsi *vsi, bool ena)
 static int
 ice_set_features(struct net_device *netdev, netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index cb109bc49c31..a87a0701bce1 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2449,7 +2449,8 @@ static netdev_features_t igb_fix_features(struct net_device *netdev,
 static int igb_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0d7f99a58a00..17973b86f3a6 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4951,7 +4951,8 @@ static netdev_features_t igc_fix_features(struct net_device *netdev,
 static int igc_set_features(struct net_device *netdev,
 			    netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 82a7373268c8..8186c8e6305e 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -311,7 +311,7 @@ static int
 ixgb_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 
 	if (!(changed & NETIF_F_RXCSUM) && !(changed & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 05ce8c4fdd99..1a193cf10dab 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9871,7 +9871,8 @@ static int ixgbe_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 	bool need_reset = false;
 
 	/* Make sure RSC matches LRO, reset if change */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 8e7abdc8fd9d..09964559d77f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5279,7 +5279,7 @@ static int mvpp2_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 static int mvpp2_set_features(struct net_device *dev,
 			      netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	struct mvpp2_port *port = netdev_priv(dev);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 2d08af351de8..2f21d044318f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1725,7 +1725,7 @@ EXPORT_SYMBOL(otx2_get_max_mtu);
 
 int otx2_handle_ntuple_tc_features(struct net_device *netdev, netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	bool ntuple = !!(features & NETIF_F_NTUPLE);
 	bool tc = !!(features & NETIF_F_HW_TC);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 9b68a79fc6e5..4811f51d297b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1882,7 +1882,7 @@ static void otx2_rx_mode_wrk_handler(struct work_struct *work)
 static int otx2_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 	struct otx2_nic *pf = netdev_priv(netdev);
 
 	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 76254d483e9f..851b1fd964c6 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4335,7 +4335,7 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 static int sky2_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 
 	if ((changed & NETIF_F_RXCSUM) &&
 	    !(sky2->hw->flags & SKY2_HW_NEW_LE)) {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 55216e1eed59..fb9d32d67884 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2727,7 +2727,7 @@ static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 {
 	int err = 0;
 
-	if (!((dev->features ^ features) & NETIF_F_LRO))
+	if (!((netdev_active_features_xor(dev, features)) & NETIF_F_LRO))
 		return 0;
 
 	if (!(features & NETIF_F_LRO))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 50ceeab2540d..dda033464220 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3838,7 +3838,7 @@ static int mlx5e_handle_feature(struct net_device *netdev,
 				unsigned short feature_bit,
 				mlx5e_feature_handler feature_handler)
 {
-	netdev_features_t changes = *features ^ netdev->features;
+	netdev_features_t changes = netdev_active_features_xor(netdev, *features);
 	bool enable = netdev_feature_test(feature_bit, *features);
 	int err;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 19fbde6bd1a8..a11bd9859204 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1220,7 +1220,8 @@ static int mlxsw_sp_handle_feature(struct net_device *dev,
 				   int feature_bit,
 				   mlxsw_sp_feature_handler feature_handler)
 {
-	netdev_features_t changes = wanted_features ^ dev->features;
+	netdev_features_t changes = netdev_active_features_xor(dev,
+							       wanted_features);
 	bool enable = netdev_feature_test(feature_bit, wanted_features);
 	int err;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 353a25f001e7..6d6f3a010ea4 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -838,7 +838,7 @@ static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
 static int ocelot_set_features(struct net_device *dev,
 			       netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 9b74b1b87220..24bf2275821e 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -6571,7 +6571,7 @@ static void s2io_ethtool_get_strings(struct net_device *dev,
 static int s2io_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct s2io_nic *sp = netdev_priv(dev);
-	netdev_features_t changed = features ^ dev->features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 
 	if (changed & NETIF_F_LRO && netif_running(dev)) {
 		int rc;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0c605cb98ded..84b36d529428 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1663,7 +1663,8 @@ static void nfp_net_stat64(struct net_device *netdev,
 static int nfp_net_set_features(struct net_device *netdev,
 				netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev,
+							       features);
 	struct nfp_net *nn = netdev_priv(netdev);
 	u32 new_ctrl;
 	int err;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 44e502650328..84087466e6f4 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4962,7 +4962,7 @@ static int nv_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	int retval;
 
 	if ((changed & NETIF_F_LOOPBACK) && netif_running(dev)) {
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 8213d2300ff4..371efa0ed0a2 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2206,7 +2206,7 @@ static int pch_gbe_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 
 	if (!(changed & NETIF_F_RXCSUM))
 		return 0;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 20fa5204b15c..09185d28552c 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -539,7 +539,7 @@ static int netxen_set_features(struct net_device *dev,
 	netdev_features_t changed;
 	int hw_lro;
 
-	changed = dev->features ^ features;
+	changed = netdev_active_features_xor(dev, features);
 	if (!(changed & NETIF_F_LRO))
 		return 0;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 9ec8daa60d6d..7a824b79cbcd 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -925,7 +925,7 @@ netdev_features_t qede_fix_features(struct net_device *dev,
 int qede_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	netdev_features_t changes = features ^ dev->features;
+	netdev_features_t changes = netdev_active_features_xor(dev, features);
 	bool need_reload = false;
 
 	if (changes & NETIF_F_GRO_HW)
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 5da115f30b69..8dcb1cfdb5ba 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1077,12 +1077,12 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 		if (adapter->flags & QLCNIC_APP_CHANGED_FLAGS) {
 			features = qlcnic_process_flags(adapter, features);
 		} else {
-			changed = features ^ netdev->features;
+			changed = netdev_active_features_xor(netdev, features);
 			netdev_features_zero(&changeable);
 			netdev_features_set_array(&qlcnic_changable_feature_set,
 						  &changeable);
 			changed &= changeable;
-			features ^= changed;
+			netdev_features_toggle(&features, changed);
 		}
 	}
 
@@ -1096,7 +1096,7 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 int qlcnic_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 	int hw_lro = (features & NETIF_F_LRO) ? QLCNIC_LRO_ENABLED : 0;
 
 	if (!(changed & NETIF_F_LRO))
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 15ffa63415e1..3c85eb122448 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -176,7 +176,7 @@ static irqreturn_t emac_isr(int _irq, void *data)
 static int emac_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
 	/* We only need to reprogram the hardware if the VLAN tag features
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 63f4ef15ebba..d34d3f0ef041 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1461,7 +1461,7 @@ static void cp_set_msglevel(struct net_device *dev, u32 value)
 
 static int cp_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	struct cp_private *cp = netdev_priv(dev);
 	unsigned long flags;
 
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 7af89f43c4ca..4206c6b31802 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -902,7 +902,7 @@ static int rtl8139_set_features(struct net_device *dev, netdev_features_t featur
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
 	unsigned long flags;
-	netdev_features_t changed = features ^ dev->features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	void __iomem *ioaddr = tp->mmio_addr;
 
 	if (!(changed & NETIF_F_RXALL))
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 333a6aba78a2..a994062c7462 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2336,7 +2336,7 @@ static int ravb_set_features_gbeth(struct net_device *ndev,
 static int ravb_set_features_rcar(struct net_device *ndev,
 				  netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(ndev, features);
 
 	if (changed & NETIF_F_RXCSUM)
 		ravb_set_rx_csum(ndev, features & NETIF_F_RXCSUM);
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 79cdd0b8d2e7..a393796f721a 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2932,7 +2932,7 @@ static void sh_eth_set_rx_csum(struct net_device *ndev, bool enable)
 static int sh_eth_set_features(struct net_device *ndev,
 			       netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(ndev, features);
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 
 	if (changed & NETIF_F_RXCSUM && mdp->cd->rx_csum)
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 9c6b7136f7fa..6f41b11e5570 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1779,7 +1779,7 @@ static int sxgbe_set_features(struct net_device *dev,
 			      netdev_features_t features)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 
 	if (changed & NETIF_F_RXCSUM) {
 		if (features & NETIF_F_RXCSUM) {
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 57fcebde8198..a5c47141e965 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -227,7 +227,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	tmp = net_dev->features ^ data;
+	tmp = netdev_active_features_xor(net_dev, data);
 	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER ||
 	    tmp & NETIF_F_RXFCS) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 5914f1ca989d..c8f52ad7fb83 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2194,7 +2194,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 	}
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
-	tmp = net_dev->features ^ data;
+	tmp = netdev_active_features_xor(net_dev, data);
 	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 0284eb688121..0916336e4901 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -225,7 +225,7 @@ int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	features = net_dev->features ^ data;
+	features = netdev_active_features_xor(net_dev, data);
 	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) || (features & NETIF_F_RXFCS)) {
 		/* efx_siena_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index e241f9a1fca7..0af1d6dc1838 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1920,7 +1920,7 @@ static netdev_features_t netvsc_fix_features(struct net_device *ndev,
 static int netvsc_set_features(struct net_device *ndev,
 			       netdev_features_t features)
 {
-	netdev_features_t change = features ^ ndev->features;
+	netdev_features_t change = netdev_active_features_xor(ndev, features);
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
 	struct net_device *vf_netdev = rtnl_dereference(ndevctx->vf_netdev);
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index d55be54264f8..4fb65f445586 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -593,7 +593,7 @@ static int aqc111_set_features(struct net_device *net,
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct aqc111_data *aqc111_data = dev->driver_priv;
-	netdev_features_t changed = net->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(net, features);
 	u16 reg16 = 0;
 	u8 reg8 = 0;
 
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 3d5f0241f2bc..d04e8a14a8ba 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -898,7 +898,7 @@ ax88179_set_features(struct net_device *net, netdev_features_t features)
 {
 	u8 tmp;
 	struct usbnet *dev = netdev_priv(net);
-	netdev_features_t changed = net->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(net, features);
 
 	if (changed & NETIF_F_IP_CSUM) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c457b4252c68..1de9c5bd9595 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3251,7 +3251,7 @@ static void rtl_rx_vlan_en(struct r8152 *tp, bool enable)
 static int rtl8152_set_features(struct net_device *dev,
 				netdev_features_t features)
 {
-	netdev_features_t changed = features ^ dev->features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	struct r8152 *tp = netdev_priv(dev);
 	int ret;
 
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index c4805165eb65..2e4039b578ad 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1475,7 +1475,7 @@ static netdev_features_t veth_fix_features(struct net_device *dev,
 static int veth_set_features(struct net_device *dev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = features ^ dev->features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	struct veth_priv *priv = netdev_priv(dev);
 	int err;
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d3eb1f5570d3..952af46cf956 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3017,7 +3017,7 @@ static int virtnet_set_features(struct net_device *dev,
 	u64 offloads;
 	int err;
 
-	if ((dev->features ^ features) & NETIF_F_GRO_HW) {
+	if ((netdev_active_features_xor(dev, features)) & NETIF_F_GRO_HW) {
 		if (vi->xdp_enabled)
 			return -EBUSY;
 
@@ -3033,7 +3033,7 @@ static int virtnet_set_features(struct net_device *dev,
 		vi->guest_offloads = offloads;
 	}
 
-	if ((dev->features ^ features) & NETIF_F_RXHASH) {
+	if ((netdev_active_features_xor(dev, features)) & NETIF_F_RXHASH) {
 		if (features & NETIF_F_RXHASH)
 			vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
 		else
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index faeb7bcc0cf2..850758b6252f 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -415,7 +415,7 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	unsigned long flags;
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 	netdev_features_t tun_offload_mask;
 	u8 udp_tun_enabled;
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 7889ca14213e..98e444f4c8f6 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6861,7 +6861,7 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 int qeth_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qeth_card *card = dev->ml_priv;
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(dev, features);
 	int rc = 0;
 
 	QETH_CARD_TEXT(card, 2, "setfeat");
@@ -6899,14 +6899,15 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 			netdev_feature_change(NETIF_F_TSO6_BIT, &changed);
 	}
 
-	qeth_check_restricted_features(card, dev->features ^ features,
-				       dev->features ^ changed);
+	qeth_check_restricted_features(card,
+				       netdev_active_features_xor(dev, features),
+				       netdev_active_features_xor(dev, changed));
 
 	/* everything changed successfully? */
-	if ((dev->features ^ features) == changed)
+	if ((netdev_active_features_xor(dev, features)) == changed)
 		return 0;
 	/* something went wrong. save changed features and return error */
-	dev->features ^= changed;
+	netdev_active_features_toggle(dev, changed);
 	return -EIO;
 }
 EXPORT_SYMBOL_GPL(qeth_set_features);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 43c17f542583..7515e4d50999 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2270,7 +2270,7 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 static int qlge_set_features(struct net_device *ndev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed = netdev_active_features_xor(ndev, features);
 	int err;
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
diff --git a/net/core/dev.c b/net/core/dev.c
index ca5dc39cd412..4ddb0bf86dcc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9756,7 +9756,7 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_sync_lower_features(dev, lower, features);
 
 	if (!err) {
-		netdev_features_t diff = features ^ dev->features;
+		netdev_features_t diff = netdev_active_features_xor(dev, features);
 
 		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
 			/* udp_tunnel_{get,drop}_rx_info both need
-- 
2.33.0

