Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298912A5000
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbgKCTWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:22:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:58366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729316AbgKCTWd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:22:33 -0500
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B676722264;
        Tue,  3 Nov 2020 19:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604431352;
        bh=jJsoyesVDSYVelMAArhDX0NsOSp89IP5P45MZ3MnLVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wUQP8PkCQ6iotGpSVnPxOp8nkgeiNd+aW7vV2niR+DZeZjvEuLq1CivkAm3AKPNZ2
         XByuK1sCJnO9aLCrnEYdbEIkXmLRuvPAKq/ljEevz7NJrzkLKunuHI1lHAvrSz1on3
         zJFWoKOOjRteE1ysR9nNsGKWtBfgIPrNAHXXFcdU=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 2/5] r8152: cosmetic improvement of product table macro
Date:   Tue,  3 Nov 2020 20:22:23 +0100
Message-Id: <20201103192226.2455-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103192226.2455-1-kabel@kernel.org>
References: <20201103192226.2455-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve macro REALTEK_USB_DEVICE cosmetically so that it defines
complete members.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/usb/r8152.c | 44 ++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 85dda591c838..96bef1c027f2 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6862,33 +6862,31 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 }
 
 #define REALTEK_USB_DEVICE(vend, prod)	\
-	USB_DEVICE_INTERFACE_CLASS(vend, prod, USB_CLASS_VENDOR_SPEC) \
-}, \
-{ \
-	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
+	{ USB_DEVICE_INTERFACE_CLASS(vend, prod, USB_CLASS_VENDOR_SPEC) }, \
+	{ USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
 				      USB_CDC_SUBCLASS_ETHERNET, \
-				      USB_CDC_PROTO_NONE)
+				      USB_CDC_PROTO_NONE) }
 
 /* table of devices that work with this driver */
 static const struct usb_device_id rtl8152_table[] = {
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153)},
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
-	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},
-	{REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601)},
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8050),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8152),
+	REALTEK_USB_DEVICE(VENDOR_ID_REALTEK, 0x8153),
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
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387),
+	REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041),
+	REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff),
+	REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601),
 	{}
 };
 
-- 
2.26.2

