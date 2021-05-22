Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17E238D3D0
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 07:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhEVF0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 01:26:51 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55169 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhEVF0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 01:26:51 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 14M5PES60021626, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 14M5PES60021626
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 22 May 2021 13:25:14 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Sat, 22 May 2021 13:25:13 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Sat, 22 May
 2021 13:25:12 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>
Subject: [PATCH net v2] r8152: check the informaton of the device
Date:   Sat, 22 May 2021 13:24:54 +0800
Message-ID: <1394712342-15778-364-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-363-Taiwan-albertk@realtek.com>
References: <1394712342-15778-363-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/22/2021 05:13:00
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzUvMjEgpFWkyCAxMDo0NjowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/22/2021 05:11:31
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163845 [May 22 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 446 446 0309aa129ce7cd9d810f87a68320917ac2eba541
X-KSE-AntiSpam-Info: {Headers: Prob_stat_susp_url_only, url2}
X-KSE-AntiSpam-Info: {Tracking_one_url, url3}
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;syzkaller.appspot.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/22/2021 05:13:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify some fields of the USB descriptor to make sure the driver
could be used by the device.

Besides, remove the check of endpoint number in rtl8152_probe().
It has been done in rtl_check_vendor_ok().

BugLink: https://syzkaller.appspot.com/bug?id=912c9c373656996801b4de61f1e3cb326fe940aa
Reported-by: syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com
Fixes: c2198943e33b ("r8152: search the configuration of vendor mode")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
v2:
Use usb_find_common_endpoints() and usb_endpoint_num() to replace original
code.

remove the check of endpoint number in rtl8152_probe(). It has been done
in rtl_check_vendor_ok().

 drivers/net/usb/r8152.c | 44 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 136ea06540ff..6e5230d6c721 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -8107,6 +8107,39 @@ static void r8156b_init(struct r8152 *tp)
 	tp->coalesce = 15000;	/* 15 us */
 }
 
+static bool rtl_check_vendor_ok(struct usb_interface *intf)
+{
+	struct usb_host_interface *alt = intf->cur_altsetting;
+	struct usb_endpoint_descriptor *in, *out, *intr;
+
+	if (alt->desc.bNumEndpoints < 3) {
+		dev_err(&intf->dev, "Unexpected bNumEndpoints %d\n", alt->desc.bNumEndpoints);
+		return false;
+	}
+
+	if (usb_find_common_endpoints(alt, &in, &out, &intr, NULL) < 0) {
+		dev_err(&intf->dev, "Miss Endpoints\n");
+		return false;
+	}
+
+	if (usb_endpoint_num(in) != 1) {
+		dev_err(&intf->dev, "Invalid Rx Endpoint\n");
+		return false;
+	}
+
+	if (usb_endpoint_num(out) != 2) {
+		dev_err(&intf->dev, "Invalid Tx Endpoint\n");
+		return false;
+	}
+
+	if (usb_endpoint_num(intr) != 3) {
+		dev_err(&intf->dev, "Invalid interrupt Endpoint\n");
+		return false;
+	}
+
+	return true;
+}
+
 static bool rtl_vendor_mode(struct usb_interface *intf)
 {
 	struct usb_host_interface *alt = intf->cur_altsetting;
@@ -8115,12 +8148,15 @@ static bool rtl_vendor_mode(struct usb_interface *intf)
 	int i, num_configs;
 
 	if (alt->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC)
-		return true;
+		return rtl_check_vendor_ok(intf);
 
 	/* The vendor mode is not always config #1, so to find it out. */
 	udev = interface_to_usbdev(intf);
 	c = udev->config;
 	num_configs = udev->descriptor.bNumConfigurations;
+	if (num_configs < 2)
+		return false;
+
 	for (i = 0; i < num_configs; (i++, c++)) {
 		struct usb_interface_descriptor	*desc = NULL;
 
@@ -8135,7 +8171,8 @@ static bool rtl_vendor_mode(struct usb_interface *intf)
 		}
 	}
 
-	WARN_ON_ONCE(i == num_configs);
+	if (i == num_configs)
+		dev_err(&intf->dev, "Unexpected Device\n");
 
 	return false;
 }
@@ -9381,9 +9418,6 @@ static int rtl8152_probe(struct usb_interface *intf,
 	if (!rtl_vendor_mode(intf))
 		return -ENODEV;
 
-	if (intf->cur_altsetting->desc.bNumEndpoints < 3)
-		return -ENODEV;
-
 	usb_reset_device(udev);
 	netdev = alloc_etherdev(sizeof(struct r8152));
 	if (!netdev) {
-- 
2.26.3

