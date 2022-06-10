Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02C5546484
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348710AbiFJKpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 06:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348912AbiFJKnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 06:43:35 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB4723F22A;
        Fri, 10 Jun 2022 03:39:42 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id C54AD240013;
        Fri, 10 Jun 2022 10:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654857581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zRt35pPj+3tkqtSPRuzjG3w11kgz5cQ7+XUdqb18+J0=;
        b=JB/hGpQLhGQ3AfA5VjTHJbmMeEjdjB4Z2bAj4+VEkv/f4rrtFCUaMm7eyrjkyjKz5Vd68v
        meSKT9Ff7W/5WqLQefNuoeHIhIBMzI4isRGoG8bUJV0eLts2STeDzzdq6Gj5DDmS3YXDTC
        SPv4TrU4Z3rKtfcPPpYSVoip0xojB1LPh3DbHuz6azOQgWYtskiwbOjBnP1/L8zpFiGrpR
        hUxEJZreY22TJ1Q882BtKQqyu0uQ5D9WlqutZNMMrcNK0uqogWJ+5RzHs28IBFMGV7H56M
        VmlC8upcz2xXxM77R6UHFh9ERxk6TpteHDERPBFGFAoNsDhtdFYXFbB4D7vCEw==
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
Subject: [PATCH RESEND net-next v7 16/16] MAINTAINERS: add Renesas RZ/N1 switch related driver entry
Date:   Fri, 10 Jun 2022 12:37:12 +0200
Message-Id: <20220610103712.550644-17-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220610103712.550644-1-clement.leger@bootlin.com>
References: <20220610103712.550644-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After contributing the drivers, volunteer for maintenance and add
myself as the maintainer for Renesas RZ/N1 switch related drivers.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 749b26763760..dee6e73876c0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17044,6 +17044,19 @@ S:	Supported
 F:	Documentation/devicetree/bindings/iio/adc/renesas,rzg2l-adc.yaml
 F:	drivers/iio/adc/rzg2l_adc.c
 
+RENESAS RZ/N1 A5PSW SWITCH DRIVER
+M:	Clément Léger <clement.leger@bootlin.com>
+S:	Maintained
+L:	linux-renesas-soc@vger.kernel.org
+L:	netdev@vger.kernel.org
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

