Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E2A26FA5B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgIRKSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:18:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56784 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726764AbgIRKSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 06:18:24 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 470DB977F0C60CCA1C64;
        Fri, 18 Sep 2020 18:18:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 18:18:13 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 6/9] rtlwifi: rtl8192cu: fix comparison to bool warning in hw.c
Date:   Fri, 18 Sep 2020 18:25:02 +0800
Message-ID: <20200918102505.16036-7-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
In-Reply-To: <20200918102505.16036-1-zhengbin13@huawei.com>
References: <20200918102505.16036-1-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c:831:14-49: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 3061bd81f39e..6312fddd9c00 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -828,7 +828,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 					? WMM_CHIP_B_TX_PAGE_BOUNDARY
 					: WMM_CHIP_A_TX_PAGE_BOUNDARY;
 	}
-	if (false == rtl92c_init_llt_table(hw, boundary)) {
+	if (!rtl92c_init_llt_table(hw, boundary)) {
 		pr_err("Failed to init LLT Table!\n");
 		return -EINVAL;
 	}
--
2.26.0.106.g9fadedd

