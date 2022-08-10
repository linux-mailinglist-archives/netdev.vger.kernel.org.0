Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED77F58E55D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbiHJDPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiHJDN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:59 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14D381B2A
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:52 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zft4HwSzXdQb;
        Wed, 10 Aug 2022 11:09:42 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:47 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 24/36] treewide: use netdev_feature_add helpers
Date:   Wed, 10 Aug 2022 11:06:12 +0800
Message-ID: <20220810030624.34711-25-shenjian15@huawei.com>
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

Replace the '|' and '|=' operations of single feature bit by
netdev_feature_add helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |   4 +-
 drivers/firewire/net.c                        |   2 +-
 drivers/infiniband/hw/hfi1/vnic_main.c        |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |   6 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c    |   2 +-
 drivers/misc/sgi-xp/xpnet.c                   |   2 +-
 drivers/net/bonding/bond_main.c               |   8 +-
 drivers/net/can/dev/dev.c                     |   2 +-
 drivers/net/ethernet/3com/3c59x.c             |   5 +-
 drivers/net/ethernet/adaptec/starfire.c       |  11 +-
 drivers/net/ethernet/aeroflex/greth.c         |   2 +-
 drivers/net/ethernet/alacritech/slicoss.c     |   2 +-
 drivers/net/ethernet/alteon/acenic.c          |   2 +-
 drivers/net/ethernet/altera/altera_tse_main.c |   5 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c  |  14 +--
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |   9 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c     |   6 +-
 drivers/net/ethernet/apm/xgene-v2/main.c      |   4 +-
 drivers/net/ethernet/apm/xgene-v2/main.h      |   1 +
 .../net/ethernet/apm/xgene/xgene_enet_main.c  |   4 +-
 .../ethernet/aquantia/atlantic/aq_macsec.c    |   2 +-
 .../ethernet/aquantia/atlantic/aq_macsec.h    |   1 +
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |   4 +-
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |   8 +-
 drivers/net/ethernet/atheros/atlx/atl1.c      |   2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      |   4 +-
 drivers/net/ethernet/atheros/atlx/atlx.c      |   2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |   6 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |   6 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  15 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   3 +-
 drivers/net/ethernet/broadcom/tg3.c           |  19 +--
 drivers/net/ethernet/cadence/macb_main.c      |  10 +-
 .../net/ethernet/cavium/liquidio/lio_main.c   |   3 +-
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   4 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  10 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |   9 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c   |   8 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   6 +-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |   4 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  14 +--
 drivers/net/ethernet/cortina/gemini.c         |   2 +-
 drivers/net/ethernet/davicom/dm9000.c         |   4 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |   2 +-
 drivers/net/ethernet/engleder/tsnep_main.c    |   2 +-
 drivers/net/ethernet/faraday/ftgmac100.c      |   2 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    |   4 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   3 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   6 +-
 .../net/ethernet/freescale/enetc/enetc_vf.c   |   2 +-
 drivers/net/ethernet/freescale/fec_main.c     |   2 +-
 .../ethernet/freescale/fs_enet/fs_enet-main.c |   2 +-
 drivers/net/ethernet/freescale/gianfar.c      |   2 +-
 .../ethernet/fungible/funeth/funeth_ktls.c    |   5 +-
 .../ethernet/fungible/funeth/funeth_main.c    |   4 +-
 drivers/net/ethernet/google/gve/gve_adminq.c  |   3 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c |   5 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  17 +--
 .../net/ethernet/huawei/hinic/hinic_main.c    |  12 +-
 drivers/net/ethernet/ibm/emac/core.c          |   2 +-
 drivers/net/ethernet/ibm/ibmveth.c            |   8 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  13 +-
 drivers/net/ethernet/intel/e100.c             |   7 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |   8 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  13 +-
 drivers/net/ethernet/intel/fm10k/fm10k.h      |   1 +
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |   4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c  |   7 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  19 +--
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  66 +++++++----
 .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   2 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  15 ++-
 drivers/net/ethernet/intel/ice/ice_repr.c     |   2 +-
 drivers/net/ethernet/intel/igb/igb_main.c     |  20 ++--
 drivers/net/ethernet/intel/igbvf/netdev.c     |   8 +-
 drivers/net/ethernet/intel/igc/igc_main.c     |  16 +--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |   8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  18 +--
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   6 +-
 drivers/net/ethernet/jme.c                    |   4 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |   2 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   6 +-
 .../ethernet/marvell/octeon_ep/octep_main.c   |   2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  10 +-
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |   6 +-
 .../ethernet/marvell/prestera/prestera_main.c |   5 +-
 drivers/net/ethernet/marvell/skge.c           |   2 +-
 drivers/net/ethernet/marvell/sky2.c           |   8 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   4 +-
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  31 +++--
 .../mellanox/mlx5/core/en_accel/ipsec.c       |  16 +--
 .../mellanox/mlx5/core/en_accel/ktls.c        |   6 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 112 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  20 ++--
 drivers/net/ethernet/micrel/ksz884x.c         |   2 +-
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |   8 +-
 drivers/net/ethernet/natsemi/ns83820.c        |   7 +-
 .../net/ethernet/netronome/nfp/crypto/tls.c   |   8 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |   1 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |  32 ++---
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  34 +++---
 drivers/net/ethernet/ni/nixge.c               |   2 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |   7 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  37 +++---
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  12 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |  22 ++--
 drivers/net/ethernet/qlogic/qla3xxx.c         |   7 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |   5 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  11 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |   2 +-
 drivers/net/ethernet/realtek/8139cp.c         |   6 +-
 drivers/net/ethernet/realtek/8139too.c        |   4 +-
 drivers/net/ethernet/realtek/r8169_main.c     |  14 +--
 drivers/net/ethernet/renesas/ravb_main.c      |   3 +-
 drivers/net/ethernet/renesas/sh_eth.c         |   5 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   5 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |   2 +-
 drivers/net/ethernet/sfc/ef10.c               |   4 +-
 drivers/net/ethernet/sfc/ef100_nic.c          |   3 +-
 drivers/net/ethernet/sfc/ef10_sriov.c         |   3 +-
 drivers/net/ethernet/sfc/efx.c                |   4 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |   6 +-
 drivers/net/ethernet/sfc/siena/efx.c          |   4 +-
 drivers/net/ethernet/socionext/sni_ave.c      |   9 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  15 +--
 drivers/net/ethernet/sun/cassini.c            |   7 +-
 drivers/net/ethernet/sun/niu.c                |   4 +-
 drivers/net/ethernet/sun/sungem.c             |   2 +-
 drivers/net/ethernet/sun/sunhme.c             |  12 +-
 .../net/ethernet/synopsys/dwc-xlgmac-common.c |  14 +--
 drivers/net/ethernet/synopsys/dwc-xlgmac.h    |   1 +
 drivers/net/ethernet/tehuti/tehuti.c          |   2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   4 +-
 drivers/net/ethernet/ti/cpsw.c                |   9 +-
 drivers/net/ethernet/ti/netcp_core.c          |   6 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |  10 +-
 drivers/net/ethernet/toshiba/spider_net.c     |  10 +-
 drivers/net/ethernet/tundra/tsi108_eth.c      |   2 +-
 drivers/net/ethernet/via/via-rhine.c          |   5 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |   3 +-
 drivers/net/ethernet/wiznet/w5100.c           |   3 +-
 drivers/net/ethernet/wiznet/w5300.c           |   3 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c   |   4 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c |   6 +-
 drivers/net/fjes/fjes_main.c                  |   3 +-
 drivers/net/gtp.c                             |   2 +-
 drivers/net/hamradio/bpqether.c               |   2 +-
 drivers/net/hyperv/netvsc_drv.c               |   2 +-
 drivers/net/hyperv/rndis_filter.c             |  16 +--
 drivers/net/ipa/ipa_modem.c                   |   2 +-
 drivers/net/macsec.c                          |   7 +-
 drivers/net/macvlan.c                         |   2 +-
 drivers/net/net_failover.c                    |   4 +-
 drivers/net/netdevsim/netdev.c                |   2 +-
 drivers/net/ntb_netdev.c                      |   2 +-
 drivers/net/ppp/ppp_generic.c                 |   3 +-
 drivers/net/rionet.c                          |   2 +-
 drivers/net/tap.c                             |  11 +-
 drivers/net/team/team.c                       |  10 +-
 drivers/net/thunderbolt.c                     |   2 +-
 drivers/net/tun.c                             |  12 +-
 drivers/net/usb/cdc_mbim.c                    |   5 +-
 drivers/net/usb/lan78xx.c                     |  10 +-
 drivers/net/usb/smsc75xx.c                    |   2 +-
 drivers/net/usb/smsc95xx.c                    |   8 +-
 drivers/net/veth.c                            |   9 +-
 drivers/net/virtio_net.c                      |  31 ++---
 drivers/net/vmxnet3/vmxnet3_drv.c             |  10 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  10 +-
 drivers/net/vrf.c                             |   6 +-
 drivers/net/wireguard/device.c                |   2 +-
 drivers/net/wireless/ath/ath10k/mac.c         |   2 +-
 drivers/net/wireless/ath/ath11k/mac.c         |   2 +-
 drivers/net/wireless/ath/ath6kl/core.h        |   1 +
 drivers/net/wireless/ath/ath6kl/main.c        |   6 +-
 .../broadcom/brcm80211/brcmfmac/core.c        |   3 +-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |   3 +-
 .../net/wireless/mediatek/mt76/mt7615/init.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt7915/init.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt7921/init.c  |   2 +-
 drivers/net/wwan/t7xx/t7xx_netdev.c           |  14 +--
 drivers/net/xen-netback/interface.c           |   2 +-
 drivers/s390/net/qeth_core_main.c             |  23 ++--
 drivers/s390/net/qeth_l2_main.c               |  32 ++---
 drivers/s390/net/qeth_l3_main.c               |  12 +-
 drivers/staging/octeon/ethernet.c             |   7 +-
 drivers/staging/qlge/qlge_main.c              |   2 +-
 include/net/udp.h                             |   3 +-
 net/8021q/vlan.h                              |   2 +-
 net/8021q/vlan_dev.c                          |   8 +-
 net/core/dev.c                                |  26 ++--
 net/core/sock.c                               |   7 +-
 net/dsa/slave.c                               |  13 +-
 net/ethtool/ioctl.c                           |  24 ++--
 net/hsr/hsr_device.c                          |   6 +-
 net/ieee802154/6lowpan/core.c                 |   3 +-
 net/ieee802154/core.c                         |   9 +-
 net/ipv4/ip_tunnel.c                          |   3 +-
 net/ipv4/ip_vti.c                             |   3 +-
 net/ipv4/ipip.c                               |   2 +-
 net/ipv4/ipmr.c                               |   2 +-
 net/ipv4/tcp_offload.c                        |   2 +-
 net/ipv4/udp_offload.c                        |   4 +-
 net/ipv6/ip6_gre.c                            |   2 +-
 net/ipv6/ip6_tunnel.c                         |   4 +-
 net/ipv6/ip6mr.c                              |   3 +-
 net/ipv6/sit.c                                |   5 +-
 net/ipv6/udp_offload.c                        |   2 +-
 net/l2tp/l2tp_eth.c                           |   2 +-
 net/nsh/nsh.c                                 |   3 +-
 net/openvswitch/datapath.c                    |   3 +-
 net/openvswitch/vport-internal_dev.c          |   2 +-
 net/phonet/pep-gprs.c                         |   2 +-
 net/sctp/offload.c                            |   5 +-
 net/wireless/core.c                           |   9 +-
 net/xfrm/xfrm_interface.c                     |   2 +-
 224 files changed, 902 insertions(+), 763 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index d797758850e1..9bd68d8dd410 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1629,8 +1629,8 @@ static void vector_eth_configure(
 	});
 
 	netdev_active_features_zero(dev);
-	dev->features |= NETIF_F_SG;
-	dev->features |= NETIF_F_FRAGLIST;
+	netdev_active_feature_add(dev, NETIF_F_SG_BIT);
+	netdev_active_feature_add(dev, NETIF_F_FRAGLIST_BIT);
 	dev->features = dev->hw_features;
 	INIT_WORK(&vp->reset_tx, vector_reset_tx);
 
diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index e73c8793599b..58a01d2cfed4 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1376,7 +1376,7 @@ static void fwnet_init_dev(struct net_device *net)
 	net->watchdog_timeo	= 2 * HZ;
 	net->flags		= IFF_BROADCAST | IFF_MULTICAST;
 	netdev_active_features_zero(net);
-	net->features		|= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(net, NETIF_F_HIGHDMA_BIT);
 	net->addr_len		= FWNET_ALEN;
 	net->hard_header_len	= FWNET_HLEN;
 	net->type		= ARPHRD_IEEE1394;
diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index 52f805909ce3..634876741a7b 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -589,8 +589,8 @@ struct net_device *hfi1_vnic_alloc_rn(struct ib_device *device,
 	rn->set_id = hfi1_vnic_set_vesw_id;
 
 	netdev_active_features_zero(netdev);
-	netdev->features |= NETIF_F_HIGHDMA;
-	netdev->features |= NETIF_F_SG;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
+	netdev_active_feature_add(netdev, NETIF_F_SG_BIT);
 	netdev->hw_features = netdev->features;
 	netdev->vlan_features = netdev->features;
 	netdev->watchdog_timeo = msecs_to_jiffies(HFI_TX_TIMEOUT_MS);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index b69b918b2c39..fe18d7819d3c 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1855,11 +1855,11 @@ static void ipoib_set_dev_features(struct ipoib_dev_priv *priv)
 	priv->kernel_caps = priv->ca->attrs.kernel_cap_flags;
 
 	if (priv->hca_caps & IB_DEVICE_UD_IP_CSUM) {
-		priv->dev->hw_features |= NETIF_F_IP_CSUM;
-		priv->dev->hw_features |= NETIF_F_RXCSUM;
+		netdev_hw_feature_add(priv->dev, NETIF_F_IP_CSUM_BIT);
+		netdev_hw_feature_add(priv->dev, NETIF_F_RXCSUM_BIT);
 
 		if (priv->kernel_caps & IBK_UD_TSO)
-			priv->dev->hw_features |= NETIF_F_TSO;
+			netdev_hw_feature_add(priv->dev, NETIF_F_TSO_BIT);
 
 		priv->dev->features |= priv->dev->hw_features;
 	}
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index 368e5d77416d..cd9ac35ac65a 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -234,7 +234,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	priv->rx_wr.sg_list = priv->rx_sge;
 
 	if (init_attr.cap.max_send_sge > 1)
-		dev->features |= NETIF_F_SG;
+		netdev_active_feature_add(dev, NETIF_F_SG_BIT);
 
 	priv->max_send_sge = init_attr.cap.max_send_sge;
 
diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 8547652c7b59..46bfc19d5020 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -570,7 +570,7 @@ xpnet_init(void)
 	 * packet will be dropped.
 	 */
 	netdev_active_features_zero(xpnet_device);
-	xpnet_device->features |= NETIF_F_HW_CSUM;
+	netdev_active_feature_add(xpnet_device, NETIF_F_HW_CSUM_BIT);
 
 	result = register_netdev(xpnet_device);
 	if (result != 0) {
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index edbeaac3f678..f117f63e2879 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5753,7 +5753,7 @@ void bond_setup(struct net_device *bond_dev)
 #endif /* CONFIG_XFRM_OFFLOAD */
 
 	/* don't acquire bond device's netif_tx_lock when transmitting */
-	bond_dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(bond_dev, NETIF_F_LLTX_BIT);
 
 	/* By default, we declare the bond to be fully
 	 * VLAN hardware accelerated capable. Special
@@ -5763,11 +5763,11 @@ void bond_setup(struct net_device *bond_dev)
 	 */
 
 	/* Don't allow bond devices to change network namespaces. */
-	bond_dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(bond_dev, NETIF_F_NETNS_LOCAL_BIT);
 
 	bond_dev->hw_features = BOND_VLAN_FEATURES;
-	bond_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
-	bond_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_hw_feature_add(bond_dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
+	netdev_hw_feature_add(bond_dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	bond_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	bond_dev->features |= bond_dev->hw_features;
diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 4243e65b2c68..6752b381f72d 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -223,7 +223,7 @@ void can_setup(struct net_device *dev)
 	/* New-style flags. */
 	dev->flags = IFF_NOARP;
 	netdev_active_features_zero(dev);
-	dev->features |= NETIF_F_HW_CSUM;
+	netdev_active_feature_add(dev, NETIF_F_HW_CSUM_BIT);
 }
 
 /* Allocate and setup space for the CAN network device */
diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 900435ea2c10..d816cb6f22ab 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -82,6 +82,7 @@ static int vortex_debug = 1;
 #include <linux/mii.h>
 #include <linux/init.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -1448,8 +1449,8 @@ static int vortex_probe1(struct device *gendev, void __iomem *ioaddr, int irq,
 		if (card_idx < MAX_UNITS &&
 		    ((hw_checksums[card_idx] == -1 && (vp->drv_flags & HAS_HWCKSM)) ||
 				hw_checksums[card_idx] == 1)) {
-			dev->features |= NETIF_F_IP_CSUM;
-			dev->features |= NETIF_F_SG;
+			netdev_active_feature_add(dev, NETIF_F_IP_CSUM_BIT);
+			netdev_active_feature_add(dev, NETIF_F_SG_BIT);
 		}
 	} else
 		dev->netdev_ops =  &vortex_netdev_ops;
diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
index f19be1f78848..51e51e4d5e7a 100644
--- a/drivers/net/ethernet/adaptec/starfire.c
+++ b/drivers/net/ethernet/adaptec/starfire.c
@@ -33,6 +33,7 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
 #include <linux/delay.h>
@@ -685,17 +686,17 @@ static int starfire_init_one(struct pci_dev *pdev,
 #ifdef ZEROCOPY
 	/* Starfire can do TCP/UDP checksumming */
 	if (enable_hw_cksum) {
-		dev->features |= NETIF_F_IP_CSUM;
-		dev->features |= NETIF_F_SG;
+		netdev_active_feature_add(dev, NETIF_F_IP_CSUM_BIT);
+		netdev_active_feature_add(dev, NETIF_F_SG_BIT);
 	}
 #endif /* ZEROCOPY */
 
 #ifdef VLAN_SUPPORT
-	dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
+	netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 #endif /* VLAN_RX_KILL_VID */
 #ifdef ADDR_64BITS
-	dev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 #endif /* ADDR_64BITS */
 
 	/* Serial EEPROM reads are hidden by the hardware. */
diff --git a/drivers/net/ethernet/aeroflex/greth.c b/drivers/net/ethernet/aeroflex/greth.c
index 8a2c87778e96..ee4165257dfe 100644
--- a/drivers/net/ethernet/aeroflex/greth.c
+++ b/drivers/net/ethernet/aeroflex/greth.c
@@ -1491,7 +1491,7 @@ static int greth_of_probe(struct platform_device *ofdev)
 		netdev_hw_features_zero(dev);
 		netdev_hw_features_set_array(dev, &greth_hw_feature_set);
 		dev->features = dev->hw_features;
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 		greth_netdev_ops.ndo_start_xmit = greth_start_xmit_gbit;
 	}
 
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index a52e3bc855e4..a8989c1146bb 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1780,7 +1780,7 @@ static int slic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->irq = pdev->irq;
 	dev->netdev_ops = &slic_netdev_ops;
 	netdev_hw_features_zero(dev);
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	dev->features |= dev->hw_features;
 
 	dev->ethtool_ops = &slic_ethtool_ops;
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 4a16e176248c..bd306d707dbf 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -595,7 +595,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
 	}
 	ap->name = dev->name;
 
-	dev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	pci_set_drvdata(pdev, dev);
 
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 6dea777c8b98..64f9ee8581ce 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/mii.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of_device.h>
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
@@ -1558,13 +1559,13 @@ static int altera_tse_probe(struct platform_device *pdev)
 	 */
 	ndev->hw_features &= ~NETIF_F_SG;
 	ndev->features |= ndev->hw_features;
-	ndev->features |=  NETIF_F_HIGHDMA;
+	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 
 	/* VLAN offloading of tagging, stripping and filtering is not
 	 * supported by hardware, but driver will accommodate the
 	 * extra 4-byte VLAN tag for processing by upper layers
 	 */
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	/* setup NAPI interface */
 	netif_napi_add(ndev, &priv->napi, tse_poll, NAPI_POLL_WEIGHT);
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index f77a930367ce..202b10c77408 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4024,28 +4024,28 @@ static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 	/* Set offload features */
 	if (feat->offload.tx &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_TX_L4_IPV4_CSUM_PART_MASK)
-		dev_features |= NETIF_F_IP_CSUM;
+		netdev_feature_add(NETIF_F_IP_CSUM_BIT, &dev_features);
 
 	if (feat->offload.tx &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_TX_L4_IPV6_CSUM_PART_MASK)
-		dev_features |= NETIF_F_IPV6_CSUM;
+		netdev_feature_add(NETIF_F_IPV6_CSUM_BIT, &dev_features);
 
 	if (feat->offload.tx & ENA_ADMIN_FEATURE_OFFLOAD_DESC_TSO_IPV4_MASK)
-		dev_features |= NETIF_F_TSO;
+		netdev_feature_add(NETIF_F_TSO_BIT, &dev_features);
 
 	if (feat->offload.tx & ENA_ADMIN_FEATURE_OFFLOAD_DESC_TSO_IPV6_MASK)
-		dev_features |= NETIF_F_TSO6;
+		netdev_feature_add(NETIF_F_TSO6_BIT, &dev_features);
 
 	if (feat->offload.tx & ENA_ADMIN_FEATURE_OFFLOAD_DESC_TSO_ECN_MASK)
-		dev_features |= NETIF_F_TSO_ECN;
+		netdev_feature_add(NETIF_F_TSO_ECN_BIT, &dev_features);
 
 	if (feat->offload.rx_supported &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_RX_L4_IPV4_CSUM_MASK)
-		dev_features |= NETIF_F_RXCSUM;
+		netdev_feature_add(NETIF_F_RXCSUM_BIT, &dev_features);
 
 	if (feat->offload.rx_supported &
 		ENA_ADMIN_FEATURE_OFFLOAD_DESC_RX_L4_IPV6_CSUM_MASK)
-		dev_features |= NETIF_F_RXCSUM;
+		netdev_feature_add(NETIF_F_RXCSUM_BIT, &dev_features);
 
 	netdev->features = dev_features;
 	netdev_active_features_set_array(netdev, &ena_feature_set);
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index eb0b205b49af..4ee601db53cd 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2185,8 +2185,8 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	netdev_features_t vxlan_base;
 
 	netdev_features_zero(&vxlan_base);
-	vxlan_base |= NETIF_F_GSO_UDP_TUNNEL;
-	vxlan_base |= NETIF_F_RX_UDP_TUNNEL_PORT;
+	netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT, &vxlan_base);
+	netdev_feature_add(NETIF_F_RX_UDP_TUNNEL_PORT_BIT, &vxlan_base);
 
 	if (!pdata->hw_feat.vxn)
 		return features;
@@ -2196,7 +2196,7 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 	    !(features & NETIF_F_GSO_UDP_TUNNEL)) {
 		netdev_notice(netdev,
 			      "forcing tx udp tunnel support\n");
-		features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT, &features);
 	}
 
 	/* Can't do one without doing the other */
@@ -2210,7 +2210,8 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 		if (!(features & NETIF_F_GSO_UDP_TUNNEL_CSUM)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming on\n");
-			features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+					   &features);
 		}
 	} else {
 		if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM) {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-main.c b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
index f08f983cc13a..e6a050b6bdee 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-main.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-main.c
@@ -375,15 +375,15 @@ int xgbe_config_netdev(struct xgbe_prv_data *pdata)
 	netdev_hw_features_set_array(netdev, &xgbe_hw_feature_set);
 
 	if (pdata->hw_feat.rss)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 
 	if (pdata->hw_feat.vxn) {
 		netdev_hw_enc_features_zero(netdev);
 		netdev_hw_enc_features_set_array(netdev,
 						 &xgbe_hw_enc_feature_set);
 
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 		netdev->udp_tunnel_nic_info = xgbe_get_udp_tunnel_info();
 	}
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 739110c9f836..ceabdad21e17 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -648,8 +648,8 @@ static int xge_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, pdata);
 	ndev->netdev_ops = &xgene_ndev_ops;
 
-	ndev->features |= NETIF_F_GSO;
-	ndev->features |= NETIF_F_GRO;
+	netdev_active_feature_add(ndev, NETIF_F_GSO_BIT);
+	netdev_active_feature_add(ndev, NETIF_F_GRO_BIT);
 
 	ret = xge_get_resources(pdata);
 	if (ret)
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.h b/drivers/net/ethernet/apm/xgene-v2/main.h
index b3985a7be59d..e53e72719716 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.h
+++ b/drivers/net/ethernet/apm/xgene-v2/main.h
@@ -17,6 +17,7 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of_platform.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 65bba455a69f..78c86e6be7a0 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -2069,8 +2069,8 @@ static int xgene_enet_probe(struct platform_device *pdev)
 	spin_lock_init(&pdata->mac_lock);
 
 	if (pdata->phy_mode == PHY_INTERFACE_MODE_XGMII) {
-		ndev->features |= NETIF_F_TSO;
-		ndev->features |= NETIF_F_RXCSUM;
+		netdev_active_feature_add(ndev, NETIF_F_TSO_BIT);
+		netdev_active_feature_add(ndev, NETIF_F_RXCSUM_BIT);
 		spin_lock_init(&pdata->mss_lock);
 	}
 	ndev->hw_features = ndev->features;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 02058fe79f52..f77b090c9fc2 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -1490,7 +1490,7 @@ int aq_macsec_init(struct aq_nic_s *nic)
 	if (!nic->macsec_cfg)
 		return -ENOMEM;
 
-	nic->ndev->features |= NETIF_F_HW_MACSEC;
+	netdev_active_feature_add(nic->ndev, NETIF_F_HW_MACSEC_BIT);
 	nic->ndev->macsec_ops = &aq_macsec_ops;
 
 	return 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
index a47e2710487e..ffedc6850e1a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
@@ -7,6 +7,7 @@
 #define AQ_MACSEC_H
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #if IS_ENABLED(CONFIG_MACSEC)
 
 #include "net/macsec.h"
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index e2fe6f2507d3..5d6eaefb8391 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -387,7 +387,7 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	self->ndev->features = *aq_hw_caps->hw_features;
 	netdev_vlan_features_set_array(self->ndev, &aq_nic_vlan_feature_set);
 	netdev_gso_partial_features_zero(self->ndev);
-	self->ndev->gso_partial_features |= NETIF_F_GSO_UDP_L4;
+	netdev_gso_partial_feature_add(self->ndev, NETIF_F_GSO_UDP_L4_BIT);
 	self->ndev->priv_flags = aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index a9c7b29aadf8..01ab8bec3d4d 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -515,7 +515,7 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -2639,7 +2639,7 @@ static int atl1c_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &atl1c_hw_feature_set);
 	netdev->features = netdev->hw_features;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index d615afd95091..1e275e1006b3 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -390,7 +390,7 @@ static netdev_features_t atl1e_fix_features(struct net_device *netdev,
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -2278,10 +2278,10 @@ static int atl1e_init_netdev(struct net_device *netdev, struct pci_dev *pdev)
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &atl1e_hw_feature_set);
 	netdev->features = netdev->hw_features;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_TX;
