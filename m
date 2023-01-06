Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A63C65F979
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 03:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjAFCQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 21:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjAFCQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 21:16:08 -0500
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99070564C9
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 18:16:05 -0800 (PST)
X-QQ-mid: bizesmtp69t1672971291thq9qa4s
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 06 Jan 2023 10:14:50 +0800 (CST)
X-QQ-SSF: 01400000000000H0X000000A0000000
X-QQ-FEAT: i75H2eCteEh8FelZU5PBeq2Z1AdveHYHqCC6rZiMcmIs3ydIgE14tB2sXtxjP
        WOag3ahrT4hQNrtQgWYE2l/78aby8AyBCK4XYT9KAAggn1sqZiQdT/vCqsGymOyQaPat/cG
        eqm+Q7z+TRppDMITLBh9I/kSCmVMaA7u3jsjRd8TJXyxR5CSMw8803FHXS4IhB81nfcroH/
        wHmFoM2LbHpHRDT8Qsu06Q047YZBsR2pY5w0EFKzAQC1EAHePLzzowrgyQntdZzePSCEEbV
        F6dU1vm4dwoHva3aj2noUXuBYCe91BpqpvDirvcITMyQ9ANm1hN7qcEZwzeEy752ulS4/Z8
        nqfN9tPEsPCrkN9lytM1NvJnjnHZtd2KaRNpVGfwnjZBMPxYHTHcw3ibNOv3BISVMXPEpPN
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 3/7] net: ngbe: Move defines into unified file
Date:   Fri,  6 Jan 2023 10:11:41 +0800
Message-Id: <20230106021145.2803126-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230106021145.2803126-1-jiawenwu@trustnetic.com>
References: <20230106021145.2803126-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove ngbe.h, move defines into ngbe_type.h file.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe.h      | 33 -------------------
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c   |  1 -
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h | 26 +++++++++++++++
 4 files changed, 27 insertions(+), 35 deletions(-)
 delete mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe.h b/drivers/net/ethernet/wangxun/ngbe/ngbe.h
deleted file mode 100644
index ed832ab3e5ed..000000000000
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright (c) 2019 - 2022 Beijing WangXun Technology Co., Ltd. */
-
-#ifndef _NGBE_H_
-#define _NGBE_H_
-
-#define NGBE_MAX_FDIR_INDICES		7
-
-#define NGBE_MAX_RX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
-#define NGBE_MAX_TX_QUEUES		(NGBE_MAX_FDIR_INDICES + 1)
-
-#define NGBE_ETH_LENGTH_OF_ADDRESS	6
-#define NGBE_MAX_MSIX_VECTORS		0x09
-#define NGBE_RAR_ENTRIES		32
-
-/* TX/RX descriptor defines */
-#define NGBE_DEFAULT_TXD		512 /* default ring size */
-#define NGBE_DEFAULT_TX_WORK		256
-#define NGBE_MAX_TXD			8192
-#define NGBE_MIN_TXD			128
-
-#define NGBE_DEFAULT_RXD		512 /* default ring size */
-#define NGBE_DEFAULT_RX_WORK		256
-#define NGBE_MAX_RXD			8192
-#define NGBE_MIN_RXD			128
-
-#define NGBE_MAC_STATE_DEFAULT		0x1
-#define NGBE_MAC_STATE_MODIFIED		0x2
-#define NGBE_MAC_STATE_IN_USE		0x4
-
-extern char ngbe_driver_name[];
-
-#endif /* _NGBE_H_ */
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
index d54e22ce7c31..6e06a46fe9fa 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
@@ -9,7 +9,6 @@
 #include "../libwx/wx_hw.h"
 #include "ngbe_type.h"
 #include "ngbe_hw.h"
-#include "ngbe.h"
 
 int ngbe_eeprom_chksum_hostif(struct ngbe_adapter *adapter)
 {
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 5d679c39f451..f7cb482c8053 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -14,7 +14,7 @@
 #include "../libwx/wx_hw.h"
 #include "ngbe_type.h"
 #include "ngbe_hw.h"
-#include "ngbe.h"
+
 char ngbe_driver_name[] = "ngbe";
 
 /* ngbe_pci_tbl - PCI Device ID Table
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 5a64ce6ded8f..83e73cac2953 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -90,6 +90,30 @@
 #define NGBE_FW_CMD_ST_PASS			0x80658383
 #define NGBE_FW_CMD_ST_FAIL			0x70657376
 
+#define NGBE_MAX_FDIR_INDICES			7
+
+#define NGBE_MAX_RX_QUEUES			(NGBE_MAX_FDIR_INDICES + 1)
+#define NGBE_MAX_TX_QUEUES			(NGBE_MAX_FDIR_INDICES + 1)
+
+#define NGBE_ETH_LENGTH_OF_ADDRESS		6
+#define NGBE_MAX_MSIX_VECTORS			0x09
+#define NGBE_RAR_ENTRIES			32
+
+/* TX/RX descriptor defines */
+#define NGBE_DEFAULT_TXD			512 /* default ring size */
+#define NGBE_DEFAULT_TX_WORK			256
+#define NGBE_MAX_TXD				8192
+#define NGBE_MIN_TXD				128
+
+#define NGBE_DEFAULT_RXD			512 /* default ring size */
+#define NGBE_DEFAULT_RX_WORK			256
+#define NGBE_MAX_RXD				8192
+#define NGBE_MIN_RXD				128
+
+#define NGBE_MAC_STATE_DEFAULT		0x1
+#define NGBE_MAC_STATE_MODIFIED		0x2
+#define NGBE_MAC_STATE_IN_USE		0x4
+
 enum ngbe_phy_type {
 	ngbe_phy_unknown = 0,
 	ngbe_phy_none,
@@ -177,4 +201,6 @@ struct ngbe_adapter {
 	u16 bd_number;
 };
 
+extern char ngbe_driver_name[];
+
 #endif /* _NGBE_TYPE_H_ */
-- 
2.27.0

