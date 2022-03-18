Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91914DE232
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbiCRUPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239791AbiCRUO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:14:57 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A20196121;
        Fri, 18 Mar 2022 13:13:37 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 13D44223EA;
        Fri, 18 Mar 2022 21:13:35 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647634415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qWHNfVem7DZQ9oD5nMVySWgz28W4v66+TQrxd7Lt7Z8=;
        b=JuFSQTwDVWbz7sIcbfUAdfS2Km6tULGL5wmzoGO87bt1s0fM3zkczwM/zMOxX32cL6mg43
        H3G0xhgaEbp5Jvgc9723wR0RI3sUPZt71eIB32Zb1aG8GlKJABbQgR8y87VG5e6FH8VWvV
        X9XoXqDBCPXRz3mUriPgAs3juX56K2k=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v3 1/3] dt-bindings: net: mscc-miim: add lan966x compatible
Date:   Fri, 18 Mar 2022 21:13:22 +0100
Message-Id: <20220318201324.1647416-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220318201324.1647416-1-michael@walle.cc>
References: <20220318201324.1647416-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MDIO controller has support to release the internal PHYs from reset
by specifying a second memory resource. This is different between the
currently supported SparX-5 and the LAN966x. Add a new compatible to
distinguish between these two.

Signed-off-by: Michael Walle <michael@walle.cc>
Acked-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 Documentation/devicetree/bindings/net/mscc-miim.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/mscc-miim.txt b/Documentation/devicetree/bindings/net/mscc-miim.txt
index 7104679cf59d..70e0cb1ee485 100644
--- a/Documentation/devicetree/bindings/net/mscc-miim.txt
+++ b/Documentation/devicetree/bindings/net/mscc-miim.txt
@@ -2,7 +2,7 @@ Microsemi MII Management Controller (MIIM) / MDIO
 =================================================
 
 Properties:
-- compatible: must be "mscc,ocelot-miim"
+- compatible: must be "mscc,ocelot-miim" or "microchip,lan966x-miim"
 - reg: The base address of the MDIO bus controller register bank. Optionally, a
   second register bank can be defined if there is an associated reset register
   for internal PHYs
-- 
2.30.2

