Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A53858E548
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiHJDOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiHJDNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:52 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B57D81B3A
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:48 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgv0N8hzjXNn;
        Wed, 10 Aug 2022 11:10:35 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:46 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 15/36] treewide: simplify the netdev features expression
Date:   Wed, 10 Aug 2022 11:06:03 +0800
Message-ID: <20220810030624.34711-16-shenjian15@huawei.com>
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

To make the semantic patches simple, split the complex opreation of
netdev_features to simple ones, and replace some feature macroes with
global netdev features variables.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |  9 ++--
 drivers/net/bonding/bond_main.c               | 10 ++--
 drivers/net/ethernet/3com/3c59x.c             |  3 +-
 drivers/net/ethernet/adaptec/starfire.c       |  9 ++--
 drivers/net/ethernet/aeroflex/greth.c         |  3 +-
 drivers/net/ethernet/altera/altera_tse_main.c |  3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |  4 +-
 drivers/net/ethernet/apm/xgene-v2/main.c      |  4 +-
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |  3 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  5 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  6 ++-
 drivers/net/ethernet/broadcom/bnx2.c          | 16 ++++--
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  6 ++-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  9 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 24 ++++++---
 drivers/net/ethernet/broadcom/tg3.c           |  4 +-
 drivers/net/ethernet/cadence/macb_main.c      | 21 +++++---
 .../net/ethernet/cavium/liquidio/lio_main.c   | 10 ++--
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 10 ++--
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  7 +--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  6 ++-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  3 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  6 ++-
 drivers/net/ethernet/cortina/gemini.c         |  3 +-
 drivers/net/ethernet/davicom/dm9000.c         |  3 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |  6 ++-
 drivers/net/ethernet/freescale/gianfar.c      |  3 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  3 +-
 .../ethernet/fungible/funeth/funeth_main.c    |  9 ++--
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |  3 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  9 ++--
 .../net/ethernet/huawei/hinic/hinic_main.c    |  3 +-
 drivers/net/ethernet/ibm/emac/core.c          |  3 +-
 drivers/net/ethernet/ibm/ibmveth.c            |  8 +--
 drivers/net/ethernet/ibm/ibmvnic.c            |  8 +--
 drivers/net/ethernet/intel/e100.c             |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 16 +++---
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  9 ++--
 drivers/net/ethernet/intel/ice/ice_main.c     | 27 ++++++----
 drivers/net/ethernet/intel/igb/igb_main.c     | 14 +++--
 drivers/net/ethernet/intel/igbvf/netdev.c     |  9 ++--
 drivers/net/ethernet/intel/igc/igc_main.c     |  8 +--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  6 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 29 ++++++-----
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 10 ++--
 drivers/net/ethernet/jme.c                    |  6 ++-
 drivers/net/ethernet/marvell/mvneta.c         |  3 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  3 +-
 .../ethernet/marvell/prestera/prestera_main.c |  3 +-
 drivers/net/ethernet/marvell/sky2.c           |  4 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  4 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 36 ++++++-------
 drivers/net/ethernet/mscc/ocelot_net.c        |  2 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  9 ++--
 drivers/net/ethernet/neterion/s2io.c          |  4 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  7 +--
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  6 ++-
 drivers/net/ethernet/netronome/nfp/nfp_port.c |  2 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  3 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  | 10 ++--
 drivers/net/ethernet/qlogic/qede/qede_main.c  | 15 +++---
 drivers/net/ethernet/qlogic/qla3xxx.c         |  6 ++-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  3 +-
 drivers/net/ethernet/realtek/8139cp.c         |  3 +-
 drivers/net/ethernet/realtek/8139too.c        |  2 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  9 ++--
 drivers/net/ethernet/rocker/rocker_main.c     |  3 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  3 +-
 drivers/net/ethernet/sfc/ef10.c               |  3 +-
 drivers/net/ethernet/sfc/efx.c                |  7 ++-
 drivers/net/ethernet/sfc/efx_common.c         | 11 ++--
 drivers/net/ethernet/sfc/falcon/efx.c         | 12 +++--
 drivers/net/ethernet/sfc/siena/efx.c          |  3 +-
 drivers/net/ethernet/sfc/siena/efx_common.c   |  7 +--
 drivers/net/ethernet/socionext/sni_ave.c      |  6 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  3 +-
 drivers/net/ethernet/sun/cassini.c            |  6 ++-
 drivers/net/ethernet/sun/niu.c                |  3 +-
 drivers/net/ethernet/sun/sunhme.c             | 12 +++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |  4 +-
 drivers/net/ethernet/ti/cpsw.c                |  6 ++-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  3 +-
 drivers/net/ethernet/toshiba/spider_net.c     |  6 ++-
 drivers/net/ethernet/via/via-rhine.c          |  6 ++-
 drivers/net/hyperv/rndis_filter.c             |  7 ++-
 drivers/net/ifb.c                             |  3 +-
 drivers/net/ipvlan/ipvlan_main.c              |  9 +++-
 drivers/net/macsec.c                          | 10 ++--
 drivers/net/macvlan.c                         | 13 +++--
 drivers/net/netdevsim/netdev.c                |  2 +-
 drivers/net/team/team.c                       |  6 +--
 drivers/net/tun.c                             |  8 ++-
 drivers/net/usb/cdc_mbim.c                    |  3 +-
 drivers/net/usb/smsc95xx.c                    |  3 +-
 drivers/net/veth.c                            |  6 ++-
 drivers/net/virtio_net.c                      | 16 ++++--
 drivers/net/vmxnet3/vmxnet3_drv.c             | 11 ++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 18 ++++---
 drivers/net/wireless/ath/ath6kl/main.c        |  9 ++--
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |  6 ++-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  6 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  5 +-
 drivers/net/xen-netback/interface.c           |  3 +-
 drivers/staging/octeon/ethernet.c             |  6 ++-
 include/linux/netdev_features_helper.h        |  7 ++-
 net/8021q/vlan.h                              | 17 ++++---
 net/8021q/vlan_dev.c                          | 14 +++--
 net/core/dev.c                                | 51 +++++++++++++------
 net/core/pktgen.c                             |  6 ++-
 net/core/skbuff.c                             |  2 +-
 net/core/sock.c                               |  3 +-
 net/dccp/ipv6.c                               |  5 +-
 net/dsa/slave.c                               |  9 ++--
 net/ethtool/features.c                        |  4 +-
 net/ethtool/ioctl.c                           | 47 ++++++++++++-----
 net/ipv4/esp4_offload.c                       | 16 +++---
 net/ipv4/ip_output.c                          |  3 +-
 net/ipv4/udp_offload.c                        |  6 +--
 net/ipv6/esp6_offload.c                       | 14 ++---
 net/ipv6/ip6_output.c                         |  3 +-
 net/mac80211/iface.c                          |  6 ++-
 net/openvswitch/vport-internal_dev.c          |  3 +-
 net/tls/tls_device.c                          |  2 +-
 net/xfrm/xfrm_device.c                        | 10 ++--
 128 files changed, 641 insertions(+), 363 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 4d917762352f..b69b918b2c39 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -218,8 +218,10 @@ static netdev_features_t ipoib_fix_features(struct net_device *dev, netdev_featu
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
 
-	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags))
-		features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
+	if (test_bit(IPOIB_FLAG_ADMIN_CM, &priv->flags)) {
+		features &= ~NETIF_F_IP_CSUM;
+		features &= ~NETIF_F_TSO;
+	}
 
 	return features;
 }
@@ -1853,7 +1855,8 @@ static void ipoib_set_dev_features(struct ipoib_dev_priv *priv)
 	priv->kernel_caps = priv->ca->attrs.kernel_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
-		priv->dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		priv->dev->hw_features |= NETIF_F_IP_CSUM;
+		priv->dev->hw_features |= NETIF_F_RXCSUM;
 
 		if (priv->kernel_caps & IBK_UD_TSO)
 			priv->dev->hw_features |= NETIF_F_TSO;
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index ca23f18fa7fc..edbeaac3f678 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1498,8 +1498,8 @@ static void bond_compute_features(struct bonding *bond)
 
 done:
 	bond_dev->vlan_features = vlan_features;
-	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL |
-				    netdev_tx_vlan_features;
+	bond_dev->hw_enc_features = enc_features | NETIF_F_GSO_ENCAP_ALL;
+	bond_dev->hw_enc_features |= netdev_tx_vlan_features;
 #ifdef CONFIG_XFRM_OFFLOAD
 	bond_dev->hw_enc_features |= xfrm_features;
 #endif /* CONFIG_XFRM_OFFLOAD */
