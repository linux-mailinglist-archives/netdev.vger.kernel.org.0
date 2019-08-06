Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522FD83240
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731401AbfHFNGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:06:41 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45879 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731379AbfHFNGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:06:40 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 462vzM5dqfz1rGj1;
        Tue,  6 Aug 2019 15:06:39 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 462vzM51Kbz1qqkQ;
        Tue,  6 Aug 2019 15:06:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id bY4eb-2xtq5v; Tue,  6 Aug 2019 15:06:37 +0200 (CEST)
X-Auth-Info: 2e5uW+IuQ5ExyXazSA69ZiRuDji5vPlVnoPI1IjA8jY=
Received: from localhost.localdomain (cst-prg-69-96.cust.vodafone.cz [46.135.69.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  6 Aug 2019 15:06:37 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH 3/3] net: dsa: ksz: Drop NET_DSA_TAG_KSZ9477
Date:   Tue,  6 Aug 2019 15:06:09 +0200
Message-Id: <20190806130609.29686-3-marex@denx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806130609.29686-1-marex@denx.de>
References: <20190806130609.29686-1-marex@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This Kconfig option is unused, drop it.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
 drivers/net/dsa/microchip/Kconfig | 1 -
 net/dsa/Kconfig                   | 7 -------
 2 files changed, 8 deletions(-)

diff --git a/drivers/net/dsa/microchip/Kconfig b/drivers/net/dsa/microchip/Kconfig
index 5e4f74286ea3..e1c23d1e91e6 100644
--- a/drivers/net/dsa/microchip/Kconfig
+++ b/drivers/net/dsa/microchip/Kconfig
@@ -5,7 +5,6 @@ config NET_DSA_MICROCHIP_KSZ_COMMON
 menuconfig NET_DSA_MICROCHIP_KSZ9477
 	tristate "Microchip KSZ9477 series switch support"
 	depends on NET_DSA
-	select NET_DSA_TAG_KSZ9477
 	select NET_DSA_MICROCHIP_KSZ_COMMON
 	help
 	  This driver adds support for Microchip KSZ9477 switch chips.
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 6e942dda1bcd..2f69d4b53d46 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -84,13 +84,6 @@ config NET_DSA_TAG_KSZ
 	  Say Y if you want to enable support for tagging frames for the
 	  Microchip 9893 family of switches.
 
-config NET_DSA_TAG_KSZ9477
-	tristate "Tag driver for Microchip 9477 family of switches"
-	select NET_DSA_TAG_KSZ_COMMON
-	help
-	  Say Y if you want to enable support for tagging frames for the
-	  Microchip 9477 family of switches.
-
 config NET_DSA_TAG_QCA
 	tristate "Tag driver for Qualcomm Atheros QCA8K switches"
 	help
-- 
2.20.1

