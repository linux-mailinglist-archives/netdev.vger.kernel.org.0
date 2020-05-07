Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33A51C87A6
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgEGLJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:09:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3842 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725809AbgEGLJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:09:25 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 85E8F700756EB12A2722;
        Thu,  7 May 2020 19:09:23 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 7 May 2020
 19:09:16 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <jcliburn@gmail.com>, <chris.snook@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH net-next] net: atheros: remove dead code in atl1c_resume()
Date:   Thu, 7 May 2020 19:08:36 +0800
Message-ID: <20200507110836.37859-1-yanaijie@huawei.com>
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

This code has been marked dead for nearly 10 years. Remove it.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 04bc53af12d9..decab9a8e4a8 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2449,12 +2449,6 @@ static int atl1c_resume(struct device *dev)
 	atl1c_reset_mac(&adapter->hw);
 	atl1c_phy_init(&adapter->hw);
 
-#if 0
-	AT_READ_REG(&adapter->hw, REG_PM_CTRLSTAT, &pm_data);
-	pm_data &= ~PM_CTRLSTAT_PME_EN;
-	AT_WRITE_REG(&adapter->hw, REG_PM_CTRLSTAT, pm_data);
-#endif
-
 	netif_device_attach(netdev);
 	if (netif_running(netdev))
 		atl1c_up(adapter);
-- 
2.21.1

