Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084FF368FAD
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 11:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241968AbhDWJqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 05:46:16 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:47411 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241786AbhDWJqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 05:46:03 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 13N9jI5M1012520, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 13N9jI5M1012520
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 17:45:18 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 23 Apr 2021 17:45:17 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 23 Apr
 2021 17:45:16 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/2] r8152: redefine REALTEK_USB_DEVICE macro
Date:   Fri, 23 Apr 2021 17:44:55 +0800
Message-ID: <1394712342-15778-361-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-359-Taiwan-albertk@realtek.com>
References: <1394712342-15778-359-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS01.realtek.com.tw (172.21.6.94) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvMjMgpFekyCAwNjoxOTowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/23/2021 09:33:25
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163300 [Apr 23 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 443 443 d64ad0ad6f66abd85f8fb55fe5d831fdcc4c44a0
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/23/2021 09:36:00
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/23/2021 09:29:24
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163300 [Apr 23 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 443 443 d64ad0ad6f66abd85f8fb55fe5d831fdcc4c44a0
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/23/2021 09:31:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Redefine REALTEK_USB_DEVICE macro with USB_DEVICE_INTERFACE_CLASS and
USB_DEVICE_AND_INTERFACE_INFO to simply the code.

Although checkpatch.pl shows the following error, it is more readable.

	ERROR: Macros with complex values should be enclosed in parentheses

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 62 ++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 47198c125719..9986f8969d02 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9579,49 +9579,41 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 	}
 }
 
-#define REALTEK_USB_DEVICE(vend, prod)	\
-	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
-		       USB_DEVICE_ID_MATCH_INT_CLASS, \
-	.idVendor = (vend), \
-	.idProduct = (prod), \
-	.bInterfaceClass = USB_CLASS_VENDOR_SPEC \
+#define REALTEK_USB_DEVICE(vend, prod)	{ \
+	USB_DEVICE_INTERFACE_CLASS(vend, prod, USB_CLASS_VENDOR_SPEC), \
 }, \
 { \
-	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO | \
-		       USB_DEVICE_ID_MATCH_DEVICE, \
-	.idVendor = (vend), \
-	.idProduct = (prod), \
-	.bInterfaceClass = USB_CLASS_COMM, \
-	.bInterfaceSubClass = USB_CDC_SUBCLASS_ETHERNET, \
-	.bInterfaceProtocol = USB_CDC_PROTO_NONE
+	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE), \
+}
 
 /* table of devices that work with this driver */
 static const struct usb_device_id rtl8152_table[] = {
 	/* Realtek */
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8053)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8155)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8156)},
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8053),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8155),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8156),
 
 	/* Microsoft */
-	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601)},
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
+	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387),
+	REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041),
+	REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff),
+	REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601),
 	{}
 };
 
-- 
2.26.3

