Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE13B5BBD2C
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiIRJvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiIRJud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:33 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045381571B
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:57 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MVjbt0RYYzlVvp;
        Sun, 18 Sep 2022 17:45:46 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:49 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 15/55] treewide: simplify the netdev features expression
Date:   Sun, 18 Sep 2022 09:42:56 +0000
Message-ID: <20220918094336.28958-16-shenjian15@huawei.com>
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

Split the complex opreation of netdev_features to simple ones,
and replace some feature macroes with global netdev features
variables. So they can be replaced by netdev features helpers
later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/bonding/bond_main.c               | 10 ++--
 drivers/net/ethernet/aeroflex/greth.c         |  3 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  3 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  4 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  3 +-
 drivers/net/ethernet/broadcom/bnx2.c          | 10 ++--
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  6 ++-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  6 ++-
 drivers/net/ethernet/cadence/macb_main.c      | 15 +++---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 10 ++--
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 10 ++--
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  7 +--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  6 ++-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  3 +-
 drivers/net/ethernet/cortina/gemini.c         |  3 +-
 drivers/net/ethernet/engleder/tsnep_main.c    |  3 +-
 drivers/net/ethernet/freescale/gianfar.c      |  3 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  3 +-
 .../ethernet/fungible/funeth/funeth_main.c    |  9 ++--
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  3 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  9 ++--
 .../net/ethernet/huawei/hinic/hinic_main.c    |  3 +-
 drivers/net/ethernet/ibm/emac/core.c          |  3 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  8 ++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  8 ++--
 drivers/net/ethernet/intel/e100.c             |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 10 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  9 ++--
 drivers/net/ethernet/intel/ice/ice_main.c     | 23 +++++----
 drivers/net/ethernet/intel/igb/igb_main.c     |  8 ++--
 drivers/net/ethernet/intel/igbvf/netdev.c     |  9 ++--
 drivers/net/ethernet/intel/igc/igc_main.c     |  8 ++--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  6 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 ++++---
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 10 ++--
 drivers/net/ethernet/jme.c                    |  6 ++-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  3 +-
 drivers/net/ethernet/marvell/sky2.c           |  4 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  2 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  9 ++--
 drivers/net/ethernet/neterion/s2io.c          |  4 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  6 ++-
 drivers/net/ethernet/netronome/nfp/nfp_port.c |  2 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  3 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  3 +-
 drivers/net/ethernet/realtek/8139cp.c         |  3 +-
 drivers/net/ethernet/realtek/8139too.c        |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  6 ++-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  3 +-
 drivers/net/ethernet/sfc/ef10.c               |  3 +-
 drivers/net/ethernet/sfc/efx.c                |  7 ++-
 drivers/net/ethernet/sfc/efx_common.c         | 11 +++--
 drivers/net/ethernet/sfc/falcon/efx.c         | 12 +++--
 drivers/net/ethernet/sfc/siena/efx.c          |  7 ++-
 drivers/net/ethernet/sfc/siena/efx_common.c   |  7 +--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  3 +-
 drivers/net/ethernet/sun/niu.c                |  3 +-
 drivers/net/ethernet/sun/sunhme.c             |  6 ++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  4 +-
 drivers/net/hyperv/rndis_filter.c             |  7 ++-
 drivers/net/ifb.c                             |  3 +-
 drivers/net/ipvlan/ipvlan_main.c              |  9 +++-
 drivers/net/macsec.c                          | 10 ++--
 drivers/net/macvlan.c                         | 13 +++--
 drivers/net/netdevsim/netdev.c                |  2 +-
 drivers/net/team/team.c                       |  6 +--
 drivers/net/thunderbolt.c                     |  3 +-
 drivers/net/tun.c                             |  8 +++-
 drivers/net/veth.c                            |  6 ++-
 drivers/net/virtio_net.c                      |  7 ++-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  7 +--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 18 ++++---
 drivers/net/wireless/ath/ath6kl/main.c        |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  5 +-
 drivers/net/xen-netback/interface.c           |  3 +-
 include/linux/netdev_feature_helpers.h        |  7 ++-
 net/8021q/vlan.h                              | 17 ++++---
 net/8021q/vlan_dev.c                          | 14 ++++--
 net/core/dev.c                                | 48 +++++++++++++------
 net/core/pktgen.c                             |  6 ++-
 net/core/skbuff.c                             |  2 +-
 net/dccp/ipv6.c                               |  5 +-
 net/dsa/slave.c                               |  3 +-
 net/ethtool/features.c                        |  4 +-
 net/ethtool/ioctl.c                           | 47 ++++++++++++------
 net/ipv4/esp4_offload.c                       | 16 ++++---
 net/ipv4/ip_output.c                          |  3 +-
 net/ipv4/udp_offload.c                        |  6 +--
 net/ipv6/esp6_offload.c                       | 14 +++---
 net/ipv6/ip6_output.c                         |  3 +-
 net/mac80211/iface.c                          |  6 ++-
 net/openvswitch/vport-internal_dev.c          |  3 +-
 net/tls/tls_device.c                          |  2 +-
 net/xfrm/xfrm_device.c                        | 10 ++--
 98 files changed, 456 insertions(+), 252 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b3fadd51d733..2a5835c6e1c1 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1483,8 +1483,8 @@ static void bond_compute_features(struct bonding *bond)
 
 done:
 	bond_dev->vlan_features = vlan_features;
-	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				    netdev_tx_vlan_features;
+	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
+	bond_dev->hw_enc_features |= netdev_tx_vlan_features;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_enc_features |= xfrm_features;
 #endif /* CONFIG_XFRM_OFFLOAD */
@@ -5771,9 +5771,9 @@ void bond_setup(struct net_device *bond_dev)
 	/* Don't allow bond devices to change network namespaces. */
 	bond_dev->features |= NETIF_F_NETNS_LOCAL;
 
-	bond_dev->hw_features = BOND_VLAN_FEATURES |
-				NETIF_F_HW_VLAN_CTAG_RX |
-				NETIF_F_HW_VLAN_CTAG_FILTER;
+	bond_dev->hw_features = BOND_VLAN_FEATURES;
+	bond_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	bond_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	bond_dev->features |= bond_dev->hw_features;
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 6065eabcd87a..ade2b14ba53e 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1487,7 +1487,8 @@ static int greth_of_probe(struct platform_device *ofdev)
 		netdev_hw_features_set_set(dev, NETIF_F_SG_BIT,
 					   NETIF_F_IP_CSUM_BIT,
 					   NETIF_F_RXCSUM_BIT);
-		dev->features = dev->hw_features | NETIF_F_HIGHDMA;
+		dev->features = dev->hw_features;
+		dev->features |= NETIF_F_HIGHDMA;
 		greth_netdev_ops.ndo_start_xmit = greth_start_xmit_gbit;
 	}
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 89ae6d1623aa..c73df5f6ae30 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1356,7 +1356,8 @@ static int altera_tse_probe(struct platform_device *pdev)
 	 * so it is turned off
 	 */
 	ndev->hw_features &= ~NETIF_F_SG;
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
+	ndev->features |= ndev->hw_features;
+	ndev->features |=  NETIF_F_HIGHDMA;
 
 	/* VLAN offloading of tagging, stripping and filtering is not
 	 * supported by hardware, but driver will accommodate the
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 22bb34ca5a9b..e7ea9607981f 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2633,8 +2633,8 @@ static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_HW_VLAN_CTAG_RX_BIT, NETIF_F_TSO_BIT,
 				   NETIF_F_TSO6_BIT);
-	netdev->features =	netdev->hw_features	|
-				NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 13b5b706d1ce..88f6ffacb671 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2273,7 +2273,8 @@ static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_TSO_BIT,
 				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX;
 	/* not enabled by default */
 	netdev_hw_features_set_set(netdev, NETIF_F_RXALL_BIT,
 				   NETIF_F_RXFCS_BIT);
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 37b0d0b26a26..336c02b28a5d 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7754,10 +7754,14 @@ bnx2_set_features(struct net_device *dev, netdev_features_t features)
 	struct bnx2 *bp = netdev_priv(dev);
 
 	/* TSO with VLAN tag won't work with current firmware */
-	if (features & NETIF_F_HW_VLAN_CTAG_TX)
-		dev->vlan_features |= (dev->hw_features & NETIF_F_ALL_TSO);
-	else
+	if (features & NETIF_F_HW_VLAN_CTAG_TX) {
+		netdev_features_t tso;
+
+		tso = dev->hw_features & NETIF_F_ALL_TSO;
+		dev->vlan_features |= tso;
+	} else {
 		dev->vlan_features &= ~NETIF_F_ALL_TSO;
+	}
 
 	if ((!!(features & NETIF_F_HW_VLAN_CTAG_RX) !=
 	    !!(bp->rx_mode & BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG)) &&
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e704e42446aa..34b84317c736 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4912,12 +4912,14 @@ netdev_features_t bnx2x_fix_features(struct net_device *dev,
 		 */
 		if (!(features & NETIF_F_RXCSUM) && !bp->disable_tpa) {
 			features &= ~NETIF_F_RXCSUM;
-			features |= dev->features & NETIF_F_RXCSUM;
+			if (dev->features & NETIF_F_RXCSUM)
+				features |= NETIF_F_RXCSUM;
 		}
 
 		if (changed & NETIF_F_LOOPBACK) {
 			features &= ~NETIF_F_LOOPBACK;
-			features |= dev->features & NETIF_F_LOOPBACK;
+			if (dev->features & NETIF_F_LOOPBACK)
+				features |= NETIF_F_LOOPBACK;
 		}
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index ad2c38c261bc..ab8a362f87f6 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13254,7 +13254,8 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 	 * getting a response to CHANNEL_TLV_ACQUIRE from PF.
 	 */
 
-	dev->features |= dev->hw_features | NETIF_F_HW_VLAN_CTAG_RX;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 	dev->features |= NETIF_F_HIGHDMA;
 	if (dev->features & NETIF_F_LRO)
 		dev->features &= ~NETIF_F_GRO_HW;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 57559609d116..2912ea0b9987 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13625,14 +13625,16 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_gso_partial_features_zero(dev);
 	netdev_gso_partial_features_set_set(dev, NETIF_F_GSO_GRE_CSUM_BIT,
 					    NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
-	dev->vlan_features = dev->hw_features | NETIF_F_HIGHDMA;
+	dev->vlan_features = dev->hw_features;
+	dev->vlan_features |= NETIF_F_HIGHDMA;
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_RX_STRIP)
 		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_TX_INSERT)
 		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_TX;
 	if (BNXT_SUPPORTS_TPA(bp))
 		dev->hw_features |= NETIF_F_GRO_HW;
-	dev->features |= dev->hw_features | NETIF_F_HIGHDMA;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_HIGHDMA;
 	if (dev->features & NETIF_F_GRO_HW)
 		dev->features &= ~NETIF_F_LRO;
 	dev->priv_flags |= IFF_UNICAST_FLT;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index fbdce0d335c2..009e8d098cf7 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -83,7 +83,6 @@ struct sifive_fu540_macb_mgmt {
 #define GEM_MAX_TX_LEN		(unsigned int)(0x3FC0)
 
 #define GEM_MTU_MIN_SIZE	ETH_MIN_MTU
-#define MACB_NETIF_LSO		NETIF_F_TSO
 
 #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
 #define MACB_WOL_ENABLED		(0x1 << 1)
@@ -2149,8 +2148,10 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 	 * When software supplies two or more payload buffers all payload buffers
 	 * apart from the last must be a multiple of 8 bytes in size.
 	 */
-	if (!IS_ALIGNED(skb_headlen(skb) - hdrlen, MACB_TX_LEN_ALIGN))
-		return features & ~MACB_NETIF_LSO;
+	if (!IS_ALIGNED(skb_headlen(skb) - hdrlen, MACB_TX_LEN_ALIGN)) {
+		features &= ~NETIF_F_TSO;
+		return features;
+	}
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	/* No need to check last fragment */
@@ -2158,8 +2159,10 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 	for (f = 0; f < nr_frags; f++) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
-		if (!IS_ALIGNED(skb_frag_size(frag), MACB_TX_LEN_ALIGN))
-			return features & ~MACB_NETIF_LSO;
+		if (!IS_ALIGNED(skb_frag_size(frag), MACB_TX_LEN_ALIGN)) {
+			features &= ~NETIF_F_TSO;
+			return features;
+		}
 	}
 	return features;
 }
