Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDBFE2740D9
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgIVLbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:31:01 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56112 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726454AbgIVLbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 07:31:01 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 24B7DA009396B05D645B;
        Tue, 22 Sep 2020 19:30:56 +0800 (CST)
Received: from huawei.com (10.175.104.57) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Tue, 22 Sep 2020
 19:30:52 +0800
From:   Li Heng <liheng40@huawei.com>
To:     <ath9k-devel@qca.qualcomm.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] ath9k: Remove set but not used variable
Date:   Tue, 22 Sep 2020 19:30:52 +0800
Message-ID: <1600774252-48564-1-git-send-email-liheng40@huawei.com>
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

drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h:1338:18: warning:
‘ar9580_1p0_pcie_phy_clkreq_disable_L1’ defined but not used [-Wunused-const-variable=]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Li Heng <liheng40@huawei.com>
---
 drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
index f4c9bef..f67f537 100644
--- a/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9580_1p0_initvals.h
@@ -1335,13 +1335,6 @@ static const u32 ar9580_1p0_pcie_phy_clkreq_enable_L1[][2] = {
 	{0x00004044, 0x00000000},
 };

-static const u32 ar9580_1p0_pcie_phy_clkreq_disable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00004040, 0x0831365e},
-	{0x00004040, 0x0008003b},
-	{0x00004044, 0x00000000},
-};
-
 static const u32 ar9580_1p0_pcie_phy_pll_on_clkreq[][2] = {
 	/* Addr      allmodes  */
 	{0x00004040, 0x0831265e},
--
2.7.4

