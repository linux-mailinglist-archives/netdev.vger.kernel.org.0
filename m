Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C746229D25
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730657AbgGVQck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730346AbgGVQcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:32:36 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EDBD8C0619E1
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:32:35 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 9F17693AF6;
        Wed, 22 Jul 2020 17:32:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435555; bh=2w5E3R3VRlhMle2fe4LWNVLYJSyoe6PTNM8yqk4S3hY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=2009/10]=20l2tp:=20line-break=20
         long=20function=20prototypes|Date:=20Wed,=2022=20Jul=202020=2017:3
         2:13=20+0100|Message-Id:=20<20200722163214.7920-10-tparkin@katalix
         .com>|In-Reply-To:=20<20200722163214.7920-1-tparkin@katalix.com>|R
         eferences:=20<20200722163214.7920-1-tparkin@katalix.com>;
        b=zNOT/5hFH554tLdp2CO2/r9+kvTdRCYiwDkjEM7HOpLEmUaFOBXRJTk6A7rypDhYA
         TnFmb1uPqup1JEf/eIvkcX4Bptqb9BiJcvWt6+2x6clRxjyHXEa7TyCHoDTrCxuNNE
         75HPk2ERoD6qa2XZwsmszQb42OKk2W2HnS1gv+jssqudLwJv2vMv6reNxxVNSd6TTD
         DHZ7OYdlDDbohTFgPF2x9ziBlKH/zCL0xwpozn1q0HG+8RYqwiH5bNE5e2dUd/4KXv
         WZeB5yKOjXSHdvyqy2NqveD87N3Cr2Vfa7vco3Fgx6DZY//nZi1bZLrSfBu6oNw7Lb
         dWlcXvM76yMMg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 09/10] l2tp: line-break long function prototypes
Date:   Wed, 22 Jul 2020 17:32:13 +0100
Message-Id: <20200722163214.7920-10-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In l2tp_core.c both l2tp_tunnel_create and l2tp_session_create take
quite a number of arguments and have a correspondingly long prototype.

This is both quite difficult to scan visually, and triggers checkpatch
warnings.

Add a line break to make these function prototypes more readable.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 64d3a1d3ff3c..3dc712647f34 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1400,7 +1400,8 @@ static int l2tp_tunnel_sock_create(struct net *net,
 
 static struct lock_class_key l2tp_socket_class;
 
-int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
+int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
+		       struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
 {
 	struct l2tp_tunnel *tunnel = NULL;
 	int err;
@@ -1641,7 +1642,8 @@ void l2tp_session_set_header_len(struct l2tp_session *session, int version)
 }
 EXPORT_SYMBOL_GPL(l2tp_session_set_header_len);
 
-struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
+struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id,
+					 u32 peer_session_id, struct l2tp_session_cfg *cfg)
 {
 	struct l2tp_session *session;
 
-- 
2.17.1

