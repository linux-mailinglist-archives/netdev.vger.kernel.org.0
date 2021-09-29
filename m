Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B7B41C8EC
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345589AbhI2QAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:12977 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245167AbhI2P7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:41 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLb90bSqzWC0Y;
        Wed, 29 Sep 2021 23:56:37 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 009/167] net: convert the prototype of ndo_features_check
Date:   Wed, 29 Sep 2021 23:50:56 +0800
Message-ID: <20210929155334.12454-10-shenjian15@huawei.com>
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
ndo_features_check for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 11 ++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 12 +++---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 15 ++++---
 drivers/net/ethernet/cadence/macb_main.c      | 20 +++++----
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 11 +++--
 drivers/net/ethernet/cisco/enic/enic_main.c   | 13 +++---
 drivers/net/ethernet/emulex/benet/be_main.c   | 23 +++++------
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 11 ++---
 drivers/net/ethernet/ibm/ibmvnic.c            |  9 ++--
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  9 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 13 +++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 13 +++---
 drivers/net/ethernet/intel/ice/ice_main.c     | 15 ++++---
 drivers/net/ethernet/intel/igb/igb_main.c     | 41 ++++++++++---------
 drivers/net/ethernet/intel/igbvf/netdev.c     | 37 +++++++++--------
 drivers/net/ethernet/intel/igc/igc_main.c     | 37 +++++++++--------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 41 ++++++++++---------
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 37 +++++++++--------
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 13 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  5 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 15 +++----
 .../ethernet/netronome/nfp/nfp_net_common.c   | 22 +++++-----
 drivers/net/ethernet/qlogic/qede/qede.h       |  5 +--
 drivers/net/ethernet/qlogic/qede/qede_fp.c    | 20 ++++-----
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  | 10 ++---
 drivers/net/ethernet/realtek/8139cp.c         | 10 ++---
 drivers/net/ethernet/realtek/r8169_main.c     | 18 ++++----
 drivers/net/ethernet/sfc/efx_common.c         | 13 +++---
 drivers/net/ethernet/sfc/efx_common.h         |  4 +-
 drivers/net/usb/lan78xx.c                     | 14 +++----
 drivers/net/usb/r8152.c                       | 11 ++---
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 15 +++----
 drivers/net/vmxnet3/vmxnet3_int.h             |  4 +-
 drivers/s390/net/qeth_core.h                  |  5 +--
 drivers/s390/net/qeth_core_main.c             | 18 ++++----
 drivers/s390/net/qeth_l3_main.c               | 10 ++---
 include/linux/netdevice.h                     |  9 ++--
 net/core/dev.c                                |  9 ++--
 38 files changed, 280 insertions(+), 318 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 29bca9fabcde..cc1f1a7a46ae 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2267,14 +2267,11 @@ static int xgbe_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t xgbe_features_check(struct sk_buff *skb,
-					     struct net_device *netdev,
-					     netdev_features_t features)
+static void xgbe_features_check(struct sk_buff *skb, struct net_device *netdev,
+				netdev_features_t *features)
 {
-	vlan_features_check(skb, &features);
-	vxlan_features_check(skb, &features);
-
-	return features;
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 }
 
 static const struct net_device_ops xgbe_netdev_ops = {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index f444515452a5..1f817dfa5b64 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12834,9 +12834,8 @@ static int bnx2x_get_phys_port_id(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t bnx2x_features_check(struct sk_buff *skb,
-					      struct net_device *dev,
-					      netdev_features_t features)
+static void bnx2x_features_check(struct sk_buff *skb, struct net_device *dev,
+				 netdev_features_t *features)
 {
 	/*
 	 * A skb with gso_size + header length > 9700 will cause a
@@ -12854,11 +12853,10 @@ static netdev_features_t bnx2x_features_check(struct sk_buff *skb,
 	if (unlikely(skb_is_gso(skb) &&
 		     (skb_shinfo(skb)->gso_size > 9000) &&
 		     !skb_gso_validate_mac_len(skb, 9700)))
-		features &= ~NETIF_F_GSO_MASK;
+		*features &= ~NETIF_F_GSO_MASK;
 
-	vlan_features_check(skb, &features);
-	vxlan_features_check(skb, &features);
-	return features;
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 }
 
 static int __bnx2x_vlan_configure_vid(struct bnx2x *bp, u16 vid, bool add)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 775dfcdd35f2..4689d053aff8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11090,31 +11090,30 @@ static bool bnxt_tunl_check(struct bnxt *bp, struct sk_buff *skb, u8 l4_proto)
 	return false;
 }
 
-static netdev_features_t bnxt_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void bnxt_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	u8 *l4_proto;
 
-	vlan_features_check(skb, &features);
+	vlan_features_check(skb, features);
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
 		if (!skb->encapsulation)
-			return features;
+			return;
 		l4_proto = &ip_hdr(skb)->protocol;
 		if (bnxt_tunl_check(bp, skb, *l4_proto))
-			return features;
+			return;
 		break;
 	case htons(ETH_P_IPV6):
 		if (!bnxt_exthdr_check(bp, skb, skb_network_offset(skb),
 				       &l4_proto))
 			break;
 		if (!l4_proto || bnxt_tunl_check(bp, skb, *l4_proto))
-			return features;
+			return;
 		break;
 	}
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index e2730b3e1a57..e30ee19d9ba2 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2035,9 +2035,8 @@ static unsigned int macb_tx_map(struct macb *bp,
 	return 0;
 }
 
-static netdev_features_t macb_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void macb_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	unsigned int nr_frags, f;
 	unsigned int hdrlen;
@@ -2046,7 +2045,7 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 
 	/* there is only one buffer or protocol is not UDP */
 	if (!skb_is_nonlinear(skb) || (ip_hdr(skb)->protocol != IPPROTO_UDP))
-		return features;
+		return;
 
 	/* length of header */
 	hdrlen = skb_transport_offset(skb);
@@ -2055,8 +2054,10 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 	 * When software supplies two or more payload buffers all payload buffers
 	 * apart from the last must be a multiple of 8 bytes in size.
 	 */
-	if (!IS_ALIGNED(skb_headlen(skb) - hdrlen, MACB_TX_LEN_ALIGN))
-		return features & ~MACB_NETIF_LSO;
+	if (!IS_ALIGNED(skb_headlen(skb) - hdrlen, MACB_TX_LEN_ALIGN)) {
+		*features &= ~MACB_NETIF_LSO;
+		return;
+	}
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
 	/* No need to check last fragment */
@@ -2064,10 +2065,11 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 	for (f = 0; f < nr_frags; f++) {
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
-		if (!IS_ALIGNED(skb_frag_size(frag), MACB_TX_LEN_ALIGN))
-			return features & ~MACB_NETIF_LSO;
+		if (!IS_ALIGNED(skb_frag_size(frag), MACB_TX_LEN_ALIGN)) {
+			*features &= ~MACB_NETIF_LSO;
+			return;
+		}
 	}
-	return features;
 }
 
 static inline int macb_clear_csum(struct sk_buff *skb)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 0d9cda4ab303..a654169b9dfc 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3834,22 +3834,21 @@ static const struct udp_tunnel_nic_info cxgb_udp_tunnels = {
 	},
 };
 
-static netdev_features_t cxgb_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void cxgb_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
 
 	if (CHELSIO_CHIP_VERSION(adapter->params.chip) < CHELSIO_T6)
-		return features;
+		return;
 
 	/* Check if hw supports offload for this packet */
 	if (!skb->encapsulation || cxgb_encap_offload_supported(skb))
-		return features;
+		return;
 
 	/* Offload is not supported for this encapsulated packet */
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 static netdev_features_t cxgb_fix_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 558a07c5b4bc..5bc075331343 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -240,9 +240,8 @@ static const struct udp_tunnel_nic_info enic_udp_tunnels = {
 	},
 };
 
