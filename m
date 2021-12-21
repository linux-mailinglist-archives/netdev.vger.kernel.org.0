Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653EC47B7EE
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhLUCDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:03:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57192 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233807AbhLUCBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:01:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E321861374;
        Tue, 21 Dec 2021 02:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1FDC36AE9;
        Tue, 21 Dec 2021 02:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052081;
        bh=3Fx+plQnDxek1aXv+EWd25LWq6o40PKKvSKu0fby3f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlEg5BsqK0b9apM5roFFN6eNhs0Emhrdat9bMcrOArHwDfFaLWNtHgMk55fQdhipW
         j+fR2OTPFSNC14kI8ubi+J+vJ56nT/5yKoCocshaYdLp2Yvic5ErDqCCFwGCYXMmTD
         hU3EN+JDtthwT0CPGjiElVvYHnz1skgDkSShaDxcYMnMUoeyof70x9DoxwV5TWhVCn
         ixe1DBpbhCaINhdhazoBNSTBZFfi7EoiBPfGQzY9G9NRgBNuL7xf6N/CK48cJU5rCw
         sfEF1iPE1PC/YY/NSVWDjWR3ajOGEHofUeAWaiGy9yBpDcfIhLCImDppBV6QsBBak2
         XYoLEJ2IrjVEg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Jesionowski <jesionowskigreg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 10/11] net: usb: lan78xx: add Allied Telesis AT29M2-AF
Date:   Mon, 20 Dec 2021 21:00:29 -0500
Message-Id: <20211221020030.117225-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020030.117225-1-sashal@kernel.org>
References: <20211221020030.117225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Jesionowski <jesionowskigreg@gmail.com>

[ Upstream commit ef8a0f6eab1ca5d1a75c242c5c7b9d386735fa0a ]

This adds the vendor and product IDs for the AT29M2-AF which is a
lan7801-based device.

Signed-off-by: Greg Jesionowski <jesionowskigreg@gmail.com>
Link: https://lore.kernel.org/r/20211214221027.305784-1-jesionowskigreg@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index b328207c04555..6e5988f23077e 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -75,6 +75,8 @@
 #define LAN7801_USB_PRODUCT_ID		(0x7801)
 #define LAN78XX_EEPROM_MAGIC		(0x78A5)
 #define LAN78XX_OTP_MAGIC		(0x78F3)
+#define AT29M2AF_USB_VENDOR_ID		(0x07C9)
+#define AT29M2AF_USB_PRODUCT_ID	(0x0012)
 
 #define	MII_READ			1
 #define	MII_WRITE			0
@@ -4172,6 +4174,10 @@ static const struct usb_device_id products[] = {
 	/* LAN7801 USB Gigabit Ethernet Device */
 	USB_DEVICE(LAN78XX_USB_VENDOR_ID, LAN7801_USB_PRODUCT_ID),
 	},
+	{
+	/* ATM2-AF USB Gigabit Ethernet Device */
+	USB_DEVICE(AT29M2AF_USB_VENDOR_ID, AT29M2AF_USB_PRODUCT_ID),
+	},
 	{},
 };
 MODULE_DEVICE_TABLE(usb, products);
-- 
2.34.1

