Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3582E31C6
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 17:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgL0QNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 11:13:20 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:54999 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbgL0QNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Dec 2020 11:13:20 -0500
Received: from localhost.localdomain (unknown [IPv6:2a01:e0a:2a2:1350:cd10:777c:7b57:3bb6])
        (Authenticated sender: dftxbs3e)
        by smtp2-g21.free.fr (Postfix) with ESMTPSA id 2CF062003C3;
        Sun, 27 Dec 2020 17:12:22 +0100 (CET)
From:   dftxbs3e@free.fr
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, trivial@kernel.org, irusskikh@marvell.com,
        =?UTF-8?q?L=C3=A9o=20Le=20Bouter?= <lle-bout@zaclys.net>
Subject: [PATCH v2] atlantic: remove architecture depends
Date:   Sun, 27 Dec 2020 17:11:36 +0100
Message-Id: <20201227161136.3429-1-dftxbs3e@free.fr>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <X+iuoLDI63CBXnfJ@lunn.ch>
References: <X+iuoLDI63CBXnfJ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Léo Le Bouter <lle-bout@zaclys.net>

This was tested on a RaptorCS Talos II with IBM POWER9 DD2.2 CPUs and an
ASUS XG-C100F PCI-e card without any issue. Speeds of ~8Gbps could be
attained with not-very-scientific (wget HTTP) both-ways measurements on
a local network. No warning or error reported in kernel logs. The
drivers seems to be portable enough for it not to be gated like such.

Signed-off-by: Léo Le Bouter <lle-bout@zaclys.net>
---
 drivers/net/ethernet/aquantia/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/Kconfig b/drivers/net/ethernet/aquantia/Kconfig
index efb33c078a3c..cec2018c84a9 100644
--- a/drivers/net/ethernet/aquantia/Kconfig
+++ b/drivers/net/ethernet/aquantia/Kconfig
@@ -19,7 +19,6 @@ if NET_VENDOR_AQUANTIA
 config AQTION
 	tristate "aQuantia AQtion(tm) Support"
 	depends on PCI
-	depends on X86_64 || ARM64 || COMPILE_TEST
 	depends on MACSEC || MACSEC=n
 	help
 	  This enables the support for the aQuantia AQtion(tm) Ethernet card.
-- 
2.29.2

