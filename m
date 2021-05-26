Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBC43914D1
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhEZKYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:24:31 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54837 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233732AbhEZKY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:24:29 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Ua9sFuo_1622024569;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ua9sFuo_1622024569)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 May 2021 18:22:55 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kvalo@codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] wcn36xx: Fix inconsistent indenting
Date:   Wed, 26 May 2021 18:22:48 +0800
Message-Id: <1622024568-32130-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

drivers/net/wireless/ath/wcn36xx/dxe.c:803 wcn36xx_dxe_tx_frame() warn:
inconsistent indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 6307923..8e1dbfd 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -800,7 +800,7 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 			 (char *)ctl_skb->skb->data, ctl_skb->skb->len);
 
 	/* Move the head of the ring to the next empty descriptor */
-	 ch->head_blk_ctl = ctl_skb->next;
+	ch->head_blk_ctl = ctl_skb->next;
 
 	/* Commit all previous writes and set descriptors to VALID */
 	wmb();
-- 
1.8.3.1

