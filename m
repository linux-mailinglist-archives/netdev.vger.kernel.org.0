Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC9941C98B
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 18:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345617AbhI2QG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:06:27 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:27927 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345707AbhI2QAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 12:00:24 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HKLXC5cxpzbmfs;
        Wed, 29 Sep 2021 23:54:03 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:21 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:58:20 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 166/167] treewide: introduce macro __DECLARE_NETDEV_FEATURE_MASK
Date:   Wed, 29 Sep 2021 23:53:33 +0800
Message-ID: <20210929155334.12454-167-shenjian15@huawei.com>
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

Introduce macro __DECLARE_NETDEV_FEATURE_MASK for declare
netdev_features_t. In the next patch, the macro will be
replaced by DECLARE_BITMAP(name, NETDEV_FEATURE_COUNT).

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/bonding/bond_main.c               | 20 +++++++++----------
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h          |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |  2 +-
 drivers/net/ethernet/atheros/atlx/atlx.c      |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  3 ++-
 drivers/net/ethernet/broadcom/tg3.c           |  6 +++---
 drivers/net/ethernet/brocade/bna/bnad.c       |  2 +-
 drivers/net/ethernet/cadence/macb_main.c      |  4 ++--
 drivers/net/ethernet/calxeda/xgmac.c          |  2 +-
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  2 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  2 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  4 ++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  2 +-
 drivers/net/ethernet/davicom/dm9000.c         |  2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c  |  2 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  2 +-
 drivers/net/ethernet/freescale/fec_main.c     |  4 ++--
 .../net/ethernet/freescale/gianfar_ethtool.c  |  2 +-
 drivers/net/ethernet/google/gve/gve_main.c    |  2 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |  2 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  4 ++--
 drivers/net/ethernet/ibm/ibmvnic.c            |  4 ++--
 drivers/net/ethernet/intel/e100.c             |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  2 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  4 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  6 +++---
 drivers/net/ethernet/intel/ice/ice_main.c     |  8 ++++----
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 ++--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  6 +++---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  2 +-
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  4 ++--
 drivers/net/ethernet/mscc/ocelot_net.c        |  2 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  2 +-
 drivers/net/ethernet/neterion/s2io.c          |  2 +-
 .../net/ethernet/neterion/vxge/vxge-main.c    |  4 ++--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  4 ++--
 drivers/net/ethernet/nvidia/forcedeth.c       |  2 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  2 +-
 drivers/net/ethernet/qlogic/qede/qede.h       |  2 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  4 ++--
 drivers/net/ethernet/qualcomm/emac/emac.c     |  2 +-
 drivers/net/ethernet/realtek/8139too.c        |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  2 +-
 drivers/net/ethernet/renesas/sh_eth.c         |  2 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  2 +-
 drivers/net/ethernet/sfc/ef10.c               |  4 ++--
 drivers/net/ethernet/sfc/ef100_nic.c          |  2 +-
 drivers/net/ethernet/sfc/efx.c                |  2 +-
 drivers/net/ethernet/sfc/efx_common.c         |  4 ++--
 drivers/net/ethernet/sfc/falcon/efx.c         |  4 ++--
 drivers/net/ethernet/sfc/falcon/net_driver.h  |  2 +-
 drivers/net/ethernet/sfc/mcdi_filters.c       |  2 +-
 drivers/net/ethernet/sfc/net_driver.h         |  2 +-
 drivers/net/ethernet/sun/sunvnet_common.c     |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h    |  2 +-
 drivers/net/hyperv/netvsc_drv.c               |  2 +-
 drivers/net/hyperv/rndis_filter.c             |  2 +-
 drivers/net/ipvlan/ipvlan.h                   |  2 +-
 drivers/net/ipvlan/ipvlan_main.c              |  2 +-
 drivers/net/macsec.c                          |  2 +-
 drivers/net/macvlan.c                         |  5 +++--
 drivers/net/net_failover.c                    |  8 ++++----
 drivers/net/tap.c                             |  6 +++---
 drivers/net/team/team.c                       | 10 +++++-----
 drivers/net/tun.c                             |  6 +++---
 drivers/net/usb/aqc111.c                      |  2 +-
 drivers/net/usb/ax88179_178a.c                |  2 +-
 drivers/net/usb/r8152.c                       |  4 ++--
 drivers/net/veth.c                            |  2 +-
 drivers/net/virtio_net.c                      |  2 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  2 +-
 drivers/net/xen-netfront.c                    |  2 +-
 drivers/s390/net/qeth_core_main.c             |  8 ++++----
 drivers/staging/qlge/qlge_main.c              |  2 +-
 include/linux/if_macvlan.h                    |  2 +-
 include/linux/if_tap.h                        |  2 +-
 include/linux/netdev_features.h               |  3 +++
 include/linux/netdevice.h                     | 18 ++++++++---------
 include/net/mac80211.h                        |  2 +-
 include/net/sock.h                            |  8 ++++----
 include/net/udp.h                             |  2 +-
 net/8021q/vlan_dev.c                          |  6 +++---
 net/bridge/br_if.c                            |  2 +-
 net/core/dev.c                                | 18 ++++++++---------
 net/core/netpoll.c                            |  2 +-
 net/ethtool/features.c                        |  2 +-
 net/ethtool/ioctl.c                           |  6 +++---
 net/hsr/hsr_device.c                          |  2 +-
 net/ipv4/esp4_offload.c                       |  2 +-
 net/ipv4/ip_output.c                          |  2 +-
 net/ipv4/tcp_offload.c                        |  2 +-
 net/ipv6/esp6_offload.c                       |  2 +-
 net/ipv6/ip6_output.c                         |  2 +-
 net/mac80211/iface.c                          |  2 +-
 net/mac80211/main.c                           |  2 +-
 net/mpls/mpls_gso.c                           |  2 +-
 net/openvswitch/datapath.c                    |  2 +-
 net/sched/sch_cake.c                          |  2 +-
 net/sched/sch_netem.c                         |  2 +-
 net/sched/sch_taprio.c                        |  2 +-
 net/sched/sch_tbf.c                           |  2 +-
 net/sctp/offload.c                            |  2 +-
 net/xfrm/xfrm_device.c                        |  2 +-
 129 files changed, 206 insertions(+), 201 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9c6f37589733..6e64ad75b847 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1365,8 +1365,8 @@ static void bond_fix_features(struct net_device *dev,
 			      netdev_features_t *features)
 {
 	struct bonding *bond = netdev_priv(dev);
+	__DECLARE_NETDEV_FEATURE_MASK(mask);
 	struct list_head *iter;
-	netdev_features_t mask;
 	struct slave *slave;
 
 #if IS_ENABLED(CONFIG_TLS_DEVICE)
@@ -1403,16 +1403,16 @@ static void bond_compute_features(struct bonding *bond)
 {
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
-	netdev_features_t vlan_features;
-	netdev_features_t enc_features;
-	netdev_features_t vlan_mask;
-	netdev_features_t enc_mask;
+	__DECLARE_NETDEV_FEATURE_MASK(vlan_features);
+	__DECLARE_NETDEV_FEATURE_MASK(enc_features);
+	__DECLARE_NETDEV_FEATURE_MASK(vlan_mask);
+	__DECLARE_NETDEV_FEATURE_MASK(enc_mask);
 #ifdef CONFIG_XFRM_OFFLOAD
-	netdev_features_t xfrm_features;
-	netdev_features_t xfrm_mask;
+	__DECLARE_NETDEV_FEATURE_MASK(xfrm_features);
+	__DECLARE_NETDEV_FEATURE_MASK(xfrm_mask);
 #endif /* CONFIG_XFRM_OFFLOAD */
-	netdev_features_t mpls_features;
-	netdev_features_t mpls_mask;
+	__DECLARE_NETDEV_FEATURE_MASK(mpls_features);
+	__DECLARE_NETDEV_FEATURE_MASK(mpls_mask);
 	struct net_device *bond_dev = bond->dev;
 	struct list_head *iter;
 	struct slave *slave;
@@ -2304,10 +2304,10 @@ static int __bond_release_one(struct net_device *bond_dev,
 			      bool all, bool unregister)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
+	__DECLARE_NETDEV_FEATURE_MASK(old_features);
 	struct slave *slave, *oldcurrent;
 	struct sockaddr_storage ss;
 	int old_flags = bond_dev->flags;
-	netdev_features_t old_features;
 
 	netdev_feature_copy(&old_features, bond_dev->features);
 	/* slave is not a slave or master is not master of this slave */
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 3bbf12bc25d8..3eda7401ce63 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4026,7 +4026,7 @@ static u32 ena_calc_max_io_queue_num(struct pci_dev *pdev,
 static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 				 struct net_device *netdev)
 {
-	netdev_features_t dev_features;
+	__DECLARE_NETDEV_FEATURE_MASK(dev_features);
 
 	netdev_feature_zero(&dev_features);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 2c29fa3a0bee..401060a2e020 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2186,7 +2186,7 @@ static void xgbe_fix_features(struct net_device *netdev,
 			      netdev_features_t *features)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
-	netdev_features_t vxlan_base;
+	__DECLARE_NETDEV_FEATURE_MASK(vxlan_base);
 
 	netdev_feature_zero(&vxlan_base);
 	netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 3305979a9f7c..7355056ed935 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -1170,7 +1170,7 @@ struct xgbe_prv_data {
 
 	/* Netdev related settings */
 	unsigned char mac_addr[ETH_ALEN];
-	netdev_features_t netdev_features;
+	__DECLARE_NETDEV_FEATURE_MASK(netdev_features);
 	struct napi_struct napi;
 	struct xgbe_mmc_stats mmc_stats;
 	struct xgbe_ext_stats ext_stats;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 685adb52d44a..a1047dfce73e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -38,7 +38,7 @@ struct aq_fc_info {
 
 struct aq_nic_cfg_s {
 	const struct aq_hw_caps_s *aq_hw_caps;
-	netdev_features_t features;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	u32 rxds;		/* rx ring size, descriptors # */
 	u32 txds;		/* tx ring size, descriptors # */
 	u32 vecs;		/* allocated rx/tx vectors */
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index eea741e971ae..1c8803f86900 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -530,7 +530,7 @@ static void atl1c_fix_features(struct net_device *netdev,
 static int atl1c_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, netdev->features, features);
 
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index fe5339b0ca7f..d5ee30450f89 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -399,7 +399,7 @@ static void atl1e_fix_features(struct net_device *netdev,
 static int atl1e_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, netdev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 2db693636588..943f2af0e3e6 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -388,7 +388,7 @@ static void atl2_fix_features(struct net_device *netdev,
 static int atl2_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, netdev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index 6e91bf6f54d0..ea5b6d73e2f1 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -254,7 +254,7 @@ static void atlx_fix_features(struct net_device *netdev,
 static int atlx_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, netdev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 29f7b0b03d64..4be5a2fa0734 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7750,7 +7750,7 @@ static int
 bnx2_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct bnx2 *bp = netdev_priv(dev);
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	/* TSO with VLAN tag won't work with current firmware */
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index b238312fd0c7..57709a295867 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4906,7 +4906,7 @@ void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features)
 	struct bnx2x *bp = netdev_priv(dev);
 
 	if (pci_num_vf(bp->pdev)) {
-		netdev_features_t changed;
+		__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 		netdev_feature_xor(&changed, dev->features, *features);
 
@@ -4944,8 +4944,8 @@ void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features)
 
 int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(changes);
 	struct bnx2x *bp = netdev_priv(dev);
-	netdev_features_t changes;
 	bool bnx2x_reload = false;
 	int rc;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 24d6f883c243..3d18839615a2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10905,7 +10905,8 @@ static bool bnxt_rfs_capable(struct bnxt *bp)
 static void bnxt_fix_features(struct net_device *dev,
 			      netdev_features_t *features)
 {
-	netdev_features_t vlan_features, tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(vlan_features);
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	struct bnxt *bp = netdev_priv(dev);
 
 	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, *features) &&
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 0406951a3a3e..430082a11f9c 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7860,8 +7860,8 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 		       struct netdev_queue *txq, struct sk_buff *skb)
 {
 	u32 frag_cnt_est = skb_shinfo(skb)->gso_segs * 3;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	struct sk_buff *segs, *seg, *next;
-	netdev_features_t tmp;
 
 	/* Estimate the number of fragments in the worst case */
 	if (unlikely(tg3_tx_avail(tnapi) <= frag_cnt_est)) {
@@ -8316,7 +8316,7 @@ static void tg3_fix_features(struct net_device *dev,
 
 static int tg3_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, dev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_LOOPBACK_BIT, changed) &&
@@ -17557,13 +17557,13 @@ static void tg3_init_coal(struct tg3 *tp)
 static int tg3_init_one(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct net_device *dev;
 	struct tg3 *tp;
 	int i, err;
 	u32 sndmbx, rcvmbx, intmbx;
 	char str[40];
 	u64 dma_mask, persist_dma_mask;
-	netdev_features_t features;
 
 	netdev_feature_zero(&features);
 
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 2e51cf6fb1c3..ed630cea4906 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3351,8 +3351,8 @@ bnad_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 
 static int bnad_set_features(struct net_device *dev, netdev_features_t features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct bnad *bnad = netdev_priv(dev);
-	netdev_features_t changed;
 
 	netdev_feature_xor(&changed, features, dev->features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 53a44ba6444c..7ffaa706536e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3634,8 +3634,8 @@ static inline void macb_set_rxflow_feature(struct macb *bp,
 static int macb_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct macb *bp = netdev_priv(netdev);
-	netdev_features_t changed;
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
@@ -3656,9 +3656,9 @@ static int macb_set_features(struct net_device *netdev,
 
 static void macb_restore_features(struct macb *bp)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct net_device *netdev = bp->dev;
 	struct ethtool_rx_fs_item *item;
-	netdev_features_t features;
 
 	netdev_feature_copy(&features, netdev->features);
 
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 10792529ef56..3679fed9beaf 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1490,8 +1490,8 @@ static int xgmac_set_features(struct net_device *dev, netdev_features_t features
 {
 	u32 ctrl;
 	struct xgmac_priv *priv = netdev_priv(dev);
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	void __iomem *ioaddr = priv->base;
-	netdev_features_t changed;
 
 	netdev_feature_xor(&changed, dev->features, features);
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 1653c058e4b9..170c3b0aaaee 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1854,8 +1854,8 @@ static void liquidio_fix_features(struct net_device *netdev,
 static int liquidio_set_features(struct net_device *netdev,
 				 netdev_features_t features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct lio *lio = netdev_priv(netdev);
-	netdev_features_t changed;
 
 	netdev_feature_xor(&changed, netdev->features, features);
 	if (!netdev_feature_test_bit(NETIF_F_LRO_BIT, changed))
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index de451d94e1a7..be88c1b8a0a2 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1788,7 +1788,7 @@ static int nicvf_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct nicvf *nic = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 193c75f5d682..6d4fbb1bd303 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -875,7 +875,7 @@ static void t1_fix_features(struct net_device *dev, netdev_features_t *features)
 static int t1_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct adapter *adapter = dev->ml_priv;
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, dev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index acd2299c1657..806d4a4d4ffe 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2615,7 +2615,7 @@ static void cxgb_fix_features(struct net_device *dev,
 
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, dev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
@@ -3220,9 +3220,9 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int i, err, pci_using_dac = 0;
 	resource_size_t mmio_start, mmio_len;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	const struct adapter_info *ai;
 	struct adapter *adapter = NULL;
-	netdev_features_t tmp;
 	struct port_info *pi;
 
 	if (!cxgb3_wq) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 26c550ae6dd0..260695dd4f68 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1274,7 +1274,7 @@ int cxgb4_set_rspq_intr_params(struct sge_rspq *q,
 static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
 {
 	const struct port_info *pi = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err;
 
 	netdev_feature_xor(&changed, dev->features, features);
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 772b513b6ba1..5b2730de38c8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1191,7 +1191,7 @@ static int cxgb4vf_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct port_info *pi = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, dev->features, features);
 	if (netdev_feature_test_bit(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index cf349566d9e0..8e4ca68c1986 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -586,7 +586,7 @@ static int dm9000_set_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	struct board_info *dm = to_dm9000_board(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	unsigned long flags;
 
 	netdev_feature_xor(&changed, dev->features, features);
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 0ca939eb2921..8552bbaa8256 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1582,7 +1582,7 @@ static int ftgmac100_set_features(struct net_device *netdev,
 				  netdev_features_t features)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	if (!netif_running(netdev))
 		return 0;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index d9ce2925e0b9..796a311c1a0a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2142,7 +2142,7 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 				  netdev_features_t features)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	bool enable;
 	int err;
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 0d92c45aa5df..719da3a38e36 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2354,7 +2354,7 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 int enetc_set_features(struct net_device *ndev,
 		       netdev_features_t features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err = 0;
 
 	netdev_feature_xor(&changed, ndev->features, features);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7dad33460673..e4a3b3d8d98f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -705,7 +705,7 @@ static int enetc_pf_set_features(struct net_device *ndev,
 				 netdev_features_t features)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, ndev->features, features);
 
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index e782bf61463d..987267f897b9 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3373,7 +3373,7 @@ static inline void fec_enet_set_netdev_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 	netdev_feature_copy(&netdev->features, features);
@@ -3391,7 +3391,7 @@ static int fec_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 38e77a01ddd1..f90708d51ecf 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -504,7 +504,7 @@ static int gfar_spauseparam(struct net_device *dev,
 int gfar_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct gfar_private *priv = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err = 0;
 
 	netdev_feature_xor(&changed, dev->features, features);
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 2a5620bc35e5..1e964410d4fd 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1112,8 +1112,8 @@ static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static int gve_set_features(struct net_device *netdev,
 			    netdev_features_t features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(orig_features);
 	struct gve_priv *priv = netdev_priv(netdev);
-	netdev_features_t orig_features;
 	int err;
 
 	netdev_feature_copy(&orig_features, netdev->features);
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index d76e89afb329..f91387efc7ef 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -587,8 +587,8 @@ bool gve_clean_rx_done(struct gve_rx_ring *rx, int budget,
 
 bool gve_rx_poll(struct gve_notify_block *block, int budget)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(feat);
 	struct gve_rx_ring *rx = block->rx;
-	netdev_features_t feat;
 	bool repoll = false;
 
 	netdev_feature_copy(&feat, block->napi.dev->features);
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 8e55d11daceb..90ac50df604d 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -663,7 +663,7 @@ static int gve_rx_complete_skb(struct gve_rx_ring *rx, struct napi_struct *napi,
 int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 {
 	struct napi_struct *napi = &block->napi;
-	netdev_features_t feat;
+	__DECLARE_NETDEV_FEATURE_MASK(feat);
 
 	struct gve_rx_ring *rx = block->rx;
 	struct gve_rx_compl_queue_dqo *complq = &rx->dqo.complq;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 180019026650..ad522b163242 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2318,7 +2318,7 @@ static int hns3_nic_set_features(struct net_device *netdev,
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	bool enable;
 	int ret;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index c33bb3dd5614..fc0765db66d1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1079,9 +1079,9 @@ static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t pre_features,
 			netdev_features_t features, bool force_change)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(failed_features);
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
-	netdev_features_t failed_features;
-	netdev_features_t changed;
 	int ret = 0;
 	int err = 0;
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 4dfabea91db6..4008951a24fd 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4510,8 +4510,8 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 {
 	struct ibmvnic_control_ip_offload_buffer *ctrl_buf = &adapter->ip_offload_ctrl;
 	struct ibmvnic_query_ip_offload_buffer *buf = &adapter->ip_offload_buf;
+	__DECLARE_NETDEV_FEATURE_MASK(old_hw_features);
 	struct device *dev = &adapter->vdev->dev;
-	netdev_features_t old_hw_features;
 	union ibmvnic_crq crq;
 
 	adapter->ip_offload_ctrl_tok =
@@ -4577,7 +4577,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 				  adapter->netdev->hw_features);
 	} else if (!netdev_feature_equal(old_hw_features,
 					 adapter->netdev->hw_features)) {
-		netdev_features_t tmp;
+		__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 		netdev_feature_zero(&tmp);
 
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index abec49f6b541..4208d8fd3b2e 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2794,8 +2794,8 @@ static int e100_close(struct net_device *netdev)
 static int e100_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct nic *nic = netdev_priv(netdev);
-	netdev_features_t changed;
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 34536befc4ea..218b8a944645 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -804,7 +804,7 @@ static int e1000_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index a299f2789164..4e36331c76d9 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7328,7 +7328,7 @@ static int e1000_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index e3747f310c2e..dbefa249e560 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1540,7 +1540,7 @@ static const struct net_device_ops fm10k_netdev_ops = {
 
 struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 {
-	netdev_features_t hw_features;
+	__DECLARE_NETDEV_FEATURE_MASK(hw_features);
 	struct fm10k_intfc *interface;
 	struct net_device *dev;
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 5dddd63bde74..d4692a9f2a55 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13310,6 +13310,8 @@ static const struct net_device_ops i40e_netdev_ops = {
  **/
 static int i40e_config_netdev(struct i40e_vsi *vsi)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(hw_enc_features);
+	__DECLARE_NETDEV_FEATURE_MASK(hw_features);
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_hw *hw = &pf->hw;
 	struct i40e_netdev_priv *np;
@@ -13317,8 +13319,6 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	u8 broadcast[ETH_ALEN];
 	u8 mac_addr[ETH_ALEN];
 	int etherdev_size;
-	netdev_features_t hw_enc_features;
-	netdev_features_t hw_features;
 
 	etherdev_size = sizeof(struct i40e_netdev_priv);
 	netdev = alloc_etherdev_mq(etherdev_size, vsi->alloc_queue_pairs);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 9f6b6cabdca1..0897ee2740ee 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3354,7 +3354,7 @@ static int iavf_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, netdev->features, features);
 	/* Don't allow changing VLAN_RX flag when adapter is not capable
@@ -3505,10 +3505,10 @@ int iavf_process_config(struct iavf_adapter *adapter)
 {
 	struct virtchnl_vf_resource *vfres = adapter->vf_res;
 	int i, num_req_queues = adapter->num_req_queues;
+	__DECLARE_NETDEV_FEATURE_MASK(hw_enc_features);
 	struct net_device *netdev = adapter->netdev;
+	__DECLARE_NETDEV_FEATURE_MASK(hw_features);
 	struct iavf_vsi *vsi = &adapter->vsi;
-	netdev_features_t hw_enc_features;
-	netdev_features_t hw_features;
 
 	/* got VF config message back from PF, now we can parse it */
 	for (i = 0; i < vfres->num_vsis; i++) {
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 682b14bebdee..bb76ea65dbc1 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3057,11 +3057,11 @@ static void ice_set_ops(struct net_device *netdev)
  */
 static void ice_set_netdev_features(struct net_device *netdev)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(csumo_features);
+	__DECLARE_NETDEV_FEATURE_MASK(vlano_features);
+	__DECLARE_NETDEV_FEATURE_MASK(dflt_features);
+	__DECLARE_NETDEV_FEATURE_MASK(tso_features);
 	struct ice_pf *pf = ice_netdev_to_pf(netdev);
-	netdev_features_t csumo_features;
-	netdev_features_t vlano_features;
-	netdev_features_t dflt_features;
-	netdev_features_t tso_features;
 
 	if (ice_is_safe_mode(pf)) {
 		/* safe mode */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 1f764d4fbd14..e4582a4ec30e 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2450,7 +2450,7 @@ static int igb_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, netdev->features, features);
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f8b4d5cfa07b..d5d79ed550fe 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4938,7 +4938,7 @@ static int igc_set_features(struct net_device *netdev,
 			    netdev_features_t features)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, netdev->features, features);
 
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index c56ac31de3e1..4357e43666c5 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -309,7 +309,7 @@ static int
 ixgb_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 742947fad23c..fc31773b2631 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4901,7 +4901,7 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_hw *hw = &adapter->hw;
 	u32 fctrl, vmolr = IXGBE_VMOLR_BAM | IXGBE_VMOLR_AUPE;
-	netdev_features_t features;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	int count;
 
 	netdev_feature_copy(&features, netdev->features);
@@ -9731,7 +9731,7 @@ static int ixgbe_set_features(struct net_device *netdev,
 			      netdev_features_t features)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	bool need_reset = false;
 
 	netdev_feature_xor(&changed, netdev->features, features);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index a222a6923dcb..894b90a6ca49 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1265,7 +1265,7 @@ static int mvpp2_swf_bm_pool_init(struct mvpp2_port *port)
 static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 			      enum mvpp2_bm_pool_log_num new_long_pool)
 {
-	netdev_features_t csums;
+	__DECLARE_NETDEV_FEATURE_MASK(csums);
 
 	netdev_feature_zero(&csums);
 	netdev_feature_set_bits(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM, &csums);
@@ -5289,7 +5289,7 @@ static int mvpp2_set_features(struct net_device *dev,
 			      netdev_features_t features)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, dev->features, features);
 
@@ -6749,7 +6749,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	struct mvpp2_port *port;
 	struct mvpp2_port_pcpu *port_pcpu;
 	struct device_node *port_node = to_of_node(port_fwnode);
-	netdev_features_t features;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct net_device *dev;
 	struct phylink *phylink;
 	char *mac_from = "";
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index c3d187a57d35..77806bedb8dd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1842,7 +1842,7 @@ static int otx2_set_features(struct net_device *netdev,
 	bool ntuple = netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features);
 	bool tc = netdev_feature_test_bit(NETIF_F_HW_TC_BIT, features);
 	struct otx2_nic *pf = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 9b500cc46e9f..5d493afc2924 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -475,7 +475,7 @@ static int otx2vf_set_features(struct net_device *netdev,
 {
 	bool ntuple_enabled = netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, features);
 	struct otx2_nic *vf = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 	if (netdev_feature_test_bit(NETIF_F_NTUPLE_BIT, changed)) {
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index eee84e6b97f6..e5132f55e830 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4391,7 +4391,7 @@ static void sky2_fix_features(struct net_device *dev,
 static int sky2_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, dev->features, features);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4370b7241522..84a14756a171 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3333,7 +3333,7 @@ static int mlx5e_handle_feature(struct net_device *netdev,
 				u32 feature_bit,
 				mlx5e_feature_handler feature_handler)
 {
-	netdev_features_t changes;
+	__DECLARE_NETDEV_FEATURE_MASK(changes);
 	bool enable;
 	int err;
 
@@ -3356,7 +3356,7 @@ static int mlx5e_handle_feature(struct net_device *netdev,
 
 int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 {
-	netdev_features_t oper_features;
+	__DECLARE_NETDEV_FEATURE_MASK(oper_features);
 	int err = 0;
 
 	netdev_feature_copy(&oper_features, netdev->features);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index d5a8bc944947..620346d392b1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1109,7 +1109,7 @@ static int mlxsw_sp_handle_feature(struct net_device *dev,
 				   mlxsw_sp_feature_handler feature_handler)
 {
 	bool enable = netdev_feature_test_bit(feature_bit, wanted_features);
-	netdev_features_t changes;
+	__DECLARE_NETDEV_FEATURE_MASK(changes);
 	int err;
 
 	netdev_feature_xor(&changes, wanted_features, dev->features);
@@ -1133,7 +1133,7 @@ static int mlxsw_sp_handle_feature(struct net_device *dev,
 static int mlxsw_sp_set_features(struct net_device *dev,
 				 netdev_features_t features)
 {
-	netdev_features_t oper_features;
+	__DECLARE_NETDEV_FEATURE_MASK(oper_features);
 	int err = 0;
 
 	netdev_feature_copy(&oper_features, dev->features);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 844525fc558c..224dcf2d2a76 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -726,8 +726,8 @@ static int ocelot_set_features(struct net_device *dev,
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int port = priv->chip_port;
-	netdev_features_t changed;
 
 	netdev_feature_xor(&changed, dev->features, features);
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 542cb42f7ea5..b0a6b1211534 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2889,7 +2889,7 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 	struct sk_buff *segs, *curr, *next;
 	struct myri10ge_priv *mgp = netdev_priv(dev);
 	struct myri10ge_slice_state *ss;
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	netdev_tx_t status;
 
 	netdev_feature_copy(&tmp, dev->features);
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 0e3f500ab5bb..79165cf28549 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -6567,7 +6567,7 @@ static void s2io_ethtool_get_strings(struct net_device *dev,
 static int s2io_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct s2io_nic *sp = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, dev->features);
 
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 12d0508dbd7b..98184a71aad5 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -2643,7 +2643,7 @@ static void vxge_poll_vp_lockup(struct timer_list *t)
 static void vxge_fix_features(struct net_device *dev,
 			      netdev_features_t *features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, dev->features, *features);
 
@@ -2659,7 +2659,7 @@ static void vxge_fix_features(struct net_device *dev,
 static int vxge_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct vxgedev *vdev = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, dev->features, features);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 63aa017804a5..38d3066aaf7c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3519,7 +3519,7 @@ static int nfp_net_set_features(struct net_device *netdev,
 				netdev_features_t features)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	u32 new_ctrl;
 	int err;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index a9afa3bf8c56..42e211017384 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -235,9 +235,9 @@ static int nfp_repr_open(struct net_device *netdev)
 static void nfp_repr_fix_features(struct net_device *netdev,
 				  netdev_features_t *features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(lower_features);
+	__DECLARE_NETDEV_FEATURE_MASK(old_features);
 	struct nfp_repr *repr = netdev_priv(netdev);
-	netdev_features_t lower_features;
-	netdev_features_t old_features;
 	struct net_device *lower_dev;
 
 	lower_dev = repr->dst->u.port_info.lower_dev;
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 48b253e54888..0c408d420d79 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4953,9 +4953,9 @@ static void nv_vlan_mode(struct net_device *dev, netdev_features_t features)
 
 static int nv_set_features(struct net_device *dev, netdev_features_t features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
-	netdev_features_t changed;
 	int retval;
 
 	netdev_feature_xor(&changed, dev->features, features);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 49caca2ae753..7e25af846448 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2210,7 +2210,7 @@ static int pch_gbe_set_features(struct net_device *netdev,
 	netdev_features_t features)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 0d1604e85ed4..62178c7b9cc1 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1604,7 +1604,7 @@ static int ionic_set_nic_features(struct ionic_lif *lif,
 static int ionic_init_nic_features(struct ionic_lif *lif)
 {
 	struct net_device *netdev = lif->netdev;
-	netdev_features_t features;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	int err;
 
 	/* set up what we expect to support by default */
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index ada71452d454..dc5041c289eb 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -515,7 +515,7 @@ int qede_get_arfs_filter_count(struct qede_dev *edev);
 struct qede_reload_args {
 	void (*func)(struct qede_dev *edev, struct qede_reload_args *args);
 	union {
-		netdev_features_t features;
+		__DECLARE_NETDEV_FEATURE_MASK(features);
 		struct bpf_prog *new_prog;
 		u16 mtu;
 	} u;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 9fe5762b4eb6..684565231c25 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -922,7 +922,7 @@ void qede_fix_features(struct net_device *dev, netdev_features_t *features)
 int qede_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct qede_dev *edev = netdev_priv(dev);
-	netdev_features_t changes;
+	__DECLARE_NETDEV_FEATURE_MASK(changes);
 	bool need_reload = false;
 
 	netdev_feature_xor(&changes, features, dev->features);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index e7c3139af274..e0a38e3e4ec8 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -761,10 +761,10 @@ static struct qede_dev *qede_alloc_etherdev(struct qed_dev *cdev,
 
 static void qede_init_ndev(struct qede_dev *edev)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(hw_features);
 	struct net_device *ndev = edev->ndev;
 	struct pci_dev *pdev = edev->pdev;
 	bool udp_tunnel_enable = false;
-	netdev_features_t hw_features;
 
 	pci_set_drvdata(pdev, ndev);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 625fcf3ecb12..ee055e9e8eda 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1060,7 +1060,7 @@ static void qlcnic_process_flags(struct qlcnic_adapter *adapter,
 void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	if (qlcnic_82xx_check(adapter) &&
 	    (adapter->flags & QLCNIC_ESWITCH_ENABLED)) {
@@ -1087,7 +1087,7 @@ void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
 int qlcnic_set_features(struct net_device *netdev, netdev_features_t features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int hw_lro;
 
 	netdev_feature_xor(&changed, netdev->features, features);
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 71c403cb5e6c..53a83c12cb53 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -176,7 +176,7 @@ static int emac_set_features(struct net_device *netdev,
 			     netdev_features_t features)
 {
 	struct emac_adapter *adpt = netdev_priv(netdev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, features, netdev->features);
 
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 59b5a95bcaa4..bb8ed95c70ad 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -900,7 +900,7 @@ static struct net_device *rtl8139_init_board(struct pci_dev *pdev)
 static int rtl8139_set_features(struct net_device *dev, netdev_features_t features)
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	unsigned long flags;
 	void __iomem *ioaddr = tp->mmio_addr;
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 6f3574494a8e..e4fcda147396 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1923,7 +1923,7 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 static int ravb_set_features_rx_csum(struct net_device *ndev,
 				     netdev_features_t features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, ndev->features, features);
 
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index a3cfc6283a86..a8fc9e42feca 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2934,7 +2934,7 @@ static int sh_eth_set_features(struct net_device *ndev,
 			       netdev_features_t features)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, ndev->features, features);
 
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index b70ce380fa61..b8b6e3164ad5 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1775,7 +1775,7 @@ static int sxgbe_set_features(struct net_device *dev,
 			      netdev_features_t features)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, dev->features, features);
 
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 981c01acef51..426a56a6f48e 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1305,7 +1305,7 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features;
+	__DECLARE_NETDEV_FEATURE_MASK(hw_enc_features);
 	int rc;
 
 	netdev_feature_zero(&hw_enc_features);
@@ -1358,7 +1358,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 					&hw_enc_features);
 	/* add encapsulated TSO features */
 	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
-		netdev_features_t encap_tso_features;
+		__DECLARE_NETDEV_FEATURE_MASK(encap_tso_features);
 
 		netdev_feature_zero(&encap_tso_features);
 		netdev_feature_set_bits(NETIF_F_GSO_UDP_TUNNEL |
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 5127e03050d1..e16cf6bc6ba1 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -184,7 +184,7 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 
 	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
 		struct net_device *net_dev = efx->net_dev;
-		netdev_features_t tso;
+		__DECLARE_NETDEV_FEATURE_MASK(tso);
 
 		netdev_feature_zero(&tso);
 		netdev_feature_set_bits(NETIF_F_TSO | NETIF_F_TSO6 |
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 30cbfdbc100e..7c909e8bfdde 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -990,8 +990,8 @@ static int efx_pci_probe_main(struct efx_nic *efx)
 static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	int rc = efx_pci_probe_main(efx);
-	netdev_features_t tmp;
 
 	if (rc)
 		return rc;
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 01353739bae0..8eac2466e33b 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -211,7 +211,7 @@ void efx_set_rx_mode(struct net_device *net_dev)
 int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
@@ -366,8 +366,8 @@ void efx_start_monitor(struct efx_nic *efx)
  */
 static void efx_start_datapath(struct efx_nic *efx)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(old_features);
 	bool old_rx_scatter = efx->rx_scatter;
-	netdev_features_t old_features;
 	size_t rx_buf_len;
 
 	/* Calculate the rx buffer allocation parameters required to
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index a6301c8dd9cb..f4bde5771ba2 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -592,8 +592,8 @@ static int ef4_probe_channels(struct ef4_nic *efx)
  */
 static void ef4_start_datapath(struct ef4_nic *efx)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(old_features);
 	bool old_rx_scatter = efx->rx_scatter;
-	netdev_features_t old_features;
 	struct ef4_tx_queue *tx_queue;
 	struct ef4_rx_queue *rx_queue;
 	struct ef4_channel *channel;
@@ -2196,7 +2196,7 @@ static void ef4_set_rx_mode(struct net_device *net_dev)
 static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index 942c539c76c2..4b66f69f516b 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -849,7 +849,7 @@ struct ef4_nic {
 	bool port_initialized;
 	struct net_device *net_dev;
 
-	netdev_features_t fixed_features;
+	__DECLARE_NETDEV_FEATURE_MASK(fixed_features);
 
 	struct ef4_buffer stats_buffer;
 	u64 rx_nodesc_drops_total;
diff --git a/drivers/net/ethernet/sfc/mcdi_filters.c b/drivers/net/ethernet/sfc/mcdi_filters.c
index 2a9a692da100..c19950974b62 100644
--- a/drivers/net/ethernet/sfc/mcdi_filters.c
+++ b/drivers/net/ethernet/sfc/mcdi_filters.c
@@ -1297,8 +1297,8 @@ efx_mcdi_filter_table_probe_matches(struct efx_nic *efx,
 int efx_mcdi_filter_table_probe(struct efx_nic *efx, bool multicast_chaining)
 {
 	struct net_device *net_dev = efx->net_dev;
+	__DECLARE_NETDEV_FEATURE_MASK(supported);
 	struct efx_mcdi_filter_table *table;
-	netdev_features_t supported;
 	int rc;
 
 	if (!efx_rwsem_assert_write_locked(&efx->filter_sem))
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 0c47ba740445..ca29a3786ea2 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1052,7 +1052,7 @@ struct efx_nic {
 	bool port_initialized;
 	struct net_device *net_dev;
 
-	netdev_features_t fixed_features;
+	__DECLARE_NETDEV_FEATURE_MASK(fixed_features);
 
 	u16 num_mac_stats;
 	struct efx_buffer stats_buffer;
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index 44f4bffb5f24..534c10e353d4 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1224,7 +1224,7 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 	struct net_device *dev = VNET_PORT_TO_NET_DEVICE(port);
 	struct vio_dring_state *dr = &port->vio.drings[VIO_DRIVER_TX_RING];
 	struct sk_buff *segs, *curr, *next;
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	int maclen, datalen;
 	int status;
 	int gso_size, gso_type, gso_segs;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac.h b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
index 8598aaf3ec99..a0f69cc235fc 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac.h
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
@@ -606,7 +606,7 @@ struct xlgmac_pdata {
 
 	/* Netdev related settings */
 	unsigned char mac_addr[ETH_ALEN];
-	netdev_features_t netdev_features;
+	__DECLARE_NETDEV_FEATURE_MASK(netdev_features);
 	struct napi_struct napi;
 
 	/* Filtering support */
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 22875a7ef1ff..84b3bce287cb 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1944,8 +1944,8 @@ static int netvsc_set_features(struct net_device *ndev,
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
 	struct net_device *vf_netdev = rtnl_dereference(ndevctx->vf_netdev);
+	__DECLARE_NETDEV_FEATURE_MASK(change);
 	struct ndis_offload_params offloads;
-	netdev_features_t change;
 	int ret = 0;
 
 	if (!nvdev || nvdev->destroy)
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 115ebe0b970a..f0206cd90678 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1348,7 +1348,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	struct ndis_offload hwcaps;
 	struct ndis_offload_params offloads;
 	unsigned int gso_max_size = GSO_MAX_SIZE;
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	int ret;
 
 	/* Find HW offload capabilities */
diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
index 3837c897832e..84cd8f1a5131 100644
--- a/drivers/net/ipvlan/ipvlan.h
+++ b/drivers/net/ipvlan/ipvlan.h
@@ -67,7 +67,7 @@ struct ipvl_dev {
 	struct list_head	addrs;
 	struct ipvl_pcpu_stats	__percpu *pcpu_stats;
 	DECLARE_BITMAP(mac_filters, IPVLAN_MAC_FILTER_SIZE);
-	netdev_features_t	sfeatures;
+	__DECLARE_NETDEV_FEATURE_MASK(sfeatures);
 	u32			msg_enable;
 	spinlock_t		addrs_lock;
 };
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 84ad786ae18d..e77e4dc2aa60 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -242,7 +242,7 @@ static void ipvlan_fix_features(struct net_device *dev,
 				netdev_features_t *features)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
 	netdev_feature_fill(&tmp);
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 5526d54c0a14..8693decea5e8 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3478,7 +3478,7 @@ static void macsec_fix_features(struct net_device *dev,
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	if (macsec_is_offloaded(macsec)) {
 		netdev_feature_copy(features, real_dev->features);
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9ac38e22ccfc..d373b4557206 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1074,9 +1074,10 @@ static int macvlan_ethtool_get_ts_info(struct net_device *dev,
 static void macvlan_fix_features(struct net_device *dev,
 				 netdev_features_t *features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(lowerdev_features);
 	struct macvlan_dev *vlan = netdev_priv(dev);
-	netdev_features_t lowerdev_features;
-	netdev_features_t mask, tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(mask);
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	netdev_feature_copy(&lowerdev_features, vlan->lowerdev->features);
 	netdev_feature_set_bits(NETIF_F_ALL_FOR_ALL, features);
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 704e691530f7..16375fb5c958 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -384,10 +384,10 @@ static void net_failover_compute_features(struct net_device *dev)
 					IFF_XMIT_DST_RELEASE_PERM;
 	struct net_failover_info *nfo_info = netdev_priv(dev);
 	struct net_device *primary_dev, *standby_dev;
-	netdev_features_t vlan_features;
-	netdev_features_t enc_features;
-	netdev_features_t vlan_mask;
-	netdev_features_t enc_mask;
+	__DECLARE_NETDEV_FEATURE_MASK(vlan_features);
+	__DECLARE_NETDEV_FEATURE_MASK(enc_features);
+	__DECLARE_NETDEV_FEATURE_MASK(vlan_mask);
+	__DECLARE_NETDEV_FEATURE_MASK(enc_mask);
 
 	netdev_feature_zero(&vlan_features);
 	netdev_feature_set_bits(FAILOVER_VLAN_FEATURES & NETIF_F_ALL_FOR_ALL,
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 03158fa9476c..49da4d101517 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -317,11 +317,11 @@ EXPORT_SYMBOL_GPL(tap_del_queues);
 
 rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct sk_buff *skb = *pskb;
 	struct net_device *dev = skb->dev;
 	struct tap_dev *tap;
 	struct tap_queue *q;
-	netdev_features_t features;
 
 	netdev_feature_zero(&features);
 	netdev_feature_set_bits(TAP_FEATURES, &features);
@@ -923,9 +923,9 @@ static int tap_ioctl_set_queue(struct file *file, unsigned int flags)
 
 static int set_offload(struct tap_queue *q, unsigned long arg)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(feature_mask);
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct tap_dev *tap;
-	netdev_features_t features;
-	netdev_features_t feature_mask;
 
 	tap = rtnl_dereference(q->tap);
 	if (!tap)
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 207771e0d1c8..79171c8c7379 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -988,10 +988,10 @@ static void __team_compute_features(struct team *team)
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
-	netdev_features_t vlan_features;
-	netdev_features_t enc_features;
-	netdev_features_t mask_vlan;
-	netdev_features_t mask_enc;
+	__DECLARE_NETDEV_FEATURE_MASK(vlan_features);
+	__DECLARE_NETDEV_FEATURE_MASK(enc_features);
+	__DECLARE_NETDEV_FEATURE_MASK(mask_vlan);
+	__DECLARE_NETDEV_FEATURE_MASK(mask_enc);
 
 	netdev_feature_zero(&vlan_features);
 	netdev_feature_set_bits(TEAM_VLAN_FEATURES & NETIF_F_ALL_FOR_ALL,
@@ -2010,7 +2010,7 @@ static void team_fix_features(struct net_device *dev,
 {
 	struct team_port *port;
 	struct team *team = netdev_priv(dev);
-	netdev_features_t mask;
+	__DECLARE_NETDEV_FEATURE_MASK(mask);
 
 	netdev_feature_copy(&mask, *features);
 	netdev_feature_clear_bits(NETIF_F_ONE_FOR_ALL, features);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 9e9cbafc870b..66c566291b16 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -183,7 +183,7 @@ struct tun_struct {
 	kgid_t			group;
 
 	struct net_device	*dev;
-	netdev_features_t	set_features;
+	__DECLARE_NETDEV_FEATURE_MASK(set_features);
 #define TUN_USER_FEATURES (NETIF_F_HW_CSUM|NETIF_F_TSO_ECN|NETIF_F_TSO| \
 			  NETIF_F_TSO6)
 
@@ -1083,7 +1083,7 @@ static void tun_net_fix_features(struct net_device *dev,
 				 netdev_features_t *features)
 {
 	struct tun_struct *tun = netdev_priv(dev);
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	netdev_feature_and(&tmp, *features, tun->set_features);
 	netdev_feature_clear_bits(TUN_USER_FEATURES, features);
@@ -2802,7 +2802,7 @@ static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
  * privs required. */
 static int set_offload(struct tun_struct *tun, unsigned long arg)
 {
-	netdev_features_t features;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 
 	netdev_feature_zero(&features);
 
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 1363f64f4c86..45305d74692e 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -567,7 +567,7 @@ static int aqc111_set_features(struct net_device *net,
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct aqc111_data *aqc111_data = dev->driver_priv;
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	u16 reg16 = 0;
 	u8 reg8 = 0;
 
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 0099d55f9c90..b11b4bba443e 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -952,7 +952,7 @@ ax88179_set_features(struct net_device *net, netdev_features_t features)
 {
 	u8 tmp;
 	struct usbnet *dev = netdev_priv(net);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 
 	netdev_feature_xor(&changed, net->features, features);
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 31fb92ae23c2..61d2175c63d7 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2092,9 +2092,9 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 				  struct sk_buff_head *list)
 {
 	if (skb_shinfo(skb)->gso_size) {
+		__DECLARE_NETDEV_FEATURE_MASK(features);
 		struct sk_buff *segs, *seg, *next;
 		struct sk_buff_head seg_list;
-		netdev_features_t features;
 
 		netdev_feature_copy(&features, tp->netdev->features);
 		netdev_feature_clear_bits(NETIF_F_SG | NETIF_F_IPV6_CSUM |
@@ -3233,8 +3233,8 @@ static void rtl_rx_vlan_en(struct r8152 *tp, bool enable)
 static int rtl8152_set_features(struct net_device *dev,
 				netdev_features_t features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	struct r8152 *tp = netdev_priv(dev);
-	netdev_features_t changed;
 	int ret;
 
 	ret = usb_autopm_get_interface(tp->intf);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 39bfa024861c..6603dcaf4c84 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1407,7 +1407,7 @@ static int veth_set_features(struct net_device *dev,
 			     netdev_features_t features)
 {
 	struct veth_priv *priv = netdev_priv(dev);
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err;
 
 	netdev_feature_xor(&changed, features, dev->features);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5307bc4f3c99..96dc985a3fb0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3154,7 +3154,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 		netdev_feature_set_bit(NETIF_F_GSO_ROBUST_BIT, &dev->features);
 
 		if (gso) {
-			netdev_features_t tmp;
+			__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 			netdev_feature_copy(&tmp, dev->hw_features);
 			netdev_feature_and_bits(NETIF_F_ALL_TSO, &tmp);
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 05e422b48774..e9035e80d5ae 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -340,7 +340,7 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	u64 tun_offload_mask = NETIF_F_GSO_UDP_TUNNEL |
 				NETIF_F_GSO_UDP_TUNNEL_CSUM;
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	unsigned long flags;
 	u8 udp_tun_enabled;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index cfe0fcb1a0ba..aaf8c15a99ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -836,8 +836,8 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 	unsigned int num_subframes, tcp_payload_len, subf_len, max_amsdu_len;
+	__DECLARE_NETDEV_FEATURE_MASK(netdev_flags);
 	u16 snap_ip_tcp, pad;
-	netdev_features_t netdev_flags;
 	u8 tid;
 
 	netdev_feature_zero(&netdev_flags);
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 00c30e6dbe7c..1c5b58ebe844 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -679,7 +679,7 @@ static netdev_tx_t xennet_start_xmit(struct sk_buff *skb, struct net_device *dev
 	struct netfront_queue *queue = NULL;
 	struct xennet_gnttab_make_txreq info = { };
 	unsigned int num_queues = dev->real_num_tx_queues;
-	netdev_features_t features;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	u16 queue_index;
 	struct sk_buff *nskb;
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 21e4a356c717..82c4ae2ae064 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6833,8 +6833,8 @@ static int qeth_set_ipa_rx_csum(struct qeth_card *card, bool on)
  */
 void qeth_enable_hw_features(struct net_device *dev)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct qeth_card *card = dev->ml_priv;
-	netdev_features_t features;
 
 	netdev_feature_copy(&features, dev->features);
 	/* force-off any feature that might need an IPA sequence.
@@ -6860,8 +6860,8 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 					   netdev_features_t changed,
 					   netdev_features_t actual)
 {
-	netdev_features_t ipv6_features;
-	netdev_features_t ipv4_features;
+	__DECLARE_NETDEV_FEATURE_MASK(ipv6_features);
+	__DECLARE_NETDEV_FEATURE_MASK(ipv4_features);
 
 	netdev_features_zero(&ipv6_features);
 	netdev_features_zero(&ipv4_features);
@@ -6975,7 +6975,7 @@ void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
 	/* Traffic with local next-hop is not eligible for some offloads: */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
 	    READ_ONCE(card->options.isolation) != ISOLATION_MODE_FWD) {
-		netdev_features_t restricted;
+		__DECLARE_NETDEV_FEATURE_MASK(restricted);
 
 		netdev_feature_zero(&restricted);
 		if (skb_is_gso(skb) && !netif_needs_gso(skb, *features))
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index efbeb0a1a601..61b7cb6d1396 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2276,7 +2276,7 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 static int qlge_set_features(struct net_device *ndev,
 			     netdev_features_t features)
 {
-	netdev_features_t changed;
+	__DECLARE_NETDEV_FEATURE_MASK(changed);
 	int err;
 
 	netdev_feature_xor(&changed, ndev->features, features);
diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index 10c94a3936ca..101be703a4db 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -26,7 +26,7 @@ struct macvlan_dev {
 
 	DECLARE_BITMAP(mc_filter, MACVLAN_MC_FILTER_SZ);
 
-	netdev_features_t	set_features;
+	__DECLARE_NETDEV_FEATURE_MASK(set_features);
 	enum macvlan_mode	mode;
 	u16			flags;
 	unsigned int		macaddr_count;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 915a187cfabd..e81070409f39 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -40,7 +40,7 @@ struct tap_dev {
 	struct list_head	queue_list;
 	int			numvtaps;
 	int			numqueues;
-	netdev_features_t	tap_features;
+	__DECLARE_NETDEV_FEATURE_MASK(tap_features);
 	int			minor;
 
 	void (*update_features)(struct tap_dev *tap, netdev_features_t features);
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index b3fa05c88eef..b5013b3e3e48 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -103,6 +103,9 @@ enum {
 
 #define NETDEV_FEATURE_DWORDS	DIV_ROUND_UP(NETDEV_FEATURE_COUNT, 64)
 
+#define __DECLARE_NETDEV_FEATURE_MASK(name)	\
+	netdev_features_t name
+
 /* copy'n'paste compression ;) */
 #define __NETIF_F_BIT(bit)	((netdev_features_t)1 << (bit))
 #define __NETIF_F(name)		__NETIF_F_BIT(NETIF_F_##name##_BIT)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 56e642a72997..4d36b747165c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1995,13 +1995,13 @@ struct net_device {
 	unsigned short		needed_headroom;
 	unsigned short		needed_tailroom;
 
-	netdev_features_t	features;
-	netdev_features_t	hw_features;
-	netdev_features_t	wanted_features;
-	netdev_features_t	vlan_features;
-	netdev_features_t	hw_enc_features;
-	netdev_features_t	mpls_features;
-	netdev_features_t	gso_partial_features;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
+	__DECLARE_NETDEV_FEATURE_MASK(hw_features);
+	__DECLARE_NETDEV_FEATURE_MASK(wanted_features);
+	__DECLARE_NETDEV_FEATURE_MASK(vlan_features);
+	__DECLARE_NETDEV_FEATURE_MASK(hw_enc_features);
+	__DECLARE_NETDEV_FEATURE_MASK(mpls_features);
+	__DECLARE_NETDEV_FEATURE_MASK(gso_partial_features);
 
 	unsigned int		min_mtu;
 	unsigned int		max_mtu;
@@ -5055,7 +5055,7 @@ void netdev_increment_features(netdev_features_t *ret, netdev_features_t all,
 static inline void netdev_add_tso_features(netdev_features_t *features,
 					   netdev_features_t mask)
 {
-	netdev_features_t one;
+	__DECLARE_NETDEV_FEATURE_MASK(one);
 
 	netdev_feature_zero(&one);
 	netdev_feature_set_bits(NETIF_F_ALL_TSO, &one);
@@ -5075,7 +5075,7 @@ void netif_skb_features(struct sk_buff *skb, netdev_features_t *features);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 {
-	netdev_features_t feature;
+	__DECLARE_NETDEV_FEATURE_MASK(feature);
 
 	/* check flags correspondence */
 	BUILD_BUG_ON(SKB_GSO_TCPV4   != (NETIF_F_TSO >> NETIF_F_GSO_SHIFT));
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index af0fc13cea34..683c56f8b8c3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2624,7 +2624,7 @@ struct ieee80211_hw {
 		int units_pos;
 		s16 accuracy;
 	} radiotap_timestamp;
-	netdev_features_t netdev_features;
+	__DECLARE_NETDEV_FEATURE_MASK(netdev_features);
 	u8 uapsd_queues;
 	u8 uapsd_max_sp_len;
 	u8 n_cipher_schemes;
diff --git a/include/net/sock.h b/include/net/sock.h
index f7ba322c63bd..6107aa6731e6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -451,9 +451,9 @@ struct sock {
 	unsigned long		sk_pacing_rate; /* bytes per second */
 	unsigned long		sk_max_pacing_rate;
 	struct page_frag	sk_frag;
-	netdev_features_t	sk_route_caps;
-	netdev_features_t	sk_route_nocaps;
-	netdev_features_t	sk_route_forced_caps;
+	__DECLARE_NETDEV_FEATURE_MASK(sk_route_caps);
+	__DECLARE_NETDEV_FEATURE_MASK(sk_route_nocaps);
+	__DECLARE_NETDEV_FEATURE_MASK(sk_route_forced_caps);
 	int			sk_gso_type;
 	unsigned int		sk_gso_max_size;
 	gfp_t			sk_allocation;
@@ -2056,7 +2056,7 @@ static inline void sk_nocaps_add(struct sock *sk, netdev_features_t flags)
 
 static inline void sk_nocaps_add_gso(struct sock *sk)
 {
-	netdev_features_t gso_flags;
+	__DECLARE_NETDEV_FEATURE_MASK(gso_flags);
 
 	netdev_feature_zero(&gso_flags);
 	netdev_feature_set_bits(NETIF_F_GSO_MASK, &gso_flags);
diff --git a/include/net/udp.h b/include/net/udp.h
index 3855b9775cbf..42681e7e2eba 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -481,7 +481,7 @@ void udpv6_encap_enable(void);
 static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 					      struct sk_buff *skb, bool ipv4)
 {
-	netdev_features_t features;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct sk_buff *segs;
 
 	netdev_feature_zero(&features);
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index a010612cf27b..4062917584de 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -640,9 +640,9 @@ static void vlan_dev_fix_features(struct net_device *dev,
 				  netdev_features_t *features)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
-	netdev_features_t lower_features;
-	netdev_features_t old_features;
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(lower_features);
+	__DECLARE_NETDEV_FEATURE_MASK(old_features);
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	netdev_feature_copy(&tmp, real_dev->vlan_features);
 	netdev_feature_set_bit(NETIF_F_RXCSUM_BIT, &tmp);
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index c0a71fd6f772..d210031df22a 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -534,8 +534,8 @@ static void br_set_gso_limits(struct net_bridge *br)
  */
 void br_features_recompute(struct net_bridge *br, netdev_features_t *features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(mask);
 	struct net_bridge_port *p;
-	netdev_features_t mask;
 
 	if (list_empty(&br->port_list))
 		return;
diff --git a/net/core/dev.c b/net/core/dev.c
index 17a93ec301b6..d0f04bdcc00e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3183,7 +3183,7 @@ static u16 skb_tx_hash(const struct net_device *dev,
 
 static void skb_warn_bad_offload(const struct sk_buff *skb)
 {
-	static const netdev_features_t null_features;
+	static __DECLARE_NETDEV_FEATURE_MASK(null_features);
 	struct net_device *dev = skb->dev;
 	const char *name = "";
 
@@ -3382,7 +3382,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 	 * work.
 	 */
 	if (netdev_feature_test_bit(NETIF_F_GSO_PARTIAL_BIT, features)) {
-		netdev_features_t partial_features;
+		__DECLARE_NETDEV_FEATURE_MASK(partial_features);
 		struct net_device *dev = skb->dev;
 
 		netdev_feature_and(&partial_features, dev->features,
@@ -3552,7 +3552,7 @@ void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
 		netdev_feature_and(features, *features, dev->hw_enc_features);
 
 	if (skb_vlan_tagged(skb)) {
-		netdev_features_t tmp;
+		__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 		netdev_feature_copy(&tmp, dev->vlan_features);
 		netdev_feature_set_bits(NETIF_F_HW_VLAN_CTAG_TX_BIT |
@@ -3649,7 +3649,7 @@ EXPORT_SYMBOL(skb_csum_hwoffload_help);
 
 static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device *dev, bool *again)
 {
-	netdev_features_t features;
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 
 	netif_skb_features(skb, &features);
 	skb = validate_xmit_vlan(skb, features);
@@ -9803,7 +9803,7 @@ static void netdev_sync_upper_features(struct net_device *lower,
 				       struct net_device *upper,
 				       netdev_features_t *features)
 {
-	netdev_features_t upper_disables;
+	__DECLARE_NETDEV_FEATURE_MASK(upper_disables);
 	int feature_bit;
 
 	netdev_feature_zero(&upper_disables);
@@ -9823,7 +9823,7 @@ static void netdev_sync_upper_features(struct net_device *lower,
 static void netdev_sync_lower_features(struct net_device *upper,
 	struct net_device *lower, netdev_features_t features)
 {
-	netdev_features_t upper_disables;
+	__DECLARE_NETDEV_FEATURE_MASK(upper_disables);
 	int feature_bit;
 
 	netdev_feature_zero(&upper_disables);
@@ -9953,8 +9953,8 @@ static void netdev_fix_features(struct net_device *dev,
 
 int __netdev_update_features(struct net_device *dev)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct net_device *upper, *lower;
-	netdev_features_t features;
 	struct list_head *iter;
 	int err = -1;
 
@@ -10001,7 +10001,7 @@ int __netdev_update_features(struct net_device *dev)
 		netdev_sync_lower_features(dev, lower, features);
 
 	if (!err) {
-		netdev_features_t diff;
+		__DECLARE_NETDEV_FEATURE_MASK(diff);
 
 		netdev_feature_xor(&diff, features, dev->features);
 
@@ -11373,7 +11373,7 @@ static int dev_cpu_dead(unsigned int oldcpu)
 void netdev_increment_features(netdev_features_t *ret, netdev_features_t all,
 			       netdev_features_t one, netdev_features_t mask)
 {
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	if (netdev_feature_test_bit(NETIF_F_HW_CSUM_BIT, mask))
 		netdev_feature_set_bits(NETIF_F_CSUM_MASK, &mask);
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index d2fc92b89a5f..83cfc0c5a200 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -74,8 +74,8 @@ static netdev_tx_t netpoll_start_xmit(struct sk_buff *skb,
 				      struct net_device *dev,
 				      struct netdev_queue *txq)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	netdev_tx_t status = NETDEV_TX_OK;
-	netdev_features_t features;
 
 	netif_skb_features(skb, &features);
 
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 1c9f4df273bd..93c6238c7ade 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -38,8 +38,8 @@ static int features_prepare_data(const struct ethnl_req_info *req_base,
 				 struct genl_info *info)
 {
 	struct features_reply_data *data = FEATURES_REPDATA(reply_base);
+	__DECLARE_NETDEV_FEATURE_MASK(all_features);
 	struct net_device *dev = reply_base->dev;
-	netdev_features_t all_features;
 
 	ethnl_features_to_bitmap32(data->hw, dev->hw_features);
 	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 661b75dee9fd..0b2e98e97f58 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -232,8 +232,8 @@ static void ethtool_get_feature_mask(u32 eth_cmd, netdev_features_t *mask)
 static int ethtool_get_one_feature(struct net_device *dev,
 	char __user *useraddr, u32 ethcmd)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(mask);
 	struct ethtool_value edata;
-	netdev_features_t mask;
 
 	ethtool_get_feature_mask(ethcmd, &mask);
 	edata.cmd = ethcmd;
@@ -247,8 +247,8 @@ static int ethtool_get_one_feature(struct net_device *dev,
 static int ethtool_set_one_feature(struct net_device *dev,
 	void __user *useraddr, u32 ethcmd)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(mask);
 	struct ethtool_value edata;
-	netdev_features_t mask;
 
 	if (copy_from_user(&edata, useraddr, sizeof(edata)))
 		return -EFAULT;
@@ -2710,9 +2710,9 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 {
 	struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
+	__DECLARE_NETDEV_FEATURE_MASK(old_features);
 	u32 ethcmd, sub_cmd;
 	int rc;
-	netdev_features_t old_features;
 
 	if (!dev)
 		return -ENODEV;
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index b7ba16bdb8e0..7a4c5e79eb5f 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -180,7 +180,7 @@ static int hsr_dev_close(struct net_device *dev)
 static void hsr_features_recompute(struct hsr_priv *hsr,
 				   netdev_features_t *features)
 {
-	netdev_features_t mask;
+	__DECLARE_NETDEV_FEATURE_MASK(mask);
 	struct hsr_port *port;
 
 	netdev_feature_copy(&mask, *features);
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index f7e77a9176d6..2c0b7a4e5489 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -190,7 +190,7 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 	struct ip_esp_hdr *esph;
 	struct crypto_aead *aead;
 	struct xfrm_offload *xo = xfrm_offload(skb);
-	netdev_features_t esp_features;
+	__DECLARE_NETDEV_FEATURE_MASK(esp_features);
 	struct sec_path *sp;
 
 	if (!xo)
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 60a693c7ae79..8a065badcf2d 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -233,8 +233,8 @@ static int ip_finish_output2(struct net *net, struct sock *sk, struct sk_buff *s
 static int ip_finish_output_gso(struct net *net, struct sock *sk,
 				struct sk_buff *skb, unsigned int mtu)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct sk_buff *segs, *nskb;
-	netdev_features_t features;
 	int ret = 0;
 
 	/* common case: seglen is <= mtu
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 4bf0a0d382f6..2f4b7489f1a2 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -55,6 +55,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 				netdev_features_t features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	unsigned int sum_truesize = 0;
 	struct tcphdr *th;
 	unsigned int thlen;
@@ -65,7 +66,6 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	struct sk_buff *gso_skb = skb;
 	__sum16 newcheck;
 	bool ooo_okay, copy_destructor;
-	netdev_features_t tmp;
 
 	th = tcp_hdr(skb);
 	thlen = th->doff * 4;
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 5c2e0da49804..3ce9360071f4 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -229,7 +229,7 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 	struct ip_esp_hdr *esph;
 	struct crypto_aead *aead;
 	struct xfrm_offload *xo = xfrm_offload(skb);
-	netdev_features_t esp_features;
+	__DECLARE_NETDEV_FEATURE_MASK(esp_features);
 	struct sec_path *sp;
 
 	if (!xo)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index c7e060064686..72acb065abc0 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -138,8 +138,8 @@ static int
 ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 				    struct sk_buff *skb, unsigned int mtu)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct sk_buff *segs, *nskb;
-	netdev_features_t features;
 	int ret = 0;
 
 	/* Please see corresponding comment in ip_finish_output_gso
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7e7431144727..fa5fc30db294 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2034,7 +2034,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ieee80211_setup_sdata(sdata, type);
 
 	if (ndev) {
-		netdev_features_t tmp;
+		__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 		ndev->ieee80211_ptr->use_4addr = params->use_4addr;
 		if (type == NL80211_IFTYPE_STATION)
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 06142de8f8db..0cc11097f3ae 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -911,7 +911,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	int channels, max_bitrates;
 	bool supp_ht, supp_vht, supp_he;
 	struct cfg80211_chan_def dflt_chandef = {};
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 
 	if (ieee80211_hw_check(hw, QUEUE_CONTROL) &&
 	    (local->hw.offchannel_tx_hw_queue == IEEE80211_INVAL_HW_QUEUE ||
diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
index 65994c68e126..8d733c4427bd 100644
--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -19,9 +19,9 @@
 static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(mpls_features);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	u16 mac_offset = skb->mac_header;
-	netdev_features_t mpls_features;
 	u16 mac_len = skb->mac_len;
 	__be16 mpls_protocol;
 	unsigned int mpls_hlen;
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index dfb69428c6b2..aad26e4cd2cb 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -318,9 +318,9 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 			     uint32_t cutlen)
 {
 	unsigned int gso_type = skb_shinfo(skb)->gso_type;
+	__DECLARE_NETDEV_FEATURE_MASK(feature);
 	struct sw_flow_key later_key;
 	struct sk_buff *segs, *nskb;
-	netdev_features_t feature;
 	int err;
 
 	BUILD_BUG_ON(sizeof(*OVS_CB(skb)) > SKB_GSO_CB_OFFSET);
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 5d783cd72290..fc45f242381e 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1739,8 +1739,8 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		b->max_skblen = len;
 
 	if (skb_is_gso(skb) && q->rate_flags & CAKE_FLAG_SPLIT_GSO) {
+		__DECLARE_NETDEV_FEATURE_MASK(features);
 		struct sk_buff *segs, *nskb;
-		netdev_features_t features;
 		unsigned int slen = 0, numsegs = 0;
 
 		netif_skb_features(skb, &features);
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 4aabeb206777..313591a9c879 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -412,8 +412,8 @@ static void tfifo_enqueue(struct sk_buff *nskb, struct Qdisc *sch)
 static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
 				     struct sk_buff **to_free)
 {
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct sk_buff *segs;
-	netdev_features_t features;
 
 	netif_skb_features(skb, &features);
 	netdev_feature_clear_bits(NETIF_F_GSO_MASK, &features);
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index e42deaf723b1..2ff999208324 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -453,7 +453,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	 */
 	if (skb_is_gso(skb) && !FULL_OFFLOAD_IS_ENABLED(q->flags)) {
 		unsigned int slen = 0, numsegs = 0, len = qdisc_pkt_len(skb);
-		netdev_features_t features;
+		__DECLARE_NETDEV_FEATURE_MASK(features);
 		struct sk_buff *segs, *nskb;
 		int ret;
 
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 8ac786f467a0..6b6b347da52f 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -191,8 +191,8 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 		       struct sk_buff **to_free)
 {
 	struct tbf_sched_data *q = qdisc_priv(sch);
+	__DECLARE_NETDEV_FEATURE_MASK(features);
 	struct sk_buff *segs, *nskb;
-	netdev_features_t features;
 	unsigned int len = 0, prev_len = qdisc_pkt_len(skb);
 	int ret, nb;
 
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index c49464811614..10d569bd9ef8 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -39,7 +39,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 					netdev_features_t features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
-	netdev_features_t tmp;
+	__DECLARE_NETDEV_FEATURE_MASK(tmp);
 	struct sctphdr *sh;
 
 	if (!skb_is_gso_sctp(skb))
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 7c167060d959..e3eeef8bfe89 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -105,8 +105,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	struct softnet_data *sd;
 	struct sk_buff *skb2, *nskb, *pskb = NULL;
 	struct xfrm_offload *xo = xfrm_offload(skb);
+	__DECLARE_NETDEV_FEATURE_MASK(esp_features);
 	struct net_device *dev = skb->dev;
-	netdev_features_t esp_features;
 	struct sec_path *sp;
 
 	if (!xo || (xo->flags & XFRM_XMIT))
-- 
2.33.0

