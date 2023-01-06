Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C72165FA6E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 04:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjAFDmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 22:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231894AbjAFDmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 22:42:15 -0500
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49E16B58A
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 19:42:09 -0800 (PST)
X-QQ-mid: bizesmtp76t1672976522tco415ic
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 06 Jan 2023 11:42:01 +0800 (CST)
X-QQ-SSF: 01400000002000H0X000B00A0000000
X-QQ-FEAT: q+EIYT+FhZohWCtKhODWJqPtCsEA02vxCwhAB9qDg57CrPIMHTpbCxxvjJ7NV
        h0rjfKbJmxfXWWCve7dyJyOGt+H7DSg8moLVsKAYTTsA4DDQQDHfmnGwDomzaljWA1d6BRz
        3NI8CMS3c7LvQQQVwi+npDWfJPkfqvvfidXOtkoSXz31ufY9c6PpStofDj/6n9hD0kX5Vor
        NzNZQejtQV3P11YYqSEAjWIPZ98kLNIOKH+ocAW1FtC1FmLSCFntjGKGy90ALnvb45SbwFL
        QgWhcfDBOExDEt+CrQQgK0tPeibWgqDeWhb7w5vDmwR+nBTyN4bMI2yszUqmXqBzA++h6gJ
        4bjs5rXhQdwmx9R7rIkOOskXYaXRgspEwyvPz1Fv6/VBERIaD/gfHzqSYAHIaYU1JjSxMPT
        hBppKxEyY3/B5CDj39ONyA==
X-QQ-GoodBg: 2
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Cc:     Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 4/8] net: ngbe: Move defines into unified file
Date:   Fri,  6 Jan 2023 11:38:49 +0800
Message-Id: <20230106033853.2806007-5-jiawenwu@trustnetic.com>
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

