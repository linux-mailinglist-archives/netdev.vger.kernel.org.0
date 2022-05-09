Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0967451FE0F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiEINZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235692AbiEINY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:24:59 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29C42654C;
        Mon,  9 May 2022 06:20:50 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 48707240010;
        Mon,  9 May 2022 13:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652102449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6ndnibU/XaVvryfZro7tRaiSnWV3JMAVSMe1z6tjXcM=;
        b=H9Nh2I7B9qZQXVwuosvFMug5Zx1Fa3eI/9gWtROEL2Q735I6ZBDFFhUJ/JOpQmlZVJfzNi
        EugeZ3hqRrtUkejhCKGAWEwAT9N9VQrjEpQDryYHbgIhDahKn3tzUKfW+JnwLB31iHtzvD
        +rFCpa072fai1IZu1QnMErdN52tQn2yK78NK3chgzk3WWoxo7oXJqdG6p4lIHNOtHzJ0hM
        2Dc6zk384QIvNa//T7E6gcW/W+8vQdow/xYKNcCVwqq73vAkzEPnldBtkrspGoJpxa3D4Z
        CFt0JItF0m5Iz4g15AdQ6b7955nxfFfY5xAnYZahoKZdhyyvOOSjUXb5kfFSBA==
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
Subject: [PATCH net-next v4 12/12] MAINTAINERS: add Renesas RZ/N1 switch related driver entry
Date:   Mon,  9 May 2022 15:19:00 +0200
Message-Id: <20220509131900.7840-13-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220509131900.7840-1-clement.leger@bootlin.com>
References: <20220509131900.7840-1-clement.leger@bootlin.com>
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
2.36.0