@@ -4053,7 +4056,7 @@ static int macb_init(struct platform_device *pdev)
 
 	/* Check LSO capability */
 	if (GEM_BFEXT(PBUF_LSO, gem_readl(bp, DCFG6)))
-		dev->hw_features |= MACB_NETIF_LSO;
+		dev->hw_features |= NETIF_F_TSO;
 
 	/* Checksum offload is only available on gem with packet buffer */
 	if (macb_is_gem(bp) && !(bp->caps & MACB_CAPS_FIFO_MODE))
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 27844cf7da8a..0b928aaf8b14 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3582,8 +3582,8 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					NETIF_F_RXCSUM_BIT, NETIF_F_TSO_BIT,
 					NETIF_F_TSO6_BIT, NETIF_F_LRO_BIT);
 
-		netdev->hw_enc_features = (lio->enc_dev_capability &
-					   ~NETIF_F_LRO);
+		netdev->hw_enc_features = lio->enc_dev_capability;
+		netdev->hw_enc_features &= ~NETIF_F_LRO;
 
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
@@ -3593,12 +3593,12 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		/* Add any unchangeable hw features */
 		lio->dev_capability |= netdev_ctag_vlan_features;
 
-		netdev->features = (lio->dev_capability & ~NETIF_F_LRO);
+		netdev->features = lio->dev_capability;
+		netdev->features &= ~NETIF_F_LRO;
 
 		netdev->hw_features = lio->dev_capability;
 		/*HW_VLAN_RX and HW_VLAN_FILTER is always on*/
-		netdev->hw_features = netdev->hw_features &
-			~NETIF_F_HW_VLAN_CTAG_RX;
+		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 
 		/* MTU range: 68 - 16000 */
 		netdev->min_mtu = LIO_MIN_MTU_SIZE;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index be01b71d8738..ed0ae09f9b04 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1850,9 +1850,10 @@ static netdev_features_t liquidio_fix_features(struct net_device *netdev,
 static int liquidio_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
+	netdev_features_t changed = netdev->features ^ features;
 	struct lio *lio = netdev_priv(netdev);
 
-	if (!((netdev->features ^ features) & NETIF_F_LRO))
+	if (!(changed & NETIF_F_LRO))
 		return 0;
 
 	if ((features & NETIF_F_LRO) && (lio->dev_capability & NETIF_F_LRO))
@@ -2111,15 +2112,16 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					NETIF_F_RXCSUM_BIT, NETIF_F_TSO_BIT,
 					NETIF_F_TSO6_BIT, NETIF_F_LRO_BIT);
 
-		netdev->hw_enc_features =
-		    (lio->enc_dev_capability & ~NETIF_F_LRO);
+		netdev->hw_enc_features = lio->enc_dev_capability;
+		netdev->hw_enc_features &= ~NETIF_F_LRO;
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
 		lio->dev_capability |= netdev_ctag_vlan_features;
 
-		netdev->features = (lio->dev_capability & ~NETIF_F_LRO);
+		netdev->features = lio->dev_capability;
+		netdev->features &= ~NETIF_F_LRO;
 
 		netdev->hw_features = lio->dev_capability;
 		netdev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 1e933a9220e9..91628878609c 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3309,14 +3309,15 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					   NETIF_F_TSO_ECN_BIT,
 					   NETIF_F_IPV6_CSUM_BIT,
 					   NETIF_F_HIGHDMA_BIT);
-		netdev->features |= netdev->hw_features |
-				    NETIF_F_HW_VLAN_CTAG_TX;
+		netdev->features |= netdev->hw_features;
+		netdev->features |= NETIF_F_HW_VLAN_CTAG_TX;
 		netdev_features_zero(vlan_feat);
 		netdev_features_set_set(vlan_feat, NETIF_F_SG_BIT,
 					NETIF_F_IP_CSUM_BIT, NETIF_F_TSO_BIT,
 					NETIF_F_RXCSUM_BIT,
 					NETIF_F_HW_VLAN_CTAG_RX_BIT);
-		netdev->vlan_features |= netdev->features & vlan_feat;
+		vlan_feat &= netdev->features;
+		netdev->vlan_features |= vlan_feat;
 
 		netdev->features |= NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 8e36455ab9ed..5f2d787b7536 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1283,8 +1283,10 @@ static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 	err = t4_set_rxmode(pi->adapter, pi->adapter->mbox, pi->viid,
 			    pi->viid_mirror, -1, -1, -1, -1,
 			    !!(features & NETIF_F_HW_VLAN_CTAG_RX), true);
-	if (unlikely(err))
-		dev->features = features ^ NETIF_F_HW_VLAN_CTAG_RX;
+	if (unlikely(err)) {
+		dev->features = features;
+		dev->features ^= NETIF_F_HW_VLAN_CTAG_RX;
+	}
 	return err;
 }
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index e26142ea68de..ffbfb3a15bce 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3073,7 +3073,8 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 					   NETIF_F_RXCSUM_BIT,
 					   NETIF_F_HW_VLAN_CTAG_TX_BIT,
 					   NETIF_F_HW_VLAN_CTAG_RX_BIT);
-		netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
+		netdev->features = netdev->hw_features;
+		netdev->features |= NETIF_F_HIGHDMA;
 		vlan_features = tso_features;
 		netdev_features_set_set(vlan_features, NETIF_F_SG_BIT,
 					NETIF_F_IP_CSUM_BIT, NETIF_F_GRO_BIT,
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index ee85285c4b11..6baa115150fb 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2463,7 +2463,8 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	gmac_clear_hw_stats(netdev);
 
 	netdev->hw_features = GMAC_OFFLOAD_FEATURES;
-	netdev->features |= GMAC_OFFLOAD_FEATURES | NETIF_F_GRO;
+	netdev->features |= GMAC_OFFLOAD_FEATURES;
+	netdev->features |= NETIF_F_GRO;
 	/* We can handle jumbo frames up to 10236 bytes so, let's accept
 	 * payloads of 10236 bytes minus VLAN and ethernet header
 	 */
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 19db8b1dddc4..bed01cc80b20 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1282,7 +1282,8 @@ static int tsnep_probe(struct platform_device *pdev)
 	netdev->netdev_ops = &tsnep_netdev_ops;
 	netdev->ethtool_ops = &tsnep_ethtool_ops;
 	netdev->features = NETIF_F_SG;
-	netdev->hw_features = netdev->features | NETIF_F_LOOPBACK;
+	netdev->hw_features = netdev->features;
+	netdev->hw_features |= NETIF_F_LOOPBACK;
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 430b4a0e6e7d..d91888b943ea 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -161,7 +161,8 @@ static void gfar_rx_offload_en(struct gfar_private *priv)
 	/* set this when rx hw offload (TOE) functions are being used */
 	priv->uses_rxfcb = 0;
 
-	if (priv->ndev->features & (NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_RX))
+	if (priv->ndev->features & NETIF_F_RXCSUM ||
+	    priv->ndev->features & NETIF_F_HW_VLAN_CTAG_RX)
 		priv->uses_rxfcb = 1;
 
 	if (priv->hwts_rx_en || priv->rx_filer_enable)
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index efb41a3eea11..e7384570b535 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -511,7 +511,8 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 	struct gfar_private *priv = netdev_priv(dev);
 	int err = 0;
 
-	if (!(changed & (netdev_ctag_vlan_offload_features | NETIF_F_RXCSUM)))
+	if (!(changed & netdev_ctag_vlan_offload_features) &&
+	    !(changed & NETIF_F_RXCSUM))
 		return 0;
 
 	while (test_and_set_bit_lock(GFAR_RESETTING, &priv->state))
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index dd2affc863cc..5b244d141913 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1776,12 +1776,15 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 
 	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_RXHASH_BIT,
 				   NETIF_F_RXCSUM_BIT);
-	if (fp->port_caps & FUN_PORT_CAP_OFFLOADS)
-		netdev->hw_features |= NETIF_F_HW_CSUM | tso_flags;
+	if (fp->port_caps & FUN_PORT_CAP_OFFLOADS) {
+		netdev->hw_features |= NETIF_F_HW_CSUM;
+		netdev->hw_features |= tso_flags;
+	}
 	if (fp->port_caps & FUN_PORT_CAP_ENCAP_OFFLOADS)
 		netdev->hw_features |= gso_encap_flags;
 
