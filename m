Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D78A76B5F
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 16:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbfGZOUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 10:20:45 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3178 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbfGZOUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 10:20:44 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C6C34BC02F0C9A6CC166;
        Fri, 26 Jul 2019 22:20:41 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Fri, 26 Jul 2019
 22:20:35 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <yhchuang@realtek.com>, <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtw88: pci: remove set but not used variable 'ip_sel'
Date:   Fri, 26 Jul 2019 22:20:18 +0800
Message-ID: <20190726142018.20792-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtw88/pci.c: In function 'rtw_pci_phy_cfg':
drivers/net/wireless/realtek/rtw88/pci.c:993:6: warning:
 variable 'ip_sel' set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 23dd06a..c562515 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -990,7 +990,6 @@ static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
 	u16 cut;
 	u16 value;
 	u16 offset;
-	u16 ip_sel;
 	int i;
 
 	cut = BIT(0) << rtwdev->hal.cut_version;
@@ -1003,7 +1002,6 @@ static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
 			break;
 		offset = para->offset;
 		value = para->value;
-		ip_sel = para->ip_sel;
 		if (para->ip_sel == RTW_IP_SEL_PHY)
 			rtw_mdio_write(rtwdev, offset, value, true);
 		else
@@ -1018,7 +1016,6 @@ static void rtw_pci_phy_cfg(struct rtw_dev *rtwdev)
 			break;
 		offset = para->offset;
 		value = para->value;
-		ip_sel = para->ip_sel;
 		if (para->ip_sel == RTW_IP_SEL_PHY)
 			rtw_mdio_write(rtwdev, offset, value, false);
 		else
-- 
2.7.4


