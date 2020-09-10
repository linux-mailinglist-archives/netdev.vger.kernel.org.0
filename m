Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105B5263BA7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 05:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgIJD4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 23:56:23 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55858 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbgIJD4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 23:56:21 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4A242310023CDB6C3C49;
        Thu, 10 Sep 2020 11:56:18 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 11:56:12 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <lee.jones@linaro.org>
CC:     <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] brcmsmac: phy_lcn: Remove unused variable lcnphy_rx_iqcomp_table_rev0
Date:   Thu, 10 Sep 2020 11:56:00 +0800
Message-ID: <20200910035600.21736-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:361:25: warning: ‘lcnphy_rx_iqcomp_table_rev0’ defined but not used [-Wunused-const-variable=]
 struct lcnphy_rx_iqcomp lcnphy_rx_iqcomp_table_rev0[] = {
                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~

commit 38c95e0258a0 ("brcmsmac: phy_lcn: Remove a bunch of unused variables")
left behind this, remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c | 55 -------------------
 1 file changed, 55 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
index b8193c99e864..7071b63042cd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -357,61 +357,6 @@ u16 rxiq_cal_rf_reg[11] = {
 	RADIO_2064_REG12A,
 };
 
-static const
-struct lcnphy_rx_iqcomp lcnphy_rx_iqcomp_table_rev0[] = {
-	{1, 0, 0},
-	{2, 0, 0},
-	{3, 0, 0},
-	{4, 0, 0},
-	{5, 0, 0},
-	{6, 0, 0},
-	{7, 0, 0},
-	{8, 0, 0},
-	{9, 0, 0},
-	{10, 0, 0},
-	{11, 0, 0},
-	{12, 0, 0},
-	{13, 0, 0},
-	{14, 0, 0},
-	{34, 0, 0},
-	{38, 0, 0},
-	{42, 0, 0},
-	{46, 0, 0},
-	{36, 0, 0},
-	{40, 0, 0},
-	{44, 0, 0},
-	{48, 0, 0},
-	{52, 0, 0},
-	{56, 0, 0},
-	{60, 0, 0},
-	{64, 0, 0},
-	{100, 0, 0},
-	{104, 0, 0},
-	{108, 0, 0},
-	{112, 0, 0},
-	{116, 0, 0},
-	{120, 0, 0},
-	{124, 0, 0},
-	{128, 0, 0},
-	{132, 0, 0},
-	{136, 0, 0},
-	{140, 0, 0},
-	{149, 0, 0},
-	{153, 0, 0},
-	{157, 0, 0},
-	{161, 0, 0},
-	{165, 0, 0},
-	{184, 0, 0},
-	{188, 0, 0},
-	{192, 0, 0},
-	{196, 0, 0},
-	{200, 0, 0},
-	{204, 0, 0},
-	{208, 0, 0},
-	{212, 0, 0},
-	{216, 0, 0},
-};
-
 static const u32 lcnphy_23bitgaincode_table[] = {
 	0x200100,
 	0x200200,
-- 
2.17.1


