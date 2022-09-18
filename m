Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0345BBD1B
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiIRJvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiIRJuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA23B12612
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbw3Q09zlVwM;
        Sun, 18 Sep 2022 17:45:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:51 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 29/55] treewide: use netdev_features_xor/toggle helpers
Date:   Sun, 18 Sep 2022 09:43:10 +0000
Message-ID: <20220918094336.28958-30-shenjian15@huawei.com>
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

Replace the 'f1 = f2 ^ f3' features expressions by
netdev_features_xor helpers, and replace the 'f1 ^= f2'
feautres expressions by netdev_features_toggle helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |  4 +++-
 drivers/net/ethernet/asix/ax88796c_main.c          |  3 ++-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  3 ++-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |  3 ++-
 drivers/net/ethernet/atheros/atlx/atl2.c           |  3 ++-
 drivers/net/ethernet/atheros/atlx/atlx.c           |  3 ++-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |  7 +++++--
 drivers/net/ethernet/broadcom/tg3.c                |  3 ++-
 drivers/net/ethernet/brocade/bna/bnad.c            |  3 ++-
 drivers/net/ethernet/cadence/macb_main.c           |  4 +++-
 drivers/net/ethernet/calxeda/xgmac.c               |  3 ++-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |  3 ++-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |  3 ++-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |  3 ++-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |  3 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  3 ++-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |  3 ++-
 drivers/net/ethernet/davicom/dm9000.c              |  3 ++-
 drivers/net/ethernet/engleder/tsnep_main.c         |  3 ++-
 drivers/net/ethernet/faraday/ftgmac100.c           |  3 ++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  3 ++-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  3 ++-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  3 ++-
 drivers/net/ethernet/freescale/fec_main.c          |  6 ++++--
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |  4 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  3 ++-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     | 10 ++++++++--
 drivers/net/ethernet/ibm/ibmvnic.c                 |  3 ++-
 drivers/net/ethernet/intel/e100.c                  |  3 ++-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  3 ++-
 drivers/net/ethernet/intel/e1000e/netdev.c         |  3 ++-
 drivers/net/ethernet/intel/ice/ice_main.c          | 10 +++++++---
 drivers/net/ethernet/intel/igb/igb_main.c          |  3 ++-
 drivers/net/ethernet/intel/igc/igc_main.c          |  3 ++-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |  3 ++-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  4 +++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  3 ++-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  3 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  3 ++-
 drivers/net/ethernet/marvell/sky2.c                |  3 ++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  3 ++-
 drivers/net/ethernet/mscc/ocelot_net.c             |  3 ++-
 drivers/net/ethernet/neterion/s2io.c               |  3 ++-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  3 ++-
 drivers/net/ethernet/nvidia/forcedeth.c            |  3 ++-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |  3 ++-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |  3 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c     |  8 +++++---
 drivers/net/ethernet/qualcomm/emac/emac.c          |  3 ++-
 drivers/net/ethernet/realtek/8139cp.c              |  3 ++-
 drivers/net/ethernet/realtek/8139too.c             |  3 ++-
 drivers/net/ethernet/renesas/ravb_main.c           |  3 ++-
 drivers/net/ethernet/renesas/sh_eth.c              |  3 ++-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |  3 ++-
 drivers/net/ethernet/sfc/efx_common.c              |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c              |  2 +-
 drivers/net/ethernet/sfc/siena/efx_common.c        |  2 +-
 drivers/net/hyperv/netvsc_drv.c                    |  3 ++-
 drivers/net/usb/aqc111.c                           |  3 ++-
 drivers/net/usb/ax88179_178a.c                     |  3 ++-
 drivers/net/usb/r8152.c                            |  4 +++-
 drivers/net/veth.c                                 |  3 ++-
 drivers/net/virtio_net.c                           |  6 ++++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |  3 ++-
 drivers/s390/net/qeth_core_main.c                  | 14 +++++++++-----
 drivers/staging/qlge/qlge_main.c                   |  3 ++-
 net/core/dev.c                                     |  3 ++-
 net/ethtool/ioctl.c                                |  5 +++--
 71 files changed, 173 insertions(+), 84 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index aac5d0936912..b7867dcd5289 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -167,6 +167,7 @@ static int aq_ndev_set_features(struct net_device *ndev,
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	bool need_ndev_restart = false;
 	struct aq_nic_cfg_s *aq_cfg;
+	netdev_features_t changed;
 	bool is_lro = false;
 	int err = 0;
 
@@ -198,7 +199,8 @@ static int aq_ndev_set_features(struct net_device *ndev,
 		}
 	}
 
