Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09973622BD4
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKIMqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiKIMqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:46:14 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B5912CDF5;
        Wed,  9 Nov 2022 04:46:12 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N6l4Y18F1zJnDr;
        Wed,  9 Nov 2022 20:43:09 +0800 (CST)
Received: from localhost.localdomain (10.175.103.91) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 20:46:10 +0800
From:   Wei Li <liwei391@huawei.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <huawei.libin@huawei.com>
Subject: [PATCH v2] wifi: rtlwifi: Correct header guards of rtl8188ee/rtl8723ae/rtl8192de
Date:   Wed, 9 Nov 2022 20:44:45 +0800
Message-ID: <20221109124445.3246937-1-liwei391@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The header guards of rtl8188ee/rtl8723ae/rtl8192de are promiscuous
currently. Rename them to be consistent with their module names.

Fixes: f0eb856e0b6c ("rtlwifi: rtl8188ee: Add new driver")
Fixes: c592e631bcec ("rtlwifi: rtl8723ae: Add new driver")
Fixes: 4f01358e5b8a ("rtlwifi: rtl8192de: Merge dynamic management routines")
Signed-off-by: Wei Li <liwei391@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h  | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h     | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h    | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h    | 4 ++--
 16 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
index edcca42c7464..2f88a6faf535 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/def.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL92C_DEF_H__
-#define __RTL92C_DEF_H__
+#ifndef __RTL88EE_DEF_H__
+#define __RTL88EE_DEF_H__
 
 #define HAL_PRIME_CHNL_OFFSET_DONT_CARE			0
 #define HAL_PRIME_CHNL_OFFSET_LOWER			1
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h
index eb8090caeec2..1573d277a920 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/dm.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef	__RTL88E_DM_H__
-#define __RTL88E_DM_H__
+#ifndef	__RTL88EE_DM_H__
+#define __RTL88EE_DM_H__
 
 #define	MAIN_ANT					0
 #define	AUX_ANT						1
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h
index 79f095e47d71..863ddcd98202 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/fw.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL92C__FW__H__
-#define __RTL92C__FW__H__
+#ifndef __RTL88EE__FW__H__
+#define __RTL88EE__FW__H__
 
 #define FW_8192C_SIZE				0x8000
 #define FW_8192C_START_ADDRESS			0x1000
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
index fd09b0712d17..3140b6938ffd 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL92CE_HW_H__
-#define __RTL92CE_HW_H__
+#ifndef __RTL88EE_HW_H__
+#define __RTL88EE_HW_H__
 
 void rtl88ee_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val);
 void rtl88ee_read_eeprom_info(struct ieee80211_hw *hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h
index 67d3dc389ba0..da8a1af3606d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/led.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL92CE_LED_H__
-#define __RTL92CE_LED_H__
+#ifndef __RTL88EE_LED_H__
+#define __RTL88EE_LED_H__
 
 void rtl88ee_init_sw_leds(struct ieee80211_hw *hw);
 void rtl88ee_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
index 8157ef419eeb..1fa9fd0d472a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL92C_PHY_H__
-#define __RTL92C_PHY_H__
+#ifndef __RTL88EE_PHY_H__
+#define __RTL88EE_PHY_H__
 
 /* MAX_TX_COUNT must always set to 4, otherwise read efuse
  * table secquence will be wrong.
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
index 42e222c1795f..e1d6df65c5c4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/pwrseq.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL8723E_PWRSEQ_H__
-#define __RTL8723E_PWRSEQ_H__
+#ifndef __RTL88EE_PWRSEQ_H__
+#define __RTL88EE_PWRSEQ_H__
 
 #include "../pwrseqcmd.h"
 /* Check document WM-20110607-Paul-RTL8188EE_Power_Architecture-R02.vsd
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
index 0fc8db8916fa..6392f2e24ac1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL92C_REG_H__
-#define __RTL92C_REG_H__
+#ifndef __RTL88EE_REG_H__
+#define __RTL88EE_REG_H__
 
 #define TXPKT_BUF_SELECT				0x69
 #define RXPKT_BUF_SELECT				0xA5
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h
index 05e27b40b2a9..76cb4cd2b5a2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/rf.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL92C_RF_H__
-#define __RTL92C_RF_H__
+#ifndef __RTL88EE_RF_H__
+#define __RTL88EE_RF_H__
 
 #define RF6052_MAX_TX_PWR		0x3F
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h
index df6065602401..dd4eee147b4c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/table.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL92CE_TABLE__H_
-#define __RTL92CE_TABLE__H_
+#ifndef __RTL88EE_TABLE__H_
+#define __RTL88EE_TABLE__H_
 
 #include <linux/types.h>
 #define  RTL8188EEPHY_REG_1TARRAYLEN	382
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
index e17f70b4d199..025087026068 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2013  Realtek Corporation.*/
 
-#ifndef __RTL92CE_TRX_H__
-#define __RTL92CE_TRX_H__
+#ifndef __RTL88EE_TRX_H__
+#define __RTL88EE_TRX_H__
 
 #define TX_DESC_SIZE					64
 #define TX_DESC_AGGR_SUBFRAME_SIZE		32
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
index 939cc45bfebd..9cd9070a0281 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2012  Realtek Corporation.*/
 
-#ifndef	__RTL92C_DM_H__
-#define __RTL92C_DM_H__
+#ifndef	__RTL92D_DM_H__
+#define __RTL92D_DM_H__
 
 #define HAL_DM_DIG_DISABLE			BIT(0)
 #define HAL_DM_HIPWR_DISABLE			BIT(1)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h
index 7599c7e5ecc3..71239a24f2c7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2012  Realtek Corporation.*/
 
-#ifndef __RTL92CE_LED_H__
-#define __RTL92CE_LED_H__
+#ifndef __RTL92DE_LED_H__
+#define __RTL92DE_LED_H__
 
 void rtl92de_init_sw_leds(struct ieee80211_hw *hw);
 void rtl92de_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
index 3f9ed9b4428e..3ab4a7389012 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2012  Realtek Corporation.*/
 
-#ifndef __RTL92C__FW__H__
-#define __RTL92C__FW__H__
+#ifndef __RTL8723E__FW__H__
+#define __RTL8723E__FW__H__
 
 #define FW_8192C_SIZE					0x3000
 #define FW_8192C_START_ADDRESS			0x1000
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h
index 9f85845d23cd..372f02409dda 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2012  Realtek Corporation.*/
 
-#ifndef __RTL92CE_LED_H__
-#define __RTL92CE_LED_H__
+#ifndef __RTL8723E_LED_H__
+#define __RTL8723E_LED_H__
 
 void rtl8723e_init_sw_leds(struct ieee80211_hw *hw);
 void rtl8723e_sw_led_on(struct ieee80211_hw *hw, struct rtl_led *pled);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
index 98bfe02f66d5..40c89095fd57 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h
@@ -1,8 +1,8 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright(c) 2009-2012  Realtek Corporation.*/
 
-#ifndef __RTL92C_PHY_H__
-#define __RTL92C_PHY_H__
+#ifndef __RTL8723E_PHY_H__
+#define __RTL8723E_PHY_H__
 
 #define MAX_PRECMD_CNT				16
 #define MAX_RFDEPENDCMD_CNT			16
-- 
2.25.1

