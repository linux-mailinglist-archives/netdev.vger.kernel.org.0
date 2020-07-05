Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473CD214FB6
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 23:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgGEVFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 17:05:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47874 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728146AbgGEVFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 17:05:24 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsBpC-003kRD-0E; Sun, 05 Jul 2020 23:05:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] net: dsa: vitesse-vsc73xx: Convert to plain comments to avoid kerneldoc warnings
Date:   Sun,  5 Jul 2020 23:05:08 +0200
Message-Id: <20200705210508.893443-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comments before struct vsc73xx_platform and struct vsc73xx_spi use
kerneldoc format, but then fail to document the members of these
structures. All the structure members are self evident, and the driver
has not other kerneldoc comments, so change these to plain comments to
avoid warnings.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/vitesse-vsc73xx-platform.c | 2 +-
 drivers/net/dsa/vitesse-vsc73xx-spi.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-platform.c b/drivers/net/dsa/vitesse-vsc73xx-platform.c
index 5e54a5726aa4..2a57f337b2a2 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-platform.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-platform.c
@@ -28,7 +28,7 @@
 #define VSC73XX_CMD_PLATFORM_SUBBLOCK_MASK		0xf
 #define VSC73XX_CMD_PLATFORM_REGISTER_SHIFT		2
 
-/**
+/*
  * struct vsc73xx_platform - VSC73xx Platform state container
  */
 struct vsc73xx_platform {
diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse-vsc73xx-spi.c
index e73c8fcddc9f..81eca4a5781d 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-spi.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
@@ -26,7 +26,7 @@
 #define VSC73XX_CMD_SPI_BLOCK_MASK		0x7
 #define VSC73XX_CMD_SPI_SUBBLOCK_MASK		0xf
 
-/**
+/*
  * struct vsc73xx_spi - VSC73xx SPI state container
  */
 struct vsc73xx_spi {
-- 
2.27.0.rc2

