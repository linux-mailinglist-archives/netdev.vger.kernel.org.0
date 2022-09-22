Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB69E5E5CA1
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 09:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbiIVHrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 03:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiIVHrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 03:47:15 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0441ABD7F;
        Thu, 22 Sep 2022 00:47:14 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MY6hS38qjzlVwB;
        Thu, 22 Sep 2022 15:43:04 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 15:47:12 +0800
From:   Gaosheng Cui <cuigaosheng1@huawei.com>
To:     <nbd@nbd.name>, <lorenzo@kernel.org>, <ryder.lee@mediatek.com>,
        <shayne.chen@mediatek.com>, <sean.wang@mediatek.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <matthias.bgg@gmail.com>,
        <cuigaosheng1@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
Subject: [PATCH v2] wifi: mt76: Remove unused inline function mt76_wcid_mask_test()
Date:   Thu, 22 Sep 2022 15:47:11 +0800
Message-ID: <20220922074711.1408385-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.244.148.83]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All uses of mt76_wcid_mask_test() have
been removed since commit 8950a62f19c9 ("mt76: get rid of
mt76_wcid_hw routine"), so remove it.

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
v2:
- taking the patch out of the series: "Remove useless inline functions from net".
- add wifi: prefix to the subject, thanks!
v1:
- links: https://patchwork.kernel.org/project/linux-mediatek/patch/20220921090455.752011-3-cuigaosheng1@huawei.com/
 drivers/net/wireless/mediatek/mt76/util.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/util.h b/drivers/net/wireless/mediatek/mt76/util.h
index 49c52d781f40..260965dde94c 100644
--- a/drivers/net/wireless/mediatek/mt76/util.h
+++ b/drivers/net/wireless/mediatek/mt76/util.h
@@ -29,12 +29,6 @@ enum {
 
 int mt76_wcid_alloc(u32 *mask, int size);
 
-static inline bool
-mt76_wcid_mask_test(u32 *mask, int idx)
-{
-	return mask[idx / 32] & BIT(idx % 32);
-}
-
 static inline void
 mt76_wcid_mask_set(u32 *mask, int idx)
 {
-- 
2.25.1

