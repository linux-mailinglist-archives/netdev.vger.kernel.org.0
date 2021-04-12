Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB3A35CDAE
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244985AbhDLQh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:37276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343635AbhDLQfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:35:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0024E613D4;
        Mon, 12 Apr 2021 16:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244820;
        bh=DJEBpE1ca0ywSvC4rzlJRwpf+v5/MJ6CW/I0S7bGObc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nn04yHrWUTqhJtKLFZ6TA+27axjkv65CcPlH9PdYsjstMe1lZIU+4DtyPqQ1tbwdE
         F2Z/9s4mx6lVrBcwBgavhLg/tQiLxpiBRgZWCZpjaUttIiR9Go9ZTtiAcW8oLemJdF
         9jiB31GtLpImA5Rsqmpged5QeGUxHArWjDZex5I0EC6cWVX9hlyjsaHkYqkclPztEN
         lEllAn4Vd2606s3bZ2TJ+ZkihGAGi7+MxNeVFD5UsWLrwY9HVU1J3iVxJpr4kOSUEJ
         2E7z8DqEprsNpWRfw1HoPIrQRoXl5hhK15EQkBIhn9KJICyqAiiivXB5+fnpka4vtf
         5E9mtT5546BcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 23/25] net: tipc: Fix spelling errors in net/tipc module
Date:   Mon, 12 Apr 2021 12:26:28 -0400
Message-Id: <20210412162630.315526-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
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
index 42d6eeeb646d..1a207b2d6d5c 100644
--- a/net/tipc/bearer.h
+++ b/net/tipc/bearer.h
@@ -146,9 +146,9 @@ struct tipc_media {
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
index 719c5924b638..76a43ac45e31 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -88,7 +88,7 @@
  *     - A spin lock to protect the registry of kernel/driver users (reg.c)
  *     - A global spin_lock (tipc_port_lock), which only task is to ensure
  *       consistency where more than one port is involved in an operation,
- *       i.e., whe a port is part of a linked list of ports.
+ *       i.e., when a port is part of a linked list of ports.
  *       There are two such lists; 'port_list', which is used for management,
  *       and 'wait_list', which is used to queue ports during congestion.
  *
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 82f8f69f4d6b..1c8a9c29a6df 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1223,7 +1223,7 @@ int tipc_node_xmit(struct net *net, struct sk_buff_head *list,
 }
 
 /* tipc_node_xmit_skb(): send single buffer to destination
- * Buffers sent via this functon are generally TIPC_SYSTEM_IMPORTANCE
+ * Buffers sent via this function are generally TIPC_SYSTEM_IMPORTANCE
  * messages, which will not be rejected
  * The only exception is datagram messages rerouted after secondary
  * lookup, which are rare and safe to dispose of anyway.
-- 
2.30.2

