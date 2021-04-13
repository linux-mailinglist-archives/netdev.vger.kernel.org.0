Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8813935DBD1
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 11:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241598AbhDMJwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 05:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240692AbhDMJwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 05:52:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A99AC06138F
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 02:52:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWFiQ-0002SB-GN
        for netdev@vger.kernel.org; Tue, 13 Apr 2021 11:52:14 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 80AFE60DA83
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:52:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 3FAE960DA51;
        Tue, 13 Apr 2021 09:52:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c5eee2af;
        Tue, 13 Apr 2021 09:52:02 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: [net-next 06/14] can: peak_usb: pcan_usb_pro.h: remove double space in indention
Date:   Tue, 13 Apr 2021 11:51:53 +0200
Message-Id: <20210413095201.2409865-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210413095201.2409865-1-mkl@pengutronix.de>
References: <20210413095201.2409865-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch replaces the double space indention after the u8 with a
single space in pcan_usb_pro.h.

Link: https://lore.kernel.org/r/20210406111622.1874957-3-mkl@pengutronix.de
Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>
Tested-by: Stephane Grosjean <s.grosjean@peak-system.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h | 76 ++++++++++-----------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_pro.h b/drivers/net/can/usb/peak_usb/pcan_usb_pro.h
index 6f4504300e23..5d4cf14eb9d9 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_pro.h
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_pro.h
@@ -34,11 +34,11 @@
 /* PCAN_USBPRO_INFO_BL vendor request record type */
 struct __packed pcan_usb_pro_blinfo {
 	__le32 ctrl_type;
-	u8  version[4];
-	u8  day;
-	u8  month;
-	u8  year;
-	u8  dummy;
+	u8 version[4];
+	u8 day;
+	u8 month;
+	u8 year;
+	u8 dummy;
 	__le32 serial_num_hi;
 	__le32 serial_num_lo;
 	__le32 hw_type;
@@ -48,11 +48,11 @@ struct __packed pcan_usb_pro_blinfo {
 /* PCAN_USBPRO_INFO_FW vendor request record type */
 struct __packed pcan_usb_pro_fwinfo {
 	__le32 ctrl_type;
-	u8  version[4];
-	u8  day;
-	u8  month;
-	u8  year;
-	u8  dummy;
+	u8 version[4];
+	u8 day;
+	u8 month;
+	u8 year;
+	u8 dummy;
 	__le32 fw_type;
 };
 
@@ -78,39 +78,39 @@ struct __packed pcan_usb_pro_fwinfo {
 
 /* record structures */
 struct __packed pcan_usb_pro_btr {
-	u8  data_type;
-	u8  channel;
+	u8 data_type;
+	u8 channel;
 	__le16 dummy;
 	__le32 CCBT;
 };
 
 struct __packed pcan_usb_pro_busact {
-	u8  data_type;
-	u8  channel;
+	u8 data_type;
+	u8 channel;
 	__le16 onoff;
 };
 
 struct __packed pcan_usb_pro_silent {
-	u8  data_type;
-	u8  channel;
+	u8 data_type;
+	u8 channel;
 	__le16 onoff;
 };
 
 struct __packed pcan_usb_pro_filter {
-	u8  data_type;
-	u8  dummy;
+	u8 data_type;
+	u8 dummy;
 	__le16 filter_mode;
 };
 
 struct __packed pcan_usb_pro_setts {
-	u8  data_type;
-	u8  dummy;
+	u8 data_type;
+	u8 dummy;
 	__le16 mode;
 };
 
 struct __packed pcan_usb_pro_devid {
-	u8  data_type;
-	u8  channel;
+	u8 data_type;
+	u8 channel;
 	__le16 dummy;
 	__le32 serial_num;
 };
@@ -122,21 +122,21 @@ struct __packed pcan_usb_pro_devid {
 #define PCAN_USBPRO_LED_OFF		0x04
 
 struct __packed pcan_usb_pro_setled {
-	u8  data_type;
-	u8  channel;
+	u8 data_type;
+	u8 channel;
 	__le16 mode;
 	__le32 timeout;
 };
 
 struct __packed pcan_usb_pro_rxmsg {
-	u8  data_type;
-	u8  client;
-	u8  flags;
-	u8  len;
+	u8 data_type;
+	u8 client;
+	u8 flags;
+	u8 len;
 	__le32 ts32;
 	__le32 id;
 
-	u8  data[8];
+	u8 data[8];
 };
 
 #define PCAN_USBPRO_STATUS_ERROR	0x0001
@@ -145,26 +145,26 @@ struct __packed pcan_usb_pro_rxmsg {
 #define PCAN_USBPRO_STATUS_QOVERRUN	0x0008
 
 struct __packed pcan_usb_pro_rxstatus {
-	u8  data_type;
-	u8  channel;
+	u8 data_type;
+	u8 channel;
 	__le16 status;
 	__le32 ts32;
 	__le32 err_frm;
 };
 
 struct __packed pcan_usb_pro_rxts {
-	u8  data_type;
-	u8  dummy[3];
+	u8 data_type;
+	u8 dummy[3];
 	__le32 ts64[2];
 };
 
 struct __packed pcan_usb_pro_txmsg {
-	u8  data_type;
-	u8  client;
-	u8  flags;
-	u8  len;
+	u8 data_type;
+	u8 client;
+	u8 flags;
+	u8 len;
 	__le32 id;
-	u8  data[8];
+	u8 data[8];
 };
 
 union pcan_usb_pro_rec {
-- 
2.30.2


