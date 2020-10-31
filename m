Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 076C02A1233
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgJaAu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:50:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgJaAuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:50:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYf5z-004Rih-Il; Sat, 31 Oct 2020 01:50:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 7/7] drivers: net: smsc: Add COMPILE_TEST support
Date:   Sat, 31 Oct 2020 01:49:58 +0100
Message-Id: <20201031004958.1059797-8-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031004958.1059797-1-andrew@lunn.ch>
References: <20201031004958.1059797-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the build testing of these SMSC drivers by enabling them when
COMPILE_TEST is selected.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/smsc/Kconfig b/drivers/net/ethernet/smsc/Kconfig
index b77e427e6729..c52a38df0e0d 100644
--- a/drivers/net/ethernet/smsc/Kconfig
+++ b/drivers/net/ethernet/smsc/Kconfig
@@ -8,7 +8,7 @@ config NET_VENDOR_SMSC
 	default y
 	depends on ARM || ARM64 || ATARI_ETHERNAT || COLDFIRE || \
 		   ISA || MAC || MIPS || NIOS2 || PCI || \
-		   PCMCIA || SUPERH || XTENSA || H8300
+		   PCMCIA || SUPERH || XTENSA || H8300 || COMPILE_TEST
 	help
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -39,7 +39,7 @@ config SMC91X
 	select MII
 	depends on !OF || GPIOLIB
 	depends on ARM || ARM64 || ATARI_ETHERNAT || COLDFIRE || \
-		   MIPS || NIOS2 || SUPERH || XTENSA || H8300
+		   MIPS || NIOS2 || SUPERH || XTENSA || H8300 || COMPILE_TEST
 	help
 	  This is a driver for SMC's 91x series of Ethernet chipsets,
 	  including the SMC91C94 and the SMC91C111. Say Y if you want it
@@ -78,7 +78,7 @@ config SMC911X
 	tristate "SMSC LAN911[5678] support"
 	select CRC32
 	select MII
-	depends on (ARM || SUPERH)
+	depends on (ARM || SUPERH || COMPILE_TEST)
 	help
 	  This is a driver for SMSC's LAN911x series of Ethernet chipsets
 	  including the new LAN9115, LAN9116, LAN9117, and LAN9118.
-- 
2.28.0

