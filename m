Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352E6229D23
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbgGVQch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730111AbgGVQcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 12:32:36 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A7373C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 09:32:35 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 169B093AEB;
        Wed, 22 Jul 2020 17:32:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435555; bh=TZzaY7Jc9wmk12usqCKLt3hqYF6Q/JfYTNqDZEUT5Ec=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=2005/10]=20l2tp:=20cleanup=20sus
         pect=20code=20indent|Date:=20Wed,=2022=20Jul=202020=2017:32:09=20+
         0100|Message-Id:=20<20200722163214.7920-6-tparkin@katalix.com>|In-
         Reply-To:=20<20200722163214.7920-1-tparkin@katalix.com>|References
         :=20<20200722163214.7920-1-tparkin@katalix.com>;
        b=oyonsdlmhaJ7czP/I47svlTF5v/qZeoA+j4qjNtHxaZmQ61+V01+IF0Ci7N6h56cw
         XTDnFZ5NxzclGdFRD/uwxDAoMnz2tl3RL1B+h43bVGSQIlFjLc3GgNsUMaxzLVfZtO
         7bEWKRYLxrNehUvXXHL2MYSRmsVlsZKqxgLUJc22/3K/lzVdhhiTymfTGhnEsEtKeM
         iNOZ9/hKZUCZ88EwPUqtbQlte3a29b9uocvdsQ0hiXwiDIUxT4oyo83uTBBcXrfNjJ
         JGjYnzH5/0stZlSwH2Kw8E3LYGhKlwTdk5xiIVIGof/aM/E1s/CQU7nSvhO2cVsks9
         8UPq167M/MyVg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 05/10] l2tp: cleanup suspect code indent
Date:   Wed, 22 Jul 2020 17:32:09 +0100
Message-Id: <20200722163214.7920-6-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
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
index 3162e395cd4a..64d3a1d3ff3c 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1122,8 +1122,8 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
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

