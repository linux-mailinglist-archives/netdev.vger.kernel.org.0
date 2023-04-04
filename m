Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5747A6D668C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 17:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbjDDPAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 11:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjDDO7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:59:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6024481
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 07:59:22 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pji80-0001op-E6
        for netdev@vger.kernel.org; Tue, 04 Apr 2023 16:59:20 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5E9BD1A689A
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 14:59:19 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9B7FA1A6876;
        Tue,  4 Apr 2023 14:59:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 80860af6;
        Tue, 4 Apr 2023 14:59:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Jimmy Assarsson <extja@kvaser.com>,
        Alexander Dahl <ada@thorsis.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 10/10] kvaser_usb: convert USB IDs to hexadecimal values
Date:   Tue,  4 Apr 2023 16:59:08 +0200
Message-Id: <20230404145908.1714400-11-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404145908.1714400-1-mkl@pengutronix.de>
References: <20230404145908.1714400-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-1.5 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

USB IDs are usually represented in 16 bit hexadecimal values. To match
the common representation in lsusb and for searching USB IDs in the
internet convert the decimal values to lowercase hexadecimal.

changes since v1: https://lore.kernel.org/all/20230327175344.4668-1-socketcan@hartkopp.net
- drop the aligned block indentation (suggested by Jimmy)
- use lowercase hex values (suggested by Alex)

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Acked-by: Jimmy Assarsson <extja@kvaser.com>
Reviewed-by: Alexander Dahl <ada@thorsis.com>
Link: https://lore.kernel.org/all/20230329090915.3127-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 102 +++++++++---------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index d4c5356d5884..7135ec851341 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -31,63 +31,63 @@
 #include "kvaser_usb.h"
 
 /* Kvaser USB vendor id. */
-#define KVASER_VENDOR_ID			0x0bfd
+#define KVASER_VENDOR_ID 0x0bfd
 
 /* Kvaser Leaf USB devices product ids */
-#define USB_LEAF_DEVEL_PRODUCT_ID		10
-#define USB_LEAF_LITE_PRODUCT_ID		11
-#define USB_LEAF_PRO_PRODUCT_ID			12
-#define USB_LEAF_SPRO_PRODUCT_ID		14
-#define USB_LEAF_PRO_LS_PRODUCT_ID		15
-#define USB_LEAF_PRO_SWC_PRODUCT_ID		16
-#define USB_LEAF_PRO_LIN_PRODUCT_ID		17
-#define USB_LEAF_SPRO_LS_PRODUCT_ID		18
-#define USB_LEAF_SPRO_SWC_PRODUCT_ID		19
-#define USB_MEMO2_DEVEL_PRODUCT_ID		22
-#define USB_MEMO2_HSHS_PRODUCT_ID		23
-#define USB_UPRO_HSHS_PRODUCT_ID		24
-#define USB_LEAF_LITE_GI_PRODUCT_ID		25
-#define USB_LEAF_PRO_OBDII_PRODUCT_ID		26
-#define USB_MEMO2_HSLS_PRODUCT_ID		27
-#define USB_LEAF_LITE_CH_PRODUCT_ID		28
-#define USB_BLACKBIRD_SPRO_PRODUCT_ID		29
-#define USB_OEM_MERCURY_PRODUCT_ID		34
-#define USB_OEM_LEAF_PRODUCT_ID			35
-#define USB_CAN_R_PRODUCT_ID			39
-#define USB_LEAF_LITE_V2_PRODUCT_ID		288
-#define USB_MINI_PCIE_HS_PRODUCT_ID		289
-#define USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID	290
-#define USB_USBCAN_LIGHT_2HS_PRODUCT_ID		291
-#define USB_MINI_PCIE_2HS_PRODUCT_ID		292
-#define USB_USBCAN_R_V2_PRODUCT_ID		294
-#define USB_LEAF_LIGHT_R_V2_PRODUCT_ID		295
-#define USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID	296
+#define USB_LEAF_DEVEL_PRODUCT_ID 0x000a
+#define USB_LEAF_LITE_PRODUCT_ID 0x000b
+#define USB_LEAF_PRO_PRODUCT_ID 0x000c
+#define USB_LEAF_SPRO_PRODUCT_ID 0x000e
+#define USB_LEAF_PRO_LS_PRODUCT_ID 0x000f
+#define USB_LEAF_PRO_SWC_PRODUCT_ID 0x0010
+#define USB_LEAF_PRO_LIN_PRODUCT_ID 0x0011
+#define USB_LEAF_SPRO_LS_PRODUCT_ID 0x0012
+#define USB_LEAF_SPRO_SWC_PRODUCT_ID 0x0013
+#define USB_MEMO2_DEVEL_PRODUCT_ID 0x0016
+#define USB_MEMO2_HSHS_PRODUCT_ID 0x0017
+#define USB_UPRO_HSHS_PRODUCT_ID 0x0018
+#define USB_LEAF_LITE_GI_PRODUCT_ID 0x0019
+#define USB_LEAF_PRO_OBDII_PRODUCT_ID 0x001a
+#define USB_MEMO2_HSLS_PRODUCT_ID 0x001b
+#define USB_LEAF_LITE_CH_PRODUCT_ID 0x001c
+#define USB_BLACKBIRD_SPRO_PRODUCT_ID 0x001d
+#define USB_OEM_MERCURY_PRODUCT_ID 0x0022
+#define USB_OEM_LEAF_PRODUCT_ID 0x0023
+#define USB_CAN_R_PRODUCT_ID 0x0027
+#define USB_LEAF_LITE_V2_PRODUCT_ID 0x0120
+#define USB_MINI_PCIE_HS_PRODUCT_ID 0x0121
+#define USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID 0x0122
+#define USB_USBCAN_LIGHT_2HS_PRODUCT_ID 0x0123
+#define USB_MINI_PCIE_2HS_PRODUCT_ID 0x0124
+#define USB_USBCAN_R_V2_PRODUCT_ID 0x0126
+#define USB_LEAF_LIGHT_R_V2_PRODUCT_ID 0x0127
+#define USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID 0x0128
 
 /* Kvaser USBCan-II devices product ids */
