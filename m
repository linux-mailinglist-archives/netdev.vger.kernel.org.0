Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FE4229D29
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 18:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730972AbgGVQcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 12:32:45 -0400
Received: from mail.katalix.com ([3.9.82.81]:35456 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbgGVQch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 12:32:37 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 555BB93AF0;
        Wed, 22 Jul 2020 17:32:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595435555; bh=PJhw7R4hx31rqlAiEIfs75cQuJOZT3tB1b5mdr6COtU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20jchapman@katalix.com,=0D=0A=09Tom=20Parkin=20<tpark
         in@katalix.com>|Subject:=20[PATCH=2007/10]=20l2tp:=20prefer=20usin
         g=20BIT=20macro|Date:=20Wed,=2022=20Jul=202020=2017:32:11=20+0100|
         Message-Id:=20<20200722163214.7920-8-tparkin@katalix.com>|In-Reply
         -To:=20<20200722163214.7920-1-tparkin@katalix.com>|References:=20<
         20200722163214.7920-1-tparkin@katalix.com>;
        b=D09sEkTHWqA4YDbrC6jY+QmDpgo9UQON9teH2mZfOfh4Q8joqv8ZyjFhHw7zWMEAF
         Fjfvvd9fUjKQtyEG1ukVeqskzpyLa/gWoBYRVObea1/sfYuPyWboe8fAgTkIfZczOg
         5HBwGYeuSV3lqBiDfy5+fSwZzLGZDaJ4aPKvlD4FcpJqP/zHP49jersAYVw67hrw0c
         soBJoB/OqPATmm4M9pWHXFLyYBu+WTu/xrWDBZ8DoiqEsqIr1WZj5acCUZWEK0Fpms
         BrtetBSDkYoOAPG9srg+k8ABQxIRbVCGuBV8Yu9gjizKsrM5Sx1+8wRGRWdkHkpujo
         c9OKQUsagaXAg==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     jchapman@katalix.com, Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 07/10] l2tp: prefer using BIT macro
Date:   Wed, 22 Jul 2020 17:32:11 +0100
Message-Id: <20200722163214.7920-8-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722163214.7920-1-tparkin@katalix.com>
References: <20200722163214.7920-1-tparkin@katalix.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use BIT(x) rather than (1<<x), reported by checkpatch.pl.

Signed-off-by: Tom Parkin <tparkin@katalix.com>
---
 net/l2tp/l2tp_core.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index f23b3ff7ffff..2d2dd219a176 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -21,11 +21,11 @@
 
 /* Per tunnel, session hash table size */
 #define L2TP_HASH_BITS	4
-#define L2TP_HASH_SIZE	(1 << L2TP_HASH_BITS)
+#define L2TP_HASH_SIZE	BIT(L2TP_HASH_BITS)
 
 /* System-wide, session hash table size */
 #define L2TP_HASH_BITS_2	8
-#define L2TP_HASH_SIZE_2	(1 << L2TP_HASH_BITS_2)
+#define L2TP_HASH_SIZE_2	BIT(L2TP_HASH_BITS_2)
 
 struct sk_buff;
 
-- 
2.17.1

