Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80D2228799
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgGURlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:41:51 -0400
Received: from mail.katalix.com ([3.9.82.81]:53300 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730435AbgGURlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:41:03 -0400
Received: from localhost.localdomain (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 936F893AF8;
        Tue, 21 Jul 2020 18:33:00 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1595352780; bh=PJhw7R4hx31rqlAiEIfs75cQuJOZT3tB1b5mdr6COtU=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:From;
        z=From:=20Tom=20Parkin=20<tparkin@katalix.com>|To:=20netdev@vger.ke
         rnel.org|Cc:=20Tom=20Parkin=20<tparkin@katalix.com>|Subject:=20[PA
         TCH=2009/29]=20l2tp:=20prefer=20using=20BIT=20macro|Date:=20Tue,=2
         021=20Jul=202020=2018:32:01=20+0100|Message-Id:=20<20200721173221.
         4681-10-tparkin@katalix.com>|In-Reply-To:=20<20200721173221.4681-1
         -tparkin@katalix.com>|References:=20<20200721173221.4681-1-tparkin
         @katalix.com>;
        b=q8fV8KYey3IvVPuScG85i40FDmmguJCiRAjvCYs0gBEmNtuii9um4jq9fDMWHsh97
         jQ2wqOpj+RLnHEsGXq73LOgAMhV4/GfblmpHSuIpPq768pYt8GS1nyViKCEugutKoA
         wsLy8BPu3pAwZT8gw/rS7Djn3p/gruQMq8YT+9ujPHT3/4R4/7z2feZshE/HTmZPOI
         ujgrsdEexZKGPhZd2Gmok2L5zaN9oqH8caU8v7on8K4wX2G/oEnji5K7PxbJqu1HQt
         vQinzy+ylNeSMQmdHfdHEXU0SSqa1HrNYE5C2U6JYUoADl6Z8XOv2Xk0uRQ+v/CMTC
         3/wORhYAxdf5A==
From:   Tom Parkin <tparkin@katalix.com>
To:     netdev@vger.kernel.org
Cc:     Tom Parkin <tparkin@katalix.com>
Subject: [PATCH 09/29] l2tp: prefer using BIT macro
Date:   Tue, 21 Jul 2020 18:32:01 +0100
Message-Id: <20200721173221.4681-10-tparkin@katalix.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721173221.4681-1-tparkin@katalix.com>
References: <20200721173221.4681-1-tparkin@katalix.com>
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

