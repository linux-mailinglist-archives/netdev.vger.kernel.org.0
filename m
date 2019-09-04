Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D099A7977
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 05:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbfIDDtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 23:49:42 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55870 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728113AbfIDDtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 23:49:32 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5B4DD19C5E16080E67A6;
        Wed,  4 Sep 2019 11:49:30 +0800 (CST)
Received: from linux-ibm.site (10.175.102.37) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Wed, 4 Sep 2019 11:49:19 +0800
From:   zhong jiang <zhongjiang@huawei.com>
To:     <davem@davemloft.net>, <kvalo@codeaurora.org>, <pkshih@realtek.com>
CC:     <zhongjiang@huawei.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] rtlwifi: Remove an unnecessary continue in _rtl8723be_phy_config_bb_with_pgheaderfile
Date:   Wed, 4 Sep 2019 11:46:22 +0800
Message-ID: <1567568784-9669-2-git-send-email-zhongjiang@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com>
References: <1567568784-9669-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continue is not needed at the bottom of a loop. Hence just drop it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
index aa8a095..4805b84 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c
@@ -732,7 +732,6 @@ static bool _rtl8723be_phy_config_bb_with_pgheaderfile(struct ieee80211_hw *hw,
 				else
 					_rtl8723be_store_tx_power_by_rate(hw,
 							v1, v2, v3, v4, v5, v6);
-				continue;
 			}
 		}
 	} else {
-- 
1.7.12.4

