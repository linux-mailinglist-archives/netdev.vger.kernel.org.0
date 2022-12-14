Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A204E64C3F0
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 07:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbiLNGoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 01:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiLNGn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 01:43:59 -0500
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463EF27DD3
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 22:43:57 -0800 (PST)
X-QQ-mid: bizesmtp70t1671000232ty124v04
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 14 Dec 2022 14:43:51 +0800 (CST)
X-QQ-SSF: 01400000000000H0X000B00A0000000
X-QQ-FEAT: +oIWmpEafD/jwVa2LfE5LfBKAOivAP5R0T1rJ1v4j9QdqAg5L6LJ2Z1xNCFHx
        hp6TyLFBF3gYUvrUCP+bWoAlP7KlMFP9uCXFWTnoOOxczcY2Eyki2tffbaAlxzlN9t4FPss
        SVjldg14bmVlBGyRhqPgqvdEB9VPxvquGyaPqjJKvHgo2nPwAU1VKkWzMOcjBgmIyRN7Jw7
        +G6u1MkIC1ReMiRbIS6Il+MLxAYfVfQJ6ox7hCD1IJwnp7NiS68kKshvSvKsp+gIB8qbpkR
        eG7RKP4ekfA5aeui4/CGhCNHjAPhSDFv/aNFubcsMuY2ExNrx3NLH0fwmQehQdeHC/SEchG
        i1R2uCO9Qov5jeyCdluHg+ETd5loLCeTemhgD/Wo3W7PO+mrOn270HeOTqOsMuoAl/Gxm8o
        spR8z0nZat8=
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net v2 3/5] net: txgbe: Move defines into unified file
Date:   Wed, 14 Dec 2022 14:41:31 +0800
Message-Id: <20221214064133.2424570-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
References: <20221214064133.2424570-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove txgbe.h, move defines into txgbe_type.h file.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe.h    | 23 -------------------
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c |  1 -
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  1 -
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 16 +++++++++++++
 4 files changed, 16 insertions(+), 25 deletions(-)
 delete mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe.h b/drivers/net/ethernet/wangxun/txgbe/txgbe.h
deleted file mode 100644
index 629c139926c5..000000000000
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd. */
-
-#ifndef _TXGBE_H_
-#define _TXGBE_H_
-
-#define TXGBE_MAX_FDIR_INDICES          63
-
-#define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
-#define TXGBE_MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
-
-#define TXGBE_SP_MAX_TX_QUEUES  128
-#define TXGBE_SP_MAX_RX_QUEUES  128
-#define TXGBE_SP_RAR_ENTRIES    128
-#define TXGBE_SP_MC_TBL_SIZE    128
-
-#define TXGBE_MAC_STATE_DEFAULT         0x1
-#define TXGBE_MAC_STATE_MODIFIED        0x2
-#define TXGBE_MAC_STATE_IN_USE          0x4
-
-extern char txgbe_driver_name[];
-
-#endif /* _TXGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
index 9b8826a29981..02656b5971fd 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
@@ -12,7 +12,6 @@
 #include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
-#include "txgbe.h"
 
 /**
  *  txgbe_init_thermal_sensor_thresh - Inits thermal sensor thresholds
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 980523e29f01..dcdf4e364979 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -14,7 +14,6 @@
 #include "../libwx/wx_hw.h"
 #include "txgbe_type.h"
 #include "txgbe_hw.h"
-#include "txgbe.h"
 
 char txgbe_driver_name[] = "txgbe";
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 0cc333a11cab..c4d22ceeddad 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -67,6 +67,20 @@
 #define TXGBE_PBANUM1_PTR                       0x06
 #define TXGBE_PBANUM_PTR_GUARD                  0xFAFA
 
+#define TXGBE_MAX_FDIR_INDICES          63
+
+#define TXGBE_MAX_RX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
+#define TXGBE_MAX_TX_QUEUES   (TXGBE_MAX_FDIR_INDICES + 1)
+
+#define TXGBE_SP_MAX_TX_QUEUES  128
+#define TXGBE_SP_MAX_RX_QUEUES  128
+#define TXGBE_SP_RAR_ENTRIES    128
+#define TXGBE_SP_MC_TBL_SIZE    128
+
+#define TXGBE_MAC_STATE_DEFAULT		0x1
+#define TXGBE_MAC_STATE_MODIFIED	0x2
+#define TXGBE_MAC_STATE_IN_USE		0x4
+
 struct txgbe_mac_addr {
 	u8 addr[ETH_ALEN];
 	u16 state; /* bitmask */
@@ -85,4 +99,6 @@ struct txgbe_adapter {
 	char eeprom_id[32];
 };
 
+extern char txgbe_driver_name[];
+
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

