Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58D422879B
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgGURlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730540AbgGURlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:03 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6C39C0619DF
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:02 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 7188793AD1;
        Tue, 21 Jul 2020 18:32:59 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352779; bh=GmQ3t1ZoIQz3ftVyUWAnBVs2lUQWSqcubosSsOp0vFc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2004/29]=20l2tp:=20cleanup=20excessive=20blank=20lines|Date:=2
         0Tue,=2021=20Jul=202020=2018:31:56=20+0100|Message-Id:=20<20200721
         173221.4681-5-tparkin@katalix.com>|In-Reply-To:=20<20200721173221.
         4681-1-tparkin@katalix.com>|References:=20<20200721173221.4681-1-t
         parkin@katalix.com>;
        b=QkDhFW7rwyKnJF3Rw4bfFVzN+npwRwU6xYZnV5Y9NdkeUCmhWV3pWY/i6Lm6MN19u
         +nSu0ywegqAuIE8utDCxyrGPoDwaHNjsK3ELyOjHZ0tp2ay9elTzbcua4f86H+1CYw
         Q0sYdcfXyYMQvY9FHr3+c0xWzOPhgBr9hNJre5AT6c+SQ3pNTrnyL7fyP7f5OCnGXo
         bkGJ2kXX9wDIKvm1YZZeo5m8ZiFulfrltJstU9x7HwINrLu05gRueZpClA7YikOyWw
         GnCKFfxWYQhv+9qAcNLVuq/y8qlcZbad2f691z0XZW1JplSbX7K67QPok3A8hHooAx
         PwWQtsTGVJ6fA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 04/29] l2tp: cleanup excessive blank lines
Date:   Tue, 21 Jul 2020 18:31:56 +0100
Message-Id: <20200721173221.4681-5-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch doesn't like multiple blank lines, or trailing blank lines at
the end of functions.  They serve no useful purpose, so remove these from
the l2tp code.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c    | 2 --
 net/l2tp/l2tp_debugfs.c | 2 --
 net/l2tp/l2tp_eth.c     | 3 ---
 net/l2tp/l2tp_netlink.c | 1 -
 4 files changed, 8 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 3308e84906ef..70891be75f77 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -133,7 +133,6 @@ static inline struct hlist_head *
 l2tp_session_id_hash_2(struct l2tp_net *pn, u32 session_id)
 {
 	return &pn->l2tp_session_hlist[hash_32(session_id, L2TP_HASH_BITS_2)];
-
 }
 
 /* Session hash list.
@@ -1637,7 +1636,6 @@ void l2tp_session_set_header_len(struct l2tp_session *session, int version)
 		if (session->tunnel->encap == L2TP_ENCAPTYPE_UDP)
 			session->hdr_len += 4;
 	}
-
 }
 EXPORT_SYMBOL_GPL(l2tp_session_set_header_len);
 
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 221b86e1ba7c..93181133e155 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -62,7 +62,6 @@ static void l2tp_dfs_next_session(struct l2tp_dfs_seq_data *pd)
 		pd->session_idx = 0;
 		l2tp_dfs_next_tunnel(pd);
 	}
-
 }
 
 static void *l2tp_dfs_seq_start(struct seq_file *m, loff_t *offs)
@@ -89,7 +88,6 @@ static void *l2tp_dfs_seq_start(struct seq_file *m, loff_t *offs)
 	return pd;
 }
 
-
 static void *l2tp_dfs_seq_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	(*pos)++;
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 87e4cebc7f57..7ed2b4eced94 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -50,7 +50,6 @@ struct l2tp_eth_sess {
 	struct net_device __rcu *dev;
 };
 
-
 static int l2tp_eth_dev_init(struct net_device *dev)
 {
 	eth_hw_addr_random(dev);
@@ -346,13 +345,11 @@ static int l2tp_eth_create(struct net *net, struct l2tp_tunnel *tunnel,
 	return rc;
 }
 
-
 static const struct l2tp_nl_cmd_ops l2tp_eth_nl_cmd_ops = {
 	.session_create	= l2tp_eth_create,
 	.session_delete	= l2tp_session_delete,
 };
 
-
 static int __init l2tp_eth_init(void)
 {
 	int err = 0;
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 5b24efc0b04b..3120f8dcc56a 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -26,7 +26,6 @@
 
 #include "l2tp_core.h"
 
-
 static struct genl_family l2tp_nl_family;
 
 static const struct genl_multicast_group l2tp_multicast_group[] = {
-- 
2.17.1

