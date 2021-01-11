Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB5E2F0EFE
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 10:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbhAKJZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 04:25:19 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:36328 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728204AbhAKJZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 04:25:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0ULMSkuR_1610357064;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULMSkuR_1610357064)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Jan 2021 17:24:30 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] hci: llc_shdlc: style: Simplify bool comparison
Date:   Mon, 11 Jan 2021 17:24:23 +0800
Message-Id: <1610357063-57705-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:
./net/nfc/hci/llc_shdlc.c:239:5-21: WARNING: Comparison to bool

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot<abaci@linux.alibaba.com>
---
 net/nfc/hci/llc_shdlc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/hci/llc_shdlc.c b/net/nfc/hci/llc_shdlc.c
index 0eb4ddc..c0c8fea 100644
--- a/net/nfc/hci/llc_shdlc.c
+++ b/net/nfc/hci/llc_shdlc.c
@@ -236,7 +236,7 @@ static void llc_shdlc_rcv_i_frame(struct llc_shdlc *shdlc,
 		goto exit;
 	}
 
-	if (shdlc->t1_active == false) {
+	if (!shdlc->t1_active) {
 		shdlc->t1_active = true;
 		mod_timer(&shdlc->t1_timer, jiffies +
 			  msecs_to_jiffies(SHDLC_T1_VALUE_MS(shdlc->w)));
-- 
1.8.3.1

