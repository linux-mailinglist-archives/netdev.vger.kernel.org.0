Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9D850A9F7
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 22:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392373AbiDUUbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 16:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389385AbiDUUbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 16:31:52 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D678E4DF59;
        Thu, 21 Apr 2022 13:29:01 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VAhY.oD_1650572933;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VAhY.oD_1650572933)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 22 Apr 2022 04:28:58 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     pisa@cmp.felk.cvut.cz
Cc:     ondrej.ille@gmail.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] can: ctucanfd: Remove unused including <linux/version.h>
Date:   Fri, 22 Apr 2022 04:28:52 +0800
Message-Id: <20220421202852.2693-1-jiapeng.chong@linux.alibaba.com>
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

Eliminate the follow versioncheck warning:

./drivers/net/can/ctucanfd/ctucanfd_base.c: 34 linux/version.h not
needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/can/ctucanfd/ctucanfd_base.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/ctucanfd/ctucanfd_base.c b/drivers/net/can/ctucanfd/ctucanfd_base.c
index 7a4550f60abb..be90136be442 100644
--- a/drivers/net/can/ctucanfd/ctucanfd_base.c
+++ b/drivers/net/can/ctucanfd/ctucanfd_base.c
@@ -31,7 +31,6 @@
 #include <linux/can/error.h>
 #include <linux/can/led.h>
 #include <linux/pm_runtime.h>
-#include <linux/version.h>
 
 #include "ctucanfd.h"
 #include "ctucanfd_kregs.h"
-- 
2.20.1.7.g153144c