-static netdev_features_t enic_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void enic_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	const struct ethhdr *eth = (struct ethhdr *)skb_inner_mac_header(skb);
 	struct enic *enic = netdev_priv(dev);
@@ -251,9 +250,9 @@ static netdev_features_t enic_features_check(struct sk_buff *skb,
 	u8 proto;
 
 	if (!skb->encapsulation)
-		return features;
+		return;
 
-	vxlan_features_check(skb, &features);
+	vxlan_features_check(skb, features);
 
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IPV6):
@@ -291,10 +290,10 @@ static netdev_features_t enic_features_check(struct sk_buff *skb,
 	if (port  != enic->vxlan.vxlan_udp_port_number)
 		goto out;
 
-	return features;
+	return;
 
 out:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 int enic_is_dynamic(struct enic *enic)
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 556242d32d93..27e8a1d95a9a 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5064,9 +5064,8 @@ static struct be_cmd_work *be_alloc_work(struct be_adapter *adapter,
 	return work;
 }
 
-static netdev_features_t be_features_check(struct sk_buff *skb,
-					   struct net_device *dev,
-					   netdev_features_t features)
+static void be_features_check(struct sk_buff *skb, struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct be_adapter *adapter = netdev_priv(dev);
 	u8 l4_hdr = 0;
@@ -5076,7 +5075,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		 * to Lancer and BE3 HW. Disable TSO6 feature.
 		 */
 		if (!skyhawk_chip(adapter) && is_ipv6_ext_hdr(skb))
-			features &= ~NETIF_F_TSO6;
+			*features &= ~NETIF_F_TSO6;
 
 		/* Lancer cannot handle the packet with MSS less than 256.
 		 * Also it can't handle a TSO packet with a single segment
@@ -5085,17 +5084,17 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		if (lancer_chip(adapter) &&
 		    (skb_shinfo(skb)->gso_size < 256 ||
 		     skb_shinfo(skb)->gso_segs == 1))
-			features &= ~NETIF_F_GSO_MASK;
+			*features &= ~NETIF_F_GSO_MASK;
 	}
 
 	/* The code below restricts offload features for some tunneled and
 	 * Q-in-Q packets.
 	 * Offload features for normal (non tunnel) packets are unchanged.
 	 */
-	vlan_features_check(skb, &features);
+	vlan_features_check(skb, features);
 	if (!skb->encapsulation ||
 	    !(adapter->flags & BE_FLAGS_VXLAN_OFFLOADS))
-		return features;
+		return;
 
 	/* It's an encapsulated packet and VxLAN offloads are enabled. We
 	 * should disable tunnel offload features if it's not a VxLAN packet,
@@ -5111,7 +5110,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		return features;
+		return;
 	}
 
 	if (l4_hdr != IPPROTO_UDP ||
@@ -5120,10 +5119,10 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 	    skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 		sizeof(struct udphdr) + sizeof(struct vxlanhdr) ||
 	    !adapter->vxlan_port ||
-	    udp_hdr(skb)->dest != adapter->vxlan_port)
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
-
-	return features;
+	    udp_hdr(skb)->dest != adapter->vxlan_port) {
+		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		return;
+	}
 }
 
 static int be_get_phys_port_id(struct net_device *dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index adc54a726661..e8179ac6d4e3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2353,9 +2353,8 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t hns3_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void hns3_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 #define HNS3_MAX_HDR_LEN	480U
 #define HNS3_MAX_L4_HDR_LEN	60U
@@ -2363,7 +2362,7 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	size_t len;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return features;
+		return;
 
 	if (skb->encapsulation)
 		len = skb_inner_transport_header(skb) - skb->data;
@@ -2379,9 +2378,7 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
-
-	return features;
+		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 static void hns3_nic_get_stats64(struct net_device *netdev,
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 8f17096e614d..b8ee2e3977b5 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3003,9 +3003,8 @@ static int ibmvnic_change_mtu(struct net_device *netdev, int new_mtu)
 	return wait_for_reset(adapter);
 }
 
-static netdev_features_t ibmvnic_features_check(struct sk_buff *skb,
-						struct net_device *dev,
-						netdev_features_t features)
+static void ibmvnic_features_check(struct sk_buff *skb, struct net_device *dev,
+				   netdev_features_t *features)
 {
 	/* Some backing hardware adapters can not
 	 * handle packets with a MSS less than 224
@@ -3014,10 +3013,8 @@ static netdev_features_t ibmvnic_features_check(struct sk_buff *skb,
 	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_size < 224 ||
 		    skb_shinfo(skb)->gso_segs == 1)
-			features &= ~NETIF_F_GSO_MASK;
+			*features &= ~NETIF_F_GSO_MASK;
 	}
-
-	return features;
 }
 
 static const struct net_device_ops ibmvnic_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2fb52bd6fc0e..a311bcdfbff2 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1504,14 +1504,13 @@ static void fm10k_dfwd_del_station(struct net_device *dev, void *priv)
 	}
 }
 
-static netdev_features_t fm10k_features_check(struct sk_buff *skb,
-					      struct net_device *dev,
-					      netdev_features_t features)
+static void fm10k_features_check(struct sk_buff *skb, struct net_device *dev,
+				 netdev_features_t *features)
 {
 	if (!skb->encapsulation || fm10k_tx_encap_offload(skb))
-		return features;
+		return;
 
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 static const struct net_device_ops fm10k_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2f20980dd9a5..5246c6abbd7d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12873,9 +12873,8 @@ static int i40e_ndo_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
  * @dev: This physical port's netdev
  * @features: Offload features that the stack believes apply
  **/
-static netdev_features_t i40e_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void i40e_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	size_t len;
 
@@ -12884,13 +12883,13 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	 * checking for CHECKSUM_PARTIAL
 	 */
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return features;
+		return;
 
 	/* We cannot support GSO if the MSS is going to be less than
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		features &= ~NETIF_F_GSO_MASK;
+		*features &= ~NETIF_F_GSO_MASK;
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -12920,9 +12919,9 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	 * by TCP, which is at most 15 dwords
 	 */
 
-	return features;
+	return;
 out_err:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 23762a7ef740..b066f1864b3f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3379,9 +3379,8 @@ static int iavf_set_features(struct net_device *netdev,
  * @dev: This physical port's netdev
  * @features: Offload features that the stack believes apply
  **/
-static netdev_features_t iavf_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void iavf_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	size_t len;
 
@@ -3390,13 +3389,13 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 	 * checking for CHECKSUM_PARTIAL
 	 */
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return features;
+		return;
 
 	/* We cannot support GSO if the MSS is going to be less than
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		features &= ~NETIF_F_GSO_MASK;
+		*features &= ~NETIF_F_GSO_MASK;
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -3426,9 +3425,9 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 	 * by TCP, which is at most 15 dwords
 	 */
 
-	return features;
+	return;
 out_err:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 909e5cd98054..1ad630b8d103 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -7176,10 +7176,9 @@ int ice_stop(struct net_device *netdev)
  * @netdev: This port's netdev
  * @features: Offload features that the stack believes apply
  */
-static netdev_features_t
-ice_features_check(struct sk_buff *skb,
-		   struct net_device __always_unused *netdev,
-		   netdev_features_t features)
+static void ice_features_check(struct sk_buff *skb,
+			       struct net_device __always_unused *netdev,
+			       netdev_features_t *features)
 {
 	size_t len;
 
@@ -7188,13 +7187,13 @@ ice_features_check(struct sk_buff *skb,
 	 * checking for CHECKSUM_PARTIAL
 	 */
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return features;
+		return;
 
 	/* We cannot support GSO if the MSS is going to be less than
 	 * 64 bytes. If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		features &= ~NETIF_F_GSO_MASK;
+		*features &= ~NETIF_F_GSO_MASK;
 
 	len = skb_network_header(skb) - skb->data;
 	if (len > ICE_TXD_MACLEN_MAX || len & 0x1)
@@ -7215,9 +7214,9 @@ ice_features_check(struct sk_buff *skb,
 			goto out_rm_features;
 	}
 
-	return features;
+	return;
 out_rm_features:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 static const struct net_device_ops ice_netdev_safe_mode_ops = {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 751de06019a0..82b59adf8034 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2505,37 +2505,38 @@ static int igb_ndo_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 #define IGB_MAX_MAC_HDR_LEN	127
 #define IGB_MAX_NETWORK_HDR_LEN	511
 
-static netdev_features_t
-igb_features_check(struct sk_buff *skb, struct net_device *dev,
-		   netdev_features_t features)
+static void igb_features_check(struct sk_buff *skb, struct net_device *dev,
+			       netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IGB_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_GSO_UDP_L4 |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IGB_MAX_MAC_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_GSO_UDP_L4 |
+			       NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IGB_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_GSO_UDP_L4 |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IGB_MAX_NETWORK_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_GSO_UDP_L4 |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
-		features &= ~NETIF_F_TSO;
-
-	return features;
+	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID))
+		*features &= ~NETIF_F_TSO;
 }
 
 static void igb_offload_apply(struct igb_adapter *adapter, s32 queue)
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index d32e72d953c8..92a46ac4ee1f 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2619,35 +2619,36 @@ static int igbvf_set_features(struct net_device *netdev,
 #define IGBVF_MAX_MAC_HDR_LEN		127
 #define IGBVF_MAX_NETWORK_HDR_LEN	511
 
-static netdev_features_t
-igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
-		     netdev_features_t features)
+static void igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
+				 netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IGBVF_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IGBVF_MAX_MAC_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IGBVF_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IGBVF_MAX_NETWORK_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
-		features &= ~NETIF_F_TSO;
-
-	return features;
+	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID))
+		*features &= ~NETIF_F_TSO;
 }
 
 static const struct net_device_ops igbvf_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0e19b4d02e62..fdb3ed051456 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4955,35 +4955,36 @@ static int igc_set_features(struct net_device *netdev,
 	return 1;
 }
 
-static netdev_features_t
-igc_features_check(struct sk_buff *skb, struct net_device *dev,
-		   netdev_features_t features)
+static void igc_features_check(struct sk_buff *skb, struct net_device *dev,
+			       netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IGC_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IGC_MAX_MAC_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IGC_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IGC_MAX_NETWORK_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	/* We can only support IPv4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
-		features &= ~NETIF_F_TSO;
-
-	return features;
+	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID))
+		*features &= ~NETIF_F_TSO;
 }
 
 static void igc_tsync_interrupt(struct igc_adapter *adapter)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 24e06ba6f5e9..e39d3983a455 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10067,43 +10067,44 @@ static void ixgbe_fwd_del(struct net_device *pdev, void *priv)
 #define IXGBE_MAX_MAC_HDR_LEN		127
 #define IXGBE_MAX_NETWORK_HDR_LEN	511
 
-static netdev_features_t
-ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
-		     netdev_features_t features)
+static void ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
+				 netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IXGBE_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_GSO_UDP_L4 |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IXGBE_MAX_MAC_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_GSO_UDP_L4 |
+			       NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IXGBE_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_GSO_UDP_L4 |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IXGBE_MAX_NETWORK_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_GSO_UDP_L4 |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 * IPsec offoad sets skb->encapsulation but still can handle
 	 * the TSO, so it's the exception.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID)) {
+	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID)) {
 #ifdef CONFIG_IXGBE_IPSEC
 		if (!secpath_exists(skb))
 #endif
-			features &= ~NETIF_F_TSO;
+			*features &= ~NETIF_F_TSO;
 	}
-
-	return features;
 }
 
 static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index c714e1ecd308..f2f6d00960c5 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4381,35 +4381,36 @@ static void ixgbevf_get_stats(struct net_device *netdev,
 #define IXGBEVF_MAX_MAC_HDR_LEN		127
 #define IXGBEVF_MAX_NETWORK_HDR_LEN	511
 
-static netdev_features_t
-ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
-		       netdev_features_t features)
+static void ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
+				   netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
-	if (unlikely(mac_hdr_len > IXGBEVF_MAX_MAC_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(mac_hdr_len > IXGBEVF_MAX_MAC_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_HW_VLAN_CTAG_TX |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
-	if (unlikely(network_hdr_len >  IXGBEVF_MAX_NETWORK_HDR_LEN))
-		return features & ~(NETIF_F_HW_CSUM |
-				    NETIF_F_SCTP_CRC |
-				    NETIF_F_TSO |
-				    NETIF_F_TSO6);
+	if (unlikely(network_hdr_len >  IXGBEVF_MAX_NETWORK_HDR_LEN)) {
+		*features &= ~(NETIF_F_HW_CSUM |
+			       NETIF_F_SCTP_CRC |
+			       NETIF_F_TSO |
+			       NETIF_F_TSO6);
+		return;
+	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !(features & NETIF_F_TSO_MANGLEID))
-		features &= ~NETIF_F_TSO;
-
-	return features;
+	if (skb->encapsulation && !(*features & NETIF_F_TSO_MANGLEID))
+		*features &= ~NETIF_F_TSO;
 }
 
 static int ixgbevf_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index dd6a41182446..354c63aa726d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2674,12 +2674,11 @@ static const struct udp_tunnel_nic_info mlx4_udp_tunnels = {
 	},
 };
 
-static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
-						struct net_device *dev,
-						netdev_features_t features)
+static void mlx4_en_features_check(struct sk_buff *skb, struct net_device *dev,
+				   netdev_features_t *features)
 {
-	vlan_features_check(skb, &features);
-	vxlan_features_check(skb, &features);
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 
 	/* The ConnectX-3 doesn't support outer IPv6 checksums but it does
 	 * support inner IPv6 checksums and segmentation so  we need to
@@ -2692,10 +2691,8 @@ static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
 		if (!priv->vxlan_port ||
 		    (ip_hdr(skb)->version != 4) ||
 		    (udp_hdr(skb)->dest != priv->vxlan_port))
-			features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 	}
-
-	return features;
 }
 
 static int mlx4_en_set_tx_maxrate(struct net_device *dev, int queue_index, u32 maxrate)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index f5d147c3141a..daf276c43d8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1129,9 +1129,8 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 void mlx5e_rx_dim_work(struct work_struct *work);
 void mlx5e_tx_dim_work(struct work_struct *work);
 
-netdev_features_t mlx5e_features_check(struct sk_buff *skb,
-				       struct net_device *netdev,
-				       netdev_features_t features);
+void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
+			  netdev_features_t *features);
 int mlx5e_set_features(struct net_device *netdev, netdev_features_t features);
 #ifdef CONFIG_MLX5_ESWITCH
 int mlx5e_set_vf_mac(struct net_device *dev, int vf, u8 *mac);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4518a490cdcd..6fdc2a793c1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3904,21 +3904,18 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
-netdev_features_t mlx5e_features_check(struct sk_buff *skb,
-				       struct net_device *netdev,
-				       netdev_features_t features)
+void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
+			  netdev_features_t *features)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	vlan_features_check(skb, &features);
-	vxlan_features_check(skb, &features);
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
-	    (features & NETIF_F_CSUM_MASK || features & NETIF_F_GSO_MASK))
-		return mlx5e_tunnel_features_check(priv, skb, features);
-
-	return features;
+	    (*features & NETIF_F_CSUM_MASK || *features & NETIF_F_GSO_MASK))
+		*features = mlx5e_tunnel_features_check(priv, skb, *features);
 }
 
 static void mlx5e_tx_timeout_work(struct work_struct *work)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 58e7d98d0dd6..6261596cfda6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3598,17 +3598,16 @@ static int nfp_net_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t
-nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
-		       netdev_features_t features)
+static void nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
+				   netdev_features_t *features)
 {
 	u8 l4_hdr;
 
 	/* We can't do TSO over double tagged packets (802.1AD) */
-	vlan_features_check(skb, &features);
+	vlan_features_check(skb, features);
 
 	if (!skb->encapsulation)
-		return features;
+		return;
 
 	/* Ensure that inner L4 header offset fits into TX descriptor field */
 	if (skb_is_gso(skb)) {
@@ -3621,7 +3620,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		 * metadata prepend - 8B
 		 */
 		if (unlikely(hdrlen > NFP_NET_LSO_MAX_HDR_SZ - 8))
-			features &= ~NETIF_F_GSO_MASK;
+			*features &= ~NETIF_F_GSO_MASK;
 	}
 
 	/* VXLAN/GRE check */
@@ -3633,7 +3632,8 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		return;
 	}
 
 	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
@@ -3641,10 +3641,10 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 	    (l4_hdr != IPPROTO_UDP && l4_hdr != IPPROTO_GRE) ||
 	    (l4_hdr == IPPROTO_UDP &&
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
-	      sizeof(struct udphdr) + sizeof(struct vxlanhdr))))
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
-
-	return features;
+	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)))) {
+		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		return;
+	}
 }
 
 static int
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index f90dcfe9ee68..c1f26a2e374d 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -527,9 +527,8 @@ int qede_xdp_transmit(struct net_device *dev, int n_frames,
 		      struct xdp_frame **frames, u32 flags);
 u16 qede_select_queue(struct net_device *dev, struct sk_buff *skb,
 		      struct net_device *sb_dev);
