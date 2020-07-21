Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9505228797
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730562AbgGURlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730560AbgGURlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:04 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 24364C0619E0
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:03 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 4073E93AC7;
        Tue, 21 Jul 2020 18:32:59 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352779; bh=IlM0jBgX+1jqedMleoIoHm9+7iluC8jfHFNoMST1cw0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2003/29]=20l2tp:=20add=20a=20blank=20line=20following=20declar
         ations|Date:=20Tue,=2021=20Jul=202020=2018:31:55=20+0100|Message-I
         d:=20<20200721173221.4681-4-tparkin@katalix.com>|In-Reply-To:=20<2
         0200721173221.4681-1-tparkin@katalix.com>|References:=20<202007211
         73221.4681-1-tparkin@katalix.com>;
        b=ZVzsfKzh/iy/rQ2oA6FDFgqssIzZelatzU8lT0/tltCRyTuXBTOlh1WbjMzVYR79F
         PjJPvAi1q5wxbLTYY9D18SoJFLYytQGqJe9hu+hIf5EiWPJuVjIkxF4BxvgMV25Jr6
         HmR7roUl6XmMK6CYsg+ZvIgXAW3FQLo83KpS9XBIqxuWG3rfZwSYIcj12vn2miZrqp
         54gCApV6OQskFQSQ5A2X+pm3daSEHSlwwZsmiaZBc2pDparuZmT0esJKxOUOm92Is8
         qxTu5zbp407zEocwouQcxvKjTsBOs8vjqN+RnpcySswK/FkG+QnX+/L13YzCKc7i4q
         p+vL3tPexBg/w==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 03/29] l2tp: add a blank line following declarations
Date:   Tue, 21 Jul 2020 18:31:55 +0100
Message-Id: <20200721173221.4681-4-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch likes an empty line following declarations, which gives a
visual prompt for where logic begins in a given block.

Add blank lines in l2tp code to adhere to this guideline.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c    | 2 ++
 net/l2tp/l2tp_ip.c      | 2 ++
 net/l2tp/l2tp_netlink.c | 2 ++
 net/l2tp/l2tp_ppp.c     | 3 +++
 4 files changed, 9 insertions(+)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 14f4ae6c5b0f..3308e84906ef 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -776,6 +776,7 @@ EXPORT_SYMBOL(l2tp_recv_common);
 static int l2tp_session_queue_purge(struct l2tp_session *session)
 {
 	struct sk_buff *skb = NULL;
+
 	BUG_ON(!session);
 	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
 	while ((skb = skb_dequeue(&session->reorder_q))) {
@@ -1592,6 +1593,7 @@ void __l2tp_session_unhash(struct l2tp_session *session)
 		/* For L2TPv3 we have a per-net hash: remove from there, too */
 		if (tunnel->version != L2TP_HDR_VER_2) {
 			struct l2tp_net *pn = l2tp_pernet(tunnel->l2tp_net);
+
 			spin_lock_bh(&pn->l2tp_session_hlist_lock);
 			hlist_del_init_rcu(&session->global_hlist);
 			spin_unlock_bh(&pn->l2tp_session_hlist_lock);
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 65cf5a1a1e08..70f9fdaf6c86 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -374,6 +374,7 @@ static int l2tp_ip_getname(struct socket *sock, struct sockaddr *uaddr,
 		lsa->l2tp_addr.s_addr = inet->inet_daddr;
 	} else {
 		__be32 addr = inet->inet_rcv_saddr;
+
 		if (!addr)
 			addr = inet->inet_saddr;
 		lsa->l2tp_conn_id = lsk->conn_id;
@@ -421,6 +422,7 @@ static int l2tp_ip_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	/* Get and verify the address. */
 	if (msg->msg_name) {
 		DECLARE_SOCKADDR(struct sockaddr_l2tpip *, lip, msg->msg_name);
+
 		rc = -EINVAL;
 		if (msg->msg_namelen < sizeof(*lip))
 			goto out;
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 7643378ebead..5b24efc0b04b 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -569,6 +569,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 
 		if (info->attrs[L2TP_ATTR_COOKIE]) {
 			u16 len = nla_len(info->attrs[L2TP_ATTR_COOKIE]);
+
 			if (len > 8) {
 				ret = -EINVAL;
 				goto out_tunnel;
@@ -578,6 +579,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 		}
 		if (info->attrs[L2TP_ATTR_PEER_COOKIE]) {
 			u16 len = nla_len(info->attrs[L2TP_ATTR_PEER_COOKIE]);
+
 			if (len > 8) {
 				ret = -EINVAL;
 				goto out_tunnel;
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index e0dd56fef018..48fbaf5ee82c 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -927,6 +927,7 @@ static int pppol2tp_getname(struct socket *sock, struct sockaddr *uaddr,
 	inet = inet_sk(tunnel->sock);
 	if ((tunnel->version == 2) && (tunnel->sock->sk_family == AF_INET)) {
 		struct sockaddr_pppol2tp sp;
+
 		len = sizeof(sp);
 		memset(&sp, 0, len);
 		sp.sa_family	= AF_PPPOX;
@@ -983,6 +984,7 @@ static int pppol2tp_getname(struct socket *sock, struct sockaddr *uaddr,
 #endif
 	} else if (tunnel->version == 3) {
 		struct sockaddr_pppol2tpv3 sp;
+
 		len = sizeof(sp);
 		memset(&sp, 0, len);
 		sp.sa_family	= AF_PPPOX;
@@ -1550,6 +1552,7 @@ static void pppol2tp_seq_session_show(struct seq_file *m, void *v)
 
 	if (tunnel->sock) {
 		struct inet_sock *inet = inet_sk(tunnel->sock);
+
 		ip = ntohl(inet->inet_saddr);
 		port = ntohs(inet->inet_sport);
 	}
-- 
2.17.1

