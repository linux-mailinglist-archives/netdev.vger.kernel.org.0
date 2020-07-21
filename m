Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A31228795
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbgGURli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730558AbgGURlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 13:41:04 -0400
Received: from mail.katalix.com (mail.katalix.com [IPv6:2a05:d01c:827:b342:16d0:7237:f32a:8096])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 08E66C0619DD
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 10:41:03 -0700 (PDT)
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 765B893AF7;
        Tue, 21 Jul 2020 18:33:00 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352780; bh=M5ASBge1m68uelOnHcFoTs9KxX0wzaFQnAgcTlDu2v0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2008/29]=20l2tp:=20add=20identifier=20name=20in=20function=20p
         ointer=20prototype|Date:=20Tue,=2021=20Jul=202020=2018:32:00=20+01
         00|Message-Id:=20<20200721173221.4681-9-tparkin@katalix.com>|In-Re
         ply-To:=20<20200721173221.4681-1-tparkin@katalix.com>|References:=
         20<20200721173221.4681-1-tparkin@katalix.com>;
        b=Pmf8U810sKQ3sIcuXRzFE9Oasgzlcp5ExUsfSzjx/sSjlxxBOSd5JKoGQKLzVVAfT
         3cKLAIzbYx/pG3X2U91j9TApYm48oAiOVnatd/xvQFbsqdCCyhdlQryrhspfEDJjFE
         EE7BGHnIZATJRXeAI54HWCA2eIntC9TavfNwhhZMVEaZUwQLY3jkYFlnIy6khOwCBB
         fOZ2c/IJ43FfpklGmzXMNtN854ElFhkhLRufQjrjl9FciFK8nUJ1ibym7NTrv93mqs
         KHnzvUOJtuHO6vi8MFf0Gj8V6ngU9ClEUHmu6InBgSLG8fLUZ+RDHPJsr9OGVwSUEN
         /INhyS2y73VnA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 08/29] l2tp: add identifier name in function pointer prototype
Date:   Tue, 21 Jul 2020 18:32:00 +0100
Message-Id: <20200721173221.4681-9-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
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

