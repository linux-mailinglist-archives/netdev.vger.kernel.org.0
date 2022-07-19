Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D586578F60
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 02:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbiGSAob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 20:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233490AbiGSAoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 20:44:30 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C279248FC;
        Mon, 18 Jul 2022 17:44:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VJp5nlb_1658191464;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VJp5nlb_1658191464)
          by smtp.aliyun-inc.com;
          Tue, 19 Jul 2022 08:44:25 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     Larry.Finger@lwfinger.net, kvalo@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] wifi: mac80211: clean up one inconsistent indenting
Date:   Tue, 19 Jul 2022 08:44:23 +0800
Message-Id: <20220719004423.85142-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate the follow smatch warning:
drivers/net/wireless/broadcom/b43legacy/main.c:2947 b43legacy_wireless_core_stop() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/wireless/broadcom/b43legacy/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index cbc21c7c3138..4022c544aefe 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -2944,7 +2944,7 @@ static void b43legacy_wireless_core_stop(struct b43legacy_wldev *dev)
 			dev_kfree_skb(skb_dequeue(&wl->tx_queue[queue_num]));
 	}
 
-b43legacy_mac_suspend(dev);
+	b43legacy_mac_suspend(dev);
 	free_irq(dev->dev->irq, dev);
 	b43legacydbg(wl, "Wireless interface stopped\n");
 }
-- 
2.20.1.7.g153144c

