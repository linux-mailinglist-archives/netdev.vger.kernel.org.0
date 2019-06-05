Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3D1365D1
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfFEUnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:43:21 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:7822 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfFEUnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 16:43:00 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x55Kgqd7013352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Jun 2019 14:42:57 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x55Kghiu021149
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 5 Jun 2019 14:42:52 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v4 04/20] net: axienet: add X86 and ARM as supported platforms
Date:   Wed,  5 Jun 2019 14:42:17 -0600
Message-Id: <1559767353-17301-5-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
References: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver should now build on (at least) X86 and ARM platforms, so add
them as supported platforms for the driver in Kconfig.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index af96e05..5f50764 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -6,7 +6,7 @@
 config NET_VENDOR_XILINX
 	bool "Xilinx devices"
 	default y
-	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || COMPILE_TEST
+	depends on PPC || PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || X86 || ARM || COMPILE_TEST
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y.
 
@@ -26,7 +26,7 @@ config XILINX_EMACLITE
 
 config XILINX_AXI_EMAC
 	tristate "Xilinx 10/100/1000 AXI Ethernet support"
-	depends on MICROBLAZE
+	depends on MICROBLAZE || X86 || ARM || COMPILE_TEST
 	select PHYLIB
 	---help---
 	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
-- 
1.8.3.1

