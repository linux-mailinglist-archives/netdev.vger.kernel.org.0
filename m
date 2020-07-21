Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1B5228788
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbgGURlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:13 -0400
Received: from mail.katalix.com ([3.9.82.81]:53282 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730240AbgGURlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:02 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id A479293B01;
        Tue, 21 Jul 2020 18:33:01 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352781; bh=5z/kBQUiJuWut9VLOIzMy/uNziWMUtPLohYO2bmgeJM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2017/29]=20l2tp:=20avoid=20precidence=20issues=20in=20L2TP_SKB
         _CB=20macro|Date:=20Tue,=2021=20Jul=202020=2018:32:09=20+0100|Mess
         age-Id:=20<20200721173221.4681-18-tparkin@katalix.com>|In-Reply-To
         :=20<20200721173221.4681-1-tparkin@katalix.com>|References:=20<202
         00721173221.4681-1-tparkin@katalix.com>;
        b=e4bFOEZVsR7pUaeYySpOu2YL4bslEMpISEnPkbiSc/mSxZAGTTMdnwhagI2M61/Tq
         iWoTghDWopZInl1x2vBXy3c3smqqq11sOndhIZU5KI2RIFZ6InwAxwcgfxsyuWoI1E
         bp8tKYWOK0xlnj5CD4JkGS9VlltGUvN2jNaa1+y7SOCxaQTYBrddk8x/pbT284j93d
         87fKL5J82k9V59Xprz4TCE0eVgrgbPgVkgdRU8U4gOGPIe1cNTg5N+wx2S/pI1zWXy
         8JPmK5T9wOXDeNuzvwFhOvYDBlkq0Ob65QWOacLR/MvWEL8AdSV1ZncrS23eEer5Lj
         20u9rXCrL9KzA==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 17/29] l2tp: avoid precidence issues in L2TP_SKB_CB macro
Date:   Tue, 21 Jul 2020 18:32:09 +0100
Message-Id: <20200721173221.4681-18-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

checkpatch warned about the L2TP_SKB_CB macro's use of its argument: add
braces to avoid the problem.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 177accb01993..4973a0f035e3 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -93,7 +93,7 @@ struct l2tp_skb_cb {
 	unsigned long		expires;
 };
 
-#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&skb->cb[sizeof(struct inet_skb_parm)])
+#define L2TP_SKB_CB(skb)	((struct l2tp_skb_cb *)&(skb)->cb[sizeof(struct inet_skb_parm)])
 
 static struct workqueue_struct *l2tp_wq;
 
-- 
2.17.1