@@ -5765,9 +5765,9 @@ void bond_setup(struct net_device *bond_dev)
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
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index ccf07667aa5e..900435ea2c10 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -1448,7 +1448,8 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 		if (card_idx < MAX_UNITS &&
 		    ((hw_checksums[card_idx] == -1 && (vp->drv_flags & HAS_HWCKSM)) ||
 				hw_checksums[card_idx] == 1)) {
-			dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
+			dev->features |= NETIF_F_IP_CSUM;
+			dev->features |= NETIF_F_SG;
 		}
 	} else
 		dev->netdev_ops =  &vortex_netdev_ops;
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index 8f0a6b9c518e..f19be1f78848 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -684,12 +684,15 @@ static int starfire_init_one(struct pci_dev *pdev,
 
 #ifdef ZEROCOPY
 	/* Starfire can do TCP/UDP checksumming */
-	if (enable_hw_cksum)
-		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
+	if (enable_hw_cksum) {
+		dev->features |= NETIF_F_IP_CSUM;
+		dev->features |= NETIF_F_SG;
+	}
 #endif /* ZEROCOPY */
 
 #ifdef VLAN_SUPPORT
-	dev->features |= NETIF_F_HW_VLAN_CTAG_RX | NETIF_F_HW_VLAN_CTAG_FILTER;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 #endif /* VLAN_RX_KILL_VID */
 #ifdef ADDR_64BITS
 	dev->features |= NETIF_F_HIGHDMA;
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index dca85429a0ea..8a2c87778e96 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1490,7 +1490,8 @@ static int greth_of_probe(struct platform_device *ofdev)
 	if (greth->gbit_mac) {
 		netdev_hw_features_zero(dev);
 		netdev_hw_features_set_array(dev, &greth_hw_feature_set);
-		dev->features = dev->hw_features | NETIF_F_HIGHDMA;
+		dev->features = dev->hw_features;
+		dev->features |= NETIF_F_HIGHDMA;
 		greth_netdev_ops.ndo_start_xmit = greth_start_xmit_gbit;
 	}
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 8c5828582c21..6dea777c8b98 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1557,7 +1557,8 @@ static int altera_tse_probe(struct platform_device *pdev)
 	 * so it is turned off
 	 */
 	ndev->hw_features &= ~NETIF_F_SG;
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
+	ndev->features |= ndev->hw_features;
+	ndev->features |=  NETIF_F_HIGHDMA;
 
 	/* VLAN offloading of tagging, stripping and filtering is not
 	 * supported by hardware, but driver will accommodate the
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 135c6e95b6f1..ce0e2fa3eb63 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2183,7 +2183,8 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	netdev_features_t vxlan_base;
 
-	vxlan_base = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_RX_UDP_TUNNEL_PORT;
+	vxlan_base = NETIF_F_GSO_UDP_TUNNEL;
+	vxlan_base |= NETIF_F_RX_UDP_TUNNEL_PORT;
 
 	if (!pdata->hw_feat.vxn)
 		return features;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index a5c4fb8aa676..f08f983cc13a 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -382,8 +382,8 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 		netdev_hw_enc_features_set_array(netdev,
 						 &xgbe_hw_enc_feature_set);
 
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				       NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
 		netdev->udp_tunnel_nic_info = xgbe_get_udp_tunnel_info();
 	}
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index d022b6db9e06..739110c9f836 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -648,8 +648,8 @@ static int xge_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	ndev->netdev_ops = &xgene_ndev_ops;
 
-	ndev->features |= NETIF_F_GSO |
-			  NETIF_F_GRO;
+	ndev->features |= NETIF_F_GSO;
+	ndev->features |= NETIF_F_GRO;
 
 	ret = xge_get_resources(pdata);
 	if (ret)
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 49a35bd4c16d..65bba455a69f 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -2069,7 +2069,8 @@ static int xgene_enet_probe(struct platform_device *pdev)
 	spin_lock_init(&pdata->mac_lock);
 
 	if (pdata->phy_mode == PHY_INTERFACE_MODE_XGMII) {
-		ndev->features |= NETIF_F_TSO | NETIF_F_RXCSUM;
+		ndev->features |= NETIF_F_TSO;
+		ndev->features |= NETIF_F_RXCSUM;
 		spin_lock_init(&pdata->mss_lock);
 	}
 	ndev->hw_features = ndev->features;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 1d54ee4f6147..a9c7b29aadf8 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2638,8 +2638,9 @@ static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	/* TODO: add when ready */
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &atl1c_hw_feature_set);
-	netdev->features =	netdev->hw_features	|
-				NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 0aaca5a1f87c..d615afd95091 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -2277,9 +2277,11 @@ static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &atl1e_hw_feature_set);
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_TX;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX;
 	/* not enabled by default */
-	netdev->hw_features |= NETIF_F_RXALL | NETIF_F_RXFCS;
+	netdev->hw_features |= NETIF_F_RXALL;
+	netdev->hw_features |= NETIF_F_RXFCS;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 4a03b8c9f37a..bd548249c2f2 100644
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
@@ -8592,8 +8596,10 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_array(dev, &bnx2_hw_feature_set);
 
-	if (BNX2_CHIP(bp) == BNX2_CHIP_5709)
-		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+	if (BNX2_CHIP(bp) == BNX2_CHIP_5709) {
+		dev->hw_features |= NETIF_F_IPV6_CSUM;
+		dev->hw_features |= NETIF_F_TSO6;
+	}
 
 	dev->vlan_features = dev->hw_features;
 	dev->hw_features |= netdev_ctag_vlan_offload_features;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 712b5595bc39..e68d77d9ae50 100644
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
index 845d31294667..1986fde63919 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12350,8 +12350,10 @@ static int bnx2x_init_bp(struct bnx2x *bp)
 
 	/* Set TPA flags */
 	if (bp->disable_tpa) {
-		bp->dev->hw_features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
-		bp->dev->features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		bp->dev->hw_features &= ~NETIF_F_LRO;
+		bp->dev->hw_features &= ~NETIF_F_GRO_HW;
+		bp->dev->features &= ~NETIF_F_LRO;
+		bp->dev->features &= ~NETIF_F_GRO_HW;
 	}
 
 	if (CHIP_IS_E1(bp))
@@ -13275,7 +13277,8 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 	 * getting a response to CHANNEL_TLV_ACQUIRE from PF.
 	 */
 
-	dev->features |= dev->hw_features | NETIF_F_HW_VLAN_CTAG_RX;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 	dev->features |= NETIF_F_HIGHDMA;
 	if (dev->features & NETIF_F_LRO)
 		dev->features &= ~NETIF_F_GRO_HW;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 37e2018fd875..150630a2b207 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11179,11 +11179,15 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	if ((features & NETIF_F_NTUPLE) && !bnxt_rfs_capable(bp))
 		features &= ~NETIF_F_NTUPLE;
 
-	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
-		features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS) {
+		features &= ~NETIF_F_LRO;
+		features &= ~NETIF_F_GRO_HW;
+	}
 
-	if (!(bp->flags & BNXT_FLAG_TPA))
-		features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+	if (!(bp->flags & BNXT_FLAG_TPA)) {
+		features &= ~NETIF_F_LRO;
+		features &= ~NETIF_F_GRO_HW;
+	}
 
 	if (!(features & NETIF_F_GRO))
 		features &= ~NETIF_F_GRO_HW;
@@ -13271,8 +13275,10 @@ static int bnxt_get_dflt_rings(struct bnxt *bp, int *max_rx, int *max_tx,
 			return rc;
 		}
 		bp->flags |= BNXT_FLAG_NO_AGG_RINGS;
-		bp->dev->hw_features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
-		bp->dev->features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+		bp->dev->hw_features &= ~NETIF_F_LRO;
+		bp->dev->hw_features &= ~NETIF_F_GRO_HW;
+		bp->dev->features &= ~NETIF_F_LRO;
+		bp->dev->features &= ~NETIF_F_GRO_HW;
 		bnxt_set_ring_params(bp);
 	}
 
