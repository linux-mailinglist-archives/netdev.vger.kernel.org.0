Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31EB5516FB
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 13:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241744AbiFTLMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 07:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241579AbiFTLKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 07:10:46 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEAB16585;
        Mon, 20 Jun 2022 04:10:32 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id ED7B8240004;
        Mon, 20 Jun 2022 11:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1655723431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e4XpCpixXHLWm12EJGAvEFvcWpgfd1sjAVb3qu+xQD0=;
        b=Ylh7Za5Q8ufOyeXGXMkeLwwvRmi224S6ilmGGrMl0bZN05OLPHEthWBpLDIotRMg4QAIx4
        1qXnTZ8sm0QQRLmVG1s0rILxI+y1VIIa8zqKfufDD/LcGHYhsDEinFk1fpRqh/hJmSoFnj
        89jFvggzLsS9Bhhe/ZRQ/m4PnfRVDvMNpeJsdgR5rARKmXRlaHKwkvhezYQlz61yUqVJAo
        wOOO4AvmTeyj8T338RCrVWWkMBBexZECOQ8WjPqsi5NkmDdgokmxglJVEf5+VCr1EYD4MR
        G4CVRvyE+ckD5DkYCVRgddhmDA47AqbR6bkQrhdeXJSN6s5S4y9TscOYqVVEmQ==
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
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next v8 16/16] MAINTAINERS: add Renesas RZ/N1 switch related driver entry
Date:   Mon, 20 Jun 2022 13:08:46 +0200
Message-Id: <20220620110846.374787-17-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620110846.374787-1-clement.leger@bootlin.com>
References: <20220620110846.374787-1-clement.leger@bootlin.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index ca95b1833b97..52f1439aac4b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17054,6 +17054,19 @@ S:	Supported
 F:	Documentation/devicetree/bindings/iio/adc/renesas,rzg2l-adc.yaml
 F:	drivers/iio/adc/rzg2l_adc.c
 
+RENESAS RZ/N1 A5PSW SWITCH DRIVER
+M:	Clément Léger <clement.leger@bootlin.com>
+L:	linux-renesas-soc@vger.kernel.org
+L:	netdev@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+F:	Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
+F:	drivers/net/dsa/rzn1_a5psw*
+F:	drivers/net/pcs/pcs-rzn1-miic.c
+F:	include/dt-bindings/net/pcs-rzn1-miic.h
+F:	include/linux/pcs-rzn1-miic.h
+F:	net/dsa/tag_rzn1_a5psw.c
+
 RENESAS RZ/N1 RTC CONTROLLER DRIVER
 M:	Miquel Raynal <miquel.raynal@bootlin.com>
 L:	linux-rtc@vger.kernel.org
-- 
2.36.1