+	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	/* not enabled by default */
-	netdev->hw_features |= NETIF_F_RXALL;
-	netdev->hw_features |= NETIF_F_RXFCS;
+	netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_RXFCS_BIT);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index c46d3e7ae89f..92ea741cc16c 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -3007,7 +3007,7 @@ static int atl1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_set_array(netdev, &atl1_hw_feature_set);
 
 	/* is this valid? see atl1_setup_mac_ctrl() */
-	netdev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
 	/* MTU range: 42 - 10218 */
 	netdev->min_mtu = ETH_ZLEN - (ETH_HLEN + VLAN_HLEN);
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 15df55325aae..e47f6325cfba 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -380,7 +380,7 @@ static netdev_features_t atl2_fix_features(struct net_device *netdev,
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -1391,7 +1391,7 @@ static int atl2_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_sw_init;
 
 	netdev_hw_features_zero(netdev);
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev->features |= netdev_ctag_vlan_offload_features;
 
 	/* Init PHY as early as possible due to power saving issue  */
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index e8cfbf4ff1b5..199b190ae23a 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -245,7 +245,7 @@ static netdev_features_t atlx_fix_features(struct net_device *netdev,
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index bd548249c2f2..a47dd8ae6e8d 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -8217,7 +8217,7 @@ bnx2_init_board(struct pci_dev *pdev, struct net_device *dev)
 
 	/* Configure DMA attributes. */
 	if (dma_set_mask(&pdev->dev, dma_mask) == 0) {
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 		rc = dma_set_coherent_mask(&pdev->dev, persist_dma_mask);
 		if (rc) {
 			dev_err(&pdev->dev,
@@ -8597,8 +8597,8 @@ bnx2_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_set_array(dev, &bnx2_hw_feature_set);
 
 	if (BNX2_CHIP(bp) == BNX2_CHIP_5709) {
-		dev->hw_features |= NETIF_F_IPV6_CSUM;
-		dev->hw_features |= NETIF_F_TSO6;
+		netdev_hw_feature_add(dev, NETIF_F_IPV6_CSUM_BIT);
+		netdev_hw_feature_add(dev, NETIF_F_TSO6_BIT);
 	}
 
 	dev->vlan_features = dev->hw_features;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index e68d77d9ae50..a1f3f6552101 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4913,13 +4913,15 @@ netdev_features_t bnx2x_fix_features(struct net_device *dev,
 		if (!(features & NETIF_F_RXCSUM) && !bp->disable_tpa) {
 			features &= ~NETIF_F_RXCSUM;
 			if (dev->features & NETIF_F_RXCSUM)
-				features |= NETIF_F_RXCSUM;
+				netdev_feature_add(NETIF_F_RXCSUM_BIT,
+						   &features);
 		}
 
 		if (changed & NETIF_F_LOOPBACK) {
 			features &= ~NETIF_F_LOOPBACK;
 			if (dev->features & NETIF_F_LOOPBACK)
-				features |= NETIF_F_LOOPBACK;
+				netdev_feature_add(NETIF_F_LOOPBACK_BIT,
+						   &features);
 		}
 	}
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 1986fde63919..fe618561b712 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13271,20 +13271,21 @@ static int bnx2x_init_dev(struct bnx2x *bp, struct pci_dev *pdev,
 		if (chip_is_e1x)
 			bp->accept_any_vlan = true;
 		else
-			dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_hw_feature_add(dev,
+					      NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 	/* For VF we'll know whether to enable VLAN filtering after
 	 * getting a response to CHANNEL_TLV_ACQUIRE from PF.
 	 */
 
 	dev->features |= dev->hw_features;
-	dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
-	dev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
+	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (dev->features & NETIF_F_LRO)
 		dev->features &= ~NETIF_F_GRO_HW;
 
 	/* Add Loopback capability to the device */
-	dev->hw_features |= NETIF_F_LOOPBACK;
+	netdev_hw_feature_add(dev, NETIF_F_LOOPBACK_BIT);
 
 #ifdef BCM_DCBNL
 	dev->dcbnl_ops = &bnx2x_dcbnl_ops;
@@ -13999,8 +14000,10 @@ static int bnx2x_init_one(struct pci_dev *pdev,
 #ifdef CONFIG_BNX2X_SRIOV
 		/* VF with OLD Hypervisor or old PF do not support filtering */
 		if (bp->acquire_resp.pfdev_info.pf_cap & PFVF_CAP_VLAN_FILTER) {
-			dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-			dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_hw_feature_add(dev,
+					      NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+			netdev_active_feature_add(dev,
+						  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 		}
 #endif
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 150630a2b207..a45a5c5684ca 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12266,10 +12266,10 @@ static void bnxt_set_dflt_rfs(struct bnxt *bp)
 	dev->features &= ~NETIF_F_NTUPLE;
 	bp->flags &= ~BNXT_FLAG_RFS;
 	if (bnxt_rfs_supported(bp)) {
-		dev->hw_features |= NETIF_F_NTUPLE;
+		netdev_hw_feature_add(dev, NETIF_F_NTUPLE_BIT);
 		if (bnxt_rfs_capable(bp)) {
 			bp->flags |= BNXT_FLAG_RFS;
-			dev->features |= NETIF_F_NTUPLE;
+			netdev_active_feature_add(dev, NETIF_F_NTUPLE_BIT);
 		}
 	}
 }
@@ -13637,7 +13637,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_set_array(dev, &bnxt_hw_feature_set);
 
 	if (BNXT_SUPPORTS_TPA(bp))
-		dev->hw_features |= NETIF_F_LRO;
+		netdev_hw_feature_add(dev, NETIF_F_LRO_BIT);
 
 	netdev_hw_enc_features_zero(dev);
 	netdev_hw_enc_features_set_array(dev, &bnxt_hw_enc_feature_set);
@@ -13646,15 +13646,15 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_gso_partial_features_zero(dev);
 	netdev_gso_partial_features_set_array(dev, &bnxt_gso_partial_feature_set);
 	dev->vlan_features = dev->hw_features;
-	dev->vlan_features |= NETIF_F_HIGHDMA;
+	netdev_vlan_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_RX_STRIP)
 		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_RX;
 	if (bp->fw_cap & BNXT_FW_CAP_VLAN_TX_INSERT)
 		dev->hw_features |= BNXT_HW_FEATURE_VLAN_ALL_TX;
 	if (BNXT_SUPPORTS_TPA(bp))
-		dev->hw_features |= NETIF_F_GRO_HW;
+		netdev_hw_feature_add(dev, NETIF_F_GRO_HW_BIT);
 	dev->features |= dev->hw_features;
-	dev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (dev->features & NETIF_F_GRO_HW)
 		dev->features &= ~NETIF_F_LRO;
 	dev->priv_flags |= IFF_UNICAST_FLT;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index d8afcf8d6b30..3c1a46ed3979 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -2052,8 +2052,8 @@ int bnxt_init_tc(struct bnxt *bp)
 		goto destroy_decap_table;
 
 	tc_info->enabled = true;
-	bp->dev->hw_features |= NETIF_F_HW_TC;
-	bp->dev->features |= NETIF_F_HW_TC;
+	netdev_hw_feature_add(bp->dev, NETIF_F_HW_TC_BIT);
+	netdev_active_feature_add(bp->dev, NETIF_F_HW_TC_BIT);
 	bp->tc_info = tc_info;
 
 	/* init indirect block notifications */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index f53387ed0167..9dd199dffb59 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -10,6 +10,7 @@
 #include <linux/errno.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/bpf.h>
@@ -425,7 +426,7 @@ static int bnxt_xdp_set(struct bnxt *bp, struct bpf_prog *prog)
 		bnxt_get_max_rings(bp, &rx, &tx, true);
 		if (rx > 1) {
 			bp->flags &= ~BNXT_FLAG_NO_AGG_RINGS;
-			bp->dev->hw_features |= NETIF_F_LRO;
+			netdev_hw_feature_add(bp->dev, NETIF_F_LRO_BIT);
 		}
 	}
 	bp->tx_nr_rings_xdp = tx_xdp;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index f4a455f8743b..ad927bc15d12 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -36,6 +36,7 @@
 #include <linux/ioport.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -17700,7 +17701,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 	if (dma_mask > DMA_BIT_MASK(32)) {
 		err = dma_set_mask(&pdev->dev, dma_mask);
 		if (!err) {
-			features |= NETIF_F_HIGHDMA;
+			netdev_feature_add(NETIF_F_HIGHDMA_BIT, &features);
 			err = dma_set_coherent_mask(&pdev->dev,
 						    persist_dma_mask);
 			if (err < 0) {
@@ -17725,12 +17726,12 @@ static int tg3_init_one(struct pci_dev *pdev,
 	 * to hardware bugs.
 	 */
 	if (tg3_chip_rev_id(tp) != CHIPREV_ID_5700_B0) {
-		features |= NETIF_F_SG;
-		features |= NETIF_F_IP_CSUM;
-		features |= NETIF_F_RXCSUM;
+		netdev_feature_add(NETIF_F_SG_BIT, &features);
+		netdev_feature_add(NETIF_F_IP_CSUM_BIT, &features);
+		netdev_feature_add(NETIF_F_RXCSUM_BIT, &features);
 
 		if (tg3_flag(tp, 5755_PLUS))
-			features |= NETIF_F_IPV6_CSUM;
+			netdev_feature_add(NETIF_F_IPV6_CSUM_BIT, &features);
 	}
 
 	/* TSO is on by default on chips that support hardware TSO.
@@ -17741,17 +17742,17 @@ static int tg3_init_one(struct pci_dev *pdev,
 	     tg3_flag(tp, HW_TSO_2) ||
 	     tg3_flag(tp, HW_TSO_3)) &&
 	    (features & NETIF_F_IP_CSUM))
-		features |= NETIF_F_TSO;
+		netdev_feature_add(NETIF_F_TSO_BIT, &features);
 	if (tg3_flag(tp, HW_TSO_2) || tg3_flag(tp, HW_TSO_3)) {
 		if (features & NETIF_F_IPV6_CSUM)
-			features |= NETIF_F_TSO6;
+			netdev_feature_add(NETIF_F_TSO6_BIT, &features);
 		if (tg3_flag(tp, HW_TSO_3) ||
 		    tg3_asic_rev(tp) == ASIC_REV_5761 ||
 		    (tg3_asic_rev(tp) == ASIC_REV_5784 &&
 		     tg3_chip_rev(tp) != CHIPREV_5784_AX) ||
 		    tg3_asic_rev(tp) == ASIC_REV_5785 ||
 		    tg3_asic_rev(tp) == ASIC_REV_57780)
-			features |= NETIF_F_TSO_ECN;
+			netdev_feature_add(NETIF_F_TSO_ECN_BIT, &features);
 	}
 
 	dev->features |= features;
@@ -17766,7 +17767,7 @@ static int tg3_init_one(struct pci_dev *pdev,
 	if (tg3_asic_rev(tp) != ASIC_REV_5780 &&
 	    !tg3_flag(tp, CPMU_PRESENT))
 		/* Add the loopback capability */
-		features |= NETIF_F_LOOPBACK;
+		netdev_feature_add(NETIF_F_LOOPBACK_BIT, &features);
 
 	dev->hw_features |= features;
 	dev->priv_flags |= IFF_UNICAST_FLT;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1f84d3bc42c9..22553f3d69d6 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4053,16 +4053,16 @@ static int macb_init(struct platform_device *pdev)
 
 	/* Set features */
 	netdev_hw_features_zero(dev);
-	dev->hw_features |= NETIF_F_SG;
+	netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
 
 	/* Check LSO capability */
 	if (GEM_BFEXT(PBUF_LSO, gem_readl(bp, DCFG6)))
-		dev->hw_features |= NETIF_F_TSO;
+		netdev_hw_feature_add(dev, NETIF_F_TSO_BIT);
 
 	/* Checksum offload is only available on gem with packet buffer */
 	if (macb_is_gem(bp) && !(bp->caps & MACB_CAPS_FIFO_MODE)) {
-		dev->hw_features |= NETIF_F_HW_CSUM;
-		dev->hw_features |= NETIF_F_RXCSUM;
+		netdev_hw_feature_add(dev, NETIF_F_HW_CSUM_BIT);
+		netdev_hw_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	}
 	if (bp->caps & MACB_CAPS_SG_DISABLED)
 		dev->hw_features &= ~NETIF_F_SG;
@@ -4084,7 +4084,7 @@ static int macb_init(struct platform_device *pdev)
 			reg = GEM_BFINS(ETHTCMP, (uint16_t)ETH_P_IP, reg);
 			gem_writel_n(bp, ETHT, SCRT2_ETHT, reg);
 			/* Filtering is supported in hw but don't enable it in kernel now */
-			dev->hw_features |= NETIF_F_NTUPLE;
+			netdev_hw_feature_add(dev, NETIF_F_NTUPLE_BIT);
 			/* init Rx flow definitions */
 			bp->rx_fs_list.count = 0;
 			spin_lock_init(&bp->rx_fs_lock);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 3271b8e9b392..fafd248977ed 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3595,7 +3595,8 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 		netdev->udp_tunnel_nic_info = &liquidio_udp_tunnels;
 
-		lio->dev_capability |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT,
+				   &lio->dev_capability);
 
 		netdev->vlan_features = lio->dev_capability;
 		/* Add any unchangeable hw features */
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index c6923ecabb63..e806eb803dd5 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -2223,10 +2223,10 @@ static int nicvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &nicvf_hw_feature_set);
 
-	netdev->hw_features |= NETIF_F_RXHASH;
+	netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 
 	netdev->features |= netdev->hw_features;
-	netdev->hw_features |= NETIF_F_LOOPBACK;
+	netdev_hw_feature_add(netdev, NETIF_F_LOOPBACK_BIT);
 
 	netdev_vlan_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &nicvf_vlan_feature_set);
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index eabb2a782d12..3174489477bc 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -871,7 +871,7 @@ static netdev_features_t t1_fix_features(struct net_device *dev,
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -1049,12 +1049,14 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		if (vlan_tso_capable(adapter)) {
 			netdev->features |= netdev_ctag_vlan_offload_features;
-			netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_hw_feature_add(netdev,
+					      NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 			/* T204: disable TSO */
 			if (!(is_T2(adapter)) || bi->port_number != 4) {
-				netdev->hw_features |= NETIF_F_TSO;
-				netdev->features |= NETIF_F_TSO;
+				netdev_hw_feature_add(netdev, NETIF_F_TSO_BIT);
+				netdev_active_feature_add(netdev,
+							  NETIF_F_TSO_BIT);
 			}
 		}
 
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 7bbec0a182c3..35daa61d3c4f 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2242,7 +2242,8 @@ static int cxgb_siocdevprivate(struct net_device *dev,
 
 		if (t.lro >= 0) {
 			if (t.lro)
-				dev->wanted_features |= NETIF_F_GRO;
+				netdev_wanted_feature_add(dev,
+							  NETIF_F_GRO_BIT);
 			else
 				dev->wanted_features &= ~NETIF_F_GRO;
 			netdev_update_features(dev);
@@ -2594,7 +2595,7 @@ static netdev_features_t cxgb_fix_features(struct net_device *dev,
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -3321,13 +3322,13 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_hw_features_zero(netdev);
 		netdev_hw_features_set_array(netdev, &cxgb_hw_feature_set);
 		netdev->features |= netdev->hw_features;
-		netdev->features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 		netdev_features_zero(&vlan_feat);
 		netdev_features_set_array(&cxgb_vlan_feature_set, &vlan_feat);
 		vlan_feat &= netdev->features;
 		netdev->vlan_features |= vlan_feat;
 
-		netdev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 		netdev->netdev_ops = &cxgb_netdev_ops;
 		netdev->ethtool_ops = &cxgb_ethtool_ops;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
index 5657ac8cfca0..1eb84a126153 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4.h
@@ -43,6 +43,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/timer.h>
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
index 33b2c0c45509..a885f8d96e2f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_fcoe.c
@@ -79,10 +79,10 @@ int cxgb_fcoe_enable(struct net_device *netdev)
 
 	dev_info(adap->pdev_dev, "Enabling FCoE offload features\n");
 
-	netdev->features |= NETIF_F_FCOE_CRC;
-	netdev->vlan_features |= NETIF_F_FCOE_CRC;
-	netdev->features |= NETIF_F_FCOE_MTU;
-	netdev->vlan_features |= NETIF_F_FCOE_MTU;
+	netdev_active_feature_add(netdev, NETIF_F_FCOE_CRC_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_FCOE_CRC_BIT);
+	netdev_active_feature_add(netdev, NETIF_F_FCOE_MTU_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_FCOE_MTU_BIT);
 
 	netdev_features_change(netdev);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 4df2af4c2e05..e5f29203a496 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6867,7 +6867,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev->vlan_features = netdev->features & vlan_features;
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW) {
-			netdev->hw_features |= NETIF_F_HW_TLS_TX;
+			netdev_hw_feature_add(netdev, NETIF_F_HW_TLS_TX_BIT);
 			netdev->tlsdev_ops = &cxgb4_ktls_ops;
 			/* initialize the refcount */
 			refcount_set(&pi->adapter->chcr_ktls.ktls_refcount, 0);
@@ -6875,8 +6875,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 #endif /* CONFIG_CHELSIO_TLS_DEVICE */
 #if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_IPSEC_INLINE) {
-			netdev->hw_enc_features |= NETIF_F_HW_ESP;
-			netdev->features |= NETIF_F_HW_ESP;
+			netdev_hw_enc_feature_add(netdev, NETIF_F_HW_ESP_BIT);
+			netdev_active_feature_add(netdev, NETIF_F_HW_ESP_BIT);
 			netdev->xfrmdev_ops = &cxgb4_xfrmdev_ops;
 		}
 #endif /* CONFIG_CHELSIO_IPSEC_INLINE */
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 0d1d361fc246..a96a45e8e805 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1182,7 +1182,7 @@ static netdev_features_t cxgb4vf_fix_features(struct net_device *dev,
 	 * enable/disable make sure tx flag is always in same state as rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -3093,7 +3093,7 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 		netdev->hw_features = tso_features;
 		netdev_hw_features_set_array(netdev, &cxgb4vf_hw_feature_set);
 		netdev->features = netdev->hw_features;
-		netdev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 		vlan_features = tso_features;
 		netdev_features_set_array(&cxgb4vf_vlan_feature_set,
 					  &vlan_features);
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 4f851d446716..77379e284cb9 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2902,17 +2902,17 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_info(dev, "loopback tag=0x%04x\n", enic->loop_tag);
 	}
 	if (ENIC_SETTING(enic, TXCSUM)) {
-		netdev->hw_features |= NETIF_F_SG;
-		netdev->hw_features |= NETIF_F_HW_CSUM;
+		netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	}
 	if (ENIC_SETTING(enic, TSO)) {
 		netdev->hw_features |= netdev_general_tso_features;
-		netdev->hw_features |= NETIF_F_TSO_ECN;
+		netdev_hw_feature_add(netdev, NETIF_F_TSO_ECN_BIT);
 	}
 	if (ENIC_SETTING(enic, RSS))
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 	if (ENIC_SETTING(enic, RXCSUM))
-		netdev->hw_features |= NETIF_F_RXCSUM;
+		netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 	if (ENIC_SETTING(enic, VXLAN)) {
 		u64 patch_level;
 		u64 a1 = 0;
@@ -2956,11 +2956,11 @@ static int enic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->vlan_features |= netdev->features;
 
 #ifdef CONFIG_RFS_ACCEL
-	netdev->hw_features |= NETIF_F_NTUPLE;
+	netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
 #endif
 
 	if (using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index dcadafd7cdaa..09e2dc3bd280 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2472,7 +2472,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 
 	netdev->hw_features = GMAC_OFFLOAD_FEATURES;
 	netdev->features |= GMAC_OFFLOAD_FEATURES;
-	netdev->features |= NETIF_F_GRO;
+	netdev_active_feature_add(netdev, NETIF_F_GRO_BIT);
 	/* We can handle jumbo frames up to 10236 bytes so, let's accept
 	 * payloads of 10236 bytes minus VLAN and ethernet header
 	 */
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index fec097064e52..c90d8be25be5 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -1646,8 +1646,8 @@ dm9000_probe(struct platform_device *pdev)
 	/* dm9000a/b are capable of hardware checksum offload */
 	if (db->type == TYPE_DM9000A || db->type == TYPE_DM9000B) {
 		netdev_hw_features_zero(ndev);
-		ndev->hw_features |= NETIF_F_RXCSUM;
-		ndev->hw_features |= NETIF_F_IP_CSUM;
+		netdev_hw_feature_add(ndev, NETIF_F_RXCSUM_BIT);
+		netdev_hw_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
 		ndev->features |= ndev->hw_features;
 	}
 
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index fefacd5530e2..0a29313e167a 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5216,7 +5216,7 @@ static void be_netdev_init(struct net_device *netdev)
 
 	netdev_hw_features_set_array(netdev, &be_hw_feature_set);
 	if ((be_if_cap_flags(adapter) & BE_IF_FLAGS_RSS))
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 
 	netdev->features |= netdev->hw_features;
 	netdev_active_features_set_array(netdev, &be_feature_set);
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 8e58b36a826d..66de80f58025 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1226,7 +1226,7 @@ static int tsnep_probe(struct platform_device *pdev)
 	netdev->netdev_ops = &tsnep_netdev_ops;
 	netdev->ethtool_ops = &tsnep_ethtool_ops;
 	netdev_active_features_zero(netdev);
-	netdev->features |= NETIF_F_SG;
+	netdev_active_feature_add(netdev, NETIF_F_SG_BIT);
 	netdev->hw_features = netdev->features;
 
 	/* carrier off reporting is important to ethtool even BEFORE open */
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 3cdc5d827f14..c286e0039851 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1943,7 +1943,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
 	netdev_hw_features_set_array(netdev, &ftgmac100_hw_feature_set);
 
 	if (priv->use_ncsi)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	/* AST2400  doesn't have working HW checksum generation */
 	if (np && (of_device_is_compatible(np, "aspeed,ast2400-mac")))
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 545e2b1afad7..c0cd9b14ef72 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -237,8 +237,8 @@ static int dpaa_netdev_init(struct net_device *net_dev,
 	/* The kernels enables GSO automatically, if we declare NETIF_F_SG.
 	 * For conformity, we'll still declare GSO explicitly.
 	 */
-	net_dev->features |= NETIF_F_GSO;
-	net_dev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(net_dev, NETIF_F_GSO_BIT);
+	netdev_active_feature_add(net_dev, NETIF_F_RXCSUM_BIT);
 
 	net_dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 	/* we do not want shared skbs on TX */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 8248e10717b9..40c24fa45506 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4405,7 +4405,8 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
 	net_dev->hw_features = net_dev->features;
 
 	if (priv->dpni_attrs.vlan_filter_entries)
-		net_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_feature_add(net_dev,
+				      NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index b8daac778c64..897932f08672 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -795,14 +795,14 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	netdev_vlan_features_set_array(ndev, &enetc_vlan_feature_set);
 
 	if (si->num_rss)
-		ndev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(ndev, NETIF_F_RXHASH_BIT);
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
-		ndev->features |= NETIF_F_HW_TC;
-		ndev->hw_features |= NETIF_F_HW_TC;
+		netdev_active_feature_add(ndev, NETIF_F_HW_TC_BIT);
+		netdev_hw_feature_add(ndev, NETIF_F_HW_TC_BIT);
 	}
 
 	/* pick up primary MAC address from SI */
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index a4eab1e1e590..cf1eb325c640 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -152,7 +152,7 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	netdev_vlan_features_set_array(ndev, &enetc_vf_vlan_feature_set);
 
 	if (si->num_rss)
-		ndev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(ndev, NETIF_F_RXHASH_BIT);
 
 	/* pick up primary MAC address from SI */
 	enetc_load_primary_mac_addr(&si->hw, ndev);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 49850ee91d4e..c656c9744305 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3571,7 +3571,7 @@ static int fec_enet_init(struct net_device *ndev)
 
 	if (fep->quirks & FEC_QUIRK_HAS_VLAN)
 		/* enable hw VLAN support */
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	if (fep->quirks & FEC_QUIRK_HAS_CSUM) {
 		netif_set_tso_max_segs(ndev, FEC_MAX_TSO_SEGS);
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index b3dae17e067e..f87512990c93 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -1027,7 +1027,7 @@ static int fs_enet_probe(struct platform_device *ofdev)
 
 	netif_carrier_off(ndev);
 
-	ndev->features |= NETIF_F_SG;
+	netdev_active_feature_add(ndev, NETIF_F_SG_BIT);
 
 	ret = register_netdev(ndev);
 	if (ret)
diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index dcf30e6dd012..26861683f699 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -3258,7 +3258,7 @@ static int gfar_probe(struct platform_device *ofdev)
 
 	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
 		dev->hw_features |= netdev_ctag_vlan_offload_features;
-		dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_active_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
 
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_ktls.c b/drivers/net/ethernet/fungible/funeth/funeth_ktls.c
index f871def70d70..4d572a86ac86 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_ktls.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_ktls.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: (GPL-2.0-only OR BSD-3-Clause)
 
+#include <linux/netdev_features_helper.h>
 #include "funeth.h"
 #include "funeth_ktls.h"
 
@@ -140,8 +141,8 @@ int fun_ktls_init(struct net_device *netdev)
 
 	fp->ktls_id = netdev->dev_port;
 	netdev->tlsdev_ops = &fun_ktls_ops;
-	netdev->hw_features |= NETIF_F_HW_TLS_TX;
-	netdev->features |= NETIF_F_HW_TLS_TX;
+	netdev_hw_feature_add(netdev, NETIF_F_HW_TLS_TX_BIT);
+	netdev_active_feature_add(netdev, NETIF_F_HW_TLS_TX_BIT);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index 4bfc6dab65f4..fd981e357f2f 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1789,14 +1789,14 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 
 	netdev_hw_features_set_array(netdev, &fun_hw_feature_set);
 	if (fp->port_caps & FUN_PORT_CAP_OFFLOADS) {
-		netdev->hw_features |= NETIF_F_HW_CSUM;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 		netdev->hw_features |= tso_flags;
 	}
 	if (fp->port_caps & FUN_PORT_CAP_ENCAP_OFFLOADS)
 		netdev->hw_features |= gso_encap_flags;
 
 	netdev->features |= netdev->hw_features;
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 	netdev->vlan_features = netdev->features & vlan_feat;
 	netdev->mpls_features = netdev->vlan_features;
 	netdev->hw_enc_features = netdev->hw_features;
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index f7621ab672b9..b8de076f079d 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include "gve.h"
 #include "gve_adminq.h"
@@ -765,7 +766,7 @@ int gve_adminq_describe_device(struct gve_priv *priv)
 		err = gve_set_desc_cnt(priv, descriptor);
 	} else {
 		/* DQO supports LRO. */
-		priv->dev->hw_features |= NETIF_F_LRO;
+		netdev_hw_feature_add(priv->dev, NETIF_F_LRO_BIT);
 		err = gve_set_desc_cnt_dqo(priv, descriptor, dev_op_dqo_rda);
 	}
 	if (err)
diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 69579d94f4d5..bf79258b4904 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/platform_device.h>
 #include <linux/of_device.h>
 #include <linux/of_net.h>
@@ -1234,10 +1235,10 @@ static int hix5hd2_dev_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, dev);
 
 	if (HAS_CAP_TSO(priv->hw_cap))
-		ndev->hw_features |= NETIF_F_SG;
+		netdev_hw_feature_add(ndev, NETIF_F_SG_BIT);
 
 	ndev->features |= ndev->hw_features;
-	ndev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 	ndev->vlan_features |= ndev->features;
 
 	ret = hix5hd2_init_hw_desc_queue(priv);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index c59026807723..e67a30738a2d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3288,30 +3288,31 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+	netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
 
 	netdev_active_features_set_array(netdev, &hns3_default_feature_set);
 
 	if (ae_dev->dev_version >= HNAE3_DEVICE_VERSION_V2) {
-		netdev->features |= NETIF_F_GRO_HW;
+		netdev_active_feature_add(netdev, NETIF_F_GRO_HW_BIT);
 
 		if (!(h->flags & HNAE3_SUPPORT_VF))
-			netdev->features |= NETIF_F_NTUPLE;
+			netdev_active_feature_add(netdev, NETIF_F_NTUPLE_BIT);
 	}
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_GSO_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_L4;
+		netdev_active_feature_add(netdev, NETIF_F_GSO_UDP_L4_BIT);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_HW_TX_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_CSUM;
+		netdev_active_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	else
 		netdev->features |= netdev_ip_csum_features;
 
 	if (test_bit(HNAE3_DEV_SUPPORT_UDP_TUNNEL_CSUM_B, ae_dev->caps))
-		netdev->features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_active_feature_add(netdev,
+					  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 	if (test_bit(HNAE3_DEV_SUPPORT_FD_FORWARD_TC_B, ae_dev->caps))
-		netdev->features |= NETIF_F_HW_TC;
+		netdev_active_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
 	netdev->hw_features |= netdev->features;
 	if (!test_bit(HNAE3_DEV_SUPPORT_VLAN_FLTR_MDF_B, ae_dev->caps))
@@ -3324,7 +3325,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev->vlan_features |= features;
 
 	netdev->hw_enc_features |= netdev->vlan_features;
-	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+	netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 }
 
 static int hns3_alloc_buffer(struct hns3_enet_ring *ring,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 93d4b019a4d1..4e49e2c4b409 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -949,7 +949,7 @@ static void netdev_features_init(struct net_device *netdev)
 	netdev->vlan_features = netdev->hw_features;
 
 	netdev->features = netdev->hw_features;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	netdev_hw_enc_features_zero(netdev);
 	netdev_hw_enc_features_set_array(netdev, &hinic_hw_enc_feature_set);
@@ -1083,7 +1083,7 @@ static int set_features(struct hinic_dev *nic_dev,
 					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_TSO;
+			netdev_feature_add(NETIF_F_TSO_BIT, &failed_features);
 		}
 	}
 
@@ -1091,7 +1091,8 @@ static int set_features(struct hinic_dev *nic_dev,
 		ret = hinic_set_rx_csum_offload(nic_dev, csum_en);
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_RXCSUM;
+			netdev_feature_add(NETIF_F_RXCSUM_BIT,
+					   &failed_features);
 		}
 	}
 
@@ -1102,7 +1103,7 @@ static int set_features(struct hinic_dev *nic_dev,
 					     HINIC_LRO_MAX_WQE_NUM_DEFAULT);
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_LRO;
+			netdev_feature_add(NETIF_F_LRO_BIT, &failed_features);
 		}
 	}
 
@@ -1112,7 +1113,8 @@ static int set_features(struct hinic_dev *nic_dev,
 						   NETIF_F_HW_VLAN_CTAG_RX));
 		if (ret) {
 			err = ret;
-			failed_features |= NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+					   &failed_features);
 		}
 	}
 
diff --git a/drivers/net/ethernet/ibm/emac/core.c b/drivers/net/ethernet/ibm/emac/core.c
index 17b5e0806aa6..5e8d43e04b53 100644
--- a/drivers/net/ethernet/ibm/emac/core.c
+++ b/drivers/net/ethernet/ibm/emac/core.c
@@ -3178,7 +3178,7 @@ static int emac_probe(struct platform_device *ofdev)
 		netdev_hw_features_zero(ndev);
 		netdev_hw_features_set_array(ndev, &emac_hw_feature_set);
 		ndev->features |= ndev->hw_features;
-		ndev->features |= NETIF_F_RXCSUM;
+		netdev_active_feature_add(ndev, NETIF_F_RXCSUM_BIT);
 	}
 	ndev->watchdog_timeo = 5 * HZ;
 	if (emac_phy_supports_gige(dev->phy_mode)) {
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index c59bbbcd094e..9d5b99ce60c2 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1685,7 +1685,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev->ethtool_ops = &netdev_ethtool_ops;
 	SET_NETDEV_DEV(netdev, &dev->dev);
 	netdev_hw_features_zero(netdev);
-	netdev->hw_features |= NETIF_F_SG;
+	netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
 	if (vio_get_attribute(dev, "ibm,illan-options", NULL) != NULL)
 		netdev_hw_features_set_array(netdev, &ibmveth_hw_feature_set);
 
@@ -1699,14 +1699,14 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 		netdev->hw_features |= netdev_general_tso_features;
 		netdev->features |= netdev->hw_features;
 	} else {
-		netdev->hw_features |= NETIF_F_TSO;
+		netdev_hw_feature_add(netdev, NETIF_F_TSO_BIT);
 	}
 
 	adapter->is_active_trunk = false;
 	if (ret == H_SUCCESS && (ret_attr & IBMVETH_ILLAN_ACTIVE_TRUNK)) {
 		adapter->is_active_trunk = true;
-		netdev->hw_features |= NETIF_F_FRAGLIST;
-		netdev->features |= NETIF_F_FRAGLIST;
+		netdev_hw_feature_add(netdev, NETIF_F_FRAGLIST_BIT);
+		netdev_active_feature_add(netdev, NETIF_F_FRAGLIST_BIT);
 	}
 
 	netdev->min_mtu = IBMVETH_MIN_MTU;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 0ceecd372b7e..5b757634973d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4879,18 +4879,18 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	netdev_hw_features_set_array(adapter->netdev, &ibmvnic_hw_feature_set);
 
 	if (buf->tcp_ipv4_chksum || buf->udp_ipv4_chksum)
-		adapter->netdev->hw_features |= NETIF_F_IP_CSUM;
+		netdev_hw_feature_add(adapter->netdev, NETIF_F_IP_CSUM_BIT);
 
 	if (buf->tcp_ipv6_chksum || buf->udp_ipv6_chksum)
-		adapter->netdev->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev_hw_feature_add(adapter->netdev, NETIF_F_IPV6_CSUM_BIT);
 
 	if ((adapter->netdev->features & netdev_ip_csum_features))
-		adapter->netdev->hw_features |= NETIF_F_RXCSUM;
+		netdev_hw_feature_add(adapter->netdev, NETIF_F_RXCSUM_BIT);
 
 	if (buf->large_tx_ipv4)
-		adapter->netdev->hw_features |= NETIF_F_TSO;
+		netdev_hw_feature_add(adapter->netdev, NETIF_F_TSO_BIT);
 	if (buf->large_tx_ipv6)
-		adapter->netdev->hw_features |= NETIF_F_TSO6;
+		netdev_hw_feature_add(adapter->netdev, NETIF_F_TSO6_BIT);
 
 	if (adapter->state == VNIC_PROBING) {
 		adapter->netdev->features |= adapter->netdev->hw_features;
@@ -5409,7 +5409,8 @@ static void handle_query_cap_rsp(union ibmvnic_crq *crq,
 		adapter->vlan_header_insertion =
 		    be64_to_cpu(crq->query_capability.number);
 		if (adapter->vlan_header_insertion)
-			netdev->features |= NETIF_F_HW_VLAN_STAG_TX;
+			netdev_active_feature_add(netdev,
+						  NETIF_F_HW_VLAN_STAG_TX_BIT);
 		netdev_dbg(netdev, "vlan_header_insertion = %lld\n",
 			   adapter->vlan_header_insertion);
 		break;
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 2809f6c0f69a..960411b8d77c 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -138,6 +138,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/mii.h>
 #include <linux/if_vlan.h>
@@ -2837,9 +2838,9 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!(netdev = alloc_etherdev(sizeof(struct nic))))
 		return -ENOMEM;
 
-	netdev->hw_features |= NETIF_F_RXFCS;
+	netdev_hw_feature_add(netdev, NETIF_F_RXFCS_BIT);
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
-	netdev->hw_features |= NETIF_F_RXALL;
+	netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
 
 	netdev->netdev_ops = &e100_netdev_ops;
 	netdev->ethtool_ops = &e100_ethtool_ops;
@@ -2896,7 +2897,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* D100 MAC doesn't allow rx of vlan packets with normal MTU */
 	if (nic->mac < mac_82558_D101_A4)
-		netdev->features |= NETIF_F_VLAN_CHALLENGED;
+		netdev_active_feature_add(netdev, NETIF_F_VLAN_CHALLENGED_BIT);
 
 	/* locks must be initialized before calling hw_reset */
 	spin_lock_init(&nic->cb_lock);
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 9564fdef837d..ea3a958a8945 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -794,7 +794,7 @@ static netdev_features_t e1000_fix_features(struct net_device *netdev,
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -1059,7 +1059,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if ((hw->mac_type >= e1000_82544) &&
 	   (hw->mac_type != e1000_82547))
-		netdev->hw_features |= NETIF_F_TSO;
+		netdev_hw_feature_add(netdev, NETIF_F_TSO_BIT);
 
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
 
@@ -1067,8 +1067,8 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_set_array(netdev, &e1000_hw_rx_feature_set);
 
 	if (pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
+		netdev_vlan_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 	}
 
 	netdev_vlan_features_set_array(netdev, &e1000_vlan_feature_set);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 7ef3e3e56dfa..439fb2110c55 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7302,7 +7302,7 @@ static netdev_features_t e1000_fix_features(struct net_device *netdev,
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -7550,19 +7550,20 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Set user-changeable features (subset of all device features) */
 	netdev->hw_features = netdev->features;
-	netdev->hw_features |= NETIF_F_RXFCS;
+	netdev_hw_feature_add(netdev, NETIF_F_RXFCS_BIT);
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
-	netdev->hw_features |= NETIF_F_RXALL;
+	netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
 
 	if (adapter->flags & FLAG_HAS_HW_VLAN_FILTER)
-		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_add(netdev,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	netdev_vlan_features_set_array(netdev, &e1000_vlan_feature_set);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev->features |= NETIF_F_HIGHDMA;
-	netdev->vlan_features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	/* MTU range: 68 - max_hw_frame_size */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k.h b/drivers/net/ethernet/intel/fm10k/fm10k.h
index 6119a4108838..fc00769f4a01 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k.h
+++ b/drivers/net/ethernet/intel/fm10k/fm10k.h
@@ -7,6 +7,7 @@
 #include <linux/types.h>
 #include <linux/etherdevice.h>
 #include <linux/cpumask.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/rtnetlink.h>
 #include <linux/if_vlan.h>
 #include <linux/pci.h>
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 2e0e7bc100e8..e51f05bfaa1d 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1583,7 +1583,7 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 		netdev_hw_enc_features_zero(dev);
 		netdev_hw_enc_features_set_array(dev, &fm10k_hw_enc_feature_set);
 
-		dev->features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_active_feature_add(dev, NETIF_F_GSO_UDP_TUNNEL_BIT);
 
 		dev->udp_tunnel_nic_info = &fm10k_udp_tunnels;
 	}
@@ -1592,7 +1592,7 @@ struct net_device *fm10k_alloc_netdev(const struct fm10k_info *info)
 	hw_features = dev->features;
 
 	/* allow user to enable L2 forwarding acceleration */
-	hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
+	netdev_feature_add(NETIF_F_HW_L2FW_DOFFLOAD_BIT, &hw_features);
 
 	/* configure VLAN features */
 	dev->vlan_features |= dev->features;
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
index b473cb7d7c57..d5be43c80c14 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pci.c
@@ -307,7 +307,8 @@ static int fm10k_handle_reset(struct fm10k_intfc *interface)
 		if (hw->mac.vlan_override)
 			netdev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 		else
-			netdev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_active_feature_add(netdev,
+						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
 
 	err = netif_running(netdev) ? fm10k_open(netdev) : 0;
@@ -2010,8 +2011,8 @@ static int fm10k_sw_init(struct fm10k_intfc *interface,
 
 	/* update netdev with DMA restrictions */
 	if (dma_get_mask(&pdev->dev) > DMA_BIT_MASK(32)) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
+		netdev_vlan_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 	}
 
 	/* reset and initialize the hardware so it is in a known state */
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index d7d628af7435..0eb64901e3e1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13680,43 +13680,44 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 	netdev_features_set_array(&i40e_hw_enc_feature_set, &hw_enc_features);
 
 	if (!(pf->hw_features & I40E_HW_OUTER_UDP_CSUM_CAPABLE))
-		netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_gso_partial_feature_add(netdev,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 	netdev->udp_tunnel_nic_info = &pf->udp_tunnel_nic;
 
-	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+	netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
 
 	netdev->hw_enc_features |= hw_enc_features;
 
 	/* record features VLANs can make use of */
 	netdev->vlan_features |= hw_enc_features;
-	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
+	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
 	netdev_features_zero(&gso_partial_features);
 	netdev_features_set_array(&i40e_gso_partial_feature_set,
 				  &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev->features |= gso_partial_features;
 
 	netdev_mpls_features_set_array(netdev, &i40e_mpls_feature_set);
 	netdev->mpls_features |= gso_partial_features;
 
 	/* enable macvlan offloads */
-	netdev->hw_features |= NETIF_F_HW_L2FW_DOFFLOAD;
+	netdev_hw_feature_add(netdev, NETIF_F_HW_L2FW_DOFFLOAD_BIT);
 
 	hw_features = hw_enc_features | netdev_ctag_vlan_offload_features;
 
 	if (!(pf->flags & I40E_FLAG_MFP_ENABLED)) {
-		hw_features |= NETIF_F_NTUPLE;
-		hw_features |= NETIF_F_HW_TC;
+		netdev_feature_add(NETIF_F_NTUPLE_BIT, &hw_features);
+		netdev_feature_add(NETIF_F_HW_TC_BIT, &hw_features);
 	}
 
 	netdev->hw_features |= hw_features;
 
 	netdev->features |= hw_features;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-	netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+	netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
 	netdev->features &= ~NETIF_F_HW_TC;
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 1f9884539807..19b79755ddda 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4337,31 +4337,37 @@ iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 		    stripping_support->outer & VIRTCHNL_VLAN_TOGGLE) {
 			if (stripping_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100)
-				hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						   &hw_features);
 			if (stripping_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_88A8)
-				hw_features |= NETIF_F_HW_VLAN_STAG_RX;
+				netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT,
+						   &hw_features);
 		} else if (stripping_support->inner !=
 			   VIRTCHNL_VLAN_UNSUPPORTED &&
 			   stripping_support->inner & VIRTCHNL_VLAN_TOGGLE) {
 			if (stripping_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100)
-				hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						   &hw_features);
 		}
 
 		if (insertion_support->outer != VIRTCHNL_VLAN_UNSUPPORTED &&
 		    insertion_support->outer & VIRTCHNL_VLAN_TOGGLE) {
 			if (insertion_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100)
-				hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+						   &hw_features);
 			if (insertion_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_88A8)
-				hw_features |= NETIF_F_HW_VLAN_STAG_TX;
+				netdev_feature_add(NETIF_F_HW_VLAN_STAG_TX_BIT,
+						   &hw_features);
 		} else if (insertion_support->inner &&
 			   insertion_support->inner & VIRTCHNL_VLAN_TOGGLE) {
 			if (insertion_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100)
-				hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+						   &hw_features);
 		}
 	}
 
@@ -4404,17 +4410,20 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 			if (stripping_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
-				features |= NETIF_F_HW_VLAN_CTAG_RX;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						   &features);
 			else if (stripping_support->outer &
 				 VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
 				 ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
-				features |= NETIF_F_HW_VLAN_STAG_RX;
+				netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT,
+						   &features);
 		} else if (stripping_support->inner !=
 			   VIRTCHNL_VLAN_UNSUPPORTED) {
 			if (stripping_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
-				features |= NETIF_F_HW_VLAN_CTAG_RX;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
+						   &features);
 		}
 
 		/* give priority to outer insertion and don't support both outer
@@ -4424,17 +4433,20 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 			if (insertion_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
-				features |= NETIF_F_HW_VLAN_CTAG_TX;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+						   &features);
 			else if (insertion_support->outer &
 				 VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
 				 ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
-				features |= NETIF_F_HW_VLAN_STAG_TX;
+				netdev_feature_add(NETIF_F_HW_VLAN_STAG_TX_BIT,
+						   &features);
 		} else if (insertion_support->inner !=
 			   VIRTCHNL_VLAN_UNSUPPORTED) {
 			if (insertion_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
-				features |= NETIF_F_HW_VLAN_CTAG_TX;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT,
+						   &features);
 		}
 
 		/* give priority to outer filtering and don't bother if both
@@ -4445,21 +4457,25 @@ iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 			if (filtering_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
-				features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						   &features);
 			if (filtering_support->outer &
 			    VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
-				features |= NETIF_F_HW_VLAN_STAG_FILTER;
+				netdev_feature_add(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+						   &features);
 		} else if (filtering_support->inner !=
 			   VIRTCHNL_VLAN_UNSUPPORTED) {
 			if (filtering_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_8100 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_8100)
-				features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						   &features);
 			if (filtering_support->inner &
 			    VIRTCHNL_VLAN_ETHERTYPE_88A8 &&
 			    ethertype_init & VIRTCHNL_VLAN_ETHERTYPE_88A8)
-				features |= NETIF_F_HW_VLAN_STAG_FILTER;
+				netdev_feature_add(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+						   &features);
 		}
 	}
 
@@ -4624,16 +4640,17 @@ int iavf_process_config(struct iavf_adapter *adapter)
 
 		if (!(vfres->vf_cap_flags &
 		      VIRTCHNL_VF_OFFLOAD_ENCAP_CSUM))
-			netdev->gso_partial_features |=
-				NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_gso_partial_feature_add(netdev,
+						       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
-		netdev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+		netdev_gso_partial_feature_add(netdev,
+					       NETIF_F_GSO_GRE_CSUM_BIT);
+		netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 		netdev->hw_enc_features |= hw_enc_features;
 	}
 	/* record features VLANs can make use of */
 	netdev->vlan_features |= hw_enc_features;
-	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
+	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
 	/* Write features and hw_features separately to avoid polluting
 	 * with, or dropping, features that are set when we registered.
@@ -4645,9 +4662,9 @@ int iavf_process_config(struct iavf_adapter *adapter)
 
 	/* Enable cloud filter if ADQ is supported */
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_ADQ)
-		hw_features |= NETIF_F_HW_TC;
+		netdev_feature_add(NETIF_F_HW_TC_BIT, &hw_features);
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_USO)
-		hw_features |= NETIF_F_GSO_UDP_L4;
+		netdev_feature_add(NETIF_F_GSO_UDP_L4_BIT, &hw_features);
 
 	netdev->hw_features |= hw_features;
 	netdev->hw_features |= hw_vlan_features;
@@ -4657,7 +4674,8 @@ int iavf_process_config(struct iavf_adapter *adapter)
 	netdev->features |= vlan_features;
 
 	if (vfres->vf_cap_flags & VIRTCHNL_VF_OFFLOAD_VLAN)
-		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_add(netdev,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 15ee85dc33bd..56bca0d7b0f5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -1878,7 +1878,7 @@ static void iavf_netdev_features_vlan_strip_set(struct net_device *netdev,
 						const bool enable)
 {
 	if (enable)
-		netdev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	else
 		netdev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 107caaac78ea..d0ecd7f3302a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3355,13 +3355,15 @@ static void ice_set_netdev_features(struct net_device *netdev)
 
 	/* Enable CTAG/STAG filtering by default in Double VLAN Mode (DVM) */
 	if (is_dvm_ena)
-		vlano_features |= NETIF_F_HW_VLAN_STAG_FILTER;
+		netdev_feature_add(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
+				   &vlano_features);
 
 	netdev_features_zero(&tso_features);
 	netdev_features_set_array(&ice_tso_feature_set, &tso_features);
 
-	netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+	netdev_gso_partial_feature_add(netdev,
+				       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+	netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
 	/* set features that user can change */
 	netdev->hw_features = dflt_features | csumo_features;
 	netdev->hw_features |= vlano_features;
@@ -3374,8 +3376,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	/* enable features */
 	netdev->features |= netdev->hw_features;
 
-	netdev->hw_features |= NETIF_F_HW_TC;
-	netdev->hw_features |= NETIF_F_LOOPBACK;
+	netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_LOOPBACK_BIT);
 
 	/* encap and VLAN devices inherit default, csumo and tso features */
 	netdev->hw_enc_features |= dflt_features;
@@ -5806,7 +5808,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 				netdev_warn(netdev, "cannot support requested 802.1ad filtering setting in SVM mode\n");
 
 			if (req_vlan_fltr & NETIF_F_HW_VLAN_CTAG_FILTER)
-				features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+				netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+						   &features);
 		}
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 0dac67cd9c77..d685d608ce16 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -276,7 +276,7 @@ ice_repr_reg_netdev(struct net_device *netdev)
 	netdev->netdev_ops = &ice_repr_netdev_ops;
 	ice_set_ethtool_repr_ops(netdev);
 
-	netdev->hw_features |= NETIF_F_HW_TC;
+	netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 3d0af1c6d13e..14e391e4bc23 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2439,7 +2439,7 @@ static netdev_features_t igb_fix_features(struct net_device *netdev,
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -3299,32 +3299,32 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_active_features_set_array(netdev, &igb_feature_set);
 
 	if (hw->mac.type >= e1000_82576) {
-		netdev->features |= NETIF_F_SCTP_CRC;
-		netdev->features |= NETIF_F_GSO_UDP_L4;
+		netdev_active_feature_add(netdev, NETIF_F_SCTP_CRC_BIT);
+		netdev_active_feature_add(netdev, NETIF_F_GSO_UDP_L4_BIT);
 	}
 
 	if (hw->mac.type >= e1000_i350)
-		netdev->features |= NETIF_F_HW_TC;
+		netdev_active_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
 	netdev_features_zero(&gso_partial_features);
 	netdev_features_set_array(&igb_feature_set, &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev->features |= gso_partial_features;
 
 	/* copy netdev features into list of user selectable features */
 	netdev->hw_features |= netdev->features;
 	netdev->hw_features |= netdev_ctag_vlan_offload_features;
-	netdev->hw_features |= NETIF_F_RXALL;
+	netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
 
 	if (hw->mac.type >= e1000_i350)
-		netdev->hw_features |= NETIF_F_NTUPLE;
+		netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
 
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev->vlan_features |= netdev->features;
-	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
-	netdev->mpls_features |= NETIF_F_HW_CSUM;
+	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
+	netdev_mpls_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 6994f573fadf..55685206eac1 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2794,15 +2794,15 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				  &gso_partial_features);
 
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->hw_features |= NETIF_F_GSO_PARTIAL;
+	netdev_hw_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev->hw_features |= gso_partial_features;
 
 	netdev->features = netdev->hw_features;
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev->vlan_features |= netdev->features;
-	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
-	netdev->mpls_features |= NETIF_F_HW_CSUM;
+	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
+	netdev_mpls_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* set this bit last since it cannot be part of vlan_features */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 805243e7c4cb..f53175a80606 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4941,7 +4941,7 @@ static netdev_features_t igc_fix_features(struct net_device *netdev,
 	 * enable/disable make sure Tx flag is always in same state as Rx.
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_CTAG_TX;
 
@@ -6335,7 +6335,7 @@ static int igc_probe(struct pci_dev *pdev,
 	netdev_features_set_array(&igc_gso_partial_feature_set,
 				  &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev->features |= gso_partial_features;
 
 	/* setup the private structure */
@@ -6344,16 +6344,16 @@ static int igc_probe(struct pci_dev *pdev,
 		goto err_sw_init;
 
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= NETIF_F_NTUPLE;
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	netdev->hw_features |= netdev->features;
 
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev->vlan_features |= netdev->features;
-	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
-	netdev->mpls_features |= NETIF_F_HW_CSUM;
+	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
+	netdev_mpls_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	netdev->hw_enc_features |= netdev->vlan_features;
 
 	/* MTU range: 68 - 9216 */
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index d23b7a10d62f..7630db8cc290 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -439,11 +439,11 @@ ixgb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_zero(netdev);
 	netdev_hw_features_set_array(netdev, &ixgb_hw_feature_set);
 	netdev->features = netdev->hw_features;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-	netdev->hw_features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
-	netdev->features |= NETIF_F_HIGHDMA;
-	netdev->vlan_features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	/* MTU range: 68 - 16114 */
 	netdev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 5369a97ff5ec..6b16a124b047 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/cpumask.h>
 #include <linux/aer.h>
 #include <linux/if_vlan.h>
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
index 0fcd82036d4e..603a910aa611 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c
@@ -858,7 +858,7 @@ int ixgbe_fcoe_enable(struct net_device *netdev)
 
 	/* enable FCoE and notify stack */
 	adapter->flags |= IXGBE_FLAG_FCOE_ENABLED;
-	netdev->features |= NETIF_F_FCOE_MTU;
+	netdev_active_feature_add(netdev, NETIF_F_FCOE_MTU_BIT);
 	netdev_features_change(netdev);
 
 	/* release existing queues and reallocate them */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0b6b5cfa84df..40228bff5e82 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11021,12 +11021,12 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				  &gso_partial_features);
 
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->features |= NETIF_F_GSO_PARTIAL;
+	netdev_active_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev->features |= gso_partial_features;
 
 	if (hw->mac.type >= ixgbe_mac_82599EB) {
-		netdev->features |= NETIF_F_SCTP_CRC;
-		netdev->features |= NETIF_F_GSO_UDP_L4;
+		netdev_active_feature_add(netdev, NETIF_F_SCTP_CRC_BIT);
+		netdev_active_feature_add(netdev, NETIF_F_GSO_UDP_L4_BIT);
 	}
 
 #ifdef CONFIG_IXGBE_IPSEC
@@ -11038,14 +11038,14 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_set_array(netdev, &ixgbe_hw_feature_set);
 
 	if (hw->mac.type >= ixgbe_mac_82599EB) {
-		netdev->hw_features |= NETIF_F_NTUPLE;
-		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 	}
 
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev->vlan_features |= netdev->features;
-	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
+	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 	netdev->hw_enc_features |= netdev->vlan_features;
 	netdev_mpls_features_set_array(netdev, &ixgbe_mpls_feature_set);
 	netdev->mpls_features |= gso_partial_features;
@@ -11084,9 +11084,9 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 #endif /* IXGBE_FCOE */
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_CAPABLE)
-		netdev->hw_features |= NETIF_F_LRO;
+		netdev_hw_feature_add(netdev, NETIF_F_LRO_BIT);
 	if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
-		netdev->features |= NETIF_F_LRO;
+		netdev_active_feature_add(netdev, NETIF_F_LRO_BIT);
 
 	if (ixgbe_check_fw_error(adapter)) {
 		err = -EIO;
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index db20be0b4fb1..79d2400b03df 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4633,14 +4633,14 @@ static int ixgbevf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_features_set_array(&ixgbevf_gso_partial_feature_set,
 				  &gso_partial_features);
 	netdev->gso_partial_features = gso_partial_features;
-	netdev->hw_features |= NETIF_F_GSO_PARTIAL;
+	netdev_hw_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	netdev->hw_features |= gso_partial_features;
 
 	netdev->features = netdev->hw_features;
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev->vlan_features |= netdev->features;
-	netdev->vlan_features |= NETIF_F_TSO_MANGLEID;
+	netdev_vlan_feature_add(netdev, NETIF_F_TSO_MANGLEID_BIT);
 
 	netdev_mpls_features_set_array(netdev, &ixgbevf_mpls_feature_set);
 	netdev->mpls_features |= gso_partial_features;
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index 96f2402f6cb4..fbc3467a36ce 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2979,7 +2979,7 @@ jme_init_one(struct pci_dev *pdev,
 	netdev_active_features_zero(netdev);
 	netdev_active_features_set_array(netdev, &jme_feature_set);
 	if (using_dac)
-		netdev->features	|=	NETIF_F_HIGHDMA;
+		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	/* MTU range: 1280 - 9202*/
 	netdev->min_mtu = IPV6_MIN_MTU;
@@ -3042,7 +3042,7 @@ jme_init_one(struct pci_dev *pdev,
 	jme->reg_gpreg1 = GPREG1_DEFAULT;
 
 	if (jme->reg_rxmcs & RXMCS_CHECKSUM)
-		netdev->features |= NETIF_F_RXCSUM;
+		netdev_active_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
 	/*
 	 * Get Max Read Req Size from PCI Config Space
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index e43fa3a2af17..b91318551538 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -3210,7 +3210,7 @@ static int mv643xx_eth_probe(struct platform_device *pdev)
 	netdev_active_features_set_array(dev, &mv643xx_feature_set);
 	dev->vlan_features = dev->features;
 
-	dev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	dev->hw_features = dev->features;
 
 	dev->priv_flags |= IFF_UNICAST_FLT;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 8aa5dd6cce91..ce17ed4b8828 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6859,13 +6859,13 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	netdev_features_zero(&features);
 	netdev_features_set_array(&mvpp2_feature_set, &features);
 	dev->features = features;
-	dev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	dev->hw_features |= features;
 	netdev_hw_features_set_array(dev, &mvpp2_hw_feature_set);
 
 	if (mvpp22_rss_is_supported(port)) {
-		dev->hw_features |= NETIF_F_RXHASH;
-		dev->features |= NETIF_F_NTUPLE;
+		netdev_hw_feature_add(dev, NETIF_F_RXHASH_BIT);
+		netdev_active_feature_add(dev, NETIF_F_NTUPLE_BIT);
 	}
 
 	if (!port->priv->percpu_pools)
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 42973668ca53..bde76afe991d 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -1066,7 +1066,7 @@ static int octep_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netif_carrier_off(netdev);
 
 	netdev_hw_features_zero(netdev);
-	netdev->hw_features |= NETIF_F_SG;
+	netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
 	netdev->features |= netdev->hw_features;
 	netdev->min_mtu = OCTEP_MIN_MTU;
 	netdev->max_mtu = OCTEP_MAX_MTU;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 888fb6dde97b..fc61e17b300f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1858,7 +1858,7 @@ static netdev_features_t otx2_fix_features(struct net_device *dev,
 					   netdev_features_t features)
 {
 	if (features & NETIF_F_HW_VLAN_CTAG_RX)
-		features |= NETIF_F_HW_VLAN_STAG_RX;
+		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_STAG_RX;
 
@@ -2712,7 +2712,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_ptp_destroy;
 
 	if (pf->flags & OTX2_FLAG_NTUPLE_SUPPORT)
-		netdev->hw_features |= NETIF_F_NTUPLE;
+		netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
 
 	if (pf->flags & OTX2_FLAG_UCAST_FLTR_SUPPORT)
 		netdev->priv_flags |= IFF_UNICAST_FLT;
@@ -2726,10 +2726,10 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* HW supports tc offload but mutually exclusive with n-tuple filters */
 	if (pf->flags & OTX2_FLAG_TC_FLOWER_SUPPORT)
-		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
-	netdev->hw_features |= NETIF_F_LOOPBACK;
-	netdev->hw_features |= NETIF_F_RXALL;
+	netdev_hw_feature_add(netdev, NETIF_F_LOOPBACK_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
 
 	netif_set_tso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 9aa8fe79bb2b..d75a09f291b0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -656,9 +656,9 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	netdev->hw_features  |= netdev_tx_vlan_features;
 	netdev->features |= netdev->hw_features;
 
-	netdev->hw_features |= NETIF_F_NTUPLE;
-	netdev->hw_features |= NETIF_F_RXALL;
-	netdev->hw_features |= NETIF_F_HW_TC;
+	netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
 	netif_set_tso_max_segs(netdev, OTX2_MAX_GSO_SEGS);
 	netdev->watchdog_timeo = OTX2_TX_TIMEOUT;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 23dde8129492..29e0e30c252b 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -6,6 +6,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
 #include <linux/if_vlan.h>
@@ -622,8 +623,8 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 	if (err)
 		goto err_dl_port_register;
 
-	dev->features |= NETIF_F_NETNS_LOCAL;
-	dev->features |= NETIF_F_HW_TC;
+	netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
+	netdev_active_feature_add(dev, NETIF_F_HW_TC_BIT);
 	dev->netdev_ops = &prestera_netdev_ops;
 	dev->ethtool_ops = &prestera_ethtool_ops;
 	SET_NETDEV_DEV(dev, sw->dev->dev);
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 8bdac1c90c0c..9f16ade3e439 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3834,7 +3834,7 @@ static struct net_device *skge_devinit(struct skge_hw *hw, int port,
 	dev->max_mtu = ETH_JUMBO_MTU;
 
 	if (highmem)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	skge = netdev_priv(dev);
 	netif_napi_add(dev, &skge->napi, skge_poll, NAPI_POLL_WEIGHT);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 98574f083375..01e9893f73bb 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4326,7 +4326,7 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 	     !(features & NETIF_F_RXCSUM) &&
 	     (sky2->hw->flags & SKY2_HW_RSS_CHKSUM)) {
 		netdev_info(dev, "receive hashing forces receive checksum\n");
-		features |= NETIF_F_RXCSUM;
+		netdev_feature_add(NETIF_F_RXCSUM_BIT, &features);
 	}
 
 	return features;
@@ -4626,7 +4626,7 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	/* Auto speed and flow control */
 	sky2->flags = SKY2_FLAG_AUTO_SPEED | SKY2_FLAG_AUTO_PAUSE;
 	if (hw->chip_id != CHIP_ID_YUKON_XL)
-		dev->hw_features |= NETIF_F_RXCSUM;
+		netdev_hw_feature_add(dev, NETIF_F_RXCSUM_BIT);
 
 	sky2->flow_mode = FC_BOTH;
 
@@ -4648,11 +4648,11 @@ static struct net_device *sky2_init_netdev(struct sky2_hw *hw, unsigned port,
 	netdev_hw_features_set_array(dev, &sky2_hw_feature_set);
 
 	if (highmem)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	/* Enable receive hashing unless hardware is known broken */
 	if (!(hw->flags & SKY2_HW_RSS_BROKEN))
-		dev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(dev, NETIF_F_RXHASH_BIT);
 
 	if (!(hw->flags & SKY2_HW_VLAN_BROKEN)) {
 		dev->hw_features |= netdev_ctag_vlan_offload_features;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e412cc11ed58..0043f387449f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2716,7 +2716,7 @@ static netdev_features_t mtk_fix_features(struct net_device *dev,
 		if (ip_cnt) {
 			netdev_info(dev, "RX flow is programmed, LRO should keep on\n");
 
-			features |= NETIF_F_LRO;
+			netdev_feature_add(NETIF_F_LRO_BIT, &features);
 		}
 	}
 
@@ -3897,7 +3897,7 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 
 	eth->netdev[id]->hw_features = *eth->soc->hw_features;
 	if (eth->hwlro)
-		eth->netdev[id]->hw_features |= NETIF_F_LRO;
+		netdev_hw_feature_add(eth->netdev[id], NETIF_F_LRO_BIT);
 
 	eth->netdev[id]->vlan_features = *eth->soc->hw_features &
 		~netdev_ctag_vlan_offload_features;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 5791f48367ef..080b5450e3a8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2508,7 +2508,7 @@ static netdev_features_t mlx4_en_fix_features(struct net_device *netdev,
 	 */
 	if (features & NETIF_F_HW_VLAN_CTAG_RX &&
 	    !(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
-		features |= NETIF_F_HW_VLAN_STAG_RX;
+		netdev_feature_add(NETIF_F_HW_VLAN_STAG_RX_BIT, &features);
 	else
 		features &= ~NETIF_F_HW_VLAN_STAG_RX;
 
@@ -3368,7 +3368,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		netdev_hw_features_set_array(dev, &mlx4_gso_feature_set);
 		netdev_active_features_set_array(dev, &mlx4_gso_feature_set);
 		netdev_gso_partial_features_zero(dev);
-		dev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_gso_partial_feature_add(dev, NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 		netdev_hw_enc_features_zero(dev);
 		netdev_hw_enc_features_set_array(dev, &mlx4_hw_enc_feature_set);
 
@@ -3383,9 +3383,10 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	netdev_hw_features_set_array(dev, &mlx4_hw_feature_set3);
 
 	if (!(mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN)) {
-		dev->features |= NETIF_F_HW_VLAN_STAG_RX;
-		dev->features |= NETIF_F_HW_VLAN_STAG_FILTER;
-		dev->hw_features |= NETIF_F_HW_VLAN_STAG_RX;
+		netdev_active_feature_add(dev, NETIF_F_HW_VLAN_STAG_RX_BIT);
+		netdev_active_feature_add(dev,
+					  NETIF_F_HW_VLAN_STAG_FILTER_BIT);
+		netdev_hw_feature_add(dev, NETIF_F_HW_VLAN_STAG_RX_BIT);
 	}
 
 	if (mlx4_is_slave(mdev->dev)) {
@@ -3394,7 +3395,8 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 
 		err = get_phv_bit(mdev->dev, port, &phv);
 		if (!err && phv) {
-			dev->hw_features |= NETIF_F_HW_VLAN_STAG_TX;
+			netdev_hw_feature_add(dev,
+					      NETIF_F_HW_VLAN_STAG_TX_BIT);
 			priv->pflags |= MLX4_EN_PRIV_FLAGS_PHV;
 		}
 		err = mlx4_get_is_vlan_offload_disabled(mdev->dev, port,
@@ -3407,19 +3409,20 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_PHV_EN &&
 		    !(mdev->dev->caps.flags2 &
 		      MLX4_DEV_CAP_FLAG2_SKIP_OUTER_VLAN))
-			dev->hw_features |= NETIF_F_HW_VLAN_STAG_TX;
+			netdev_hw_feature_add(dev,
+					      NETIF_F_HW_VLAN_STAG_TX_BIT);
 	}
 
 	if (mdev->dev->caps.flags & MLX4_DEV_CAP_FLAG_FCS_KEEP)
-		dev->hw_features |= NETIF_F_RXFCS;
+		netdev_hw_feature_add(dev, NETIF_F_RXFCS_BIT);
 
 	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_IGNORE_FCS)
-		dev->hw_features |= NETIF_F_RXALL;
+		netdev_hw_feature_add(dev, NETIF_F_RXALL_BIT);
 
 	if (mdev->dev->caps.steering_mode ==
 	    MLX4_STEERING_MODE_DEVICE_MANAGED &&
 	    mdev->dev->caps.dmfs_high_steer_mode != MLX4_STEERING_DMFS_A0_STATIC)
-		dev->hw_features |= NETIF_F_NTUPLE;
+		netdev_hw_feature_add(dev, NETIF_F_NTUPLE_BIT);
 
 	if (mdev->dev->caps.steering_mode != MLX4_STEERING_MODE_A0)
 		dev->priv_flags |= IFF_UNICAST_FLT;
@@ -3559,7 +3562,8 @@ int mlx4_en_reset_config(struct net_device *dev,
 
 	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 		if (features & NETIF_F_HW_VLAN_CTAG_RX)
-			dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_active_feature_add(dev,
+						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		else
 			dev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 	} else if (ts_config.rx_filter == HWTSTAMP_FILTER_NONE) {
@@ -3567,14 +3571,15 @@ int mlx4_en_reset_config(struct net_device *dev,
 		 * to the latest wanted state
 		 */
 		if (dev->wanted_features & NETIF_F_HW_VLAN_CTAG_RX)
-			dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+			netdev_active_feature_add(dev,
+						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		else
 			dev->features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 	}
 
 	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT)) {
 		if (features & NETIF_F_RXFCS)
-			dev->features |= NETIF_F_RXFCS;
+			netdev_active_feature_add(dev, NETIF_F_RXFCS_BIT);
 		else
 			dev->features &= ~NETIF_F_RXFCS;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 2a8fd7020622..12b6101a50d2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -448,25 +448,25 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 
 	mlx5_core_info(mdev, "mlx5e: IPSec ESP acceleration enabled\n");
 	netdev->xfrmdev_ops = &mlx5e_ipsec_xfrmdev_ops;
-	netdev->features |= NETIF_F_HW_ESP;
-	netdev->hw_enc_features |= NETIF_F_HW_ESP;
+	netdev_active_feature_add(netdev, NETIF_F_HW_ESP_BIT);
+	netdev_hw_enc_feature_add(netdev, NETIF_F_HW_ESP_BIT);
 
 	if (!MLX5_CAP_ETH(mdev, swp_csum)) {
 		mlx5_core_dbg(mdev, "mlx5e: SWP checksum not supported\n");
 		return;
 	}
 
-	netdev->features |= NETIF_F_HW_ESP_TX_CSUM;
-	netdev->hw_enc_features |= NETIF_F_HW_ESP_TX_CSUM;
+	netdev_active_feature_add(netdev, NETIF_F_HW_ESP_TX_CSUM_BIT);
+	netdev_hw_enc_feature_add(netdev, NETIF_F_HW_ESP_TX_CSUM_BIT);
 
 	if (!MLX5_CAP_ETH(mdev, swp_lso)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP LSO not supported\n");
 		return;
 	}
 
-	netdev->gso_partial_features |= NETIF_F_GSO_ESP;
+	netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_ESP_BIT);
 	mlx5_core_dbg(mdev, "mlx5e: ESP GSO capability turned on\n");
-	netdev->features |= NETIF_F_GSO_ESP;
-	netdev->hw_features |= NETIF_F_GSO_ESP;
-	netdev->hw_enc_features |= NETIF_F_GSO_ESP;
+	netdev_active_feature_add(netdev, NETIF_F_GSO_ESP_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_GSO_ESP_BIT);
+	netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_ESP_BIT);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
index 30a70d139046..885c85dbfe73 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.c
@@ -101,12 +101,12 @@ void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 		return;
 
 	if (mlx5e_is_ktls_tx(mdev)) {
-		netdev->hw_features |= NETIF_F_HW_TLS_TX;
-		netdev->features    |= NETIF_F_HW_TLS_TX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TLS_TX_BIT);
+		netdev_active_feature_add(netdev, NETIF_F_HW_TLS_TX_BIT);
 	}
 
 	if (mlx5e_is_ktls_rx(mdev))
-		netdev->hw_features |= NETIF_F_HW_TLS_RX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TLS_RX_BIT);
 
 	netdev->tlsdev_ops = &mlx5e_ktls_ops;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f702ba4da89a..ddedeac29935 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4882,22 +4882,22 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->ethtool_ops	  = &mlx5e_ethtool_ops;
 
-	netdev->vlan_features    |= NETIF_F_SG;
-	netdev->vlan_features    |= NETIF_F_HW_CSUM;
-	netdev->vlan_features    |= NETIF_F_GRO;
-	netdev->vlan_features    |= NETIF_F_TSO;
-	netdev->vlan_features    |= NETIF_F_TSO6;
-	netdev->vlan_features    |= NETIF_F_RXCSUM;
-	netdev->vlan_features    |= NETIF_F_RXHASH;
-	netdev->vlan_features    |= NETIF_F_GSO_PARTIAL;
-
-	netdev->mpls_features    |= NETIF_F_SG;
-	netdev->mpls_features    |= NETIF_F_HW_CSUM;
-	netdev->mpls_features    |= NETIF_F_TSO;
-	netdev->mpls_features    |= NETIF_F_TSO6;
-
-	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_vlan_feature_add(netdev, NETIF_F_SG_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_GRO_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_TSO_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_TSO6_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_RXCSUM_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_RXHASH_BIT);
+	netdev_vlan_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
+
+	netdev_mpls_feature_add(netdev, NETIF_F_SG_BIT);
+	netdev_mpls_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
+	netdev_mpls_feature_add(netdev, NETIF_F_TSO_BIT);
+	netdev_mpls_feature_add(netdev, NETIF_F_TSO6_BIT);
+
+	netdev_hw_enc_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
+	netdev_hw_enc_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	/* Tunneled LRO is not supported in the driver, and the same RQs are
 	 * shared between inner and outer TIRs, so the driver can't disable LRO
@@ -4908,64 +4908,68 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	    !MLX5_CAP_ETH(mdev, tunnel_lro_vxlan) &&
 	    !MLX5_CAP_ETH(mdev, tunnel_lro_gre) &&
 	    mlx5e_check_fragmented_striding_rq_cap(mdev))
-		netdev->vlan_features    |= NETIF_F_LRO;
+		netdev_vlan_feature_add(netdev, NETIF_F_LRO_BIT);
 
 	netdev->hw_features       = netdev->vlan_features;
-	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_TX;
-	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_RX;
-	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_FILTER;
-	netdev->hw_features      |= NETIF_F_HW_VLAN_STAG_TX;
+	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_STAG_TX_BIT);
 
 	if (mlx5e_tunnel_any_tx_proto_supported(mdev)) {
-		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
-		netdev->hw_enc_features |= NETIF_F_TSO;
-		netdev->hw_enc_features |= NETIF_F_TSO6;
-		netdev->hw_enc_features |= NETIF_F_GSO_PARTIAL;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
+		netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_BIT);
+		netdev_hw_enc_feature_add(netdev, NETIF_F_TSO6_BIT);
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev)) {
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT);
+		netdev_hw_enc_feature_add(netdev,
+					  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 		netdev_gso_partial_features_zero(netdev);
-		netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_gso_partial_feature_add(netdev,
+					       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+		netdev_vlan_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT);
+		netdev_vlan_feature_add(netdev,
+					NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-		netdev->hw_features     |= NETIF_F_GSO_GRE;
-		netdev->hw_features     |= NETIF_F_GSO_GRE_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE_CSUM;
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE;
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_GRE_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_GRE_BIT);
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
+		netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_GRE_BIT);
+		netdev_gso_partial_feature_add(netdev,
+					       NETIF_F_GSO_GRE_CSUM_BIT);
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
-		netdev->hw_features |= NETIF_F_GSO_IPXIP4;
-		netdev->hw_features |= NETIF_F_GSO_IPXIP6;
-		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4;
-		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP6;
-		netdev->gso_partial_features |= NETIF_F_GSO_IPXIP4;
-		netdev->gso_partial_features |= NETIF_F_GSO_IPXIP6;
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_IPXIP4_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_IPXIP6_BIT);
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_IPXIP4_BIT);
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_IPXIP6_BIT);
+		netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_IPXIP4_BIT);
+		netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_IPXIP6_BIT);
 	}
 
-	netdev->gso_partial_features             |= NETIF_F_GSO_UDP_L4;
-	netdev->hw_features                      |= NETIF_F_GSO_UDP_L4;
-	netdev->features                         |= NETIF_F_GSO_UDP_L4;
+	netdev_gso_partial_feature_add(netdev, NETIF_F_GSO_UDP_L4_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_GSO_UDP_L4_BIT);
+	netdev_active_feature_add(netdev, NETIF_F_GSO_UDP_L4_BIT);
 
 	mlx5_query_port_fcs(mdev, &fcs_supported, &fcs_enabled);
 
 	if (fcs_supported)
-		netdev->hw_features |= NETIF_F_RXALL;
+		netdev_hw_feature_add(netdev, NETIF_F_RXALL_BIT);
 
 	if (MLX5_CAP_ETH(mdev, scatter_fcs))
-		netdev->hw_features |= NETIF_F_RXFCS;
+		netdev_hw_feature_add(netdev, NETIF_F_RXFCS_BIT);
 
 	if (mlx5_qos_is_supported(mdev))
-		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
 	netdev->features          = netdev->hw_features;
 
@@ -4982,15 +4986,15 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	    FT_CAP(identified_miss_table_mode) &&
 	    FT_CAP(flow_table_modify)) {
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-		netdev->hw_features      |= NETIF_F_HW_TC;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
-		netdev->hw_features	 |= NETIF_F_NTUPLE;
+		netdev_hw_feature_add(netdev, NETIF_F_NTUPLE_BIT);
 #endif
 	}
 
-	netdev->features         |= NETIF_F_HIGHDMA;
-	netdev->features         |= NETIF_F_HW_VLAN_STAG_FILTER;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
+	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_STAG_FILTER_BIT);
 
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 4c1599de652c..3ee785091aa7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -677,18 +677,18 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev->watchdog_timeo    = 15 * HZ;
 
 #if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
-	netdev->hw_features    |= NETIF_F_HW_TC;
+	netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 #endif
-	netdev->hw_features    |= NETIF_F_SG;
-	netdev->hw_features    |= NETIF_F_IP_CSUM;
-	netdev->hw_features    |= NETIF_F_IPV6_CSUM;
-	netdev->hw_features    |= NETIF_F_GRO;
-	netdev->hw_features    |= NETIF_F_TSO;
-	netdev->hw_features    |= NETIF_F_TSO6;
-	netdev->hw_features    |= NETIF_F_RXCSUM;
+	netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_IP_CSUM_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_IPV6_CSUM_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_GRO_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_TSO_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_TSO6_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
 	netdev->features |= netdev->hw_features;
-	netdev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(netdev, NETIF_F_NETNS_LOCAL_BIT);
 }
 
 static int mlx5e_init_rep(struct mlx5_core_dev *mdev,
@@ -1082,7 +1082,7 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	mlx5e_rep_neigh_init(rpriv);
 	mlx5e_rep_bridge_init(priv);
 
-	netdev->wanted_features |= NETIF_F_HW_TC;
+	netdev_wanted_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
 	rtnl_lock();
 	if (netif_running(netdev))
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 07b6d0124d1a..f421f48cb135 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6718,7 +6718,7 @@ static int __init netdev_init(struct net_device *dev)
 	 * Hardware does not really support IPv6 checksum generation, but
 	 * driver actually runs faster with this on.
 	 */
-	dev->hw_features |= NETIF_F_IPV6_CSUM;
+	netdev_hw_feature_add(dev, NETIF_F_IPV6_CSUM_BIT);
 
 	dev->features |= dev->hw_features;
 
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 2a4e49122b5c..83a3ad14c79f 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -699,7 +699,7 @@ static int myri10ge_get_firmware_capabilities(struct myri10ge_priv *mgp)
 				   &cmd, 0);
 	if (status == 0) {
 		mgp->max_tso6 = cmd.data0;
-		mgp->features |= NETIF_F_TSO6;
+		netdev_feature_add(NETIF_F_TSO6_BIT, &mgp->features);
 	}
 
 	status = myri10ge_send_cmd(mgp, MXGEFW_CMD_GET_RX_RING_SIZE, &cmd, 0);
@@ -3868,13 +3868,13 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netdev->netdev_ops = &myri10ge_netdev_ops;
 	netdev->hw_features = mgp->features;
-	netdev->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
 	/* fake NETIF_F_HW_VLAN_CTAG_RX for good GRO performance */
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	netdev->features = netdev->hw_features;
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	netdev->vlan_features |= mgp->features;
 	if (mgp->fw_ver_tiny < 37)
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index dba583d60d8e..a5db6ccdb2df 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -87,6 +87,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/delay.h>
 #include <linux/workqueue.h>
@@ -2142,8 +2143,8 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 	ns83820_getmac(dev, ndev);
 
 	/* Yes, we support dumb IP checksum on transmit */
-	ndev->features |= NETIF_F_SG;
-	ndev->features |= NETIF_F_IP_CSUM;
+	netdev_active_feature_add(ndev, NETIF_F_SG_BIT);
+	netdev_active_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
 
 	ndev->min_mtu = 0;
 
@@ -2155,7 +2156,7 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 	if (using_dac) {
 		printk(KERN_INFO "%s: using 64 bit addressing.\n",
 			ndev->name);
-		ndev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 	}
 
 	printk(KERN_INFO "%s: ns83820 v" VERSION ": DP83820 v%u.%u: %pM io=0x%08lx irq=%d f=%s\n",
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 78368e71ce83..96a7a9d69e28 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -587,12 +587,12 @@ int nfp_net_tls_init(struct nfp_net *nn)
 		return err;
 
 	if (nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK_RX) {
-		netdev->hw_features |= NETIF_F_HW_TLS_RX;
-		netdev->features |= NETIF_F_HW_TLS_RX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TLS_RX_BIT);
+		netdev_active_feature_add(netdev, NETIF_F_HW_TLS_RX_BIT);
 	}
 	if (nn->tlv_caps.crypto_ops & NFP_NET_TLS_OPCODE_MASK_TX) {
-		netdev->hw_features |= NETIF_F_HW_TLS_TX;
-		netdev->features |= NETIF_F_HW_TLS_TX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TLS_TX_BIT);
+		netdev_active_feature_add(netdev, NETIF_F_HW_TLS_TX_BIT);
 	}
 
 	netdev->tlsdev_ops = &nfp_net_tls_ops;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index a101ff30a1ae..f1f1aaacbf54 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/pci.h>
 #include <linux/dim.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index e306b58b643c..0b2e6dfa0ac2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2353,9 +2353,9 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	netdev_hw_features_zero(netdev);
-	netdev->hw_features |= NETIF_F_HIGHDMA;
+	netdev_hw_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 	if (nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY) {
-		netdev->hw_features |= NETIF_F_RXCSUM;
+		netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_TXCSUM) {
@@ -2363,7 +2363,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_GATHER) {
-		netdev->hw_features |= NETIF_F_SG;
+		netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_GATHER;
 	}
 	if ((nn->cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
@@ -2373,22 +2373,25 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 					 NFP_NET_CFG_CTRL_LSO;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_RSS_ANY)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 	if (nn->cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO) {
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-			netdev->hw_features |= NETIF_F_GSO_PARTIAL;
+			netdev_hw_feature_add(netdev,
+					      NETIF_F_GSO_UDP_TUNNEL_BIT);
+			netdev_hw_feature_add(netdev,
+					      NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
+			netdev_hw_feature_add(netdev, NETIF_F_GSO_PARTIAL_BIT);
 
 			netdev_gso_partial_features_zero(netdev);
-			netdev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_gso_partial_feature_add(netdev,
+						       NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 		}
 		netdev->udp_tunnel_nic_info = &nfp_udp_tunnels;
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_VXLAN;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_NVGRE) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO)
-			netdev->hw_features |= NETIF_F_GSO_GRE;
+			netdev_hw_feature_add(netdev, NETIF_F_GSO_GRE_BIT);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_NVGRE;
 	}
 	if (nn->cap & (NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE))
@@ -2397,7 +2400,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	netdev->vlan_features = netdev->hw_features;
 
 	if (nn->cap & NFP_NET_CFG_CTRL_RXVLAN_ANY) {
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXVLAN_V2 ?:
 			       NFP_NET_CFG_CTRL_RXVLAN;
 	}
@@ -2405,24 +2408,25 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO2) {
 			nn_warn(nn, "Device advertises both TSO2 and TXVLAN. Refusing to enable TXVLAN.\n");
 		} else {
-			netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+			netdev_hw_feature_add(netdev,
+					      NETIF_F_HW_VLAN_CTAG_TX_BIT);
 			nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_TXVLAN_V2 ?:
 				       NFP_NET_CFG_CTRL_TXVLAN;
 		}
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_CTAG_FILTER) {
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_CTAG_FILTER;
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_RXQINQ) {
-		netdev->hw_features |= NETIF_F_HW_VLAN_STAG_RX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_STAG_RX_BIT);
 		nn->dp.ctrl |= NFP_NET_CFG_CTRL_RXQINQ;
 	}
 
 	netdev->features = netdev->hw_features;
 
 	if (nfp_app_has_tc(nn->app) && nn->port)
-		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 
 	/* C-Tag strip and S-Tag strip can't be supported simultaneously,
 	 * so enable C-Tag strip and disable S-Tag strip by default.
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 66f0a9de53ad..a193d87c7e39 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -246,14 +246,14 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 
 	lower_features = lower_dev->features;
 	if (lower_features & netdev_ip_csum_features)
-		lower_features |= NETIF_F_HW_CSUM;
+		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &lower_features);
 
 	features = netdev_intersect_features(features, lower_features);
 	tmp = NETIF_F_SOFT_FEATURES;
-	tmp |= NETIF_F_HW_TC;
+	netdev_feature_add(NETIF_F_HW_TC_BIT, &tmp);
 	tmp &= old_features;
 	features |= tmp;
-	features |= NETIF_F_LLTX;
+	netdev_feature_add(NETIF_F_LLTX_BIT, &features);
 
 	return features;
 }
@@ -346,25 +346,26 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 		netdev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
 	netdev_hw_features_zero(netdev);
-	netdev->hw_features |= NETIF_F_HIGHDMA;
+	netdev_hw_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 	if (repr_cap & NFP_NET_CFG_CTRL_RXCSUM_ANY)
-		netdev->hw_features |= NETIF_F_RXCSUM;
+		netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 	if (repr_cap & NFP_NET_CFG_CTRL_TXCSUM)
 		netdev->hw_features |= netdev_ip_csum_features;
 	if (repr_cap & NFP_NET_CFG_CTRL_GATHER)
-		netdev->hw_features |= NETIF_F_SG;
+		netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
 	if ((repr_cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    repr_cap & NFP_NET_CFG_CTRL_LSO2)
 		netdev->hw_features |= netdev_general_tso_features;
 	if (repr_cap & NFP_NET_CFG_CTRL_RSS_ANY)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 	if (repr_cap & NFP_NET_CFG_CTRL_VXLAN) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO)
-			netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
+			netdev_hw_feature_add(netdev,
+					      NETIF_F_GSO_UDP_TUNNEL_BIT);
 	}
 	if (repr_cap & NFP_NET_CFG_CTRL_NVGRE) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO)
-			netdev->hw_features |= NETIF_F_GSO_GRE;
+			netdev_hw_feature_add(netdev, NETIF_F_GSO_GRE_BIT);
 	}
 	if (repr_cap & (NFP_NET_CFG_CTRL_VXLAN | NFP_NET_CFG_CTRL_NVGRE))
 		netdev->hw_enc_features = netdev->hw_features;
@@ -372,17 +373,18 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	netdev->vlan_features = netdev->hw_features;
 
 	if (repr_cap & NFP_NET_CFG_CTRL_RXVLAN_ANY)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	if (repr_cap & NFP_NET_CFG_CTRL_TXVLAN_ANY) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO2)
 			netdev_warn(netdev, "Device advertises both TSO2 and TXVLAN. Refusing to enable TXVLAN.\n");
 		else
-			netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+			netdev_hw_feature_add(netdev,
+					      NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	}
 	if (repr_cap & NFP_NET_CFG_CTRL_CTAG_FILTER)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	if (repr_cap & NFP_NET_CFG_CTRL_RXQINQ)
-		netdev->hw_features |= NETIF_F_HW_VLAN_STAG_RX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_STAG_RX_BIT);
 
 	netdev->features = netdev->hw_features;
 
@@ -393,11 +395,11 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 	netif_set_tso_max_segs(netdev, NFP_NET_LSO_MAX_SEGS);
 
 	netdev->priv_flags |= IFF_NO_QUEUE | IFF_DISABLE_NETPOLL;
-	netdev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(netdev, NETIF_F_LLTX_BIT);
 
 	if (nfp_app_has_tc(app)) {
-		netdev->features |= NETIF_F_HW_TC;
-		netdev->hw_features |= NETIF_F_HW_TC;
+		netdev_active_feature_add(netdev, NETIF_F_HW_TC_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_HW_TC_BIT);
 	}
 
 	err = nfp_app_repr_init(app, netdev);
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index f70feffbf2ba..5ead88eb3385 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -1276,7 +1276,7 @@ static int nixge_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	netdev_active_features_zero(ndev);
-	ndev->features |= NETIF_F_SG;
+	netdev_active_feature_add(ndev, NETIF_F_SG_BIT);
 	ndev->netdev_ops = &nixge_netdev_ops;
 	ndev->ethtool_ops = &nixge_ethtool_ops;
 
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index a8a8d59dd008..5adc4f02f36f 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4932,7 +4932,7 @@ static netdev_features_t nv_fix_features(struct net_device *dev,
 {
 	/* vlan is dependent on rx checksum offload */
 	if (features & netdev_ctag_vlan_offload_features)
-		features |= NETIF_F_RXCSUM;
+		netdev_feature_add(NETIF_F_RXCSUM_BIT, &features);
 
 	return features;
 }
@@ -5800,7 +5800,8 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 				dev_info(&pci_dev->dev,
 					 "64-bit DMA failed, using 32-bit addressing\n");
 			else
-				dev->features |= NETIF_F_HIGHDMA;
+				netdev_active_feature_add(dev,
+							  NETIF_F_HIGHDMA_BIT);
 		}
 	} else if (id->driver_data & DEV_HAS_LARGEDESC) {
 		/* packet format 2: supports jumbo frames */
@@ -5830,7 +5831,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	dev->features |= dev->hw_features;
 
 	/* Add loopback capability to the device. */
-	dev->hw_features |= NETIF_F_LOOPBACK;
+	netdev_hw_feature_add(dev, NETIF_F_LOOPBACK_BIT);
 
 	/* MTU range: 64 - 1500 or 9100 */
 	dev->min_mtu = ETH_ZLEN + ETH_FCS_LEN;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 8459002574fc..2d1c6d591baa 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1502,48 +1502,49 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	netdev_features_set_array(&ionic_feature_set, &features);
 
 	if (lif->nxqs > 1)
-		features |= NETIF_F_RXHASH;
+		netdev_feature_add(NETIF_F_RXHASH_BIT, &features);
 
 	err = ionic_set_nic_features(lif, features);
 	if (err)
 		return err;
 
 	/* tell the netdev what we actually can support */
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	if (lif->hw_features & IONIC_ETH_HW_VLAN_TX_TAG)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_STRIP)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_VLAN_RX_FILTER)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_RX_HASH)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TX_SG)
-		netdev->hw_features |= NETIF_F_SG;
+		netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
 
 	if (lif->hw_features & IONIC_ETH_HW_TX_CSUM)
-		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_HW_CSUM_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_RX_CSUM)
-		netdev->hw_enc_features |= NETIF_F_RXCSUM;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TSO)
-		netdev->hw_enc_features |= NETIF_F_TSO;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_IPV6)
-		netdev->hw_enc_features |= NETIF_F_TSO6;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_TSO6_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_ECN)
-		netdev->hw_enc_features |= NETIF_F_TSO_ECN;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_TSO_ECN_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE)
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_GRE_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_GRE_CSUM)
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE_CSUM;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_GRE_CSUM_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP4)
-		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP4;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_IPXIP4_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_IPXIP6)
-		netdev->hw_enc_features |= NETIF_F_GSO_IPXIP6;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_IPXIP6_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP)
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT);
 	if (lif->hw_features & IONIC_ETH_HW_TSO_UDP_CSUM)
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_enc_feature_add(netdev,
+					  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 	netdev->hw_features |= netdev->hw_enc_features;
 	netdev->features |= netdev->hw_features;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 1c3b06599b37..b4c56b023122 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1360,22 +1360,22 @@ netxen_setup_netdev(struct netxen_adapter *adapter,
 	netdev_hw_features_set_array(netdev, &netxen_hw_feature_set);
 
 	if (NX_IS_REVISION_P3(adapter->ahw.revision_id)) {
-		netdev->hw_features |= NETIF_F_IPV6_CSUM;
-		netdev->hw_features |= NETIF_F_TSO6;
+		netdev_hw_feature_add(netdev, NETIF_F_IPV6_CSUM_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_TSO6_BIT);
 	}
 
 	netdev->vlan_features |= netdev->hw_features;
 
 	if (adapter->pci_using_dac) {
-		netdev->features |= NETIF_F_HIGHDMA;
-		netdev->vlan_features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
+		netdev_vlan_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 	}
 
 	if (adapter->capabilities & NX_FW_CAPABILITY_FVLANTX)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 
 	if (adapter->capabilities & NX_FW_CAPABILITY_HW_LRO)
-		netdev->hw_features |= NETIF_F_LRO;
+		netdev_hw_feature_add(netdev, NETIF_F_LRO_BIT);
 
 	netdev->features |= netdev->hw_features;
 
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index b37a045f09d6..64ba47a8629b 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -884,32 +884,34 @@ static void qede_init_ndev(struct qede_dev *edev)
 	netdev_features_set_array(&qede_hw_feature_set, &hw_features);
 
 	if (edev->dev_info.common.b_arfs_capable)
-		hw_features |= NETIF_F_NTUPLE;
+		netdev_feature_add(NETIF_F_NTUPLE_BIT, &hw_features);
 
 	if (edev->dev_info.common.vxlan_enable ||
 	    edev->dev_info.common.geneve_enable)
 		udp_tunnel_enable = true;
 
 	if (udp_tunnel_enable || edev->dev_info.common.gre_enable) {
-		hw_features |= NETIF_F_TSO_ECN;
+		netdev_feature_add(NETIF_F_TSO_ECN_BIT, &hw_features);
 		netdev_hw_enc_features_zero(ndev);
 		netdev_hw_enc_features_set_array(ndev, &qede_hw_enc_feature_set);
 	}
 
 	if (udp_tunnel_enable) {
-		hw_features |= NETIF_F_GSO_UDP_TUNNEL;
-		hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		ndev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
-		ndev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT, &hw_features);
+		netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT,
+				   &hw_features);
+		netdev_hw_enc_feature_add(ndev, NETIF_F_GSO_UDP_TUNNEL_BIT);
+		netdev_hw_enc_feature_add(ndev,
+					  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 
 		qede_set_udp_tunnels(edev);
 	}
 
 	if (edev->dev_info.common.gre_enable) {
-		hw_features |= NETIF_F_GSO_GRE;
-		hw_features |= NETIF_F_GSO_GRE_CSUM;
-		ndev->hw_enc_features |= NETIF_F_GSO_GRE;
-		ndev->hw_enc_features |= NETIF_F_GSO_GRE_CSUM;
+		netdev_feature_add(NETIF_F_GSO_GRE_BIT, &hw_features);
+		netdev_feature_add(NETIF_F_GSO_GRE_CSUM_BIT, &hw_features);
+		netdev_hw_enc_feature_add(ndev, NETIF_F_GSO_GRE_BIT);
+		netdev_hw_enc_feature_add(ndev, NETIF_F_GSO_GRE_CSUM_BIT);
 	}
 
 	ndev->vlan_features = hw_features;
diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index fe823b03736b..c9da4a9f204d 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -26,6 +26,7 @@
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
@@ -3794,10 +3795,10 @@ static int ql3xxx_probe(struct pci_dev *pdev,
 
 	qdev->msg_enable = netif_msg_init(debug, default_msg);
 
-	ndev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 	if (qdev->device_id == QL3032_DEVICE_ID) {
-		ndev->features |= NETIF_F_IP_CSUM;
-		ndev->features |= NETIF_F_SG;
+		netdev_active_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
+		netdev_active_feature_add(ndev, NETIF_F_SG_BIT);
 	}
 
 	qdev->mem_map_registers = pci_ioremap_bar(pdev, 1);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 9bb1b9d53d96..fc51958cd77a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1044,12 +1044,13 @@ static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 			if (!(offload_flags & BIT_1))
 				features &= ~NETIF_F_TSO;
 			else
-				features |= NETIF_F_TSO;
+				netdev_feature_add(NETIF_F_TSO_BIT, &features);
 
 			if (!(offload_flags & BIT_2))
 				features &= ~NETIF_F_TSO6;
 			else
-				features |= NETIF_F_TSO6;
+				netdev_feature_add(NETIF_F_TSO6_BIT,
+						   &features);
 		}
 	} else {
 		netdev_features_clear_array(&qlcnic_csum_feature_set, &features);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 4c19fc626385..d768cee19d3a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2305,16 +2305,17 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 	}
 
 	if (qlcnic_vlan_tx_check(adapter))
