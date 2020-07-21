Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41C9228793
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729300AbgGURle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730564AbgGURlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:04 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F6B7C0619DA
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:03 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 43A7A93AF6;
        Tue, 21 Jul 2020 18:33:00 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352780; bh=HUluvjjQ6vNsS4z+gfke4/PUIaoe1BkSfi1tKiZ2xgY=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2007/29]=20l2tp:=20cleanup=20suspect=20code=20indent|Date:=20T
         ue,=2021=20Jul=202020=2018:31:59=20+0100|Message-Id:=20<2020072117
         3221.4681-8-tparkin@katalix.com>|In-Reply-To:=20<20200721173221.46
         81-1-tparkin@katalix.com>|References:=20<20200721173221.4681-1-tpa
         rkin@katalix.com>;
        b=J7PhU+mqHVFgWfRkmy4i2cg4R6PVQGrgHaGAds8hvWHvIdXxKZ1O5iaifXI3W2L9n
         vJ3DngrxvMgcwmBFh+KtJ71KGOFc7VxikoL/EzSySdV2FO7LyEjH9U5TF8wgwpthzq
         3mGFYDTHZfO5EYTLep+EdidZeX6hMC2Q//YgeTezMxujZRNf+2Qpf7XkIWDtWYmQP/
         yRDct5XweGzeK5Y/inx7yq02jAf3mpXS4JO2Jr2aVICZ6+mtOeLtMNZn7iAfMA8dvE
         0Lz30+pXIE1CebxtiXpH0nmAfEpa1VESQ38PixW3w3b4WpEWLlOrzymT5IJ5qeCNho
         aKhPJRPCUfhCw==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 07/29] l2tp: cleanup suspect code indent
Date:   Tue, 21 Jul 2020 18:31:59 +0100
Message-Id: <20200721173221.4681-8-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

l2tp_core has conditionally compiled code in l2tp_xmit_skb for IPv6
support.  The structure of this code triggered a checkpatch warning
due to incorrect indentation.

Fix up the indentation to address the checkpatch warning.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a206ba97328f..0b6649d6d97d 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1120,8 +1120,8 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
 				      &sk->sk_v6_daddr, udp_len);
 		else
 #endif
-		udp_set_csum(sk->sk_no_check_tx, skb, inet->inet_saddr,
-			     inet->inet_daddr, udp_len);
+			udp_set_csum(sk->sk_no_check_tx, skb, inet->inet_saddr,
+				     inet->inet_daddr, udp_len);
 		break;
 
 	case L2TP_ENCAPTYPE_IP:
-- 
2.17.1

