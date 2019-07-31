Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8524E7C343
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 15:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387784AbfGaNWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 09:22:22 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:50880 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729473AbfGaNWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 09:22:21 -0400
Received: from ramsan ([84.194.98.4])
        by albert.telenet-ops.be with bizsmtp
        id jRNK2000F05gfCL06RNKRD; Wed, 31 Jul 2019 15:22:19 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-000187-90; Wed, 31 Jul 2019 15:22:19 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hsoYd-0004UV-7y; Wed, 31 Jul 2019 15:22:19 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 7/8] net: packetengines: Fix manufacturer spelling and capitalization
Date:   Wed, 31 Jul 2019 15:22:15 +0200
Message-Id: <20190731132216.17194-8-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190731132216.17194-1-geert+renesas@glider.be>
References: <20190731132216.17194-1-geert+renesas@glider.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "Packet Engines" consistently.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/packetengines/Kconfig  | 6 +++---
 drivers/net/ethernet/packetengines/Makefile | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/packetengines/Kconfig b/drivers/net/ethernet/packetengines/Kconfig
index 8161e308e64b0f16..ead3750b4489d1bf 100644
--- a/drivers/net/ethernet/packetengines/Kconfig
+++ b/drivers/net/ethernet/packetengines/Kconfig
@@ -1,10 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# Packet engine device configuration
+# Packet Engines device configuration
 #
 
 config NET_VENDOR_PACKET_ENGINES
-	bool "Packet Engine devices"
+	bool "Packet Engines devices"
 	default y
 	depends on PCI
 	---help---
@@ -12,7 +12,7 @@ config NET_VENDOR_PACKET_ENGINES
 
 	  Note that the answer to this question doesn't directly affect the
 	  kernel: saying N will just cause the configurator to skip all
-	  the questions about packet engine devices. If you say Y, you will
+	  the questions about Packet Engines devices. If you say Y, you will
 	  be asked for your specific card in the following questions.
 
 if NET_VENDOR_PACKET_ENGINES
diff --git a/drivers/net/ethernet/packetengines/Makefile b/drivers/net/ethernet/packetengines/Makefile
index 1553c9cfc254d6f8..cf054b796d111231 100644
--- a/drivers/net/ethernet/packetengines/Makefile
+++ b/drivers/net/ethernet/packetengines/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 #
-# Makefile for the Packet Engine network device drivers.
+# Makefile for the Packet Engines network device drivers.
 #
 
 obj-$(CONFIG_HAMACHI) += hamachi.o
-- 
2.17.1

