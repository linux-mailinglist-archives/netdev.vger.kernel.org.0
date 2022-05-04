Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D641C519BE2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 11:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbiEDJgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 05:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347432AbiEDJgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 05:36:10 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A73227147;
        Wed,  4 May 2022 02:31:51 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A6E9A4001C;
        Wed,  4 May 2022 09:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651656710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0f9OuIqnKWeX+OGZsEpXifhCvbt8Y6SEkR4j7N0Js9U=;
        b=Sjcw+PjsAzOmxGlvUsaJ7BeujYxDyRTETAWhccRn2Z+gu595uhugCY7X86KNktUWRg03+i
        1PqAkMKeJ6ZRm6rRBSTAxDWgUuMY1CprQYXcghZ1hkarkVNBLmAAAvI+eneqFLmiEW7x9N
        vupVwhYmG7eNE6jJDKQigTwM+0uroz8AMLUMt3EkXmsB/5YcoY3hnXC660z08UHX38FAIs
        BO+IhCBS4IsLjF3WKK+whL9GniDeYz6t6QQkFey/9t3qi7ofXugPsTtMlGt/w4WCgz1JgZ
        ALT+rQIpCE/1hgTCqMmgIIj5zNuwKJPv6zegYnkIE2CGxMqP/1U/1LnyoJF6oA==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v3 12/12] MAINTAINERS: add Renesas RZ/N1 switch related driver entry
Date:   Wed,  4 May 2022 11:30:00 +0200
Message-Id: <20220504093000.132579-13-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220504093000.132579-1-clement.leger@bootlin.com>
References: <20220504093000.132579-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After contributing the drivers, volunteer for maintenance and add
myself as the maintainer for Renesas RZ/N1 switch related drivers.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa6896e8b2d8..9e1d2647f8bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16872,6 +16872,17 @@ S:	Supported
 F:	Documentation/devicetree/bindings/iio/adc/renesas,rzg2l-adc.yaml
 F:	drivers/iio/adc/rzg2l_adc.c
 
+RENESAS RZ/N1 A5PSW SWITCH DRIVER
+M:	Clément Léger <clement.leger@bootlin.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+F:	Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
+F:	drivers/net/dsa/rzn1_a5psw*
+F:	drivers/net/pcs/pcs-rzn1-miic.c
+F:	include/dt-bindings/net/pcs-rzn1-miic.h
+F:	include/linux/pcs-rzn1-miic.h
+F:	net/dsa/tag_rzn1_a5psw.c
+
 RENESAS R-CAR GEN3 & RZ/N1 NAND CONTROLLER DRIVER
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 L:	linux-mtd@lists.infradead.org
-- 
2.34.1

