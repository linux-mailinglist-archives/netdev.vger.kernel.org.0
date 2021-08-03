Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DE13DEC72
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbhHCLmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235846AbhHCLmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:42:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FDFF60F48;
        Tue,  3 Aug 2021 11:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990911;
        bh=UvFIsPcVFoTFjEPkeQp6ittb6V6f/9YtB3iKNvSSk+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fysc3o4Zo9YrTM3ZjAQdTw6HIBBlTfZG4tBAJbMZOIQTxNTEUtfLWalSZslpUZgey
         FSPT0K8ezE8oUSitp5vcyHNhHS5swnKjBUqu8AHH/eQpSpfomZ1v6sMbkj81yLSLos
         ZP6Vk6QSMrRXjeDbEcuVH1okxPoWj3k5+2dpgawpGRJKGNiV3alMw6uMZ5dRHE6i1Y
         swFnFFFPSY4jQiLRTXk7C1roI+3rXg+SegOn+Eo12T6T0xfBza9eWeDjaKmXKSy/Q1
         qzRLJpa39gGpcqFQcUTVt+kW3MXHDZsZoGW1MJv15B3QmKSlGEpuYdFAz8zvDI/Byf
         PodIFif9I2TQg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH v2 11/14] [net-next] wan: remove stale Kconfig entries
Date:   Tue,  3 Aug 2021 13:40:48 +0200
Message-Id: <20210803114051.2112986-12-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
References: <20210803114051.2112986-1-arnd@kernel.org>
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
index 473df2505c8e..d31791535ccf 100644
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

