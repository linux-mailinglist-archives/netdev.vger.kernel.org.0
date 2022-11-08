Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310D1620C5A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiKHJgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233739AbiKHJgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:36:12 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E721ADBE;
        Tue,  8 Nov 2022 01:36:10 -0800 (PST)
Received: from canpemm500002.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N62vm1grXzHqP8;
        Tue,  8 Nov 2022 17:33:08 +0800 (CST)
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
Subject: [PATCH v1 3/3] rtlwifi: rtl8192de: Correct the header guard of rtl8192de/{dm,led}.h
Date:   Tue, 8 Nov 2022 17:34:47 +0800
Message-ID: <20221108093447.3588889-4-liwei391@huawei.com>
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

Rename the header guard of rtl8192de/{dm,led}.h from __RTL92C* to
__RTL92D* that corresponding with the module name.

Fixes: 4f01358e5b8a ("rtlwifi: rtl8192de: Merge dynamic management routines")
Signed-off-by: Wei Li <liwei391@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h  | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/led.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

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
-- 
2.25.1