-netdev_features_t qede_features_check(struct sk_buff *skb,
-				      struct net_device *dev,
-				      netdev_features_t features);
+void qede_features_check(struct sk_buff *skb, struct net_device *dev,
+			 netdev_features_t *features);
 int qede_alloc_rx_buffer(struct qede_rx_queue *rxq, bool allow_lazy);
 int qede_free_tx_pkt(struct qede_dev *edev,
 		     struct qede_tx_queue *txq, int *len);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 065e9004598e..8a459d2ca983 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1747,9 +1747,8 @@ u16 qede_select_queue(struct net_device *dev, struct sk_buff *skb,
 /* 8B udp header + 8B base tunnel header + 32B option length */
 #define QEDE_MAX_TUN_HDR_LEN 48
 
-netdev_features_t qede_features_check(struct sk_buff *skb,
-				      struct net_device *dev,
-				      netdev_features_t features)
+void qede_features_check(struct sk_buff *skb, struct net_device *dev,
+			 netdev_features_t *features)
 {
 	if (skb->encapsulation) {
 		u8 l4_proto = 0;
@@ -1762,7 +1761,7 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 			l4_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			return features;
+			return;
 		}
 
 		/* Disable offloads for geneve tunnels, as HW can't parse
@@ -1780,16 +1779,17 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 			if ((skb_inner_mac_header(skb) -
 			     skb_transport_header(skb)) > hdrlen ||
 			     (ntohs(udp_hdr(skb)->dest) != vxln_port &&
-			      ntohs(udp_hdr(skb)->dest) != gnv_port))
-				return features & ~(NETIF_F_CSUM_MASK |
-						    NETIF_F_GSO_MASK);
+			      ntohs(udp_hdr(skb)->dest) != gnv_port)) {
+				*features &= ~(NETIF_F_CSUM_MASK |
+					       NETIF_F_GSO_MASK);
+				return;
+			}
 		} else if (l4_proto == IPPROTO_IPIP) {
 			/* IPIP tunnels are unknown to the device or at least unsupported natively,
 			 * offloads for them can't be done trivially, so disable them for such skb.
 			 */
-			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			return;
 		}
 	}
