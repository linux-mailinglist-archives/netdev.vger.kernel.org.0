Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F6D3AB568
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 16:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbhFQOI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 10:08:56 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:8261 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbhFQOIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 10:08:44 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4G5NyK5dVWz1BN5D;
        Thu, 17 Jun 2021 22:01:29 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 17 Jun 2021 22:06:32 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 17 Jun 2021 22:06:31 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH V2 net-next 3/6] net: hdlc_ppp: fix the code style issue about "foo* bar"
Date:   Thu, 17 Jun 2021 22:03:16 +0800
Message-ID: <1623938599-25981-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623938599-25981-1-git-send-email-huangguangbin2@huawei.com>
References: <1623938599-25981-1-git-send-email-huangguangbin2@huawei.com>
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

Fix the checkpatch error as "foo* bar" or "foo*bar" should be "foo *bar".

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc_ppp.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/hdlc_ppp.c b/drivers/net/wan/hdlc_ppp.c
index 32f01d7e12d4..861491206f12 100644
--- a/drivers/net/wan/hdlc_ppp.c
+++ b/drivers/net/wan/hdlc_ppp.c
@@ -102,12 +102,12 @@ static struct sk_buff_head tx_queue; /* used when holding the spin lock */
 
 static int ppp_ioctl(struct net_device *dev, struct ifreq *ifr);
 
-static inline struct ppp* get_ppp(struct net_device *dev)
+static inline struct ppp *get_ppp(struct net_device *dev)
 {
 	return (struct ppp *)dev_to_hdlc(dev)->state;
 }
 
-static inline struct proto* get_proto(struct net_device *dev, u16 pid)
+static inline struct proto *get_proto(struct net_device *dev, u16 pid)
 {
 	struct ppp *ppp = get_ppp(dev);
 
@@ -123,7 +123,7 @@ static inline struct proto* get_proto(struct net_device *dev, u16 pid)
 	}
 }
 
-static inline const char* proto_name(u16 pid)
+static inline const char *proto_name(u16 pid)
 {
 	switch (pid) {
 	case PID_LCP:
@@ -139,7 +139,7 @@ static inline const char* proto_name(u16 pid)
 
 static __be16 ppp_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
-	struct hdlc_header *data = (struct hdlc_header*)skb->data;
+	struct hdlc_header *data = (struct hdlc_header *)skb->data;
 
 	if (skb->len < sizeof(struct hdlc_header))
 		return htons(ETH_P_HDLC);
@@ -171,7 +171,7 @@ static int ppp_hard_header(struct sk_buff *skb, struct net_device *dev,
 #endif
 
 	skb_push(skb, sizeof(struct hdlc_header));
-	data = (struct hdlc_header*)skb->data;
+	data = (struct hdlc_header *)skb->data;
 
 	data->address = HDLC_ADDR_ALLSTATIONS;
 	data->control = HDLC_CTRL_UI;
@@ -432,7 +432,7 @@ static void ppp_cp_parse_cr(struct net_device *dev, u16 pid, u8 id,
 
 static int ppp_rx(struct sk_buff *skb)
 {
-	struct hdlc_header *hdr = (struct hdlc_header*)skb->data;
+	struct hdlc_header *hdr = (struct hdlc_header *)skb->data;
 	struct net_device *dev = skb->dev;
 	struct ppp *ppp = get_ppp(dev);
 	struct proto *proto;
@@ -490,7 +490,7 @@ static int ppp_rx(struct sk_buff *skb)
 	if (pid == PID_LCP)
 		switch (cp->code) {
 		case LCP_PROTO_REJ:
-			pid = ntohs(*(__be16*)skb->data);
+			pid = ntohs(*(__be16 *)skb->data);
 			if (pid == PID_LCP || pid == PID_IPCP ||
 			    pid == PID_IPV6CP)
 				ppp_cp_event(dev, pid, RXJ_BAD, 0, 0,
-- 
2.8.1