-	netdev->features |= netdev->hw_features | NETIF_F_HIGHDMA;
+	netdev->features |= netdev->hw_features;
+	netdev->features |= NETIF_F_HIGHDMA;
 	netdev->vlan_features = netdev->features & vlan_feat;
 	netdev->mpls_features = netdev->vlan_features;
 	netdev->hw_enc_features = netdev->hw_features;
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index d7e62eca050f..69579d94f4d5 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -1236,7 +1236,8 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	if (HAS_CAP_TSO(priv->hw_cap))
 		ndev->hw_features |= NETIF_F_SG;
 
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
+	ndev->features |= ndev->hw_features;
+	ndev->features |= NETIF_F_HIGHDMA;
 	ndev->vlan_features |= ndev->features;
 
 	ret = hix5hd2_init_hw_desc_queue(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5bd054b39dad..edf1162a881f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2411,7 +2411,7 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	bool enable;
 	int ret;
 
-	if (changed & (NETIF_F_GRO_HW) && h->ae_algo->ops->set_gro_en) {
+	if (changed & NETIF_F_GRO_HW && h->ae_algo->ops->set_gro_en) {
 		enable = !!(features & NETIF_F_GRO_HW);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
 		if (ret)
@@ -3307,6 +3307,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	struct pci_dev *pdev = h->pdev;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 	netdev_features_t vlan_off_features;
+	netdev_features_t features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
@@ -3356,9 +3357,11 @@ static void hns3_set_default_feature(struct net_device *netdev)
 				NETIF_F_GRO_HW_BIT,
 				NETIF_F_NTUPLE_BIT,
 				NETIF_F_HW_TC_BIT);
-	netdev->vlan_features |= netdev->features & ~vlan_off_features;
+	features = netdev->features & ~vlan_off_features;
+	netdev->vlan_features |= features;
 
-	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
+	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 7ae848678461..09815e4bea8f 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -931,7 +931,8 @@ static void netdev_features_init(struct net_device *netdev)
 
 	netdev->vlan_features = netdev->hw_features;
 
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	netdev_hw_enc_features_zero(netdev);
 	netdev_hw_enc_features_set_set(netdev, NETIF_F_IP_CSUM_BIT,
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index ce8e7d9be073..9883abd4c207 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3174,7 +3174,8 @@ static int emac_probe(struct platform_device *ofdev)
 		netdev_hw_features_zero(ndev);
 		netdev_hw_features_set_set(ndev, NETIF_F_IP_CSUM_BIT,
 					   NETIF_F_SG_BIT);
-		ndev->features |= ndev->hw_features | NETIF_F_RXCSUM;
+		ndev->features |= ndev->hw_features;
+		ndev->features |= NETIF_F_RXCSUM;
 	}
 	ndev->watchdog_timeo = 5 * HZ;
 	if (emac_phy_supports_gige(dev->phy_mode)) {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index bcbf365a7596..7beb7b168dae 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -906,10 +906,10 @@ static int ibmveth_set_features(struct net_device *dev,
 
 	if (rx_csum != adapter->rx_csum) {
 		rc1 = ibmveth_set_csum_offload(dev, rx_csum);
-		if (rc1 && !adapter->rx_csum)
-			dev->features =
-				features & ~(NETIF_F_CSUM_MASK |
-					     NETIF_F_RXCSUM);
+		if (rc1 && !adapter->rx_csum) {
+			dev->features = features & ~NETIF_F_CSUM_MASK;
+			dev->features &= ~NETIF_F_RXCSUM;
+		}
 	}
 
 	if (large_send != adapter->large_send) {
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 06c1b9dd25ce..0ea0f2e5c8e0 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4896,10 +4896,10 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		/* disable features no longer supported */
 		adapter->netdev->features &= adapter->netdev->hw_features;
 		/* turn on features now supported if previously enabled */
-		tmp = (old_hw_features ^ adapter->netdev->hw_features) &
-			adapter->netdev->hw_features;
-		adapter->netdev->features |=
-				tmp & adapter->netdev->wanted_features;
+		tmp = old_hw_features ^ adapter->netdev->hw_features;
+		tmp &= adapter->netdev->hw_features;
+		tmp &= adapter->netdev->wanted_features;
+		adapter->netdev->features |= tmp;
 	}
 
 	memset(&crq, 0, sizeof(crq));
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 560d1d442232..deb4b810152b 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2805,7 +2805,7 @@ static int e100_set_features(struct net_device *netdev,
 	struct nic *nic = netdev_priv(netdev);
 	netdev_features_t changed = features ^ netdev->features;
 
-	if (!(changed & (NETIF_F_RXFCS | NETIF_F_RXALL)))
+	if (!(changed & NETIF_F_RXFCS && changed & NETIF_F_RXALL))
 		return 0;
 
 	netdev->features = features;
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 9b96bace6707..25e74a03ffce 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -810,7 +810,7 @@ static int e1000_set_features(struct net_device *netdev,
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		e1000_vlan_mode(netdev, features);
 
-	if (!(changed & (NETIF_F_RXCSUM | NETIF_F_RXALL)))
+	if (!(changed & NETIF_F_RXCSUM && changed & NETIF_F_RXALL))
 		return 0;
 
 	netdev->features = features;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3b5392750a0a..e5f7d27e451f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13666,7 +13666,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->hw_enc_features |= hw_enc_features;
 
 	/* record features VLANs can make use of */
-	netdev->vlan_features |= hw_enc_features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= hw_enc_features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 
 	netdev_features_zero(gso_partial_features);
 	netdev_features_set_set(gso_partial_features, NETIF_F_GSO_GRE_BIT,
@@ -13676,8 +13677,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL |
-			    gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev->features |= gso_partial_features;
 
 	netdev_mpls_features_set_set(netdev, NETIF_F_SG_BIT,
 				     NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
@@ -13695,7 +13696,8 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 
 	netdev->hw_features |= hw_features;
 
-	netdev->features |= hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->features |= hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
 	netdev->features &= ~NETIF_F_HW_TC;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index d6e1c0438e14..38d7ba76643a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4753,7 +4753,8 @@ int iavf_process_config(struct iavf_adapter *adapter)
 		netdev->hw_enc_features |= hw_enc_features;
 	}
 	/* record features VLANs can make use of */
-	netdev->vlan_features |= hw_enc_features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= hw_enc_features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 
 	/* Write features and hw_features separately to avoid polluting
 	 * with, or dropping, features that are set when we registered.
@@ -4769,10 +4770,12 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_USO)
 		hw_features |= NETIF_F_GSO_UDP_L4;
 
-	netdev->hw_features |= hw_features | hw_vlan_features;
+	netdev->hw_features |= hw_features;
+	netdev->hw_features |= hw_vlan_features;
 	vlan_features = iavf_get_netdev_vlan_features(adapter);
 
-	netdev->features |= hw_features | vlan_features;
+	netdev->features |= hw_features;
+	netdev->features |= vlan_features;
 
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
 		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d6a177b0f2c8..e748a58b336b 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3372,8 +3372,9 @@ static void ice_set_netdev_features(struct net_device *netdev)
 					    NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
 					    NETIF_F_GSO_GRE_CSUM_BIT);
 	/* set features that user can change */
-	netdev->hw_features = dflt_features | csumo_features |
-			      vlano_features | tso_features;
+	netdev->hw_features = dflt_features | csumo_features;
+	netdev->hw_features |= vlano_features;
+	netdev->hw_features |= tso_features;
 
 	/* add support for HW_CSUM on packets with MPLS header */
 	netdev_mpls_features_zero(netdev);
@@ -3389,10 +3390,12 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	netdev->hw_features |= NETIF_F_LOOPBACK;
 
 	/* encap and VLAN devices inherit default, csumo and tso features */
-	netdev->hw_enc_features |= dflt_features | csumo_features |
-				   tso_features;
-	netdev->vlan_features |= dflt_features | csumo_features |
-				 tso_features;
+	netdev->hw_enc_features |= dflt_features;
+	netdev->hw_enc_features |= csumo_features;
+	netdev->hw_enc_features |= tso_features;
+	netdev->vlan_features |= dflt_features;
+	netdev->vlan_features |= csumo_features;
+	netdev->vlan_features |= tso_features;
 
 	/* advertise support but don't enable by default since only one type of
 	 * VLAN offload can be enabled at a time (i.e. CTAG or STAG). When one
@@ -5945,14 +5948,15 @@ ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
 static int
 ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 {
-	netdev_features_t current_vlan_features, requested_vlan_features;
+	netdev_features_t current_vlan_features, requested_vlan_features, diff;
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 	int err;
 
 	current_vlan_features = netdev->features & NETIF_VLAN_OFFLOAD_FEATURES;
 	requested_vlan_features = features & NETIF_VLAN_OFFLOAD_FEATURES;
-	if (current_vlan_features ^ requested_vlan_features) {
+	diff = current_vlan_features ^ requested_vlan_features;
+	if (diff) {
 		if ((features & NETIF_F_RXFCS) &&
 		    (features & NETIF_VLAN_STRIPPING_FEATURES)) {
 			dev_err(ice_pf_to_dev(vsi->back),
@@ -5968,7 +5972,8 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	current_vlan_features = netdev->features &
 		NETIF_VLAN_FILTERING_FEATURES;
 	requested_vlan_features = features & NETIF_VLAN_FILTERING_FEATURES;
-	if (current_vlan_features ^ requested_vlan_features) {
+	diff = current_vlan_features ^ requested_vlan_features;
+	if (diff) {
 		err = ice_set_vlan_filtering_features(vsi, features);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index af90680f7329..d59e1c85ce8d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2455,7 +2455,7 @@ static int igb_set_features(struct net_device *netdev,
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		igb_vlan_mode(netdev, features);
 
-	if (!(changed & (NETIF_F_RXALL | NETIF_F_NTUPLE)))
+	if (!(changed & NETIF_F_RXALL) && !(changed & NETIF_F_NTUPLE))
 		return 0;
 
 	if (!(features & NETIF_F_NTUPLE)) {
@@ -3301,7 +3301,8 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev->features |= gso_partial_features;
 
 	/* copy netdev features into list of user selectable features */
 	netdev->hw_features |= netdev->features;
@@ -3315,7 +3316,8 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
 	netdev->hw_enc_features |= netdev->vlan_features;
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index cd16e9e259c4..b93a14390e12 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2785,11 +2785,14 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->hw_features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
+	netdev->hw_features |= NETIF_F_GSO_PARTIAL;
+	netdev->hw_features |= gso_partial_features;
 
-	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
 	netdev->hw_enc_features |= netdev->vlan_features;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 63f30912cada..ccb343324742 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4996,7 +4996,7 @@ static int igc_set_features(struct net_device *netdev,
 		igc_vlan_mode(netdev, features);
 
 	/* Add VLAN support */
-	if (!(changed & (NETIF_F_RXALL | NETIF_F_NTUPLE)))
+	if (!(changed & NETIF_F_RXALL) && !(changed & NETIF_F_NTUPLE))
 		return 0;
 
 	if (!(features & NETIF_F_NTUPLE))
@@ -6364,7 +6364,8 @@ static int igc_probe(struct pci_dev *pdev,
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev->features |= gso_partial_features;
 
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
@@ -6379,7 +6380,8 @@ static int igc_probe(struct pci_dev *pdev,
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
 	netdev->hw_enc_features |= netdev->vlan_features;
 
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index 51e89e9aefcb..f5e886cdabae 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -313,7 +313,7 @@ ixgb_set_features(struct net_device *netdev, netdev_features_t features)
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed = features ^ netdev->features;
 
-	if (!(changed & (NETIF_F_RXCSUM|NETIF_F_HW_VLAN_CTAG_RX)))
+	if (!(changed & NETIF_F_RXCSUM) && !(changed & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
 
 	adapter->rx_csum = !!(features & NETIF_F_RXCSUM);
@@ -436,8 +436,8 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				   NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
-	netdev->features = netdev->hw_features |
-			   NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features |= NETIF_F_RXCSUM;
 
 	netdev->features |= NETIF_F_HIGHDMA;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index ea08c9fb5764..8d35b1d7b99e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8828,7 +8828,8 @@ netdev_tx_t ixgbe_xmit_frame_ring(struct sk_buff *skb,
 #ifdef IXGBE_FCOE
 	/* setup tx offload for FCoE */
 	if ((protocol == htons(ETH_P_FCOE)) &&
-	    (tx_ring->netdev->features & (NETIF_F_FSO | NETIF_F_FCOE_CRC))) {
+	    (tx_ring->netdev->features & NETIF_F_FSO ||
+	     tx_ring->netdev->features & NETIF_F_FCOE_CRC)) {
 		tso = ixgbe_fso(tx_ring, first, &hdr_len);
 		if (tso < 0)
 			goto out_drop;
@@ -9884,7 +9885,7 @@ static int ixgbe_set_features(struct net_device *netdev,
 		    adapter->rx_itr_setting > IXGBE_MIN_RSC_ITR) {
 			adapter->flags2 |= IXGBE_FLAG2_RSC_ENABLED;
 			need_reset = true;
-		} else if ((changed ^ features) & NETIF_F_LRO) {
+		} else if ((changed & NETIF_F_LRO) != (features & NETIF_F_LRO)) {
 			e_info(probe, "rx-usecs set too low, "
 			       "disabling RSC\n");
 		}
@@ -9930,8 +9931,8 @@ static int ixgbe_set_features(struct net_device *netdev,
 		ixgbe_reset_l2fw_offload(adapter);
 	else if (need_reset)
 		ixgbe_do_reset(netdev);
-	else if (changed & (NETIF_F_HW_VLAN_CTAG_RX |
-			    NETIF_F_HW_VLAN_CTAG_FILTER))
+	else if (changed & NETIF_F_HW_VLAN_CTAG_RX ||
+		 changed & NETIF_F_HW_VLAN_CTAG_FILTER)
 		ixgbe_set_rx_mode(netdev);
 
 	return 1;
@@ -10985,8 +10986,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL |
-			    gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev->features |= gso_partial_features;
 
 	if (hw->mac.type >= ixgbe_mac_82599EB)
 		netdev_hw_features_set_set(netdev,
@@ -11016,7 +11017,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 	netdev->hw_enc_features |= netdev->vlan_features;
 	netdev_mpls_features_set_set(netdev,
 				     NETIF_F_SG_BIT,
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d6c848533d04..657a9ee537e8 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4619,12 +4619,14 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->hw_features |= NETIF_F_GSO_PARTIAL |
-			       gso_partial_features;
+	netdev->hw_features |= NETIF_F_GSO_PARTIAL;
+	netdev->hw_features |= gso_partial_features;
 
-	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 
 	netdev_mpls_features_set_set(netdev,
 				     NETIF_F_SG_BIT,
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 6eb610dce765..6ce1656734cb 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2664,8 +2664,10 @@ jme_set_msglevel(struct net_device *netdev, u32 value)
 static netdev_features_t
 jme_fix_features(struct net_device *netdev, netdev_features_t features)
 {
-	if (netdev->mtu > 1900)
-		features &= ~(NETIF_F_ALL_TSO | NETIF_F_CSUM_MASK);
+	if (netdev->mtu > 1900) {
+		features &= ~NETIF_F_ALL_TSO;
+		features &= ~NETIF_F_CSUM_MASK;
+	}
 	return features;
 }
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b50cfdb33f53..8963eaf4a5f0 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6849,7 +6849,8 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	netdev_features_zero(features);
 	netdev_features_set_set(features, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
 				NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT);
-	dev->features = features | NETIF_F_RXCSUM;
+	dev->features = features;
+	dev->features |= NETIF_F_RXCSUM;
 	dev->hw_features |= features;
 	netdev_hw_features_set_set(dev, NETIF_F_RXCSUM_BIT, NETIF_F_GRO_BIT,
 				   NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 2f7f8aef4553..94ba7538d242 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4316,7 +4316,9 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 	 */
 	if (dev->mtu > ETH_DATA_LEN && hw->chip_id == CHIP_ID_YUKON_EC_U) {
 		netdev_info(dev, "checksum offload not possible with jumbo frames\n");
-		features &= ~(NETIF_F_TSO | NETIF_F_SG | NETIF_F_CSUM_MASK);
+		features &= ~NETIF_F_TSO;
+		features &= ~NETIF_F_SG;
+		features &= ~NETIF_F_CSUM_MASK;
 	}
 
 	/* Some hardware requires receive checksum for RSS to work. */
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index a2db1db99c4b..afa7fe88bb73 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -864,7 +864,7 @@ static int ocelot_set_features(struct net_device *dev,
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
 
-	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if ((dev->features & NETIF_F_HW_TC) && !(features & NETIF_F_HW_TC) &&
 	    priv->tc.offload_cnt) {
 		netdev_err(dev,
 			   "Cannot disable HW TC offload while offloads active\n");
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 96b437f01afe..cdbb7e7ab0ba 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1285,8 +1285,7 @@ myri10ge_vlan_rx(struct net_device *dev, void *addr, struct sk_buff *skb)
 	va = addr;
 	va += MXGEFW_PAD;
 	veh = (struct vlan_ethhdr *)va;
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) ==
-	    NETIF_F_HW_VLAN_CTAG_RX &&
+	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    veh->h_vlan_proto == htons(ETH_P_8021Q)) {
 		/* fixup csum if needed */
 		if (skb->ip_summed == CHECKSUM_COMPLETE) {
@@ -3864,12 +3863,14 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->mtu = myri10ge_initial_mtu;
 
 	netdev->netdev_ops = &myri10ge_netdev_ops;
-	netdev->hw_features = mgp->features | NETIF_F_RXCSUM;
+	netdev->hw_features = mgp->features;
+	netdev->hw_features |= NETIF_F_RXCSUM;
 
 	/* fake NETIF_F_HW_VLAN_CTAG_RX for good GRO performance */
 	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
 
-	netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HIGHDMA;
 
 	netdev->vlan_features |= mgp->features;
 	if (mgp->fw_ver_tiny < 37)
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 4d69c006dcaa..2157d22ced2b 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -6571,9 +6571,9 @@ static void s2io_ethtool_get_strings(struct net_device *dev,
 static int s2io_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct s2io_nic *sp = netdev_priv(dev);
-	netdev_features_t changed = (features ^ dev->features) & NETIF_F_LRO;
+	netdev_features_t changed = features ^ dev->features;
 
-	if (changed && netif_running(dev)) {
+	if (changed & NETIF_F_LRO && netif_running(dev)) {
 		int rc;
 
 		s2io_stop_all_tx_queue(sp);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 7c749e41a2d6..def04c617c0f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -240,6 +240,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	netdev_features_t old_features = features;
 	netdev_features_t lower_features;
 	struct net_device *lower_dev;
+	netdev_features_t tmp;
 
 	lower_dev = repr->dst->u.port_info.lower_dev;
 
@@ -248,7 +249,10 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 		lower_features |= NETIF_F_HW_CSUM;
 
 	features = netdev_intersect_features(features, lower_features);
-	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_HW_TC);
+	tmp = NETIF_F_SOFT_FEATURES;
+	tmp |= NETIF_F_HW_TC;
+	tmp &= old_features;
+	features |= tmp;
 	features |= NETIF_F_LLTX;
 
 	return features;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 4f2308570dcf..c224707f763f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -66,7 +66,7 @@ int nfp_port_set_features(struct net_device *netdev, netdev_features_t features)
 	if (!port)
 		return 0;
 
-	if ((netdev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if ((netdev->features & NETIF_F_HW_TC) && !(features & NETIF_F_HW_TC) &&
 	    port->tc_offload_cnt) {
 		netdev_err(netdev, "Cannot disable HW TC offload while offloads active\n");
 		return -EBUSY;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 67c6214d19bd..dfa3cc8f6dbc 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -6120,7 +6120,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 
 	dev_info(&pci_dev->dev, "%s%s%s%s%s%s%s%s%s%s%sdesc-v%u\n",
 		 dev->features & NETIF_F_HIGHDMA ? "highdma " : "",
-		 dev->features & (NETIF_F_IP_CSUM | NETIF_F_SG) ?
+		 (dev->features & NETIF_F_IP_CSUM || dev->features & NETIF_F_SG) ?
 			"csum " : "",
 		 dev->features & netdev_ctag_vlan_offload_features ?
 			"vlan " : "",
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 6930603e1698..6cc31f460478 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1545,7 +1545,8 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 
 	netdev->hw_features |= netdev->hw_enc_features;
 	netdev->features |= netdev->hw_features;
-	netdev->vlan_features |= netdev->features & ~NETIF_F_VLAN_FEATURES;
+	features = netdev->features & ~NETIF_F_VLAN_FEATURES;
+	netdev->vlan_features |= features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT |
 			      IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 5c49282a99d7..8a712acae06c 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -536,9 +536,11 @@ static int netxen_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct netxen_adapter *adapter = netdev_priv(dev);
+	netdev_features_t changed;
 	int hw_lro;
 
-	if (!((dev->features ^ features) & NETIF_F_LRO))
+	changed = dev->features ^ features;
+	if (!(changed & NETIF_F_LRO))
 		return 0;
 
 	hw_lro = (features & NETIF_F_LRO) ? NETXEN_NIC_LRO_ENABLED
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index a03d38d4ccfc..e45b4e1884c3 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1075,7 +1075,8 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 						NETIF_F_IPV6_CSUM_BIT,
 						NETIF_F_TSO_BIT,
 						NETIF_F_TSO6_BIT);
-			features ^= changed & changeable;
+			changed &= changeable;
+			features ^= changed;
 		}
 	}
 
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 8543fc682d12..36cfb2cc900e 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1461,10 +1461,11 @@ static void cp_set_msglevel(struct net_device *dev, u32 value)
 
 static int cp_set_features(struct net_device *dev, netdev_features_t features)
 {
+	netdev_features_t changed = dev->features ^ features;
 	struct cp_private *cp = netdev_priv(dev);
 	unsigned long flags;
 
-	if (!((dev->features ^ features) & NETIF_F_RXCSUM))
+	if (!(changed & NETIF_F_RXCSUM))
 		return 0;
 
 	spin_lock_irqsave(&cp->lock, flags);
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 8c7b6b80dbd9..ff4e317538ab 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -905,7 +905,7 @@ static int rtl8139_set_features(struct net_device *dev, netdev_features_t featur
 	netdev_features_t changed = features ^ dev->features;
 	void __iomem *ioaddr = tp->mmio_addr;
 
-	if (!(changed & (NETIF_F_RXALL)))
+	if (!(changed & NETIF_F_RXALL))
 		return 0;
 
 	spin_lock_irqsave(&tp->lock, flags);
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 727792b6cf26..c7edd6d7ef15 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1431,8 +1431,10 @@ static netdev_features_t rtl8169_fix_features(struct net_device *dev,
 		features &= ~NETIF_F_ALL_TSO;
 
 	if (dev->mtu > ETH_DATA_LEN &&
-	    tp->mac_version > RTL_GIGA_MAC_VER_06)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_ALL_TSO);
+	    tp->mac_version > RTL_GIGA_MAC_VER_06) {
+		features &= ~NETIF_F_CSUM_MASK;
+		features &= ~NETIF_F_ALL_TSO;
+	}
 
 	return features;
 }
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 37428e2d4f3d..da564ad246ae 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2111,7 +2111,8 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_RXCSUM_BIT,
 				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
 				   NETIF_F_GRO_BIT);
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
+	ndev->features |= ndev->hw_features;
+	ndev->features |= NETIF_F_HIGHDMA;
 	ndev->watchdog_timeo = msecs_to_jiffies(TX_TIMEO);
 
 	/* assign filtering support */
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index c0d6f6419228..7f0e59652305 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1363,7 +1363,8 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 					NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
 					NETIF_F_GSO_GRE_CSUM_BIT);
 
-		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
+		hw_enc_features |= encap_tso_features;
+		hw_enc_features |= NETIF_F_TSO;
 		efx->net_dev->features |= encap_tso_features;
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index a750d9588bf7..1b80c2b31347 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -989,6 +989,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
 	int rc = efx_pci_probe_main(efx);
+	netdev_features_t tmp;
 
 	if (rc)
 		return rc;
@@ -1004,7 +1005,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	net_dev->features |= *efx->type->offload_features;
 	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
 				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
-	if (*efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
+	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
 		net_dev->features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
@@ -1015,7 +1017,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
 				     NETIF_F_RXCSUM_BIT);
 
-	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
+	tmp = net_dev->features & ~efx->fixed_features;
+	net_dev->hw_features |= tmp;
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->features &= ~NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index f7ae65d53c78..70a48ede5599 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -213,10 +213,12 @@ void efx_set_rx_mode(struct net_device *net_dev)
 int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct efx_nic *efx = efx_netdev_priv(net_dev);
+	netdev_features_t tmp;
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->features & ~data & NETIF_F_NTUPLE) {
+	tmp = net_dev->features & ~data;
+	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -225,8 +227,9 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	if ((net_dev->features ^ data) & (NETIF_F_HW_VLAN_CTAG_FILTER |
-					  NETIF_F_RXFCS)) {
+	tmp = net_dev->features ^ data;
+	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER ||
+	    tmp & NETIF_F_RXFCS) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
@@ -1364,7 +1367,7 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 			 */
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
-				features &= ~(NETIF_F_GSO_MASK);
+				features &= ~NETIF_F_GSO_MASK;
 		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
 				features &= ~netdev_csum_gso_features_mask;
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 60a552d78a83..caf570fcf618 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2182,17 +2182,20 @@ static void ef4_set_rx_mode(struct net_device *net_dev)
 static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
+	netdev_features_t tmp;
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->features & ~data & NETIF_F_NTUPLE) {
+	tmp = net_dev->features & ~data;
+	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
 	}
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
-	if ((net_dev->features ^ data) & NETIF_F_HW_VLAN_CTAG_FILTER) {
+	tmp = net_dev->features ^ data;
+	if (tmp & NETIF_F_HW_VLAN_CTAG_FILTER) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
@@ -2898,8 +2901,9 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->features |= (*efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_RXCSUM);
+	net_dev->features |= *efx->type->offload_features;
+	net_dev->features |= NETIF_F_SG;
+	net_dev->features |= NETIF_F_RXCSUM;
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index b83e60f8ebbb..66f75c2ab9b4 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -972,6 +972,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
 	int rc = efx_pci_probe_main(efx);
+	netdev_features_t tmp;
 
 	if (rc)
 		return rc;
@@ -987,7 +988,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	net_dev->features |= *efx->type->offload_features;
 	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT, NETIF_F_TSO_BIT,
 				       NETIF_F_RXCSUM_BIT, NETIF_F_RXALL_BIT);
-	if (*efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
+	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
 		net_dev->features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
@@ -998,7 +1000,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
 				     NETIF_F_RXCSUM_BIT);
 
-	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
+	tmp = net_dev->features & ~efx->fixed_features;
+	net_dev->hw_features |= tmp;
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->features &= ~NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index c8389da6509d..3b37d9ccfc6c 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -212,10 +212,11 @@ void efx_siena_set_rx_mode(struct net_device *net_dev)
 int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
+	netdev_features_t features;
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	if (net_dev->features & ~data & NETIF_F_NTUPLE) {
+	if ((net_dev->features & NETIF_F_NTUPLE) && !(data & NETIF_F_NTUPLE)) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -224,8 +225,8 @@ int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	if ((net_dev->features ^ data) & (NETIF_F_HW_VLAN_CTAG_FILTER |
-					  NETIF_F_RXFCS)) {
+	features = net_dev->features ^ data;
+	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) || (features & NETIF_F_RXFCS)) {
 		/* efx_siena_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
 		 */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 69e55f3e2c12..eb67918507c1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7174,7 +7174,8 @@ int stmmac_dvr_probe(struct device *device,
 		}
 	}
 
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
+	ndev->features |= ndev->hw_features;
+	ndev->features |= NETIF_F_HIGHDMA;
 	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 1b4d6b2f57ec..a4392cccf20f 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9739,7 +9739,8 @@ static void niu_set_basic_features(struct net_device *dev)
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_RXHASH_BIT);
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_RXCSUM;
 }
 
 static int niu_pci_init_one(struct pci_dev *pdev,
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index fd99c2e677b1..e2b00446f171 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2787,7 +2787,8 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	/* Happy Meal can do it all... */
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT);
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_RXCSUM;
 
 	hp->irq = op->archdata.irqs[0];
 
@@ -3108,7 +3109,8 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	/* Happy Meal can do it all... */
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT);
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_RXCSUM;
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
 	/* Hook up PCI register/descriptor accessors. */
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 728aaba3fef2..5657d97a934e 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1982,8 +1982,8 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	netdev_hw_features_set_set(port->ndev, NETIF_F_SG_BIT,
 				   NETIF_F_RXCSUM_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_HW_TC_BIT);
-	port->ndev->features = port->ndev->hw_features |
-			       NETIF_F_HW_VLAN_CTAG_FILTER;
+	port->ndev->features = port->ndev->hw_features;
+	port->ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	port->ndev->vlan_features |=  NETIF_F_SG;
 	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 6da36cb8af80..bbbf391cb687 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/if_vlan.h>
 #include <linux/nls.h>
 #include <linux/vmalloc.h>
@@ -1350,6 +1351,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	struct ndis_offload hwcaps;
 	struct ndis_offload_params offloads;
 	unsigned int gso_max_size = GSO_LEGACY_MAX_SIZE;
+	netdev_features_t features;
 	int ret;
 
 	/* Find HW offload capabilities */
@@ -1429,7 +1431,10 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	/* In case some hw_features disappeared we need to remove them from
 	 * net->features list as they're no longer supported.
 	 */
-	net->features &= ~NETVSC_SUPPORTED_HW_FEATURES | net->hw_features;
+	netdev_features_fill(features);
+	features &= ~NETVSC_SUPPORTED_HW_FEATURES;
+	features |= net->hw_features;
+	net->features &= features;
 
 	netif_set_tso_max_size(net, gso_max_size);
 
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 2fd507897cd1..58718326083a 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -324,7 +324,8 @@ static void ifb_setup(struct net_device *dev)
 	dev->features |= ifb_features;
 	dev->hw_features |= dev->features;
 	dev->hw_enc_features |= dev->features;
-	dev->vlan_features |= ifb_features & ~netdev_tx_vlan_features;
+	ifb_features &= ~netdev_tx_vlan_features;
+	dev->vlan_features |= ifb_features;
 
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index a4f461ec1374..ef346c99e42e 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -231,13 +231,18 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 					     netdev_features_t features)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
+	netdev_features_t tmp;
 
 	features |= NETIF_F_ALL_FOR_ALL;
-	features &= (ipvlan->sfeatures | ~IPVLAN_FEATURES);
+	netdev_features_fill(tmp);
+	tmp &= ~IPVLAN_FEATURES;
+	tmp |= ipvlan->sfeatures;
+	features &= tmp;
 	features = netdev_increment_features(ipvlan->phy_dev->features,
 					     features, features);
 	features |= IPVLAN_ALWAYS_ON;
-	features &= (IPVLAN_FEATURES | IPVLAN_ALWAYS_ON);
+	tmp = IPVLAN_FEATURES | IPVLAN_ALWAYS_ON;
+	features &= tmp;
 
 	return features;
 }
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 299879133317..57716883db82 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3478,7 +3478,8 @@ static int macsec_dev_init(struct net_device *dev)
 		dev->features = REAL_DEV_FEATURES(real_dev);
 	} else {
 		dev->features = real_dev->features & SW_MACSEC_FEATURES;
-		dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
+		dev->features |= NETIF_F_LLTX;
+		dev->features |= NETIF_F_GSO_SOFTWARE;
 	}
 
 	dev->needed_headroom = real_dev->needed_headroom +
@@ -3510,12 +3511,15 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
+	netdev_features_t tmp;
 
 	if (macsec_is_offloaded(macsec))
 		return REAL_DEV_FEATURES(real_dev);
 
-	features &= (real_dev->features & SW_MACSEC_FEATURES) |
-		    NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES;
+	tmp = real_dev->features & SW_MACSEC_FEATURES;
+	tmp |= NETIF_F_GSO_SOFTWARE;
+	tmp |= NETIF_F_SOFT_FEATURES;
+	features &= tmp;
 	features |= NETIF_F_LLTX;
 
 	return features;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index fa20b4b2ff0a..2a76b93fd950 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1078,15 +1078,22 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	netdev_features_t lowerdev_features = vlan->lowerdev->features;
 	netdev_features_t mask;
+	netdev_features_t tmp;
 
 	features |= NETIF_F_ALL_FOR_ALL;
-	features &= (vlan->set_features | ~MACVLAN_FEATURES);
+	netdev_features_fill(tmp);
+	tmp &= ~MACVLAN_FEATURES;
+	tmp |= vlan->set_features;
+	features &= tmp;
 	mask = features;
 
-	lowerdev_features &= (features | ~NETIF_F_LRO);
+	tmp = features;
+	tmp &= ~NETIF_F_LRO;
+	lowerdev_features &= tmp;
 	features = netdev_increment_features(lowerdev_features, features, mask);
 	features |= ALWAYS_ON_FEATURES;
-	features &= (ALWAYS_ON_FEATURES | MACVLAN_FEATURES);
+	tmp = ALWAYS_ON_FEATURES | MACVLAN_FEATURES;
+	features &= tmp;
 
 	return features;
 }
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 2fdfb4e6ba23..877d5d1e8d39 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -233,7 +233,7 @@ nsim_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
-	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC))
+	if ((dev->features & NETIF_F_HW_TC) && !(features & NETIF_F_HW_TC))
 		return nsim_bpf_disable_tc(ns);
 
 	return 0;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 0b345010195f..fd0f3d872fd0 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2174,9 +2174,9 @@ static void team_setup(struct net_device *dev)
 	/* Don't allow team devices to change network namespaces. */
 	dev->features |= NETIF_F_NETNS_LOCAL;
 
-	dev->hw_features = TEAM_VLAN_FEATURES |
-			   NETIF_F_HW_VLAN_CTAG_RX |
-			   NETIF_F_HW_VLAN_CTAG_FILTER;
+	dev->hw_features = TEAM_VLAN_FEATURES;
+	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	dev->features |= dev->hw_features;
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index b3842ff71c75..9d31135b77bb 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1283,7 +1283,8 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 				   NETIF_F_GRO_BIT,
 				   NETIF_F_IP_CSUM_BIT,
 				   NETIF_F_IPV6_CSUM_BIT);
-	dev->features = dev->hw_features | NETIF_F_HIGHDMA;
+	dev->features = dev->hw_features;
+	dev->features |= NETIF_F_HIGHDMA;
 	dev->hard_header_len += sizeof(struct thunderbolt_ip_frame_header);
 
 	netif_napi_add(dev, &net->napi, tbnet_poll, NAPI_POLL_WEIGHT);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index f92041e49864..1c895384bf03 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -996,7 +996,8 @@ static int tun_net_init(struct net_device *dev)
 				   NETIF_F_FRAGLIST_BIT,
 				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				   NETIF_F_HW_VLAN_STAG_TX_BIT);
-	dev->features = dev->hw_features | NETIF_F_LLTX;
+	dev->features = dev->hw_features;
+	dev->features |= NETIF_F_LLTX;
 	dev->vlan_features = dev->features & ~netdev_tx_vlan_features;
 
 	tun->flags = (tun->flags & ~TUN_FEATURES) |
@@ -1167,8 +1168,11 @@ static netdev_features_t tun_net_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct tun_struct *tun = netdev_priv(dev);
+	netdev_features_t tmp1, tmp2;
 
-	return (features & tun->set_features) | (features & ~TUN_USER_FEATURES);
+	tmp1 = features & tun->set_features;
+	tmp2 = features & ~TUN_USER_FEATURES;
+	return tmp1 | tmp2;
 }
 
 static void tun_set_headroom(struct net_device *dev, int new_hr)
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 2070756c2c43..b5e207f1cd05 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -307,7 +307,8 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 {
 	return !(dev->features & NETIF_F_ALL_TSO) ||
 		(skb->destructor == sock_wfree &&
-		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
+		 (rcv->features & NETIF_F_GRO_FRAGLIST ||
+		  rcv->features & NETIF_F_GRO_UDP_FWD));
 }
 
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -1648,7 +1649,8 @@ static void veth_setup(struct net_device *dev)
 
 	dev->hw_features = veth_features;
 	dev->hw_enc_features = veth_features;
-	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
+	dev->mpls_features = NETIF_F_GSO_SOFTWARE;
+	dev->mpls_features |= NETIF_F_HW_CSUM;
 	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d5be3fe5d140..4423073021e5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3739,8 +3739,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 
 		dev->features |= NETIF_F_GSO_ROBUST;
 
-		if (gso)
-			dev->features |= dev->hw_features & NETIF_F_ALL_TSO;
+		if (gso) {
+			netdev_features_t tmp = dev->hw_features & NETIF_F_ALL_TSO;
+
+			dev->features |= tmp;
+		}
 		/* (!csum && gso) case will be fixed by register_netdev() */
 	}
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 20869331e70f..e7786f449c2a 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2592,8 +2592,8 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 	if (adapter->netdev->features & NETIF_F_HW_VLAN_CTAG_RX)
 		devRead->misc.uptFeatures |= UPT1_F_RXVLAN;
 
-	if (adapter->netdev->features & (NETIF_F_GSO_UDP_TUNNEL |
-					 NETIF_F_GSO_UDP_TUNNEL_CSUM))
+	if (adapter->netdev->features & NETIF_F_GSO_UDP_TUNNEL ||
+	    adapter->netdev->features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
 		devRead->misc.uptFeatures |= UPT1_F_RXINNEROFLD;
 
 	devRead->misc.mtu = cpu_to_le32(adapter->netdev->mtu);
@@ -3381,7 +3381,8 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 
 	netdev->vlan_features = netdev->hw_features &
 				~netdev_ctag_vlan_offload_features;
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 3f5006cf8cc1..fa70ef3a9ea0 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -402,12 +402,18 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	unsigned long flags;
 	netdev_features_t changed = features ^ netdev->features;
-	netdev_features_t tun_offload_mask = NETIF_F_GSO_UDP_TUNNEL |
-					     NETIF_F_GSO_UDP_TUNNEL_CSUM;
-	u8 udp_tun_enabled = (netdev->features & tun_offload_mask) != 0;
-
-	if (changed & (NETIF_F_RXCSUM | NETIF_F_LRO |
-		       NETIF_F_HW_VLAN_CTAG_RX | tun_offload_mask)) {
+	netdev_features_t tun_offload_mask;
+	u8 udp_tun_enabled;
+
+	netdev_features_zero(tun_offload_mask);
+	tun_offload_mask |= NETIF_F_GSO_UDP_TUNNEL;
+	tun_offload_mask |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	udp_tun_enabled = (netdev->features & tun_offload_mask) != 0;
+
+	if (changed & NETIF_F_RXCSUM ||
+	    changed & NETIF_F_LRO ||
+	    changed & NETIF_F_HW_VLAN_CTAG_RX ||
+	    changed & tun_offload_mask) {
 		if (features & NETIF_F_RXCSUM)
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXCSUM;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 946c8fbae08a..f7eccfa72865 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1143,7 +1143,8 @@ static int ath6kl_set_features(struct net_device *dev,
 							 vif->fw_vif_idx,
 							 ar->rx_meta_ver, 0, 0);
 		if (err) {
-			dev->features = features | NETIF_F_RXCSUM;
+			dev->features = features;
+			dev->features |= NETIF_F_RXCSUM;
 			return err;
 		}
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index f9e08b339e0c..3283c346fbe7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -887,9 +887,12 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 	unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;
 	u16 snap_ip_tcp, pad;
-	netdev_features_t netdev_flags = NETIF_F_CSUM_MASK | NETIF_F_SG;
+	netdev_features_t netdev_flags;
 	u8 tid;
 
+	netdev_flags = NETIF_F_CSUM_MASK;
+	netdev_flags |= NETIF_F_SG;
+
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 81a4c99fb60e..0df7495586cc 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -527,7 +527,8 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
 				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
 				   NETIF_F_TSO6_BIT, NETIF_F_FRAGLIST_BIT);
-	dev->features = dev->hw_features | NETIF_F_RXCSUM;
+	dev->features = dev->hw_features;
+	dev->features |= NETIF_F_RXCSUM;
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
 	dev->tx_queue_len = XENVIF_QUEUE_LENGTH;
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index 456ebfd97632..d7ab441e0560 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -700,7 +700,7 @@ static inline bool __netdev_features_subset(const netdev_features_t *feats1,
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 							  netdev_features_t f2)
 {
-	if ((f1 ^ f2) & NETIF_F_HW_CSUM) {
+	if ((f1 & NETIF_F_HW_CSUM) != (f2 & NETIF_F_HW_CSUM)) {
 		if (f1 & NETIF_F_HW_CSUM)
 			f1 |= netdev_ip_csum_features;
 		else
@@ -713,7 +713,10 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 static inline netdev_features_t
 netdev_get_wanted_features(struct net_device *dev)
 {
-	return (dev->features & ~dev->hw_features) | dev->wanted_features;
+	netdev_features_t tmp;
+
+	tmp = dev->features & ~dev->hw_features;
+	return dev->wanted_features | tmp;
 }
 
 #endif
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 5eaf38875554..2cf51c2514e7 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -5,6 +5,7 @@
 #include <linux/if_vlan.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/list.h>
+#include <linux/netdev_feature_helpers.h>
 
 /* if this changes, algorithm will have to be reworked because this
  * depends on completely exhausting the VLAN identifier space.  Thus
@@ -107,13 +108,17 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 {
 	netdev_features_t ret;
 
-	ret = real_dev->hw_enc_features &
-	      (NETIF_F_CSUM_MASK | NETIF_F_GSO_SOFTWARE |
-	       NETIF_F_GSO_ENCAP_ALL);
+	ret = NETIF_F_CSUM_MASK | NETIF_F_GSO_SOFTWARE;
+	ret |= NETIF_F_GSO_ENCAP_ALL;
+	ret &= real_dev->hw_enc_features;
 
-	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK))
-		return (ret & ~NETIF_F_CSUM_MASK) | NETIF_F_HW_CSUM;
-	return 0;
+	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK)) {
+		ret &= ~NETIF_F_CSUM_MASK;
+		ret |= NETIF_F_HW_CSUM;
+		return ret;
+	}
+	netdev_features_zero(ret);
+	return ret;
 }
 
 #define vlan_group_for_each_dev(grp, i, dev) \
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index b1aab3cd7c28..49ba2152a7b1 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -575,7 +575,8 @@ static int vlan_dev_init(struct net_device *dev)
 				   NETIF_F_HIGHDMA_BIT,
 				   NETIF_F_SCTP_CRC_BIT);
 
-	dev->features |= dev->hw_features | NETIF_F_LLTX;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_LLTX;
 	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
@@ -649,10 +650,11 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
 	netdev_features_t old_features = features;
 	netdev_features_t lower_features;
+	netdev_features_t tmp;
 
-	lower_features = netdev_intersect_features((real_dev->vlan_features |
-						    NETIF_F_RXCSUM),
-						   real_dev->features);
+	tmp = real_dev->vlan_features;
+	tmp |= NETIF_F_RXCSUM;
+	lower_features = netdev_intersect_features(tmp, real_dev->features);
 
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
@@ -660,7 +662,9 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	if (lower_features & netdev_ip_csum_features)
 		lower_features |= NETIF_F_HW_CSUM;
 	features = netdev_intersect_features(features, lower_features);
-	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
+	tmp = NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE;
+	tmp &= old_features;
+	features |= tmp;
 	features |= NETIF_F_LLTX;
 
 	return features;
diff --git a/net/core/dev.c b/net/core/dev.c
index 5b5f53608331..cdfe1a0608a1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3552,6 +3552,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
 	netdev_features_t features = dev->features;
+	netdev_features_t tmp;
 
 	if (skb_is_gso(skb))
 		features = gso_features_check(skb, dev, features);
@@ -3563,16 +3564,16 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	if (skb->encapsulation)
 		features &= dev->hw_enc_features;
 
-	if (skb_vlan_tagged(skb))
-		features = netdev_intersect_features(features,
-						     dev->vlan_features |
-						     netdev_tx_vlan_features);
+	if (skb_vlan_tagged(skb)) {
+		tmp = dev->vlan_features | netdev_tx_vlan_features;
+		features = netdev_intersect_features(features, tmp);
+	}
 
 	if (dev->netdev_ops->ndo_features_check)
-		features &= dev->netdev_ops->ndo_features_check(skb, dev,
-								features);
+		tmp = dev->netdev_ops->ndo_features_check(skb, dev, features);
 	else
-		features &= dflt_features_check(skb, dev, features);
+		tmp = dflt_features_check(skb, dev, features);
+	features &= tmp;
 
 	return harmonize_features(skb, features);
 }
@@ -9606,6 +9607,8 @@ static void netdev_sync_lower_features(struct net_device *upper,
 static netdev_features_t netdev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
+	netdev_features_t tmp;
+
 	/* Fix illegal checksum combinations */
 	if ((features & NETIF_F_HW_CSUM) &&
 	    (features & netdev_ip_csum_features)) {
@@ -9637,7 +9640,9 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 		features &= ~NETIF_F_TSO_MANGLEID;
 
 	/* TSO ECN requires that TSO is present as well. */
-	if ((features & NETIF_F_ALL_TSO) == NETIF_F_TSO_ECN)
+	tmp = NETIF_F_ALL_TSO;
+	tmp &= ~NETIF_F_TSO_ECN;
+	if (!(features & tmp) && (features & NETIF_F_TSO_ECN))
 		features &= ~NETIF_F_TSO_ECN;
 
 	/* Software GSO depends on SG. */
@@ -10007,8 +10012,8 @@ int register_netdevice(struct net_device *dev)
 		}
 	}
 
-	if (((dev->hw_features | dev->features) &
-	     NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	if ((dev->hw_features & NETIF_F_HW_VLAN_CTAG_FILTER ||
+	     dev->features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
 	    (!dev->netdev_ops->ndo_vlan_rx_add_vid ||
 	     !dev->netdev_ops->ndo_vlan_rx_kill_vid)) {
 		netdev_WARN(dev, "Buggy VLAN acceleration in driver!\n");
@@ -10025,7 +10030,8 @@ int register_netdevice(struct net_device *dev)
 	/* Transfer changeable features to wanted_features and enable
 	 * software offloads (GSO and GRO).
 	 */
-	dev->hw_features |= (NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF);
+	dev->hw_features |= NETIF_F_SOFT_FEATURES;
+	dev->hw_features |= NETIF_F_SOFT_FEATURES_OFF;
 	dev->features |= NETIF_F_SOFT_FEATURES;
 
 	if (dev->udp_tunnel_nic_info) {
@@ -11146,16 +11152,28 @@ static int dev_cpu_dead(unsigned int oldcpu)
 netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_t one, netdev_features_t mask)
 {
+	netdev_features_t tmp;
+
 	if (mask & NETIF_F_HW_CSUM)
 		mask |= NETIF_F_CSUM_MASK;
 	mask |= NETIF_F_VLAN_CHALLENGED;
 
-	all |= one & (NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK) & mask;
-	all &= one | ~NETIF_F_ALL_FOR_ALL;
+	tmp = NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK;
+	tmp &= one;
+	tmp &= mask;
+	all |= tmp;
+
+	netdev_features_fill(tmp);
+	tmp &= ~NETIF_F_ALL_FOR_ALL;
+	tmp |= one;
+	all &= tmp;
 
 	/* If one device supports hw checksumming, set for all. */
-	if (all & NETIF_F_HW_CSUM)
-		all &= ~(NETIF_F_CSUM_MASK & ~NETIF_F_HW_CSUM);
+	if (all & NETIF_F_HW_CSUM) {
+		tmp = NETIF_F_CSUM_MASK;
+		tmp &= ~NETIF_F_HW_CSUM;
+		all &= ~tmp;
+	}
 
 	return all;
 }
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 88906ba6d9a7..198d94f2e8f0 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -2963,7 +2963,8 @@ static struct sk_buff *fill_packet_ipv4(struct net_device *odev,
 
 	if (!(pkt_dev->flags & F_UDPCSUM)) {
 		skb->ip_summed = CHECKSUM_NONE;
-	} else if (odev->features & (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM)) {
+	} else if (odev->features & NETIF_F_HW_CSUM ||
+		   odev->features & NETIF_F_IP_CSUM) {
 		skb->ip_summed = CHECKSUM_PARTIAL;
 		skb->csum = 0;
 		udp4_hwcsum(skb, iph->saddr, iph->daddr);
@@ -3098,7 +3099,8 @@ static struct sk_buff *fill_packet_ipv6(struct net_device *odev,
 
 	if (!(pkt_dev->flags & F_UDPCSUM)) {
 		skb->ip_summed = CHECKSUM_NONE;
-	} else if (odev->features & (NETIF_F_HW_CSUM | NETIF_F_IPV6_CSUM)) {
+	} else if (odev->features & NETIF_F_HW_CSUM ||
+		   odev->features & NETIF_F_IPV6_CSUM) {
 		skb->ip_summed = CHECKSUM_PARTIAL;
 		skb->csum_start = skb_transport_header(skb) - skb->head;
 		skb->csum_offset = offsetof(struct udphdr, check);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f1b8b20fc20b..8861d47d1c48 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4316,7 +4316,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		unsigned short gso_size = skb_shinfo(head_skb)->gso_size;
 
 		/* Update type to add partial and then remove dodgy if set */
-		type |= (features & NETIF_F_GSO_PARTIAL) / NETIF_F_GSO_PARTIAL * SKB_GSO_PARTIAL;
+		type |= (features & NETIF_F_GSO_PARTIAL) ? 0 : SKB_GSO_PARTIAL;
 		type &= ~SKB_GSO_DODGY;
 
 		/* Update GSO info and prepare to start updating headers on
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index e57b43006074..9915a6d15886 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -489,8 +489,9 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 	 */
 
 	ip6_dst_store(newsk, dst, NULL, NULL);
-	newsk->sk_route_caps = dst->dev->features & ~(NETIF_F_IP_CSUM |
-						      NETIF_F_TSO);
+	newsk->sk_route_caps = dst->dev->features;
+	newsk->sk_route_caps &= ~NETIF_F_IP_CSUM;
+	newsk->sk_route_caps &= ~NETIF_F_TSO;
 	newdp6 = (struct dccp6_sock *)newsk;
 	newinet = inet_sk(newsk);
 	newinet->pinet6 = &newdp6->inet6;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5d9d1d83754c..7d5de3187bfe 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2288,7 +2288,8 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 
 	p->xmit = cpu_dp->tag_ops->xmit;
 
-	slave->features = master->vlan_features | NETIF_F_HW_TC;
+	slave->features = master->vlan_features;
+	slave->features |= NETIF_F_HW_TC;
 	slave->hw_features |= NETIF_F_HW_TC;
 	slave->features |= NETIF_F_LLTX;
 	if (slave->needed_tailroom)
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 55d449a2d3fc..67a837d44491 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -220,6 +220,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
+	netdev_features_t tmp;
 	bool mod;
 	int ret;
 
@@ -253,7 +254,8 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
 		dev->wanted_features &= ~dev->hw_features;
-		dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+		dev->wanted_features |= tmp;
 		__netdev_update_features(dev);
 	}
 	ethnl_features_to_bitmap(new_active, dev->features);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 01d3e3478a5d..586b4ee4ee85 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -126,6 +126,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
 	netdev_features_t wanted = 0, valid = 0;
+	netdev_features_t tmp;
 	int i, ret = 0;
 
 	if (copy_from_user(&cmd, useraddr, sizeof(cmd)))
@@ -143,19 +144,23 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 		wanted |= (netdev_features_t)features[i].requested << (32 * i);
 	}
 
-	if (valid & ~NETIF_F_ETHTOOL_BITS)
+	tmp = valid & ~NETIF_F_ETHTOOL_BITS;
+	if (tmp)
 		return -EINVAL;
 
-	if (valid & ~dev->hw_features) {
+	tmp = valid & ~dev->hw_features;
+	if (tmp) {
 		valid &= dev->hw_features;
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
 	dev->wanted_features &= ~valid;
-	dev->wanted_features |= wanted & valid;
+	tmp = wanted & valid;
+	dev->wanted_features |= tmp;
 	__netdev_update_features(dev);
 
-	if ((dev->wanted_features ^ dev->features) & valid)
+	tmp = dev->wanted_features ^ dev->features;
+	if (tmp & valid)
 		ret |= ETHTOOL_F_WISH;
 
 	return ret;
@@ -222,28 +227,38 @@ static void __ethtool_get_strings(struct net_device *dev,
 
 static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 {
+	netdev_features_t tmp;
+
 	/* feature masks of legacy discrete ethtool ops */
 
+	netdev_features_zero(tmp);
 	switch (eth_cmd) {
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_STXCSUM:
-		return NETIF_F_CSUM_MASK | NETIF_F_FCOE_CRC |
-		       NETIF_F_SCTP_CRC;
+		tmp = NETIF_F_CSUM_MASK;
+		tmp |= NETIF_F_FCOE_CRC;
+		tmp |= NETIF_F_SCTP_CRC;
+		return tmp;
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_SRXCSUM:
-		return NETIF_F_RXCSUM;
+		tmp |= NETIF_F_RXCSUM;
+		return tmp;
 	case ETHTOOL_GSG:
 	case ETHTOOL_SSG:
-		return NETIF_F_SG | NETIF_F_FRAGLIST;
+		tmp |= NETIF_F_SG;
+		tmp |= NETIF_F_FRAGLIST;
+		return tmp;
 	case ETHTOOL_GTSO:
 	case ETHTOOL_STSO:
 		return NETIF_F_ALL_TSO;
 	case ETHTOOL_GGSO:
 	case ETHTOOL_SGSO:
-		return NETIF_F_GSO;
+		tmp |= NETIF_F_GSO;
+		return tmp;
 	case ETHTOOL_GGRO:
 	case ETHTOOL_SGRO:
-		return NETIF_F_GRO;
+		tmp |= NETIF_F_GRO;
+		return tmp;
 	default:
 		BUG();
 	}
@@ -312,6 +327,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
 	netdev_features_t features = 0, changed;
 	netdev_features_t eth_all_features;
+	netdev_features_t tmp;
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
@@ -334,12 +350,15 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 				NETIF_F_NTUPLE_BIT, NETIF_F_RXHASH_BIT);
 
 	/* allow changing only bits set in hw_features */
-	changed = (features ^ dev->features) & eth_all_features;
-	if (changed & ~dev->hw_features)
+	changed = dev->features ^ features;
+	changed &= eth_all_features;
+	tmp = changed & ~dev->hw_features;
+	if (tmp)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
-	dev->wanted_features =
-		(dev->wanted_features & ~changed) | (features & changed);
+	dev->wanted_features &= ~changed;
+	tmp = features & changed;
+	dev->wanted_features |= tmp;
 
 	__netdev_update_features(dev);
 
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 935026f4c807..2931b3385bc9 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -218,13 +218,15 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 	skb->encap_hdr_csum = 1;
 
 	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
-	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
-					    NETIF_F_SCTP_CRC);
-	else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
-		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~(NETIF_F_CSUM_MASK |
-					    NETIF_F_SCTP_CRC);
+	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev) {
+		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features &= ~NETIF_F_SG;
+		esp_features &= ~NETIF_F_SCTP_CRC;
+	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
+		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM)) {
+		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features  &= ~NETIF_F_SCTP_CRC;
+	}
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 3c6206e2e0f4..085fcf1395d2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1013,7 +1013,8 @@ static int __ip_append_data(struct sock *sk,
 	 */
 	if (transhdrlen &&
 	    length + fragheaderlen <= mtu &&
-	    rt->dst.dev->features & (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM) &&
+	    (rt->dst.dev->features & NETIF_F_HW_CSUM ||
+	     rt->dst.dev->features & NETIF_F_IP_CSUM) &&
 	    (!(flags & MSG_MORE) || cork->gso_size) &&
 	    (!exthdrlen || (rt->dst.dev->features & NETIF_F_HW_ESP_TX_CSUM)))
 		csummode = CHECKSUM_PARTIAL;
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 6d1a4bec2614..0486dbe58390 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -64,9 +64,9 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	/* Try to offload checksum if possible */
 	offload_csum = !!(need_csum &&
 			  !need_ipsec &&
-			  (skb->dev->features &
-			   (is_ipv6 ? (NETIF_F_HW_CSUM | NETIF_F_IPV6_CSUM) :
-				      (NETIF_F_HW_CSUM | NETIF_F_IP_CSUM))));
+			  (skb->dev->features & NETIF_F_HW_CSUM ||
+			   (is_ipv6 ? (skb->dev->features & NETIF_F_IPV6_CSUM) :
+				      (skb->dev->features & NETIF_F_IP_CSUM))));
 
 	features &= skb->dev->hw_enc_features;
 	if (need_csum)
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 3a293838a91d..95b5c26abad5 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -256,12 +256,14 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 
 	skb->encap_hdr_csum = 1;
 
-	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
-					    NETIF_F_SCTP_CRC);
-	else if (!(features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~(NETIF_F_CSUM_MASK |
-					    NETIF_F_SCTP_CRC);
+	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev) {
+		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features &= ~NETIF_F_SG;
+		esp_features &= ~NETIF_F_SCTP_CRC;
+	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM)) {
+		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features  &= ~NETIF_F_SCTP_CRC;
+	}
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0663be2415fe..f6f54fdce208 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1539,7 +1539,8 @@ static int __ip6_append_data(struct sock *sk,
 	    headersize == sizeof(struct ipv6hdr) &&
 	    length <= mtu - headersize &&
 	    (!(flags & MSG_MORE) || cork->gso_size) &&
-	    rt->dst.dev->features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	    (rt->dst.dev->features & NETIF_F_IPV6_CSUM ||
+	     rt->dst.dev->features & NETIF_F_HW_CSUM))
 		csummode = CHECKSUM_PARTIAL;
 
 	if ((flags & MSG_ZEROCOPY) && length) {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index f99685e2d633..f14b0da3b9e1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2222,14 +2222,16 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ieee80211_setup_sdata(sdata, type);
 
 	if (ndev) {
+		netdev_features_t tmp;
+
 		ndev->ieee80211_ptr->use_4addr = params->use_4addr;
 		if (type == NL80211_IFTYPE_STATION)
 			sdata->u.mgd.use_4addr = params->use_4addr;
 
 		ndev->features |= local->hw.netdev_features;
 		ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
-		ndev->hw_features |= ndev->features &
-					MAC80211_SUPPORTED_FEATURES_TX;
+		tmp = ndev->features & MAC80211_SUPPORTED_FEATURES_TX;
+		ndev->hw_features |= tmp;
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 402594e1cdb0..6411034b46e9 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -119,7 +119,8 @@ static void do_setup(struct net_device *netdev)
 	netdev->vlan_features = netdev->features;
 	netdev->hw_enc_features = netdev->features;
 	netdev->features |= netdev_tx_vlan_features;
-	netdev->hw_features = netdev->features & ~NETIF_F_LLTX;
+	netdev->hw_features = netdev->features;
+	netdev->hw_features &= ~NETIF_F_LLTX;
 
 	eth_hw_addr_random(netdev);
 }
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 0f983e5f7dde..dbaf2ddcf656 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1429,7 +1429,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	if (!dev->tlsdev_ops &&
-	    !(dev->features & (NETIF_F_HW_TLS_RX | NETIF_F_HW_TLS_TX)))
+	    !(dev->features & netdev_tls_features))
 		return NOTIFY_DONE;
 
 	switch (event) {
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 96ffd287ae9a..06b94053097e 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -112,8 +112,11 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	if (!xo || (xo->flags & XFRM_XMIT))
 		return skb;
 
-	if (!(features & NETIF_F_HW_ESP))
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
+	if (!(features & NETIF_F_HW_ESP)) {
+		esp_features = features;
+		esp_features &= ~NETIF_F_SG;
+		esp_features &= ~NETIF_F_CSUM_MASK;
+	}
 
 	sp = skb_sec_path(skb);
 	x = sp->xvec[sp->len - 1];
@@ -379,7 +382,8 @@ static int xfrm_api_check(struct net_device *dev)
 	       dev->xfrmdev_ops->xdo_dev_state_delete)))
 		return NOTIFY_BAD;
 #else
-	if (dev->features & (NETIF_F_HW_ESP | NETIF_F_HW_ESP_TX_CSUM))
+	if (dev->features & NETIF_F_HW_ESP ||
+	    dev->features & NETIF_F_HW_ESP_TX_CSUM)
 		return NOTIFY_BAD;
 #endif
 
-- 
2.33.0

