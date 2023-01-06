Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51B5665FA6D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjAFDmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:42:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbjAFDmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:42:13 -0500
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF9265AD9
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 19:42:06 -0800 (PST)
X-QQ-mid: bizesmtp76t1672976519tvfcxf9s
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 06 Jan 2023 11:41:58 +0800 (CST)
X-QQ-SSF: 01400000002000H0X000B00A0000000
X-QQ-FEAT: 3M0okmaRx3hpk4d2zHp6W8Nrc7mDWM9ZG4NoCsrjQ67F2wTg5EsZvaNl77jqM
        B50fkANTMMJ2uEGqSMtfuKbqnTF+x1ZaZo8QOnMtvIGnmUNVKJ6cKioMIKQmGcgp4Tnycnc
        L2nHe7bOVrLobUDDh8O2Z/RgH5sMI5UwcwCieEFiPjQaHLl/bYqkBrscdrkgtcKu05tBDYV
        ZOav4+PatyLEEVQVJHHNvoKXo/c1a5QeGs6yidkxcZ4Hbl+YlpGHCr4U5SBShWm+xQ7Uxkp
        fElck/bSyZsUH3JHSFhESJDfjK9oD7L25RrJY67pTKxVxSZWlDLy65Zxu9/PHeQCIQzjV9H
        2j5V8gD/FqEqJISqXRhwN6BRkBtQTZOGFemlMvqJmwYEG10hvkt4r4w9/8eqmoa0PE9Q/C+
        lCJb46RvmVPcciNegSYAdw==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 3/8] net: txgbe: Move defines into unified file
Date:   Fri,  6 Jan 2023 11:38:48 +0800
Message-Id: <20230106033853.2806007-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230106033853.2806007-1-jiawenwu@trustnetic.com>
References: <20230106033853.2806007-1-jiawenwu@trustnetic.com>
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
index 0536f2059db9..a657b579447c 100644
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
index 900f0f2be262..96657430fe67 100644
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