-		netdev->features |= (NETIF_F_HW_VLAN_CTAG_TX);
+		netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 
 	if (qlcnic_sriov_vf_check(adapter))
-		netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_add(netdev,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	if (adapter->ahw->capabilities & QLCNIC_FW_CAPABILITY_HW_LRO)
-		netdev->features |= NETIF_F_LRO;
+		netdev_active_feature_add(netdev, NETIF_F_LRO_BIT);
 
 	if (qlcnic_encap_tx_offload(adapter)) {
-		netdev->features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev_active_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT);
 
 		/* encapsulation Tx offload supported by Adapter */
 		netdev_vlan_features_zero(netdev);
@@ -2323,7 +2324,7 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 	}
 
 	if (qlcnic_encap_rx_offload(adapter)) {
-		netdev->hw_enc_features |= NETIF_F_RXCSUM;
+		netdev_hw_enc_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
 		netdev->udp_tunnel_nic_info = &qlcnic_udp_tunnels;
 	}
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 92215121428f..3d288e1a8d46 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -237,7 +237,7 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
 	rmnet_dev->needs_free_netdev = true;
 	rmnet_dev->ethtool_ops = &rmnet_ethtool_ops;
 
-	rmnet_dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(rmnet_dev, NETIF_F_LLTX_BIT);
 
 	/* This perm addr will be used as interface identifier by IPv6 */
 	rmnet_dev->addr_assign_type = NET_ADDR_RANDOM;
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 1a4e97594238..778c75b76950 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1978,8 +1978,8 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	cp->cpcmd = (pci_using_dac ? PCIDAC : 0) |
 		    PCIMulRW | RxChkSum | CpRxOn | CpTxOn;
 
