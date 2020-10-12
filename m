Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4076A28C0C4
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391165AbgJLTGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391221AbgJLTEH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:04:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB6D722203;
        Mon, 12 Oct 2020 19:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529437;
        bh=gPTFyTuWUwLu11CjWrlX9fZdSzV2qzyV9CaIgffRU3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+0KVd9jA9HkgiANWq/Rw0nte5fG5JT/h64KU+UOcQTKTsenYTtn9CPpOIf1qj+0M
         AIACTyzY7BYZf2aOKjYk6jDrvKES31l+UxAqH0rb8v9K9pw0MbFXoPZWfAvMPNwKHK
         j8tzafdel58c3tY3wWG7t9QM2qI1vCN/CvFI5rd4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 03/11] net: usb: ax88179_178a: add Toshiba usb 3.0 adapter
Date:   Mon, 12 Oct 2020 15:03:45 -0400
Message-Id: <20201012190353.3279662-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190353.3279662-1-sashal@kernel.org>
References: <20201012190353.3279662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wilken Gottwalt <wilken.gottwalt@mailbox.org>

[ Upstream commit e42d72fea91f8f2e82b65808739ca04b7a8cd7a8 ]

Adds the driver_info and usb ids of the AX88179 based Toshiba USB 3.0
ethernet adapter.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88179_178a.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 875639b0e9d56..c248b64072ab5 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1741,6 +1741,19 @@ static const struct driver_info belkin_info = {
 	.tx_fixup = ax88179_tx_fixup,
 };
 
+static const struct driver_info toshiba_info = {
+	.description = "Toshiba USB Ethernet Adapter",
+	.bind	= ax88179_bind,
+	.unbind = ax88179_unbind,
+	.status = ax88179_status,
+	.link_reset = ax88179_link_reset,
+	.reset	= ax88179_reset,
+	.stop = ax88179_stop,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.rx_fixup = ax88179_rx_fixup,
+	.tx_fixup = ax88179_tx_fixup,
+};
+
 static const struct usb_device_id products[] = {
 {
 	/* ASIX AX88179 10/100/1000 */
@@ -1774,6 +1787,10 @@ static const struct usb_device_id products[] = {
 	/* Belkin B2B128 USB 3.0 Hub + Gigabit Ethernet Adapter */
 	USB_DEVICE(0x050d, 0x0128),
 	.driver_info = (unsigned long)&belkin_info,
+}, {
+	/* Toshiba USB 3.0 GBit Ethernet Adapter */
+	USB_DEVICE(0x0930, 0x0a13),
+	.driver_info = (unsigned long)&toshiba_info,
 },
 	{ },
 };
-- 
2.25.1

