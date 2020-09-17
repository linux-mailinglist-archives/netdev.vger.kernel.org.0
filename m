Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B6026E07C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 18:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgIQQUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 12:20:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40840 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728416AbgIQQUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 12:20:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kIwdc-00F6EY-U9; Thu, 17 Sep 2020 18:20:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: mdio: octeon: Select MDIO_DEVRES
Date:   Thu, 17 Sep 2020 18:19:49 +0200
Message-Id: <20200917161949.3598839-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver makes use of devm_mdiobus_alloc_size. To ensure this is
available select MDIO_DEVRES which provides it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/mdio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
index 1299880dfe74..840727cc9499 100644
--- a/drivers/net/mdio/Kconfig
+++ b/drivers/net/mdio/Kconfig
@@ -138,6 +138,7 @@ config MDIO_OCTEON
 	depends on (64BIT && OF_MDIO) || COMPILE_TEST
 	depends on HAS_IOMEM
 	select MDIO_CAVIUM
+	select MDIO_DEVRES
 	help
 	  This module provides a driver for the Octeon and ThunderX MDIO
 	  buses. It is required by the Octeon and ThunderX ethernet device
-- 
2.28.0

