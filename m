Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E804DA67C
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 00:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352664AbiCOX5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 19:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344372AbiCOX5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 19:57:21 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F0F8BCA9;
        Tue, 15 Mar 2022 16:56:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V7JsXvb_1647388565;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V7JsXvb_1647388565)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Mar 2022 07:56:05 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     ioana.ciornei@nxp.com
Cc:     kishon@ti.com, vkoul@kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] phy: Remove duplicated include in phy-fsl-lynx-28g.c
Date:   Wed, 16 Mar 2022 07:56:03 +0800
Message-Id: <20220315235603.59481-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following includecheck warning:
./drivers/phy/freescale/phy-fsl-lynx-28g.c: linux/workqueue.h is
included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/phy/freescale/phy-fsl-lynx-28g.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/phy/freescale/phy-fsl-lynx-28g.c b/drivers/phy/freescale/phy-fsl-lynx-28g.c
index a2b060e9e284..569f12af2aaf 100644
--- a/drivers/phy/freescale/phy-fsl-lynx-28g.c
+++ b/drivers/phy/freescale/phy-fsl-lynx-28g.c
@@ -6,7 +6,6 @@
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/workqueue.h>
-#include <linux/workqueue.h>
 
 #define LYNX_28G_NUM_LANE			8
 #define LYNX_28G_NUM_PLL			2
-- 
2.20.1.7.g153144c