-	dev->features |= NETIF_F_RXCSUM;
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
+	netdev_hw_feature_add(dev, NETIF_F_RXCSUM_BIT);
 
 	regs = ioremap(pciaddr, CP_REGS_SIZE);
 	if (!regs) {
@@ -2007,7 +2007,7 @@ static int cp_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_active_features_set_array(dev, &cp_default_feature_set);
 
 	if (pci_using_dac)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	netdev_hw_features_set_array(dev, &cp_default_feature_set);
 	netdev_vlan_features_zero(dev);
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index fb4437f4ae35..7af89f43c4ca 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -1017,8 +1017,8 @@ static int rtl8139_init_one(struct pci_dev *pdev,
 	netdev_active_features_set_array(dev, &rtl8139_feature_set);
 	dev->vlan_features = dev->features;
 
-	dev->hw_features |= NETIF_F_RXALL;
-	dev->hw_features |= NETIF_F_RXFCS;
+	netdev_hw_feature_add(dev, NETIF_F_RXALL_BIT);
+	netdev_hw_feature_add(dev, NETIF_F_RXFCS_BIT);
 
 	/* MTU range: 68 - 1770 */
 	dev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ef8b13d342f5..ded5fef309be 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5403,7 +5403,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&
 	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)))
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	rtl_init_rxcfg(tp);
 
