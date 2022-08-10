Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C16258E544
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiHJDOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiHJDNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:50 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346F181B30
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:48 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgv0rbJzjXhl;
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
Subject: [RFCv7 PATCH net-next 16/36] treewide: use replace features '0' by netdev_empty_features
Date:   Wed, 10 Aug 2022 11:06:04 +0800
Message-ID: <20220810030624.34711-17-shenjian15@huawei.com>
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

For the prototype of netdev_features_t will be changed from
u64 to bitmap, so it's unable to assignment with 0 directly.
Replace it with netdev_empty_features.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/hsi/clients/ssi_protocol.c             | 2 +-
 drivers/net/caif/caif_serial.c                 | 2 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c   | 2 +-
 drivers/net/ethernet/broadcom/b44.c            | 2 +-
 drivers/net/ethernet/broadcom/tg3.c            | 2 +-
 drivers/net/ethernet/dnet.c                    | 2 +-
 drivers/net/ethernet/ec_bhf.c                  | 2 +-
 drivers/net/ethernet/emulex/benet/be_main.c    | 2 +-
 drivers/net/ethernet/ethoc.c                   | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 5 +++--
 drivers/net/ethernet/ibm/ibmvnic.c             | 6 +++---
 drivers/net/ethernet/intel/iavf/iavf_main.c    | 9 +++++----
 drivers/net/ethernet/microsoft/mana/mana_en.c  | 2 +-
 drivers/net/ethernet/sfc/ef10.c                | 2 +-
 drivers/net/tap.c                              | 2 +-
 drivers/net/tun.c                              | 2 +-
 drivers/net/usb/cdc-phonet.c                   | 3 ++-
 drivers/net/usb/lan78xx.c                      | 2 +-
 drivers/s390/net/qeth_core_main.c              | 2 +-
 drivers/usb/gadget/function/f_phonet.c         | 3 ++-
 net/dccp/ipv4.c                                | 2 +-
 net/dccp/ipv6.c                                | 2 +-
 net/ethtool/features.c                         | 2 +-
 net/ethtool/ioctl.c                            | 6 ++++--
 net/ipv4/af_inet.c                             | 2 +-
 net/ipv4/tcp.c                                 | 2 +-
 net/ipv4/tcp_ipv4.c                            | 2 +-
 net/ipv6/af_inet6.c                            | 2 +-
 net/ipv6/inet6_connection_sock.c               | 2 +-
 net/ipv6/tcp_ipv6.c                            | 2 +-
 net/openvswitch/datapath.c                     | 2 +-
 31 files changed, 44 insertions(+), 38 deletions(-)

diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 21f11a5b965b..c7f3dae91e36 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -1057,7 +1057,7 @@ static void ssip_pn_setup(struct net_device *dev)
 {
 	static const u8 addr = PN_MEDIA_SOS;
 
-	dev->features		= 0;
+	dev->features		= netdev_empty_features;
 	dev->netdev_ops		= &ssip_pn_ops;
 	dev->type		= ARPHRD_PHONET;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 688075859ae4..1fca20f97e8f 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -398,7 +398,7 @@ static void caifdev_setup(struct net_device *dev)
 {
 	struct ser_device *serdev = netdev_priv(dev);
 
-	dev->features = 0;
+	dev->features = netdev_empty_features;
 	dev->netdev_ops = &netdev_ops;
 	dev->type = ARPHRD_CAIF;
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index ab102769965f..f77a930367ce 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -4019,7 +4019,7 @@ static DECLARE_NETDEV_FEATURE_SET(ena_feature_set,
 static void ena_set_dev_offloads(struct ena_com_dev_get_features_ctx *feat,
 				 struct net_device *netdev)
 {
-	netdev_features_t dev_features = 0;
+	netdev_features_t dev_features = netdev_empty_features;
 
 	/* Set offload features */
 	if (feat->offload.tx &
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index e5857e88c207..075bdded8e45 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2359,7 +2359,7 @@ static int b44_init_one(struct ssb_device *sdev,
 	SET_NETDEV_DEV(dev, sdev->dev);
 
 	/* No interesting netdevice features in this card... */
-	dev->features |= 0;
+	dev->features |= netdev_empty_features;
 
 	bp = netdev_priv(dev);
 	bp->sdev = sdev;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 72a9b1f38cab..f4a455f8743b 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17550,13 +17550,13 @@ static void tg3_init_coal(struct tg3 *tp)
 static int tg3_init_one(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
+	netdev_features_t features = netdev_empty_features;
 	struct net_device *dev;
 	struct tg3 *tp;
 	int i, err;
 	u32 sndmbx, rcvmbx, intmbx;
 	char str[40];
 	u64 dma_mask, persist_dma_mask;
-	netdev_features_t features = 0;
 	u8 addr[ETH_ALEN] __aligned(2);
 
 	err = pci_enable_device(pdev);
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index 92462ed87bc4..7f4dcea2cd87 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -763,7 +763,7 @@ static int dnet_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* TODO: Actually, we have some interesting features... */
-	dev->features |= 0;
+	dev->features |= netdev_empty_features;
 
 	bp = netdev_priv(dev);
 	bp->dev = dev;
diff --git a/drivers/net/ethernet/ec_bhf.c b/drivers/net/ethernet/ec_bhf.c
index 46e3a05e9582..44e90e06fdab 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -525,7 +525,7 @@ static int ec_bhf_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	pci_set_drvdata(dev, net_dev);
 	SET_NETDEV_DEV(net_dev, &dev->dev);
 
-	net_dev->features = 0;
+	net_dev->features = netdev_empty_features;
 	net_dev->flags |= IFF_NOARP;
 
 	net_dev->netdev_ops = &ec_bhf_netdev_ops;
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 22af4232329e..fefacd5530e2 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4029,7 +4029,7 @@ static int be_vxlan_unset_port(struct net_device *netdev, unsigned int table,
 	adapter->flags &= ~BE_FLAGS_VXLAN_OFFLOADS;
 	adapter->vxlan_port = 0;
 
-	netdev->hw_enc_features = 0;
+	netdev->hw_enc_features = netdev_empty_features;
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/ethoc.c b/drivers/net/ethernet/ethoc.c
index 437c5acfe222..3ced63aaa6cb 100644
--- a/drivers/net/ethernet/ethoc.c
+++ b/drivers/net/ethernet/ethoc.c
@@ -1220,7 +1220,7 @@ static int ethoc_probe(struct platform_device *pdev)
 	/* setup the net_device structure */
 	netdev->netdev_ops = &ethoc_netdev_ops;
 	netdev->watchdog_timeo = ETHOC_TIMEOUT;
-	netdev->features |= 0;
+	netdev->features |= netdev_empty_features;
 	netdev->ethtool_ops = &ethoc_ethtool_ops;
 
 	/* setup NAPI */
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 80d14a014d2d..93d4b019a4d1 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1073,8 +1073,8 @@ static int set_features(struct hinic_dev *nic_dev,
 			netdev_features_t features, bool force_change)
 {
 	netdev_features_t changed = force_change ? ~0 : pre_features ^ features;
+	netdev_features_t failed_features = netdev_empty_features;
 	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
-	netdev_features_t failed_features = 0;
 	int ret = 0;
 	int err = 0;
 
@@ -1295,7 +1295,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 				HINIC_MGMT_MSG_CMD_LINK_ERR_EVENT,
 				nic_dev, link_err_event);
 
-	err = set_features(nic_dev, 0, nic_dev->netdev->features, true);
+	err = set_features(nic_dev, netdev_empty_features,
+			   nic_dev->netdev->features, true);
 	if (err)
 		goto err_set_features;
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 598f5b9d9025..0ceecd372b7e 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4840,8 +4840,8 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 {
 	struct ibmvnic_control_ip_offload_buffer *ctrl_buf = &adapter->ip_offload_ctrl;
 	struct ibmvnic_query_ip_offload_buffer *buf = &adapter->ip_offload_buf;
+	netdev_features_t old_hw_features = netdev_emtpy_features;
 	struct device *dev = &adapter->vdev->dev;
-	netdev_features_t old_hw_features = 0;
 	union ibmvnic_crq crq;
 
 	adapter->ip_offload_ctrl_tok =
@@ -4872,7 +4872,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 
 	if (adapter->state != VNIC_PROBING) {
 		old_hw_features = adapter->netdev->hw_features;
-		adapter->netdev->hw_features = 0;
+		adapter->netdev->hw_features = netdev_empty_features;
 	}
 
 	netdev_hw_features_zero(adapter->netdev);
@@ -4895,7 +4895,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	if (adapter->state == VNIC_PROBING) {
 		adapter->netdev->features |= adapter->netdev->hw_features;
 	} else if (old_hw_features != adapter->netdev->hw_features) {
-		netdev_features_t tmp = 0;
+		netdev_features_t tmp = netdev_empty_features;
 
 		/* disable features no longer supported */
 		adapter->netdev->features &= adapter->netdev->hw_features;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 95dd5a16b553..d4a2776381c3 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2595,7 +2595,8 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 
 	if (VLAN_V2_ALLOWED(adapter))
 		/* request initial VLAN offload settings */
-		iavf_set_vlan_offload_features(adapter, 0, netdev->features);
+		iavf_set_vlan_offload_features(adapter, netdev_empty_features,
+					       netdev->features);
 
 	return;
 err_mem:
@@ -3151,7 +3152,7 @@ static void iavf_adminq_task(struct work_struct *work)
 			/* Request VLAN offload settings */
 			if (VLAN_V2_ALLOWED(adapter))
 				iavf_set_vlan_offload_features
-					(adapter, 0, netdev->features);
+					(adapter, netdev_empty_features, netdev->features);
 
 			iavf_set_queue_vlan_tag_loc(adapter);
 		}
@@ -4316,7 +4317,7 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 static netdev_features_t
 iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 {
-	netdev_features_t hw_features = 0;
+	netdev_features_t hw_features = netdev_empty_features;
 
 	if (!adapter->vf_res || !adapter->vf_res->vf_cap_flags)
 		return hw_features;
@@ -4377,7 +4378,7 @@ iavf_get_netdev_vlan_hw_features(struct iavf_adapter *adapter)
 static netdev_features_t
 iavf_get_netdev_vlan_features(struct iavf_adapter *adapter)
 {
-	netdev_features_t features = 0;
+	netdev_features_t features = netdev_empty_features;
 
 	if (!adapter->vf_res || !adapter->vf_res->vf_cap_flags)
 		return features;
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d2a424573d89..29bb41fdcdcd 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2093,7 +2093,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	netdev_hw_features_zero(ndev);
 	netdev_hw_features_set_array(ndev, &mana_hw_feature_set);
 	ndev->features = ndev->hw_features;
-	ndev->vlan_features = 0;
+	ndev->vlan_features = netdev_empty_features;
 
 	err = register_netdev(ndev);
 	if (err) {
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index dd8e278f8d8d..2f908bf1f019 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1310,7 +1310,7 @@ static DECLARE_NETDEV_FEATURE_SET(ef10_tso_feature_set,
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features = 0;
+	netdev_features_t hw_enc_features = netdev_empty_features;
 	int rc;
 
 	if (nic_data->must_check_datapath_caps) {
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 7d5446500d67..53865533d7a9 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -944,7 +944,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 {
 	struct tap_dev *tap;
 	netdev_features_t features;
-	netdev_features_t feature_mask = 0;
+	netdev_features_t feature_mask = netdev_empty_features;
 
 	tap = rtnl_dereference(q->tap);
 	if (!tap)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 322956768815..661391e9399b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2865,7 +2865,7 @@ static void tun_get_iff(struct tun_struct *tun, struct ifreq *ifr)
  * privs required. */
 static int set_offload(struct tun_struct *tun, unsigned long arg)
 {
-	netdev_features_t features = 0;
+	netdev_features_t features = netdev_empty_features;
 
 	if (arg & TUN_F_CSUM) {
 		features |= NETIF_F_HW_CSUM;
diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index ad5121e9cf5d..8c5116ed7278 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -14,6 +14,7 @@
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/if_arp.h>
 #include <linux/if_phonet.h>
 #include <linux/phonet.h>
@@ -277,7 +278,7 @@ static void usbpn_setup(struct net_device *dev)
 {
 	const u8 addr = PN_MEDIA_USB;
 
-	dev->features		= 0;
+	dev->features		= netdev_empty_features;
 	dev->netdev_ops		= &usbpn_ops;
 	dev->header_ops		= &phonet_header_ops;
 	dev->type		= ARPHRD_PHONET;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index b3c01bee9504..1c67cfb9bdb8 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3462,7 +3462,7 @@ static int lan78xx_bind(struct lan78xx_net *dev, struct usb_interface *intf)
 
 	INIT_WORK(&pdata->set_vlan, lan78xx_deferred_vlan_write);
 
-	dev->net->features = 0;
+	dev->net->features = netdev_empty_features;
 
 	if (DEFAULT_TX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_HW_CSUM;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 35d4b398c197..1ee35c5cb0bd 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6938,7 +6938,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 	/* Traffic with local next-hop is not eligible for some offloads: */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
 	    READ_ONCE(card->options.isolation) != ISOLATION_MODE_FWD) {
-		netdev_features_t restricted = 0;
+		netdev_features_t restricted = netdev_empty_features;
 
 		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
 			restricted |= NETIF_F_ALL_TSO;
diff --git a/drivers/usb/gadget/function/f_phonet.c b/drivers/usb/gadget/function/f_phonet.c
index 0bebbdf3f213..a540bf98441f 100644
--- a/drivers/usb/gadget/function/f_phonet.c
+++ b/drivers/usb/gadget/function/f_phonet.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/if_ether.h>
 #include <linux/if_phonet.h>
 #include <linux/if_arp.h>
@@ -269,7 +270,7 @@ static void pn_net_setup(struct net_device *dev)
 {
 	const u8 addr = PN_MEDIA_USB;
 
-	dev->features		= 0;
+	dev->features		= netdev_empty_features;
 	dev->type		= ARPHRD_PHONET;
 	dev->flags		= IFF_POINTOPOINT | IFF_NOARP;
 	dev->mtu		= PHONET_DEV_MTU;
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index da6e3b20cd75..3a017cecc6d3 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -137,7 +137,7 @@ int dccp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 */
 	dccp_set_state(sk, DCCP_CLOSED);
 	ip_rt_put(rt);
-	sk->sk_route_caps = 0;
+	sk->sk_route_caps = netdev_empty_features;
 	inet->inet_dport = 0;
 	goto out;
 }
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 53fa477d20ab..84fdb991bee5 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -971,7 +971,7 @@ static int dccp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	__sk_dst_reset(sk);
 failure:
 	inet->inet_dport = 0;
-	sk->sk_route_caps = 0;
+	sk->sk_route_caps = netdev_empty_features;
 	return err;
 }
 
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 67a837d44491..38efdab960ba 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -144,7 +144,7 @@ static netdev_features_t ethnl_bitmap_to_features(unsigned long *src)
 {
 	const unsigned int nft_bits = sizeof(netdev_features_t) * BITS_PER_BYTE;
 	const unsigned int words = BITS_TO_LONGS(NETDEV_FEATURE_COUNT);
-	netdev_features_t ret = 0;
+	netdev_features_t ret = netdev_empty_features;
 	unsigned int i;
 
 	for (i = 0; i < words; i++)
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 8f32e4f06bfb..7674629773a1 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -125,7 +125,8 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 {
 	struct ethtool_sfeatures cmd;
 	struct ethtool_set_features_block features[ETHTOOL_DEV_FEATURE_WORDS];
-	netdev_features_t wanted = 0, valid = 0;
+	netdev_features_t wanted = netdev_empty_features;
+	netdev_features_t valid = netdev_empty_features;
 	netdev_features_t tmp;
 	int i, ret = 0;
 
@@ -332,8 +333,9 @@ static u32 __ethtool_get_flags(struct net_device *dev)
 
 static int __ethtool_set_flags(struct net_device *dev, u32 data)
 {
-	netdev_features_t features = 0, changed;
+	netdev_features_t features = netdev_empty_features;
 	netdev_features_t eth_all_features;
+	netdev_features_t changed;
 	netdev_features_t tmp;
 
 	if (data & ~ETH_ALL_FLAGS)
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 3ca0cc467886..ad3bea716358 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1297,7 +1297,7 @@ int inet_sk_rebuild_header(struct sock *sk)
 		err = PTR_ERR(rt);
 
 		/* Routing failed... */
-		sk->sk_route_caps = 0;
+		sk->sk_route_caps = netdev_empty_features;
 		/*
 		 * Other protocols have to map its equivalent state to TCP_SYN_SENT.
 		 * DCCP maps its DCCP_REQUESTING state to TCP_SYN_SENT. -acme
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 970e9a2cca4a..df10a1e5027c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1193,7 +1193,7 @@ static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 		if (err) {
 			tcp_set_state(sk, TCP_CLOSE);
 			inet->inet_dport = 0;
-			sk->sk_route_caps = 0;
+			sk->sk_route_caps = netdev_empty_features;
 		}
 	}
 	flags = (msg->msg_flags & MSG_DONTWAIT) ? O_NONBLOCK : 0;
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 0c83780dc9bf..0d1459b52fc9 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -324,7 +324,7 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	 */
 	tcp_set_state(sk, TCP_CLOSE);
 	ip_rt_put(rt);
-	sk->sk_route_caps = 0;
+	sk->sk_route_caps = netdev_empty_features;
 	inet->inet_dport = 0;
 	return err;
 }
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2ce0c44d0081..eacac47c9fda 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -846,7 +846,7 @@ int inet6_sk_rebuild_header(struct sock *sk)
 
 		dst = ip6_dst_lookup_flow(sock_net(sk), sk, &fl6, final_p);
 		if (IS_ERR(dst)) {
-			sk->sk_route_caps = 0;
+			sk->sk_route_caps = netdev_empty_features;
 			sk->sk_err_soft = -PTR_ERR(dst);
 			return PTR_ERR(dst);
 		}
diff --git a/net/ipv6/inet6_connection_sock.c b/net/ipv6/inet6_connection_sock.c
index 5a9f4d722f35..52209f42d18a 100644
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -121,7 +121,7 @@ int inet6_csk_xmit(struct sock *sk, struct sk_buff *skb, struct flowi *fl_unused
 	dst = inet6_csk_route_socket(sk, &fl6);
 	if (IS_ERR(dst)) {
 		sk->sk_err_soft = -PTR_ERR(dst);
-		sk->sk_route_caps = 0;
+		sk->sk_route_caps = netdev_empty_features;
 		kfree_skb(skb);
 		return PTR_ERR(dst);
 	}
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index e54eee80ce5f..c60e1f714b79 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -342,7 +342,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	tcp_set_state(sk, TCP_CLOSE);
 failure:
 	inet->inet_dport = 0;
-	sk->sk_route_caps = 0;
+	sk->sk_route_caps = netdev_empty_features;
 	return err;
 }
 
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 0780c418a971..73571e1393fc 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -437,7 +437,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
 
 	/* Complete checksum if needed */
 	if (skb->ip_summed == CHECKSUM_PARTIAL &&
-	    (err = skb_csum_hwoffload_help(skb, 0)))
+	    (err = skb_csum_hwoffload_help(skb, netdev_empty_features)))
 		goto out;
 
 	/* Older versions of OVS user space enforce alignment of the last
-- 
2.33.0

