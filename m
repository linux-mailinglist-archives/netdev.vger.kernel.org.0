Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8243AD034
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 18:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbhFRQTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 12:19:05 -0400
Received: from [106.121.162.16] ([106.121.162.16]:60545 "EHLO server"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S232944AbhFRQTE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 12:19:04 -0400
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jun 2021 12:19:03 EDT
Received: by server (Postfix, from userid 1000)
        id E9237762CE8; Sat, 19 Jun 2021 00:08:43 +0800 (CST)
From:   Wei Mingzhi <whistler@member.fsf.org>
To:     kubakici@wp.pl, kvalo@codeaurora.org, davem@davemloft.net,
        matthias.bgg@gmail.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wei Mingzhi <whistler@member.fsf.org>
Subject: [PATCH] mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.
Date:   Sat, 19 Jun 2021 00:08:40 +0800
Message-Id: <20210618160840.305024-1-whistler@member.fsf.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB device ID of some versions of XiaoDu WiFi Dongle is 2955:1003
instead of 2955:1001. Both are the same mt7601u hardware.

Signed-off-by: Wei Mingzhi <whistler@member.fsf.org>
---
 drivers/net/wireless/mediatek/mt7601u/usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
index 6bcc4a13ae6c..cc772045d526 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -26,6 +26,7 @@ static const struct usb_device_id mt7601u_device_table[] = {
 	{ USB_DEVICE(0x2717, 0x4106) },
 	{ USB_DEVICE(0x2955, 0x0001) },
 	{ USB_DEVICE(0x2955, 0x1001) },
+	{ USB_DEVICE(0x2955, 0x1003) },
 	{ USB_DEVICE(0x2a5f, 0x1000) },
 	{ USB_DEVICE(0x7392, 0x7710) },
 	{ 0, }
-- 
2.31.1

