Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D9C5BBD24
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiIRJvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiIRJuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:21 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C4717A92
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:58 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MVjc12JHYz14QY5;
        Sun, 18 Sep 2022 17:45:53 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 54/55] treewide: use netdev_features_copy helpers
Date:   Sun, 18 Sep 2022 09:43:35 +0000
Message-ID: <20220918094336.28958-55-shenjian15@huawei.com>
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

Replace operation 'f1 = f2' with netdev_features_copy helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |  2 +-
 drivers/infiniband/hw/hfi1/vnic_main.c        |  4 +--
 drivers/net/bonding/bond_main.c               | 27 +++++++++++--------
 drivers/net/ethernet/3com/typhoon.c           |  2 +-
 drivers/net/ethernet/aeroflex/greth.c         |  2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  2 +-
 drivers/net/ethernet/apm/xgene-v2/main.c      |  2 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  4 +--
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  2 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  2 +-
 drivers/net/ethernet/broadcom/bgmac.c         |  4 +--
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |  8 +++---
 drivers/net/ethernet/cadence/macb_main.c      |  6 +++--
 .../net/ethernet/cavium/liquidio/lio_main.c   |  8 +++---
 .../ethernet/cavium/liquidio/lio_vf_main.c    |  8 +++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  4 +--
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  6 ++---
 drivers/net/ethernet/cortina/gemini.c         |  2 +-
 drivers/net/ethernet/engleder/tsnep_main.c    |  2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |  2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 +-
 drivers/net/ethernet/freescale/fec_main.c     |  2 +-
 .../ethernet/fungible/funeth/funeth_main.c    |  4 +--
 drivers/net/ethernet/google/gve/gve_main.c    |  7 ++---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |  3 ++-
 .../net/ethernet/huawei/hinic/hinic_main.c    |  4 +--
 drivers/net/ethernet/ibm/ibmvnic.c            |  3 ++-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  2 +-
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  4 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  4 +--
 drivers/net/ethernet/intel/ice/ice_main.c     |  4 +--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  3 ++-
 drivers/net/ethernet/intel/igb/igb_main.c     |  2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c     |  4 +--
 drivers/net/ethernet/intel/igc/igc_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  5 ++--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |  4 +--
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  4 +--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 14 +++++-----
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  2 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  4 +--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  6 ++---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  3 ++-
 drivers/net/ethernet/microchip/lan743x_main.c |  2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c |  2 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  7 ++---
 .../ethernet/netronome/nfp/nfp_net_common.c   |  6 ++---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c | 10 +++----
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  2 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  6 ++---
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |  2 +-
 drivers/net/ethernet/realtek/8139too.c        |  2 +-
 drivers/net/ethernet/renesas/ravb_main.c      |  4 +--
 drivers/net/ethernet/renesas/sh_eth.c         |  2 +-
 drivers/net/ethernet/sfc/ef10.c               |  2 +-
 drivers/net/ethernet/sfc/efx_common.c         |  3 ++-
 drivers/net/ethernet/sfc/falcon/efx.c         |  3 ++-
 drivers/net/ethernet/sfc/siena/efx_common.c   |  3 ++-
 drivers/net/ethernet/socionext/netsec.c       |  2 +-
 drivers/net/ethernet/sun/ldmvsw.c             |  2 +-
 drivers/net/ethernet/sun/sungem.c             |  2 +-
 drivers/net/ethernet/sun/sunvnet.c            |  4 +--
 drivers/net/ethernet/sun/sunvnet_common.c     |  3 ++-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  6 ++---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  2 +-
 drivers/net/ethernet/ti/netcp_core.c          |  2 +-
 drivers/net/hyperv/netvsc_drv.c               |  6 ++---
 drivers/net/ipvlan/ipvlan_main.c              |  6 ++---
 drivers/net/loopback.c                        |  4 +--
 drivers/net/macsec.c                          |  2 +-
 drivers/net/macvlan.c                         |  5 ++--
 drivers/net/net_failover.c                    |  5 ++--
 drivers/net/ntb_netdev.c                      |  2 +-
 drivers/net/tap.c                             |  4 +--
 drivers/net/team/team.c                       | 11 ++++----
 drivers/net/thunderbolt.c                     |  4 +--
 drivers/net/tun.c                             |  6 ++---
 drivers/net/usb/lan78xx.c                     |  2 +-
 drivers/net/usb/r8152.c                       |  3 ++-
 drivers/net/veth.c                            |  6 ++---
 drivers/net/virtio_net.c                      |  2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c             |  2 +-
 drivers/net/vrf.c                             |  4 +--
 drivers/net/vxlan/vxlan_core.c                |  2 +-
 drivers/net/wireguard/device.c                |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c  |  7 ++---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  2 +-
 drivers/net/xen-netback/interface.c           |  2 +-
 drivers/s390/block/dasd_devmap.c              |  2 +-
 drivers/s390/net/qeth_core_main.c             |  2 +-
 drivers/staging/qlge/qlge_main.c              |  4 +--
 net/8021q/vlan_dev.c                          |  2 +-
 net/bridge/br_device.c                        |  6 ++---
 net/core/dev.c                                | 16 ++++++-----
 net/dsa/slave.c                               |  4 +--
 net/ethtool/ioctl.c                           |  4 +--
 net/hsr/hsr_device.c                          |  4 +--
 net/ipv4/ipip.c                               |  2 +-
 net/ipv6/ip6_tunnel.c                         |  2 +-
 net/ipv6/sit.c                                |  2 +-
 net/mac80211/main.c                           |  2 +-
 net/openvswitch/vport-internal_dev.c          |  6 ++---
 net/xfrm/xfrm_interface.c                     |  2 +-
 112 files changed, 231 insertions(+), 206 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 7b4b9bed8979..e0c8b02d0051 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1630,7 +1630,7 @@ static void vector_eth_configure(
 	netdev_active_features_zero(dev);
 	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
 				       NETIF_F_FRAGLIST_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 	INIT_WORK(&vp->reset_tx, vector_reset_tx);
 
 	timer_setup(&vp->tl, vector_timer_expire, 0);
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index 949a414d4d7d..a1347daa648f 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -591,8 +591,8 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
 	netdev_active_features_zero(netdev);
 	netdev_active_features_set_set(netdev, NETIF_F_HIGHDMA_BIT,
 				       NETIF_F_SG_BIT);
-	netdev->hw_features = netdev->features;
-	netdev->vlan_features = netdev->features;
+	netdev_hw_features_copy(netdev, netdev->features);
+	netdev_vlan_features_copy(netdev, netdev->features);
 	netdev->watchdog_timeo = msecs_to_jiffies(HFI_TX_TIMEOUT_MS);
 	netdev->netdev_ops = &hfi1_netdev_ops;
 	mutex_init(&vinfo->lock);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index cd7c8d81ba0c..1b941cac6b41 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1433,12 +1433,12 @@ static void bond_compute_features(struct bonding *bond)
 {
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
-	netdev_features_t vlan_features = BOND_VLAN_FEATURES;
-	netdev_features_t enc_features  = BOND_ENC_FEATURES;
+	netdev_features_t vlan_features;
+	netdev_features_t enc_features;
 #ifdef CONFIG_XFRM_OFFLOAD
-	netdev_features_t xfrm_features  = BOND_XFRM_FEATURES;
+	netdev_features_t xfrm_features;
 #endif /* CONFIG_XFRM_OFFLOAD */
-	netdev_features_t mpls_features  = BOND_MPLS_FEATURES;
+	netdev_features_t mpls_features;
 	struct net_device *bond_dev = bond->dev;
 	struct list_head *iter;
 	struct slave *slave;
@@ -1448,6 +1448,10 @@ static void bond_compute_features(struct bonding *bond)
 
 	if (!bond_has_slaves(bond))
 		goto done;
+	netdev_features_copy(vlan_features, BOND_VLAN_FEATURES);
+	netdev_features_copy(enc_features, BOND_ENC_FEATURES);
+	netdev_features_copy(xfrm_features, BOND_XFRM_FEATURES);
+	netdev_features_copy(mpls_features, BOND_MPLS_FEATURES);
 	netdev_features_mask(vlan_features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_mask(mpls_features, NETIF_F_ALL_FOR_ALL);
 
@@ -1480,14 +1484,14 @@ static void bond_compute_features(struct bonding *bond)
 	bond_dev->hard_header_len = max_hard_header_len;
 
 done:
-	bond_dev->vlan_features = vlan_features;
+	netdev_vlan_features_copy(bond_dev, vlan_features);
 	netdev_hw_enc_features_or(bond_dev, enc_features,
 				  NETIF_F_GSO_ENCAP_ALL);
 	netdev_hw_enc_features_set(bond_dev, netdev_tx_vlan_features);
 #ifdef CONFIG_XFRM_OFFLOAD
 	netdev_hw_enc_features_set(bond_dev, xfrm_features);
 #endif /* CONFIG_XFRM_OFFLOAD */
-	bond_dev->mpls_features = mpls_features;
+	netdev_mpls_features_copy(bond_dev, mpls_features);
 	netif_set_tso_max_segs(bond_dev, tso_max_segs);
 	netif_set_tso_max_size(bond_dev, tso_max_size);
 
@@ -2317,7 +2321,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	struct slave *slave, *oldcurrent;
 	struct sockaddr_storage ss;
 	int old_flags = bond_dev->flags;
-	netdev_features_t old_features = bond_dev->features;
+	netdev_features_t old_features;
 
 	/* slave is not a slave or master is not master of this slave */
 	if (!(slave_dev->flags & IFF_SLAVE) ||
@@ -2420,6 +2424,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 		call_netdevice_notifiers(NETDEV_RELEASE, bond->dev);
 	}
 
+	netdev_features_copy(old_features, bond_dev->features);
 	bond_compute_features(bond);
 	if (!netdev_active_feature_test(bond_dev, NETIF_F_VLAN_CHALLENGED_BIT) &&
 	    netdev_feature_test(NETIF_F_VLAN_CHALLENGED_BIT, old_features))
@@ -5770,7 +5775,7 @@ void bond_setup(struct net_device *bond_dev)
 	/* Don't allow bond devices to change network namespaces. */
 	netdev_active_feature_add(bond_dev, NETIF_F_NETNS_LOCAL_BIT);
 
-	bond_dev->hw_features = BOND_VLAN_FEATURES;
+	netdev_hw_features_copy(bond_dev, BOND_VLAN_FEATURES);
 	netdev_hw_feature_add(bond_dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev_hw_feature_add(bond_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
@@ -6216,16 +6221,16 @@ static int bond_check_params(struct bond_params *params)
 
 static void __init bond_netdev_features_init(void)
 {
-	bond_vlan_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(bond_vlan_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(bond_vlan_features, NETIF_F_HW_CSUM_BIT,
 				NETIF_F_SG_BIT, NETIF_F_FRAGLIST_BIT,
 				NETIF_F_HIGHDMA_BIT, NETIF_F_LRO_BIT);
 
-	bond_enc_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(bond_enc_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(bond_enc_features, NETIF_F_HW_CSUM_BIT,
 				NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT);
 
-	bond_mpls_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(bond_mpls_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(bond_mpls_features,  NETIF_F_HW_CSUM_BIT,
 				NETIF_F_SG_BIT);
 }
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 694400423285..d42a53748f40 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2481,7 +2481,7 @@ typhoon_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
 				   NETIF_F_TSO_BIT,
 				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 	netdev_active_features_set_set(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT,
 				       NETIF_F_RXCSUM_BIT);
 
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 0e424ac95a65..0a8aa16d0ce1 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1488,7 +1488,7 @@ static int greth_of_probe(struct platform_device *ofdev)
 		netdev_hw_features_set_set(dev, NETIF_F_SG_BIT,
 					   NETIF_F_IP_CSUM_BIT,
 					   NETIF_F_RXCSUM_BIT);
-		dev->features = dev->hw_features;
+		netdev_active_features_copy(dev, dev->hw_features);
 		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 		greth_netdev_ops.ndo_start_xmit = greth_start_xmit_gbit;
 	}
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 5d287e960a2a..47beaab0d963 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4044,7 +4044,7 @@ static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_RX_L4_IPV6_CSUM_MASK)
 		netdev_feature_add(NETIF_F_RXCSUM_BIT, dev_features);
 
-	netdev->features = dev_features;
+	netdev_active_features_copy(netdev, dev_features);
 	netdev_active_features_set_set(netdev, NETIF_F_SG_BIT,
 				       NETIF_F_RXHASH_BIT, NETIF_F_HIGHDMA_BIT);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index 79a4a8c1471e..1e717fda866f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -377,7 +377,7 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 				     NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
 
 	netdev_active_features_set(netdev, netdev->hw_features);
-	pdata->netdev_features = netdev->features;
+	netdev_features_copy(pdata->netdev_features, netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->min_mtu = 0;
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index c33d9f810953..aa1df1785c55 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -654,7 +654,7 @@ static int xge_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	ndev->hw_features = ndev->features;
+	netdev_hw_features_copy(ndev, ndev->features);
 	xge_set_ethtool_ops(ndev);
 
 	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 2f03cdebb00d..e817344ef385 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -2069,7 +2069,7 @@ static int xgene_enet_probe(struct platform_device *pdev)
 					       NETIF_F_RXCSUM_BIT);
 		spin_lock_init(&pdata->mss_lock);
 	}
-	ndev->hw_features = ndev->features;
+	netdev_hw_features_copy(ndev, ndev->features);
 
 	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(64));
 	if (ret) {
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index bc9649ea37e9..09f5f2b37359 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -145,7 +145,7 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 		cfg->link_irq_vec = 0;
 
 	cfg->link_speed_msk &= cfg->aq_hw_caps->link_speed_msk;
-	cfg->features = *cfg->aq_hw_caps->hw_features;
+	netdev_features_copy(cfg->features, *cfg->aq_hw_caps->hw_features);
 	cfg->is_vlan_rx_strip =
 		netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, cfg->features);
 	cfg->is_vlan_tx_insert =
@@ -375,7 +375,7 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	struct aq_nic_cfg_s *aq_nic_cfg = &self->aq_nic_cfg;
 
 	netdev_hw_features_set(self->ndev, *aq_hw_caps->hw_features);
-	self->ndev->features = *aq_hw_caps->hw_features;
+	netdev_active_features_copy(self->ndev, *aq_hw_caps->hw_features);
 	netdev_vlan_features_set_set(self->ndev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_RXCSUM_BIT, NETIF_F_RXHASH_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_LRO_BIT,
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 4ce52ea0833f..2cadd62e034d 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2634,7 +2634,7 @@ static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_HW_VLAN_CTAG_RX_BIT, NETIF_F_TSO_BIT,
 				   NETIF_F_TSO6_BIT);
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	return 0;
 }
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 29245ecea761..422fe8c2f47e 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2274,7 +2274,7 @@ static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_TSO_BIT,
 				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	/* not enabled by default */
 	netdev_hw_features_set_set(netdev, NETIF_F_RXALL_BIT,
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 2c902c0b4ffe..b36c8c4a68c5 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1540,8 +1540,8 @@ int bgmac_enet_probe(struct bgmac *bgmac)
 	netdev_active_features_set_set(net_dev, NETIF_F_SG_BIT,
 				       NETIF_F_IP_CSUM_BIT,
 				       NETIF_F_IPV6_CSUM_BIT);
-	net_dev->hw_features = net_dev->features;
-	net_dev->vlan_features = net_dev->features;
+	netdev_hw_features_copy(net_dev, net_dev->features);
+	netdev_vlan_features_copy(net_dev, net_dev->features);
 
 	/* Omit FCS from max MTU size */
 	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 7ea525d1dc11..f9cbce85f083 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8593,7 +8593,7 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_hw_features_set_set(dev, NETIF_F_IPV6_CSUM_BIT,
 					   NETIF_F_TSO6_BIT);
 
-	dev->vlan_features = dev->hw_features;
+	netdev_vlan_features_copy(dev, dev->hw_features);
 	netdev_hw_features_set(dev, netdev_ctag_vlan_offload_features);
 	netdev_active_features_set(dev, dev->hw_features);
 	dev->priv_flags |= IFF_UNICAST_FLT;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e62d5f9cc211..516623df4f2b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13627,7 +13627,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_gso_partial_features_zero(dev);
 	netdev_gso_partial_features_set_set(dev, NETIF_F_GSO_GRE_CSUM_BIT,
 					    NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
-	dev->vlan_features = dev->hw_features;
+	netdev_vlan_features_copy(dev, dev->hw_features);
 	netdev_vlan_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_RX_STRIP)
 		netdev_hw_features_set(dev, BNXT_HW_FEATURE_VLAN_ALL_RX);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index beba73d73f3f..c5a064629fad 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -468,10 +468,10 @@ static void bnxt_vf_rep_netdev_init(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 	/* Just inherit all the featues of the parent PF as the VF-R
 	 * uses the RX/TX rings of the parent PF
 	 */
-	dev->hw_features = pf_dev->hw_features;
-	dev->gso_partial_features = pf_dev->gso_partial_features;
-	dev->vlan_features = pf_dev->vlan_features;
-	dev->hw_enc_features = pf_dev->hw_enc_features;
+	netdev_hw_features_copy(dev, pf_dev->hw_features);
+	netdev_gso_partial_features_copy(dev, pf_dev->gso_partial_features);
+	netdev_vlan_features_copy(dev, pf_dev->vlan_features);
+	netdev_hw_enc_features_copy(dev, pf_dev->hw_enc_features);
 	netdev_active_features_set(dev, pf_dev->features);
 	bnxt_vf_rep_eth_addr_gen(bp->pf.mac_addr, vf_rep->vf_idx,
 				 dev->perm_addr);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 9b31b70309c7..22a03aa03f36 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3765,8 +3765,10 @@ static int macb_set_features(struct net_device *netdev,
 static void macb_restore_features(struct macb *bp)
 {
 	struct net_device *netdev = bp->dev;
-	netdev_features_t features = netdev->features;
 	struct ethtool_rx_fs_item *item;
+	netdev_features_t features;
+
+	netdev_features_copy(features, netdev->features);
 
 	/* TX checksum offload */
 	macb_set_txcsum_feature(bp, &features);
@@ -4067,7 +4069,7 @@ static int macb_init(struct platform_device *pdev)
 					   NETIF_F_RXCSUM_BIT);
 	if (bp->caps & MACB_CAPS_SG_DISABLED)
 		netdev_hw_feature_del(dev, NETIF_F_SG_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 
 	/* Check RX Flow Filters support.
 	 * Max Rx flows set by availability of screeners & compare regs:
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7e4c749aa8b0..9bc430aea6af 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3585,7 +3585,7 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					NETIF_F_RXCSUM_BIT, NETIF_F_TSO_BIT,
 					NETIF_F_TSO6_BIT, NETIF_F_LRO_BIT);
 
-		netdev->hw_enc_features = lio->enc_dev_capability;
+		netdev_hw_enc_features_copy(netdev, lio->enc_dev_capability);
 		netdev_hw_enc_feature_del(netdev, NETIF_F_LRO_BIT);
 
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
@@ -3593,15 +3593,15 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT,
 				   lio->dev_capability);
 
-		netdev->vlan_features = lio->dev_capability;
+		netdev_vlan_features_copy(netdev, lio->dev_capability);
 		/* Add any unchangeable hw features */
 		netdev_features_set(lio->dev_capability,
 				    netdev_ctag_vlan_features);
 
-		netdev->features = lio->dev_capability;
+		netdev_active_features_copy(netdev, lio->dev_capability);
 		netdev_active_feature_del(netdev, NETIF_F_LRO_BIT);
 
-		netdev->hw_features = lio->dev_capability;
+		netdev_hw_features_copy(netdev, lio->dev_capability);
 		/*HW_VLAN_RX and HW_VLAN_FILTER is always on*/
 		netdev_hw_feature_del(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index cd0f6a7de629..65bbd2b38e15 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2116,19 +2116,19 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 					NETIF_F_RXCSUM_BIT, NETIF_F_TSO_BIT,
 					NETIF_F_TSO6_BIT, NETIF_F_LRO_BIT);
 
-		netdev->hw_enc_features = lio->enc_dev_capability;
+		netdev_hw_enc_features_copy(netdev, lio->enc_dev_capability);
 		netdev_hw_enc_feature_del(netdev, NETIF_F_LRO_BIT);
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
-		netdev->vlan_features = lio->dev_capability;
+		netdev_vlan_features_copy(netdev, lio->dev_capability);
 		/* Add any unchangeable hw features */
 		netdev_features_set(lio->dev_capability,
 				    netdev_ctag_vlan_features);
 
-		netdev->features = lio->dev_capability;
+		netdev_active_features_copy(netdev, lio->dev_capability);
 		netdev_active_feature_del(netdev, NETIF_F_LRO_BIT);
 
-		netdev->hw_features = lio->dev_capability;
+		netdev_hw_features_copy(netdev, lio->dev_capability);
 		netdev_hw_feature_del(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 		/* MTU range: 68 - 16000 */
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 8d578c120641..d8703796721e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6816,7 +6816,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_features_set_set(tso_features, NETIF_F_TSO_BIT,
 					NETIF_F_TSO6_BIT, NETIF_F_TSO_ECN_BIT,
 					NETIF_F_GSO_UDP_L4_BIT);
-		netdev->hw_features = tso_features;
+		netdev_hw_features_copy(netdev, tso_features);
 		netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT,
 					   NETIF_F_IP_CSUM_BIT,
 					   NETIF_F_IPV6_CSUM_BIT,
@@ -6848,7 +6848,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 
 		netdev_active_features_set(netdev, netdev->hw_features);
-		vlan_features = tso_features;
+		netdev_features_copy(vlan_features, tso_features);
 		netdev_features_set_set(vlan_features, NETIF_F_SG_BIT,
 					NETIF_F_IP_CSUM_BIT, NETIF_F_GRO_BIT,
 					NETIF_F_IPV6_CSUM_BIT,
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index a2e8135490d2..be3a1cba938f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3066,16 +3066,16 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 		netdev_features_zero(tso_features);
 		netdev_features_set_set(tso_features, NETIF_F_TSO_BIT,
 					NETIF_F_TSO6_BIT, NETIF_F_TSO_ECN_BIT);
-		netdev->hw_features = tso_features;
+		netdev_hw_features_copy(netdev, tso_features);
 		netdev_hw_features_set_set(netdev, NETIF_F_SG_BIT,
 					   NETIF_F_GRO_BIT, NETIF_F_IP_CSUM_BIT,
 					   NETIF_F_IPV6_CSUM_BIT,
 					   NETIF_F_RXCSUM_BIT,
 					   NETIF_F_HW_VLAN_CTAG_TX_BIT,
 					   NETIF_F_HW_VLAN_CTAG_RX_BIT);
-		netdev->features = netdev->hw_features;
+		netdev_active_features_copy(netdev, netdev->hw_features);
 		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
-		vlan_features = tso_features;
+		netdev_features_copy(vlan_features, tso_features);
 		netdev_features_set_set(vlan_features, NETIF_F_SG_BIT,
 					NETIF_F_IP_CSUM_BIT, NETIF_F_GRO_BIT,
 					NETIF_F_IPV6_CSUM_BIT,
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index f66ef5bf8d94..65e0d496f69a 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2460,7 +2460,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	spin_lock_init(&port->config_lock);
 	gmac_clear_hw_stats(netdev);
 
-	netdev->hw_features = GMAC_OFFLOAD_FEATURES;
+	netdev_hw_features_copy(netdev, GMAC_OFFLOAD_FEATURES);
 	netdev_active_features_set(netdev, GMAC_OFFLOAD_FEATURES);
 	netdev_active_feature_add(netdev, NETIF_F_GRO_BIT);
 	/* We can handle jumbo frames up to 10236 bytes so, let's accept
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 5a86b671ba3d..fcf062e2d570 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1285,7 +1285,7 @@ static int tsnep_probe(struct platform_device *pdev)
 	netdev->ethtool_ops = &tsnep_ethtool_ops;
 	netdev_active_features_zero(netdev);
 	netdev_active_feature_add(netdev, NETIF_F_SG_BIT);
-	netdev->hw_features = netdev->features;
+	netdev_hw_features_copy(netdev, netdev->features);
 	netdev_hw_feature_add(netdev, NETIF_F_LOOPBACK_BIT);
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 546002f864d0..6957a9cabd85 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -243,7 +243,7 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	net_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
 
 	netdev_active_features_set(net_dev, net_dev->hw_features);
-	net_dev->vlan_features = net_dev->features;
+	netdev_vlan_features_copy(net_dev, net_dev->features);
 
 	if (is_valid_ether_addr(mac_addr)) {
 		memcpy(net_dev->perm_addr, mac_addr, net_dev->addr_len);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fdd0bda2c461..cb89136e8c39 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4398,7 +4398,7 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 				       NETIF_F_HIGHDMA_BIT, NETIF_F_LLTX_BIT,
 				       NETIF_F_HW_TC_BIT, NETIF_F_TSO_BIT);
 	net_dev->gso_max_segs = DPAA2_ETH_ENQUEUE_MAX_FDS;
-	net_dev->hw_features = net_dev->features;
+	netdev_hw_features_copy(net_dev, net_dev->features);
 
 	if (priv->dpni_attrs.vlan_filter_entries)
 		netdev_hw_feature_add(net_dev,
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 90094816a6c8..c18b45114aff 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3656,7 +3656,7 @@ static int fec_enet_init(struct net_device *ndev)
 		fep->rx_align = 0x3f;
 	}
 
-	ndev->hw_features = ndev->features;
+	netdev_hw_features_copy(ndev, ndev->features);
 
 	fec_restart(ndev);
 
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index ea5863db61ed..0b68fa37c1a6 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1786,8 +1786,8 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 	netdev_vlan_features_and(netdev, netdev->features, vlan_feat);
-	netdev->mpls_features = netdev->vlan_features;
-	netdev->hw_enc_features = netdev->hw_features;
+	netdev_mpls_features_copy(netdev, netdev->vlan_features);
+	netdev_hw_enc_features_copy(netdev, netdev->hw_features);
 
 	netdev->min_mtu = ETH_MIN_MTU;
 	netdev->max_mtu = FUN_MAX_MTU;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 31d749796b49..148cd458494e 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1181,10 +1181,11 @@ static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static int gve_set_features(struct net_device *netdev,
 			    const netdev_features_t *features)
 {
-	const netdev_features_t orig_features = netdev->features;
 	struct gve_priv *priv = netdev_priv(netdev);
+	netdev_features_t orig_features;
 	int err;
 
+	netdev_features_copy(orig_features, netdev->features);
 	if (netdev_active_feature_test(netdev, NETIF_F_LRO_BIT) !=
 	    netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 		netdev_active_feature_change(netdev, NETIF_F_LRO_BIT);
@@ -1209,7 +1210,7 @@ static int gve_set_features(struct net_device *netdev,
 	return 0;
 err:
 	/* Reverts the change on error. */
-	netdev->features = orig_features;
+	netdev_active_features_copy(netdev, orig_features);
 	netif_err(priv, drv, netdev,
 		  "Set features failed! !!! DISABLING ALL QUEUES !!!\n");
 	return err;
@@ -1595,7 +1596,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				   NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
 				   NETIF_F_TSO6_BIT, NETIF_F_TSO_ECN_BIT,
 				   NETIF_F_RXCSUM_BIT, NETIF_F_RXHASH_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 	dev->watchdog_timeo = 5 * HZ;
 	dev->min_mtu = ETH_MIN_MTU;
 	netif_carrier_off(dev);
diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index e5ce1d261b03..7718f11307fc 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -663,7 +663,7 @@ static int gve_rx_complete_skb(struct gve_rx_ring *rx, struct napi_struct *napi,
 int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 {
 	struct napi_struct *napi = &block->napi;
-	netdev_features_t feat = napi->dev->features;
+	netdev_features_t feat;
 
 	struct gve_rx_ring *rx = block->rx;
 	struct gve_rx_compl_queue_dqo *complq = &rx->dqo.complq;
@@ -672,6 +672,7 @@ int gve_rx_poll_dqo(struct gve_notify_block *block, int budget)
 	u64 bytes = 0;
 	int err;
 
+	netdev_features_copy(feat, napi->dev->features);
 	while (work_done < budget) {
 		struct gve_rx_compl_desc_dqo *compl_desc =
 			&complq->desc_ring[complq->head];
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index ecb3d345ff2e..f1a500bf7c21 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -927,9 +927,9 @@ static void netdev_features_init(struct net_device *netdev)
 				   NETIF_F_GSO_UDP_TUNNEL_BIT,
 				   NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
-	netdev->vlan_features = netdev->hw_features;
+	netdev_vlan_features_copy(netdev, netdev->hw_features);
 
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	netdev_hw_enc_features_zero(netdev);
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index afef066f0647..e87e709c5952 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4864,7 +4864,8 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 
 	netdev_hw_features_zero(old_hw_features);
 	if (adapter->state != VNIC_PROBING) {
-		old_hw_features = adapter->netdev->hw_features;
+		netdev_features_copy(old_hw_features,
+				     adapter->netdev->hw_features);
 		netdev_hw_features_zero(adapter->netdev);
 	}
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 95fe8df96d5a..5bd08f884817 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7536,7 +7536,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				       NETIF_F_HW_CSUM_BIT);
 
 	/* Set user-changeable features (subset of all device features) */
-	netdev->hw_features = netdev->features;
+	netdev_hw_features_copy(netdev, netdev->features);
 	netdev_hw_feature_add(netdev, NETIF_F_RXFCS_BIT);
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 	netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2162a2d7f3f5..1efe6fdb7c33 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1585,7 +1585,7 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 	}
 
 	/* all features defined to this point should be changeable */
-	hw_features = dev->features;
+	netdev_features_copy(hw_features, dev->features);
 
 	/* allow user to enable L2 forwarding acceleration */
 	netdev_feature_add(NETIF_F_HW_L2FW_DOFFLOAD_BIT, hw_features);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 86e63041f2cc..eeaf336a4465 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13645,7 +13645,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	np = netdev_priv(netdev);
 	np->vsi = vsi;
 
-	hw_enc_features = NETIF_F_SOFT_FEATURES;
+	netdev_features_copy(hw_enc_features, NETIF_F_SOFT_FEATURES);
 	netdev_features_set_set(hw_enc_features, NETIF_F_SG_BIT,
 				NETIF_F_HW_CSUM_BIT, NETIF_F_HIGHDMA_BIT,
 				NETIF_F_TSO_BIT, NETIF_F_TSO_ECN_BIT,
@@ -13679,7 +13679,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 				NETIF_F_GSO_IPXIP6_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
-	netdev->gso_partial_features = gso_partial_features;
+	netdev_gso_partial_features_copy(netdev, gso_partial_features);
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev_active_features_set(netdev, gso_partial_features);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 456bb30ce086..f0040e7dbc92 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4747,7 +4747,7 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	netdev_features_t hw_enc_features;
 	netdev_features_t hw_features;
 
-	hw_enc_features = NETIF_F_SOFT_FEATURES;
+	netdev_features_copy(hw_enc_features, NETIF_F_SOFT_FEATURES);
 	netdev_features_set_set(hw_enc_features,
 				NETIF_F_SG_BIT,
 				NETIF_F_IP_CSUM_BIT,
@@ -4790,7 +4790,7 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	/* Write features and hw_features separately to avoid polluting
 	 * with, or dropping, features that are set when we registered.
 	 */
-	hw_features = hw_enc_features;
+	netdev_features_copy(hw_features, hw_enc_features);
 
 	/* get HW VLAN features that can be toggled */
 	iavf_get_netdev_vlan_hw_features(adapter, &hw_vlan_features);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d4f77da1ddd7..f1006743b35a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3330,7 +3330,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 		netdev_active_features_zero(netdev);
 		netdev_active_features_set_set(netdev, NETIF_F_SG_BIT,
 					       NETIF_F_HIGHDMA_BIT);
-		netdev->hw_features = netdev->features;
+		netdev_hw_features_copy(netdev, netdev->features);
 		return;
 	}
 
@@ -3348,7 +3348,7 @@ static void ice_set_netdev_features(struct net_device *netdev)
 				NETIF_F_SCTP_CRC_BIT,
 				NETIF_F_IPV6_CSUM_BIT);
 
-	vlano_features = netdev_ctag_vlan_features;
+	netdev_features_copy(vlano_features, netdev_ctag_vlan_features);
 
 	/* Enable CTAG/STAG filtering by default in Double VLAN Mode (DVM) */
 	if (is_dvm_ena)
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
index 7bade466c0e5..ebaf2acfb089 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.c
@@ -209,9 +209,10 @@ ice_process_skb_fields(struct ice_rx_ring *rx_ring,
 void
 ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag)
 {
-	netdev_features_t features = rx_ring->netdev->features;
 	bool non_zero_vlan = !!(vlan_tag & VLAN_VID_MASK);
+	netdev_features_t features;
 
+	netdev_features_copy(features, rx_ring->netdev->features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && non_zero_vlan)
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tag);
 	else if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, features) && non_zero_vlan)
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 87c55e4c7649..4b7bcd9c3d94 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3300,7 +3300,7 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_IPXIP6_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
-	netdev->gso_partial_features = gso_partial_features;
+	netdev_gso_partial_features_copy(netdev, gso_partial_features);
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev_active_features_set(netdev, gso_partial_features);
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index a812b3fae712..5533be0b57cf 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2782,11 +2782,11 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
-	netdev->gso_partial_features = gso_partial_features;
+	netdev_gso_partial_features_copy(netdev, gso_partial_features);
 	netdev_hw_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev_hw_features_set(netdev, gso_partial_features);
 
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev_vlan_features_set(netdev, netdev->features);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index c0305237a620..68444500a476 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6362,7 +6362,7 @@ static int igc_probe(struct pci_dev *pdev,
 				NETIF_F_GSO_IPXIP6_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
-	netdev->gso_partial_features = gso_partial_features;
+	netdev_gso_partial_features_copy(netdev, gso_partial_features);
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev_active_features_set(netdev, gso_partial_features);
 
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index d8d88bb41c38..87a4ff84ce42 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -437,7 +437,7 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				   NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				   NETIF_F_HW_VLAN_CTAG_RX_BIT);
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7faec783bfcc..590902329395 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4904,7 +4904,7 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	struct ixgbe_hw *hw = &adapter->hw;
 	u32 fctrl, vmolr = IXGBE_VMOLR_BAM | IXGBE_VMOLR_AUPE;
-	netdev_features_t features = netdev->features;
+	netdev_features_t features;
 	int count;
 
 	/* Check for Promiscuous and All Multicast modes */
@@ -4916,6 +4916,7 @@ void ixgbe_set_rx_mode(struct net_device *netdev)
 	fctrl |= IXGBE_FCTRL_DPF; /* discard pause frames when FC enabled */
 	fctrl |= IXGBE_FCTRL_PMCF;
 
+	netdev_features_copy(features, netdev->features);
 	/* clear the bits we are changing the status of */
 	fctrl &= ~(IXGBE_FCTRL_UPE | IXGBE_FCTRL_MPE);
 	if (netdev->flags & IFF_PROMISC) {
@@ -10985,7 +10986,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
-	netdev->gso_partial_features = gso_partial_features;
+	netdev_gso_partial_features_copy(netdev, gso_partial_features);
 	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev_active_features_set(netdev, gso_partial_features);
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 5078d723251f..5b2c501428ef 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4616,11 +4616,11 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				NETIF_F_GSO_IPXIP6_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_BIT,
 				NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
-	netdev->gso_partial_features = gso_partial_features;
+	netdev_gso_partial_features_copy(netdev, gso_partial_features);
 	netdev_hw_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev_hw_features_set(netdev, gso_partial_features);
 
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev_vlan_features_set(netdev, netdev->features);
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 4bf7b2fbf728..9d0c52b6eef0 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3205,10 +3205,10 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	netdev_active_features_zero(dev);
 	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
 				       NETIF_F_TSO_BIT);
-	dev->vlan_features = dev->features;
+	netdev_vlan_features_copy(dev, dev->features);
 
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
-	dev->hw_features = dev->features;
+	netdev_hw_features_copy(dev, dev->features);
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
 	netif_set_tso_max_segs(dev, MV643XX_MAX_TSO_SEGS);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index cc6699715171..0d18fb6e8a56 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1266,7 +1266,7 @@ static int mvpp2_swf_bm_pool_init(struct mvpp2_port *port)
 static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 			      enum mvpp2_bm_pool_log_num new_long_pool)
 {
-	const netdev_features_t csums = netdev_ip_csum_features;
+	const netdev_features_t *csums = &netdev_ip_csum_features;
 
 	/* Update L4 checksum when jumbo enable/disable on port.
 	 * Only port 0 supports hardware checksum offload due to
@@ -1275,11 +1275,11 @@ static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 	 * has 7 bits, so the maximum L3 offset is 128.
 	 */
 	if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
-		netdev_active_features_clear(port->dev, csums);
-		netdev_hw_features_clear(port->dev, csums);
+		netdev_active_features_clear(port->dev, *csums);
+		netdev_hw_features_clear(port->dev, *csums);
 	} else {
-		netdev_active_features_set(port->dev, csums);
-		netdev_hw_features_set(port->dev, csums);
+		netdev_active_features_set(port->dev, *csums);
+		netdev_hw_features_set(port->dev, *csums);
 	}
 }
 
@@ -1353,7 +1353,7 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 
 out_set:
 	dev->mtu = mtu;
-	dev->wanted_features = dev->features;
+	netdev_wanted_features_copy(dev, dev->features);
 
 	netdev_update_features(dev);
 	return 0;
@@ -6852,7 +6852,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	netdev_features_zero(features);
 	netdev_features_set_set(features, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
 				NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT);
-	dev->features = features;
+	netdev_active_features_copy(dev, features);
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	netdev_hw_features_set(dev, features);
 	netdev_hw_features_set_set(dev, NETIF_F_RXCSUM_BIT, NETIF_F_GRO_BIT,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 0acfc16a08ae..026b44b195ed 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -644,7 +644,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 				   NETIF_F_RXHASH_BIT, NETIF_F_SG_BIT,
 				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
 				   NETIF_F_GSO_UDP_L4_BIT);
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	/* Support TSO on tag interface */
 	netdev_vlan_features_set(netdev, netdev->features);
 	netdev_hw_features_set(netdev, netdev_tx_vlan_features);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index ae3a18119fef..935f0d1f4550 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3897,7 +3897,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	eth->netdev[id]->netdev_ops = &mtk_netdev_ops;
 	eth->netdev[id]->base_addr = (unsigned long)eth->base;
 
-	eth->netdev[id]->hw_features = *eth->soc->hw_features;
+	netdev_hw_features_copy(eth->netdev[id], *eth->soc->hw_features);
 	if (eth->hwlro)
 		netdev_hw_feature_add(eth->netdev[id], NETIF_F_LRO_BIT);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 5c4570c3878e..879c96c4aa96 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3349,10 +3349,10 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		dev->udp_tunnel_nic_info = &mlx4_udp_tunnels;
 	}
 
-	dev->vlan_features = dev->hw_features;
+	netdev_vlan_features_copy(dev, dev->hw_features);
 
 	netdev_hw_features_set_set(dev, NETIF_F_RXCSUM_BIT, NETIF_F_RXHASH_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 	netdev_active_features_set_set(dev, NETIF_F_HIGHDMA_BIT,
 				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 44a3ef2d8cd1..d0a9e69b24fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3888,7 +3888,7 @@ int mlx5e_set_features(struct net_device *netdev,
 				    mlx5e_ktls_set_feature_rx);
 
 	if (err) {
-		netdev->features = oper_features;
+		netdev_active_features_copy(netdev, oper_features);
 		return -EINVAL;
 	}
 
@@ -4907,7 +4907,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	    mlx5e_check_fragmented_striding_rq_cap(mdev))
 		netdev_vlan_feature_add(netdev, NETIF_F_LRO_BIT);
 
-	netdev->hw_features       = netdev->vlan_features;
+	netdev_hw_features_copy(netdev, netdev->vlan_features);
 	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
@@ -4967,7 +4967,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	if (mlx5_qos_is_supported(mdev))
 		netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
-	netdev->features          = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 
 	/* Defaults */
 	if (fcs_enabled)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ccdc585b6e4c..58aab1182032 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1245,9 +1245,10 @@ static int mlxsw_sp_handle_feature(struct net_device *dev,
 static int mlxsw_sp_set_features(struct net_device *dev,
 				 const netdev_features_t *features)
 {
-	netdev_features_t oper_features = dev->features;
+	netdev_features_t oper_features;
 	int err = 0;
 
+	netdev_features_copy(oper_features, dev->features);
 	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_HW_TC_BIT,
 				       mlxsw_sp_feature_hw_tc);
 	err |= mlxsw_sp_handle_feature(dev, features, NETIF_F_LOOPBACK_BIT,
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 594afe94874e..78de627c23c7 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3400,7 +3400,7 @@ static int lan743x_pcidev_probe(struct pci_dev *pdev,
 	netdev_active_features_set_set(adapter->netdev, NETIF_F_SG_BIT,
 				       NETIF_F_TSO_BIT, NETIF_F_HW_CSUM_BIT,
 				       NETIF_F_RXCSUM_BIT);
-	adapter->netdev->hw_features = adapter->netdev->features;
+	netdev_hw_features_copy(adapter->netdev, adapter->netdev->features);
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
 	netif_carrier_off(netdev);
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 888d494bbeda..778d81ae3014 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2086,7 +2086,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_RXCSUM_BIT,
 				   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
 				   NETIF_F_RXHASH_BIT);
-	ndev->features = ndev->hw_features;
+	netdev_active_features_copy(ndev, ndev->hw_features);
 	netdev_vlan_features_zero(ndev);
 
 	err = register_netdev(ndev);
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 08b6dc477810..81aa4254c814 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2893,10 +2893,11 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 {
 	struct sk_buff *segs, *curr, *next;
 	struct myri10ge_priv *mgp = netdev_priv(dev);
-	netdev_features_t features = dev->features;
 	struct myri10ge_slice_state *ss;
+	netdev_features_t features;
 	netdev_tx_t status;
 
+	netdev_features_copy(features, dev->features);
 	netdev_feature_del(NETIF_F_TSO6_BIT, features);
 	segs = skb_gso_segment(skb, &features);
 	if (IS_ERR(segs))
@@ -3863,13 +3864,13 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->mtu = myri10ge_initial_mtu;
 
 	netdev->netdev_ops = &myri10ge_netdev_ops;
-	netdev->hw_features = mgp->features;
+	netdev_hw_features_copy(netdev, mgp->features);
 	netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
 	/* fake NETIF_F_HW_VLAN_CTAG_RX for good GRO performance */
 	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev_vlan_features_set(netdev, mgp->features);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 723ee0225c9f..fad9d4337eb5 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2401,9 +2401,9 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_NVGRE;
 	}
 	if (nn->cap & (NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE))
-		netdev->hw_enc_features = netdev->hw_features;
+		netdev_hw_enc_features_copy(netdev, netdev->hw_features);
 
-	netdev->vlan_features = netdev->hw_features;
+	netdev_vlan_features_copy(netdev, netdev->hw_features);
 
 	if (nn->cap & NFP_NET_CFG_CTRL_RXVLAN_ANY) {
 		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
@@ -2429,7 +2429,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_RXQINQ;
 	}
 
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 
 	if (nfp_app_has_tc(nn->app) && nn->port)
 		netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index bb310a247e4b..8f5433c3aac9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -244,13 +244,13 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t *features)
 
 	lower_dev = repr->dst->u.port_info.lower_dev;
 
-	lower_features = lower_dev->features;
+	netdev_features_copy(lower_features, lower_dev->features);
 	if (netdev_features_intersects(lower_features, netdev_ip_csum_features))
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, lower_features);
 
 	netdev_features_copy(old_features, *features);
 	netdev_intersect_features(features, features, &lower_features);
-	tmp = NETIF_F_SOFT_FEATURES;
+	netdev_features_copy(tmp, NETIF_F_SOFT_FEATURES);
 	netdev_feature_add(NETIF_F_HW_TC_BIT, tmp);
 	netdev_features_mask(tmp, old_features);
 	netdev_features_set(*features, tmp);
@@ -367,9 +367,9 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 			netdev_hw_feature_add(netdev, NETIF_F_GSO_GRE_BIT);
 	}
 	if (repr_cap & (NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE))
-		netdev->hw_enc_features = netdev->hw_features;
+		netdev_hw_enc_features_copy(netdev, netdev->hw_features);
 
-	netdev->vlan_features = netdev->hw_features;
+	netdev_vlan_features_copy(netdev, netdev->hw_features);
 
 	if (repr_cap & NFP_NET_CFG_CTRL_RXVLAN_ANY)
 		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
@@ -385,7 +385,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	if (repr_cap & NFP_NET_CFG_CTRL_RXQINQ)
 		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_STAG_RX_BIT);
 
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 
 	/* C-Tag strip and S-Tag strip can't be supported simultaneously,
 	 * so enable C-Tag strip and disable S-Tag strip by default.
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index b41db2d70812..f1c701f3f7bc 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2523,7 +2523,7 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_set(netdev, NETIF_F_RXCSUM_BIT,
 				   NETIF_F_IP_CSUM_BIT, NETIF_F_IPV6_CSUM_BIT);
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	pch_gbe_set_ethtool_ops(netdev);
 
 	/* MTU range: 46 - 10300 */
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index 0f391d75d9be..2cfae5d0b72b 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -907,7 +907,7 @@ void qede_vlan_mark_nonconfigured(struct qede_dev *edev)
 static void qede_set_features_reload(struct qede_dev *edev,
 				     struct qede_reload_args *args)
 {
-	edev->ndev->features = args->u.features;
+	netdev_active_features_copy(edev->ndev, args->u.features);
 }
 
 void qede_fix_features(struct net_device *dev, netdev_features_t *features)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 61cc3fb2e808..7531672c9f3a 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -892,10 +892,10 @@ static void qede_init_ndev(struct qede_dev *edev)
 					       NETIF_F_GSO_GRE_CSUM_BIT);
 	}
 
-	ndev->vlan_features = hw_features;
+	netdev_vlan_features_copy(ndev, hw_features);
 	netdev_vlan_features_set_set(ndev, NETIF_F_RXHASH_BIT,
 				     NETIF_F_RXCSUM_BIT, NETIF_F_HIGHDMA_BIT);
-	ndev->features = hw_features;
+	netdev_active_features_copy(ndev, hw_features);
 	netdev_active_features_set_set(ndev, NETIF_F_RXHASH_BIT,
 				       NETIF_F_RXCSUM_BIT,
 				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
@@ -903,7 +903,7 @@ static void qede_init_ndev(struct qede_dev *edev)
 				       NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				       NETIF_F_HW_VLAN_CTAG_TX_BIT);
 
-	ndev->hw_features = hw_features;
+	netdev_hw_features_copy(ndev, hw_features);
 
 	/* MTU range: 46 - 9600 */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 94b5b96ad9fb..205427e0b848 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2318,7 +2318,7 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 		netdev->udp_tunnel_nic_info = &qlcnic_udp_tunnels;
 	}
 
-	netdev->hw_features = netdev->features;
+	netdev_hw_features_copy(netdev, netdev->features);
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->irq = adapter->msix_entries[0].vector;
 
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 3a5f9c93edb8..0cc8ede831ba 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -673,7 +673,7 @@ static int emac_probe(struct platform_device *pdev)
 				       NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT,
 				       NETIF_F_HW_VLAN_CTAG_RX_BIT,
 				       NETIF_F_HW_VLAN_CTAG_TX_BIT);
-	netdev->hw_features = netdev->features;
+	netdev_hw_features_copy(netdev, netdev->features);
 
 	netdev_vlan_features_set_set(netdev, NETIF_F_SG_BIT,
 				     NETIF_F_HW_CSUM_BIT, NETIF_F_TSO_BIT,
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index c8f1622a230f..567d7393c21f 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -1013,7 +1013,7 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 	 */
 	netdev_active_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				       NETIF_F_HIGHDMA_BIT);
-	dev->vlan_features = dev->features;
+	netdev_vlan_features_copy(dev, dev->features);
 
 	netdev_hw_feature_add(dev, NETIF_F_RXALL_BIT);
 	netdev_hw_feature_add(dev, NETIF_F_RXFCS_BIT);
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 5f99a06ef122..382f06aeb3da 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2648,8 +2648,8 @@ static int ravb_probe(struct platform_device *pdev)
 	info = of_device_get_match_data(&pdev->dev);
 
 	netdev_feature_add(NETIF_F_RXCSUM_BIT, ravb_default_features);
-	ndev->features = *info->net_features;
-	ndev->hw_features = *info->net_hw_features;
+	netdev_active_features_copy(ndev, *info->net_features);
+	netdev_hw_features_copy(ndev, *info->net_hw_features);
 
 	reset_control_deassert(rstc);
 	pm_runtime_enable(&pdev->dev);
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index cf027162da71..564103f1dd26 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3296,7 +3296,7 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 	if (mdp->cd->rx_csum) {
 		netdev_active_features_zero(ndev);
 		netdev_active_feature_add(ndev, NETIF_F_RXCSUM_BIT);
-		ndev->hw_features = ndev->features;
+		netdev_hw_features_copy(ndev, ndev->features);
 	}
 
 	/* set function */
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 3aefa37ae5ce..1b8dccbffccd 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1368,7 +1368,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		netdev_feature_add(NETIF_F_TSO_BIT, hw_enc_features);
 		netdev_active_features_set(efx->net_dev, encap_tso_features);
 	}
