Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5E22878E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgGURlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729975AbgGURlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:05 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2E66C0619E3
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:03 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 86A2A915B2;
        Tue, 21 Jul 2020 18:32:58 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352778; bh=Ashz8N2WZkfXyiTqNGiRuZ/iCf2nX79+PPANrL560wE=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2002/29]=20l2tp:=20tweak=20comment=20style=20for=20consistency
         |Date:=20Tue,=2021=20Jul=202020=2018:31:54=20+0100|Message-Id:=20<
         20200721173221.4681-3-tparkin@katalix.com>|In-Reply-To:=20<2020072
         1173221.4681-1-tparkin@katalix.com>|References:=20<20200721173221.
         4681-1-tparkin@katalix.com>;
        b=iUB+xcdjbO+qpolS9n2BNP/LRKFr+nE+0/yYm8BgZM6jIQ8rqbKwWMRxgGtiN/OJR
         rC1hu2bt2Wt5H7L9tjzsgZzRM6JFZ3R2aEA0+08nNxL5zL7KCuFBngrjAbkG1pjibb
         nZiUyJx5k/yZ9WXD7FirMgn4RE5Mo84Ao5mqjWMMA7toqxt+/hj5RxmU+gaWqpfrbe
         mquFQzHoYkDT4QYQ8iLmUmmlR1eH0o6dHsuh+q2YoNcfaGREkCznD/25KYwoh7CLK+
         Fh8KeYSuri2ymFtYJgiHPLlFtFe7tT/wWvxmoIvAzM6tsGHIt+IeYzqlrZ+UK58pVu
         wUBPJd46WqRow==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 02/29] l2tp: tweak comment style for consistency
Date:   Tue, 21 Jul 2020 18:31:54 +0100
Message-Id: <20200721173221.4681-3-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify some l2tp comments to better adhere to kernel coding style.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c    |  5 ++-
 net/l2tp/l2tp_core.h    | 76 +++++++++++++++++------------------------
 net/l2tp/l2tp_debugfs.c |  3 +-
 net/l2tp/l2tp_eth.c     |  3 +-
 net/l2tp/l2tp_ip.c      |  3 +-
 net/l2tp/l2tp_ip6.c     | 15 ++++----
 net/l2tp/l2tp_netlink.c |  3 +-
 net/l2tp/l2tp_ppp.c     |  3 +-
 8 files changed, 44 insertions(+), 67 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 4031149b7d44..14f4ae6c5b0f 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * L2TP core.
