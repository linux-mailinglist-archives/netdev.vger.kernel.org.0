Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63D126FA64
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgIRKTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:19:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56782 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726760AbgIRKSY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 06:18:24 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 54F2C73931506DA55A2C;
        Fri, 18 Sep 2020 18:18:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 18:18:11 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 2/9] rtlwifi: rtl8192c: fix comparison to bool warning in phy_common.c
Date:   Fri, 18 Sep 2020 18:24:58 +0800
Message-ID: <20200918102505.16036-3-zhengbin13@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c:1106:14-18: WARNING: Comparison to bool

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
index fc6c81291cf5..6a3deca404b9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -1103,7 +1103,7 @@ static void _rtl92c_phy_path_adda_on(struct ieee80211_hw *hw,
 	u32 i;

 	pathon = is_patha_on ? 0x04db25a4 : 0x0b1b25a4;
-	if (false == is2t) {
+	if (!is2t) {
 		pathon = 0x0bdb25a0;
 		rtl_set_bbreg(hw, addareg[0], MASKDWORD, 0x0b1b25a0);
 	} else {
--
2.26.0.106.g9fadedd

