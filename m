Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCE21B703F
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 11:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgDXJFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 05:05:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:49544 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725868AbgDXJFR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 05:05:17 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CB1285328B0C5F59B08A;
        Fri, 24 Apr 2020 17:05:14 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Fri, 24 Apr 2020
 17:05:05 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: sched: remove unused inline function qdisc_reset_all_tx
Date:   Fri, 24 Apr 2020 17:04:50 +0800
Message-ID: <20200424090450.44532-1-yuehaibing@huawei.com>
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
 include/net/sch_generic.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 25d2ec4c8f00..1862bf5a105b 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -710,11 +710,6 @@ static inline void qdisc_reset_all_tx_gt(struct net_device *dev, unsigned int i)
 	}
 }
 
-static inline void qdisc_reset_all_tx(struct net_device *dev)
-{
-	qdisc_reset_all_tx_gt(dev, 0);
-}
-
 /* Are all TX queues of the device empty?  */
 static inline bool qdisc_all_tx_empty(const struct net_device *dev)
 {
-- 
2.17.1


