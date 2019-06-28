Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 532F459E69
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfF1PGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:06:24 -0400
Received: from sesbmg23.ericsson.net ([193.180.251.37]:43391 "EHLO
        sesbmg23.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbfF1PGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:06:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; d=ericsson.com; s=mailgw201801; c=relaxed/relaxed;
        q=dns/txt; i=@ericsson.com; t=1561734381; x=1564326381;
        h=From:Sender:Reply-To:Subject:Date:Message-ID:To:CC:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RBdhbqwDBi8SHuR63H43n5YYTE3NygS3UXxU+S0KB7s=;
        b=cO67tS/rfPGznvnVYlbF2AVsqZMw1EXWnbF5zcyIwAfEf1oAZW1ZOdtdQIOJdrrc
        hRF2yQXlOhMu0hh2FUoCz1fsYtzOP77loW9Dqm1qMxuvNi+bcrdbrc5/NAkZZSlt
        dnD29LYD+aJ+YXSOAzLn9LPinrLyr6UZdj8LEX6FpRM=;
X-AuditID: c1b4fb25-3b1ff700000029f0-5c-5d162cedd4f3
Received: from ESESBMB505.ericsson.se (Unknown_Domain [153.88.183.118])
        by sesbmg23.ericsson.net (Symantec Mail Security) with SMTP id F8.BD.10736.DEC261D5; Fri, 28 Jun 2019 17:06:21 +0200 (CEST)
Received: from ESESSMR506.ericsson.se (153.88.183.128) by
 ESESBMB505.ericsson.se (153.88.183.188) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 28 Jun 2019 17:06:21 +0200
Received: from ESESBMB503.ericsson.se (153.88.183.170) by
 ESESSMR506.ericsson.se (153.88.183.128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Fri, 28 Jun 2019 17:06:20 +0200
Received: from tipsy.lab.linux.ericsson.se (153.88.183.153) by
 smtp.internal.ericsson.com (153.88.183.186) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Fri, 28 Jun 2019 17:06:20 +0200
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     <gordan.mihaljevic@dektech.com.au>, <tung.q.nguyen@dektech.com.au>,
        <hoang.h.le@dektech.com.au>, <jon.maloy@ericsson.com>,
        <canh.d.luu@dektech.com.au>, <ying.xue@windriver.com>,
        <tipc-discussion@lists.sourceforge.net>
Subject: [net-next  1/1] tipc: embed jiffies in macro TIPC_BC_RETR_LIM
Date:   Fri, 28 Jun 2019 17:06:20 +0200
Message-ID: <1561734380-26868-1-git-send-email-jon.maloy@ericsson.com>
X-Mailer: git-send-email 2.1.4
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsUyM2J7me5bHbFYgz3b5S1uNPQwW8w538Ji
        sWL3JFaLt69msVscWyBmseV8lsWV9rPsFo+vX2d24PDYsvImk8e7K2weuxd8ZvL4vEnOY/2W
        rUwBrFFcNimpOZllqUX6dglcGUdWtzAWzOWvmPz9PEsD4x6eLkZODgkBE4m+zZPZQGwhgaOM
        Egc38HcxcgHZ3xglVnxfygyRAHKOTqmDsC8wSrxfFQ1iswloSLyc1sEIYosIGEu8WtnJBNLM
        LPCYUeLL/VVgU4UF3CTuf78GZrMIqErceb4RzOYFih949IAV4go5ifPHf0ItU5aY+2EaE0SN
        oMTJmU9YQGxmAQmJgy9eME9g5J+FJDULSWoBI9MqRtHi1OKk3HQjY73Uoszk4uL8PL281JJN
        jMDQPbjlt+oOxstvHA8xCnAwKvHwLv4qGivEmlhWXJl7iFGCg1lJhFfynEisEG9KYmVValF+
        fFFpTmrxIUZpDhYlcd713v9ihATSE0tSs1NTC1KLYLJMHJxSDYz58UHbf+o0Twn/OTHmBFO0
        VUtk5cffa141Z3+1PHjZfW3QFlFR84IurYkK84T/Hm80WGYpIX5sy2SZ2ZX8nrqps63aN4v1
        rlsQvLX55IaDs3boeNz+ETrf9+XMDaaeCtG7zv73O3T7RVUT7xrebzUm744otE0uX+mewvfL
        dP/cSkGH2Z+W6CkpsRRnJBpqMRcVJwIAGB+H0VkCAAA=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro TIPC_BC_RETR_LIM is always used in combination with 'jiffies',
so we can just as well perform the addition in the macro itself. This
way, we get a few shorter code lines and one less line break.

Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
---
 net/tipc/link.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index f8bf63b..66d3a07 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -207,7 +207,7 @@ enum {
 	BC_NACK_SND_SUPPRESS,
 };
 
-#define TIPC_BC_RETR_LIM msecs_to_jiffies(10)   /* [ms] */
+#define TIPC_BC_RETR_LIM  (jiffies + msecs_to_jiffies(10))
 #define TIPC_UC_RETR_TIME (jiffies + msecs_to_jiffies(1))
 
 /*
@@ -976,8 +976,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 			__skb_queue_tail(transmq, skb);
 			/* next retransmit attempt */
 			if (link_is_bc_sndlink(l))
-				TIPC_SKB_CB(skb)->nxt_retr =
-					jiffies + TIPC_BC_RETR_LIM;
+				TIPC_SKB_CB(skb)->nxt_retr = TIPC_BC_RETR_LIM;
 			__skb_queue_tail(xmitq, _skb);
 			TIPC_SKB_CB(skb)->ackers = l->ackers;
 			l->rcv_unacked = 0;
@@ -1027,7 +1026,7 @@ static void tipc_link_advance_backlog(struct tipc_link *l,
 		__skb_queue_tail(&l->transmq, skb);
 		/* next retransmit attempt */
 		if (link_is_bc_sndlink(l))
-			TIPC_SKB_CB(skb)->nxt_retr = jiffies + TIPC_BC_RETR_LIM;
+			TIPC_SKB_CB(skb)->nxt_retr = TIPC_BC_RETR_LIM;
 
 		__skb_queue_tail(xmitq, _skb);
 		TIPC_SKB_CB(skb)->ackers = l->ackers;
@@ -1123,7 +1122,7 @@ static int tipc_link_bc_retrans(struct tipc_link *l, struct tipc_link *r,
 		if (link_is_bc_sndlink(l)) {
 			if (time_before(jiffies, TIPC_SKB_CB(skb)->nxt_retr))
 				continue;
-			TIPC_SKB_CB(skb)->nxt_retr = jiffies + TIPC_BC_RETR_LIM;
+			TIPC_SKB_CB(skb)->nxt_retr = TIPC_BC_RETR_LIM;
 		}
 		_skb = __pskb_copy(skb, LL_MAX_HEADER + MIN_H_SIZE, GFP_ATOMIC);
 		if (!_skb)
-- 
2.1.4

