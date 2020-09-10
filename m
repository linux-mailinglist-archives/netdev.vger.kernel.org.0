Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEF626528C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgIJVUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:20:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:11796 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731118AbgIJO0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 10:26:02 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 985C9E1D2419A1DEE8BB;
        Thu, 10 Sep 2020 22:05:42 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 10 Sep 2020
 22:05:33 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <arend.vanspriel@broadcom.com>, <franky.lin@broadcom.com>,
        <hante.meuleman@broadcom.com>, <chi-hsien.lin@cypress.com>,
        <wright.feng@cypress.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <lee.jones@linaro.org>,
        <yanaijie@huawei.com>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <brcm80211-dev-list@cypress.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] brcmsmac: phy_lcn: Eliminate defined but not used 'lcnphy_rx_iqcomp_table_rev0'
Date:   Thu, 10 Sep 2020 22:04:55 +0800
Message-ID: <20200910140455.1168174-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c:361:25:
warning: ‘lcnphy_rx_iqcomp_table_rev0’ defined but not used
[-Wunused-const-variable=]
  361 | struct lcnphy_rx_iqcomp lcnphy_rx_iqcomp_table_rev0[] = {
      |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
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
2.25.4

