Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8790B6006E4
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 08:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbiJQGu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 02:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiJQGut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 02:50:49 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E164D5419E;
        Sun, 16 Oct 2022 23:50:47 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VSIvXR9_1665989362;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VSIvXR9_1665989362)
          by smtp.aliyun-inc.com;
          Mon, 17 Oct 2022 14:50:44 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     nbd@nbd.name
Cc:     john@phrozen.org, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net: ethernet: mediatek: ppe: Remove the unused function mtk_foe_entry_usable()
Date:   Mon, 17 Oct 2022 14:49:20 +0800
Message-Id: <20221017064920.83732-1-jiapeng.chong@linux.alibaba.com>
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

The function mtk_foe_entry_usable() is defined in the mtk_ppe.c file, but
not called elsewhere, so delete this unused function.

drivers/net/ethernet/mediatek/mtk_ppe.c:400:20: warning: unused function 'mtk_foe_entry_usable'.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2409
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index ae00e572390d..2d8ca99f2467 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -397,12 +397,6 @@ int mtk_foe_entry_set_wdma(struct mtk_eth *eth, struct mtk_foe_entry *entry,
 	return 0;
 }
 
-static inline bool mtk_foe_entry_usable(struct mtk_foe_entry *entry)
-{
-	return !(entry->ib1 & MTK_FOE_IB1_STATIC) &&
-	       FIELD_GET(MTK_FOE_IB1_STATE, entry->ib1) != MTK_FOE_STATE_BIND;
-}
-
 static bool
 mtk_flow_entry_match(struct mtk_eth *eth, struct mtk_flow_entry *entry,
 		     struct mtk_foe_entry *data)
-- 
2.20.1.7.g153144c

