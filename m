Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91932394C17
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 13:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhE2LxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 07:53:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5146 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2LxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 07:53:23 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FsfwH4BJ7zYpF7;
        Sat, 29 May 2021 19:49:03 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 19:51:44 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 29
 May 2021 19:51:44 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <Larry.Finger@lwfinger.net>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <gustavoars@kernel.org>,
        <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <b43-dev@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] b43legacy: Remove unused inline function txring_to_priority()
Date:   Sat, 29 May 2021 19:51:31 +0800
Message-ID: <20210529115131.6028-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 5d07a3d62f63 ("b43legacy: Avoid packet losses in the dma worker code")
left behind this.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/broadcom/b43legacy/dma.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/dma.c b/drivers/net/wireless/broadcom/b43legacy/dma.c
index 7e2f70c4207c..6869f2bf1bae 100644
--- a/drivers/net/wireless/broadcom/b43legacy/dma.c
+++ b/drivers/net/wireless/broadcom/b43legacy/dma.c
@@ -213,19 +213,6 @@ return dev->dma.tx_ring1;
 	return ring;
 }
 
-/* Bcm4301-ring to mac80211-queue mapping */
-static inline int txring_to_priority(struct b43legacy_dmaring *ring)
-{
-	static const u8 idx_to_prio[] =
-		{ 3, 2, 1, 0, 4, 5, };
-
-/*FIXME: have only one queue, for now */
-return 0;
-
-	return idx_to_prio[ring->index];
-}
-
-
 static u16 b43legacy_dmacontroller_base(enum b43legacy_dmatype type,
 					int controller_idx)
 {
-- 
2.17.1

