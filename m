Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DEF68E57C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 02:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjBHBcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 20:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBHBcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 20:32:42 -0500
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E765542BDD;
        Tue,  7 Feb 2023 17:32:31 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vb92KQM_1675819948;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Vb92KQM_1675819948)
          by smtp.aliyun-inc.com;
          Wed, 08 Feb 2023 09:32:28 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiawenwu@trustnetic.com, mengyuanlou@net-swift.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] net: libwx: clean up one inconsistent indenting
Date:   Wed,  8 Feb 2023 09:32:27 +0800
Message-Id: <20230208013227.111605-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/wangxun/libwx/wx_lib.c:1835 wx_setup_all_rx_resources() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3981
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/wangxun/libwx/wx_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_lib.c b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
index 57e1871ea0c6..88dceece3e8a 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_lib.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_lib.c
@@ -1832,7 +1832,7 @@ static int wx_setup_all_rx_resources(struct wx *wx)
 		goto err_setup_rx;
 	}
 
-		return 0;
+	return 0;
 err_setup_rx:
 	/* rewind the index freeing the rings as we go */
 	while (i--)
-- 
2.20.1.7.g153144c

