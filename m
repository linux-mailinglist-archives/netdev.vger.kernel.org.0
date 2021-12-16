Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E18476796
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 02:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhLPByi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 20:54:38 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:34815 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhLPByh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 20:54:37 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V-lWl92_1639619674;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V-lWl92_1639619674)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Dec 2021 09:54:35 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net: vertexcom: remove unneeded semicolon
Date:   Thu, 16 Dec 2021 09:54:33 +0800
Message-Id: <20211216015433.83383-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/net/ethernet/vertexcom/mse102x.c:414:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index a3c2426e5597..89a31783fbb4 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -411,7 +411,7 @@ static int mse102x_tx_pkt_spi(struct mse102x_net *mse, struct sk_buff *txb,
 		} else {
 			msleep(20);
 		}
-	};
+	}
 
 	ret = mse102x_tx_frame_spi(mse, txb, pad);
 	if (ret)
-- 
2.20.1.7.g153144c