-
-	return features;
 }
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index d823f2a22472..192d74665c20 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -492,13 +492,11 @@ static const struct udp_tunnel_nic_info qlcnic_udp_tunnels = {
 	},
 };
 
-static netdev_features_t qlcnic_features_check(struct sk_buff *skb,
-					       struct net_device *dev,
-					       netdev_features_t features)
+static void qlcnic_features_check(struct sk_buff *skb, struct net_device *dev,
+				  netdev_features_t *features)
 {
-	vlan_features_check(skb, &features);
-	vxlan_features_check(skb, &features);
-	return features;
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 }
 
 static const struct net_device_ops qlcnic_netdev_ops = {
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index d2135fe99cd7..663a12598cad 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1853,15 +1853,13 @@ static void cp_set_d3_state (struct cp_private *cp)
 	pci_set_power_state (cp->pdev, PCI_D3hot);
 }
 
-static netdev_features_t cp_features_check(struct sk_buff *skb,
-					   struct net_device *dev,
-					   netdev_features_t features)
+static void cp_features_check(struct sk_buff *skb, struct net_device *dev,
+			      netdev_features_t *features)
 {
 	if (skb_shinfo(skb)->gso_size > MSSMask)
-		features &= ~NETIF_F_TSO;
+		*features &= ~NETIF_F_TSO;
 
-	vlan_features_check(skb, &features);
-	return features;
+	vlan_features_check(skb, features);
 }
 static const struct net_device_ops cp_netdev_ops = {
 	.ndo_open		= cp_open,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 98e7ffa6aa0a..3d753ddd1a89 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4347,35 +4347,33 @@ static netdev_features_t rtl8168evl_fix_tso(struct sk_buff *skb,
 	return features;
 }
 
-static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
-						struct net_device *dev,
-						netdev_features_t features)
+static void rtl8169_features_check(struct sk_buff *skb, struct net_device *dev,
+				   netdev_features_t *features)
 {
 	int transport_offset = skb_transport_offset(skb);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (skb_is_gso(skb)) {
 		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
-			features = rtl8168evl_fix_tso(skb, features);
+			*features = rtl8168evl_fix_tso(skb, *features);
 
 		if (transport_offset > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			features &= ~NETIF_F_ALL_TSO;
+			*features &= ~NETIF_F_ALL_TSO;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		/* work around hw bug on some chip versions */
 		if (skb->len < ETH_ZLEN)
-			features &= ~NETIF_F_CSUM_MASK;
+			*features &= ~NETIF_F_CSUM_MASK;
 
 		if (rtl_quirk_packet_padto(tp, skb))
-			features &= ~NETIF_F_CSUM_MASK;
+			*features &= ~NETIF_F_CSUM_MASK;
 
 		if (transport_offset > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			features &= ~NETIF_F_CSUM_MASK;
+			*features &= ~NETIF_F_CSUM_MASK;
 	}
 
-	vlan_features_check(skb, &features);
-	return features;
+	vlan_features_check(skb, features);
 }
 
 static void rtl8169_pcierr_interrupt(struct net_device *dev)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 896b59253197..a101fa50a5cc 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1353,25 +1353,24 @@ static bool efx_can_encap_offloads(struct efx_nic *efx, struct sk_buff *skb)
 	}
 }
 
-netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev,
-				     netdev_features_t features)
+void efx_features_check(struct sk_buff *skb, struct net_device *dev,
+			netdev_features_t *features)
 {
 	struct efx_nic *efx = netdev_priv(dev);
 
 	if (skb->encapsulation) {
-		if (features & NETIF_F_GSO_MASK)
+		if (*features & NETIF_F_GSO_MASK)
 			/* Hardware can only do TSO with at most 208 bytes
 			 * of headers.
 			 */
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
-				features &= ~(NETIF_F_GSO_MASK);
-		if (features & (NETIF_F_GSO_MASK | NETIF_F_CSUM_MASK))
+				*features &= ~(NETIF_F_GSO_MASK);
+		if (*features & (NETIF_F_GSO_MASK | NETIF_F_CSUM_MASK))
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~(NETIF_F_GSO_MASK |
+				*features &= ~(NETIF_F_GSO_MASK |
 					      NETIF_F_CSUM_MASK);
 	}
-	return features;
 }
 
 int efx_get_phys_port_id(struct net_device *net_dev,
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 65513fd0cf6c..c4fea3997704 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -105,8 +105,8 @@ int efx_change_mtu(struct net_device *net_dev, int new_mtu);
 
 extern const struct pci_error_handlers efx_err_handlers;
 
-netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev,
-				     netdev_features_t features);
+void efx_features_check(struct sk_buff *skb, struct net_device *dev,
+			netdev_features_t *features);
 
 int efx_get_phys_port_id(struct net_device *net_dev,
 			 struct netdev_phys_item_id *ppid);
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 9bfee75cbaf1..7a60cc0f6aad 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3976,17 +3976,15 @@ static void lan78xx_tx_timeout(struct net_device *net, unsigned int txqueue)
 	tasklet_schedule(&dev->bh);
 }
 
