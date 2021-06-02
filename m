Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCF8398793
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhFBLG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:06:28 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:4283 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhFBLGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:06:10 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fw5dP5Xf2z1BFhR;
        Wed,  2 Jun 2021 18:59:37 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 2 Jun 2021 19:04:20 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 19:04:20 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/6] net: hdlc_cisco: remove redundant blank lines
Date:   Wed, 2 Jun 2021 19:01:11 +0800
Message-ID: <1622631676-34037-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622631676-34037-1-git-send-email-huangguangbin2@huawei.com>
References: <1622631676-34037-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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
 drivers/net/wan/hdlc_cisco.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/net/wan/hdlc_cisco.c b/drivers/net/wan/hdlc_cisco.c
index cb5898f..5fc0f8d 100644
--- a/drivers/net/wan/hdlc_cisco.c
+++ b/drivers/net/wan/hdlc_cisco.c
@@ -28,14 +28,12 @@
 #define CISCO_ADDR_REPLY	1	/* Cisco address reply */
 #define CISCO_KEEPALIVE_REQ	2	/* Cisco keepalive request */
 
-
 struct hdlc_header {
 	u8 address;
 	u8 control;
 	__be16 protocol;
 }__packed;
 
-
 struct cisco_packet {
 	__be32 type;		/* code */
 	__be32 par1;
@@ -46,7 +44,6 @@ struct cisco_packet {
 #define	CISCO_PACKET_LEN	18
 #define	CISCO_BIG_PACKET_LEN	20
 
-
 struct cisco_state {
 	cisco_proto settings;
 
@@ -59,16 +56,13 @@ struct cisco_state {
 	u32 rxseq; /* RX sequence number */
 };
 
-
 static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr);
 
-
 static inline struct cisco_state* state(hdlc_device *hdlc)
 {
 	return (struct cisco_state *)hdlc->state;
 }
 
-
 static int cisco_hard_header(struct sk_buff *skb, struct net_device *dev,
 			     u16 type, const void *daddr, const void *saddr,
 			     unsigned int len)
@@ -90,8 +84,6 @@ static int cisco_hard_header(struct sk_buff *skb, struct net_device *dev,
 	return sizeof(struct hdlc_header);
 }
 
-
-
 static void cisco_keepalive_send(struct net_device *dev, u32 type,
 				 __be32 par1, __be32 par2)
 {
@@ -124,8 +116,6 @@ static void cisco_keepalive_send(struct net_device *dev, u32 type,
 	dev_queue_xmit(skb);
 }
 
-
-
 static __be16 cisco_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
 	struct hdlc_header *data = (struct hdlc_header*)skb->data;
@@ -148,7 +138,6 @@ static __be16 cisco_type_trans(struct sk_buff *skb, struct net_device *dev)
 	}
 }
 
-
 static int cisco_rx(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
@@ -253,8 +242,6 @@ static int cisco_rx(struct sk_buff *skb)
 	return NET_RX_DROP;
 }
 
-
-
 static void cisco_timer(struct timer_list *t)
 {
 	struct cisco_state *st = from_timer(st, t, timer);
@@ -276,8 +263,6 @@ static void cisco_timer(struct timer_list *t)
 	add_timer(&st->timer);
 }
 
-
-
 static void cisco_start(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -294,8 +279,6 @@ static void cisco_start(struct net_device *dev)
 	add_timer(&st->timer);
 }
 
-
-
 static void cisco_stop(struct net_device *dev)
 {
 	hdlc_device *hdlc = dev_to_hdlc(dev);
@@ -310,7 +293,6 @@ static void cisco_stop(struct net_device *dev)
 	spin_unlock_irqrestore(&st->lock, flags);
 }
 
-
 static struct hdlc_proto proto = {
 	.start		= cisco_start,
 	.stop		= cisco_stop,
@@ -381,21 +363,17 @@ static int cisco_ioctl(struct net_device *dev, struct ifreq *ifr)
 	return -EINVAL;
 }
 
-
 static int __init mod_init(void)
 {
 	register_hdlc_protocol(&proto);
 	return 0;
 }
 
-
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

