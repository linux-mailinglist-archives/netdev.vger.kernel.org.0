Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460AB1C50AE
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 10:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgEEInZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 04:43:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:48554 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725915AbgEEInZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 04:43:25 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9E70EEA5BFBC82BBE8BC;
        Tue,  5 May 2020 16:43:20 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 16:43:13 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <joabreu@synopsys.com>, <davem@davemloft.net>,
        <mcoquelin.stm32@gmail.com>
CC:     <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] net: stmmac: Remove unused inline function stmmac_rx_threshold_count
Date:   Tue, 5 May 2020 16:42:56 +0800
Message-ID: <20200505084256.52048-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no caller in-tree since
commit 2af6106ae949 ("net: stmmac: Introducing support for Page Pool")

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ff22f274aa43..90bddca1ddd8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3543,15 +3543,6 @@ static void stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
 	}
 }
 
-
-static inline int stmmac_rx_threshold_count(struct stmmac_rx_queue *rx_q)
-{
-	if (rx_q->rx_zeroc_thresh < STMMAC_RX_THRESH)
-		return 0;
-
-	return 1;
-}
-
 /**
  * stmmac_rx_refill - refill used skb preallocated buffers
  * @priv: driver private structure
-- 
2.17.1


