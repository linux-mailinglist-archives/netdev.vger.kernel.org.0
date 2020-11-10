Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644092ACB33
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 03:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730010AbgKJCkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 21:40:41 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44850 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgKJCkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 21:40:39 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcJaG-006Cxq-Jf; Tue, 10 Nov 2020 03:40:36 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 3/3] drivers: net: xilinx_emaclite: Add COMPILE_TEST support
Date:   Tue, 10 Nov 2020 03:40:24 +0100
Message-Id: <20201110024024.1479741-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110024024.1479741-1-andrew@lunn.ch>
References: <20201110024024.1479741-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To improve build testing of this driver, add COMPILE_TEST support.

Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index d0d0d4fe9d40..3b2137d1f4c6 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -18,7 +18,7 @@ if NET_VENDOR_XILINX
 
 config XILINX_EMACLITE
 	tristate "Xilinx 10/100 Ethernet Lite support"
-	depends on PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS
+	depends on PPC32 || MICROBLAZE || ARCH_ZYNQ || MIPS || COMPILE_TEST
 	select PHYLIB
 	help
 	  This driver supports the 10/100 Ethernet Lite from Xilinx.
-- 
2.29.2

