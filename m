Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5EAC3F71CE
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbhHYJgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239628AbhHYJgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:36:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A1BC0613C1
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 02:35:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mIpJa-00047t-4p
        for netdev@vger.kernel.org; Wed, 25 Aug 2021 11:35:22 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5BCA166F5A9
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 09:35:19 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E133866F592;
        Wed, 25 Aug 2021 09:35:17 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4f86cbb0;
        Wed, 25 Aug 2021 09:35:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Cai Huoqing <caihuoqing@baidu.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 1/4] can: rcar: Kconfig: Add helper dependency on COMPILE_TEST
Date:   Wed, 25 Aug 2021 11:35:13 +0200
Message-Id: <20210825093516.448231-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210825093516.448231-1-mkl@pengutronix.de>
References: <20210825093516.448231-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cai Huoqing <caihuoqing@baidu.com>

it's helpful for complie test in other platform(e.g.X86)

Link: https://lore.kernel.org/r/20210825062341.2332-1-caihuoqing@baidu.com
Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/rcar/Kconfig b/drivers/net/can/rcar/Kconfig
index 29cabc20109e..56320a7f828b 100644
--- a/drivers/net/can/rcar/Kconfig
+++ b/drivers/net/can/rcar/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 config CAN_RCAR
 	tristate "Renesas R-Car and RZ/G CAN controller"
-	depends on ARCH_RENESAS || ARM
+	depends on ARCH_RENESAS || ARM || COMPILE_TEST
 	help
 	  Say Y here if you want to use CAN controller found on Renesas R-Car
 	  or RZ/G SoCs.
@@ -11,7 +11,7 @@ config CAN_RCAR
 
 config CAN_RCAR_CANFD
 	tristate "Renesas R-Car CAN FD controller"
-	depends on ARCH_RENESAS || ARM
+	depends on ARCH_RENESAS || ARM || COMPILE_TEST
 	help
 	  Say Y here if you want to use CAN FD controller found on
 	  Renesas R-Car SoCs. The driver puts the controller in CAN FD only

base-commit: a37c5c26693eadb3aa4101d8fe955e40d206b386
-- 
2.32.0


