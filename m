Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABBD36BFD9
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 09:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbhD0HLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 03:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234894AbhD0HKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 03:10:35 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9E6C061346
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 00:09:42 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqK-000121-9M; Tue, 27 Apr 2021 09:09:12 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lbHqI-0003nD-KG; Tue, 27 Apr 2021 09:09:10 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next v8 9/9] dt-bindings: net: mdio-gpio: add compatible for microchip,mdio-smi0
Date:   Tue, 27 Apr 2021 09:09:09 +0200
Message-Id: <20210427070909.14434-10-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210427070909.14434-1-o.rempel@pengutronix.de>
References: <20210427070909.14434-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

Microchip SMI0 Mode is a special mode, where the MDIO Read/Write
commands are part of the PHY Address and the OP Code is always 0. We add
the compatible for this special mode of the bitbanged mdio driver.

Cc: devicetree@vger.kernel.org
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

---
v1 -> v2: - patch not present
v2 -> v3: - first patch
v3 -> v4: - no changes
---
 Documentation/devicetree/bindings/net/mdio-gpio.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
index 8dbcf8295c6c..4d91a36c5cf5 100644
--- a/Documentation/devicetree/bindings/net/mdio-gpio.txt
+++ b/Documentation/devicetree/bindings/net/mdio-gpio.txt
@@ -2,6 +2,7 @@ MDIO on GPIOs
 
 Currently defined compatibles:
 - virtual,gpio-mdio
+- microchip,mdio-smi0
 
 MDC and MDIO lines connected to GPIO controllers are listed in the
 gpios property as described in section VIII.1 in the following order:
-- 
2.29.2

