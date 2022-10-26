Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D849A60DA7D
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 07:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbiJZFSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 01:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiJZFSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 01:18:33 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F418996B;
        Tue, 25 Oct 2022 22:18:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VT5nKsG_1666761505;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VT5nKsG_1666761505)
          by smtp.aliyun-inc.com;
          Wed, 26 Oct 2022 13:18:26 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     ioana.ciornei@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next] net: dpaa2-eth: Simplify bool conversion
Date:   Wed, 26 Oct 2022 13:18:24 +0800
Message-Id: <20221026051824.38730-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

./drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c:453:42-47: WARNING: conversion to bool not needed here

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2577
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
index 567f52affe21..051748b997f3 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
@@ -450,5 +450,5 @@ bool dpaa2_xsk_tx(struct dpaa2_eth_priv *priv,
 
 	xsk_tx_release(ch->xsk_pool);
 
-	return total_enqueued == budget ? true : false;
+	return total_enqueued == budget;
 }
-- 
2.20.1.7.g153144c