@@ -13639,14 +13645,16 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_gso_partial_features_zero(dev);
 	netdev_gso_partial_features_set_array(dev, &bnxt_gso_partial_feature_set);
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
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 3a7bb3db4e47..72a9b1f38cab 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17725,7 +17725,9 @@ static int tg3_init_one(struct pci_dev *pdev,
 	 * to hardware bugs.
 	 */
 	if (tg3_chip_rev_id(tp) != CHIPREV_ID_5700_B0) {
-		features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		features |= NETIF_F_SG;
+		features |= NETIF_F_IP_CSUM;
+		features |= NETIF_F_RXCSUM;
 
 		if (tg3_flag(tp, 5755_PLUS))
 			features |= NETIF_F_IPV6_CSUM;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 494fe961a49d..4cac5e3a1929 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -82,7 +82,6 @@ struct sifive_fu540_macb_mgmt {
 #define GEM_MAX_TX_LEN		(unsigned int)(0x3FC0)
 
 #define GEM_MTU_MIN_SIZE	ETH_MIN_MTU
-#define MACB_NETIF_LSO		NETIF_F_TSO
 
 #define MACB_WOL_HAS_MAGIC_PACKET	(0x1 << 0)
 #define MACB_WOL_ENABLED		(0x1 << 1)
@@ -2148,8 +2147,10 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
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
@@ -2157,8 +2158,10 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
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
@@ -4052,11 +4055,13 @@ static int macb_init(struct platform_device *pdev)
 
 	/* Check LSO capability */
 	if (GEM_BFEXT(PBUF_LSO, gem_readl(bp, DCFG6)))
-		dev->hw_features |= MACB_NETIF_LSO;
+		dev->hw_features |= NETIF_F_TSO;
 
 	/* Checksum offload is only available on gem with packet buffer */
-	if (macb_is_gem(bp) && !(bp->caps & MACB_CAPS_FIFO_MODE))
-		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_RXCSUM;
+	if (macb_is_gem(bp) && !(bp->caps & MACB_CAPS_FIFO_MODE)) {
+		dev->hw_features |= NETIF_F_HW_CSUM;
+		dev->hw_features |= NETIF_F_RXCSUM;
+	}
 	if (bp->caps & MACB_CAPS_SG_DISABLED)
 		dev->hw_features &= ~NETIF_F_SG;
 	dev->features = dev->hw_features;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index b5a963c9dc03..3271b8e9b392 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3590,8 +3590,8 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		netdev_features_set_array(&liquidio_enc_feature_set,
 					  &lio->enc_dev_capability);
 
-		netdev->hw_enc_features = (lio->enc_dev_capability &
-					   ~NETIF_F_LRO);
+		netdev->hw_enc_features = lio->enc_dev_capability;
+		netdev->hw_enc_features &= ~NETIF_F_LRO;
 
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
@@ -3601,12 +3601,12 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
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
index 23524066fa9a..688a6c4931b9 100644
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
@@ -2121,15 +2122,16 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 		netdev_features_set_array(&lio_enc_feature_set,
 					  &lio->enc_dev_capability);
 
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
index 80f65f491b3f..7bbec0a182c3 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3320,11 +3320,12 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->mem_end = mmio_start + mmio_len - 1;
 		netdev_hw_features_zero(netdev);
 		netdev_hw_features_set_array(netdev, &cxgb_hw_feature_set);
-		netdev->features |= netdev->hw_features |
-				    NETIF_F_HW_VLAN_CTAG_TX;
+		netdev->features |= netdev->hw_features;
+		netdev->features |= NETIF_F_HW_VLAN_CTAG_TX;
 		netdev_features_zero(&vlan_feat);
 		netdev_features_set_array(&cxgb_vlan_feature_set, &vlan_feat);
-		netdev->vlan_features |= netdev->features & vlan_feat;
+		vlan_feat &= netdev->features;
+		netdev->vlan_features |= vlan_feat;
 
 		netdev->features |= NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7e61049247b9..4df2af4c2e05 100644
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
index 2d6e1b42b36b..0d1d361fc246 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3092,7 +3092,8 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 					  &tso_features);
 		netdev->hw_features = tso_features;
 		netdev_hw_features_set_array(netdev, &cxgb4vf_hw_feature_set);
-		netdev->features = netdev->hw_features | NETIF_F_HIGHDMA;
+		netdev->features = netdev->hw_features;
+		netdev->features |= NETIF_F_HIGHDMA;
 		vlan_features = tso_features;
 		netdev_features_set_array(&cxgb4vf_vlan_feature_set,
 					  &vlan_features);
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 061375f34d5d..4f851d446716 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2901,8 +2901,10 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		enic->loop_tag = enic->config.loop_tag;
 		dev_info(dev, "loopback tag=0x%04x\n", enic->loop_tag);
 	}
-	if (ENIC_SETTING(enic, TXCSUM))
-		netdev->hw_features |= NETIF_F_SG | NETIF_F_HW_CSUM;
+	if (ENIC_SETTING(enic, TXCSUM)) {
+		netdev->hw_features |= NETIF_F_SG;
+		netdev->hw_features |= NETIF_F_HW_CSUM;
+	}
 	if (ENIC_SETTING(enic, TSO)) {
 		netdev->hw_features |= netdev_general_tso_features;
 		netdev->hw_features |= NETIF_F_TSO_ECN;
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index d2b0296b426a..dcadafd7cdaa 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2471,7 +2471,8 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	gmac_clear_hw_stats(netdev);
 
 	netdev->hw_features = GMAC_OFFLOAD_FEATURES;
-	netdev->features |= GMAC_OFFLOAD_FEATURES | NETIF_F_GRO;
+	netdev->features |= GMAC_OFFLOAD_FEATURES;
+	netdev->features |= NETIF_F_GRO;
 	/* We can handle jumbo frames up to 10236 bytes so, let's accept
 	 * payloads of 10236 bytes minus VLAN and ethernet header
 	 */
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 0985ab216566..363490713825 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1644,7 +1644,8 @@ dm9000_probe(struct platform_device *pdev)
 
 	/* dm9000a/b are capable of hardware checksum offload */
 	if (db->type == TYPE_DM9000A || db->type == TYPE_DM9000B) {
-		ndev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
+		ndev->hw_features = NETIF_F_RXCSUM;
+		ndev->hw_features |= NETIF_F_IP_CSUM;
 		ndev->features |= ndev->hw_features;
 	}
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 8c95ad9df5e5..3cdc5d827f14 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1953,8 +1953,10 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	if (priv->use_ncsi && of_device_is_compatible(np, "aspeed,ast2600-mac"))
 		netdev->hw_features &= ~NETIF_F_HW_CSUM;
 
-	if (np && of_get_property(np, "no-hw-checksum", NULL))
-		netdev->hw_features &= ~(NETIF_F_HW_CSUM | NETIF_F_RXCSUM);
+	if (np && of_get_property(np, "no-hw-checksum", NULL)) {
+		netdev->hw_features &= ~NETIF_F_HW_CSUM;
+		netdev->hw_features &= ~NETIF_F_RXCSUM;
+	}
 	netdev->features |= netdev->hw_features;
 
 	/* register network device */
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index d9b1928d1987..dcf30e6dd012 100644
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
index b4b1b7b7143f..8c541070ffe0 100644
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
index 537daf19f7f6..4bfc6dab65f4 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1788,12 +1788,15 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 	netdev_features_set_array(&fun_vlan_feature_set, &vlan_feat);
 
 	netdev_hw_features_set_array(netdev, &fun_hw_feature_set);
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
index 3213322fcb08..c59026807723 100644
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
@@ -3284,6 +3284,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	struct pci_dev *pdev = h->pdev;
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
 	netdev_features_t vlan_off_features;
+	netdev_features_t features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
@@ -3319,9 +3320,11 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev_features_zero(&vlan_off_features);
 	netdev_features_set_array(&hns3_vlan_off_feature_set,
 				  &vlan_off_features);
-	netdev->vlan_features |= netdev->features & ~vlan_off_features;
+	features = netdev->features & ~vlan_off_features;
+	netdev->vlan_features |= features;
 
-	netdev->hw_enc_features |= netdev->vlan_features | NETIF_F_TSO_MANGLEID;
+	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index b8db3b423a5b..80d14a014d2d 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -948,7 +948,8 @@ static void netdev_features_init(struct net_device *netdev)
 
 	netdev->vlan_features = netdev->hw_features;
 
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	netdev_hw_enc_features_zero(netdev);
 	netdev_hw_enc_features_set_array(netdev, &hinic_hw_enc_feature_set);
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 6b026ba0f262..17b5e0806aa6 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3177,7 +3177,8 @@ static int emac_probe(struct platform_device *ofdev)
 	if (dev->tah_dev) {
 		netdev_hw_features_zero(ndev);
 		netdev_hw_features_set_array(ndev, &emac_hw_feature_set);
-		ndev->features |= ndev->hw_features | NETIF_F_RXCSUM;
+		ndev->features |= ndev->hw_features;
+		ndev->features |= NETIF_F_RXCSUM;
 	}
 	ndev->watchdog_timeo = 5 * HZ;
 	if (emac_phy_supports_gige(dev->phy_mode)) {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 32ad4087a43d..3533ae7c92f7 100644
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
index 43f12a96cf90..598f5b9d9025 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4900,10 +4900,10 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
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
index 11a884aa5082..2809f6c0f69a 100644
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
index 07670cabf19f..9564fdef837d 100644
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
index b905eced9d91..d7d628af7435 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13689,14 +13689,15 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev->hw_enc_features |= hw_enc_features;
 
 	/* record features VLANs can make use of */
-	netdev->vlan_features |= hw_enc_features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= hw_enc_features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 
 	netdev_features_zero(&gso_partial_features);
 	netdev_features_set_array(&i40e_gso_partial_feature_set,
 				  &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL |
-			    gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev->features |= gso_partial_features;
 
 	netdev_mpls_features_set_array(netdev, &i40e_mpls_feature_set);
 	netdev->mpls_features |= gso_partial_features;
@@ -13706,12 +13707,15 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 
 	hw_features = hw_enc_features | netdev_ctag_vlan_offload_features;
 
-	if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
-		hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
+	if (!(pf->flags & I40E_FLAG_MFP_ENABLED)) {
+		hw_features |= NETIF_F_NTUPLE;
+		hw_features |= NETIF_F_HW_TC;
+	}
 
 	netdev->hw_features |= hw_features;
 
-	netdev->features |= hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->features |= hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
 
 	netdev->features &= ~NETIF_F_HW_TC;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index efbd889eea1a..95dd5a16b553 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4631,7 +4631,8 @@ int iavf_process_config(struct iavf_adapter *adapter)
 		netdev->hw_enc_features |= hw_enc_features;
 	}
 	/* record features VLANs can make use of */
-	netdev->vlan_features |= hw_enc_features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= hw_enc_features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 
 	/* Write features and hw_features separately to avoid polluting
 	 * with, or dropping, features that are set when we registered.
@@ -4647,10 +4648,12 @@ int iavf_process_config(struct iavf_adapter *adapter)
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
index 5c9333da4dfc..107caaac78ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3360,11 +3360,12 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	netdev_features_zero(&tso_features);
 	netdev_features_set_array(&ice_tso_feature_set, &tso_features);
 
-	netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					NETIF_F_GSO_GRE_CSUM;
+	netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 	/* set features that user can change */
-	netdev->hw_features = dflt_features | csumo_features |
-			      vlano_features | tso_features;
+	netdev->hw_features = dflt_features | csumo_features;
+	netdev->hw_features |= vlano_features;
+	netdev->hw_features |= tso_features;
 
 	/* add support for HW_CSUM on packets with MPLS header */
 	netdev_mpls_features_zero(netdev);
@@ -3377,10 +3378,12 @@ static void ice_set_netdev_features(struct net_device *netdev)
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
@@ -5897,14 +5900,15 @@ ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
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
 		err = ice_set_vlan_offload_features(vsi, features);
 		if (err)
 			return err;
@@ -5913,7 +5917,8 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
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
index 578663a47c93..3d0af1c6d13e 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2455,7 +2455,7 @@ static int igb_set_features(struct net_device *netdev,
 	if (changed & NETIF_F_HW_VLAN_CTAG_RX)
 		igb_vlan_mode(netdev, features);
 
-	if (!(changed & (NETIF_F_RXALL | NETIF_F_NTUPLE)))
+	if (!(changed & NETIF_F_RXALL) && !(changed & NETIF_F_NTUPLE))
 		return 0;
 
 	if (!(features & NETIF_F_NTUPLE)) {
@@ -3298,8 +3298,10 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	netdev_active_features_set_array(netdev, &igb_feature_set);
 
-	if (hw->mac.type >= e1000_82576)
-		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
+	if (hw->mac.type >= e1000_82576) {
+		netdev->features |= NETIF_F_SCTP_CRC;
+		netdev->features |= NETIF_F_GSO_UDP_L4;
+	}
 
 	if (hw->mac.type >= e1000_i350)
 		netdev->features |= NETIF_F_HW_TC;
@@ -3307,7 +3309,8 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_features_zero(&gso_partial_features);
 	netdev_features_set_array(&igb_feature_set, &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev->features |= gso_partial_features;
 
 	/* copy netdev features into list of user selectable features */
 	netdev->hw_features |= netdev->features;
@@ -3319,7 +3322,8 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
 	netdev->hw_enc_features |= netdev->vlan_features;
 
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 07c725474e32..6994f573fadf 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2794,11 +2794,14 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				  &gso_partial_features);
 
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
index e5b97822e191..805243e7c4cb 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4958,7 +4958,7 @@ static int igc_set_features(struct net_device *netdev,
 		igc_vlan_mode(netdev, features);
 
 	/* Add VLAN support */
-	if (!(changed & (NETIF_F_RXALL | NETIF_F_NTUPLE)))
+	if (!(changed & NETIF_F_RXALL) && !(changed & NETIF_F_NTUPLE))
 		return 0;
 
 	if (!(features & NETIF_F_NTUPLE))
@@ -6335,7 +6335,8 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev_features_set_array(&igc_gso_partial_feature_set,
 				  &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL | gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev->features |= gso_partial_features;
 
 	/* setup the private structure */
 	err = igc_sw_init(adapter);
@@ -6350,7 +6351,8 @@ static int igc_probe(struct pci_dev *pdev,
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 	netdev->mpls_features |= NETIF_F_HW_CSUM;
 	netdev->hw_enc_features |= netdev->vlan_features;
 
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index c3ae375f04dd..d23b7a10d62f 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -313,7 +313,7 @@ ixgb_set_features(struct net_device *netdev, netdev_features_t features)
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed = features ^ netdev->features;
 
-	if (!(changed & (NETIF_F_RXCSUM|NETIF_F_HW_VLAN_CTAG_RX)))
+	if (!(changed & NETIF_F_RXCSUM) && !(changed & NETIF_F_HW_VLAN_CTAG_RX))
 		return 0;
 
 	adapter->rx_csum = !!(features & NETIF_F_RXCSUM);
@@ -438,8 +438,8 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &ixgb_hw_feature_set);
-	netdev->features = netdev->hw_features |
-			   NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features |= NETIF_F_RXCSUM;
 
 	netdev->features |= NETIF_F_HIGHDMA;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index db008c8281ed..0b6b5cfa84df 100644
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
@@ -11020,11 +11021,13 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				  &gso_partial_features);
 
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL |
-			    gso_partial_features;
+	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev->features |= gso_partial_features;
 
-	if (hw->mac.type >= ixgbe_mac_82599EB)
-		netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_GSO_UDP_L4;
+	if (hw->mac.type >= ixgbe_mac_82599EB) {
+		netdev->features |= NETIF_F_SCTP_CRC;
+		netdev->features |= NETIF_F_GSO_UDP_L4;
+	}
 
 #ifdef CONFIG_IXGBE_IPSEC
 	if (adapter->ipsec)
@@ -11034,13 +11037,15 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->hw_features |= netdev->features;
 	netdev_hw_features_set_array(netdev, &ixgbe_hw_feature_set);
 
-	if (hw->mac.type >= ixgbe_mac_82599EB)
-		netdev->hw_features |= NETIF_F_NTUPLE |
-				       NETIF_F_HW_TC;
+	if (hw->mac.type >= ixgbe_mac_82599EB) {
+		netdev->hw_features |= NETIF_F_NTUPLE;
+		netdev->hw_features |= NETIF_F_HW_TC;
+	}
 
 	netdev->features |= NETIF_F_HIGHDMA;
 
-	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
 	netdev->hw_enc_features |= netdev->vlan_features;
 	netdev_mpls_features_set_array(netdev, &ixgbe_mpls_feature_set);
 	netdev->mpls_features |= gso_partial_features;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index d46ab40b2b98..db20be0b4fb1 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4633,12 +4633,14 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_features_set_array(&ixgbevf_gso_partial_feature_set,
 				  &gso_partial_features);
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
 
 	netdev_mpls_features_set_array(netdev, &ixgbevf_mpls_feature_set);
 	netdev->mpls_features |= gso_partial_features;
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 6db2f01468c5..96f2402f6cb4 100644
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
 
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index b097a857fe4e..3b9c7257622d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3848,7 +3848,8 @@ static netdev_features_t mvneta_fix_features(struct net_device *dev,
 	struct mvneta_port *pp = netdev_priv(dev);
 
 	if (pp->tx_csum_limit && dev->mtu > pp->tx_csum_limit) {
-		features &= ~(NETIF_F_IP_CSUM | NETIF_F_TSO);
+		features &= ~NETIF_F_IP_CSUM;
+		features &= ~NETIF_F_TSO;
 		netdev_info(dev,
 			    "Disable IP checksum for MTU greater than %dB\n",
 			    pp->tx_csum_limit);
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d693c6580e27..8aa5dd6cce91 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6858,7 +6858,8 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 
 	netdev_features_zero(&features);
 	netdev_features_set_array(&mvpp2_feature_set, &features);
-	dev->features = features | NETIF_F_RXCSUM;
+	dev->features = features;
+	dev->features |= NETIF_F_RXCSUM;
 	dev->hw_features |= features;
 	netdev_hw_features_set_array(dev, &mvpp2_hw_feature_set);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 172c715415fa..888fb6dde97b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -2728,7 +2728,8 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pf->flags & OTX2_FLAG_TC_FLOWER_SUPPORT)
 		netdev->hw_features |= NETIF_F_HW_TC;
 
-	netdev->hw_features |= NETIF_F_LOOPBACK | NETIF_F_RXALL;
+	netdev->hw_features |= NETIF_F_LOOPBACK;
+	netdev->hw_features |= NETIF_F_RXALL;
 
 	netif_set_tso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index ede3e53b9790..23dde8129492 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -622,7 +622,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_dl_port_register;
 
-	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_HW_TC;
+	dev->features |= NETIF_F_NETNS_LOCAL;
+	dev->features |= NETIF_F_HW_TC;
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
 	SET_NETDEV_DEV(dev, sw->dev->dev);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index c9a4b1db43eb..98574f083375 100644
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
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 019dbd5ae79f..c73fcb4a15f3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3382,8 +3382,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	netdev_hw_features_set_array(dev, &mlx4_hw_feature_set3);
 
 	if (!(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN)) {
-		dev->features |= NETIF_F_HW_VLAN_STAG_RX |
-			NETIF_F_HW_VLAN_STAG_FILTER;
+		dev->features |= NETIF_F_HW_VLAN_STAG_RX;
+		dev->features |= NETIF_F_HW_VLAN_STAG_FILTER;
 		dev->hw_features |= NETIF_F_HW_VLAN_STAG_RX;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c32468f81500..3c8d059c8484 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4921,31 +4921,31 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev)) {
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL |
-					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-		netdev->hw_features     |= NETIF_F_GSO_GRE |
-					   NETIF_F_GSO_GRE_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE |
-					   NETIF_F_GSO_GRE_CSUM;
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE |
-						NETIF_F_GSO_GRE_CSUM;
+		netdev->hw_features     |= NETIF_F_GSO_GRE;
+		netdev->hw_features     |= NETIF_F_GSO_GRE_CSUM;
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE_CSUM;
+		netdev->gso_partial_features |= NETIF_F_GSO_GRE;
+		netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
-		netdev->hw_features |= NETIF_F_GSO_IPXIP4 |
-				       NETIF_F_GSO_IPXIP6;
-		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4 |
-					   NETIF_F_GSO_IPXIP6;
-		netdev->gso_partial_features |= NETIF_F_GSO_IPXIP4 |
-						NETIF_F_GSO_IPXIP6;
+		netdev->hw_features |= NETIF_F_GSO_IPXIP4;
+		netdev->hw_features |= NETIF_F_GSO_IPXIP6;
+		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4;
+		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP6;
+		netdev->gso_partial_features |= NETIF_F_GSO_IPXIP4;
+		netdev->gso_partial_features |= NETIF_F_GSO_IPXIP6;
 	}
 
 	netdev->gso_partial_features             |= NETIF_F_GSO_UDP_L4;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 0f88dac6920a..353a25f001e7 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -843,7 +843,7 @@ static int ocelot_set_features(struct net_device *dev,
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
 
-	if ((dev->features & NETIF_F_HW_TC) > (features & NETIF_F_HW_TC) &&
+	if ((dev->features & NETIF_F_HW_TC) && !(features & NETIF_F_HW_TC) &&
 	    priv->tc.offload_cnt) {
 		netdev_err(dev,
 			   "Cannot disable HW TC offload while offloads active\n");
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index e1a5e80e1704..2a4e49122b5c 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -1289,8 +1289,7 @@ myri10ge_vlan_rx(struct net_device *dev, void *addr, struct sk_buff *skb)
 	va = addr;
 	va += MXGEFW_PAD;
 	veh = (struct vlan_ethhdr *)va;
-	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) ==
-	    NETIF_F_HW_VLAN_CTAG_RX &&
+	if ((dev->features & NETIF_F_HW_VLAN_CTAG_RX) &&
 	    veh->h_vlan_proto == htons(ETH_P_8021Q)) {
 		/* fixup csum if needed */
 		if (skb->ip_summed == CHECKSUM_COMPLETE) {
@@ -3868,12 +3867,14 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
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
index 79dd414f6e36..8b3def9866d0 100644
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
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index bcf89fe69cc4..29611221990f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2374,9 +2374,10 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		netdev->hw_features |= NETIF_F_RXHASH;
 	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO) {
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-					       NETIF_F_GSO_UDP_TUNNEL_CSUM |
-					       NETIF_F_GSO_PARTIAL;
+			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev->hw_features |= NETIF_F_GSO_PARTIAL;
+
 			netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		}
 		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 3e670133e27a..48da1da1c704 100644
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
index 5b957cdc118e..a8a8d59dd008 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -6124,7 +6124,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 
 	dev_info(&pci_dev->dev, "%s%s%s%s%s%s%s%s%s%s%sdesc-v%u\n",
 		 dev->features & NETIF_F_HIGHDMA ? "highdma " : "",
-		 dev->features & (NETIF_F_IP_CSUM | NETIF_F_SG) ?
+		 (dev->features & NETIF_F_IP_CSUM || dev->features & NETIF_F_SG) ?
 			"csum " : "",
 		 dev->features & netdev_ctag_vlan_offload_features ?
 			"vlan " : "",
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 4f2511f763dd..8459002574fc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1547,7 +1547,8 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 
 	netdev->hw_features |= netdev->hw_enc_features;
 	netdev->features |= netdev->hw_features;
-	netdev->vlan_features |= netdev->features & ~NETIF_F_VLAN_FEATURES;
+	features = netdev->features & ~NETIF_F_VLAN_FEATURES;
+	netdev->vlan_features |= features;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT |
 			      IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 993d0ee6db01..1c3b06599b37 100644
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
@@ -1357,8 +1359,10 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &netxen_hw_feature_set);
 
-	if (NX_IS_REVISION_P3(adapter->ahw.revision_id))
-		netdev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+	if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
+		netdev->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev->hw_features |= NETIF_F_TSO6;
+	}
 
 	netdev->vlan_features |= netdev->hw_features;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 04af61f4122a..b37a045f09d6 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -897,18 +897,19 @@ static void qede_init_ndev(struct qede_dev *edev)
 	}
 
 	if (udp_tunnel_enable) {
-		hw_features |= (NETIF_F_GSO_UDP_TUNNEL |
-				NETIF_F_GSO_UDP_TUNNEL_CSUM);
-		ndev->hw_enc_features |= (NETIF_F_GSO_UDP_TUNNEL |
-					  NETIF_F_GSO_UDP_TUNNEL_CSUM);
+		hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+		hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		ndev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+		ndev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 
 		qede_set_udp_tunnels(edev);
 	}
 
 	if (edev->dev_info.common.gre_enable) {
-		hw_features |= (NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM);
-		ndev->hw_enc_features |= (NETIF_F_GSO_GRE |
-					  NETIF_F_GSO_GRE_CSUM);
+		hw_features |= NETIF_F_GSO_GRE;
+		hw_features |= NETIF_F_GSO_GRE_CSUM;
+		ndev->hw_enc_features |= NETIF_F_GSO_GRE;
+		ndev->hw_enc_features |= NETIF_F_GSO_GRE_CSUM;
 	}
 
 	ndev->vlan_features = hw_features;
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 06f4d9a9e938..fe823b03736b 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -3795,8 +3795,10 @@ static int ql3xxx_probe(struct pci_dev *pdev,
 	qdev->msg_enable = netif_msg_init(debug, default_msg);
 
 	ndev->features |= NETIF_F_HIGHDMA;
-	if (qdev->device_id == QL3032_DEVICE_ID)
-		ndev->features |= NETIF_F_IP_CSUM | NETIF_F_SG;
+	if (qdev->device_id == QL3032_DEVICE_ID) {
+		ndev->features |= NETIF_F_IP_CSUM;
+		ndev->features |= NETIF_F_SG;
+	}
 
 	qdev->mem_map_registers = pci_ioremap_bar(pdev, 1);
 	if (!qdev->mem_map_registers) {
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 7039925bc566..9bb1b9d53d96 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1078,7 +1078,8 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 			netdev_features_zero(&changeable);
 			netdev_features_set_array(&qlcnic_changable_feature_set,
 						  &changeable);
-			features ^= changed & changeable;
+			changed &= changeable;
+			features ^= changed;
 		}
 	}
 
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index c5c2e491d251..1a4e97594238 100644
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
index 3844a0f418ec..fb4437f4ae35 100644
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
index 55f67e0c1280..ef8b13d342f5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1446,8 +1446,10 @@ static netdev_features_t rtl8169_fix_features(struct net_device *dev,
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
@@ -5456,7 +5458,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
 		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V2);
 	} else {
-		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO;
+		dev->hw_features |= NETIF_F_SG;
+		dev->hw_features |= NETIF_F_TSO;
 		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V1);
 		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V1);
 	}
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index fc83ec23bd1d..2a16201ce0cf 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2578,7 +2578,8 @@ static int rocker_probe_port(struct rocker *rocker, unsigned int port_number)
 		       NAPI_POLL_WEIGHT);
 	rocker_carrier_init(rocker_port);
 
-	dev->features |= NETIF_F_NETNS_LOCAL | NETIF_F_SG;
+	dev->features |= NETIF_F_NETNS_LOCAL;
+	dev->features |= NETIF_F_SG;
 
 	/* MTU range: 68 - 9000 */
 	dev->min_mtu = ROCKER_PORT_MIN_MTU;
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 30af142820c6..7963a9aeafe0 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2117,7 +2117,8 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 
 	netdev_hw_features_zero(ndev);
 	netdev_hw_features_set_array(ndev, &sxgbe_hw_feature_set);
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
+	ndev->features |= ndev->hw_features;
+	ndev->features |= NETIF_F_HIGHDMA;
 	ndev->watchdog_timeo = msecs_to_jiffies(TX_TIMEO);
 
 	/* assign filtering support */
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 064d6f224af8..dd8e278f8d8d 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1366,7 +1366,8 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		netdev_features_set_array(&ef10_tso_feature_set,
 					  &encap_tso_features);
 
-		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
+		hw_enc_features |= encap_tso_features;
+		hw_enc_features |= NETIF_F_TSO;
 		efx->net_dev->features |= encap_tso_features;
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 897a0113e257..4c802cd087fc 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1001,6 +1001,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 {
 	struct net_device *net_dev = efx->net_dev;
 	int rc = efx_pci_probe_main(efx);
+	netdev_features_t tmp;
 
 	if (rc)
 		return rc;
@@ -1015,7 +1016,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	/* Determine netdevice features */
 	net_dev->features |= *efx->type->offload_features;
 	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
-	if (*efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
+	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
 		net_dev->features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
@@ -1024,7 +1026,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	net_dev->vlan_features |= NETIF_F_ALL_TSO;
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
-	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
+	tmp = net_dev->features & ~efx->fixed_features;
+	net_dev->hw_features |= tmp;
 
 	/* Disable receiving frames with bad FCS, by default. */
 	net_dev->features &= ~NETIF_F_RXALL;
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index b6e0e4855821..c3a29d4169c9 100644
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
index 8692dc18efff..0b6dbd33410e 100644
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
@@ -2904,8 +2907,9 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	if (rc)
 		goto fail3;
 
-	net_dev->features |= (*efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_RXCSUM);
+	net_dev->features |= *efx->type->offload_features;
+	net_dev->features |= NETIF_F_SG;
+	net_dev->features |= NETIF_F_RXCSUM;
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 4829f66a47e7..6887ba4c9806 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -998,7 +998,8 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	/* Determine netdevice features */
 	net_dev->features |= *efx->type->offload_features;
 	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
-	if (*efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM))
+	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
+	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
 		net_dev->features |= NETIF_F_TSO6;
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index ef00f1d87876..4c0f915dba82 100644
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
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index f0c8de2c6075..c3aead3d052b 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1594,8 +1594,10 @@ static int ave_probe(struct platform_device *pdev)
 	ndev->ethtool_ops = &ave_ethtool_ops;
 	SET_NETDEV_DEV(ndev, dev);
 
-	ndev->features    |= (NETIF_F_IP_CSUM | NETIF_F_RXCSUM);
-	ndev->hw_features |= (NETIF_F_IP_CSUM | NETIF_F_RXCSUM);
+	ndev->features    |= NETIF_F_IP_CSUM;
+	ndev->features    |= NETIF_F_RXCSUM;
+	ndev->hw_features |= NETIF_F_IP_CSUM;
+	ndev->hw_features |= NETIF_F_RXCSUM;
 
 	ndev->max_mtu = AVE_MAX_ETHFRAME - (ETH_HLEN + ETH_FCS_LEN);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6ddacc6a7f7a..8f227d5f2199 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7194,7 +7194,8 @@ int stmmac_dvr_probe(struct device *device,
 		}
 	}
 
-	ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
+	ndev->features |= ndev->hw_features;
+	ndev->features |= NETIF_F_HIGHDMA;
 	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 0b08b0e085e8..bf899125b1ef 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -5056,8 +5056,10 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->dma = 0;
 
 	/* Cassini features. */
-	if ((cp->cas_flags & CAS_FLAG_NO_HW_CSUM) == 0)
-		dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+	if ((cp->cas_flags & CAS_FLAG_NO_HW_CSUM) == 0) {
+		dev->features |= NETIF_F_HW_CSUM;
+		dev->features |= NETIF_F_SG;
+	}
 
 	dev->features |= NETIF_F_HIGHDMA;
 
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index f7fa28ba5d53..6a37026e02b6 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9743,7 +9743,8 @@ static void niu_set_basic_features(struct net_device *dev)
 {
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_array(dev, &niu_hw_feature_set);
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_RXCSUM;
 }
 
 static int niu_pci_init_one(struct pci_dev *pdev,
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 8594ee839628..f8868f79ee95 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2784,8 +2784,10 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+	dev->hw_features = NETIF_F_SG;
+	dev->hw_features |= NETIF_F_HW_CSUM;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_RXCSUM;
 
 	hp->irq = op->archdata.irqs[0];
 
@@ -3104,8 +3106,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 	dev->ethtool_ops = &hme_ethtool_ops;
 
 	/* Happy Meal can do it all... */
-	dev->hw_features = NETIF_F_SG | NETIF_F_HW_CSUM;
-	dev->features |= dev->hw_features | NETIF_F_RXCSUM;
+	dev->hw_features = NETIF_F_SG;
+	dev->hw_features |= NETIF_F_HW_CSUM;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_RXCSUM;
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
 	/* Hook up PCI register/descriptor accessors. */
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index b390983861d8..2347a3df30cd 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1975,8 +1975,8 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	port->ndev->max_mtu = AM65_CPSW_MAX_PACKET_SIZE;
 	netdev_hw_features_zero(port->ndev);
 	netdev_hw_features_set_array(port->ndev, &am65_cpsw_hw_feature_set);
-	port->ndev->features = port->ndev->hw_features |
-			       NETIF_F_HW_VLAN_CTAG_FILTER;
+	port->ndev->features = port->ndev->hw_features;
+	port->ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	port->ndev->vlan_features |=  NETIF_F_SG;
 	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index ed66c4d4d830..7e12c6a77d30 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1456,7 +1456,8 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 
 	priv_sl2->emac_port = 1;
 	cpsw->slaves[1].ndev = ndev;
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
@@ -1633,7 +1634,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	cpsw->slaves[0].ndev = ndev;
 
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_HW_VLAN_CTAG_RX;
+	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 3dbfb1b20649..5def0b3bf8ef 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1461,7 +1461,8 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 	int status;
 	u64 v1, v2;
 
-	netdev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+	netdev->hw_features = NETIF_F_IP_CSUM;
+	netdev->hw_features |= NETIF_F_RXCSUM;
 
 	netdev->features = NETIF_F_IP_CSUM;
 	if (GELIC_CARD_RX_CSUM_DEFAULT)
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index bc4914c758ad..e2e0e18fcdc8 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2275,10 +2275,12 @@ spider_net_setup_netdev(struct spider_net_card *card)
 
 	spider_net_setup_netdev_ops(netdev);
 
-	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM;
+	netdev->hw_features = NETIF_F_RXCSUM;
+	netdev->hw_features |= NETIF_F_IP_CSUM;
 	if (SPIDER_NET_RX_CSUM_DEFAULT)
 		netdev->features |= NETIF_F_RXCSUM;
-	netdev->features |= NETIF_F_IP_CSUM | NETIF_F_LLTX;
+	netdev->features |= NETIF_F_IP_CSUM;
+	netdev->features |= NETIF_F_LLTX;
 	/* some time: NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 	 *		NETIF_F_HW_VLAN_CTAG_FILTER
 	 */
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 1d795114c264..3c8631f9925d 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -967,8 +967,10 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 
 	netif_napi_add(dev, &rp->napi, rhine_napipoll, 64);
 
-	if (rp->quirks & rqRhineI)
-		dev->features |= NETIF_F_SG|NETIF_F_HW_CSUM;
+	if (rp->quirks & rqRhineI) {
+		dev->features |= NETIF_F_SG;
+		dev->features |= NETIF_F_HW_CSUM;
+	}
 
 	if (rp->quirks & rqMgmt)
 		dev->features |= netdev_ctag_vlan_features;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 6da36cb8af80..456563b6b242 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
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
+	netdev_features_fill(&features);
+	features &= ~NETVSC_SUPPORTED_HW_FEATURES;
+	features |= net->hw_features;
+	net->features &= features;
 
 	netif_set_tso_max_size(net, gso_max_size);
 
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 656a54a9f6e8..370f3fa59587 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -328,7 +328,8 @@ static void ifb_setup(struct net_device *dev)
 	dev->features |= ifb_features;
 	dev->hw_features |= dev->features;
 	dev->hw_enc_features |= dev->features;
-	dev->vlan_features |= ifb_features & ~netdev_tx_vlan_features;
+	ifb_features &= ~netdev_tx_vlan_features;
+	dev->vlan_features |= ifb_features;
 
 	dev->flags |= IFF_NOARP;
 	dev->flags &= ~IFF_MULTICAST;
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index b0d7a484fd39..0078ecfe8838 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -254,13 +254,18 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 					     netdev_features_t features)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
+	netdev_features_t tmp;
 
 	features |= NETIF_F_ALL_FOR_ALL;
-	features &= (ipvlan->sfeatures | ~IPVLAN_FEATURES);
+	netdev_features_fill(&tmp);
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
index ca7f01d33483..41e17d737d33 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3456,7 +3456,8 @@ static int macsec_dev_init(struct net_device *dev)
 		dev->features = REAL_DEV_FEATURES(real_dev);
 	} else {
 		dev->features = real_dev->features & SW_MACSEC_FEATURES;
-		dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
+		dev->features |= NETIF_F_LLTX;
+		dev->features |= NETIF_F_GSO_SOFTWARE;
 	}
 
 	dev->needed_headroom = real_dev->needed_headroom +
@@ -3488,12 +3489,15 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
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
index d9a20c0341c6..aac040522ee9 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1099,15 +1099,22 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	netdev_features_t lowerdev_features = vlan->lowerdev->features;
 	netdev_features_t mask;
+	netdev_features_t tmp;
 
 	features |= NETIF_F_ALL_FOR_ALL;
-	features &= (vlan->set_features | ~MACVLAN_FEATURES);
+	netdev_features_fill(&tmp);
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
index ad687b14dda3..d501c7c58f70 100644
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
index eec3c8112d3f..4c999e18d4a1 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2184,9 +2184,9 @@ static void team_setup(struct net_device *dev)
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
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 194757bbd2b3..322956768815 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1003,7 +1003,8 @@ static int tun_net_init(struct net_device *dev)
 
 	dev->hw_features = TUN_USER_FEATURES;
 	netdev_hw_features_set_array(dev, &tun_hw_feature_set);
-	dev->features = dev->hw_features | NETIF_F_LLTX;
+	dev->features = dev->hw_features;
+	dev->features |= NETIF_F_LLTX;
 	dev->vlan_features = dev->features & ~netdev_tx_vlan_features;
 
 	tun->flags = (tun->flags & ~TUN_FEATURES) |
@@ -1174,8 +1175,11 @@ static netdev_features_t tun_net_fix_features(struct net_device *dev,
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
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index c89639381eca..29451eb7263b 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -185,7 +185,8 @@ static int cdc_mbim_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->flags |= IFF_NOARP;
 
 	/* no need to put the VLAN tci in the packet headers */
-	dev->net->features |= NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_FILTER;
+	dev->net->features |= NETIF_F_HW_VLAN_CTAG_TX;
+	dev->net->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
 	/* monitor VLAN additions and removals */
 	dev->net->netdev_ops = &cdc_mbim_netdev_ops;
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index bfb58c91db04..10cf0a68980e 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1085,7 +1085,8 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	if (DEFAULT_RX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_RXCSUM;
 
-	dev->net->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+	dev->net->hw_features = NETIF_F_IP_CSUM;
+	dev->net->hw_features |= NETIF_F_RXCSUM;
 	set_bit(EVENT_NO_IP_ALIGN, &dev->flags);
 
 	smsc95xx_init_mac_address(dev);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 5978baef9695..805056a246cc 100644
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
@@ -1657,7 +1658,8 @@ static void veth_setup(struct net_device *dev)
 
 	dev->hw_features = veth_features;
 	dev->hw_enc_features = veth_features;
-	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
+	dev->mpls_features = NETIF_F_GSO_SOFTWARE;
+	dev->mpls_features |= NETIF_F_HW_CSUM;
 	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c40d80f25809..3d8f4da73bd7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3510,9 +3510,12 @@ static int virtnet_probe(struct virtio_device *vdev)
 	/* Do we support "hardware" checksums? */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CSUM)) {
 		/* This opens up the world of extra features. */
-		dev->hw_features |= NETIF_F_HW_CSUM | NETIF_F_SG;
-		if (csum)
-			dev->features |= NETIF_F_HW_CSUM | NETIF_F_SG;
+		dev->hw_features |= NETIF_F_HW_CSUM;
+		dev->hw_features |= NETIF_F_SG;
+		if (csum) {
+			dev->features |= NETIF_F_HW_CSUM;
+			dev->features |= NETIF_F_SG;
+		}
 
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
 			dev->hw_features |= netdev_general_tso_features;
@@ -3528,8 +3531,11 @@ static int virtnet_probe(struct virtio_device *vdev)
 
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
index ede0a87ca982..9f8a074eab03 100644
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
@@ -3332,8 +3332,8 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 	netdev_hw_features_set_array(netdev, &vmxnet3_hw_feature_set);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL |
-				NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
 		netdev_hw_enc_features_zero(netdev);
 		netdev_hw_enc_features_set_array(netdev,
 						 &vmxnet3_hw_enc_feature_set);
@@ -3389,7 +3389,8 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 
 	netdev->vlan_features = netdev->hw_features &
 				~netdev_ctag_vlan_offload_features;
-	netdev->features = netdev->hw_features | NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev->features = netdev->hw_features;
+	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
 
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index abc2aeb0559e..3ed93302084a 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -410,12 +410,18 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
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
+	netdev_features_zero(&tun_offload_mask);
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
index d3aa9e7a37c2..8c57cd413e79 100644
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
@@ -1304,8 +1305,10 @@ void init_netdev(struct net_device *dev)
 					ATH6KL_HTC_ALIGN_BYTES, 4);
 
 	if (!test_bit(ATH6KL_FW_CAPABILITY_NO_IP_CHECKSUM,
-		      ar->fw_capabilities))
-		dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
+		      ar->fw_capabilities)) {
+		dev->hw_features |= NETIF_F_IP_CSUM;
+		dev->hw_features |= NETIF_F_RXCSUM;
+	}
 
 	return;
 }
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index f4070fddc8c7..5f0bba0cfdf6 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -96,8 +96,10 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
 	ieee80211_hw_set(hw, WANT_MONITOR_VIF);
 
