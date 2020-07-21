Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBCE228791
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgGURlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:31 -0400
Received: from mail.katalix.com ([3.9.82.81]:53312 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbgGURlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:05 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 4331993AFD;
        Tue, 21 Jul 2020 18:33:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352781; bh=FBWurGVXrqcz7ttizQaKLVqncKtkk96nzgvfINfWFx0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2014/29]=20l2tp:=20line-break=20long=20function=20prototypes|D
         ate:=20Tue,=2021=20Jul=202020=2018:32:06=20+0100|Message-Id:=20<20
         200721173221.4681-15-tparkin@katalix.com>|In-Reply-To:=20<20200721
         173221.4681-1-tparkin@katalix.com>|References:=20<20200721173221.4
         681-1-tparkin@katalix.com>;
        b=HxqJLYd5cEePxqnFqoo6Po9X8QQyP4LftkROf6Q9LgbyVSYj5Clwo2X61yYQIYuX8
         5+fD97jxGpeQEEQjX1Lz8Xlwb5KNQha5z2/+Xb3/o3bUjXsJjPyXw1U5aIxrr+8+1p
         yIr5oVUbjhjDPh5j0/i/uwoqjkg7CV0Bf0KB9mOC1cf+dZ1c4jVr4osW7iGjNZE2xA
         Tn5YXo7+roWWN3pu8PBkueYPQ89wgMMmmEBbjEk+s+vCyhuVQkwrXM1eP+j8Mg4ehp
         DSL67xffiu2z9YKciDlnxGN4pdQCKyotnkpOZTAipRyVbjh5mI2AJ/H7FhEe34wKM3
         ftobwmit917sw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 14/29] l2tp: line-break long function prototypes
Date:   Tue, 21 Jul 2020 18:32:06 +0100
Message-Id: <20200721173221.4681-15-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
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
index 7218925edbf2..ef393604e66e 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1398,7 +1398,8 @@ static int l2tp_tunnel_sock_create(struct net *net,
 
 static struct lock_class_key l2tp_socket_class;
 
-int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
+int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
+		       struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
 {
 	struct l2tp_tunnel *tunnel = NULL;
 	int err;
@@ -1639,7 +1640,8 @@ void l2tp_session_set_header_len(struct l2tp_session *session, int version)
 }
 EXPORT_SYMBOL_GPL(l2tp_session_set_header_len);
 
-struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id, u32 peer_session_id, struct l2tp_session_cfg *cfg)
+struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunnel, u32 session_id,
+					 u32 peer_session_id, struct l2tp_session_cfg *cfg)
 {
 	struct l2tp_session *session;
 
-- 
2.17.1

