Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393AE35CE38
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343672AbhDLQnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:43:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344125AbhDLQh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D188613F1;
        Mon, 12 Apr 2021 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244886;
        bh=GQLpvHkPEe3Xf9biLLTl2pQLYzB8Cy+G2ATPw1muCbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yw3pZ5jPKnYLLixzJtArEWhRjQxktI3NiEpCnpTAWaem6mwcBmW207Goo7RbrR24w
         CxDh2o+fT8yecaI43pdBnSE6CIfQqrpqMdniSlzqR72yXf79AXHWx7lTeLXQReJKzI
         AFMIcN9tf5i8GgPlESy35ho92rUg2msP0P6we/0UI48h14Ri8W2Tu3oyT8f7DR2MTV
         vjR+jNaaHqw1ZPhxfJizU10fl7X/uH0rC0uUqIvyK8lNvk8THKhD1ag+Fvqcaewoel
         MyURw3xvt5DJz7TWmx5hbS8MZMFRXovtOcjGqrOW2GGU0Y2xpx9qe7Qwk/l68CmR40
         o3OVsJn9veCGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.4 22/23] net: tipc: Fix spelling errors in net/tipc module
Date:   Mon, 12 Apr 2021 12:27:35 -0400
Message-Id: <20210412162736.316026-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
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
index 5f11e18b1fa1..1e180d512ef2 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -153,9 +153,9 @@ struct tipc_media {
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
index 2763bd369b79..f874f95b6b93 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -93,7 +93,7 @@ static const struct nla_policy tipc_nl_net_policy[TIPC_NLA_NET_MAX + 1] = {
  *     - A spin lock to protect the registry of kernel/driver users (reg.c)
  *     - A global spin_lock (tipc_port_lock), which only task is to ensure
  *       consistency where more than one port is involved in an operation,
- *       i.e., whe a port is part of a linked list of ports.
+ *       i.e., when a port is part of a linked list of ports.
  *       There are two such lists; 'port_list', which is used for management,
  *       and 'wait_list', which is used to queue ports during congestion.
  *
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 2df0b98d4a32..772794e5dd02 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1052,7 +1052,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 }
 
 /* tipc_node_xmit_skb(): send single buffer to destination
- * Buffers sent via this functon are generally TIPC_SYSTEM_IMPORTANCE
+ * Buffers sent via this function are generally TIPC_SYSTEM_IMPORTANCE
  * messages, which will not be rejected
  * The only exception is datagram messages rerouted after secondary
  * lookup, which are rare and safe to dispose of anyway.
-- 
2.30.2

