Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16F004F7D15
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244441AbiDGKjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244946AbiDGKiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:38:10 -0400
Received: from mail.meizu.com (edge07.meizu.com [112.91.151.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C25E18F213;
        Thu,  7 Apr 2022 03:36:07 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail11.meizu.com
 (172.16.1.15) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 8 Apr 2022
 02:46:33 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Thu, 7 Apr
 2022 18:36:05 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH V2] ethernet: Fix some formatting issues
Date:   Thu, 7 Apr 2022 18:36:04 +0800
Message-ID: <1649327764-29869-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

reported by checkpatch.pl

WARNING: suspect code indent for conditional statements (16, 16)
#732: FILE: drivers/net/ethernet/3com/3c589_cs.c:732:
CHECK: Alignment should match open parenthesis
#733: FILE: drivers/net/ethernet/3com/3c589_cs.c:733:
CHECK: Alignment should match open parenthesis
#735: FILE: drivers/net/ethernet/3com/3c589_cs.c:735:
WARNING: suspect code indent for conditional statements (16, 16)
#736: FILE: drivers/net/ethernet/3com/3c589_cs.c:736:
CHECK: Alignment should match open parenthesis
#737: FILE: drivers/net/ethernet/3com/3c589_cs.c:737:
CHECK: Alignment should match open parenthesis
#739: FILE: drivers/net/ethernet/3com/3c589_cs.c:739:
Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
V1->V2: add detail of description

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

