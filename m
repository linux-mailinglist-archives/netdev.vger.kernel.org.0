Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF33568E524
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBHAuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBHAuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:50:07 -0500
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F011A962;
        Tue,  7 Feb 2023 16:50:04 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vb985jS_1675817400;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Vb985jS_1675817400)
          by smtp.aliyun-inc.com;
          Wed, 08 Feb 2023 08:50:01 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net: libwx: Remove unneeded semicolon
Date:   Wed,  8 Feb 2023 08:49:59 +0800
Message-Id: <20230208004959.47553-1-yang.lee@linux.alibaba.com>
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

./drivers/net/ethernet/wangxun/libwx/wx_lib.c:683:2-3: Unneeded semicolon

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3976
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 57e1871ea0c6..7abb5ef5f34e 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -680,7 +680,7 @@ static int wx_poll(struct napi_struct *napi, int budget)
 	if (likely(napi_complete_done(napi, work_done))) {
 		if (netif_running(wx->netdev))
 			wx_intr_enable(wx, WX_INTR_Q(q_vector->v_idx));
-	};
+	}
 
 	return min(work_done, budget - 1);
 }
-- 
2.20.1.7.g153144c

