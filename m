Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 297442F4D70
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 15:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbhAMOn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 09:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbhAMOn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 09:43:56 -0500
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47127C061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 06:43:16 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by michel.telenet-ops.be with bizsmtp
        id GEjD2401H4C55Sk06EjDTH; Wed, 13 Jan 2021 15:43:14 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1kzhMe-003HhP-N3; Wed, 13 Jan 2021 15:43:12 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1kzhMe-005oUh-5n; Wed, 13 Jan 2021 15:43:12 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] nt: usb: USB_RTL8153_ECM should not default to y
Date:   Wed, 13 Jan 2021 15:43:09 +0100
Message-Id: <20210113144309.1384615-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In general, device drivers should not be enabled by default.

Fixes: 657bc1d10bfc23ac ("r8153_ecm: avoid to be prior to r8152 driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/usb/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 1e37190287808973..fbbe786436319013 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -631,7 +631,6 @@ config USB_NET_AQC111
 config USB_RTL8153_ECM
 	tristate "RTL8153 ECM support"
 	depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
-	default y
 	help
 	  This option supports ECM mode for RTL8153 ethernet adapter, when
 	  CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not
-- 
2.25.1

