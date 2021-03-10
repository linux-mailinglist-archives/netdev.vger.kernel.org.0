Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4113337DE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 09:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhCJIxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 03:53:35 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:53745 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231539AbhCJIxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 03:53:09 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0URGfeKO_1615366385;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0URGfeKO_1615366385)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Mar 2021 16:53:05 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     isdn@linux-pingi.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH] isdn: mISDN: remove unneeded variable 'ret'
Date:   Wed, 10 Mar 2021 16:53:04 +0800
Message-Id: <1615366384-12225-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./drivers/isdn/mISDN/dsp_core.c:956:6-9: Unneeded variable: "err".
Return "0" on line 1001

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/isdn/mISDN/dsp_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index 038e72a..4946ea1 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -953,7 +953,6 @@
 {
 	struct dsp		*dsp = container_of(ch, struct dsp, ch);
 	u_long		flags;
-	int		err = 0;
 
 	if (debug & DEBUG_DSP_CTRL)
 		printk(KERN_DEBUG "%s:(%x)\n", __func__, cmd);
@@ -998,7 +997,7 @@
 		module_put(THIS_MODULE);
 		break;
 	}
-	return err;
+	return 0;
 }
 
 static void
-- 
1.8.3.1