-static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
-						struct net_device *netdev,
-						netdev_features_t features)
+static void lan78xx_features_check(struct sk_buff *skb,
+				   struct net_device *netdev,
+				   netdev_features_t *features)
 {
 	if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
-		features &= ~NETIF_F_GSO_MASK;
+		*features &= ~NETIF_F_GSO_MASK;
 
-	vlan_features_check(skb, &features);
-	vxlan_features_check(skb, &features);
-
-	return features;
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 }
 
 static const struct net_device_ops lan78xx_netdev_ops = {
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 60ba9b734055..5bb327b8d8e0 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2741,20 +2741,17 @@ static void _rtl8152_set_rx_mode(struct net_device *netdev)
 	netif_wake_queue(netdev);
 }
 
-static netdev_features_t
-rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
-		       netdev_features_t features)
+static void rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
+				   netdev_features_t *features)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
 	int max_offset = mss ? GTTCPHO_MAX : TCPHO_MAX;
 	int offset = skb_transport_offset(skb);
 
 	if ((mss || skb->ip_summed == CHECKSUM_PARTIAL) && offset > max_offset)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 	else if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
-		features &= ~NETIF_F_GSO_MASK;
-
-	return features;
+		*features &= ~NETIF_F_GSO_MASK;
 }
 
 static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 5dd8360b21a0..e840547cd19e 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -256,9 +256,8 @@ netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
 	return features;
 }
 
-netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
-					 struct net_device *netdev,
-					 netdev_features_t features)
+void vmxnet3_features_check(struct sk_buff *skb, struct net_device *netdev,
+			    netdev_features_t *features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
@@ -277,7 +276,8 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			l4_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			return;
 		}
 
 		switch (l4_proto) {
@@ -288,14 +288,15 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			if (port != GENEVE_UDP_PORT &&
 			    port != IANA_VXLAN_UDP_PORT &&
 			    port != VXLAN_UDP_PORT) {
-				return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+				*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+				return;
 			}
 			break;
 		default:
-			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			*features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			return;
 		}
 	}
-	return features;
 }
 
 static void vmxnet3_enable_encap_offloads(struct net_device *netdev)
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 7027ff483fa5..a711759ebb00 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -478,9 +478,9 @@ vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 netdev_features_t
 vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
 
-netdev_features_t
+void
 vmxnet3_features_check(struct sk_buff *skb,
-		       struct net_device *netdev, netdev_features_t features);
+		       struct net_device *netdev, netdev_features_t *features);
 
 int
 vmxnet3_set_features(struct net_device *netdev, netdev_features_t features);
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index a5aa0bdc61d6..58bd0dc43695 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1094,9 +1094,8 @@ int qeth_setassparms_cb(struct qeth_card *, struct qeth_reply *, unsigned long);
 int qeth_set_features(struct net_device *, netdev_features_t);
 void qeth_enable_hw_features(struct net_device *dev);
 netdev_features_t qeth_fix_features(struct net_device *, netdev_features_t);
