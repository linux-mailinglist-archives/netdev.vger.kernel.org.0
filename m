Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744F9572B31
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 04:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbiGMCIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 22:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiGMCIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 22:08:14 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB02AC1773;
        Tue, 12 Jul 2022 19:08:12 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R631e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VJBdQNF_1657678080;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VJBdQNF_1657678080)
          by smtp.aliyun-inc.com;
          Wed, 13 Jul 2022 10:08:10 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     sgoutham@marvell.com
Cc:     lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] octeontx2-af: Remove duplicate include
Date:   Wed, 13 Jul 2022 10:07:59 +0800
Message-Id: <20220713020759.52770-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The include is in line 14 and 23. Remove the duplicate.

Fix following checkincludes warning:

./drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: linux/bitfield.h is included more than once.
./drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: rvu_npc_hash.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
index ed8b9afbf731..ff71e6a87741 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
@@ -11,14 +11,12 @@
 #include <linux/firmware.h>
 #include <linux/stddef.h>
 #include <linux/debugfs.h>
-#include <linux/bitfield.h>
 
 #include "rvu_struct.h"
 #include "rvu_reg.h"
 #include "rvu.h"
 #include "npc.h"
 #include "cgx.h"
-#include "rvu_npc_hash.h"
 #include "rvu_npc_fs.h"
 #include "rvu_npc_hash.h"
 
-- 
2.20.1.7.g153144c

