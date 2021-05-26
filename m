Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114EB39167C
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 13:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbhEZLtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 07:49:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3978 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhEZLt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 07:49:29 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FqpyB4VvQzQpXK;
        Wed, 26 May 2021 19:44:18 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 19:47:55 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 01/10] net: wan: remove redundant blank lines
Date:   Wed, 26 May 2021 19:44:46 +0800
Message-ID: <1622029495-30357-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
References: <1622029495-30357-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

This patch removes some redundant blank lines.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_fr.c | 42 ------------------------------------------
 1 file changed, 42 deletions(-)

diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
index 0720f5f92caa..0b6e133de4ad 100644
--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -60,7 +60,6 @@
 #define NLPID_CCITT_ANSI_LMI	0x08
 #define NLPID_CISCO_LMI		0x09
 
-
 #define LMI_CCITT_ANSI_DLCI	   0 /* LMI DLCI */
 #define LMI_CISCO_DLCI		1023
 
@@ -86,7 +85,6 @@
 #define LMI_CCITT_CISCO_LENGTH	  13 /* LMI frame lengths */
 #define LMI_ANSI_LENGTH		  14
 
-
 struct fr_hdr {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	unsigned ea1:	1;
@@ -111,7 +109,6 @@ struct fr_hdr {
 #endif
 } __packed;
 
-
 struct pvc_device {
 	struct net_device *frad;
 	struct net_device *main;
@@ -149,29 +146,24 @@ struct frad_state {
 	u8 rxseq; /* RX sequence number */
 };
 
-
 static int fr_ioctl(struct net_device *dev, struct ifreq *ifr);
 
-
 static inline u16 q922_to_dlci(u8 *hdr)
 {
 	return ((hdr[0] & 0xFC) << 2) | ((hdr[1] & 0xF0) >> 4);
 }
 
-
 static inline void dlci_to_q922(u8 *hdr, u16 dlci)
 {
 	hdr[0] = (dlci >> 2) & 0xFC;
 	hdr[1] = ((dlci << 4) & 0xF0) | 0x01;
 }
 
-
 static inline struct frad_state* state(hdlc_device *hdlc)
 {
 	return(struct frad_state *)(hdlc->state);
 }
 
-
 static inline struct pvc_device *find_pvc(hdlc_device *hdlc, u16 dlci)
 {
 	struct pvc_device *pvc = state(hdlc)->first_pvc;
@@ -187,7 +179,6 @@ static inline struct pvc_device *find_pvc(hdlc_device *hdlc, u16 dlci)
 	return NULL;
 }
 
-
 static struct pvc_device *add_pvc(struct net_device *dev, u16 dlci)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -215,13 +206,11 @@ static struct pvc_device *add_pvc(struct net_device *dev, u16 dlci)
 	return pvc;
 }
 
-
 static inline int pvc_is_used(struct pvc_device *pvc)
 {
 	return pvc->main || pvc->ether;
 }
 
-
 static inline void pvc_carrier(int on, struct pvc_device *pvc)
 {
 	if (on) {
@@ -241,7 +230,6 @@ static inline void pvc_carrier(int on, struct pvc_device *pvc)
 	}
 }
 
-
 static inline void delete_unused_pvcs(hdlc_device *hdlc)
 {
 	struct pvc_device **pvc_p = &state(hdlc)->first_pvc;
@@ -260,7 +248,6 @@ static inline void delete_unused_pvcs(hdlc_device *hdlc)
 	}
 }
 
-
 static inline struct net_device **get_dev_p(struct pvc_device *pvc,
 					    int type)
 {
@@ -270,7 +257,6 @@ static inline struct net_device **get_dev_p(struct pvc_device *pvc,
 		return &pvc->main;
 }
 
-
 static int fr_hard_header(struct sk_buff *skb, u16 dlci)
 {
 	if (!skb->dev) { /* Control packets */
@@ -334,8 +320,6 @@ static int fr_hard_header(struct sk_buff *skb, u16 dlci)
 	return 0;
 }
 
-
-
 static int pvc_open(struct net_device *dev)
 {
 	struct pvc_device *pvc = dev->ml_priv;
@@ -354,8 +338,6 @@ static int pvc_open(struct net_device *dev)
 	return 0;
 }
 
-
-
 static int pvc_close(struct net_device *dev)
 {
 	struct pvc_device *pvc = dev->ml_priv;
@@ -373,8 +355,6 @@ static int pvc_close(struct net_device *dev)
 	return 0;
 }
 
-
-
 static int pvc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct pvc_device *pvc = dev->ml_priv;
@@ -465,15 +445,12 @@ static inline void fr_log_dlci_active(struct pvc_device *pvc)
 		    pvc->state.active ? "active" : "inactive");
 }
 