+/* L2TP core.
  *
  * Copyright (c) 2008,2009,2010 Katalix Systems Ltd
  *
@@ -1603,7 +1602,7 @@ void __l2tp_session_unhash(struct l2tp_session *session)
 EXPORT_SYMBOL_GPL(__l2tp_session_unhash);
 
 /* This function is used by the netlink SESSION_DELETE command and by
-   pseudowire modules.
+ * pseudowire modules.
  */
 int l2tp_session_delete(struct l2tp_session *session)
 {
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 10cf7c3dcbb3..3ebb701eebbf 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -1,6 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * L2TP internal definitions.
+/* L2TP internal definitions.
  *
  * Copyright (c) 2008,2009 Katalix Systems Ltd
  */
@@ -49,32 +48,26 @@ struct l2tp_tunnel;
  */
 struct l2tp_session_cfg {
 	enum l2tp_pwtype	pw_type;
-	unsigned int		recv_seq:1;	/* expect receive packets with
-						 * sequence numbers? */
-	unsigned int		send_seq:1;	/* send packets with sequence
-						 * numbers? */
-	unsigned int		lns_mode:1;	/* behave as LNS? LAC enables
-						 * sequence numbers under
-						 * control of LNS. */
-	int			debug;		/* bitmask of debug message
-						 * categories */
+	unsigned int		recv_seq:1;	/* expect receive packets with sequence numbers? */
+	unsigned int		send_seq:1;	/* send packets with sequence numbers? */
+	unsigned int		lns_mode:1;	/* behave as LNS?
+						 * LAC enables sequence numbers under LNS control.
+						 */
+	int			debug;		/* bitmask of debug message categories */
 	u16			l2specific_type; /* Layer 2 specific type */
 	u8			cookie[8];	/* optional cookie */
 	int			cookie_len;	/* 0, 4 or 8 bytes */
 	u8			peer_cookie[8];	/* peer's cookie */
 	int			peer_cookie_len; /* 0, 4 or 8 bytes */
-	int			reorder_timeout; /* configured reorder timeout
-						  * (in jiffies) */
+	int			reorder_timeout; /* configured reorder timeout (in jiffies) */
 	char			*ifname;
 };
 
 struct l2tp_session {
-	int			magic;		/* should be
-						 * L2TP_SESSION_MAGIC */
+	int			magic;		/* should be L2TP_SESSION_MAGIC */
 	long			dead;
 
-	struct l2tp_tunnel	*tunnel;	/* back pointer to tunnel
-						 * context */
+	struct l2tp_tunnel	*tunnel;	/* back pointer to tunnel context */
 	u32			session_id;
 	u32			peer_session_id;
 	u8			cookie[8];
@@ -89,42 +82,37 @@ struct l2tp_session {
 	u32			nr_max;		/* max NR. Depends on tunnel */
 	u32			nr_window_size;	/* NR window size */
 	u32			nr_oos;		/* NR of last OOS packet */
-	int			nr_oos_count;	/* For OOS recovery */
+	int			nr_oos_count;	/* for OOS recovery */
 	int			nr_oos_count_max;
-	struct hlist_node	hlist;		/* Hash list node */
+	struct hlist_node	hlist;		/* hash list node */
 	refcount_t		ref_count;
 
 	char			name[32];	/* for logging */
 	char			ifname[IFNAMSIZ];
-	unsigned int		recv_seq:1;	/* expect receive packets with
-						 * sequence numbers? */
-	unsigned int		send_seq:1;	/* send packets with sequence
-						 * numbers? */
-	unsigned int		lns_mode:1;	/* behave as LNS? LAC enables
-						 * sequence numbers under
-						 * control of LNS. */
-	int			debug;		/* bitmask of debug message
-						 * categories */
-	int			reorder_timeout; /* configured reorder timeout
-						  * (in jiffies) */
+	unsigned int		recv_seq:1;	/* expect receive packets with sequence numbers? */
+	unsigned int		send_seq:1;	/* send packets with sequence numbers? */
+	unsigned int		lns_mode:1;	/* behave as LNS?
+						 * LAC enables sequence numbers under LNS control.
+						 */
+	int			debug;		/* bitmask of debug message categories */
+	int			reorder_timeout; /* configured reorder timeout (in jiffies) */
 	int			reorder_skip;	/* set if skip to next nr */
 	enum l2tp_pwtype	pwtype;
 	struct l2tp_stats	stats;
-	struct hlist_node	global_hlist;	/* Global hash list node */
+	struct hlist_node	global_hlist;	/* global hash list node */
 
 	int (*build_header)(struct l2tp_session *session, void *buf);
 	void (*recv_skb)(struct l2tp_session *session, struct sk_buff *skb, int data_len);
 	void (*session_close)(struct l2tp_session *session);
 	void (*show)(struct seq_file *m, void *priv);
-	u8			priv[];	/* private data */
+	u8			priv[];		/* private data */
 };
 
 /* Describes the tunnel. It contains info to track all the associated
  * sessions so incoming packets can be sorted out
  */
 struct l2tp_tunnel_cfg {
-	int			debug;		/* bitmask of debug message
-						 * categories */
+	int			debug;		/* bitmask of debug message categories */
 	enum l2tp_encap_type	encap;
 
 	/* Used only for kernel-created sockets */
@@ -148,31 +136,29 @@ struct l2tp_tunnel {
 
 	struct rcu_head rcu;
 	rwlock_t		hlist_lock;	/* protect session_hlist */
-	bool			acpt_newsess;	/* Indicates whether this
-						 * tunnel accepts new sessions.
-						 * Protected by hlist_lock.
+	bool			acpt_newsess;	/* indicates whether this tunnel accepts
+						 * new sessions. Protected by hlist_lock.
 						 */
 	struct hlist_head	session_hlist[L2TP_HASH_SIZE];
-						/* hashed list of sessions,
-						 * hashed by id */
+						/* hashed list of sessions, hashed by id */
 	u32			tunnel_id;
 	u32			peer_tunnel_id;
 	int			version;	/* 2=>L2TPv2, 3=>L2TPv3 */
 
 	char			name[20];	/* for logging */
-	int			debug;		/* bitmask of debug message
-						 * categories */
+	int			debug;		/* bitmask of debug message categories */
 	enum l2tp_encap_type	encap;
 	struct l2tp_stats	stats;
 
-	struct list_head	list;		/* Keep a list of all tunnels */
+	struct list_head	list;		/* list node on per-namespace list of tunnels */
 	struct net		*l2tp_net;	/* the net we belong to */
 
 	refcount_t		ref_count;
 	void (*old_sk_destruct)(struct sock *);
-	struct sock		*sock;		/* Parent socket */
-	int			fd;		/* Parent fd, if tunnel socket
-						 * was created by userspace */
+	struct sock		*sock;		/* parent socket */
+	int			fd;		/* parent fd, if tunnel socket was created
+						 * by userspace
+						 */
 
 	struct work_struct	del_work;
 };
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 35bb4f3bdbe0..221b86e1ba7c 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * L2TP subsystem debugfs
+/* L2TP subsystem debugfs
  *
  * Copyright (c) 2010 Katalix Systems Ltd
  */
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 86e111d7d73c..87e4cebc7f57 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * L2TPv3 ethernet pseudowire driver
+/* L2TPv3 ethernet pseudowire driver
  *
  * Copyright (c) 2008,2009,2010 Katalix Systems Ltd
  */
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index c52eb2510ca4..65cf5a1a1e08 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * L2TPv3 IP encapsulation support
+/* L2TPv3 IP encapsulation support
  *
  * Copyright (c) 2008,2009,2010 Katalix Systems Ltd
  */
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index d17b9fe1180f..ca7696147c7e 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/*
- * L2TPv3 IP encapsulation support for IPv6
+/* L2TPv3 IP encapsulation support for IPv6
  *
  * Copyright (c) 2012 Katalix Systems Ltd
  */
@@ -38,7 +37,8 @@ struct l2tp_ip6_sock {
 	u32			peer_conn_id;
 
 	/* ipv6_pinfo has to be the last member of l2tp_ip6_sock, see
-	   inet6_sk_generic */
+	 * inet6_sk_generic
+	 */
 	struct ipv6_pinfo	inet6;
 };
 
@@ -519,7 +519,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	int err;
 
 	/* Rough check on arithmetic overflow,
-	   better check is made in ip6_append_data().
+	 * better check is made in ip6_append_data().
 	 */
 	if (len > INT_MAX)
 		return -EMSGSIZE;
@@ -528,9 +528,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	/*
-	 *	Get and verify the address.
-	 */
+	/* Get and verify the address */
 	memset(&fl6, 0, sizeof(fl6));
 
 	fl6.flowi6_mark = sk->sk_mark;
@@ -555,8 +553,7 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			}
 		}
 
-		/*
-		 * Otherwise it will be difficult to maintain
+		/* Otherwise it will be difficult to maintain
 		 * sk->sk_dst_cache.
 		 */
 		if (sk->sk_state == TCP_ESTABLISHED &&
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index ebb381c3f1b9..7643378ebead 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -1,6 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/*
- * L2TP netlink layer, for management
+/* L2TP netlink layer, for management
  *
  * Copyright (c) 2008,2009,2010 Katalix Systems Ltd
  *
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index a0bd39f0d5fe..e0dd56fef018 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -117,8 +117,7 @@ struct pppol2tp_session {
 	int			owner;		/* pid that opened the socket */
 
 	struct mutex		sk_lock;	/* Protects .sk */
-	struct sock __rcu	*sk;		/* Pointer to the session
-						 * PPPoX socket */
+	struct sock __rcu	*sk;		/* Pointer to the session PPPoX socket */
 	struct sock		*__sk;		/* Copy of .sk, for cleanup */
 	struct rcu_head		rcu;		/* For asynchronous release */
 };
-- 
2.17.1