-	efx->net_dev->hw_enc_features = hw_enc_features;
+	netdev_hw_enc_features_copy(efx->net_dev, hw_enc_features);
 
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 670e30425447..e4423ec042b9 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -368,8 +368,8 @@ void efx_start_monitor(struct efx_nic *efx)
  */
 static void efx_start_datapath(struct efx_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->features;
 	bool old_rx_scatter = efx->rx_scatter;
+	netdev_features_t old_features;
 	size_t rx_buf_len;
 
 	/* Calculate the rx buffer allocation parameters required to
@@ -411,6 +411,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 			  efx->rx_dma_len, efx->rx_page_buf_step,
 			  efx->rx_bufs_per_page, efx->rx_pages_per_batch);
 
+	netdev_features_copy(old_features, efx->net_dev->features);
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 438f8a453f32..13a4463fb9d4 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -587,8 +587,8 @@ static int ef4_probe_channels(struct ef4_nic *efx)
  */
 static void ef4_start_datapath(struct ef4_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->features;
 	bool old_rx_scatter = efx->rx_scatter;
+	netdev_features_t old_features;
 	struct ef4_tx_queue *tx_queue;
 	struct ef4_rx_queue *rx_queue;
 	struct ef4_channel *channel;
@@ -632,6 +632,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 			  efx->rx_dma_len, efx->rx_page_buf_step,
 			  efx->rx_bufs_per_page, efx->rx_pages_per_batch);
 
+	netdev_features_copy(old_features, efx->net_dev->features);
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index fc3bf13d4b67..58bd3df2e41e 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -368,8 +368,8 @@ void efx_siena_start_monitor(struct efx_nic *efx)
  */
 static void efx_start_datapath(struct efx_nic *efx)
 {
-	netdev_features_t old_features = efx->net_dev->features;
 	bool old_rx_scatter = efx->rx_scatter;
+	netdev_features_t old_features;
 	size_t rx_buf_len;
 
 	/* Calculate the rx buffer allocation parameters required to
@@ -411,6 +411,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 			  efx->rx_dma_len, efx->rx_page_buf_step,
 			  efx->rx_bufs_per_page, efx->rx_pages_per_batch);
 
+	netdev_features_copy(old_features, efx->net_dev->features);
 	/* Restore previously fixed features in hw_features and remove
 	 * features which are fixed now
 	 */
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 05db1d69ae2a..928bbc48c5d3 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -2104,7 +2104,7 @@ static int netsec_probe(struct platform_device *pdev)
 				       NETIF_F_RXCSUM_BIT, NETIF_F_GSO_BIT,
 				       NETIF_F_IP_CSUM_BIT,
 				       NETIF_F_IPV6_CSUM_BIT);
-	ndev->hw_features = ndev->features;
+	netdev_hw_features_copy(ndev, ndev->features);
 
 	priv->rx_cksum_offload_flag = true;
 
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index eaf2b6d8c187..1ed4eabcd9ae 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -248,7 +248,7 @@ static struct net_device *vsw_alloc_netdev(u8 hwaddr[],
 
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_set(dev, NETIF_F_HW_CSUM_BIT, NETIF_F_SG_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index ccd06f237ef9..bb0fb1e6f4ea 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2993,7 +2993,7 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_RXCSUM_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 	if (pci_using_dac)
 		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 469a1f9cc2fc..9b08ad7ba286 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -314,10 +314,10 @@ static struct vnet *vnet_new(const u64 *local_mac,
 	dev->ethtool_ops = &vnet_ethtool_ops;
 	dev->watchdog_timeo = VNET_TX_TIMEOUT;
 
-	dev->hw_features = NETIF_F_ALL_TSO;
+	netdev_hw_features_copy(dev, NETIF_F_ALL_TSO);
 	netdev_hw_features_set_set(dev, NETIF_F_TSO_BIT, NETIF_F_GSO_BIT,
 				   NETIF_F_HW_CSUM_BIT, NETIF_F_SG_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/sunvnet_common.c b/drivers/net/ethernet/sun/sunvnet_common.c
index b0239b704e79..e9dd32e3b8b6 100644
--- a/drivers/net/ethernet/sun/sunvnet_common.c
+++ b/drivers/net/ethernet/sun/sunvnet_common.c
@@ -1228,7 +1228,7 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 	int status;
 	int gso_size, gso_type, gso_segs;
 	int hlen = skb_transport_header(skb) - skb_mac_header(skb);
-	netedv_features_t features = dev->features;
+	netedv_features_t features;
 	int proto = IPPROTO_IP;
 
 	if (skb->protocol == htons(ETH_P_IP))
@@ -1275,6 +1275,7 @@ vnet_handle_offloads(struct vnet_port *port, struct sk_buff *skb,
 		skb_shinfo(skb)->gso_size = datalen;
 		skb_shinfo(skb)->gso_segs = gso_segs;
 	}
+	netdev_features_copy(features, dev->features);
 	netdev_feature_del(NETIF_F_TSO_BIT, features);
 	segs = skb_gso_segment(skb, &features);
 	if (IS_ERR(segs))
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index d81a3b69ec47..476293d90bfc 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -179,11 +179,11 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 
 	/* Set device features */
 	if (pdata->hw_feat.tso) {
-		netdev->hw_features = netdev_general_tso_features;
+		netdev_hw_features_copy(netdev, netdev_general_tso_features);
 		netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
 		netdev_hw_features_set(netdev, netdev_ip_csum_features);
 	} else if (pdata->hw_feat.tx_coe) {
-		netdev->hw_features = netdev_ip_csum_features;
+		netdev_hw_features_copy(netdev, netdev_ip_csum_features);
 	}
 
 	if (pdata->hw_feat.rx_coe) {
@@ -203,7 +203,7 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	netdev_active_features_set(netdev, netdev->hw_features);
-	pdata->netdev_features = netdev->features;
+	netdev_features_copy(pdata->netdev_features, netdev->features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index a64c450ce149..86c3d09c194c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1982,7 +1982,7 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	netdev_hw_features_set_set(port->ndev, NETIF_F_SG_BIT,
 				   NETIF_F_RXCSUM_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_HW_TC_BIT);
-	port->ndev->features = port->ndev->hw_features;
+	netdev_active_features_copy(port->ndev, port->ndev->hw_features);
 	netdev_active_feature_add(port->ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	netdev_vlan_feature_add(port->ndev, NETIF_F_SG_BIT);
 	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index 9a513869ab66..b27f9a365b13 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1977,7 +1977,7 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 
 	netdev_active_feature_add(ndev, NETIF_F_SG_BIT);
 	netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
-	ndev->hw_features = ndev->features;
+	netdev_hw_features_copy(ndev, ndev->features);
 	netdev_vlan_feature_add(ndev, NETIF_F_SG_BIT);
 
 	/* MTU range: 68 - 9486 */
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index c96811972969..56db2c150be8 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2374,7 +2374,7 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
 	if (ndev->needed_headroom < vf_netdev->needed_headroom)
 		ndev->needed_headroom = vf_netdev->needed_headroom;
 
-	vf_netdev->wanted_features = ndev->features;
+	netdev_wanted_features_copy(vf_netdev, ndev->features);
 	netdev_update_features(vf_netdev);
 
 	prog = netvsc_xdp_get(netvsc_dev);
@@ -2540,11 +2540,11 @@ static int netvsc_probe(struct hv_device *dev,
 		schedule_work(&nvdev->subchan_work);
 
 	/* hw_features computed in rndis_netdev_set_hwcaps() */
-	net->features = net->hw_features;
+	netdev_active_features_copy(net, net->hw_features);
 	netdev_active_features_set_set(net, NETIF_F_HIGHDMA_BIT,
 				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				       NETIF_F_HW_VLAN_CTAG_RX_BIT);
-	net->vlan_features = net->features;
+	netdev_vlan_features_copy(net, net->features);
 
 	netdev_lockdep_set_classes(net);
 
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 31d5e203e035..66a892932f71 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -564,7 +564,7 @@ int ipvlan_link_new(struct net *src_net, struct net_device *dev,
 
 	ipvlan->phy_dev = phy_dev;
 	ipvlan->dev = dev;
-	ipvlan->sfeatures = IPVLAN_FEATURES;
+	netdev_features_copy(ipvlan->sfeatures, IPVLAN_FEATURES);
 	if (!tb[IFLA_MTU])
 		ipvlan_adjust_mtu(ipvlan, phy_dev);
 	INIT_LIST_HEAD(&ipvlan->addrs);
@@ -1024,11 +1024,11 @@ static void __init ipvlan_features_init(void)
 				NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				NETIF_F_GSO_ROBUST_BIT);
 
-	ipvlan_always_on_features = ipvlan_offload_features;
+	netdev_features_copy(ipvlan_always_on_features, ipvlan_offload_features);
 	netdev_features_set_set(ipvlan_always_on_features, NETIF_F_LLTX_BIT,
 				NETIF_F_VLAN_CHALLENGED_BIT);
 
-	ipvlan_features = NETIF_F_ALL_TSO;
+	netdev_features_copy(ipvlan_features, NETIF_F_ALL_TSO);
 	netdev_features_set_set(ipvlan_features, NETIF_F_SG_BIT,
 				NETIF_F_HW_CSUM_BIT,
 				NETIF_F_HIGHDMA_BIT,
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index f5f5cbb29766..bc35b5e2736f 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -176,8 +176,8 @@ static void gen_lo_setup(struct net_device *dev,
 	dev->flags		= IFF_LOOPBACK;
 	dev->priv_flags		|= IFF_LIVE_ADDR_CHANGE | IFF_NO_QUEUE;
 	netif_keep_dst(dev);
-	dev->hw_features	= NETIF_F_GSO_SOFTWARE;
-	dev->features		= NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_copy(dev, NETIF_F_GSO_SOFTWARE);
+	netdev_active_features_copy(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_active_features_set_set(dev, NETIF_F_SG_BIT,
 				       NETIF_F_FRAGLIST_BIT,
 				       NETIF_F_HW_CSUM_BIT, NETIF_F_RXCSUM_BIT,
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 513e1ff7a2a0..3d82c7cc9f9f 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -4409,7 +4409,7 @@ static void __init macsec_features_init(void)
 	netdev_features_set_set(sw_macsec_features, NETIF_F_SG_BIT,
 				NETIF_F_HIGHDMA_BIT, NETIF_F_FRAGLIST_BIT);
 
-	macsec_no_inherit_features = NETIF_F_VLAN_FEATURES;
+	netdev_features_copy(macsec_no_inherit_features, NETIF_F_VLAN_FEATURES);
 	netdev_feature_add(NETIF_F_HW_MACSEC_BIT, macsec_no_inherit_features);
 }
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 21071335c0ac..1c9068be8569 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1077,10 +1077,11 @@ static void macvlan_fix_features(struct net_device *dev,
 				 netdev_features_t *features)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
-	netdev_features_t lowerdev_features = vlan->lowerdev->features;
+	netdev_features_t lowerdev_features;
 	netdev_features_t mask;
 	netdev_features_t tmp;
 
+	netdev_features_copy(lowerdev_features, vlan->lowerdev->features);
 	netdev_features_set(*features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(tmp);
 	netdev_features_clear(tmp, MACVLAN_FEATURES);
@@ -1826,7 +1827,7 @@ static void __init macvlan_features_init(void)
 				NETIF_F_HW_CSUM_BIT,
 				NETIF_F_GSO_ROBUST_BIT);
 
-	macvlan_always_on_features = macvlan_offload_features;
+	netdev_features_copy(macvlan_always_on_features, macvlan_offload_features);
 	netdev_features_set_set(macvlan_always_on_features, NETIF_F_LLTX_BIT);
 
 	netdev_features_set_set(macvlan_features,
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index d0b72fd696d3..0ec4113af572 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -383,14 +383,15 @@ static rx_handler_result_t net_failover_handle_frame(struct sk_buff **pskb)
 
 static void net_failover_compute_features(struct net_device *dev)
 {
-	netdev_features_t enc_features  = FAILOVER_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
 	struct net_failover_info *nfo_info = netdev_priv(dev);
 	struct net_device *primary_dev, *standby_dev;
 	netdev_features_t vlan_features;
+	netdev_features_t enc_features;
 
+	netdev_features_copy(enc_features, FAILOVER_ENC_FEATURES);
 	netdev_features_and(vlan_features, FAILOVER_VLAN_FEATURES,
 			    NETIF_F_ALL_FOR_ALL);
 
@@ -422,7 +423,7 @@ static void net_failover_compute_features(struct net_device *dev)
 			max_hard_header_len = standby_dev->hard_header_len;
 	}
 
-	dev->vlan_features = vlan_features;
+	netdev_vlan_features_copy(dev, vlan_features);
 	netdev_hw_enc_features_or(dev, enc_features, NETIF_F_GSO_ENCAP_ALL);
 	dev->hard_header_len = max_hard_header_len;
 
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index a116b21ae741..d67083d30f4d 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -426,7 +426,7 @@ static int ntb_netdev_probe(struct device *client_dev)
 
 	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	ndev->hw_features = ndev->features;
+	netdev_hw_features_copy(ndev, ndev->features);
 	ndev->watchdog_timeo = msecs_to_jiffies(NTB_TX_TIMEOUT_MS);
 
 	eth_random_addr(ndev->perm_addr);
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index a13c0479079f..fcc9ec6895a5 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -947,7 +947,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 		return -ENOLINK;
 
 	netdev_features_zero(feature_mask);
-	features = tap->dev->features;
+	netdev_features_copy(features, tap->dev->features);
 
 	if (arg & TUN_F_CSUM) {
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, feature_mask);
@@ -983,7 +983,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	/* tap_features are the same as features on tun/tap and
 	 * reflect user expectations.
 	 */
-	tap->tap_features = feature_mask;
+	netdev_features_copy(tap->tap_features, feature_mask);
 	if (tap->update_features)
 		tap->update_features(tap, &features);
 
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 1f9642b400ec..c32e8760e2d3 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -989,12 +989,13 @@ static netdev_features_t team_enc_features __ro_after_init;
 static void __team_compute_features(struct team *team)
 {
 	struct team_port *port;
-	netdev_features_t enc_features  = TEAM_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
 	netdev_features_t vlan_features;
+	netdev_features_t enc_features;
 
+	netdev_features_copy(enc_features, TEAM_ENC_FEATURES);
 	netdev_features_and(vlan_features, TEAM_VLAN_FEATURES,
 			    NETIF_F_ALL_FOR_ALL);
 
@@ -1014,7 +1015,7 @@ static void __team_compute_features(struct team *team)
 	}
 	rcu_read_unlock();
 
-	team->dev->vlan_features = vlan_features;
+	netdev_vlan_features_copy(team->dev, vlan_features);
 	netdev_hw_enc_features_or(team->dev, enc_features,
 				  NETIF_F_GSO_ENCAP_ALL);
 	netdev_hw_enc_features_set(team->dev, netdev_tx_vlan_features);
@@ -2173,7 +2174,7 @@ static void team_setup(struct net_device *dev)
 	/* Don't allow team devices to change network namespaces. */
 	netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
 
-	dev->hw_features = TEAM_VLAN_FEATURES;
+	netdev_hw_features_copy(dev, TEAM_VLAN_FEATURES);
 	netdev_hw_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev_hw_feature_add(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
@@ -2875,14 +2876,14 @@ static void team_nl_fini(void)
 
 static void __init team_features_init(void)
 {
-	team_vlan_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(team_vlan_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(team_vlan_features,
 				NETIF_F_HW_CSUM_BIT,
 				NETIF_F_SG_BIT,
 				NETIF_F_FRAGLIST_BIT,
 				NETIF_F_HIGHDMA_BIT,
 				NETIF_F_LRO_BIT);
-	team_enc_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(team_enc_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(team_enc_features, NETIF_F_HW_CSUM_BIT,
 				NETIF_F_SG_BIT, NETIF_F_RXCSUM_BIT);
 }
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index cd446c8242b4..a259f8da43ec 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1278,12 +1278,12 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 	 * we need to announce support for most of the offloading
 	 * features here.
 	 */
-	dev->hw_features = NETIF_F_ALL_TSO;
+	netdev_hw_features_copy(dev, NETIF_F_ALL_TSO);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT,
 				   NETIF_F_GRO_BIT,
 				   NETIF_F_IP_CSUM_BIT,
 				   NETIF_F_IPV6_CSUM_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	dev->hard_header_len += sizeof(struct thunderbolt_ip_frame_header);
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index d2e6bfb5edd4..689f704d96ba 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -991,12 +991,12 @@ static int tun_net_init(struct net_device *dev)
 
 	tun_flow_init(tun);
 
-	dev->hw_features = TUN_USER_FEATURES;
+	netdev_hw_features_copy(dev, TUN_USER_FEATURES);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT,
 				   NETIF_F_FRAGLIST_BIT,
 				   NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				   NETIF_F_HW_VLAN_STAG_TX_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netdev_vlan_features_andnot(dev, dev->features,
 				    netdev_tx_vlan_features);
@@ -2889,7 +2889,7 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 	if (arg)
 		return -EINVAL;
 
-	tun->set_features = features;
+	netdev_features_copy(tun->set_features, features);
 	netdev_wanted_features_clear(tun->dev, TUN_USER_FEATURES);
 	netdev_wanted_features_set(tun->dev, features);
 	netdev_update_features(tun->dev);
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 227ca5943007..0194eefb4581 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3478,7 +3478,7 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 		netdev_active_feature_add(dev->net,
 					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
-	dev->net->hw_features = dev->net->features;
+	netdev_hw_features_copy(dev->net, dev->net->features);
 
 	ret = lan78xx_setup_irq_domain(dev);
 	if (ret < 0) {
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d2936ac84774..c3fae3b595f8 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2106,10 +2106,11 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 				  struct sk_buff_head *list)
 {
 	if (skb_shinfo(skb)->gso_size) {
-		netdev_features_t features = tp->netdev->features;
 		struct sk_buff *segs, *seg, *next;
 		struct sk_buff_head seg_list;
+		netdev_features_t features;
 
+		netdev_features_copy(features, tp->netdev->features);
 		netdev_features_clear_set(features, NETIF_F_SG_BIT,
 					  NETIF_F_IPV6_CSUM_BIT,
 					  NETIF_F_TSO6_BIT);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 8c516efa818d..c34dd2aefa51 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1651,9 +1651,9 @@ static void veth_setup(struct net_device *dev)
 	dev->priv_destructor = veth_dev_free;
 	dev->max_mtu = ETH_MAX_MTU;
 
-	dev->hw_features = veth_features;
-	dev->hw_enc_features = veth_features;
-	dev->mpls_features = NETIF_F_GSO_SOFTWARE;
+	netdev_hw_features_copy(dev, veth_features);
+	netdev_hw_enc_features_copy(dev, veth_features);
+	netdev_mpls_features_copy(dev, NETIF_F_GSO_SOFTWARE);
 	netdev_mpls_feature_add(dev, NETIF_F_HW_CSUM_BIT);
 	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index d4e9ffa9695e..be9febc83bc3 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3761,7 +3761,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
 		netdev_hw_feature_add(dev, NETIF_F_GRO_HW_BIT);
 
-	dev->vlan_features = dev->features;
+	netdev_vlan_features_copy(dev, dev->features);
 
 	/* MTU range: 68 - 65535 */
 	dev->min_mtu = MIN_MTU;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index e9671df05780..846b6df31e34 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3385,7 +3385,7 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 
 	netdev_vlan_features_andnot(netdev, netdev->hw_features,
 				    netdev_ctag_vlan_offload_features);
-	netdev->features = netdev->hw_features;
+	netdev_active_features_copy(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 }
 
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index c7fd71f66b2e..366ef17c4640 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1695,8 +1695,8 @@ static void vrf_setup(struct net_device *dev)
 				       NETIF_F_FRAGLIST_BIT,
 				       NETIF_F_HIGHDMA_BIT);
 
-	dev->hw_features = dev->features;
-	dev->hw_enc_features = dev->features;
+	netdev_hw_features_copy(dev, dev->features);
+	netdev_hw_enc_features_copy(dev, dev->features);
 
 	/* default to no qdisc; user can add if desired */
 	dev->priv_flags |= IFF_NO_QUEUE;
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index e179c780b761..0a520055ea32 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3169,7 +3169,7 @@ static void vxlan_setup(struct net_device *dev)
 				       NETIF_F_RXCSUM_BIT);
 	netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 
-	dev->vlan_features = dev->features;
+	netdev_vlan_features_copy(dev, dev->features);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_FRAGLIST_BIT, NETIF_F_RXCSUM_BIT);
 	netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 04145af755c9..9561d80f5d30 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -293,7 +293,7 @@ static void wg_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 	dev->priv_flags |= IFF_NO_QUEUE;
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-	wg_netdev_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(wg_netdev_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(wg_netdev_features, NETIF_F_HW_CSUM_BIT,
 				NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
 				NETIF_F_GSO_BIT, NETIF_F_HIGHDMA_BIT);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index e8588fa8e5df..5915ef98c611 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1848,12 +1848,13 @@ static void __init iwl_features_init(void)
 				NETIF_F_HW_CSUM_BIT,
 				NETIF_F_TSO_BIT,
 				NETIF_F_TSO6_BIT);
-	iwl_dev_22000_comm_features = iwl_tx_csum_features;
+	netdev_features_copy(iwl_dev_22000_comm_features, iwl_tx_csum_features);
 	netdev_feature_add(NETIF_F_RXCSUM_BIT, iwl_dev_22000_comm_features);
-	iwl_dev_bz_comm_features = iwl_tx_csum_bz_features;
+	netdev_features_copy(iwl_dev_bz_comm_features, iwl_tx_csum_bz_features);
 	netdev_feature_add(NETIF_F_RXCSUM_BIT, iwl_dev_bz_comm_features);
 	netdev_feature_add(NETIF_F_RXCSUM_BIT, iwl_dev_8000_comm_features);
-	iwl_dev_9000_comm_features = iwl_dev_22000_comm_features;
+	netdev_features_copy(iwl_dev_9000_comm_features,
+			     iwl_dev_22000_comm_features);
 }
 
 static int __init iwl_drv_init(void)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 4ed95b179b45..f44e1f687045 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -891,7 +891,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	netdev_features_t netdev_flags;
 	u8 tid;
 
-	netdev_flags = NETIF_F_CSUM_MASK;
+	netdev_features_copy(netdev_flags, NETIF_F_CSUM_MASK);
 	netdev_feature_add(NETIF_F_SG_BIT, netdev_flags);
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 62677a757409..16b8bbe5f4f9 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -525,7 +525,7 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
 				   NETIF_F_IPV6_CSUM_BIT, NETIF_F_TSO_BIT,
 				   NETIF_F_TSO6_BIT, NETIF_F_FRAGLIST_BIT);
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 811e79c9f59c..efb88f979494 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -1814,7 +1814,7 @@ dasd_set_feature(struct ccw_device *cdev, int feature, int flag)
 	else
 		devmap->features &= ~feature;
 	if (devmap->device)
-		devmap->device->features = devmap->features;
+		netdev_active_features_copy(devmap->device, devmap->features);
 	spin_unlock(&dasd_devmap_lock);
 	return 0;
 }
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 6695f8dda8f4..e4d04dd0bdb9 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6744,7 +6744,7 @@ void qeth_enable_hw_features(struct net_device *dev)
 	struct qeth_card *card = dev->ml_priv;
 	netdev_features_t features;
 
-	features = dev->features;
+	netdev_features_copy(features, dev->features);
 	/* force-off any feature that might need an IPA sequence.
 	 * netdev_update_features() will restart them.
 	 */
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index c1140efa3413..afe06a8e169d 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4579,8 +4579,8 @@ static int qlge_probe(struct pci_dev *pdev,
 				   NETIF_F_HW_VLAN_CTAG_RX_BIT,
 				   NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				   NETIF_F_RXCSUM_BIT);
-	ndev->features = ndev->hw_features;
-	ndev->vlan_features = ndev->hw_features;
+	netdev_active_features_copy(ndev, ndev->hw_features);
+	netdev_vlan_features_copy(ndev, ndev->hw_features);
 	/* vlan gets same features (except vlan filter) */
 	netdev_vlan_features_clear(ndev, netdev_ctag_vlan_features);
 
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 321adf534177..6078a52de35e 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -584,7 +584,7 @@ static int vlan_dev_init(struct net_device *dev)
 	netdev_vlan_features_andnot(dev, real_dev->vlan_features,
 				    NETIF_F_ALL_FCOE);
 	vlan_tnl_features(real_dev, &dev->hw_enc_features);
-	dev->mpls_features = real_dev->mpls_features;
+	netdev_mpls_features_copy(dev, real_dev->mpls_features);
 
 	/* ipv6 shared card related stuff */
 	dev->dev_id = real_dev->dev_id;
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index fafcc67ca3bc..7083fd686e1b 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -490,17 +490,17 @@ void br_dev_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &br_type);
 	dev->priv_flags = IFF_EBRIDGE | IFF_NO_QUEUE;
 
-	common_features = NETIF_F_GSO_MASK;
+	netdev_features_copy(common_features, NETIF_F_GSO_MASK);
 	netdev_features_set_set(common_features, NETIF_F_SG_BIT,
 				NETIF_F_FRAGLIST_BIT, NETIF_F_HIGHDMA_BIT,
 				NETIF_F_HW_CSUM_BIT);
-	dev->features = common_features;
+	netdev_active_features_copy(dev, common_features);
 	netdev_active_features_set_set(dev, NETIF_F_LLTX_BIT,
 				       NETIF_F_NETNS_LOCAL_BIT,
 				       NETIF_F_HW_VLAN_CTAG_TX_BIT,
 				       NETIF_F_HW_VLAN_STAG_TX_BIT);
 	netdev_hw_features_or(dev, common_features, netdev_tx_vlan_features);
-	dev->vlan_features = common_features;
+	netdev_vlan_features_copy(dev, common_features);
 
 	br->dev = dev;
 	spin_lock_init(&br->lock);
diff --git a/net/core/dev.c b/net/core/dev.c
index bed372ecef65..d854c643d2b2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9561,9 +9561,10 @@ static void netdev_sync_upper_features(struct net_device *lower,
 				       struct net_device *upper,
 				       netdev_features_t *features)
 {
-	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
+	netdev_features_t upper_disables;
 	int feature_bit;
 
+	netdev_features_copy(upper_disables, NETIF_F_UPPER_DISABLES);
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		if (!netdev_wanted_feature_test(upper, feature_bit) &&
 		    netdev_feature_test(feature_bit, *features)) {
@@ -9577,9 +9578,10 @@ static void netdev_sync_upper_features(struct net_device *lower,
 static void netdev_sync_lower_features(struct net_device *upper,
 	struct net_device *lower, netdev_features_t *features)
 {
-	netdev_features_t upper_disables = NETIF_F_UPPER_DISABLES;
+	netdev_features_t upper_disables;
 	int feature_bit;
 
+	netdev_features_copy(upper_disables, NETIF_F_UPPER_DISABLES);
 	for_each_netdev_feature(upper_disables, feature_bit) {
 		if (!netdev_feature_test(feature_bit, *features) &&
 		    netdev_active_feature_test(lower, feature_bit)) {
@@ -9637,7 +9639,7 @@ static void netdev_fix_features(struct net_device *dev,
 		netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT, *features);
 
 	/* TSO ECN requires that TSO is present as well. */
-	tmp = NETIF_F_ALL_TSO;
+	netdev_features_copy(tmp, NETIF_F_ALL_TSO);
 	netdev_feature_del(NETIF_F_TSO_ECN_BIT, tmp);
 	if (!netdev_features_intersects(*features, tmp) &&
 	    netdev_feature_test(NETIF_F_TSO_ECN_BIT, *features))
@@ -9769,7 +9771,7 @@ int __netdev_update_features(struct net_device *dev)
 			 * but *after* calling udp_tunnel_drop_rx_info.
 			 */
 			if (netdev_feature_test(NETIF_F_RX_UDP_TUNNEL_PORT_BIT, features)) {
-				dev->features = features;
+				netdev_active_features_copy(dev, features);
 				udp_tunnel_get_rx_info(dev);
 			} else {
 				udp_tunnel_drop_rx_info(dev);
@@ -9778,7 +9780,7 @@ int __netdev_update_features(struct net_device *dev)
 
 		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, diff)) {
 			if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features)) {
-				dev->features = features;
+				netdev_active_features_copy(dev, features);
 				err |= vlan_get_rx_ctag_filter_info(dev);
 			} else {
 				vlan_drop_rx_ctag_filter_info(dev);
@@ -9787,14 +9789,14 @@ int __netdev_update_features(struct net_device *dev)
 
 		if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT, diff)) {
 			if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT, features)) {
-				dev->features = features;
+				netdev_active_features_copy(dev, features);
 				err |= vlan_get_rx_stag_filter_info(dev);
 			} else {
 				vlan_drop_rx_stag_filter_info(dev);
 			}
 		}
 
-		dev->features = features;
+		netdev_active_features_copy(dev, features);
 	}
 
 	return err < 0 ? 0 : 1;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index fd54b586f851..02334524cb64 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2291,7 +2291,7 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 
 	p->xmit = cpu_dp->tag_ops->xmit;
 
-	slave->features = master->vlan_features;
+	netdev_active_features_copy(slave, master->vlan_features);
 	netdev_active_feature_add(slave, NETIF_F_HW_TC_BIT);
 	netdev_hw_feature_add(slave, NETIF_F_HW_TC_BIT);
 	netdev_active_feature_add(slave, NETIF_F_LLTX_BIT);
@@ -2372,7 +2372,7 @@ int dsa_slave_create(struct dsa_port *port)
 
 	SET_NETDEV_DEV(slave_dev, port->ds->dev);
 	slave_dev->dev.of_node = port->dn;
-	slave_dev->vlan_features = master->vlan_features;
+	netdev_vlan_features_copy(slave_dev, master->vlan_features);
 
 	p = netdev_priv(slave_dev);
 	slave_dev->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index c4154666e82a..12bf982a5d2d 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -239,7 +239,7 @@ static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 	switch (eth_cmd) {
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_STXCSUM:
-		tmp = NETIF_F_CSUM_MASK;
+		netdev_features_copy(tmp, NETIF_F_CSUM_MASK);
 		netdev_feature_add(NETIF_F_FCOE_CRC_BIT, tmp);
 		netdev_feature_add(NETIF_F_SCTP_CRC_BIT, tmp);
 		return tmp;
@@ -2818,7 +2818,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
 		if (rc < 0)
 			goto out;
 	}
-	old_features = dev->features;
+	netdev_features_copy(old_features, dev->features);
 
 	switch (ethcmd) {
 	case ETHTOOL_GSET:
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 7d89d3a72e54..a85be08ff4b8 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -446,12 +446,12 @@ void hsr_dev_setup(struct net_device *dev)
 
 	dev->needs_free_netdev = true;
 
-	dev->hw_features = NETIF_F_GSO_MASK;
+	netdev_hw_features_copy(dev, NETIF_F_GSO_MASK);
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_FRAGLIST_BIT,
 				   NETIF_F_HIGHDMA_BIT, NETIF_F_HW_CSUM_BIT,
 				   NETIF_F_HW_VLAN_CTAG_TX_BIT);
 
-	dev->features = dev->hw_features;
+	netdev_active_features_copy(dev, dev->hw_features);
 
 	/* Prevent recursive tx locking */
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index fc7835e24717..3ce0643263f9 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -368,7 +368,7 @@ static void ipip_tunnel_setup(struct net_device *dev)
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_keep_dst(dev);
 
-	ipip_features		= NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(ipip_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(ipip_features, NETIF_F_SG_BIT,
 				NETIF_F_FRAGLIST_BIT,
 				NETIF_F_HIGHDMA_BIT,
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 86c7052a3dd3..79c6b3b0c7cc 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1833,7 +1833,7 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_keep_dst(dev);
 
-	ipxipx_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(ipxipx_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(ipxipx_features, NETIF_F_SG_BIT,
 				NETIF_F_FRAGLIST_BIT,
 				NETIF_F_HIGHDMA_BIT,
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 15b0a28d339b..b4468a5a039b 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1426,7 +1426,7 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	netif_keep_dst(dev);
 	dev->addr_len		= 4;
-	sit_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(sit_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(sit_features, NETIF_F_SG_BIT,
 				NETIF_F_FRAGLIST_BIT,
 				NETIF_F_HIGHDMA_BIT,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index f2f55129d639..3b58a56289f9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1537,7 +1537,7 @@ EXPORT_SYMBOL(ieee80211_free_hw);
 
 static void __init ieee80211_features_init(void)
 {
-	mac80211_tx_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(mac80211_tx_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(mac80211_tx_features,
 				NETIF_F_IP_CSUM_BIT,
 				NETIF_F_IPV6_CSUM_BIT,
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index bf332718aeab..2f3c8d5bb486 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -117,10 +117,10 @@ static void do_setup(struct net_device *netdev)
 				       NETIF_F_HIGHDMA_BIT,
 				       NETIF_F_HW_CSUM_BIT);
 
-	netdev->vlan_features = netdev->features;
-	netdev->hw_enc_features = netdev->features;
+	netdev_vlan_features_copy(netdev, netdev->features);
+	netdev_hw_enc_features_copy(netdev, netdev->features);
 	netdev_active_features_set(netdev, netdev_tx_vlan_features);
-	netdev->hw_features = netdev->features;
+	netdev_hw_features_copy(netdev, netdev->features);
 	netdev_hw_feature_del(netdev, NETIF_F_LLTX_BIT);
 
 	eth_hw_addr_random(netdev);
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 3d5b8c6377d7..90df017678a2 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -590,7 +590,7 @@ static int xfrmi_dev_init(struct net_device *dev)
 		return err;
 	}
 
-	xfrmi_features = NETIF_F_GSO_SOFTWARE;
+	netdev_features_copy(xfrmi_features, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set_set(xfrmi_features, NETIF_F_SG_BIT,
 				NETIF_F_FRAGLIST_BIT, NETIF_F_HW_CSUM_BIT);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-- 
2.33.0

