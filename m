Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED491C5067
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgEEIdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:33:47 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3411 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbgEEIdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 04:33:46 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F17FEFE53B4BF7EC7C92;
        Tue,  5 May 2020 16:33:21 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 16:33:15 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: sun: cassini: Remove unused inline functions
Date:   Tue, 5 May 2020 16:33:12 +0800
Message-ID: <20200505083312.52312-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no callers in-tree anymore.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/sun/cassini.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 3ee6ab104cb9..e6e25960da4f 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -237,12 +237,6 @@ static inline void cas_lock_tx(struct cas *cp)
 		spin_lock_nested(&cp->tx_lock[i], i);
 }
 
-static inline void cas_lock_all(struct cas *cp)
-{
-	spin_lock_irq(&cp->lock);
-	cas_lock_tx(cp);
-}
-
 /* WTZ: QA was finding deadlock problems with the previous
  * versions after long test runs with multiple cards per machine.
  * See if replacing cas_lock_all with safer versions helps. The
@@ -266,12 +260,6 @@ static inline void cas_unlock_tx(struct cas *cp)
 		spin_unlock(&cp->tx_lock[i - 1]);
 }
 
-static inline void cas_unlock_all(struct cas *cp)
-{
-	cas_unlock_tx(cp);
-	spin_unlock_irq(&cp->lock);
-}
-
 #define cas_unlock_all_restore(cp, flags) \
 do { \
 	struct cas *xxxcp = (cp); \
-- 
2.17.1