-netdev_features_t qeth_features_check(struct sk_buff *skb,
-				      struct net_device *dev,
-				      netdev_features_t features);
+void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
+			 netdev_features_t *features);
 void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats);
 int qeth_set_real_num_tx_queues(struct qeth_card *card, unsigned int count);
 u16 qeth_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 3b1903f8790a..46b5ad0171fa 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6946,9 +6946,8 @@ netdev_features_t qeth_fix_features(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(qeth_fix_features);
 
-netdev_features_t qeth_features_check(struct sk_buff *skb,
-				      struct net_device *dev,
-				      netdev_features_t features)
+void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
+			 netdev_features_t *features)
 {
 	struct qeth_card *card = dev->ml_priv;
 
@@ -6957,7 +6956,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 	    READ_ONCE(card->options.isolation) != ISOLATION_MODE_FWD) {
 		netdev_features_t restricted = 0;
 
-		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
+		if (skb_is_gso(skb) && !netif_needs_gso(skb, *features))
 			restricted |= NETIF_F_ALL_TSO;
 
 		switch (vlan_get_protocol(skb)) {
@@ -6966,14 +6965,14 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 				restricted |= NETIF_F_IP_CSUM;
 
 			if (restricted && qeth_next_hop_is_local_v4(card, skb))
-				features &= ~restricted;
+				*features &= ~restricted;
 			break;
 		case htons(ETH_P_IPV6):
 			if (!card->info.has_lp2lp_cso_v6)
 				restricted |= NETIF_F_IPV6_CSUM;
 
 			if (restricted && qeth_next_hop_is_local_v6(card, skb))
-				features &= ~restricted;
+				*features &= ~restricted;
 			break;
 		default:
 			break;
@@ -6987,7 +6986,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 	 * additional buffer element. This reduces buffer utilization, and
 	 * hurts throughput. So compress small segments into one element.
 	 */
-	if (netif_needs_gso(skb, features)) {
+	if (netif_needs_gso(skb, *features)) {
 		/* match skb_segment(): */
 		unsigned int doffset = skb->data - skb_mac_header(skb);
 		unsigned int hsize = skb_shinfo(skb)->gso_size;
@@ -6995,11 +6994,10 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 
 		/* linearize only if resulting skb allocations are order-0: */
 		if (SKB_DATA_ALIGN(hroom + doffset + hsize) <= SKB_MAX_HEAD(0))
-			features &= ~NETIF_F_SG;
+			*features &= ~NETIF_F_SG;
 	}
 
-	vlan_features_check(skb, &features);
-	return features;
+	vlan_features_check(skb, features);
 }
 EXPORT_SYMBOL_GPL(qeth_features_check);
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 6fd3e288f059..1d3d0377fe4b 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1804,13 +1804,13 @@ qeth_l3_neigh_setup(struct net_device *dev, struct neigh_parms *np)
 	return 0;
 }
 
-static netdev_features_t qeth_l3_osa_features_check(struct sk_buff *skb,
-						    struct net_device *dev,
-						    netdev_features_t features)
+static void qeth_l3_osa_features_check(struct sk_buff *skb,
+				       struct net_device *dev,
+				       netdev_features_t *features)
 {
 	if (vlan_get_protocol(skb) != htons(ETH_P_IP))
-		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
-	return qeth_features_check(skb, dev, features);
+		*features &= ~NETIF_F_HW_VLAN_CTAG_TX;
+	qeth_features_check(skb, dev, features);
 }
 
 static u16 qeth_l3_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a5598d617789..09233e7df8f1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1352,9 +1352,9 @@ struct net_device_ops {
 	int			(*ndo_stop)(struct net_device *dev);
 	netdev_tx_t		(*ndo_start_xmit)(struct sk_buff *skb,
 						  struct net_device *dev);
-	netdev_features_t	(*ndo_features_check)(struct sk_buff *skb,
+	void			(*ndo_features_check)(struct sk_buff *skb,
 						      struct net_device *dev,
-						      netdev_features_t features);
+						      netdev_features_t *features);
 	u16			(*ndo_select_queue)(struct net_device *dev,
 						    struct sk_buff *skb,
 						    struct net_device *sb_dev);
@@ -5056,9 +5056,8 @@ void netdev_change_features(struct net_device *dev);
 void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 					struct net_device *dev);
 
-netdev_features_t passthru_features_check(struct sk_buff *skb,
-					  struct net_device *dev,
-					  netdev_features_t features);
+void passthru_features_check(struct sk_buff *skb, struct net_device *dev,
+			     netdev_features_t *features);
 netdev_features_t netif_skb_features(struct sk_buff *skb);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
diff --git a/net/core/dev.c b/net/core/dev.c
index 814e6e7ee579..43b81dc6b815 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3472,11 +3472,9 @@ static void harmonize_features(struct sk_buff *skb, netdev_features_t *features)
 		*features &= ~NETIF_F_SG;
 }
 
-netdev_features_t passthru_features_check(struct sk_buff *skb,
-					  struct net_device *dev,
-					  netdev_features_t features)
+void passthru_features_check(struct sk_buff *skb, struct net_device *dev,
+			     netdev_features_t *features)
 {
-	return features;
 }
 EXPORT_SYMBOL(passthru_features_check);
 
@@ -3547,8 +3545,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 					  NETIF_F_HW_VLAN_STAG_TX);
 
 	if (dev->netdev_ops->ndo_features_check)
-		features &= dev->netdev_ops->ndo_features_check(skb, dev,
-								features);
+		dev->netdev_ops->ndo_features_check(skb, dev, &features);
 	else
 		dflt_features_check(skb, dev, &features);
 
-- 
2.33.0