-	if ((aq_nic->ndev->features ^ features) & NETIF_F_RXCSUM) {
+	netdev_features_xor(changed, aq_nic->ndev->features, features);
+	if (changed & NETIF_F_RXCSUM) {
 		err = aq_nic->aq_hw_ops->hw_set_offload(aq_nic->aq_hw,
 							aq_cfg);
 
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index ee4428ef59fb..8ad92c2f92cb 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -924,8 +924,9 @@ static int
 ax88796c_set_features(struct net_device *ndev, netdev_features_t features)
 {
 	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
-	netdev_features_t changed = features ^ ndev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, ndev->features, features);
 	if (!(changed & ax88796c_features))
 		return 0;
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 2562f5e443b0..8cffd89c855e 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -531,8 +531,9 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 static int atl1c_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		atl1c_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 8da6938e2335..b1fdc855ae84 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -400,8 +400,9 @@ static netdev_features_t atl1e_fix_features(struct net_device *netdev,
 static int atl1e_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		atl1e_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index f428181b9d0b..4dde0f0b5620 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -390,8 +390,9 @@ static netdev_features_t atl2_fix_features(struct net_device *netdev,
 static int atl2_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		atl2_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index b87d4bf67747..24679d304234 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -255,8 +255,9 @@ static netdev_features_t atlx_fix_features(struct net_device *netdev,
 static int atlx_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		atlx_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index a957ec4f60fd..44c4d94ad7e3 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4905,8 +4905,9 @@ netdev_features_t bnx2x_fix_features(struct net_device *dev,
 	struct bnx2x *bp = netdev_priv(dev);
 
 	if (pci_num_vf(bp->pdev)) {
-		netdev_features_t changed = dev->features ^ features;
+		netdev_features_t changed;
 
+		netdev_features_xor(changed, dev->features, features);
 		/* Revert the requested changes in features if they
 		 * would require internal reload of PF in bnx2x_set_features().
 		 */
@@ -4940,10 +4941,12 @@ netdev_features_t bnx2x_fix_features(struct net_device *dev,
 int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct bnx2x *bp = netdev_priv(dev);
-	netdev_features_t changes = features ^ dev->features;
+	netdev_features_t changes;
 	bool bnx2x_reload = false;
 	int rc;
 
+	netdev_features_xor(changes, features, dev->features);
+
 	/* VFs or non SRIOV PFs should be able to change loopback feature */
 	if (!pci_num_vf(bp->pdev)) {
 		if (features & NETIF_F_LOOPBACK) {
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index c5b75539bb7f..720c48bd117f 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8317,8 +8317,9 @@ static netdev_features_t tg3_fix_features(struct net_device *dev,
 
 static int tg3_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if ((changed & NETIF_F_LOOPBACK) && netif_running(dev))
 		tg3_set_loopback(dev, features);
 
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index ca543079316a..b0f1da5175ca 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3347,8 +3347,9 @@ bnad_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 static int bnad_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct bnad *bnad = netdev_priv(dev);
-	netdev_features_t changed = features ^ dev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if ((changed & NETIF_F_HW_VLAN_CTAG_RX) && netif_running(dev)) {
 		unsigned long flags;
 
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c76bd2b4d245..e608f0c41071 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3743,7 +3743,9 @@ static int macb_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct macb *bp = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
+
+	netdev_features_xor(changed, netdev->features, features);
 
 	/* TX checksum offload */
 	if (changed & NETIF_F_HW_CSUM)
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 531686bf9426..5405aeb04200 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1492,8 +1492,9 @@ static int xgmac_set_features(struct net_device *dev, netdev_features_t features
 	u32 ctrl;
 	struct xgmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = priv->base;
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (!(changed & NETIF_F_RXCSUM))
 		return 0;
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 232dc5d31db6..c9807b759702 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1850,9 +1850,10 @@ static netdev_features_t liquidio_fix_features(struct net_device *netdev,
 static int liquidio_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct lio *lio = netdev_priv(netdev);
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (!(changed & NETIF_F_LRO))
 		return 0;
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index d43da69d2213..0c1a0eb9d1a6 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1789,8 +1789,9 @@ static int nicvf_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct nicvf *nic = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		nicvf_config_vlan_stripping(nic, features);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 243990dc9c09..00e2492d944b 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -880,9 +880,10 @@ static netdev_features_t t1_fix_features(struct net_device *dev,
 
 static int t1_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	struct adapter *adapter = dev->ml_priv;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		t1_vlan_mode(adapter, features);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 17c26c54a71e..7c3c4729363a 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2605,8 +2605,9 @@ static netdev_features_t cxgb_fix_features(struct net_device *dev,
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		cxgb_vlan_mode(dev, features);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index da5989ec5bd2..10aa8786c4d3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1273,10 +1273,11 @@ int cxgb4_set_rspq_intr_params(struct sge_rspq *q,
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	const struct port_info *pi = netdev_priv(dev);
+	netdev_features_t changed;
 	int err;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (!(changed & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 63fdfe40b813..64de70b13ded 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1193,8 +1193,9 @@ static int cxgb4vf_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct port_info *pi = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		t4vf_set_rxmode(pi->adapter, pi->viid, -1, -1, -1, -1,
 				features & NETIF_F_HW_VLAN_CTAG_TX, 0);
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index f16bb16bf892..f859ea1e8fdb 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -587,9 +587,10 @@ static int dm9000_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct board_info *dm = to_dm9000_board(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 	unsigned long flags;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (!(changed & NETIF_F_RXCSUM))
 		return 0;
 
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 555ccc62d6d5..4d1dc4c82541 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1056,10 +1056,11 @@ static int tsnep_netdev_set_features(struct net_device *netdev,
 				     netdev_features_t features)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 	bool enable;
 	int retval = 0;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_LOOPBACK) {
 		enable = !!(features & NETIF_F_LOOPBACK);
 		retval = tsnep_phy_loopback(adapter, enable);
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 0a8c6bcff3fb..0ba3df97b8c8 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1597,11 +1597,12 @@ static int ftgmac100_set_features(struct net_device *netdev,
 				  netdev_features_t features)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 
 	if (!netif_running(netdev))
 		return 0;
 
+	netdev_features_xor(changed, netdev->features, features);
 	/* Update the vlan filtering bit */
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
 		u32 maccr;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 51a5105da784..ebba24e81ff9 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2422,10 +2422,11 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 				  netdev_features_t features)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	netdev_features_t changed = features ^ net_dev->features;
+	netdev_features_t changed;
 	bool enable;
 	int err;
 
+	netdev_features_xor(changed, net_dev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		enable = !!(features & NETIF_F_HW_VLAN_CTAG_FILTER);
 		err = dpaa2_eth_set_rx_vlan_filtering(priv, enable);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4470a4a3e4c3..171c13c01658 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2644,9 +2644,10 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed;
 	int err = 0;
 
+	netdev_features_xor(changed, ndev->features, features);
 	if (changed & NETIF_F_RXHASH)
 		enetc_set_rss(ndev, !!(features & NETIF_F_RXHASH));
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 726f73bb3653..6cac44808e60 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -708,9 +708,10 @@ static int enetc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 static int enetc_pf_set_features(struct net_device *ndev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, ndev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		struct enetc_pf *pf = enetc_si_priv(priv->si);
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 5bd71fb7ea80..6a1513c91e77 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3450,8 +3450,9 @@ static inline void fec_enet_set_netdev_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	netdev->features = features;
 
 	/* Receive checksum has been changed */
@@ -3467,8 +3468,9 @@ static int fec_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (netif_running(netdev) && changed & NETIF_F_RXCSUM) {
 		napi_disable(&fep->napi);
 		netif_tx_lock_bh(netdev);
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index e7384570b535..6bb30e21d8db 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/net_tstamp.h>
 #include <linux/skbuff.h>
@@ -507,10 +508,11 @@ static int gfar_spauseparam(struct net_device *dev,
 
 int gfar_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	struct gfar_private *priv = netdev_priv(dev);
+	netdev_features_t changed;
 	int err = 0;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (!(changed & netdev_ctag_vlan_offload_features) &&
 	    !(changed & NETIF_F_RXCSUM))
 		return 0;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index bf7bafd465b4..31d8da9aeb5f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2405,12 +2405,13 @@ static int hns3_nic_do_ioctl(struct net_device *netdev,
 static int hns3_nic_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
+	netdev_features_t changed;
 	bool enable;
 	int ret;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_GRO_HW && h->ae_algo->ops->set_gro_en) {
 		enable = !!(features & NETIF_F_GRO_HW);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index dc1f7c6d8049..d04e95313da7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1061,12 +1061,17 @@ static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change)
 {
-	netdev_features_t changed = force_change ? ~0 : pre_features ^ features;
 	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
 	netdev_features_t failed_features;
+	netdev_features_t changed;
 	int ret = 0;
 	int err = 0;
 
+	if (force_change)
+		netdev_features_fill(changed);
+	else
+		netdev_features_xor(changed, pre_features, features);
+
 	netdev_features_zero(failed_features);
 	if (changed & NETIF_F_TSO) {
 		ret = hinic_port_set_tso(nic_dev, (features & NETIF_F_TSO) ?
@@ -1109,7 +1114,8 @@ static int set_features(struct hinic_dev *nic_dev,
 	}
 
 	if (err) {
-		nic_dev->netdev->features = features ^ failed_features;
+		netdev_active_features_xor(nic_dev->netdev, features,
+					   failed_features);
 		return -EIO;
 	}
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 32e09372fe0d..23bc8c228ce8 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4899,7 +4899,8 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		/* disable features no longer supported */
 		adapter->netdev->features &= adapter->netdev->hw_features;
 		/* turn on features now supported if previously enabled */
-		tmp = old_hw_features ^ adapter->netdev->hw_features;
+		netdev_features_xor(tmp, old_hw_features,
+				    adapter->netdev->hw_features);
 		tmp &= adapter->netdev->hw_features;
 		tmp &= adapter->netdev->wanted_features;
 		netdev_active_features_set(adapter->netdev, tmp);
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 802016d61d54..a715fcb2b3f2 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2804,8 +2804,9 @@ static int e100_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct nic *nic = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (!(changed & NETIF_F_RXFCS && changed & NETIF_F_RXALL))
 		return 0;
 
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 0021ff6ea0a0..f3d8c71354e5 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -805,8 +805,9 @@ static int e1000_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		e1000_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 7bbab2dca5c0..f7c201d06e54 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7316,9 +7316,10 @@ static int e1000_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
 	netdev_features_t changeable;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & netdev_general_tso_features)
 		adapter->flags |= FLAG_TSO_FORCE;
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 0a4ffc45cc70..6e4dd1aae6d5 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5964,7 +5964,8 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 
 	current_vlan_features = netdev->features & NETIF_VLAN_OFFLOAD_FEATURES;
 	requested_vlan_features = features & NETIF_VLAN_OFFLOAD_FEATURES;
-	diff = current_vlan_features ^ requested_vlan_features;
+	netdev_features_xor(diff, current_vlan_features,
+			    requested_vlan_features);
 	if (diff) {
 		if ((features & NETIF_F_RXFCS) &&
 		    (features & NETIF_VLAN_STRIPPING_FEATURES)) {
@@ -5981,7 +5982,8 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	current_vlan_features = netdev->features &
 		NETIF_VLAN_FILTERING_FEATURES;
 	requested_vlan_features = features & NETIF_VLAN_FILTERING_FEATURES;
-	diff = current_vlan_features ^ requested_vlan_features;
+	netdev_features_xor(diff, current_vlan_features,
+			    requested_vlan_features);
 	if (diff) {
 		err = ice_set_vlan_filtering_features(vsi, features);
 		if (err)
@@ -6025,10 +6027,10 @@ static int ice_set_loopback(struct ice_vsi *vsi, bool ena)
 static int
 ice_set_features(struct net_device *netdev, netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_pf *pf = vsi->back;
+	netdev_features_t changed;
 	int ret = 0;
 
 	/* Don't set any netdev advanced features with device in Safe Mode */
@@ -6045,6 +6047,8 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 		return -EBUSY;
 	}
 
+	netdev_features_xor(changed, netdev->features, features);
+
 	/* Multiple features can be changed in one call so keep features in
 	 * separate if/else statements to guarantee each feature is checked
 	 */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 8596c3e925a3..2a03b70bac35 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2449,9 +2449,10 @@ static netdev_features_t igb_fix_features(struct net_device *netdev,
 static int igb_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct igb_adapter *adapter = netdev_priv(netdev);
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		igb_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index fd1db5a1f12d..781555d4d9a7 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4989,9 +4989,10 @@ static netdev_features_t igc_fix_features(struct net_device *netdev,
 static int igc_set_features(struct net_device *netdev,
 			    netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct igc_adapter *adapter = netdev_priv(netdev);
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		igc_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 5d72dcf1dcb3..0b324849ccd0 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -311,8 +311,9 @@ static int
 ixgb_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (!(changed & NETIF_F_RXCSUM) && !(changed & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 6f908468fdeb..288384161dac 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9871,9 +9871,11 @@ static int ixgbe_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
+	netdev_features_t changed;
 	bool need_reset = false;
 
+	netdev_features_xor(changed, netdev->features, features);
+
 	/* Make sure RSC matches LRO, reset if change */
 	if (!(features & NETIF_F_LRO)) {
 		if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 369aa0a80212..1c73afaeed86 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5279,9 +5279,10 @@ static int mvpp2_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 static int mvpp2_set_features(struct net_device *dev,
 			      netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	struct mvpp2_port *port = netdev_priv(dev);
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		if (features & NETIF_F_HW_VLAN_CTAG_FILTER) {
 			mvpp2_prs_vid_enable_filtering(port);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index cb0102417a68..eb95fbb32b6d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1769,11 +1769,12 @@ EXPORT_SYMBOL(otx2_get_max_mtu);
 
 int otx2_handle_ntuple_tc_features(struct net_device *netdev, netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	bool ntuple = !!(features & NETIF_F_NTUPLE);
 	bool tc = !!(features & NETIF_F_HW_TC);
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if ((changed & NETIF_F_NTUPLE) && !ntuple)
 		otx2_destroy_ntuple_flows(pfvf);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index f2a975e2a75a..f3cdef7edff4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1933,9 +1933,10 @@ static void otx2_rx_mode_wrk_handler(struct work_struct *work)
 static int otx2_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
 	struct otx2_nic *pf = netdev_priv(netdev);
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if ((changed & NETIF_F_LOOPBACK) && netif_running(netdev))
 		return otx2_cgx_config_loopback(pf,
 						features & NETIF_F_LOOPBACK);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 0e2908c8f8b2..c601bbf8eeb7 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4335,8 +4335,9 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 static int sky2_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if ((changed & NETIF_F_RXCSUM) &&
 	    !(sky2->hw->flags & SKY2_HW_NEW_LE)) {
 		sky2_write32(sky2->hw,
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 50cebfe2a426..6f8564886a55 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2716,9 +2716,11 @@ static netdev_features_t mtk_fix_features(struct net_device *dev,
 
 static int mtk_set_features(struct net_device *dev, netdev_features_t features)
 {
+	netdev_features_t changed;
 	int err = 0;
 
-	if (!((dev->features ^ features) & NETIF_F_LRO))
+	netdev_features_xor(changed, dev->features, features);
+	if (!(changed & NETIF_F_LRO))
 		return 0;
 
 	if (!(features & NETIF_F_LRO))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 70ac775a53e6..a67b7be0e500 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3842,10 +3842,11 @@ static int mlx5e_handle_feature(struct net_device *netdev,
 				unsigned short feature_bit,
 				mlx5e_feature_handler feature_handler)
 {
-	netdev_features_t changes = *features ^ netdev->features;
 	bool enable = netdev_feature_test(feature_bit, *features);
+	netdev_features_t changes;
 	int err;
 
+	netdev_features_xor(changes, netdev->features, *features);
 	if (!netdev_feature_test(feature_bit, changes))
 		return 0;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 702edcfa25a3..9b1934a897e0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1220,10 +1220,11 @@ static int mlxsw_sp_handle_feature(struct net_device *dev,
 				   int feature_bit,
 				   mlxsw_sp_feature_handler feature_handler)
 {
-	netdev_features_t changes = wanted_features ^ dev->features;
 	bool enable = netdev_feature_test(feature_bit, wanted_features);
+	netdev_features_t changes;
 	int err;
 
+	netdev_features_xor(changes, dev->features, wanted_features);
 	if (!netdev_feature_test(feature_bit, changes))
 		return 0;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index afa7fe88bb73..254958b08505 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -859,11 +859,12 @@ static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
 static int ocelot_set_features(struct net_device *dev,
 			       netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if ((dev->features & NETIF_F_HW_TC) && !(features & NETIF_F_HW_TC) &&
 	    priv->tc.offload_cnt) {
 		netdev_err(dev,
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index dbc46e260969..c6002fe4d2d3 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -6571,8 +6571,9 @@ static void s2io_ethtool_get_strings(struct net_device *dev,
 static int s2io_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct s2io_nic *sp = netdev_priv(dev);
-	netdev_features_t changed = features ^ dev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (changed & NETIF_F_LRO && netif_running(dev)) {
 		int rc;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 943598704e9a..7af1dd2709ac 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1666,8 +1666,8 @@ static void nfp_net_stat64(struct net_device *netdev,
 static int nfp_net_set_features(struct net_device *netdev,
 				netdev_features_t features)
 {
-	netdev_features_t changed = netdev->features ^ features;
 	struct nfp_net *nn = netdev_priv(netdev);
+	netdev_features_t changed;
 	u32 new_ctrl;
 	int err;
 
@@ -1675,6 +1675,7 @@ static int nfp_net_set_features(struct net_device *netdev,
 
 	new_ctrl = nn->dp.ctrl;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_RXCSUM) {
 		if (features & NETIF_F_RXCSUM)
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index acf3b88f9edb..528bcedda177 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4962,9 +4962,10 @@ static int nv_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 	int retval;
 
+	netdev_features_xor(changed, dev->features, features);
 	if ((changed & NETIF_F_LOOPBACK) && netif_running(dev)) {
 		retval = nv_set_loopback(dev, features);
 		if (retval != 0)
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index ab519deead53..0062c75e7d84 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2206,8 +2206,9 @@ static int pch_gbe_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = features ^ netdev->features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (!(changed & NETIF_F_RXCSUM))
 		return 0;
 
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 99d8e3c17510..1d34037c9bc8 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -539,7 +539,7 @@ static int netxen_set_features(struct net_device *dev,
 	netdev_features_t changed;
 	int hw_lro;
 
-	changed = dev->features ^ features;
+	netdev_features_xor(changed, dev->features, features);
 	if (!(changed & NETIF_F_LRO))
 		return 0;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 53565295b73c..a3635890a0e2 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -925,9 +925,10 @@ netdev_features_t qede_fix_features(struct net_device *dev,
 int qede_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	netdev_features_t changes = features ^ dev->features;
+	netdev_features_t changes;
 	bool need_reload = false;
 
+	netdev_features_xor(changes, dev->features, features);
 	if (changes & NETIF_F_GRO_HW)
 		need_reload = true;
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index e2b74569ae82..abfe0de86ff9 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1070,7 +1070,8 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 		if (adapter->flags & QLCNIC_APP_CHANGED_FLAGS) {
 			features = qlcnic_process_flags(adapter, features);
 		} else {
-			changed = features ^ netdev->features;
+			netdev_features_xor(changed, netdev->features,
+					    features);
 			netdev_features_zero(changeable);
 			netdev_features_set_set(changeable,
 						NETIF_F_RXCSUM_BIT,
@@ -1079,7 +1080,7 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 						NETIF_F_TSO_BIT,
 						NETIF_F_TSO6_BIT);
 			changed &= changeable;
-			features ^= changed;
+			netdev_features_toggle(features, changed);
 		}
 	}
 
@@ -1093,9 +1094,10 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 int qlcnic_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed = netdev->features ^ features;
 	int hw_lro = (features & NETIF_F_LRO) ? QLCNIC_LRO_ENABLED : 0;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (!(changed & NETIF_F_LRO))
 		return 0;
 
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index e79187d50c20..de4803b911cd 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -176,9 +176,10 @@ static irqreturn_t emac_isr(int _irq, void *data)
 static int emac_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = features ^ netdev->features;
 	struct emac_adapter *adpt = netdev_priv(netdev);
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, netdev->features, features);
 	/* We only need to reprogram the hardware if the VLAN tag features
 	 * have changed, and if it's already running.
 	 */
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 7d97b3e012e5..eb0fec232e04 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1461,10 +1461,11 @@ static void cp_set_msglevel(struct net_device *dev, u32 value)
 
 static int cp_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed = dev->features ^ features;
 	struct cp_private *cp = netdev_priv(dev);
+	netdev_features_t changed;
 	unsigned long flags;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (!(changed & NETIF_F_RXCSUM))
 		return 0;
 
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 702b4b111729..e90df0de255e 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -902,9 +902,10 @@ static int rtl8139_set_features(struct net_device *dev, netdev_features_t featur
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
 	unsigned long flags;
-	netdev_features_t changed = features ^ dev->features;
+	netdev_features_t changed;
 	void __iomem *ioaddr = tp->mmio_addr;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (!(changed & NETIF_F_RXALL))
 		return 0;
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index d7ca2bf7cf3b..d7d6f2798d88 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2336,8 +2336,9 @@ static int ravb_set_features_gbeth(struct net_device *ndev,
 static int ravb_set_features_rcar(struct net_device *ndev,
 				  netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, ndev->features, features);
 	if (changed & NETIF_F_RXCSUM)
 		ravb_set_rx_csum(ndev, features & NETIF_F_RXCSUM);
 
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 72aa825bfc03..b01318964100 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2932,9 +2932,10 @@ static void sh_eth_set_rx_csum(struct net_device *ndev, bool enable)
 static int sh_eth_set_features(struct net_device *ndev,
 			       netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
 	struct sh_eth_private *mdp = netdev_priv(ndev);
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, ndev->features, features);
 	if (changed & NETIF_F_RXCSUM && mdp->cd->rx_csum)
 		sh_eth_set_rx_csum(ndev, features & NETIF_F_RXCSUM);
 
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 624079763107..97f884c1993b 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1779,8 +1779,9 @@ static int sxgbe_set_features(struct net_device *dev,
 			      netdev_features_t features)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (changed & NETIF_F_RXCSUM) {
 		if (features & NETIF_F_RXCSUM) {
 			priv->hw->mac->enable_rx_csum(priv->ioaddr);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 9fcad774a052..3d57a23022b7 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -227,7 +227,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	tmp = net_dev->features ^ data;
+	netdev_features_xor(tmp, net_dev->features, data);
 	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER ||
 	    tmp & NETIF_F_RXFCS) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 016c459a3cfd..854e1bca7ac9 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2194,7 +2194,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 	}
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
-	tmp = net_dev->features ^ data;
+	netdev_features_xor(tmp, net_dev->features, data);
 	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 808104cf5220..2693b2386916 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -225,7 +225,7 @@ int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	features = net_dev->features ^ data;
+	netdev_features_xor(features, net_dev->features, data);
 	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) || (features & NETIF_F_RXFCS)) {
 		/* efx_siena_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 6c39c7def645..e9d8ffa45703 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1922,16 +1922,17 @@ static netdev_features_t netvsc_fix_features(struct net_device *ndev,
 static int netvsc_set_features(struct net_device *ndev,
 			       netdev_features_t features)
 {
-	netdev_features_t change = features ^ ndev->features;
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
 	struct net_device *vf_netdev = rtnl_dereference(ndevctx->vf_netdev);
 	struct ndis_offload_params offloads;
+	netdev_features_t change;
 	int ret = 0;
 
 	if (!nvdev || nvdev->destroy)
 		return -ENODEV;
 
+	netdev_features_xor(change, ndev->features, features);
 	if (!(change & NETIF_F_LRO))
 		goto syncvf;
 
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index bf6d429b31f2..134de64d4be7 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -593,10 +593,11 @@ static int aqc111_set_features(struct net_device *net,
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct aqc111_data *aqc111_data = dev->driver_priv;
-	netdev_features_t changed = net->features ^ features;
+	netdev_features_t changed;
 	u16 reg16 = 0;
 	u8 reg8 = 0;
 
+	netdev_features_xor(changed, net->features, features);
 	if (changed & NETIF_F_IP_CSUM) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL, 1, 1, &reg8);
 		reg8 ^= SFR_TXCOE_TCP | SFR_TXCOE_UDP;
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 88a57c8ad62f..755d99e1815a 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -898,8 +898,9 @@ ax88179_set_features(struct net_device *net, netdev_features_t features)
 {
 	u8 tmp;
 	struct usbnet *dev = netdev_priv(net);
-	netdev_features_t changed = net->features ^ features;
+	netdev_features_t changed;
 
+	netdev_features_xor(changed, net->features, features);
 	if (changed & NETIF_F_IP_CSUM) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 		tmp ^= AX_TXCOE_TCP | AX_TXCOE_UDP;
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 510531a79221..ba71a6d9a9da 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3255,14 +3255,16 @@ static void rtl_rx_vlan_en(struct r8152 *tp, bool enable)
 static int rtl8152_set_features(struct net_device *dev,
 				netdev_features_t features)
 {
-	netdev_features_t changed = features ^ dev->features;
 	struct r8152 *tp = netdev_priv(dev);
+	netdev_features_t changed;
 	int ret;
 
 	ret = usb_autopm_get_interface(tp->intf);
 	if (ret < 0)
 		goto out;
 
+	netdev_features_xor(changed, dev->features, features);
+
 	mutex_lock(&tp->control);
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index cde2f29ce9a6..1b6d33903a47 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1471,10 +1471,11 @@ static netdev_features_t veth_fix_features(struct net_device *dev,
 static int veth_set_features(struct net_device *dev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = features ^ dev->features;
 	struct veth_priv *priv = netdev_priv(dev);
+	netdev_features_t changed;
 	int err;
 
+	netdev_features_xor(changed, dev->features, features);
 	if (!(changed & NETIF_F_GRO) || !(dev->flags & IFF_UP) || priv->_xdp_prog)
 		return 0;
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4900ab1bdea6..ad16d382af9c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3212,10 +3212,12 @@ static int virtnet_set_features(struct net_device *dev,
 				netdev_features_t features)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
+	netdev_features_t changed;
 	u64 offloads;
 	int err;
 
-	if ((dev->features ^ features) & NETIF_F_GRO_HW) {
+	netdev_features_xor(changed, dev->features, features);
+	if (changed & NETIF_F_GRO_HW) {
 		if (vi->xdp_enabled)
 			return -EBUSY;
 
@@ -3231,7 +3233,7 @@ static int virtnet_set_features(struct net_device *dev,
 		vi->guest_offloads = offloads;
 	}
 
-	if ((dev->features ^ features) & NETIF_F_RXHASH) {
+	if (changed & NETIF_F_RXHASH) {
 		if (features & NETIF_F_RXHASH)
 			vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
 		else
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index d9be2fc80de2..8d664a9e4bd9 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -411,8 +411,8 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	unsigned long flags;
-	netdev_features_t changed = features ^ netdev->features;
 	netdev_features_t tun_offload_mask;
+	netdev_features_t changed;
 	u8 udp_tun_enabled;
 
 	netdev_features_zero(tun_offload_mask);
@@ -420,6 +420,7 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 	netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, tun_offload_mask);
 	udp_tun_enabled = (netdev->features & tun_offload_mask) != 0;
 
+	netdev_features_xor(changed, netdev->features, features);
 	if (changed & NETIF_F_RXCSUM ||
 	    changed & NETIF_F_LRO ||
 	    changed & NETIF_F_HW_VLAN_CTAG_RX ||
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 762968b23edc..6105c02a723b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6789,12 +6789,15 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 int qeth_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qeth_card *card = dev->ml_priv;
-	netdev_features_t changed = dev->features ^ features;
+	netdev_features_t changed;
+	netdev_features_t diff1;
+	netdev_features_t diff2;
 	int rc = 0;
 
 	QETH_CARD_TEXT(card, 2, "setfeat");
 	QETH_CARD_HEX(card, 2, &features, sizeof(features));
 
+	netdev_features_xor(changed, dev->features, features);
 	if ((changed & NETIF_F_IP_CSUM)) {
 		rc = qeth_set_ipa_csum(card, features & NETIF_F_IP_CSUM,
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV4,
@@ -6827,14 +6830,15 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 			netdev_feature_change(NETIF_F_TSO6_BIT, changed);
 	}
 
-	qeth_check_restricted_features(card, dev->features ^ features,
-				       dev->features ^ changed);
+	netdev_features_xor(diff1, dev->features, features);
+	netdev_features_xor(diff2, dev->features, changed);
+	qeth_check_restricted_features(card, diff1, diff2);
 
 	/* everything changed successfully? */
-	if ((dev->features ^ features) == changed)
+	if (diff1 == changed)
 		return 0;
 	/* something went wrong. save changed features and return error */
-	dev->features ^= changed;
+	netdev_active_features_toggle(dev, changed);
 	return -EIO;
 }
 EXPORT_SYMBOL_GPL(qeth_set_features);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 4b248fe59e67..6bcf77c35bab 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2270,9 +2270,10 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 static int qlge_set_features(struct net_device *ndev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed = ndev->features ^ features;
+	netdev_features_t changed;
 	int err;
 
+	netdev_features_xor(changed, ndev->features, features);
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX) {
 		/* Update the behavior of vlan accel in the adapter */
 		err = qlge_update_hw_vlan_features(ndev, features);
diff --git a/net/core/dev.c b/net/core/dev.c
index fb32cd8e8c3e..528c7da47a44 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9761,8 +9761,9 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_sync_lower_features(dev, lower, features);
 
 	if (!err) {
-		netdev_features_t diff = features ^ dev->features;
+		netdev_features_t diff;
 
+		netdev_features_xor(diff, dev->features, features);
 		if (diff & NETIF_F_RX_UDP_TUNNEL_PORT) {
 			/* udp_tunnel_{get,drop}_rx_info both need
 			 * NETIF_F_RX_UDP_TUNNEL_PORT enabled on the
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 21045ba78350..595b8dae7fa3 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -162,7 +162,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	netdev_wanted_features_set(dev, tmp);
 	__netdev_update_features(dev);
 
-	tmp = dev->wanted_features ^ dev->features;
+	netdev_features_xor(tmp, dev->wanted_features, dev->features);
+
 	if (tmp & valid)
 		ret |= ETHTOOL_F_WISH;
 
@@ -355,7 +356,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 				NETIF_F_NTUPLE_BIT, NETIF_F_RXHASH_BIT);
 
 	/* allow changing only bits set in hw_features */
-	changed = dev->features ^ features;
+	netdev_features_xor(changed, dev->features, features);
 	changed &= eth_all_features;
 	netdev_features_andnot(tmp, changed, dev->hw_features);
 	if (tmp)
-- 
2.33.0

