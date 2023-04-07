Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5608E6DA807
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 05:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237539AbjDGDmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 23:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjDGDmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 23:42:17 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2147ABC;
        Thu,  6 Apr 2023 20:42:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R581e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VfVAT1-_1680838919;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VfVAT1-_1680838919)
          by smtp.aliyun-inc.com;
          Fri, 07 Apr 2023 11:42:10 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net: fddi: skfp: rmt: Clean up some inconsistent indenting
Date:   Fri,  7 Apr 2023 11:41:57 +0800
Message-Id: <20230407034157.61276-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional modification involved.

drivers/net/fddi/skfp/rmt.c:236 rmt_fsm() warn: if statement not indented.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4736
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/fddi/skfp/rmt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/fddi/skfp/rmt.c b/drivers/net/fddi/skfp/rmt.c
index 37a89675dbeb..314623650a84 100644
--- a/drivers/net/fddi/skfp/rmt.c
+++ b/drivers/net/fddi/skfp/rmt.c
@@ -234,9 +234,9 @@ static void rmt_fsm(struct s_smc *smc, int cmd)
 		if (smc->r.rm_join) {
 			smc->r.sm_ma_avail = TRUE ;
 			if (smc->mib.m[MAC0].fddiMACMA_UnitdataEnable)
-			smc->mib.m[MAC0].fddiMACMA_UnitdataAvailable = TRUE ;
-				else
-			smc->mib.m[MAC0].fddiMACMA_UnitdataAvailable = FALSE ;
+				smc->mib.m[MAC0].fddiMACMA_UnitdataAvailable = TRUE;
+			else
+				smc->mib.m[MAC0].fddiMACMA_UnitdataAvailable = FALSE;
 		}
 		DB_RMTN(1, "RMT : RING UP");
 		RS_CLEAR(smc,RS_NORINGOP) ;
-- 
2.20.1.7.g153144c

