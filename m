Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80FA4EFC6C
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 23:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353121AbiDAWAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 18:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352837AbiDAWAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 18:00:51 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8E51C1EF8;
        Fri,  1 Apr 2022 14:59:00 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EBC5A22249;
        Fri,  1 Apr 2022 23:58:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648850339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p7la0KOeEOAysVBijkaFTCkW3yqx5mQnMD3fZ7uHfuI=;
        b=ficpD8sttr3iAWV08aCp1HPpWMiR/UfMAJDD/nqVbSEGScJGn94fgpguze2KQpp7hL8Khb
        y1+vdZBZcU2pPNWhMqD+NuS77vtkp2J6UR/i1T6lYCKHXBnd9XhHXNVzT2bnUPnh/V9ogI
        CKjNV6eSnM8s6e+WlNl86w+QjUoswI0=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH RFC net-next v2 2/3] dt-bindings: net: mscc-miim: add clock and clock-frequency
Date:   Fri,  1 Apr 2022 23:58:33 +0200
Message-Id: <20220401215834.3757692-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220401215834.3757692-1-michael@walle.cc>
References: <20220401215834.3757692-1-michael@walle.cc>
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

Add the (optional) clock input of the MDIO controller and indicate that
the common clock-frequency property is supported. The driver can use it
to set the desired MDIO bus frequency.

Signed-off-by: Michael Walle <michael@walle.cc>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/net/mscc,miim.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mscc,miim.yaml b/Documentation/devicetree/bindings/net/mscc,miim.yaml
index cdc39aa20683..2c451cfa4e0b 100644
--- a/Documentation/devicetree/bindings/net/mscc,miim.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,miim.yaml
@@ -33,6 +33,11 @@ properties:
   interrupts:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+
+  clock-frequency: true
+
 required:
   - compatible
   - reg
-- 
2.30.2

