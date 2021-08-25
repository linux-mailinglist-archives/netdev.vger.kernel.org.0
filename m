Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8133F6F6F
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238328AbhHYGYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:24:49 -0400
Received: from mx21.baidu.com ([220.181.3.85]:60422 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237993AbhHYGYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 02:24:49 -0400
Received: from BC-Mail-HQEX01.internal.baidu.com (unknown [172.31.51.57])
        by Forcepoint Email with ESMTPS id E806622C041D02F36F5F;
        Wed, 25 Aug 2021 14:23:57 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-HQEX01.internal.baidu.com (172.31.51.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Wed, 25 Aug 2021 14:23:57 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 25 Aug 2021 14:23:57 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>, <geert+renesas@glider.be>,
        <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] can: rcar: Kconfig: Add helper dependency on COMPILE_TEST
Date:   Wed, 25 Aug 2021 14:23:41 +0800
Message-ID: <20210825062341.2332-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex30.internal.baidu.com (172.31.51.24) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

it's helpful for complie test in other platform(e.g.X86)

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
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
-- 
2.25.1

