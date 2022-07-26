Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596CD581BDC
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiGZV5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGZV5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:57:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE57D12AB7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 14:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 977ACB81F01
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 21:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2069BC433C1;
        Tue, 26 Jul 2022 21:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658872617;
        bh=MOX3fFg6Z1DOgTL6XuWLK6cjxmFA7kSLpuGXfARsnSM=;
        h=From:To:Cc:Subject:Date:From;
        b=L/++v3YSV7SeBqT52NPSnCm3p26N+Hc84wDkZTXr+8iCB1fFtm9bFawbsbSGeTsW9
         s37xV5+V5DwCxm4EhmgkD6wiG5XdrWxYl/s8Febg5zP+nFH5SA0BcWGRpnuv1BFZHx
         HrmILePhLoY9OJmZNdwG3j+3GChksZ16XCZSwZ4rQDHOnd8szbxNmd1xs6h56FTxj5
         DG/PG3EacHU6jzH2dB2W2H2n0LsCyCAY2pLH8Q5HY321RX4KMyjnlb9KEu0TgRX9bv
         xVumb0fuh0DNT8oYXPR8+zr3ykmaz7su7hiJbhax6W7hahovaa+5cIs99HZeGq06Ti
         u4S1PHPx/Q7TA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2] add missing includes and forward declarations to networking includes under linux/
Date:   Tue, 26 Jul 2022 14:56:52 -0700
Message-Id: <20220726215652.158167-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to a recent include/net/ cleanup, this patch adds
missing includes to networking headers under include/linux.
All these problems are currently masked by the existing users
including the missing dependency before the broken header.

Link: https://lore.kernel.org/all/20220723045755.2676857-1-kuba@kernel.org/ v1
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2: drop the unnecessary forwards caught by Paolo
---
 include/linux/atm_tcp.h         |  2 ++
 include/linux/dsa/tag_qca.h     |  5 +++++
 include/linux/hippidevice.h     |  4 ++++
 include/linux/if_eql.h          |  1 +
 include/linux/if_hsr.h          |  4 ++++
 include/linux/if_rmnet.h        |  2 ++
 include/linux/if_tap.h          | 11 ++++++-----
 include/linux/mdio/mdio-xgene.h |  4 ++++
 include/linux/nl802154.h        |  2 ++
 include/linux/phy_fixed.h       |  3 +++
 include/linux/ppp-comp.h        |  2 +-
 include/linux/ppp_channel.h     |  2 ++
 include/linux/ptp_kvm.h         |  2 ++
 include/linux/ptp_pch.h         |  4 ++++
 include/linux/seq_file_net.h    |  1 +
 include/linux/sungem_phy.h      |  2 ++
 include/linux/usb/usbnet.h      |  6 ++++++
 include/net/llc_s_st.h          |  6 ++++++
 18 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/include/linux/atm_tcp.h b/include/linux/atm_tcp.h
index c8ecf6f68fb5..2558439d849b 100644
--- a/include/linux/atm_tcp.h
+++ b/include/linux/atm_tcp.h
@@ -9,6 +9,8 @@
 
 #include <uapi/linux/atm_tcp.h>
 
