Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93413A9655
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 11:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhFPJjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 05:39:18 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4945 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232284AbhFPJjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 05:39:17 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4g476nj6z704l;
        Wed, 16 Jun 2021 17:33:59 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 16 Jun 2021 17:37:09 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 1/8] net: hdlc_ppp: remove redundant blank lines
Date:   Wed, 16 Jun 2021 17:33:50 +0800
Message-ID: <1623836037-26812-2-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
References: <1623836037-26812-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 drivers/net/wan/hdlc_ppp.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 261b53f..e25b2f0 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -58,7 +58,6 @@ struct cp_header {
 	__be16 len;
 };
 
-
 struct proto {
 	struct net_device *dev;
 	struct timer_list timer;
@@ -160,7 +159,6 @@ static __be16 ppp_type_trans(struct sk_buff *skb, struct net_device *dev)
 	}
 }
 
-
 static int ppp_hard_header(struct sk_buff *skb, struct net_device *dev,
 			   u16 type, const void *daddr, const void *saddr,
 			   unsigned int len)
@@ -193,7 +191,6 @@ static int ppp_hard_header(struct sk_buff *skb, struct net_device *dev,
 	return sizeof(struct hdlc_header);
 }
 
-
 static void ppp_tx_flush(void)
 {
 	struct sk_buff *skb;
@@ -256,7 +253,6 @@ static void ppp_tx_cp(struct net_device *dev, u16 pid, u8 code,
 	skb_queue_tail(&tx_queue, skb);
 }
 
-
 /* State transition table (compare STD-51)
    Events                                   Actions
    TO+  = Timeout with counter > 0          irc = Initialize-Restart-Count
@@ -294,7 +290,6 @@ static int cp_table[EVENTS][STATES] = {
 	{    0    ,      1      ,  1  ,    1    ,  1  ,    1    ,IRC|STR|2}, /* RXJ- */
 };
 
-
 /* SCA: RCR+ must supply id, len and data
    SCN: RCR- must supply code, id, len and data
    STA: RTR must supply id
@@ -369,7 +364,6 @@ static void ppp_cp_event(struct net_device *dev, u16 pid, u16 event, u8 code,
 #endif
 }
 
-
 static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 			    unsigned int req_len, const u8 *data)
 {
@@ -615,7 +609,6 @@ static void ppp_timer(struct timer_list *t)
 	ppp_tx_flush();
 }
 
-
 static void ppp_start(struct net_device *dev)
 {
 	struct ppp *ppp = get_ppp(dev);
@@ -707,7 +700,6 @@ static int ppp_ioctl(struct net_device *dev, struct ifreq *ifr)
 	return -EINVAL;
 }
 
-
 static int __init mod_init(void)
 {
 	skb_queue_head_init(&tx_queue);
@@ -720,7 +712,6 @@ static void __exit mod_exit(void)
 	unregister_hdlc_protocol(&proto);
 }
 
-
 module_init(mod_init);
 module_exit(mod_exit);
 
-- 
2.8.1

