Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD05620C5B
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbiKHJgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbiKHJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:36:10 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822A6220ED;
        Tue,  8 Nov 2022 01:36:09 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N62v02zL1zpWG3;
        Tue,  8 Nov 2022 17:32:28 +0800 (CST)
Received: from localhost.localdomain (10.175.103.91) by
 canpemm500002.china.huawei.com (7.192.104.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 17:36:07 +0800
From:   Wei Li <liwei391@huawei.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <huawei.libin@huawei.com>
Subject: [PATCH v1 2/3] rtlwifi: rtl8723ae: Correct the header guard of rtl8723ae/{fw,led,phy}.h
Date:   Tue, 8 Nov 2022 17:34:46 +0800
Message-ID: <20221108093447.3588889-3-liwei391@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221108093447.3588889-1-liwei391@huawei.com>
References: <20221108093447.3588889-1-liwei391@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500002.china.huawei.com (7.192.104.244)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the header guard of rtl8723ae/{fw,led,phy}.h from __RTL92C* to
__RTL8723E* that corresponding with the module name.

Fixes: c592e631bcec ("rtlwifi: rtl8723ae: Add new driver")
Signed-off-by: Wei Li <liwei391@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/fw.h  | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/led.h | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

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

