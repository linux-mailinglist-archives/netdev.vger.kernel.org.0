Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A68274F87
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 05:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgIWDZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 23:25:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14263 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726703AbgIWDZi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 23:25:38 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 68C6DBC5F24D1962E43F;
        Wed, 23 Sep 2020 11:25:36 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Wed, 23 Sep 2020
 11:25:31 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <ath9k-devel@qca.qualcomm.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next v2] ath9k: Remove set but not used variable
Date:   Wed, 23 Sep 2020 11:25:31 +0800
Message-ID: <1600831531-8573-1-git-send-email-liheng40@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.104.57]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This addresses the following gcc warning with "make W=1":

drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h:1331:18: warning:
‘ar9580_1p0_pcie_phy_clkreq_enable_L1’ defined but not used [-Wunused-const-variable=]

drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h:1338:18: warning:
‘ar9580_1p0_pcie_phy_clkreq_disable_L1’ defined but not used [-Wunused-const-variable=]

drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h:1345:18: warning:
‘ar9580_1p0_pcie_phy_pll_on_clkreq’ defined but not used [-Wunused-const-variable=]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Heng <liheng40@huawei.com>
---
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h    | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index f4c9bef..fab14e0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -1328,27 +1328,6 @@ static const u32 ar9580_1p0_baseband_postamble[][5] = {
 	{0x0000c284, 0x00000000, 0x00000000, 0x00000150, 0x00000150},
 };

-static const u32 ar9580_1p0_pcie_phy_clkreq_enable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x0835365e},
-	{0x00004040, 0x0008003b},
-	{0x00004044, 0x00000000},
-};
-
-static const u32 ar9580_1p0_pcie_phy_clkreq_disable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x0831365e},
-	{0x00004040, 0x0008003b},
-	{0x00004044, 0x00000000},
-};
-
-static const u32 ar9580_1p0_pcie_phy_pll_on_clkreq[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x0831265e},
-	{0x00004040, 0x0008003b},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9580_1p0_baseband_postamble_dfs_channel[][3] = {
 	/* Addr      5G          2G        */
 	{0x00009814, 0x3400c00f, 0x3400c00f},
--
2.7.4

