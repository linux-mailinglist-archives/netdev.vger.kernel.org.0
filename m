Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7AA229D26
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgGVQcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:41 -0400
Received: from mail.katalix.com ([3.9.82.81]:35454 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730108AbgGVQch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 12:32:37 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 363BB93AC0;
        Wed, 22 Jul 2020 17:32:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435555; bh=M5ASBge1m68uelOnHcFoTs9KxX0wzaFQnAgcTlDu2v0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=2006/10]=20l2tp:=20add=20identif
         ier=20name=20in=20function=20pointer=20prototype|Date:=20Wed,=2022
         =20Jul=202020=2017:32:10=20+0100|Message-Id:=20<20200722163214.792
         0-7-tparkin@katalix.com>|In-Reply-To:=20<20200722163214.7920-1-tpa
         rkin@katalix.com>|References:=20<20200722163214.7920-1-tparkin@kat
         alix.com>;
        b=ZN7H7CBpnJx+0/6Iyz8hCEztB6Veskx/JI8wRrOF34wxQBqhfEsbrX4P+tKHtTJEq
         dmH65CLXDkymvanSFiBfQ5sI6WRoNzb7Lpv7bqWUsdLkjhlAKe0c/58awjewyVRUAe
         KD1llnwsIv2Jtqb2rNIk9mULZneefmrnVBQXPkCOqJroWWYuCX+pcOPTVypf0Mh1ka
         CTkBiVvkWBvGwwCWCxhH8kxSR+ltwcL0YKy6GstqY/e3ZrRaXx2jb0pdPHsTI7wdMr
         iRjAH0czXmeB1rshwTcSwbRJzoo5Dl1yszF3Xtu9dg9Vig6avbKBOXVhaL+xtymLNS
         1WY8zU3976rFg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 06/10] l2tp: add identifier name in function pointer prototype
Date:   Wed, 22 Jul 2020 17:32:10 +0100
Message-Id: <20200722163214.7920-7-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reported by checkpatch:

        "WARNING: function definition argument 'struct sock *'
         should also have an identifier name"

Add an identifier name to help document the prototype.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 3ebb701eebbf..f23b3ff7ffff 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -154,7 +154,7 @@ struct l2tp_tunnel {
 	struct net		*l2tp_net;	/* the net we belong to */
 
 	refcount_t		ref_count;
-	void (*old_sk_destruct)(struct sock *);
+	void (*old_sk_destruct)(struct sock *sk);
 	struct sock		*sock;		/* parent socket */
 	int			fd;		/* parent fd, if tunnel socket was created
 						 * by userspace
-- 
2.17.1

