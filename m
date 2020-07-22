Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C44229D24
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730292AbgGVQcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:39 -0400
Received: from mail.katalix.com ([3.9.82.81]:35450 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbgGVQcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 12:32:36 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id E941393AD9;
        Wed, 22 Jul 2020 17:32:34 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435555; bh=0Hkg8XywfMQCu50p823j+wlyPjI+J8tRneqJYcWWqY0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=2004/10]=20l2tp:=20cleanup=20won
         ky=20alignment=20of=20line-broken=20function=20calls|Date:=20Wed,=
         2022=20Jul=202020=2017:32:08=20+0100|Message-Id:=20<20200722163214
         .7920-5-tparkin@katalix.com>|In-Reply-To:=20<20200722163214.7920-1
         -tparkin@katalix.com>|References:=20<20200722163214.7920-1-tparkin
         @katalix.com>;
        b=vPGkLAjEkKiizyub9h9LURSEgbMcY1rJ0tcd0Xl7VvcWBaBgKhR3+e/mlE1vcAuFZ
         QSf2JjI342cFncMNWyfLGaUJQDdNgXmoGXCenWnaBuOwl0NDqHPqt3XkSNdaxRvefx
         hzNlwoORMxSRQEjlQ8GJIlmI74LLF/ii2rW/B4r/xECag7zjhRpCmi1FU0XfBS7cii
         uhEN9GdDV7rsYcxT9vTr/gx+POYy27PSZTe2TtLtxieyhT/KTJkjZZVz2Lq1PH8aQe
         ZfbU9UhE71EqjY4Z5YjkyseiQpxSg+GXaau0i7AEM/qz/GKPd/FjXMguNOnfZgpwyC
         m57emcyRzWAgA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 04/10] l2tp: cleanup wonky alignment of line-broken function calls
Date:   Wed, 22 Jul 2020 17:32:08 +0100
Message-Id: <20200722163214.7920-5-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arguments should be aligned with the function call open parenthesis as
per checkpatch.  Tweak some function calls which were not aligned
correctly.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c    | 12 ++++++------
 net/l2tp/l2tp_debugfs.c |  2 +-
 net/l2tp/l2tp_ppp.c     |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index f5e314d8a02b..3162e395cd4a 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1285,10 +1285,10 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
  * exit hook.
  */
 static int l2tp_tunnel_sock_create(struct net *net,
-				u32 tunnel_id,
-				u32 peer_tunnel_id,
-				struct l2tp_tunnel_cfg *cfg,
-				struct socket **sockp)
+				   u32 tunnel_id,
+				   u32 peer_tunnel_id,
+				   struct l2tp_tunnel_cfg *cfg,
+				   struct socket **sockp)
 {
 	int err = -EINVAL;
 	struct socket *sock = NULL;
@@ -1333,7 +1333,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
 			struct sockaddr_l2tpip6 ip6_addr = {0};
 
 			err = sock_create_kern(net, AF_INET6, SOCK_DGRAM,
-					  IPPROTO_L2TP, &sock);
+					       IPPROTO_L2TP, &sock);
 			if (err < 0)
 				goto out;
 
@@ -1361,7 +1361,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
 			struct sockaddr_l2tpip ip_addr = {0};
 
 			err = sock_create_kern(net, AF_INET, SOCK_DGRAM,
-					  IPPROTO_L2TP, &sock);
+					       IPPROTO_L2TP, &sock);
 			if (err < 0)
 				goto out;
 
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 93181133e155..bea89c383b7d 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -145,7 +145,7 @@ static void l2tp_dfs_seq_tunnel_show(struct seq_file *m, void *v)
 			const struct ipv6_pinfo *np = inet6_sk(tunnel->sock);
 
 			seq_printf(m, " from %pI6c to %pI6c\n",
-				&np->saddr, &tunnel->sock->sk_v6_daddr);
+				   &np->saddr, &tunnel->sock->sk_v6_daddr);
 		} else
 #endif
 		seq_printf(m, " from %pI4 to %pI4\n",
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 3fed922addb5..f894dc275393 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1638,7 +1638,7 @@ static __net_init int pppol2tp_init_net(struct net *net)
 	int err = 0;
 
 	pde = proc_create_net("pppol2tp", 0444, net->proc_net,
-			&pppol2tp_seq_ops, sizeof(struct pppol2tp_seq_data));
+			      &pppol2tp_seq_ops, sizeof(struct pppol2tp_seq_data));
 	if (!pde) {
 		err = -ENOMEM;
 		goto out;
-- 
2.17.1

