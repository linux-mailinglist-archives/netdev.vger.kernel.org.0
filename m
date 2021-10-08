Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370E1426490
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 08:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhJHGXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 02:23:24 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:37408 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229654AbhJHGXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 02:23:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R251e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Uqw9Qu6_1633674083;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Uqw9Qu6_1633674083)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Oct 2021 14:21:25 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, olteanv@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, linus.walleij@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] net: dsa: rtl8366rb: remove unneeded semicolon
Date:   Fri,  8 Oct 2021 14:21:17 +0800
Message-Id: <1633674077-68546-1-git-send-email-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the following coccicheck warning:
./drivers/net/dsa/rtl8366rb.c:1348:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/dsa/rtl8366rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index d2370cd..03deacd 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -1345,7 +1345,7 @@ static int rtl8366rb_vlan_filtering(struct dsa_switch *ds, int port,
 	default:
 		dev_err(smi->dev, "unknown bridge state requested\n");
 		return;
-	};
+	}
 
 	/* Set the same status for the port on all the FIDs */
 	for (i = 0; i < RTL8366RB_NUM_FIDS; i++) {
-- 
1.8.3.1