-	if (priv->trans->max_skb_frags)
-		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
+	if (priv->trans->max_skb_frags) {
+		hw->netdev_features = NETIF_F_HIGHDMA;
+		hw->netdev_features |= NETIF_F_SG;
+	}
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
 	hw->radiotap_mcs_details |= IEEE80211_RADIOTAP_MCS_HAVE_FMT;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9a5abb7958b6..5fbeb262a90b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -318,8 +318,10 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (mvm->trans->num_rx_queues > 1)
 		ieee80211_hw_set(hw, USES_RSS);
 
-	if (mvm->trans->max_skb_frags)
-		hw->netdev_features = NETIF_F_HIGHDMA | NETIF_F_SG;
+	if (mvm->trans->max_skb_frags) {
+		hw->netdev_features = NETIF_F_HIGHDMA;
+		hw->netdev_features |= NETIF_F_SG;
+	}
 
 	hw->queues = IEEE80211_NUM_ACS;
 	hw->offchannel_tx_hw_queue = IWL_MVM_OFFCHANNEL_QUEUE;
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
index 989328168e1c..8c37a65d8d06 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -533,7 +533,8 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	dev->netdev_ops	= &xenvif_netdev_ops;
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_array(dev, &xenvif_hw_feature_set);
-	dev->features = dev->hw_features | NETIF_F_RXCSUM;
+	dev->features = dev->hw_features;
+	dev->features |= NETIF_F_RXCSUM;
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
 	dev->tx_queue_len = XENVIF_QUEUE_LENGTH;
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index f662739137b5..0811ff9452f7 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -421,8 +421,10 @@ int cvm_oct_common_init(struct net_device *dev)
 	    (always_use_pow || strstr(pow_send_list, dev->name)))
 		priv->queue = -1;
 
