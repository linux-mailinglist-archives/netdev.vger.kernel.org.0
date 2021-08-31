Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF2D3FC836
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhHaN2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbhHaN2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 09:28:40 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD28C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 06:27:44 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:2193:279a:893d:20ae])
        by baptiste.telenet-ops.be with bizsmtp
        id oDTi2500G1ZidPp01DTi9D; Tue, 31 Aug 2021 15:27:42 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mL3nh-000rvz-M3; Tue, 31 Aug 2021 15:27:41 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1mL3nh-001JYB-6q; Tue, 31 Aug 2021 15:27:41 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] can: rcar: Drop unneeded ARM dependency
Date:   Tue, 31 Aug 2021 15:27:40 +0200
Message-Id: <362d9ced19f3524ee8917df5681b3880c13cac85.1630416373.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dependency on ARM predates the dependency on ARCH_RENESAS.
The latter was introduced for Renesas arm64 SoCs first, and later
extended to cover Renesas ARM SoCs, too.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/can/rcar/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/Kconfig b/drivers/net/can/rcar/Kconfig
index 56320a7f828b6684..c66762ef631b0871 100644
--- a/drivers/net/can/rcar/Kconfig
+++ b/drivers/net/can/rcar/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config CAN_RCAR
 	tristate "Renesas R-Car and RZ/G CAN controller"
-	depends on ARCH_RENESAS || ARM || COMPILE_TEST
+	depends on ARCH_RENESAS || COMPILE_TEST
 	help
 	  Say Y here if you want to use CAN controller found on Renesas R-Car
 	  or RZ/G SoCs.
@@ -11,7 +11,7 @@ config CAN_RCAR
 
 config CAN_RCAR_CANFD
 	tristate "Renesas R-Car CAN FD controller"
-	depends on ARCH_RENESAS || ARM || COMPILE_TEST
+	depends on ARCH_RENESAS || COMPILE_TEST
 	help
 	  Say Y here if you want to use CAN FD controller found on
 	  Renesas R-Car SoCs. The driver puts the controller in CAN FD only
-- 
2.25.1

