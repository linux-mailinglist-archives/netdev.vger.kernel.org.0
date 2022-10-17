Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3003600784
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 09:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbiJQHS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 03:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiJQHSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 03:18:25 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D3C35808B;
        Mon, 17 Oct 2022 00:18:22 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VSJPAsn_1665991068;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VSJPAsn_1665991068)
          by smtp.aliyun-inc.com;
          Mon, 17 Oct 2022 15:18:20 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     stas.yakovlev@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] wireless: ipw2200: Remove the unused function ipw_alive()
Date:   Mon, 17 Oct 2022 15:17:46 +0800
Message-Id: <20221017071746.118685-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ipw_alive() is defined in the ipw2200.c file, but not called
elsewhere, so delete this unused function.

drivers/net/wireless/intel/ipw2x00/ipw2200.c:3007:19: warning: unused function 'ipw_alive'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2410
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5b483de18c81..79d5c09757d4 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -2995,20 +2995,6 @@ static void ipw_remove_current_network(struct ipw_priv *priv)
 	spin_unlock_irqrestore(&priv->ieee->lock, flags);
 }
 
-/*
- * Check that card is still alive.
- * Reads debug register from domain0.
- * If card is present, pre-defined value should
- * be found there.
- *
- * @param priv
- * @return 1 if card is present, 0 otherwise
- */
-static inline int ipw_alive(struct ipw_priv *priv)
-{
-	return ipw_read32(priv, 0x90) == 0xd55555d5;
-}
-
 /* timeout in msec, attempted in 10-msec quanta */
 static int ipw_poll_bit(struct ipw_priv *priv, u32 addr, u32 mask,
 			       int timeout)
-- 
2.20.1.7.g153144c

