Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC70500D41
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243283AbiDNM2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243322AbiDNM1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:27:51 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D54D30F7D;
        Thu, 14 Apr 2022 05:25:03 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 24ED540004;
        Thu, 14 Apr 2022 12:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1649939101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TQf1op9JK2uw4U3DShnLFodUXLKVqIi3dgErr72WmTA=;
        b=C3/JJsHQa7ZAIfun/QoN+GkUGHybDMyPWHJPRI59lYPTkStOSjNbm7z28yvfIulNvC6zPg
        x0uONaeFScWW8SozaVhnCM4bzsqfcYMiW7U9uOu3yXyX66uCSq4JxO5jb1D8YoZz80C0Hm
        wtqYT4Xami+BHE4VXhNMmzGLRvJHEtpZfGfS2xR/K3QurCqFuDhJ/VVDvJkHRzP1PjosNK
        8ksZfW403ouYATPXEHlOB5z5bZayHMwLgyCMGhadubSWlgVZENBbMx0WJboCNkeTWegVyw
        fecZ/GElZOmYOZpyRhnzaYoBvVyTwmMDNwyHphvDcQfnCWOFbM6W5QbwaQs+fw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 12/12] MAINTAINERS: add Renesas RZ/N1 switch related driver entry
Date:   Thu, 14 Apr 2022 14:22:50 +0200
Message-Id: <20220414122250.158113-13-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220414122250.158113-1-clement.leger@bootlin.com>
References: <20220414122250.158113-1-clement.leger@bootlin.com>
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
index 9b0480f1b153..8b25308d523e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16856,6 +16856,17 @@ S:	Supported
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

