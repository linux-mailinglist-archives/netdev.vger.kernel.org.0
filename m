Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746E834FB78
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhCaIVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:21:44 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15119 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbhCaIVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:21:18 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9K3L0tcrz1BFrZ;
        Wed, 31 Mar 2021 16:19:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 16:21:05 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yixing Liu <liuyixing1@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 5/7] net: ocelot: fix a trailling format issue with block comments
Date:   Wed, 31 Mar 2021 16:18:32 +0800
Message-ID: <1617178714-14031-6-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
References: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

Use a tralling */ on a separate line for block comments.

Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 1a36b41..8d06ffa 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -484,7 +484,8 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			   DEV_MAC_ENA_CFG_TX_ENA, DEV_MAC_ENA_CFG);
 
 	/* Take MAC, Port, Phy (intern) and PCS (SGMII/Serdes) clock out of
-	 * reset */
+	 * reset
+	 */
 	ocelot_port_writel(ocelot_port, DEV_CLOCK_CFG_LINK_SPEED(speed),
 			   DEV_CLOCK_CFG);
 
-- 
2.8.1