-
-
 static inline u8 fr_lmi_nextseq(u8 x)
 {
 	x++;
 	return x ? x : 1;
 }
 
-
 static void fr_lmi_send(struct net_device *dev, int fullrep)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -569,8 +546,6 @@ static void fr_lmi_send(struct net_device *dev, int fullrep)
 	dev_queue_xmit(skb);
 }
 
-
-
 static void fr_set_link_state(int reliable, struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -603,7 +578,6 @@ static void fr_set_link_state(int reliable, struct net_device *dev)
 	}
 }
 
-
 static void fr_timer(struct timer_list *t)
 {
 	struct frad_state *st = from_timer(st, t, timer);
@@ -655,7 +629,6 @@ static void fr_timer(struct timer_list *t)
 	add_timer(&state(hdlc)->timer);
 }
 
-
 static int fr_lmi_recv(struct net_device *dev, struct sk_buff *skb)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -962,7 +935,6 @@ static int fr_rx(struct sk_buff *skb)
 		pvc->state.becn ^= 1;
 	}
 
-
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL) {
 		frad->stats.rx_dropped++;
 		return NET_RX_DROP;
@@ -1018,8 +990,6 @@ static int fr_rx(struct sk_buff *skb)
 	return NET_RX_DROP;
 }
 
-
-
 static void fr_start(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -1044,7 +1014,6 @@ static void fr_start(struct net_device *dev)
 		fr_set_link_state(1, dev);
 }
 
-
 static void fr_stop(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -1056,7 +1025,6 @@ static void fr_stop(struct net_device *dev)
 	fr_set_link_state(0, dev);
 }
 
-
 static void fr_close(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -1071,7 +1039,6 @@ static void fr_close(struct net_device *dev)
 	}
 }
 
-
 static void pvc_setup(struct net_device *dev)
 {
 	dev->type = ARPHRD_DLCI;
@@ -1147,8 +1114,6 @@ static int fr_add_pvc(struct net_device *frad, unsigned int dlci, int type)
 	return 0;
 }
 
-
-
 static int fr_del_pvc(hdlc_device *hdlc, unsigned int dlci, int type)
 {
 	struct pvc_device *pvc;
@@ -1174,8 +1139,6 @@ static int fr_del_pvc(hdlc_device *hdlc, unsigned int dlci, int type)
 	return 0;
 }
 
-
-
 static void fr_destroy(struct net_device *frad)
 {
 	hdlc_device *hdlc = dev_to_hdlc(frad);
@@ -1198,7 +1161,6 @@ static void fr_destroy(struct net_device *frad)
 	}
 }
 
-
 static struct hdlc_proto proto = {
 	.close		= fr_close,
 	.start		= fr_start,
@@ -1209,7 +1171,6 @@ static struct hdlc_proto proto = {
 	.module		= THIS_MODULE,
 };
 
-
 static int fr_ioctl(struct net_device *dev, struct ifreq *ifr)
 {
 	fr_proto __user *fr_s = ifr->ifr_settings.ifs_ifsu.fr;
@@ -1309,20 +1270,17 @@ static int fr_ioctl(struct net_device *dev, struct ifreq *ifr)
 	return -EINVAL;
 }
 
-
 static int __init mod_init(void)
 {
 	register_hdlc_protocol(&proto);
 	return 0;
 }
 
-
 static void __exit mod_exit(void)
 {
 	unregister_hdlc_protocol(&proto);
 }
 
-
 module_init(mod_init);
 module_exit(mod_exit);
 
-- 
2.8.1