-	if (priv->queue != -1)
-		dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM;
+	if (priv->queue != -1) {
+		dev->features |= NETIF_F_SG;
+		dev->features |= NETIF_F_IP_CSUM;
+	}
 
 	/* We do our own locking, Linux doesn't need to */
 	dev->features |= NETIF_F_LLTX;
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
index e096786e4b7a..772401f25a81 100644
--- a/include/linux/netdev_features_helper.h
+++ b/include/linux/netdev_features_helper.h
@@ -688,7 +688,7 @@ static inline bool netdev_features_subset(const netdev_features_t src1,
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 							  netdev_features_t f2)
 {
-	if ((f1 ^ f2) & NETIF_F_HW_CSUM) {
+	if ((f1 & NETIF_F_HW_CSUM) != (f2 & NETIF_F_HW_CSUM)) {
 		if (f1 & NETIF_F_HW_CSUM)
 			f1 |= netdev_ip_csum_features;
 		else
@@ -701,7 +701,10 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
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
index 5eaf38875554..60b5e401e346 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -5,6 +5,7 @@
 #include <linux/if_vlan.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/list.h>
+#include <linux/netdev_features_helper.h>
 
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
+	netdev_features_zero(&ret);
+	return ret;
 }
 
 #define vlan_group_for_each_dev(grp, i, dev) \
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 3af719812f00..ab2847fa938d 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -578,7 +578,8 @@ static int vlan_dev_init(struct net_device *dev)
 	dev->hw_features |= NETIF_F_ALL_FCOE;
 	netdev_hw_features_set_array(dev, &vlan_hw_feature_set);
 
-	dev->features |= dev->hw_features | NETIF_F_LLTX;
+	dev->features |= dev->hw_features;
+	dev->features |= NETIF_F_LLTX;
 	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
@@ -652,10 +653,11 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
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
@@ -663,7 +665,9 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
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
index 7a57d8b4f307..2a0f31c66dea 100644
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
@@ -10058,7 +10064,8 @@ int register_netdevice(struct net_device *dev)
 
 	/* Make NETIF_F_SG inheritable to tunnel devices.
 	 */
-	dev->hw_enc_features |= NETIF_F_SG | NETIF_F_GSO_PARTIAL;
+	dev->hw_enc_features |= NETIF_F_SG;
+	dev->hw_enc_features |= NETIF_F_GSO_PARTIAL;
 
 	/* Make NETIF_F_SG inheritable to MPLS.
 	 */
@@ -11147,16 +11154,28 @@ static int dev_cpu_dead(unsigned int oldcpu)
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
+	netdev_features_fill(&tmp);
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
index 974bbbbe7138..955d7640dde6 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4312,7 +4312,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 		unsigned short gso_size = skb_shinfo(head_skb)->gso_size;
 
 		/* Update type to add partial and then remove dodgy if set */
-		type |= (features & NETIF_F_GSO_PARTIAL) / NETIF_F_GSO_PARTIAL * SKB_GSO_PARTIAL;
+		type |= (features & NETIF_F_GSO_PARTIAL) ? 0 : SKB_GSO_PARTIAL;
 		type &= ~SKB_GSO_DODGY;
 
 		/* Update GSO info and prepare to start updating headers on
diff --git a/net/core/sock.c b/net/core/sock.c
index 4cb957d934a2..3127552e8989 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2326,7 +2326,8 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 		if (dst->header_len && !xfrm_dst_offload_ok(dst)) {
 			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 		} else {
-			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
+			sk->sk_route_caps |= NETIF_F_SG;
+			sk->sk_route_caps |= NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
 			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
 			sk_trim_gso_size(sk);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index fd44638ec16b..53fa477d20ab 100644
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
index ad6a6663feeb..a7e831bc5632 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2287,11 +2287,14 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 
 	p->xmit = cpu_dp->tag_ops->xmit;
 
-	slave->features = master->vlan_features | NETIF_F_HW_TC;
+	slave->features = master->vlan_features;
+	slave->features |= NETIF_F_HW_TC;
 	slave->hw_features |= NETIF_F_HW_TC;
 	slave->features |= NETIF_F_LLTX;
-	if (slave->needed_tailroom)
-		slave->features &= ~(NETIF_F_SG | NETIF_F_FRAGLIST);
+	if (slave->needed_tailroom) {
+		slave->features &= ~NETIF_F_SG;
+		slave->features &= ~NETIF_F_FRAGLIST;
+	}
 	if (ds->needs_standalone_vlan_filtering)
 		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 }
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
index 2ed9277a873e..8f32e4f06bfb 100644
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
 
+	netdev_features_zero(&tmp);
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
@@ -319,6 +334,7 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
 	netdev_features_t features = 0, changed;
 	netdev_features_t eth_all_features;
+	netdev_features_t tmp;
 
 	if (data & ~ETH_ALL_FLAGS)
 		return -EINVAL;
@@ -338,12 +354,15 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	netdev_features_set_array(&ethtool_all_feature_set, &eth_all_features);
 
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
index d7bd1daf022b..9ca2620de9ea 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1012,7 +1012,8 @@ static int __ip_append_data(struct sock *sk,
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
index 897ca4f9b791..f8fca2a3af3a 100644
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
index 95b58c5cac07..bd0c2073828c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2391,13 +2391,15 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ieee80211_setup_sdata(sdata, type);
 
 	if (ndev) {
+		netdev_features_t tmp;
+
 		ndev->ieee80211_ptr->use_4addr = params->use_4addr;
 		if (type == NL80211_IFTYPE_STATION)
 			sdata->u.mgd.use_4addr = params->use_4addr;
 
 		ndev->features |= local->hw.netdev_features;
-		ndev->hw_features |= ndev->features &
-					MAC80211_SUPPORTED_FEATURES_TX;
+		tmp = ndev->features & MAC80211_SUPPORTED_FEATURES_TX;
+		ndev->hw_features |= tmp;
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 0459fe97ddd9..522457207275 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -122,7 +122,8 @@ static void do_setup(struct net_device *netdev)
 	netdev->vlan_features = netdev->features;
 	netdev->hw_enc_features = netdev->features;
 	netdev->features |= netdev_tx_vlan_features;
-	netdev->hw_features = netdev->features & ~NETIF_F_LLTX;
+	netdev->hw_features = netdev->features;
+	netdev->hw_features &= ~NETIF_F_LLTX;
 
 	eth_hw_addr_random(netdev);
 }
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index e3e6cf75aa03..7e57a67ecce3 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1403,7 +1403,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
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

