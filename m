Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9561C4F88
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgEEHrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:47:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:58710 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725833AbgEEHrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:47:14 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id F2146D734242C58E3C61;
        Tue,  5 May 2020 15:47:10 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 15:47:01 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <grygorii.strashko@ti.com>, <davem@davemloft.net>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <kpsingh@chromium.org>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] net: ethernet: ti: use true,false for bool variables in cpsw_new.c
Date:   Tue, 5 May 2020 15:46:23 +0800
Message-ID: <20200505074623.22541-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/ethernet/ti/cpsw_new.c:1924:2-17: WARNING: Assignment of
0/1 to bool variable
drivers/net/ethernet/ti/cpsw_new.c:1231:1-16: WARNING: Assignment of
0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/ti/cpsw_new.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 33c8dd686206..dce49311d3d3 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1228,7 +1228,7 @@ static int cpsw_probe_dt(struct cpsw_common *cpsw)
 	data->active_slave = 0;
 	data->channels = CPSW_MAX_QUEUES;
 	data->ale_entries = CPSW_ALE_NUM_ENTRIES;
-	data->dual_emac = 1;
+	data->dual_emac = true;
 	data->bd_ram_size = CPSW_BD_RAM_SIZE;
 	data->mac_control = 0;
 
@@ -1921,7 +1921,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	soc = soc_device_match(cpsw_soc_devices);
 	if (soc)
-		cpsw->quirk_irq = 1;
+		cpsw->quirk_irq = true;
 
 	cpsw->rx_packet_max = rx_packet_max;
 	cpsw->descs_pool_size = descs_pool_size;
-- 
2.21.1

