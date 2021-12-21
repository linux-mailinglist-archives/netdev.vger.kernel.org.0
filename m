Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7730847B837
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbhLUCGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234490AbhLUCDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:03:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E568C08C5D1;
        Mon, 20 Dec 2021 18:01:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 232C361362;
        Tue, 21 Dec 2021 02:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A530C36AE5;
        Tue, 21 Dec 2021 02:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052116;
        bh=gUYiOe2W9fOWmiSuSneBgJNt6HfaOsj+OcYlnUJjZqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejtRzi6070sbWQtLrJ3Plj9TX0RGPX0wMl93bnB9WgJZz6W0TIlMsdyhJsXr0Gncp
         lyNN89EtWEokfXPYDUkFigPnzzX6HCBQoZ3/llKA3TClDempVPCgAhbEz4+4NItaAu
         O9L94OXPEeuh6PeHDYp+obaHXqFllQ9WzvKuwMCkKoXECHq0UcJDPNJxcIV1s+SsHA
         xTkMd1rhukmKNMs1InFJP7AfyI+2AuYsTLUp5YA+kbgNQt3LyFQPoopO41YidOt3Ri
         5kF4mxkzA/OKc1LlrnsG7RrO4NpsneAkddrBMZqMrx69tQx0Nb9WDsIjdsjHI4mhTW
         h9o62UpzkbInQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Jesionowski <jesionowskigreg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 8/9] net: usb: lan78xx: add Allied Telesis AT29M2-AF
Date:   Mon, 20 Dec 2021 21:01:22 -0500
Message-Id: <20211221020123.117380-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020123.117380-1-sashal@kernel.org>
References: <20211221020123.117380-1-sashal@kernel.org>
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
index 838b6fe9dfaaf..dc8afd5575fe2 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -74,6 +74,8 @@
 #define LAN7801_USB_PRODUCT_ID		(0x7801)
 #define LAN78XX_EEPROM_MAGIC		(0x78A5)
 #define LAN78XX_OTP_MAGIC		(0x78F3)
+#define AT29M2AF_USB_VENDOR_ID		(0x07C9)
+#define AT29M2AF_USB_PRODUCT_ID	(0x0012)
 
 #define	MII_READ			1
 #define	MII_WRITE			0
@@ -4015,6 +4017,10 @@ static const struct usb_device_id products[] = {
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

