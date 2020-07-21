Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D8A722879E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730776AbgGURl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730479AbgGURlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:03 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE9ADC0619DE
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:02 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id E2EAA93AE9;
        Tue, 21 Jul 2020 18:32:59 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352780; bh=pbshDHzSUZSgk7brdSDKlOiuAf+T8GM1kGNfTlCptcY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2006/29]=20l2tp:=20cleanup=20wonky=20alignment=20of=20line-bro
         ken=20function=20calls|Date:=20Tue,=2021=20Jul=202020=2018:31:58=2
         0+0100|Message-Id:=20<20200721173221.4681-7-tparkin@katalix.com>|I
         n-Reply-To:=20<20200721173221.4681-1-tparkin@katalix.com>|Referenc
         es:=20<20200721173221.4681-1-tparkin@katalix.com>;
        b=SaHIsUh4sDMTIOtm64w/3ZqaW3B8WUTzStuvQQdHV0SEP+7M6x+6o5f1bJj37S+6R
         5RYKC+vawyTwgSu8hptRut/rxdank3jUZ5xFZNCYtfKSZ3bpVFPsE2esD6JwVLbz+q
         CXLcsKvUYi4YZU7QgsZSRkdaiqDb6PWSvAfSuYh5GHEYgcf9NTFKsMqGDwA1LHQP1L
         hVIhK2vtR/9cKSrnTvRYdj778xa5BnG0hOTkA079cjQWGkcTfmi9QGbQxBxG/pufP8
         5SaAwI8t+isW0TTMSspmx++XpYDLQBnSNe7b+c0oEgv+NPN6NCC3Yh89VMJ4mrOBS9
         nxzFxyY2jdZrg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 06/29] l2tp: cleanup wonky alignment of line-broken function calls
Date:   Tue, 21 Jul 2020 18:31:58 +0100
Message-Id: <20200721173221.4681-7-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
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
index 70891be75f77..a206ba97328f 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1283,10 +1283,10 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
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
@@ -1331,7 +1331,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
 			struct sockaddr_l2tpip6 ip6_addr = {0};
 
 			err = sock_create_kern(net, AF_INET6, SOCK_DGRAM,
-					  IPPROTO_L2TP, &sock);
+					       IPPROTO_L2TP, &sock);
 			if (err < 0)
 				goto out;
 
@@ -1359,7 +1359,7 @@ static int l2tp_tunnel_sock_create(struct net *net,
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

