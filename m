Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161E21AEA29
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 08:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgDRGgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 02:36:38 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2356 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbgDRGgi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 02:36:38 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F30F51A42DFC22C2A0E8;
        Sat, 18 Apr 2020 14:36:33 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 14:36:24 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <amade@asmblr.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 5/5] rtlwifi: rtl8821ae: use true,false for bool variables
Date:   Sat, 18 Apr 2020 15:02:36 +0800
Message-ID: <20200418070236.9620-6-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200418070236.9620-1-yanaijie@huawei.com>
References: <20200418070236.9620-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c:79:1-34: WARNING:
Assignment of 0/1 to bool variable
drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c:81:1-34: WARNING:
Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index d8df816753cb..950542a24e31 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -76,9 +76,9 @@ static int rtl8821ae_init_sw_vars(struct ieee80211_hw *hw)
 	rtl8821ae_bt_reg_init(hw);
 	rtlpriv->btcoexist.btc_ops = rtl_btc_get_ops_pointer();
 
-	rtlpriv->dm.dm_initialgain_enable = 1;
+	rtlpriv->dm.dm_initialgain_enable = true;
 	rtlpriv->dm.dm_flag = 0;
-	rtlpriv->dm.disable_framebursting = 0;
+	rtlpriv->dm.disable_framebursting = false;
 	rtlpriv->dm.thermalvalue = 0;
 	rtlpci->transmit_config = CFENDFORM | BIT(15) | BIT(24) | BIT(25);
 
-- 
2.21.1

