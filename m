Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA82334C609
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhC2IEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:04:44 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:15371 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbhC2IDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:03:48 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4F84m7278zz9sLb;
        Mon, 29 Mar 2021 16:01:43 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.498.0; Mon, 29 Mar 2021 16:03:41 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sebastian.hesselbarth@gmail.com>, <thomas.petazzoni@bootlin.com>,
        <mlindner@marvell.com>, <stephen@networkplumber.org>,
        <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 1/4] net: marvell: Delete duplicate word in comments
Date:   Mon, 29 Mar 2021 16:01:09 +0800
Message-ID: <1617004872-38974-2-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617004872-38974-1-git-send-email-liweihang@huawei.com>
References: <1617004872-38974-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

Delete duplicate word in two comments.

Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 4 +---
 drivers/net/ethernet/marvell/skge.c   | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 563ceac..88545be 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4175,9 +4175,7 @@ static void mvneta_percpu_elect(struct mvneta_port *pp)
 				rxq_map |= MVNETA_CPU_RXQ_ACCESS(rxq);
 
 		if (cpu == elected_cpu)
-			/* Map the default receive queue queue to the
-			 * elected CPU
-			 */
+			/* Map the default receive queue to the elected CPU */
 			rxq_map |= MVNETA_CPU_RXQ_ACCESS(pp->rxq_def);
 
 		/* We update the TX queue map only if we have one
diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 8a9c0f4..c0882c7 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -1617,7 +1617,7 @@ static void genesis_mac_init(struct skge_hw *hw, int port)
 		xm_write16(hw, port, XM_TX_THR, 512);
 
 	/*
-	 * Enable the reception of all error frames. This is is
+	 * Enable the reception of all error frames. This is
 	 * a necessary evil due to the design of the XMAC. The
 	 * XMAC's receive FIFO is only 8K in size, however jumbo
 	 * frames can be up to 9000 bytes in length. When bad
-- 
2.8.1

