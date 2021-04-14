Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47E335EE37
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349666AbhDNHOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:14:15 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:48264 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349632AbhDNHOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:14:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UVWLSk6_1618384421;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UVWLSk6_1618384421)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 14 Apr 2021 15:13:50 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] atm: idt77252: remove unused function
Date:   Wed, 14 Apr 2021 15:13:39 +0800
Message-Id: <1618384419-39959-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following clang warning:

drivers/atm/idt77252.c:1787:1: warning: unused function
'idt77252_fbq_level' [-Wunused-function].

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/atm/idt77252.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 0c13cac..9e4bd75 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -1784,12 +1784,6 @@ static int idt77252_proc_read(struct atm_dev *dev, loff_t * pos,
 /*****************************************************************************/
 
 static __inline__ int
-idt77252_fbq_level(struct idt77252_dev *card, int queue)
-{
-	return (readl(SAR_REG_STAT) >> (16 + (queue << 2))) & 0x0f;
-}
-
-static __inline__ int
 idt77252_fbq_full(struct idt77252_dev *card, int queue)
 {
 	return (readl(SAR_REG_STAT) >> (16 + (queue << 2))) == 0x0f;
-- 
1.8.3.1

