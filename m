Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68A947B79E
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhLUCAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:00:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55268 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233673AbhLUB7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:59:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74E726134A;
        Tue, 21 Dec 2021 01:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71BAC36AE5;
        Tue, 21 Dec 2021 01:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051987;
        bh=rMP0bc7nMrZYTAq7itdYID9oTaaKe53xOIDh3bvtKzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mUTCxet5OjVjp2xC5wmKtviba3HOXydyCJpC8JvsJZucqPF7/krWJmmkjSLykec1z
         +jwhoL0nXC5LHX9HnhFX+pjCsW/CKKoWD6KUuEByZFy4mpfP7WUs19UK1GzUPIgO8O
         WNJauQ64C+m6gkuI0qNdpYVg6z4ZPxikbX8RW1yEprVHEj3SWCIHKk1y3iKzXrJf/y
         iyxmhcPWnUXZdTJZ0Gu9Z34F8nqSzl/J+XcDiWybcIVGpZUvYM8iej5uNGnSiQVnoy
         ERXZyE5GL6WKA4D3Lw0Sow5vgwIkxxH4BJPGhVH+aWM+K3Euqsi7zvJAA7GOYypk7L
         0xbTMGsdOWgnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Jesionowski <jesionowskigreg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/19] net: usb: lan78xx: add Allied Telesis AT29M2-AF
Date:   Mon, 20 Dec 2021 20:59:11 -0500
Message-Id: <20211221015914.116767-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015914.116767-1-sashal@kernel.org>
References: <20211221015914.116767-1-sashal@kernel.org>
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
index c666e990900b9..6f7b70522d926 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -64,6 +64,8 @@
 #define LAN7801_USB_PRODUCT_ID		(0x7801)
 #define LAN78XX_EEPROM_MAGIC		(0x78A5)
 #define LAN78XX_OTP_MAGIC		(0x78F3)
+#define AT29M2AF_USB_VENDOR_ID		(0x07C9)
+#define AT29M2AF_USB_PRODUCT_ID	(0x0012)
 
 #define	MII_READ			1
 #define	MII_WRITE			0
@@ -4142,6 +4144,10 @@ static const struct usb_device_id products[] = {
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

