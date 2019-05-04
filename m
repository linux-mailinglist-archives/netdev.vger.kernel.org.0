Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE3713938
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 12:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfEDKdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 06:33:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:34840 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726776AbfEDKdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 May 2019 06:33:18 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9B1C75067530B2D663B0;
        Sat,  4 May 2019 18:33:15 +0800 (CST)
Received: from localhost (10.177.31.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Sat, 4 May 2019
 18:33:08 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <yhchuang@realtek.com>, <kvalo@codeaurora.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtw88: Make some symbols static
Date:   Sat, 4 May 2019 18:32:24 +0800
Message-ID: <20190504103224.27524-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warnings:

drivers/net/wireless/realtek/rtw88/phy.c:851:4: warning: symbol 'rtw_cck_size' was not declared. Should it be static?
drivers/net/wireless/realtek/rtw88/phy.c:852:4: warning: symbol 'rtw_ofdm_size' was not declared. Should it be static?
drivers/net/wireless/realtek/rtw88/phy.c:853:4: warning: symbol 'rtw_ht_1s_size' was not declared. Should it be static?
drivers/net/wireless/realtek/rtw88/phy.c:854:4: warning: symbol 'rtw_ht_2s_size' was not declared. Should it be static?
drivers/net/wireless/realtek/rtw88/phy.c:855:4: warning: symbol 'rtw_vht_1s_size' was not declared. Should it be static?
drivers/net/wireless/realtek/rtw88/phy.c:856:4: warning: symbol 'rtw_vht_2s_size' was not declared. Should it be static?
drivers/net/wireless/realtek/rtw88/fw.c:11:6: warning: symbol 'rtw_fw_c2h_cmd_handle_ext' was not declared. Should it be static?
drivers/net/wireless/realtek/rtw88/fw.c:50:6: warning: symbol 'rtw_fw_send_h2c_command' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c  |  6 ++++--
 drivers/net/wireless/realtek/rtw88/phy.c | 13 +++++++------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index cf4265c..62847797 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -8,7 +8,8 @@
 #include "reg.h"
 #include "debug.h"
 
-void rtw_fw_c2h_cmd_handle_ext(struct rtw_dev *rtwdev, struct sk_buff *skb)
+static void rtw_fw_c2h_cmd_handle_ext(struct rtw_dev *rtwdev,
+				      struct sk_buff *skb)
 {
 	struct rtw_c2h_cmd *c2h;
 	u8 sub_cmd_id;
@@ -47,7 +48,8 @@ void rtw_fw_c2h_cmd_handle(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	}
 }
 
-void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev, u8 *h2c)
+static void rtw_fw_send_h2c_command(struct rtw_dev *rtwdev,
+				    u8 *h2c)
 {
 	u8 box;
 	u8 box_state;
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 4381b36..2105fc4 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -848,12 +848,13 @@ u8 rtw_vht_2s_rates[] = {
 	DESC_RATEVHT2SS_MCS6, DESC_RATEVHT2SS_MCS7,
 	DESC_RATEVHT2SS_MCS8, DESC_RATEVHT2SS_MCS9
 };
-u8 rtw_cck_size = ARRAY_SIZE(rtw_cck_rates);
-u8 rtw_ofdm_size = ARRAY_SIZE(rtw_ofdm_rates);
-u8 rtw_ht_1s_size = ARRAY_SIZE(rtw_ht_1s_rates);
-u8 rtw_ht_2s_size = ARRAY_SIZE(rtw_ht_2s_rates);
-u8 rtw_vht_1s_size = ARRAY_SIZE(rtw_vht_1s_rates);
-u8 rtw_vht_2s_size = ARRAY_SIZE(rtw_vht_2s_rates);
+
+static u8 rtw_cck_size = ARRAY_SIZE(rtw_cck_rates);
+static u8 rtw_ofdm_size = ARRAY_SIZE(rtw_ofdm_rates);
+static u8 rtw_ht_1s_size = ARRAY_SIZE(rtw_ht_1s_rates);
+static u8 rtw_ht_2s_size = ARRAY_SIZE(rtw_ht_2s_rates);
+static u8 rtw_vht_1s_size = ARRAY_SIZE(rtw_vht_1s_rates);
+static u8 rtw_vht_2s_size = ARRAY_SIZE(rtw_vht_2s_rates);
 u8 *rtw_rate_section[RTW_RATE_SECTION_MAX] = {
 	rtw_cck_rates, rtw_ofdm_rates,
 	rtw_ht_1s_rates, rtw_ht_2s_rates,
-- 
2.7.4