+struct atm_vcc;
+struct module;
 
 struct atm_tcp_ops {
 	int (*attach)(struct atm_vcc *vcc,int itf);
diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
index 4359fb0221cf..50be7cbd93a5 100644
--- a/include/linux/dsa/tag_qca.h
+++ b/include/linux/dsa/tag_qca.h
@@ -3,6 +3,11 @@
 #ifndef __TAG_QCA_H
 #define __TAG_QCA_H
 
+#include <linux/types.h>
+
+struct dsa_switch;
+struct sk_buff;
+
 #define QCA_HDR_LEN	2
 #define QCA_HDR_VERSION	0x2
 
diff --git a/include/linux/hippidevice.h b/include/linux/hippidevice.h
index 9dc01f7ab5b4..07414c241e65 100644
--- a/include/linux/hippidevice.h
+++ b/include/linux/hippidevice.h
@@ -23,6 +23,10 @@
 
 #ifdef __KERNEL__
 
+struct neigh_parms;
+struct net_device;
+struct sk_buff;
+
 struct hippi_cb {
 	__u32	ifield;
 };
diff --git a/include/linux/if_eql.h b/include/linux/if_eql.h
index d75601d613cc..07f9b660b741 100644
--- a/include/linux/if_eql.h
+++ b/include/linux/if_eql.h
@@ -21,6 +21,7 @@
 
 #include <linux/timer.h>
 #include <linux/spinlock.h>
+#include <net/net_trackers.h>
 #include <uapi/linux/if_eql.h>
 
 typedef struct slave {
diff --git a/include/linux/if_hsr.h b/include/linux/if_hsr.h
index 408539d5ea5f..0404f5bf4f30 100644
--- a/include/linux/if_hsr.h
+++ b/include/linux/if_hsr.h
@@ -2,6 +2,10 @@
 #ifndef _LINUX_IF_HSR_H_
 #define _LINUX_IF_HSR_H_
 
+#include <linux/types.h>
+
+struct net_device;
+
 /* used to differentiate various protocols */
 enum hsr_version {
 	HSR_V0 = 0,
diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
index 10e7521ecb6c..839d1e48b85e 100644
--- a/include/linux/if_rmnet.h
+++ b/include/linux/if_rmnet.h
@@ -5,6 +5,8 @@
 #ifndef _LINUX_IF_RMNET_H_
 #define _LINUX_IF_RMNET_H_
 
+#include <linux/types.h>
+
 struct rmnet_map_header {
 	u8 flags;			/* MAP_CMD_FLAG, MAP_PAD_LEN_MASK */
 	u8 mux_id;
diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
index 915a187cfabd..553552fa635c 100644
--- a/include/linux/if_tap.h
+++ b/include/linux/if_tap.h
@@ -2,14 +2,18 @@
 #ifndef _LINUX_IF_TAP_H_
 #define _LINUX_IF_TAP_H_
 
+#include <net/sock.h>
+#include <linux/skb_array.h>
+
+struct file;
+struct socket;
+
 #if IS_ENABLED(CONFIG_TAP)
 struct socket *tap_get_socket(struct file *);
 struct ptr_ring *tap_get_ptr_ring(struct file *file);
 #else
 #include <linux/err.h>
 #include <linux/errno.h>
-struct file;
-struct socket;
 static inline struct socket *tap_get_socket(struct file *f)
 {
 	return ERR_PTR(-EINVAL);
@@ -20,9 +24,6 @@ static inline struct ptr_ring *tap_get_ptr_ring(struct file *f)
 }
 #endif /* CONFIG_TAP */
 
-#include <net/sock.h>
-#include <linux/skb_array.h>
-
 /*
  * Maximum times a tap device can be opened. This can be used to
  * configure the number of receive queue, e.g. for multiqueue virtio.
diff --git a/include/linux/mdio/mdio-xgene.h b/include/linux/mdio/mdio-xgene.h
index 8af93ada8b64..9e588965dc83 100644
--- a/include/linux/mdio/mdio-xgene.h
+++ b/include/linux/mdio/mdio-xgene.h
@@ -8,6 +8,10 @@
 #ifndef __MDIO_XGENE_H__
 #define __MDIO_XGENE_H__
 
+#include <linux/bits.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
 #define BLOCK_XG_MDIO_CSR_OFFSET	0x5000
 #define BLOCK_DIAG_CSR_OFFSET		0xd000
 #define XGENET_CONFIG_REG_ADDR		0x20
diff --git a/include/linux/nl802154.h b/include/linux/nl802154.h
index b22782225f27..cbe5fd1dd2e7 100644
--- a/include/linux/nl802154.h
+++ b/include/linux/nl802154.h
@@ -8,6 +8,8 @@
 #ifndef NL802154_H
 #define NL802154_H
 
+#include <net/netlink.h>
+
 #define IEEE802154_NL_NAME "802.15.4 MAC"
 #define IEEE802154_MCAST_COORD_NAME "coordinator"
 #define IEEE802154_MCAST_BEACON_NAME "beacon"
diff --git a/include/linux/phy_fixed.h b/include/linux/phy_fixed.h
index 52bc8e487ef7..1acafd86ab13 100644
--- a/include/linux/phy_fixed.h
+++ b/include/linux/phy_fixed.h
@@ -2,6 +2,8 @@
 #ifndef __PHY_FIXED_H
 #define __PHY_FIXED_H
 
+#include <linux/types.h>
+
 struct fixed_phy_status {
 	int link;
 	int speed;
@@ -12,6 +14,7 @@ struct fixed_phy_status {
 
 struct device_node;
 struct gpio_desc;
+struct net_device;
 
 #if IS_ENABLED(CONFIG_FIXED_PHY)
 extern int fixed_phy_change_carrier(struct net_device *dev, bool new_carrier);
diff --git a/include/linux/ppp-comp.h b/include/linux/ppp-comp.h
index 9d3ffc8f5ea6..fb847e47f148 100644
--- a/include/linux/ppp-comp.h
+++ b/include/linux/ppp-comp.h
@@ -9,7 +9,7 @@
 
 #include <uapi/linux/ppp-comp.h>
 
-
+struct compstat;
 struct module;
 
 /*
diff --git a/include/linux/ppp_channel.h b/include/linux/ppp_channel.h
index 91f9a928344e..45e6e427ceb8 100644
--- a/include/linux/ppp_channel.h
+++ b/include/linux/ppp_channel.h
@@ -20,6 +20,8 @@
 #include <linux/poll.h>
 #include <net/net_namespace.h>
 
+struct net_device_path;
+struct net_device_path_ctx;
 struct ppp_channel;
 
 struct ppp_channel_ops {
diff --git a/include/linux/ptp_kvm.h b/include/linux/ptp_kvm.h
index f960a719f0d5..c2e28deef33a 100644
--- a/include/linux/ptp_kvm.h
+++ b/include/linux/ptp_kvm.h
@@ -8,6 +8,8 @@
 #ifndef _PTP_KVM_H_
 #define _PTP_KVM_H_
 
+#include <linux/types.h>
+
 struct timespec64;
 struct clocksource;
 
diff --git a/include/linux/ptp_pch.h b/include/linux/ptp_pch.h
index 51818198c292..7ba643b62c15 100644
--- a/include/linux/ptp_pch.h
+++ b/include/linux/ptp_pch.h
@@ -10,6 +10,10 @@
 #ifndef _PTP_PCH_H_
 #define _PTP_PCH_H_
 
+#include <linux/types.h>
+
+struct pci_dev;
+
 void pch_ch_control_write(struct pci_dev *pdev, u32 val);
 u32  pch_ch_event_read(struct pci_dev *pdev);
 void pch_ch_event_write(struct pci_dev *pdev, u32 val);
diff --git a/include/linux/seq_file_net.h b/include/linux/seq_file_net.h
index b97912fdbae7..79638395bc32 100644
--- a/include/linux/seq_file_net.h
+++ b/include/linux/seq_file_net.h
@@ -3,6 +3,7 @@
 #define __SEQ_FILE_NET_H__
 
 #include <linux/seq_file.h>
+#include <net/net_trackers.h>
 
 struct net;
 extern struct net init_net;
diff --git a/include/linux/sungem_phy.h b/include/linux/sungem_phy.h
index 3a11fa41a131..c505f30e8b68 100644
--- a/include/linux/sungem_phy.h
+++ b/include/linux/sungem_phy.h
@@ -2,6 +2,8 @@
 #ifndef __SUNGEM_PHY_H__
 #define __SUNGEM_PHY_H__
 
+#include <linux/types.h>
+
 struct mii_phy;
 
 /* Operations supported by any kind of PHY */
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 1b4d72d5e891..b42b72391a8d 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -23,6 +23,12 @@
 #ifndef	__LINUX_USB_USBNET_H
 #define	__LINUX_USB_USBNET_H
 
+#include <linux/mii.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <linux/usb.h>
+
 /* interface from usbnet core to each USB networking link we handle */
 struct usbnet {
 	/* housekeeping */
diff --git a/include/net/llc_s_st.h b/include/net/llc_s_st.h
index c4359e203013..ed5b2fa40d32 100644
--- a/include/net/llc_s_st.h
+++ b/include/net/llc_s_st.h
@@ -12,6 +12,12 @@
  * See the GNU General Public License for more details.
  */
 
+#include <linux/types.h>
+#include <net/llc_s_ac.h>
+#include <net/llc_s_ev.h>
+
+struct llc_sap_state_trans;
+
 #define LLC_NR_SAP_STATES	2       /* size of state table */
 
 /* structures and types */
-- 
2.37.1

