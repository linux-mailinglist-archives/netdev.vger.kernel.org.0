Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B19270B8B
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 09:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgISHpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 03:45:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13723 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbgISHpO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 03:45:14 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DCEF03F5BB19D8BCD646;
        Sat, 19 Sep 2020 15:45:11 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Sat, 19 Sep 2020
 15:45:05 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <grygorii.strashko@ti.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <kpsingh@chromium.org>, <linux-omap@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net: ethernet: ti: cpsw: use true,false for bool variables
Date:   Sat, 19 Sep 2020 15:46:17 +0800
Message-ID: <20200919074617.3460645-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses the following coccinelle warning:

drivers/net/ethernet/ti/cpsw.c:1599:2-17: WARNING: Assignment of 0/1 to
bool variable
drivers/net/ethernet/ti/cpsw.c:1300:2-17: WARNING: Assignment of 0/1 to
bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/ti/cpsw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9b425f184f3c..9fd1f77190ad 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1291,7 +1291,7 @@ static int cpsw_probe_dt(struct cpsw_platform_data *data,
 	data->mac_control = prop;
 
 	if (of_property_read_bool(node, "dual_emac"))
-		data->dual_emac = 1;
+		data->dual_emac = true;
 
 	/*
 	 * Populate all the child nodes here...
@@ -1590,7 +1590,7 @@ static int cpsw_probe(struct platform_device *pdev)
 
 	soc = soc_device_match(cpsw_soc_devices);
 	if (soc)
-		cpsw->quirk_irq = 1;
+		cpsw->quirk_irq = true;
 
 	data = &cpsw->data;
 	cpsw->slaves = devm_kcalloc(dev,
-- 
2.25.4

