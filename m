Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17A0381B69
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbhEOWRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235345AbhEOWQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:16:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2884A61377;
        Sat, 15 May 2021 22:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116901;
        bh=eeOO3But91IFATUTNPdQLLi/Sj6XI75cxhUbTnASYsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEGk1mjHfke24VhPZ4xg+VERI3StfGEQeB5NFFakHeQHU2RiPhGyzyPxvPqEifCPn
         Cft9bqeU6eXjWGENvtwqj/kvUs6JfApU34vvnbMO3fD/oi+AB/PjmMuzdq0It9IQt5
         p/AhcsqPb95j0tCBwPpF+bt1XTjaDkSQbwTqUV3wMCjLag6qjiUpvXzpMnLXeXKCsw
         EmOsbArz2+V0pU94p5aMxRr2B89xMqD33XP15LmixpFgSaODJgml/IP0JHsyYei3MK
         bPX2KeNLDRX4jLuHyhwyoHCj+frWAZFT96NsdI5nhV44UAMMbBuG5iMTfdk1elG3oP
         xFn/lXcIo0zTg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 09/13] [net-next] wan: remove stale Kconfig entries
Date:   Sun, 16 May 2021 00:13:16 +0200
Message-Id: <20210515221320.1255291-10-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The dscc4 driver was removed in 2019 but these Kconfig entries remain,
so remove them as well.

Fixes: 28c9eb9042a9 ("net/wan: dscc4: remove broken dscc4 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wan/Kconfig | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 83c9481995dd..f59ebafa3761 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -290,30 +290,6 @@ config SLIC_DS26522
 	  To compile this driver as a module, choose M here: the
 	  module will be called slic_ds26522.
 
-config DSCC4_PCISYNC
-	bool "Etinc PCISYNC features"
-	depends on DSCC4
-	help
-	  Due to Etinc's design choice for its PCISYNC cards, some operations
-	  are only allowed on specific ports of the DSCC4. This option is the
-	  only way for the driver to know that it shouldn't return a success
-	  code for these operations.
-
-	  Please say Y if your card is an Etinc's PCISYNC.
-
-config DSCC4_PCI_RST
-	bool "Hard reset support"
-	depends on DSCC4
-	help
-	  Various DSCC4 bugs forbid any reliable software reset of the ASIC.
-	  As a replacement, some vendors provide a way to assert the PCI #RST
-	  pin of DSCC4 through the GPIO port of the card. If you choose Y,
-	  the driver will make use of this feature before module removal
-	  (i.e. rmmod). The feature is known to be available on Commtech's
-	  cards. Contact your manufacturer for details.
-
-	  Say Y if your card supports this feature.
-
 config IXP4XX_HSS
 	tristate "Intel IXP4xx HSS (synchronous serial port) support"
 	depends on HDLC && IXP4XX_NPE && IXP4XX_QMGR
-- 
2.29.2