@@ -5443,7 +5443,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (rtl_chip_supports_csum_v2(tp))
-		dev->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev_hw_feature_add(dev, NETIF_F_IPV6_CSUM_BIT);
 
 	dev->features |= dev->hw_features;
 
@@ -5453,19 +5453,19 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * enable them. Use at own risk!
 	 */
 	if (rtl_chip_supports_csum_v2(tp)) {
-		dev->hw_features |= NETIF_F_SG;
+		netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
 		dev->hw_features |= netdev_general_tso_features;
 		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
 		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V2);
 	} else {
-		dev->hw_features |= NETIF_F_SG;
-		dev->hw_features |= NETIF_F_TSO;
+		netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
+		netdev_hw_feature_add(dev, NETIF_F_TSO_BIT);
 		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V1);
 		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V1);
 	}
 
-	dev->hw_features |= NETIF_F_RXALL;
-	dev->hw_features |= NETIF_F_RXFCS;
+	netdev_hw_feature_add(dev, NETIF_F_RXALL_BIT);
+	netdev_hw_feature_add(dev, NETIF_F_RXFCS_BIT);
 
 	/* configure chip for default features */
 	rtl8169_set_features(dev, dev->features);
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b38f689c3683..333a6aba78a2 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -20,6 +20,7 @@
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/net_tstamp.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
@@ -2617,7 +2618,7 @@ static void ravb_set_delay_mode(struct net_device *ndev)
 
 static void ravb_features_init(void)
 {
-	ravb_default_features |= NETIF_F_RXCSUM;
+	netdev_feature_add(NETIF_F_RXCSUM_BIT, &ravb_default_features);
 }
 
 static int ravb_probe(struct platform_device *pdev)
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index d42adef5a143..79cdd0b8d2e7 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3293,7 +3293,7 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 
 	if (mdp->cd->rx_csum) {
 		netdev_active_features_zero(ndev);
-		ndev->features |= NETIF_F_RXCSUM;
+		netdev_active_feature_add(ndev, NETIF_F_RXCSUM_BIT);
 		ndev->hw_features = ndev->features;
 	}
 
@@ -3346,7 +3346,8 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
 			goto out_release;
 		}
 		mdp->port = port;
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_add(ndev,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 		/* Need to init only the first port of the two sharing a TSU */
 		if (port == 0) {
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 2a16201ce0cf..021e93a08baf 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -15,6 +15,7 @@
 #include <linux/sort.h>
 #include <linux/random.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>
 #include <linux/socket.h>
 #include <linux/etherdevice.h>
@@ -2578,8 +2579,8 @@ static int rocker_probe_port(struct rocker *rocker, unsigned int port_number)
 		       NAPI_POLL_WEIGHT);
 	rocker_carrier_init(rocker_port);
 
-	dev->features |= NETIF_F_NETNS_LOCAL;
-	dev->features |= NETIF_F_SG;
+	netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
+	netdev_active_feature_add(dev, NETIF_F_SG_BIT);
 
 	/* MTU range: 68 - 9000 */
 	dev->min_mtu = ROCKER_PORT_MIN_MTU;
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 7963a9aeafe0..0a664cc7739e 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -2118,7 +2118,7 @@ struct sxgbe_priv_data *sxgbe_drv_probe(struct device *device,
 	netdev_hw_features_zero(ndev);
 	netdev_hw_features_set_array(ndev, &sxgbe_hw_feature_set);
 	ndev->features |= ndev->hw_features;
-	ndev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 	ndev->watchdog_timeo = msecs_to_jiffies(TX_TIMEO);
 
 	/* assign filtering support */
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 2f908bf1f019..2e0a096b5967 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -627,7 +627,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
 
 	if (nic_data->datapath_caps &
 	    (1 << MC_CMD_GET_CAPABILITIES_OUT_RX_INCLUDE_FCS_LBN))
-		efx->net_dev->hw_features |= NETIF_F_RXFCS;
+		netdev_hw_feature_add(efx->net_dev, NETIF_F_RXFCS_BIT);
 
 	rc = efx_mcdi_port_get_number(efx);
 	if (rc < 0)
@@ -1367,7 +1367,7 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 					  &encap_tso_features);
 
 		hw_enc_features |= encap_tso_features;
-		hw_enc_features |= NETIF_F_TSO;
+		netdev_feature_add(NETIF_F_TSO_BIT, &hw_enc_features);
 		efx->net_dev->features |= encap_tso_features;
 	}
 	efx->net_dev->hw_enc_features = hw_enc_features;
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index a19a8df568f9..f40766137540 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -207,7 +207,8 @@ int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 		/* EF100 HW can only offload outer checksums if they are UDP,
 		 * so for GRE_CSUM we have to use GSO_PARTIAL.
 		 */
-		net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
+		netdev_gso_partial_feature_add(net_dev,
+					       NETIF_F_GSO_GRE_CSUM_BIT);
 	}
 	efx->num_mac_stats = MCDI_WORD(outbuf,
 				       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 9aae0d8b713f..4a3cbc1c50ec 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -243,7 +243,8 @@ static int efx_ef10_vadaptor_alloc_set_features(struct efx_nic *efx)
 
 	if (port_flags &
 	    (1 << MC_CMD_VPORT_ALLOC_IN_FLAG_VLAN_RESTRICT_LBN))
-		efx->fixed_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
+				   &efx->fixed_features);
 	else
 		efx->fixed_features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 4c802cd087fc..9feb3295ccaa 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1018,7 +1018,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
 	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
 	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
-		net_dev->features |= NETIF_F_TSO6;
+		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
@@ -1079,7 +1079,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 	*probe_ptr = probe_data;
 	efx->net_dev = net_dev;
 	efx->type = (const struct efx_nic_type *) entry->driver_data;
