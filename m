Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED741AEA2A
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 08:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgDRGgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 02:36:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:42966 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725958AbgDRGgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 02:36:39 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CA0D7D4961E27377769F;
        Sat, 18 Apr 2020 14:36:33 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 14:36:22 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <amade@asmblr.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 3/5] rtlwifi: rtl8192ee: use true,false for bool variables
Date:   Sat, 18 Apr 2020 15:02:34 +0800
Message-ID: <20200418070236.9620-4-yanaijie@huawei.com>
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

drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c:78:1-34: WARNING:
Assignment of 0/1 to bool variable
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c:80:1-34: WARNING:
Assignment of 0/1 to bool variable

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
index b337d599b6f4..7a16563b3a5d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c
@@ -75,9 +75,9 @@ static int rtl92ee_init_sw_vars(struct ieee80211_hw *hw)
 	rtlpci->msi_support = rtlpriv->cfg->mod_params->msi_support;
 	rtlpriv->btcoexist.btc_ops = rtl_btc_get_ops_pointer();
 
-	rtlpriv->dm.dm_initialgain_enable = 1;
+	rtlpriv->dm.dm_initialgain_enable = true;
 	rtlpriv->dm.dm_flag = 0;
-	rtlpriv->dm.disable_framebursting = 0;
+	rtlpriv->dm.disable_framebursting = false;
 	rtlpci->transmit_config = CFENDFORM | BIT(15);
 
 	/*just 2.4G band*/
-- 
2.21.1

