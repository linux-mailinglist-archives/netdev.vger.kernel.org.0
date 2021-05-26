Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6293914D5
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 12:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhEZKZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 06:25:47 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:60223 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233913AbhEZKZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 06:25:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0Ua9sG5G_1622024650;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Ua9sG5G_1622024650)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 May 2021 18:24:13 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] drivers/net/sungem: Fix inconsistent indenting
Date:   Wed, 26 May 2021 18:24:08 +0800
Message-Id: <1622024648-33438-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:

drivers/net/sungem_phy.c:412 genmii_read_link() warn: inconsistent
indenting.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/sungem_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/sungem_phy.c b/drivers/net/sungem_phy.c
index 291fa44..4daac5f 100644
--- a/drivers/net/sungem_phy.c
+++ b/drivers/net/sungem_phy.c
@@ -409,7 +409,7 @@ static int genmii_read_link(struct mii_phy *phy)
 	 * though magic-aneg shouldn't prevent this case from occurring
 	 */
 
-	 return 0;
+	return 0;
 }
 
 static int generic_suspend(struct mii_phy* phy)
-- 
1.8.3.1