-	efx->fixed_features |= NETIF_F_HIGHDMA;
+	netdev_feature_add(NETIF_F_HIGHDMA_BIT, &efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 0b6dbd33410e..6fab0c10b78d 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2885,7 +2885,7 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	efx = netdev_priv(net_dev);
 	efx->type = (const struct ef4_nic_type *) entry->driver_data;
-	efx->fixed_features |= NETIF_F_HIGHDMA;
+	netdev_feature_add(NETIF_F_HIGHDMA_BIT, &efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
@@ -2908,8 +2908,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 		goto fail3;
 
 	net_dev->features |= *efx->type->offload_features;
-	net_dev->features |= NETIF_F_SG;
-	net_dev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(net_dev, NETIF_F_SG_BIT);
+	netdev_active_feature_add(net_dev, NETIF_F_RXCSUM_BIT);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index 6887ba4c9806..4a3d2be92a12 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -1000,7 +1000,7 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	netdev_active_features_set_array(net_dev, &efx_active_feature_set);
 	if ((*efx->type->offload_features & NETIF_F_IPV6_CSUM) ||
 	    (*efx->type->offload_features & NETIF_F_HW_CSUM))
-		net_dev->features |= NETIF_F_TSO6;
+		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
 		net_dev->features &= ~NETIF_F_ALL_TSO;
@@ -1051,7 +1051,7 @@ static int efx_pci_probe(struct pci_dev *pci_dev,
 		return -ENOMEM;
 	efx = netdev_priv(net_dev);
 	efx->type = (const struct efx_nic_type *) entry->driver_data;
-	efx->fixed_features |= NETIF_F_HIGHDMA;
+	netdev_feature_add(NETIF_F_HIGHDMA_BIT, &efx->fixed_features);
 
 	pci_set_drvdata(pci_dev, efx);
 	SET_NETDEV_DEV(net_dev, &pci_dev->dev);
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index c3aead3d052b..b3e9c5125195 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -15,6 +15,7 @@
 #include <linux/mii.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/of_platform.h>
@@ -1594,10 +1595,10 @@ static int ave_probe(struct platform_device *pdev)
 	ndev->ethtool_ops = &ave_ethtool_ops;
 	SET_NETDEV_DEV(ndev, dev);
 
-	ndev->features    |= NETIF_F_IP_CSUM;
-	ndev->features    |= NETIF_F_RXCSUM;
-	ndev->hw_features |= NETIF_F_IP_CSUM;
-	ndev->hw_features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
+	netdev_active_feature_add(ndev, NETIF_F_RXCSUM_BIT);
+	netdev_hw_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
+	netdev_hw_feature_add(ndev, NETIF_F_RXCSUM_BIT);
 
 	ndev->max_mtu = AVE_MAX_ETHFRAME - (ETH_HLEN + ETH_FCS_LEN);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8f227d5f2199..c85941528096 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7144,19 +7144,19 @@ int stmmac_dvr_probe(struct device *device,
 
 	ret = stmmac_tc_init(priv, priv);
 	if (!ret) {
-		ndev->hw_features |= NETIF_F_HW_TC;
+		netdev_hw_feature_add(ndev, NETIF_F_HW_TC_BIT);
 	}
 
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
 		ndev->hw_features |= netdev_general_tso_features;
 		if (priv->plat->has_gmac4)
-			ndev->hw_features |= NETIF_F_GSO_UDP_L4;
+			netdev_hw_feature_add(ndev, NETIF_F_GSO_UDP_L4_BIT);
 		priv->tso = true;
 		dev_info(priv->device, "TSO feature enabled\n");
 	}
 
 	if (priv->dma_cap.sphen && !priv->plat->sph_disable) {
-		ndev->hw_features |= NETIF_F_GRO;
+		netdev_hw_feature_add(ndev, NETIF_F_GRO_BIT);
 		priv->sph_cap = true;
 		priv->sph = priv->sph_cap;
 		dev_info(priv->device, "SPH feature enabled\n");
@@ -7195,7 +7195,7 @@ int stmmac_dvr_probe(struct device *device,
 	}
 
 	ndev->features |= ndev->hw_features;
-	ndev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 	ndev->watchdog_timeo = msecs_to_jiffies(watchdog);
 #ifdef STMMAC_VLAN_TAG_USED
 	/* Both mac100 and gmac support receive VLAN tag detection */
@@ -7203,9 +7203,10 @@ int stmmac_dvr_probe(struct device *device,
 	if (priv->dma_cap.vlhash)
 		ndev->features |= netdev_vlan_filter_features;
 	if (priv->dma_cap.vlins) {
-		ndev->features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 		if (priv->dma_cap.dvlan)
-			ndev->features |= NETIF_F_HW_VLAN_STAG_TX;
+			netdev_active_feature_add(ndev,
+						  NETIF_F_HW_VLAN_STAG_TX_BIT);
 	}
 #endif
 	priv->msg_enable = netif_msg_init(debug, default_msg_level);
@@ -7217,7 +7218,7 @@ int stmmac_dvr_probe(struct device *device,
 		priv->rss.table[i] = ethtool_rxfh_indir_default(i, rxq);
 
 	if (priv->dma_cap.rssen && priv->plat->rss_en)
-		ndev->features |= NETIF_F_RXHASH;
+		netdev_active_feature_add(ndev, NETIF_F_RXHASH_BIT);
 
 	/* MTU range: 46 - hw-specific max */
 	ndev->min_mtu = ETH_ZLEN - ETH_HLEN;
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index bf899125b1ef..d77aa6dd6931 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -71,6 +71,7 @@
 #include <linux/dma-mapping.h>
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/ethtool.h>
@@ -5057,11 +5058,11 @@ static int cas_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Cassini features. */
 	if ((cp->cas_flags & CAS_FLAG_NO_HW_CSUM) == 0) {
-		dev->features |= NETIF_F_HW_CSUM;
-		dev->features |= NETIF_F_SG;
+		netdev_active_feature_add(dev, NETIF_F_HW_CSUM_BIT);
+		netdev_active_feature_add(dev, NETIF_F_SG_BIT);
 	}
 
-	dev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	/* MTU range: 60 - varies or 9000 */
 	dev->min_mtu = CAS_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 6a37026e02b6..41398fa580c2 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9744,7 +9744,7 @@ static void niu_set_basic_features(struct net_device *dev)
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_array(dev, &niu_hw_feature_set);
 	dev->features |= dev->hw_features;
-	dev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 }
 
 static int niu_pci_init_one(struct pci_dev *pdev,
@@ -9810,7 +9810,7 @@ static int niu_pci_init_one(struct pci_dev *pdev,
 
 	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(44));
 	if (!err)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	if (err) {
 		err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (err) {
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 42a7a6a5926f..ef90119e1636 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -2999,7 +2999,7 @@ static int gem_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_features_set_array(dev, &gem_hw_feature_set);
 	dev->features = dev->hw_features;
 	if (pci_using_dac)
-		dev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	/* MTU range: 68 - 1500 (Jumbo mode is broken) */
 	dev->min_mtu = GEM_MIN_MTU;
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index f9fcca2adcf4..5eaf7c40a0ad 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2786,10 +2786,10 @@ static int happy_meal_sbus_probe_one(struct platform_device *op, int is_qfe)
 
 	/* Happy Meal can do it all... */
 	netdev_hw_features_zero(dev);
-	dev->hw_features |= NETIF_F_SG;
-	dev->hw_features |= NETIF_F_HW_CSUM;
+	netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
+	netdev_hw_feature_add(dev, NETIF_F_HW_CSUM_BIT);
 	dev->features |= dev->hw_features;
-	dev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 
 	hp->irq = op->archdata.irqs[0];
 
@@ -3109,10 +3109,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 
 	/* Happy Meal can do it all... */
 	netdev_hw_features_zero(dev);
-	dev->hw_features |= NETIF_F_SG;
-	dev->hw_features |= NETIF_F_HW_CSUM;
+	netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
+	netdev_hw_feature_add(dev, NETIF_F_HW_CSUM_BIT);
 	dev->features |= dev->hw_features;
-	dev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 
 #if defined(CONFIG_SBUS) && defined(CONFIG_PCI)
 	/* Hook up PCI register/descriptor accessors. */
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index 68b4bc10c8a9..f15e8768526d 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -180,27 +180,27 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 	/* Set device features */
 	if (pdata->hw_feat.tso) {
 		netdev->hw_features = netdev_general_tso_features;
-		netdev->hw_features |= NETIF_F_SG;
+		netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
 		netdev->hw_features |= netdev_ip_csum_features;
 	} else if (pdata->hw_feat.tx_coe) {
 		netdev->hw_features = netdev_ip_csum_features;
 	}
 
 	if (pdata->hw_feat.rx_coe) {
-		netdev->hw_features |= NETIF_F_RXCSUM;
-		netdev->hw_features |= NETIF_F_GRO;
+		netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_GRO_BIT);
 	}
 
 	if (pdata->hw_feat.rss)
-		netdev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
 
 	netdev->vlan_features |= netdev->hw_features;
 
-	netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	if (pdata->hw_feat.sa_vlan_ins)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 	if (pdata->hw_feat.vlhash)
-		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_hw_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	netdev->features |= netdev->hw_features;
 	pdata->netdev_features = netdev->features;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac.h b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
index a848e10f3ea4..baab47cb15aa 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac.h
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
@@ -20,6 +20,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/workqueue.h>
 #include <linux/phy.h>
 #include <linux/if_vlan.h>
diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index fd89439791ce..839e169c607d 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2032,7 +2032,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		 * set multicast list callback has to use priv->tx_lock.
 		 */
 #ifdef BDX_LLTX
-		ndev->features |= NETIF_F_LLTX;
+		netdev_active_feature_add(ndev, NETIF_F_LLTX_BIT);
 #endif
 		/* MTU range: 60 - 16384 */
 		ndev->min_mtu = ETH_ZLEN;
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 2347a3df30cd..fb32c1f045e6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1976,8 +1976,8 @@ am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 	netdev_hw_features_zero(port->ndev);
 	netdev_hw_features_set_array(port->ndev, &am65_cpsw_hw_feature_set);
 	port->ndev->features = port->ndev->hw_features;
-	port->ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-	port->ndev->vlan_features |=  NETIF_F_SG;
+	netdev_active_feature_add(port->ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+	netdev_vlan_feature_add(port->ndev, NETIF_F_SG_BIT);
 	port->ndev->netdev_ops = &am65_cpsw_nuss_netdev_ops;
 	port->ndev->ethtool_ops = &am65_cpsw_ethtool_ops_slave;
 
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 7e12c6a77d30..0f8f7b1bf841 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -17,6 +17,7 @@
 #include <linux/if_ether.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/phy/phy.h>
@@ -1456,8 +1457,8 @@ static int cpsw_probe_dual_emac(struct cpsw_priv *priv)
 
 	priv_sl2->emac_port = 1;
 	cpsw->slaves[1].ndev = ndev;
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+	netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
@@ -1634,8 +1635,8 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	cpsw->slaves[0].ndev = ndev;
 
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+	netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+	netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	ndev->netdev_ops = &cpsw_netdev_ops;
 	ndev->ethtool_ops = &cpsw_ethtool_ops;
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index b15d44261e76..9a513869ab66 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1975,10 +1975,10 @@ static int netcp_create_interface(struct netcp_device *netcp_device,
 		return -ENOMEM;
 	}
 
-	ndev->features |= NETIF_F_SG;
-	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_add(ndev, NETIF_F_SG_BIT);
+	netdev_active_feature_add(ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	ndev->hw_features = ndev->features;
-	ndev->vlan_features |=  NETIF_F_SG;
+	netdev_vlan_feature_add(ndev, NETIF_F_SG_BIT);
 
 	/* MTU range: 68 - 9486 */
 	ndev->min_mtu = ETH_MIN_MTU;
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 45c0cb3c9a48..78c817b3e88c 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1462,13 +1462,13 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 	u64 v1, v2;
 
 	netdev_hw_features_zero(netdev);
-	netdev->hw_features |= NETIF_F_IP_CSUM;
-	netdev->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_feature_add(netdev, NETIF_F_IP_CSUM_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
 	netdev_active_features_zero(netdev);
-	netdev->features |= NETIF_F_IP_CSUM;
+	netdev_active_feature_add(netdev, NETIF_F_IP_CSUM_BIT);
 	if (GELIC_CARD_RX_CSUM_DEFAULT)
-		netdev->features |= NETIF_F_RXCSUM;
+		netdev_active_feature_add(netdev, NETIF_F_RXCSUM_BIT);
 
 	status = lv1_net_control(bus_id(card), dev_id(card),
 				 GELIC_LV1_GET_MAC_ADDRESS,
@@ -1488,7 +1488,7 @@ int gelic_net_setup_netdev(struct net_device *netdev, struct gelic_card *card)
 		 * As vlan is internally used,
 		 * we can not receive vlan packets
 		 */
-		netdev->features |= NETIF_F_VLAN_CHALLENGED;
+		netdev_active_feature_add(netdev, NETIF_F_VLAN_CHALLENGED_BIT);
 	}
 
 	/* MTU range: 64 - 1518 */
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 03dc5fb10a2b..6267c414d356 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -2276,12 +2276,12 @@ spider_net_setup_netdev(struct spider_net_card *card)
 	spider_net_setup_netdev_ops(netdev);
 
 	netdev_hw_features_zero(netdev);
-	netdev->hw_features |= NETIF_F_RXCSUM;
-	netdev->hw_features |= NETIF_F_IP_CSUM;
+	netdev_hw_feature_add(netdev, NETIF_F_RXCSUM_BIT);
+	netdev_hw_feature_add(netdev, NETIF_F_IP_CSUM_BIT);
 	if (SPIDER_NET_RX_CSUM_DEFAULT)
-		netdev->features |= NETIF_F_RXCSUM;
-	netdev->features |= NETIF_F_IP_CSUM;
-	netdev->features |= NETIF_F_LLTX;
+		netdev_active_feature_add(netdev, NETIF_F_RXCSUM_BIT);
+	netdev_active_feature_add(netdev, NETIF_F_IP_CSUM_BIT);
+	netdev_active_feature_add(netdev, NETIF_F_LLTX_BIT);
 	/* some time: NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 	 *		NETIF_F_HW_VLAN_CTAG_FILTER
 	 */
diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 785f4f3bd0ee..4cdb0ee494ad 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -1611,7 +1611,7 @@ tsi108_init_one(struct platform_device *pdev)
 	 */
 
 	netdev_active_features_zero(dev);
-	dev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	spin_lock_init(&data->txlock);
 	spin_lock_init(&data->misclock);
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 3c8631f9925d..adc8a3de10ff 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -99,6 +99,7 @@ static const int multicast_filter_limit = 32;
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 #include <linux/init.h>
@@ -968,8 +969,8 @@ static int rhine_init_one_common(struct device *hwdev, u32 quirks,
 	netif_napi_add(dev, &rp->napi, rhine_napipoll, 64);
 
 	if (rp->quirks & rqRhineI) {
-		dev->features |= NETIF_F_SG;
-		dev->features |= NETIF_F_HW_CSUM;
+		netdev_active_feature_add(dev, NETIF_F_SG_BIT);
+		netdev_active_feature_add(dev, NETIF_F_HW_CSUM_BIT);
 	}
 
 	if (rp->quirks & rqMgmt)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index d3b9f73ecba4..0b8d4fc47729 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/string.h>
 #include <linux/aer.h>
 #include <linux/etherdevice.h>
@@ -116,7 +117,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_pci_release_regions;
 	}
 
-	netdev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
 
 	pci_set_drvdata(pdev, adapter);
 
diff --git a/drivers/net/ethernet/wiznet/w5100.c b/drivers/net/ethernet/wiznet/w5100.c
index acd78120e53c..85bcaf07f18f 100644
--- a/drivers/net/ethernet/wiznet/w5100.c
+++ b/drivers/net/ethernet/wiznet/w5100.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/wiznet.h>
@@ -1138,7 +1139,7 @@ int w5100_probe(struct device *dev, const struct w5100_ops *ops,
 	/* This chip doesn't support VLAN packets with normal MTU,
 	 * so disable VLAN for this device.
 	 */
-	ndev->features |= NETIF_F_VLAN_CHALLENGED;
+	netdev_active_feature_add(ndev, NETIF_F_VLAN_CHALLENGED_BIT);
 
 	err = register_netdev(ndev);
 	if (err < 0)
diff --git a/drivers/net/ethernet/wiznet/w5300.c b/drivers/net/ethernet/wiznet/w5300.c
index 773f8c77909a..551ba8637843 100644
--- a/drivers/net/ethernet/wiznet/w5300.c
+++ b/drivers/net/ethernet/wiznet/w5300.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/wiznet.h>
@@ -608,7 +609,7 @@ static int w5300_probe(struct platform_device *pdev)
 	/* This chip doesn't support VLAN packets with normal MTU,
 	 * so disable VLAN for this device.
 	 */
-	ndev->features |= NETIF_F_VLAN_CHALLENGED;
+	netdev_active_feature_add(ndev, NETIF_F_VLAN_CHALLENGED_BIT);
 
 	err = register_netdev(ndev);
 	if (err < 0)
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index e3299bb3a1e6..d7f015b3abe4 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1397,7 +1397,7 @@ static int temac_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	netdev_active_features_zero(ndev);
-	ndev->features |= NETIF_F_SG;
+	netdev_active_feature_add(ndev, NETIF_F_SG_BIT);
 	ndev->netdev_ops = &temac_netdev_ops;
 	ndev->ethtool_ops = &temac_ethtool_ops;
 #if 0
@@ -1483,7 +1483,7 @@ static int temac_probe(struct platform_device *pdev)
 	}
 	if (lp->temac_features & TEMAC_FEATURE_TX_CSUM)
 		/* Can checksum TCP/UDP over IPv4. */
-		ndev->features |= NETIF_F_IP_CSUM;
+		netdev_active_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
 
 	/* Defaults for IRQ delay/coalescing setup.  These are
 	 * configuration values, so does not belong in device-tree.
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index cac3437991ae..d24625640520 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1837,7 +1837,7 @@ static int axienet_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
 	netdev_active_features_zero(ndev);
-	ndev->features |= NETIF_F_SG;
+	netdev_active_feature_add(ndev, NETIF_F_SG_BIT);
 	ndev->netdev_ops = &axienet_netdev_ops;
 	ndev->ethtool_ops = &axienet_ethtool_ops;
 
@@ -1903,14 +1903,14 @@ static int axienet_probe(struct platform_device *pdev)
 				XAE_FEATURE_PARTIAL_TX_CSUM;
 			lp->features |= XAE_FEATURE_PARTIAL_TX_CSUM;
 			/* Can checksum TCP/UDP over IPv4. */
-			ndev->features |= NETIF_F_IP_CSUM;
+			netdev_active_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
 			break;
 		case 2:
 			lp->csum_offload_on_tx_path =
 				XAE_FEATURE_FULL_TX_CSUM;
 			lp->features |= XAE_FEATURE_FULL_TX_CSUM;
 			/* Can checksum TCP/UDP over IPv4. */
-			ndev->features |= NETIF_F_IP_CSUM;
+			netdev_active_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
 			break;
 		default:
 			lp->csum_offload_on_tx_path = XAE_NO_CSUM_OFFLOAD;
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 5805e4a56385..9d66e24fa166 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -9,6 +9,7 @@
 #include <linux/nls.h>
 #include <linux/platform_device.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/interrupt.h>
 
 #include "fjes.h"
@@ -1351,7 +1352,7 @@ static void fjes_netdev_setup(struct net_device *netdev)
 	netdev->mtu = fjes_support_mtu[3];
 	netdev->min_mtu = fjes_support_mtu[0];
 	netdev->max_mtu = fjes_support_mtu[3];
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 }
 
 static void fjes_irq_watch_task(struct work_struct *work)
diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index a208e2b1a9af..a16c2d2b6e99 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -967,7 +967,7 @@ static void gtp_link_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP | IFF_MULTICAST;
 
 	dev->priv_flags	|= IFF_NO_QUEUE;
-	dev->features	|= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_keep_dst(dev);
 
 	dev->needed_headroom	= LL_MAX_HEADER + max_gtp_header_len;
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 3b5d82b09675..70d1301d5b1b 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -460,7 +460,7 @@ static void bpq_setup(struct net_device *dev)
 
 	dev->flags      = 0;
 	netdev_active_features_zero(dev);
-	dev->features	|= NETIF_F_LLTX;	/* Allow recursion */
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);	/* Allow recursion */
 
 #if IS_ENABLED(CONFIG_AX25)
 	dev->header_ops      = &ax25_header_ops;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index b83a966b73db..72f0500ae697 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1164,7 +1164,7 @@ static void netvsc_init_settings(struct net_device *dev)
 	ndc->duplex = DUPLEX_FULL;
 
 	netdev_active_features_zero(dev);
-	dev->features |= NETIF_F_LRO;
+	netdev_active_feature_add(dev, NETIF_F_LRO_BIT);
 }
 
 static int netvsc_get_link_ksettings(struct net_device *dev,
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 456563b6b242..9729cd9c37b3 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1370,20 +1370,20 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	net_device_ctx->tx_checksum_mask = 0;
 
 	/* Compute tx offload settings based on hw capabilities */
-	net->hw_features |= NETIF_F_RXCSUM;
-	net->hw_features |= NETIF_F_SG;
-	net->hw_features |= NETIF_F_RXHASH;
+	netdev_hw_feature_add(net, NETIF_F_RXCSUM_BIT);
+	netdev_hw_feature_add(net, NETIF_F_SG_BIT);
+	netdev_hw_feature_add(net, NETIF_F_RXHASH_BIT);
 
 	if ((hwcaps.csum.ip4_txcsum & NDIS_TXCSUM_ALL_TCP4) == NDIS_TXCSUM_ALL_TCP4) {
 		/* Can checksum TCP */
-		net->hw_features |= NETIF_F_IP_CSUM;
+		netdev_hw_feature_add(net, NETIF_F_IP_CSUM_BIT);
 		net_device_ctx->tx_checksum_mask |= TRANSPORT_INFO_IPV4_TCP;
 
 		offloads.tcp_ip_v4_csum = NDIS_OFFLOAD_PARAMETERS_TX_RX_ENABLED;
 
 		if (hwcaps.lsov2.ip4_encap & NDIS_OFFLOAD_ENCAP_8023) {
 			offloads.lso_v2_ipv4 = NDIS_OFFLOAD_PARAMETERS_LSOV2_ENABLED;
-			net->hw_features |= NETIF_F_TSO;
+			netdev_hw_feature_add(net, NETIF_F_TSO_BIT);
 
 			if (hwcaps.lsov2.ip4_maxsz < gso_max_size)
 				gso_max_size = hwcaps.lsov2.ip4_maxsz;
@@ -1396,7 +1396,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	}
 
 	if ((hwcaps.csum.ip6_txcsum & NDIS_TXCSUM_ALL_TCP6) == NDIS_TXCSUM_ALL_TCP6) {
-		net->hw_features |= NETIF_F_IPV6_CSUM;
+		netdev_hw_feature_add(net, NETIF_F_IPV6_CSUM_BIT);
 
 		offloads.tcp_ip_v6_csum = NDIS_OFFLOAD_PARAMETERS_TX_RX_ENABLED;
 		net_device_ctx->tx_checksum_mask |= TRANSPORT_INFO_IPV6_TCP;
@@ -1404,7 +1404,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 		if ((hwcaps.lsov2.ip6_encap & NDIS_OFFLOAD_ENCAP_8023) &&
 		    (hwcaps.lsov2.ip6_opts & NDIS_LSOV2_CAP_IP6) == NDIS_LSOV2_CAP_IP6) {
 			offloads.lso_v2_ipv6 = NDIS_OFFLOAD_PARAMETERS_LSOV2_ENABLED;
-			net->hw_features |= NETIF_F_TSO6;
+			netdev_hw_feature_add(net, NETIF_F_TSO6_BIT);
 
 			if (hwcaps.lsov2.ip6_maxsz < gso_max_size)
 				gso_max_size = hwcaps.lsov2.ip6_maxsz;
@@ -1417,7 +1417,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	}
 
 	if (hwcaps.rsc.ip4 && hwcaps.rsc.ip6) {
-		net->hw_features |= NETIF_F_LRO;
+		netdev_hw_feature_add(net, NETIF_F_LRO_BIT);
 
 		if (net->features & NETIF_F_LRO) {
 			offloads.rsc_ip_v4 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index b7d16d16d523..a3a82aefcb69 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -225,7 +225,7 @@ static void ipa_modem_netdev_setup(struct net_device *netdev)
 	netdev->needed_tailroom = IPA_NETDEV_TAILROOM;
 	netdev->watchdog_timeo = IPA_NETDEV_TIMEOUT * HZ;
 	netdev_hw_features_zero(netdev);
-	netdev->hw_features |= NETIF_F_SG;
+	netdev_hw_feature_add(netdev, NETIF_F_SG_BIT);
 }
 
 /** ipa_modem_suspend() - suspend callback
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 41e17d737d33..35b9e9831ab8 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3456,7 +3456,7 @@ static int macsec_dev_init(struct net_device *dev)
 		dev->features = REAL_DEV_FEATURES(real_dev);
 	} else {
 		dev->features = real_dev->features & SW_MACSEC_FEATURES;
-		dev->features |= NETIF_F_LLTX;
+		netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 		dev->features |= NETIF_F_GSO_SOFTWARE;
 	}
 
@@ -3498,7 +3498,7 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 	tmp |= NETIF_F_GSO_SOFTWARE;
 	tmp |= NETIF_F_SOFT_FEATURES;
 	features &= tmp;
-	features |= NETIF_F_LLTX;
+	netdev_feature_add(NETIF_F_LLTX_BIT, &features);
 
 	return features;
 }
@@ -4366,7 +4366,8 @@ static void __init macsec_features_init(void)
 	netdev_features_set_array(&sw_macsec_feature_set, &sw_macsec_features);
 
 	macsec_no_inherit_features = NETIF_F_VLAN_FEATURES;
-	macsec_no_inherit_features |= NETIF_F_HW_MACSEC;
+	netdev_feature_add(NETIF_F_HW_MACSEC_BIT,
+			   &macsec_no_inherit_features);
 }
 
 static int __init macsec_init(void)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index aac040522ee9..5df2989cf562 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -918,7 +918,7 @@ static int macvlan_init(struct net_device *dev)
 				  (lowerdev->state & MACVLAN_STATE_MASK);
 	dev->features 		= lowerdev->features & MACVLAN_FEATURES;
 	dev->features		|= ALWAYS_ON_FEATURES;
-	dev->hw_features	|= NETIF_F_LRO;
+	netdev_hw_feature_add(dev, NETIF_F_LRO_BIT);
 	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
 	dev->vlan_features	|= ALWAYS_ON_OFFLOADS;
 	dev->hw_enc_features    |= dev->features;
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 50033364b2bd..c643e4914e8e 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -749,10 +749,10 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 				       IFF_TX_SKB_SHARING);
 
 	/* don't acquire failover netdev's netif_tx_lock when transmitting */
-	failover_dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(failover_dev, NETIF_F_LLTX_BIT);
 
 	/* Don't allow failover devices to change network namespaces. */
-	failover_dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(failover_dev, NETIF_F_NETNS_LOCAL_BIT);
 
 	failover_dev->hw_features = FAILOVER_VLAN_FEATURES |
 				    netdev_ctag_vlan_features;
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index d501c7c58f70..e0de6450d79f 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -297,7 +297,7 @@ static void nsim_setup(struct net_device *dev)
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE |
 			   IFF_NO_QUEUE;
 	netdev_active_features_set_array(dev, &nsim_feature_set);
-	dev->hw_features |= NETIF_F_HW_TC;
+	netdev_hw_feature_add(dev, NETIF_F_HW_TC_BIT);
 	dev->max_mtu = ETH_MAX_MTU;
 }
 
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index 2075e0b9f175..8abb86d9da92 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -422,7 +422,7 @@ static int ntb_netdev_probe(struct device *client_dev)
 	dev->ndev = ndev;
 	dev->pdev = pdev;
 	netdev_active_features_zero(ndev);
-	ndev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 
 	ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 9206c660a72e..3efa34e0342d 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/idr.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/poll.h>
 #include <linux/ppp_defs.h>
 #include <linux/filter.h>
@@ -1616,7 +1617,7 @@ static void ppp_setup(struct net_device *dev)
 	dev->netdev_ops = &ppp_netdev_ops;
 	SET_NETDEV_DEVTYPE(dev, &ppp_type);
 
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 
 	dev->hard_header_len = PPP_HDRLEN;
 	dev->mtu = PPP_MRU;
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 9f0175b73fd7..11b0204f070b 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -517,7 +517,7 @@ static int rionet_setup_netdev(struct rio_mport *mport, struct net_device *ndev)
 	ndev->min_mtu = ETH_MIN_MTU;
 	ndev->max_mtu = RIONET_MAX_MTU;
 	netdev_active_features_zero(ndev);
-	ndev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(ndev, NETIF_F_LLTX_BIT);
 	SET_NETDEV_DEV(ndev, &mport->dev);
 	ndev->ethtool_ops = &rionet_ethtool_ops;
 
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 496de424121e..323e4158cf4a 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -953,15 +953,18 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	features = tap->dev->features;
 
 	if (arg & TUN_F_CSUM) {
-		feature_mask |= NETIF_F_HW_CSUM;
+		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &feature_mask);
 
 		if (arg & (TUN_F_TSO4 | TUN_F_TSO6)) {
 			if (arg & TUN_F_TSO_ECN)
-				feature_mask |= NETIF_F_TSO_ECN;
+				netdev_feature_add(NETIF_F_TSO_ECN_BIT,
+						   &feature_mask);
 			if (arg & TUN_F_TSO4)
-				feature_mask |= NETIF_F_TSO;
+				netdev_feature_add(NETIF_F_TSO_BIT,
+						   &feature_mask);
 			if (arg & TUN_F_TSO6)
-				feature_mask |= NETIF_F_TSO6;
+				netdev_feature_add(NETIF_F_TSO6_BIT,
+						   &feature_mask);
 		}
 	}
 
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 4c999e18d4a1..e9b51c600b35 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2178,15 +2178,15 @@ static void team_setup(struct net_device *dev)
 	 */
 	dev->priv_flags |= IFF_UNICAST_FLT | IFF_LIVE_ADDR_CHANGE;
 
-	dev->features |= NETIF_F_LLTX;
-	dev->features |= NETIF_F_GRO;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
+	netdev_active_feature_add(dev, NETIF_F_GRO_BIT);
 
 	/* Don't allow team devices to change network namespaces. */
-	dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
 
 	dev->hw_features = TEAM_VLAN_FEATURES;
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
-	dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_hw_feature_add(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
+	netdev_hw_feature_add(dev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	dev->features |= dev->hw_features;
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 5fad8f09d69f..dc2b0c19b64b 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1269,7 +1269,7 @@ static int tbnet_probe(struct tb_service *svc, const struct tb_service_id *id)
 	dev->hw_features = NETIF_F_ALL_TSO;
 	netdev_hw_features_set_array(dev, &tbnet_hw_feature_set);
 	dev->features = dev->hw_features;
-	dev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 	dev->hard_header_len += sizeof(struct thunderbolt_ip_frame_header);
 
 	netif_napi_add(dev, &net->napi, tbnet_poll, NAPI_POLL_WEIGHT);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 661391e9399b..e7950125d628 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1004,7 +1004,7 @@ static int tun_net_init(struct net_device *dev)
 	dev->hw_features = TUN_USER_FEATURES;
 	netdev_hw_features_set_array(dev, &tun_hw_feature_set);
 	dev->features = dev->hw_features;
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	dev->vlan_features = dev->features & ~netdev_tx_vlan_features;
 
 	tun->flags = (tun->flags & ~TUN_FEATURES) |
@@ -2868,18 +2868,20 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 	netdev_features_t features = netdev_empty_features;
 
 	if (arg & TUN_F_CSUM) {
-		features |= NETIF_F_HW_CSUM;
+		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &features);
 		arg &= ~TUN_F_CSUM;
 
 		if (arg & (TUN_F_TSO4|TUN_F_TSO6)) {
 			if (arg & TUN_F_TSO_ECN) {
-				features |= NETIF_F_TSO_ECN;
+				netdev_feature_add(NETIF_F_TSO_ECN_BIT,
+						   &features);
 				arg &= ~TUN_F_TSO_ECN;
 			}
 			if (arg & TUN_F_TSO4)
-				features |= NETIF_F_TSO;
+				netdev_feature_add(NETIF_F_TSO_BIT, &features);
 			if (arg & TUN_F_TSO6)
-				features |= NETIF_F_TSO6;
+				netdev_feature_add(NETIF_F_TSO6_BIT,
+						   &features);
 			arg &= ~(TUN_F_TSO4|TUN_F_TSO6);
 		}
 
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 29451eb7263b..f063201df838 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -9,6 +9,7 @@
 
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/ethtool.h>
 #include <linux/if_vlan.h>
 #include <linux/ip.h>
@@ -185,8 +186,8 @@ static int cdc_mbim_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->flags |= IFF_NOARP;
 
 	/* no need to put the VLAN tci in the packet headers */
-	dev->net->features |= NETIF_F_HW_VLAN_CTAG_TX;
-	dev->net->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_add(dev->net, NETIF_F_HW_VLAN_CTAG_TX_BIT);
+	netdev_active_feature_add(dev->net, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	/* monitor VLAN additions and removals */
 	dev->net->netdev_ops = &cdc_mbim_netdev_ops;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 1c67cfb9bdb8..d3dfd9f0fda9 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3465,19 +3465,21 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 	dev->net->features = netdev_empty_features;
 
 	if (DEFAULT_TX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_HW_CSUM;
+		netdev_active_feature_add(dev->net, NETIF_F_HW_CSUM_BIT);
 
 	if (DEFAULT_RX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_RXCSUM;
+		netdev_active_feature_add(dev->net, NETIF_F_RXCSUM_BIT);
 
 	if (DEFAULT_TSO_CSUM_ENABLE)
 		netdev_active_features_set_array(dev->net, &lan78xx_tso_feature_set);
 
 	if (DEFAULT_VLAN_RX_OFFLOAD)
-		dev->net->features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_active_feature_add(dev->net,
+					  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 
 	if (DEFAULT_VLAN_FILTER_ENABLE)
-		dev->net->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_add(dev->net,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 	dev->net->hw_features = dev->net->features;
 
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 8aa7a0417476..0370e1fc3365 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -1482,7 +1482,7 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 		dev->net->features |= netdev_ip_csum_features;
 
 	if (DEFAULT_RX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_RXCSUM;
+		netdev_active_feature_add(dev->net, NETIF_F_RXCSUM_BIT);
 
 	netdev_hw_features_zero(dev->net);
 	netdev_hw_features_set_array(dev->net, &smsc75xx_hw_feature_set);
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index d7c8b9d6ba29..1d6818c3d1fd 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1082,13 +1082,13 @@ static int smsc95xx_bind(struct usbnet *dev, struct usb_interface *intf)
 	 * for ipv4 packets.
 	 */
 	if (DEFAULT_TX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_IP_CSUM;
+		netdev_active_feature_add(dev->net, NETIF_F_IP_CSUM_BIT);
 	if (DEFAULT_RX_CSUM_ENABLE)
-		dev->net->features |= NETIF_F_RXCSUM;
+		netdev_active_feature_add(dev->net, NETIF_F_RXCSUM_BIT);
 
 	netdev_hw_features_zero(dev->net);
-	dev->net->hw_features |= NETIF_F_IP_CSUM;
-	dev->net->hw_features |= NETIF_F_RXCSUM;
+	netdev_hw_feature_add(dev->net, NETIF_F_IP_CSUM_BIT);
+	netdev_hw_feature_add(dev->net, NETIF_F_RXCSUM_BIT);
 	set_bit(EVENT_NO_IP_ALIGN, &dev->flags);
 
 	smsc95xx_init_mac_address(dev);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 805056a246cc..7fcecff337a5 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1145,7 +1145,8 @@ static int veth_enable_xdp(struct net_device *dev)
 				/* user-space did not require GRO, but adding XDP
 				 * is supposed to get GRO working
 				 */
-				dev->features |= NETIF_F_GRO;
+				netdev_active_feature_add(dev,
+							  NETIF_F_GRO_BIT);
 				netdev_features_change(dev);
 			}
 		}
@@ -1466,7 +1467,7 @@ static netdev_features_t veth_fix_features(struct net_device *dev,
 			features &= ~NETIF_F_GSO_SOFTWARE;
 	}
 	if (priv->_xdp_prog)
-		features |= NETIF_F_GRO;
+		netdev_feature_add(NETIF_F_GRO_BIT, &features);
 
 	return features;
 }
@@ -1649,7 +1650,7 @@ static void veth_setup(struct net_device *dev)
 	dev->ethtool_ops = &veth_ethtool_ops;
 	veth_features = NETIF_F_GSO_SOFTWARE | NETIF_F_GSO_ENCAP_ALL;
 	netdev_features_set_array(&veth_feature_set, &veth_features);
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	dev->features |= veth_features;
 	dev->vlan_features = dev->features & ~netdev_vlan_offload_features;
 	dev->needs_free_netdev = true;
@@ -1659,7 +1660,7 @@ static void veth_setup(struct net_device *dev)
 	dev->hw_features = veth_features;
 	dev->hw_enc_features = veth_features;
 	dev->mpls_features = NETIF_F_GSO_SOFTWARE;
-	dev->mpls_features |= NETIF_F_HW_CSUM;
+	netdev_mpls_feature_add(dev, NETIF_F_HW_CSUM_BIT);
 	netif_set_tso_max_size(dev, GSO_MAX_SIZE);
 }
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4fb30d9534f4..d10c1a8782cc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3286,7 +3286,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 	if (vi->has_cvq) {
 		vi->cvq = vqs[total_vqs - 1];
 		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
-			vi->dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_active_feature_add(vi->dev,
+						  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -3504,7 +3505,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 			   IFF_TX_SKB_NO_LINEAR;
 	dev->netdev_ops = &virtnet_netdev;
 	netdev_active_features_zero(dev);
-	dev->features |= NETIF_F_HIGHDMA;
+	netdev_active_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	dev->ethtool_ops = &virtnet_ethtool_ops;
 	SET_NETDEV_DEV(dev, &vdev->dev);
@@ -3512,26 +3513,26 @@ static int virtnet_probe(struct virtio_device *vdev)
 	/* Do we support "hardware" checksums? */
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CSUM)) {
 		/* This opens up the world of extra features. */
-		dev->hw_features |= NETIF_F_HW_CSUM;
-		dev->hw_features |= NETIF_F_SG;
+		netdev_hw_feature_add(dev, NETIF_F_HW_CSUM_BIT);
+		netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
 		if (csum) {
-			dev->features |= NETIF_F_HW_CSUM;
-			dev->features |= NETIF_F_SG;
+			netdev_active_feature_add(dev, NETIF_F_HW_CSUM_BIT);
+			netdev_active_feature_add(dev, NETIF_F_SG_BIT);
 		}
 
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
 			dev->hw_features |= netdev_general_tso_features;
-			dev->hw_features |= NETIF_F_TSO_ECN;
+			netdev_hw_feature_add(dev, NETIF_F_TSO_ECN_BIT);
 		}
 		/* Individual feature bits: what can host handle? */
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO4))
-			dev->hw_features |= NETIF_F_TSO;
+			netdev_hw_feature_add(dev, NETIF_F_TSO_BIT);
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO6))
-			dev->hw_features |= NETIF_F_TSO6;
+			netdev_hw_feature_add(dev, NETIF_F_TSO6_BIT);
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_ECN))
-			dev->hw_features |= NETIF_F_TSO_ECN;
+			netdev_hw_feature_add(dev, NETIF_F_TSO_ECN_BIT);
 
-		dev->features |= NETIF_F_GSO_ROBUST;
+		netdev_active_feature_add(dev, NETIF_F_GSO_ROBUST_BIT);
 
 		if (gso) {
 			netdev_features_t tmp = dev->hw_features & NETIF_F_ALL_TSO;
@@ -3541,12 +3542,12 @@ static int virtnet_probe(struct virtio_device *vdev)
 		/* (!csum && gso) case will be fixed by register_netdev() */
 	}
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_CSUM))
-		dev->features |= NETIF_F_RXCSUM;
+		netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
-		dev->features |= NETIF_F_GRO_HW;
+		netdev_active_feature_add(dev, NETIF_F_GRO_HW_BIT);
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
-		dev->hw_features |= NETIF_F_GRO_HW;
+		netdev_hw_feature_add(dev, NETIF_F_GRO_HW_BIT);
 
 	dev->vlan_features = dev->features;
 
@@ -3605,7 +3606,7 @@ static int virtnet_probe(struct virtio_device *vdev)
 				  VIRTIO_NET_RSS_HASH_TYPE_TCP_EX |
 				  VIRTIO_NET_RSS_HASH_TYPE_UDP_EX);
 
-		dev->hw_features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(dev, NETIF_F_RXHASH_BIT);
 	}
 
 	if (vi->has_rss_hash_report)
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 9f8a074eab03..f08209bf2274 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3332,8 +3332,8 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 	netdev_hw_features_set_array(netdev, &vmxnet3_hw_feature_set);
 
 	if (VMXNET3_VERSION_GE_4(adapter)) {
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL;
-		netdev->hw_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_BIT);
+		netdev_hw_feature_add(netdev, NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 		netdev_hw_enc_features_zero(netdev);
 		netdev_hw_enc_features_set_array(netdev,
 						 &vmxnet3_hw_enc_feature_set);
@@ -3390,7 +3390,7 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 	netdev->vlan_features = netdev->hw_features &
 				~netdev_ctag_vlan_offload_features;
 	netdev->features = netdev->hw_features;
-	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 }
 
 
@@ -3868,8 +3868,8 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	if (adapter->num_rx_queues > 1 &&
 	    adapter->intr.type == VMXNET3_IT_MSIX) {
 		adapter->rss = true;
-		netdev->hw_features |= NETIF_F_RXHASH;
-		netdev->features |= NETIF_F_RXHASH;
+		netdev_hw_feature_add(netdev, NETIF_F_RXHASH_BIT);
+		netdev_active_feature_add(netdev, NETIF_F_RXHASH_BIT);
 		dev_dbg(&pdev->dev, "RSS is enabled.\n");
 	} else {
 		adapter->rss = false;
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 3ed93302084a..0444dedf75e7 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -328,9 +328,11 @@ static void vmxnet3_enable_encap_offloads(struct net_device *netdev, netdev_feat
 		netdev_hw_enc_features_set_array(netdev,
 						 &vmxnet3_hw_enc_feature_set);
 		if (features & NETIF_F_GSO_UDP_TUNNEL)
-			netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+			netdev_hw_enc_feature_add(netdev,
+						  NETIF_F_GSO_UDP_TUNNEL_BIT);
 		if (features & NETIF_F_GSO_UDP_TUNNEL_CSUM)
-			netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+			netdev_hw_enc_feature_add(netdev,
+						  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	}
 	if (VMXNET3_VERSION_GE_7(adapter)) {
 		unsigned long flags;
@@ -414,8 +416,8 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 	u8 udp_tun_enabled;
 
 	netdev_features_zero(&tun_offload_mask);
-	tun_offload_mask |= NETIF_F_GSO_UDP_TUNNEL;
-	tun_offload_mask |= NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT, &tun_offload_mask);
+	netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, &tun_offload_mask);
 	udp_tun_enabled = (netdev->features & tun_offload_mask) != 0;
 
 	if (changed & NETIF_F_RXCSUM ||
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 7ad145f832cc..98ae263639fc 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1687,13 +1687,13 @@ static void vrf_setup(struct net_device *dev)
 	eth_hw_addr_random(dev);
 
 	/* don't acquire vrf device's netif_tx_lock when transmitting */
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 
 	/* don't allow vrf devices to change network namespaces. */
-	dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
 
 	/* does not make sense for a VLAN to be added to a vrf device */
-	dev->features   |= NETIF_F_VLAN_CHALLENGED;
+	netdev_active_feature_add(dev, NETIF_F_VLAN_CHALLENGED_BIT);
 
 	/* enable offload features */
 	dev->features   |= NETIF_F_GSO_SOFTWARE;
diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index f78f910e113e..3c127313fb05 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -295,7 +295,7 @@ static void wg_setup(struct net_device *dev)
 	dev->type = ARPHRD_NONE;
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 	dev->priv_flags |= IFF_NO_QUEUE;
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	wg_netdev_features = NETIF_F_GSO_SOFTWARE;
 	netdev_features_set_array(&wg_feature_set, &wg_netdev_features);
 	dev->features |= wg_netdev_features;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4d9cd3df3095..30748857435c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -10213,7 +10213,7 @@ int ath10k_mac_register(struct ath10k *ar)
 
 	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags)) {
 		netdev_features_zero(&ar->hw->netdev_features);
-		ar->hw->netdev_features |= NETIF_F_HW_CSUM;
+		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &ar->hw->netdev_features);
 	}
 
 	if (IS_ENABLED(CONFIG_ATH10K_DFS_CERTIFIED)) {
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 2b78b47e0a90..277aac5fb61b 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8897,7 +8897,7 @@ static int __ath11k_mac_register(struct ath11k *ar)
 
 	if (!test_bit(ATH11K_FLAG_RAW_MODE, &ab->dev_flags)) {
 		netdev_features_zero(&ar->hw->netdev_features);
-		ar->hw->netdev_features |= NETIF_F_HW_CSUM;
+		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &ar->hw->netdev_features);
 		ieee80211_hw_set(ar->hw, SW_CRYPTO_CONTROL);
 		ieee80211_hw_set(ar->hw, SUPPORT_FAST_XMIT);
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 77e052336eb5..e37020cf794b 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -19,6 +19,7 @@
 #define CORE_H
 
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/rtnetlink.h>
 #include <linux/firmware.h>
 #include <linux/sched.h>
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 8c57cd413e79..4dbfdd1a8097 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1144,7 +1144,7 @@ static int ath6kl_set_features(struct net_device *dev,
 							 ar->rx_meta_ver, 0, 0);
 		if (err) {
 			dev->features = features;
-			dev->features |= NETIF_F_RXCSUM;
+			netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 			return err;
 		}
 	}
@@ -1306,8 +1306,8 @@ void init_netdev(struct net_device *dev)
 
 	if (!test_bit(ATH6KL_FW_CAPABILITY_NO_IP_CHECKSUM,
 		      ar->fw_capabilities)) {
-		dev->hw_features |= NETIF_F_IP_CSUM;
-		dev->hw_features |= NETIF_F_RXCSUM;
+		netdev_hw_feature_add(dev, NETIF_F_IP_CSUM_BIT);
+		netdev_hw_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	}
 
 	return;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index bd164a0821f9..ad0d49866f38 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -7,6 +7,7 @@
 #include <linux/etherdevice.h>
 #include <linux/module.h>
 #include <linux/inetdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/property.h>
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
@@ -605,7 +606,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
 	    && (toe_ol & TOE_TX_CSUM_OL) != 0)
-		ndev->features |= NETIF_F_IP_CSUM;
+		netdev_active_feature_add(ndev, NETIF_F_IP_CSUM_BIT);
 	else
 		ndev->features &= ~NETIF_F_IP_CSUM;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 53c41f48ecf8..8a75c57fc000 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -99,8 +99,8 @@ int iwlagn_mac_setup_register(struct iwl_priv *priv,
 
 	if (priv->trans->max_skb_frags) {
 		netdev_features_zero(&hw->netdev_features);
-		hw->netdev_features |= NETIF_F_HIGHDMA;
-		hw->netdev_features |= NETIF_F_SG;
+		netdev_feature_add(NETIF_F_HIGHDMA_BIT, &hw->netdev_features);
+		netdev_feature_add(NETIF_F_SG_BIT, &hw->netdev_features);
 	}
 
 	hw->offchannel_tx_hw_queue = IWL_AUX_QUEUE;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 1c6bb3317a30..0c94d7bf80f6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -321,8 +321,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	if (mvm->trans->max_skb_frags) {
 		netdev_features_zero(&hw->netdev_features);
-		hw->netdev_features |= NETIF_F_HIGHDMA;
-		hw->netdev_features |= NETIF_F_SG;
+		netdev_feature_add(NETIF_F_HIGHDMA_BIT, &hw->netdev_features);
+		netdev_feature_add(NETIF_F_SG_BIT, &hw->netdev_features);
 	}
 
 	hw->queues = IEEE80211_NUM_ACS;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 3283c346fbe7..e110ac000e88 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -6,6 +6,7 @@
  */
 #include <linux/ieee80211.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/tcp.h>
 #include <net/ip.h>
 #include <net/ipv6.h>
@@ -891,7 +892,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	u8 tid;
 
 	netdev_flags = NETIF_F_CSUM_MASK;
-	netdev_flags |= NETIF_F_SG;
+	netdev_feature_add(NETIF_F_SG_BIT, &netdev_flags);
 
 	snap_ip_tcp = 8 + skb_transport_header(skb) - skb_network_header(skb) +
 		tcp_hdrlen(skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
index bc2e309d45ed..8b899de8af2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -368,7 +368,7 @@ mt7615_init_wiphy(struct ieee80211_hw *hw)
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 11;
 	netdev_features_zero(&hw->netdev_features);
-	hw->netdev_features |= NETIF_F_RXCSUM;
+	netdev_feature_add(NETIF_F_RXCSUM_BIT, &hw->netdev_features);
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index bc35271f41da..32b81deefbbe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -331,7 +331,7 @@ mt7915_init_wiphy(struct ieee80211_hw *hw)
 	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	netdev_features_zero(&hw->netdev_features);
-	hw->netdev_features |= NETIF_F_RXCSUM;
+	netdev_feature_add(NETIF_F_RXCSUM_BIT, &hw->netdev_features);
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index 7824ee8e29cc..abc5d5667772 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -56,7 +56,7 @@ mt7921_init_wiphy(struct ieee80211_hw *hw)
 	hw->max_rx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	hw->max_tx_aggregation_subframes = IEEE80211_MAX_AMPDU_BUF_HE;
 	netdev_features_zero(&hw->netdev_features);
-	hw->netdev_features |= NETIF_F_RXCSUM;
+	netdev_feature_add(NETIF_F_RXCSUM_BIT, &hw->netdev_features);
 
 	hw->radiotap_timestamp.units_pos =
 		IEEE80211_RADIOTAP_TIMESTAMP_UNIT_US;
diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index 52a77a224a64..4d9892adceac 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -174,16 +174,16 @@ static void t7xx_ccmni_wwan_setup(struct net_device *dev)
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
 
 	netdev_active_features_zero(dev);
-	dev->features |= NETIF_F_VLAN_CHALLENGED;
+	netdev_active_feature_add(dev, NETIF_F_VLAN_CHALLENGED_BIT);
 
-	dev->features |= NETIF_F_SG;
-	dev->hw_features |= NETIF_F_SG;
+	netdev_active_feature_add(dev, NETIF_F_SG_BIT);
+	netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
 
-	dev->features |= NETIF_F_HW_CSUM;
-	dev->hw_features |= NETIF_F_HW_CSUM;
+	netdev_active_feature_add(dev, NETIF_F_HW_CSUM_BIT);
+	netdev_hw_feature_add(dev, NETIF_F_HW_CSUM_BIT);
 
-	dev->features |= NETIF_F_RXCSUM;
-	dev->hw_features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
+	netdev_hw_feature_add(dev, NETIF_F_RXCSUM_BIT);
 
 	dev->needs_free_netdev = true;
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 8c37a65d8d06..b2e50d1a6cc2 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -534,7 +534,7 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	netdev_hw_features_zero(dev);
 	netdev_hw_features_set_array(dev, &xenvif_hw_feature_set);
 	dev->features = dev->hw_features;
-	dev->features |= NETIF_F_RXCSUM;
+	netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 	dev->ethtool_ops = &xenvif_ethtool_ops;
 
 	dev->tx_queue_len = XENVIF_QUEUE_LENGTH;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 1a903161c46c..1975d01b6cad 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6362,10 +6362,10 @@ static struct net_device *qeth_alloc_netdev(struct qeth_card *card)
 
 	dev->ethtool_ops = &qeth_ethtool_ops;
 	dev->priv_flags &= ~IFF_TX_SKB_SHARING;
-	dev->hw_features |= NETIF_F_SG;
-	dev->vlan_features |= NETIF_F_SG;
+	netdev_hw_feature_add(dev, NETIF_F_SG_BIT);
+	netdev_vlan_feature_add(dev, NETIF_F_SG_BIT);
 	if (IS_IQD(card))
-		dev->features |= NETIF_F_SG;
+		netdev_active_feature_add(dev, NETIF_F_SG_BIT);
 
 	return dev;
 }
@@ -6826,7 +6826,8 @@ void qeth_enable_hw_features(struct net_device *dev)
 	/* toggle VLAN filter, so that VIDs are re-programmed: */
 	if (IS_LAYER2(card) && IS_VM_NIC(card)) {
 		dev->features &= ~NETIF_F_HW_VLAN_CTAG_FILTER;
-		dev->wanted_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_wanted_feature_add(dev,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 	netdev_update_features(dev);
 	if (features != dev->features)
@@ -6842,13 +6843,13 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 	netdev_features_t ipv6_features = netdev_empty_features;
 	netdev_features_t ipv4_features = netdev_empty_features;
 
-	ipv6_features |= NETIF_F_TSO6;
-	ipv4_features |= NETIF_F_TSO;
+	netdev_feature_add(NETIF_F_TSO6_BIT, &ipv6_features);
+	netdev_feature_add(NETIF_F_TSO_BIT, &ipv4_features);
 
 	if (!card->info.has_lp2lp_cso_v6)
-		ipv6_features |= NETIF_F_IPV6_CSUM;
+		netdev_feature_add(NETIF_F_IPV6_CSUM_BIT, &ipv6_features);
 	if (!card->info.has_lp2lp_cso_v4)
-		ipv4_features |= NETIF_F_IP_CSUM;
+		netdev_feature_add(NETIF_F_IP_CSUM_BIT, &ipv4_features);
 
 	if ((changed & ipv6_features) && !(actual & ipv6_features))
 		qeth_flush_local_addrs6(card);
@@ -6949,14 +6950,16 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 		switch (vlan_get_protocol(skb)) {
 		case htons(ETH_P_IP):
 			if (!card->info.has_lp2lp_cso_v4)
-				restricted |= NETIF_F_IP_CSUM;
+				netdev_feature_add(NETIF_F_IP_CSUM_BIT,
+						   &restricted);
 
 			if (restricted && qeth_next_hop_is_local_v4(card, skb))
 				features &= ~restricted;
 			break;
 		case htons(ETH_P_IPV6):
 			if (!card->info.has_lp2lp_cso_v6)
-				restricted |= NETIF_F_IPV6_CSUM;
+				netdev_feature_add(NETIF_F_IPV6_CSUM_BIT,
+						   &restricted);
 
 			if (restricted && qeth_next_hop_is_local_v6(card, skb))
 				features &= ~restricted;
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 83950ce159f9..32926f3c90ed 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1093,37 +1093,41 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 	card->dev->priv_flags |= IFF_UNICAST_FLT;
 
 	if (IS_OSM(card)) {
-		card->dev->features |= NETIF_F_VLAN_CHALLENGED;
+		netdev_active_feature_add(card->dev,
+					  NETIF_F_VLAN_CHALLENGED_BIT);
 	} else {
 		if (!IS_VM_NIC(card))
-			card->dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
-		card->dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+			netdev_hw_feature_add(card->dev,
+					      NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
+		netdev_active_feature_add(card->dev,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 	}
 
 	if (IS_OSD(card) && !IS_VM_NIC(card)) {
-		card->dev->features |= NETIF_F_SG;
+		netdev_active_feature_add(card->dev, NETIF_F_SG_BIT);
 		/* OSA 3S and earlier has no RX/TX support */
 		if (qeth_is_supported(card, IPA_OUTBOUND_CHECKSUM)) {
-			card->dev->hw_features |= NETIF_F_IP_CSUM;
-			card->dev->vlan_features |= NETIF_F_IP_CSUM;
+			netdev_hw_feature_add(card->dev, NETIF_F_IP_CSUM_BIT);
+			netdev_vlan_feature_add(card->dev,
+						NETIF_F_IP_CSUM_BIT);
 		}
 	}
 	if (qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6)) {
-		card->dev->hw_features |= NETIF_F_IPV6_CSUM;
-		card->dev->vlan_features |= NETIF_F_IPV6_CSUM;
+		netdev_hw_feature_add(card->dev, NETIF_F_IPV6_CSUM_BIT);
+		netdev_vlan_feature_add(card->dev, NETIF_F_IPV6_CSUM_BIT);
 	}
 	if (qeth_is_supported(card, IPA_INBOUND_CHECKSUM) ||
 	    qeth_is_supported6(card, IPA_INBOUND_CHECKSUM_V6)) {
-		card->dev->hw_features |= NETIF_F_RXCSUM;
-		card->dev->vlan_features |= NETIF_F_RXCSUM;
+		netdev_hw_feature_add(card->dev, NETIF_F_RXCSUM_BIT);
+		netdev_vlan_feature_add(card->dev, NETIF_F_RXCSUM_BIT);
 	}
 	if (qeth_is_supported(card, IPA_OUTBOUND_TSO)) {
-		card->dev->hw_features |= NETIF_F_TSO;
-		card->dev->vlan_features |= NETIF_F_TSO;
+		netdev_hw_feature_add(card->dev, NETIF_F_TSO_BIT);
+		netdev_vlan_feature_add(card->dev, NETIF_F_TSO_BIT);
 	}
 	if (qeth_is_supported6(card, IPA_OUTBOUND_TSO)) {
-		card->dev->hw_features |= NETIF_F_TSO6;
-		card->dev->vlan_features |= NETIF_F_TSO6;
+		netdev_hw_feature_add(card->dev, NETIF_F_TSO6_BIT);
+		netdev_vlan_feature_add(card->dev, NETIF_F_TSO6_BIT);
 	}
 
 	if (card->dev->hw_features & netdev_general_tso_features) {
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index f7b30abac5e9..0f342a6d3070 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1872,7 +1872,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		dev->dev_id = qeth_l3_get_unique_id(card, dev->dev_id);
 
 		if (!IS_VM_NIC(card)) {
-			card->dev->features |= NETIF_F_SG;
+			netdev_active_feature_add(card->dev, NETIF_F_SG_BIT);
 			netdev_hw_features_set_array(card->dev,
 						     &qeth_l3_feature_set);
 			netdev_vlan_features_set_array(card->dev,
@@ -1880,12 +1880,14 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 		}
 
 		if (qeth_is_supported6(card, IPA_OUTBOUND_CHECKSUM_V6)) {
-			card->dev->hw_features |= NETIF_F_IPV6_CSUM;
-			card->dev->vlan_features |= NETIF_F_IPV6_CSUM;
+			netdev_hw_feature_add(card->dev,
+					      NETIF_F_IPV6_CSUM_BIT);
+			netdev_vlan_feature_add(card->dev,
+						NETIF_F_IPV6_CSUM_BIT);
 		}
 		if (qeth_is_supported6(card, IPA_OUTBOUND_TSO)) {
-			card->dev->hw_features |= NETIF_F_TSO6;
-			card->dev->vlan_features |= NETIF_F_TSO6;
+			netdev_hw_feature_add(card->dev, NETIF_F_TSO6_BIT);
+			netdev_vlan_feature_add(card->dev, NETIF_F_TSO6_BIT);
 		}
 
 		/* allow for de-acceleration of NETIF_F_HW_VLAN_CTAG_TX: */
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 0811ff9452f7..2d1109e7d03e 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/phy.h>
 #include <linux/slab.h>
@@ -422,12 +423,12 @@ int cvm_oct_common_init(struct net_device *dev)
 		priv->queue = -1;
 
 	if (priv->queue != -1) {
-		dev->features |= NETIF_F_SG;
-		dev->features |= NETIF_F_IP_CSUM;
+		netdev_active_feature_add(dev, NETIF_F_SG_BIT);
+		netdev_active_feature_add(dev, NETIF_F_IP_CSUM_BIT);
 	}
 
 	/* We do our own locking, Linux doesn't need to */
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	dev->ethtool_ops = &cvm_oct_ethtool_ops;
 
 	cvm_oct_set_mac_filter(dev);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 89ce268d9d81..2e67d69d6ac7 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4586,7 +4586,7 @@ static int qlge_probe(struct pci_dev *pdev,
 	ndev->vlan_features &= ~netdev_ctag_vlan_features;
 
 	if (test_bit(QL_DMA64, &qdev->flags))
-		ndev->features |= NETIF_F_HIGHDMA;
+		netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
 
 	/*
 	 * Set up net_device structure.
diff --git a/include/net/udp.h b/include/net/udp.h
index 46d7527cae38..f901e40bd470 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -25,6 +25,7 @@
 #include <net/snmp.h>
 #include <net/ip.h>
 #include <linux/ipv6.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/seq_file.h>
 #include <linux/poll.h>
 #include <linux/indirect_call_wrapper.h>
@@ -460,7 +461,7 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
 	netdev_features_t features = netdev_empty_features;
 	struct sk_buff *segs;
 
-	features |= NETIF_F_SG;
+	netdev_feature_add(NETIF_F_SG_BIT, &features);
 
 	/* Avoid csum recalculation by skb_segment unless userspace explicitly
 	 * asks for the final checksum values
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 60b5e401e346..4c11028ce4f8 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -114,7 +114,7 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 
 	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK)) {
 		ret &= ~NETIF_F_CSUM_MASK;
-		ret |= NETIF_F_HW_CSUM;
+		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &ret);
 		return ret;
 	}
 	netdev_features_zero(&ret);
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ab2847fa938d..6df3fd365714 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -579,7 +579,7 @@ static int vlan_dev_init(struct net_device *dev)
 	netdev_hw_features_set_array(dev, &vlan_hw_feature_set);
 
 	dev->features |= dev->hw_features;
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_inherit_tso_max(dev, real_dev);
 	if (dev->features & NETIF_F_VLAN_FEATURES)
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
@@ -656,19 +656,19 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	netdev_features_t tmp;
 
 	tmp = real_dev->vlan_features;
-	tmp |= NETIF_F_RXCSUM;
+	netdev_feature_add(NETIF_F_RXCSUM_BIT, &tmp);
 	lower_features = netdev_intersect_features(tmp, real_dev->features);
 
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
 	if (lower_features & netdev_ip_csum_features)
-		lower_features |= NETIF_F_HW_CSUM;
+		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &lower_features);
 	features = netdev_intersect_features(features, lower_features);
 	tmp = NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE;
 	tmp &= old_features;
 	features |= tmp;
-	features |= NETIF_F_LLTX;
+	netdev_feature_add(NETIF_F_LLTX_BIT, &features);
 
 	return features;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 74b6315449a7..e374eb18c716 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3399,7 +3399,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		struct net_device *dev = skb->dev;
 
 		partial_features = dev->features & dev->gso_partial_features;
-		partial_features |= NETIF_F_GSO_ROBUST;
+		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, &partial_features);
 		if (!skb_gso_ok(skb, features | partial_features))
 			features &= ~NETIF_F_GSO_PARTIAL;
 	}
@@ -10032,14 +10032,14 @@ int register_netdevice(struct net_device *dev)
 	dev->features |= NETIF_F_SOFT_FEATURES;
 
 	if (dev->udp_tunnel_nic_info) {
-		dev->features |= NETIF_F_RX_UDP_TUNNEL_PORT;
-		dev->hw_features |= NETIF_F_RX_UDP_TUNNEL_PORT;
+		netdev_active_feature_add(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
+		netdev_hw_feature_add(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 	}
 
 	dev->wanted_features = dev->features & dev->hw_features;
 
 	if (!(dev->flags & IFF_LOOPBACK))
-		dev->hw_features |= NETIF_F_NOCACHE_COPY;
+		netdev_hw_feature_add(dev, NETIF_F_NOCACHE_COPY_BIT);
 
 	/* If IPv4 TCP segmentation offload is supported we should also
 	 * allow the device to enable segmenting the frame with the option
@@ -10047,26 +10047,26 @@ int register_netdevice(struct net_device *dev)
 	 * feature itself but allows the user to enable it later.
 	 */
 	if (dev->hw_features & NETIF_F_TSO)
-		dev->hw_features |= NETIF_F_TSO_MANGLEID;
+		netdev_hw_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 	if (dev->vlan_features & NETIF_F_TSO)
-		dev->vlan_features |= NETIF_F_TSO_MANGLEID;
+		netdev_vlan_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 	if (dev->mpls_features & NETIF_F_TSO)
-		dev->mpls_features |= NETIF_F_TSO_MANGLEID;
+		netdev_mpls_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 	if (dev->hw_enc_features & NETIF_F_TSO)
-		dev->hw_enc_features |= NETIF_F_TSO_MANGLEID;
+		netdev_hw_enc_feature_add(dev, NETIF_F_TSO_MANGLEID_BIT);
 
 	/* Make NETIF_F_HIGHDMA inheritable to VLAN devices.
 	 */
-	dev->vlan_features |= NETIF_F_HIGHDMA;
+	netdev_vlan_feature_add(dev, NETIF_F_HIGHDMA_BIT);
 
 	/* Make NETIF_F_SG inheritable to tunnel devices.
 	 */
-	dev->hw_enc_features |= NETIF_F_SG;
-	dev->hw_enc_features |= NETIF_F_GSO_PARTIAL;
+	netdev_hw_enc_feature_add(dev, NETIF_F_SG_BIT);
+	netdev_hw_enc_feature_add(dev, NETIF_F_GSO_PARTIAL_BIT);
 
 	/* Make NETIF_F_SG inheritable to MPLS.
 	 */
-	dev->mpls_features |= NETIF_F_SG;
+	netdev_mpls_feature_add(dev, NETIF_F_SG_BIT);
 
 	ret = call_netdevice_notifiers(NETDEV_POST_INIT, dev);
 	ret = notifier_to_errno(ret);
@@ -11155,7 +11155,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 
 	if (mask & NETIF_F_HW_CSUM)
 		mask |= NETIF_F_CSUM_MASK;
-	mask |= NETIF_F_VLAN_CHALLENGED;
+	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
 
 	tmp = NETIF_F_ONE_FOR_ALL | NETIF_F_CSUM_MASK;
 	tmp &= one;
diff --git a/net/core/sock.c b/net/core/sock.c
index 3127552e8989..c71c43882785 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -118,6 +118,7 @@
 #include <linux/uaccess.h>
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <net/protocol.h>
 #include <linux/skbuff.h>
 #include <net/net_namespace.h>
@@ -2317,7 +2318,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 	sk_dst_set(sk, dst);
 	sk->sk_route_caps = dst->dev->features;
 	if (sk_is_tcp(sk))
-		sk->sk_route_caps |= NETIF_F_GSO;
+		netdev_feature_add(NETIF_F_GSO_BIT, &sk->sk_route_caps);
 	if (sk->sk_route_caps & NETIF_F_GSO)
 		sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
 	if (unlikely(sk->sk_gso_disabled))
@@ -2326,8 +2327,8 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 		if (dst->header_len && !xfrm_dst_offload_ok(dst)) {
 			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 		} else {
-			sk->sk_route_caps |= NETIF_F_SG;
-			sk->sk_route_caps |= NETIF_F_HW_CSUM;
+			netdev_feature_add(NETIF_F_SG_BIT, &sk->sk_route_caps);
+			netdev_feature_add(NETIF_F_HW_CSUM_BIT, &sk->sk_route_caps);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
 			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
 			sk_trim_gso_size(sk);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a7e831bc5632..7ed3699bdc4d 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -7,6 +7,7 @@
 #include <linux/list.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/phy.h>
 #include <linux/phy_fixed.h>
 #include <linux/phylink.h>
@@ -1671,7 +1672,8 @@ int dsa_slave_manage_vlan_filtering(struct net_device *slave,
 	int err;
 
 	if (vlan_filtering) {
-		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_add(slave,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 
 		err = vlan_for_each(slave, dsa_slave_restore_vlan, slave);
 		if (err) {
@@ -2288,15 +2290,16 @@ void dsa_slave_setup_tagger(struct net_device *slave)
 	p->xmit = cpu_dp->tag_ops->xmit;
 
 	slave->features = master->vlan_features;
-	slave->features |= NETIF_F_HW_TC;
-	slave->hw_features |= NETIF_F_HW_TC;
-	slave->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(slave, NETIF_F_HW_TC_BIT);
+	netdev_hw_feature_add(slave, NETIF_F_HW_TC_BIT);
+	netdev_active_feature_add(slave, NETIF_F_LLTX_BIT);
 	if (slave->needed_tailroom) {
 		slave->features &= ~NETIF_F_SG;
 		slave->features &= ~NETIF_F_FRAGLIST;
 	}
 	if (ds->needs_standalone_vlan_filtering)
-		slave->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		netdev_active_feature_add(slave,
+					  NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 }
 
 int dsa_slave_suspend(struct net_device *slave_dev)
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 7674629773a1..3e5116f6d56a 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -237,28 +237,28 @@ static netdev_features_t ethtool_get_feature_mask(u32 eth_cmd)
 	case ETHTOOL_GTXCSUM:
 	case ETHTOOL_STXCSUM:
 		tmp = NETIF_F_CSUM_MASK;
-		tmp |= NETIF_F_FCOE_CRC;
-		tmp |= NETIF_F_SCTP_CRC;
+		netdev_feature_add(NETIF_F_FCOE_CRC_BIT, &tmp);
+		netdev_feature_add(NETIF_F_SCTP_CRC_BIT, &tmp);
 		return tmp;
 	case ETHTOOL_GRXCSUM:
 	case ETHTOOL_SRXCSUM:
-		tmp |= NETIF_F_RXCSUM;
+		netdev_feature_add(NETIF_F_RXCSUM_BIT, &tmp);
 		return tmp;
 	case ETHTOOL_GSG:
 	case ETHTOOL_SSG:
-		tmp |= NETIF_F_SG;
-		tmp |= NETIF_F_FRAGLIST;
+		netdev_feature_add(NETIF_F_SG_BIT, &tmp);
+		netdev_feature_add(NETIF_F_FRAGLIST_BIT, &tmp);
 		return tmp;
 	case ETHTOOL_GTSO:
 	case ETHTOOL_STSO:
 		return NETIF_F_ALL_TSO;
 	case ETHTOOL_GGSO:
 	case ETHTOOL_SGSO:
-		tmp |= NETIF_F_GSO;
+		netdev_feature_add(NETIF_F_GSO_BIT, &tmp);
 		return tmp;
 	case ETHTOOL_GGRO:
 	case ETHTOOL_SGRO:
-		tmp |= NETIF_F_GRO;
+		netdev_feature_add(NETIF_F_GRO_BIT, &tmp);
 		return tmp;
 	default:
 		BUG();
@@ -342,15 +342,15 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 		return -EINVAL;
 
 	if (data & ETH_FLAG_LRO)
-		features |= NETIF_F_LRO;
+		netdev_feature_add(NETIF_F_LRO_BIT, &features);
 	if (data & ETH_FLAG_RXVLAN)
-		features |= NETIF_F_HW_VLAN_CTAG_RX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT, &features);
 	if (data & ETH_FLAG_TXVLAN)
-		features |= NETIF_F_HW_VLAN_CTAG_TX;
+		netdev_feature_add(NETIF_F_HW_VLAN_CTAG_TX_BIT, &features);
 	if (data & ETH_FLAG_NTUPLE)
-		features |= NETIF_F_NTUPLE;
+		netdev_feature_add(NETIF_F_NTUPLE_BIT, &features);
 	if (data & ETH_FLAG_RXHASH)
-		features |= NETIF_F_RXHASH;
+		netdev_feature_add(NETIF_F_RXHASH_BIT, &features);
 
 	netdev_features_zero(&eth_all_features);
 	netdev_features_set_array(&ethtool_all_feature_set, &eth_all_features);
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index ab1c4dfa25b7..421ce8c28932 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -462,15 +462,15 @@ void hsr_dev_setup(struct net_device *dev)
 	dev->features = dev->hw_features;
 
 	/* Prevent recursive tx locking */
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	/* VLAN on top of HSR needs testing and probably some work on
 	 * hsr_header_create() etc.
 	 */
-	dev->features |= NETIF_F_VLAN_CHALLENGED;
+	netdev_active_feature_add(dev, NETIF_F_VLAN_CHALLENGED_BIT);
 	/* Not sure about this. Taken from bridge code. netdev_features.h says
 	 * it means "Does not change network namespaces".
 	 */
-	dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
 }
 
 /* Return true if dev is a HSR master; return false otherwise.
diff --git a/net/ieee802154/6lowpan/core.c b/net/ieee802154/6lowpan/core.c
index 2c087b7f17c5..5f7affe795f0 100644
--- a/net/ieee802154/6lowpan/core.c
+++ b/net/ieee802154/6lowpan/core.c
@@ -46,6 +46,7 @@
 
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/ieee802154.h>
 #include <linux/if_arp.h>
 
@@ -116,7 +117,7 @@ static void lowpan_setup(struct net_device *ldev)
 	ldev->netdev_ops	= &lowpan_netdev_ops;
 	ldev->header_ops	= &lowpan_header_ops;
 	ldev->needs_free_netdev	= true;
-	ldev->features		|= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(ldev, NETIF_F_NETNS_LOCAL_BIT);
 }
 
 static int lowpan_validate(struct nlattr *tb[], struct nlattr *data[],
diff --git a/net/ieee802154/core.c b/net/ieee802154/core.c
index de259b5170ab..8eda70f58682 100644
--- a/net/ieee802154/core.c
+++ b/net/ieee802154/core.c
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
+#include <linux/netdev_features_helper.h>
 
 #include <net/cfg802154.h>
 #include <net/rtnetlink.h>
@@ -208,7 +209,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 		err = dev_change_net_namespace(wpan_dev->netdev, net, "wpan%d");
 		if (err)
 			break;
-		wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_active_feature_add(wpan_dev->netdev,
+					  NETIF_F_NETNS_LOCAL_BIT);
 	}
 
 	if (err) {
@@ -224,7 +226,8 @@ int cfg802154_switch_netns(struct cfg802154_registered_device *rdev,
 			err = dev_change_net_namespace(wpan_dev->netdev, net,
 						       "wpan%d");
 			WARN_ON(err);
-			wpan_dev->netdev->features |= NETIF_F_NETNS_LOCAL;
+			netdev_active_feature_add(wpan_dev->netdev,
+						  NETIF_F_NETNS_LOCAL_BIT);
 		}
 
 		return err;
@@ -269,7 +272,7 @@ static int cfg802154_netdev_notifier_call(struct notifier_block *nb,
 	switch (state) {
 		/* TODO NETDEV_DEVTYPE */
 	case NETDEV_REGISTER:
-		dev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
 		wpan_dev->identifier = ++rdev->wpan_dev_id;
 		list_add_rcu(&wpan_dev->list, &rdev->wpan_dev_list);
 		rdev->devlist_generation++;
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index e65e948cab9f..8c4fd17535dd 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -1074,7 +1074,8 @@ int ip_tunnel_init_net(struct net *net, unsigned int ip_tnl_net_id,
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
 	if (!IS_ERR(itn->fb_tunnel_dev)) {
-		itn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_active_feature_add(itn->fb_tunnel_dev,
+					  NETIF_F_NETNS_LOCAL_BIT);
 		itn->fb_tunnel_dev->mtu = ip_tunnel_bind_dev(itn->fb_tunnel_dev);
 		ip_tunnel_add(itn, netdev_priv(itn->fb_tunnel_dev));
 		itn->type = itn->fb_tunnel_dev->type;
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 8c2bd1d9ddce..022aee189e6f 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -21,6 +21,7 @@
 #include <linux/uaccess.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/in.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
@@ -430,7 +431,7 @@ static int vti_tunnel_init(struct net_device *dev)
 
 	dev->flags		= IFF_NOARP;
 	dev->addr_len		= 4;
-	dev->features		|= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_keep_dst(dev);
 
 	return ip_tunnel_init(dev);
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index 66b2deb4ddff..e1988286c523 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -371,7 +371,7 @@ static void ipip_tunnel_setup(struct net_device *dev)
 	dev->type		= ARPHRD_TUNNEL;
 	dev->flags		= IFF_NOARP;
 	dev->addr_len		= 4;
-	dev->features		|= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_keep_dst(dev);
 
 	ipip_features		= NETIF_F_GSO_SOFTWARE;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 73651d17e51f..330e3fa258e6 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -536,7 +536,7 @@ static void reg_vif_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	dev->netdev_ops		= &reg_vif_netdev_ops;
 	dev->needs_free_netdev	= true;
-	dev->features		|= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
 }
 
 static struct net_device *ipmr_reg_vif(struct net *net, struct mr_table *mrt)
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 3f3c158a5ac5..3f1cbb081f39 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -82,7 +82,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 	if (unlikely(skb->len <= mss))
 		goto out;
 
-	features |= NETIF_F_GSO_ROBUST;
+	netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, &features);
 	if (skb_gso_ok(skb, features)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 0486dbe58390..b699b89e592b 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -79,7 +79,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	if (remcsum) {
 		features &= ~NETIF_F_CSUM_MASK;
 		if (!need_csum || offload_csum)
-			features |= NETIF_F_HW_CSUM;
+			netdev_feature_add(NETIF_F_HW_CSUM_BIT, &features);
 	}
 
 	/* segment inner packet. */
@@ -415,7 +415,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 	 * software prior to segmenting the frame.
 	 */
 	if (!skb->encap_hdr_csum)
-		features |= NETIF_F_HW_CSUM;
+		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &features);
 
 	/* Fragment the skb. IP headers of the fragments are updated in
 	 * inet_gso_segment()
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index b91a001077af..1a322cd002cb 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -1632,7 +1632,7 @@ static int __net_init ip6gre_init_net(struct net *net)
 	/* FB netdevice is special: we have one, and only one per netns.
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
-	ign->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(ign->fb_tunnel_dev, NETIF_F_NETNS_LOCAL_BIT);
 
 
 	ip6gre_fb_tunnel_init(ign->fb_tunnel_dev);
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index da8eccfd1849..2922f0f66634 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1840,7 +1840,7 @@ static void ip6_tnl_dev_setup(struct net_device *dev)
 	dev->type = ARPHRD_TUNNEL6;
 	dev->flags |= IFF_NOARP;
 	dev->addr_len = sizeof(struct in6_addr);
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_keep_dst(dev);
 
 	ipxipx_features = NETIF_F_GSO_SOFTWARE;
@@ -2288,7 +2288,7 @@ static int __net_init ip6_tnl_init_net(struct net *net)
 	/* FB netdevice is special: we have one, and only one per netns.
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
-	ip6n->fb_tnl_dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(ip6n->fb_tnl_dev, NETIF_F_NETNS_LOCAL_BIT);
 
 	err = ip6_fb_tnl_dev_init(ip6n->fb_tnl_dev);
 	if (err < 0)
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index a9ba41648e36..ac153f8783e1 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -22,6 +22,7 @@
 #include <linux/socket.h>
 #include <linux/inet.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/inetdevice.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -640,7 +641,7 @@ static void reg_vif_setup(struct net_device *dev)
 	dev->flags		= IFF_NOARP;
 	dev->netdev_ops		= &reg_vif_netdev_ops;
 	dev->needs_free_netdev	= true;
-	dev->features		|= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
 }
 
 static struct net_device *ip6mr_reg_vif(struct net *net, struct mr_table *mrt)
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 9e4c02fd379c..69d10ab34e1c 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1434,7 +1434,7 @@ static void ipip6_tunnel_setup(struct net_device *dev)
 	dev->addr_len		= 4;
 	sit_features = NETIF_F_GSO_SOFTWARE;
 	netdev_features_set_array(&sit_feature_set, &sit_features);
-	dev->features		|= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	dev->features		|= sit_features;
 	dev->hw_features	|= sit_features;
 }
@@ -1914,7 +1914,8 @@ static int __net_init sit_init_net(struct net *net)
 	/* FB netdevice is special: we have one, and only one per netns.
 	 * Allowing to move it to another netns is clearly unsafe.
 	 */
-	sitn->fb_tunnel_dev->features |= NETIF_F_NETNS_LOCAL;
+	netdev_active_feature_add(sitn->fb_tunnel_dev,
+				  NETIF_F_NETNS_LOCAL_BIT);
 
 	err = register_netdev(sitn->fb_tunnel_dev);
 	if (err)
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 7720d04ed396..301ba864096c 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -70,7 +70,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 		 * software prior to segmenting the frame.
 		 */
 		if (!skb->encap_hdr_csum)
-			features |= NETIF_F_HW_CSUM;
+			netdev_feature_add(NETIF_F_HW_CSUM_BIT, &features);
 
 		/* Check if there is enough headroom to insert fragment header. */
 		tnl_hlen = skb_tnl_header_len(skb);
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 6cd97c75445c..0ee490b4b846 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -117,7 +117,7 @@ static void l2tp_eth_dev_setup(struct net_device *dev)
 	SET_NETDEV_DEVTYPE(dev, &l2tpeth_type);
 	ether_setup(dev);
 	dev->priv_flags		&= ~IFF_TX_SKB_SHARING;
-	dev->features		|= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	dev->netdev_ops		= &l2tp_eth_netdev_ops;
 	dev->needs_free_netdev	= true;
 }
diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index ba98ac8e31c8..d9b55bf19fd0 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -7,6 +7,7 @@
 
 #include <linux/module.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>
 #include <net/nsh.h>
 #include <net/tun_proto.h>
@@ -105,7 +106,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	skb->mac_len = proto == htons(ETH_P_TEB) ? ETH_HLEN : 0;
 	skb->protocol = proto;
 
-	tmp |= NETIF_F_SG;
+	netdev_feature_add(NETIF_F_SG_BIT, &tmp);
 	features &= tmp;
 	segs = skb_mac_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 73571e1393fc..9a4e86ae2cbf 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/time.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/genetlink.h>
 #include <linux/kernel.h>
 #include <linux/kthread.h>
@@ -325,7 +326,7 @@ static int queue_gso_packets(struct datapath *dp, struct sk_buff *skb,
 	int err;
 
 	BUILD_BUG_ON(sizeof(*OVS_CB(skb)) > SKB_GSO_CB_OFFSET);
-	features |= NETIF_F_SG;
+	netdev_feature_add(NETIF_F_SG_BIT, &features);
 	segs = __skb_gso_segment(skb, features, false);
 	if (IS_ERR(segs))
 		return PTR_ERR(segs);
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 522457207275..888ffcb2e1ca 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -160,7 +160,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
 
 	/* Restrict bridge port to current netns. */
 	if (vport->port_no == OVSP_LOCAL)
-		vport->dev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_active_feature_add(vport->dev, NETIF_F_NETNS_LOCAL_BIT);
 
 	rtnl_lock();
 	err = register_netdevice(vport->dev);
diff --git a/net/phonet/pep-gprs.c b/net/phonet/pep-gprs.c
index 0b09b1ba0c05..a72d85722df7 100644
--- a/net/phonet/pep-gprs.c
+++ b/net/phonet/pep-gprs.c
@@ -214,7 +214,7 @@ static const struct net_device_ops gprs_netdev_ops = {
 static void gprs_setup(struct net_device *dev)
 {
 	netdev_active_features_zero(dev);
-	dev->features		|= NETIF_F_FRAGLIST;
+	netdev_active_feature_add(dev, NETIF_F_FRAGLIST_BIT);
 	dev->type		= ARPHRD_PHONET_PIPE;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
 	dev->mtu		= GPRS_DEFAULT_MTU;
diff --git a/net/sctp/offload.c b/net/sctp/offload.c
index 1433fcc0977d..ad77e0362188 100644
--- a/net/sctp/offload.c
+++ b/net/sctp/offload.c
@@ -14,6 +14,7 @@
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
 #include <linux/module.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/kfifo.h>
 #include <linux/time.h>
 #include <net/net_namespace.h>
@@ -51,7 +52,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 
 	__skb_pull(skb, sizeof(*sh));
 
-	tmp |= NETIF_F_GSO_ROBUST;
+	netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, &tmp);
 	if (skb_gso_ok(skb, tmp)) {
 		/* Packet is from an untrusted source, reset gso_segs. */
 		struct skb_shared_info *pinfo = skb_shinfo(skb);
@@ -71,7 +72,7 @@ static struct sk_buff *sctp_gso_segment(struct sk_buff *skb,
 	}
 
 	tmp = features;
-	tmp |= NETIF_F_HW_CSUM;
+	netdev_feature_add(NETIF_F_HW_CSUM_BIT, &tmp);
 	tmp &= ~NETIF_F_SG;
 	segs = skb_segment(skb, tmp);
 	if (IS_ERR(segs))
diff --git a/net/wireless/core.c b/net/wireless/core.c
index eefd6d8ff465..57504e859573 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -20,6 +20,7 @@
 #include <linux/notifier.h>
 #include <linux/device.h>
 #include <linux/etherdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/rtnetlink.h>
 #include <linux/sched.h>
 #include <net/genetlink.h>
@@ -168,7 +169,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
 		if (err)
 			break;
-		wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_active_feature_add(wdev->netdev,
+					  NETIF_F_NETNS_LOCAL_BIT);
 	}
 
 	if (err) {
@@ -184,7 +186,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 			err = dev_change_net_namespace(wdev->netdev, net,
 							"wlan%d");
 			WARN_ON(err);
-			wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
+			netdev_active_feature_add(wdev->netdev,
+						  NETIF_F_NETNS_LOCAL_BIT);
 		}
 
 		return err;
@@ -1412,7 +1415,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
 		wdev->netdev = dev;
 		/* can only change netns with wiphy */
-		dev->features |= NETIF_F_NETNS_LOCAL;
+		netdev_active_feature_add(dev, NETIF_F_NETNS_LOCAL_BIT);
 
 		cfg80211_init_wdev(wdev);
 		break;
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index d80bff81b346..41a05e6d2ef0 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -597,7 +597,7 @@ static int xfrmi_dev_init(struct net_device *dev)
 
 	xfrmi_features = NETIF_F_GSO_SOFTWARE;
 	netdev_features_set_array(&xfrmi_feature_set, &xfrmi_features);
-	dev->features |= NETIF_F_LLTX;
+	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	dev->features |= xfrmi_features;
 	dev->hw_features |= xfrmi_features;
 
-- 
2.33.0

