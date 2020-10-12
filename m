Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4BB28C11B
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731317AbgJLTJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387933AbgJLTC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:02:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDD46214D8;
        Mon, 12 Oct 2020 19:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529375;
        bh=2wljG4LeMS7hfd/+UNGq7TdFAwYhZZvRSu5x0DBBEDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3Uxohr4empUXtSpgRdeEKa91N2YGhjd7B76wae0CCymrx631NBwhWwdNLdmQ+FsS
         Afn8Z/Ld3sHt5Dhqq5Rs4yIkSbQ6s+MyogyCTnl3/pVVyj61nKPDg/I8SYCrst+5rW
         T9I+Dd+U4KKWM4lPG7sE9V6WCsgQwyWAy+glb3jE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 12/24] net: usb: ax88179_178a: add MCT usb 3.0 adapter
Date:   Mon, 12 Oct 2020 15:02:27 -0400
Message-Id: <20201012190239.3279198-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wilken Gottwalt <wilken.gottwalt@mailbox.org>

[ Upstream commit c92a79829c7c169139874aa1d4bf6da32d10c38a ]

Adds the driver_info and usb ids of the AX88179 based MCT U3-A9003 USB
3.0 ethernet adapter.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88179_178a.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 125f7bf57590b..a2f8a93c89269 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1841,6 +1841,19 @@ static const struct driver_info toshiba_info = {
 	.tx_fixup = ax88179_tx_fixup,
 };
 
+static const struct driver_info mct_info = {
+	.description = "MCT USB 3.0 Gigabit Ethernet Adapter",
+	.bind	= ax88179_bind,
+	.unbind	= ax88179_unbind,
+	.status	= ax88179_status,
+	.link_reset = ax88179_link_reset,
+	.reset	= ax88179_reset,
+	.stop	= ax88179_stop,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.rx_fixup = ax88179_rx_fixup,
+	.tx_fixup = ax88179_tx_fixup,
+};
+
 static const struct usb_device_id products[] = {
 {
 	/* ASIX AX88179 10/100/1000 */
@@ -1878,6 +1891,10 @@ static const struct usb_device_id products[] = {
 	/* Toshiba USB 3.0 GBit Ethernet Adapter */
 	USB_DEVICE(0x0930, 0x0a13),
 	.driver_info = (unsigned long)&toshiba_info,
+}, {
+	/* Magic Control Technology U3-A9003 USB 3.0 Gigabit Ethernet Adapter */
+	USB_DEVICE(0x0711, 0x0179),
+	.driver_info = (unsigned long)&mct_info,
 },
 	{ },
 };
-- 
2.25.1

