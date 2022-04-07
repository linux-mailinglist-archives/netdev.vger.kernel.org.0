Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA344F7CD6
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbiDGKei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244409AbiDGKeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:34:18 -0400
Received: from mail.meizu.com (edge05.meizu.com [157.122.146.251])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CB21066EF;
        Thu,  7 Apr 2022 03:32:08 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail12.meizu.com
 (172.16.1.108) with Microsoft SMTP Server (TLS) id 14.3.487.0; Thu, 7 Apr
 2022 18:32:01 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Thu, 7 Apr
 2022 18:32:00 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ethernet: Fix some formatting issues
Date:   Thu, 7 Apr 2022 18:31:58 +0800
Message-ID: <1649327518-19696-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

reported by checkpatch.pl

WARNING: suspect code indent for conditional statements (16, 16)

CHECK: Alignment should match open parenthesis

WARNING: suspect code indent for conditional statements (16, 16)

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/net/ethernet/3com/3c589_cs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
index 4673bc1604e7..c46353375909 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -730,13 +730,13 @@ static void media_check(struct timer_list *t)
 
 	if (media != lp->media_status) {
 		if ((media & lp->media_status & 0x8000) &&
-				((lp->media_status ^ media) & 0x0800))
-		netdev_info(dev, "%s link beat\n",
-				(lp->media_status & 0x0800 ? "lost" : "found"));
+		    ((lp->media_status ^ media) & 0x0800))
+			netdev_info(dev, "%s link beat\n",
+				    (lp->media_status & 0x0800 ? "lost" : "found"));
 		else if ((media & lp->media_status & 0x4000) &&
-		 ((lp->media_status ^ media) & 0x0010))
-		netdev_info(dev, "coax cable %s\n",
-				(lp->media_status & 0x0010 ? "ok" : "problem"));
+			 ((lp->media_status ^ media) & 0x0010))
+			netdev_info(dev, "coax cable %s\n",
+				    (lp->media_status & 0x0010 ? "ok" : "problem"));
 		if (dev->if_port == 0) {
 			if (media & 0x8000) {
 				if (media & 0x0800)
-- 
2.7.4

