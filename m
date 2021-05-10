Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E46E379066
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbhEJONc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:13:32 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:2296 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbhEJOLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 10:11:25 -0400
Received: from dggeml761-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Ff2s75Y7Yz19NV0;
        Mon, 10 May 2021 22:06:03 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggeml761-chm.china.huawei.com (10.1.199.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 10 May 2021 22:10:16 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 10 May 2021 22:10:15 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        linux-stm32 <linux-stm32@st-md-mailman.stormreply.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] net: stmmac: platform: Delete a redundant condition branch
Date:   Mon, 10 May 2021 22:10:02 +0800
Message-ID: <20210510141002.4013-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The statement of the last "if (xxx)" branch is the same as the "else"
branch. Delete it to simplify code.

No functional change.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 1e17a23d9118506..97a1fedcc9ac04d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -230,8 +230,6 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_WFQ;
 	else if (of_property_read_bool(tx_node, "snps,tx-sched-dwrr"))
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_DWRR;
-	else if (of_property_read_bool(tx_node, "snps,tx-sched-sp"))
-		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
 	else
 		plat->tx_sched_algorithm = MTL_TX_ALGORITHM_SP;
 
-- 
2.26.0.106.g9fadedd


