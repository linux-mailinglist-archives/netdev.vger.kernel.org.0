Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45BE41CB3C3
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgEHPoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 11:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgEHPn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 11:43:59 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A4BC05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 08:43:58 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jX5AH-0004qp-3q; Fri, 08 May 2020 17:43:53 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1jX5AB-0003XK-94; Fri, 08 May 2020 17:43:47 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, devicetree@vger.kernel.org
Subject: [PATCH v3 2/5] dt-bindings: net: mdio-gpio: add compatible for microchip,mdio-smi0
Date:   Fri,  8 May 2020 17:43:40 +0200
Message-Id: <20200508154343.6074-3-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Microchip SMI0 Mode is a special mode, where the MDIO Read/Write
commands are part of the PHY Address and the OP Code is always 0. We add
the compatible for this special mode of the bitbanged mdio driver.

Cc: devicetree@vger.kernel.org
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 Documentation/devicetree/bindings/net/mdio-gpio.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
index 8dbcf8295c6c9c..4d91a36c5cf503 100644
--- a/Documentation/devicetree/bindings/net/mdio-gpio.txt
+++ b/Documentation/devicetree/bindings/net/mdio-gpio.txt
@@ -2,6 +2,7 @@ MDIO on GPIOs
 
 Currently defined compatibles:
 - virtual,gpio-mdio
+- microchip,mdio-smi0
 
 MDC and MDIO lines connected to GPIO controllers are listed in the
 gpios property as described in section VIII.1 in the following order:
-- 
2.26.2

