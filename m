Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AE1351A36
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbhDAR6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:58:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:15897 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236811AbhDARzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:55:20 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FB4vv0fw9zkbyt;
        Thu,  1 Apr 2021 22:15:23 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Thu, 1 Apr 2021
 22:17:03 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>
Subject: [PATCH -next] lan743x: remove redundant semi-colon
Date:   Thu, 1 Apr 2021 22:20:15 +0800
Message-ID: <20210401142015.1685712-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 1c3e204d727c..e7ab5f3f73fd 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3004,7 +3004,7 @@ static int lan743x_pm_suspend(struct device *dev)
 		lan743x_pm_set_wol(adapter);
 
 	/* Host sets PME_En, put D3hot */
-	return pci_prepare_to_sleep(pdev);;
+	return pci_prepare_to_sleep(pdev);
 }
 
 static int lan743x_pm_resume(struct device *dev)
-- 
2.25.1

