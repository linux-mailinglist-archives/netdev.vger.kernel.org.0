Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE93ECDAF
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 08:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbfKBHw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 03:52:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5692 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfKBHw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 03:52:27 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B6E8D821B3C96911183C;
        Sat,  2 Nov 2019 15:52:19 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Sat, 2 Nov 2019
 15:52:09 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <allison@lohutok.net>, <gregkh@linuxfoundation.org>,
        <kstewart@linuxfoundation.org>, <info@metux.net>,
        <tglx@linutronix.de>, <yuehaibing@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8225se: remove some unused const variables
Date:   Sat, 2 Nov 2019 15:46:03 +0800
Message-ID: <20191102074603.38516-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:83:17: warning: 'rtl8225sez2_tx_power_cck' defined but not used [-Wunused-const-variable=]
drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:79:17: warning: 'rtl8225sez2_tx_power_cck_A' defined but not used [-Wunused-const-variable=]
drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:75:17: warning: 'rtl8225sez2_tx_power_cck_B' defined but not used [-Wunused-const-variable=]
drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:71:17: warning: 'rtl8225sez2_tx_power_cck_ch14' defined but not used [-Wunused-const-variable=]
drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:62:17: warning: 'rtl8225se_tx_power_ofdm' defined but not used [-Wunused-const-variable=]
drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:53:17: warning: 'rtl8225se_tx_power_cck_ch14' defined but not used [-Wunused-const-variable=]
drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:44:17: warning: 'rtl8225se_tx_power_cck' defined but not used [-Wunused-const-variable=]
drivers/net/wireless//realtek/rtl818x/rtl8180/rtl8225se.c:40:17: warning: 'rtl8225se_tx_gain_cck_ofdm' defined but not used [-Wunused-const-variable=]

They are never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 .../wireless/realtek/rtl818x/rtl8180/rtl8225se.c   | 42 ----------------------
 1 file changed, 42 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
index 23cd4ff..e1bf41c 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/rtl8225se.c
@@ -37,53 +37,11 @@ static const u8 cck_ofdm_gain_settings[] = {
 	0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23,
 };
 
-static const u8 rtl8225se_tx_gain_cck_ofdm[] = {
-	0x02, 0x06, 0x0e, 0x1e, 0x3e, 0x7e
-};
-
-static const u8 rtl8225se_tx_power_cck[] = {
-	0x18, 0x17, 0x15, 0x11, 0x0c, 0x08, 0x04, 0x02,
-	0x1b, 0x1a, 0x17, 0x13, 0x0e, 0x09, 0x04, 0x02,
-	0x1f, 0x1e, 0x1a, 0x15, 0x10, 0x0a, 0x05, 0x02,
-	0x22, 0x21, 0x1d, 0x18, 0x11, 0x0b, 0x06, 0x02,
-	0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03,
-	0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03
-};
-
-static const u8 rtl8225se_tx_power_cck_ch14[] = {
-	0x18, 0x17, 0x15, 0x0c, 0x00, 0x00, 0x00, 0x00,
-	0x1b, 0x1a, 0x17, 0x0e, 0x00, 0x00, 0x00, 0x00,
-	0x1f, 0x1e, 0x1a, 0x0f, 0x00, 0x00, 0x00, 0x00,
-	0x22, 0x21, 0x1d, 0x11, 0x00, 0x00, 0x00, 0x00,
-	0x26, 0x25, 0x21, 0x13, 0x00, 0x00, 0x00, 0x00,
-	0x2b, 0x2a, 0x25, 0x15, 0x00, 0x00, 0x00, 0x00
-};
-
-static const u8 rtl8225se_tx_power_ofdm[] = {
-	0x80, 0x90, 0xa2, 0xb5, 0xcb, 0xe4
-};
-
 static const u32 rtl8225se_chan[] = {
 	0x0080, 0x0100, 0x0180, 0x0200, 0x0280, 0x0300, 0x0380,
 	0x0400, 0x0480, 0x0500, 0x0580, 0x0600, 0x0680, 0x074A,
 };
 
-static const u8 rtl8225sez2_tx_power_cck_ch14[] = {
-	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00
-};
-
-static const u8 rtl8225sez2_tx_power_cck_B[] = {
-	0x30, 0x2f, 0x29, 0x21, 0x19, 0x10, 0x08, 0x04
-};
-
-static const u8 rtl8225sez2_tx_power_cck_A[] = {
-	0x33, 0x32, 0x2b, 0x23, 0x1a, 0x11, 0x08, 0x04
-};
-
-static const u8 rtl8225sez2_tx_power_cck[] = {
-	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04
-};
-
 static const u8 ZEBRA_AGC[] = {
 	0x7E, 0x7E, 0x7E, 0x7E, 0x7D, 0x7C, 0x7B, 0x7A,
 	0x79, 0x78, 0x77, 0x76, 0x75, 0x74, 0x73, 0x72,
-- 
2.7.4


