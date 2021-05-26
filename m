Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9BD3914CC
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhEZKWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:22:48 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:60133 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233873AbhEZKWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:22:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Ua9vg6b_1622024471;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ua9vg6b_1622024471)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 May 2021 18:21:13 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net/appletalk: Fix inconsistent indenting
Date:   Wed, 26 May 2021 18:21:04 +0800
Message-Id: <1622024464-29896-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

drivers/net/appletalk/ltpc.c:588 idle() warn: inconsistent indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/appletalk/ltpc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index f0e715a..69c2708 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -584,11 +584,13 @@ static void idle(struct net_device *dev)
 						printk("%02x ",ltdmacbuf[i]);
 					printk("\n");
 				}
+
 				handlecommand(dev);
-					if(0xfa==inb_p(base+6)) {
-						/* we timed out, so return */
-						goto done;
-					} 
+
+				if (0xfa == inb_p(base + 6)) {
+					/* we timed out, so return */
+					goto done;
+				}
 			} else {
 				/* we don't seem to have a command */
 				if (!mboxinuse[0]) {
-- 
1.8.3.1

