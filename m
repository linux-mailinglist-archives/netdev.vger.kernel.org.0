Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3472735CD70
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344110AbhDLQhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:37:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243545AbhDLQdG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:33:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F5CC613C3;
        Mon, 12 Apr 2021 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244787;
        bh=PbQbxu9mBVQi3OCpwHiD+EHOZZrGM128shVGekisZQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDeqxBVPPjsravnu7C94UGY815ZNPRbV1yN8ctU7pTDyjvQkgrDNR2V3SnBcQ5qF5
         7c+hjqX3+z2pZyJ1lLcI5oQRskRcBxEqxFo8srqTTX2RHXwAj9hnflXFzH0XXCQkxY
         732oeiVGlSZuchg2rPwE23Bc9I8biAMdf24QTj4wgfmtO9Z3THS1AN9eYa2g0/Q3v5
         SNcsPoyx40iX3ZdFpTQTWdGLedYActhtFmc8YfxdvLM64wv91auJdsBVUMgIH3u++5
         dd000JXcrB1mJjd7EQ7M5Iqa4uXdTo7ZdDXpovOOHOrjeuOS08TbaPhdWpWivIn8ON
         XlIK0tJ/rKu5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 26/28] net: tipc: Fix spelling errors in net/tipc module
Date:   Mon, 12 Apr 2021 12:25:51 -0400
Message-Id: <20210412162553.315227-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162553.315227-1-sashal@kernel.org>
References: <20210412162553.315227-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit a79ace4b312953c5835fafb12adc3cb6878b26bd ]

These patches fix a series of spelling errors in net/tipc module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.h | 6 +++---
 net/tipc/net.c    | 2 +-
 net/tipc/node.c   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/tipc/bearer.h b/net/tipc/bearer.h
index 394290cbbb1d..00bf28a65057 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -149,9 +149,9 @@ struct tipc_media {
  * care of initializing all other fields.
  */
 struct tipc_bearer {
-	void __rcu *media_ptr;			/* initalized by media */
-	u32 mtu;				/* initalized by media */
-	struct tipc_media_addr addr;		/* initalized by media */
+	void __rcu *media_ptr;			/* initialized by media */
+	u32 mtu;				/* initialized by media */
+	struct tipc_media_addr addr;		/* initialized by media */
 	char name[TIPC_MAX_BEARER_NAME];
 	struct tipc_media *media;
 	struct tipc_media_addr bcast_addr;
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 2e2e938fe4b7..18bcf2393afe 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -89,7 +89,7 @@
  *     - A spin lock to protect the registry of kernel/driver users (reg.c)
  *     - A global spin_lock (tipc_port_lock), which only task is to ensure
  *       consistency where more than one port is involved in an operation,
- *       i.e., whe a port is part of a linked list of ports.
+ *       i.e., when a port is part of a linked list of ports.
  *       There are two such lists; 'port_list', which is used for management,
  *       and 'wait_list', which is used to queue ports during congestion.
  *
diff --git a/net/tipc/node.c b/net/tipc/node.c
index a188c2590137..201ef25fb30b 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1406,7 +1406,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 }
 
 /* tipc_node_xmit_skb(): send single buffer to destination
- * Buffers sent via this functon are generally TIPC_SYSTEM_IMPORTANCE
+ * Buffers sent via this function are generally TIPC_SYSTEM_IMPORTANCE
  * messages, which will not be rejected
  * The only exception is datagram messages rerouted after secondary
  * lookup, which are rare and safe to dispose of anyway.
-- 
2.30.2