-#define USB_USBCAN_REVB_PRODUCT_ID		2
-#define USB_VCI2_PRODUCT_ID			3
-#define USB_USBCAN2_PRODUCT_ID			4
-#define USB_MEMORATOR_PRODUCT_ID		5
+#define USB_USBCAN_REVB_PRODUCT_ID 0x0002
+#define USB_VCI2_PRODUCT_ID 0x0003
+#define USB_USBCAN2_PRODUCT_ID 0x0004
+#define USB_MEMORATOR_PRODUCT_ID 0x0005
 
 /* Kvaser Minihydra USB devices product ids */
-#define USB_BLACKBIRD_V2_PRODUCT_ID		258
-#define USB_MEMO_PRO_5HS_PRODUCT_ID		260
-#define USB_USBCAN_PRO_5HS_PRODUCT_ID		261
-#define USB_USBCAN_LIGHT_4HS_PRODUCT_ID		262
-#define USB_LEAF_PRO_HS_V2_PRODUCT_ID		263
-#define USB_USBCAN_PRO_2HS_V2_PRODUCT_ID	264
-#define USB_MEMO_2HS_PRODUCT_ID			265
-#define USB_MEMO_PRO_2HS_V2_PRODUCT_ID		266
-#define USB_HYBRID_2CANLIN_PRODUCT_ID		267
-#define USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID	268
-#define USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID	269
-#define USB_HYBRID_PRO_2CANLIN_PRODUCT_ID	270
-#define USB_U100_PRODUCT_ID			273
-#define USB_U100P_PRODUCT_ID			274
-#define USB_U100S_PRODUCT_ID			275
-#define USB_USBCAN_PRO_4HS_PRODUCT_ID		276
-#define USB_HYBRID_CANLIN_PRODUCT_ID		277
-#define USB_HYBRID_PRO_CANLIN_PRODUCT_ID	278
+#define USB_BLACKBIRD_V2_PRODUCT_ID 0x0102
+#define USB_MEMO_PRO_5HS_PRODUCT_ID 0x0104
+#define USB_USBCAN_PRO_5HS_PRODUCT_ID 0x0105
+#define USB_USBCAN_LIGHT_4HS_PRODUCT_ID 0x0106
+#define USB_LEAF_PRO_HS_V2_PRODUCT_ID 0x0107
+#define USB_USBCAN_PRO_2HS_V2_PRODUCT_ID 0x0108
+#define USB_MEMO_2HS_PRODUCT_ID 0x0109
+#define USB_MEMO_PRO_2HS_V2_PRODUCT_ID 0x010a
+#define USB_HYBRID_2CANLIN_PRODUCT_ID 0x010b
+#define USB_ATI_USBCAN_PRO_2HS_V2_PRODUCT_ID 0x010c
+#define USB_ATI_MEMO_PRO_2HS_V2_PRODUCT_ID 0x010d
+#define USB_HYBRID_PRO_2CANLIN_PRODUCT_ID 0x010e
+#define USB_U100_PRODUCT_ID 0x0111
+#define USB_U100P_PRODUCT_ID 0x0112
+#define USB_U100S_PRODUCT_ID 0x0113
+#define USB_USBCAN_PRO_4HS_PRODUCT_ID 0x0114
+#define USB_HYBRID_CANLIN_PRODUCT_ID 0x0115
+#define USB_HYBRID_PRO_CANLIN_PRODUCT_ID 0x0116
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_hydra = {
 	.quirks = KVASER_USB_QUIRK_HAS_HARDWARE_TIMESTAMP,
-- 
2.39.2


