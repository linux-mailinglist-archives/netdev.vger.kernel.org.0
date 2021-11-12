Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CAC44E478
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 11:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234894AbhKLKTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 05:19:55 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47390 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234800AbhKLKTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 05:19:52 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0UwBJYte_1636712209;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UwBJYte_1636712209)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 12 Nov 2021 18:17:00 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] net: Clean up some inconsistent indenting
Date:   Fri, 12 Nov 2021 18:16:34 +0800
Message-Id: <1636712194-67361-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

./include/linux/skbuff.h:4229 skb_remcsum_process() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 include/linux/skbuff.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 686a666..c8cb7e6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4226,7 +4226,7 @@ static inline void skb_remcsum_process(struct sk_buff *skb, void *ptr,
 		return;
 	}
 
-	 if (unlikely(skb->ip_summed != CHECKSUM_COMPLETE)) {
+	if (unlikely(skb->ip_summed != CHECKSUM_COMPLETE)) {
 		__skb_checksum_complete(skb);
 		skb_postpull_rcsum(skb, skb->data, ptr - (void *)skb->data);
 	}
-- 
1.8.3.1

