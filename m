Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0E24D71D2
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 01:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbiCMAXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 19:23:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbiCMAXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 19:23:11 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EB79BBB7;
        Sat, 12 Mar 2022 16:22:04 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D7C12223EA;
        Sun, 13 Mar 2022 01:22:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647130922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Om+Fp1RFdxau+QHT4ZTv6VQABvlFxAGNLV7Mt6x5j5M=;
        b=RH0CKNA/NRqgj9PN58bZhc1GCtF/rkn830WfTKuznl4SzEOf0OYJWpkurYvm1YFQRi14UK
        EImcdRkZtjK46cDel/5FyFt6akEv8sVwJssz2Pz9/t5HbOBYiUgm35vPFxPOnRgdoluHAg
        eEo6sWDURQOZ9Nud/lB24PnNsADGkeE=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 1/3] dt-bindings: net: mscc-miim: add lan966x compatible
Date:   Sun, 13 Mar 2022 01:21:51 +0100
Message-Id: <20220313002153.11280-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220313002153.11280-1-michael@walle.cc>
References: <20220313002153.11280-1-michael@walle.cc>
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
distiguish between these two.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 Documentation/devicetree/bindings/net/mscc-miim.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/mscc-miim.txt b/Documentation/devicetree/bindings/net/mscc-miim.txt
index 7104679cf59d..a9efff252ca6 100644
--- a/Documentation/devicetree/bindings/net/mscc-miim.txt
+++ b/Documentation/devicetree/bindings/net/mscc-miim.txt
@@ -2,7 +2,7 @@ Microsemi MII Management Controller (MIIM) / MDIO
 =================================================
 
 Properties:
-- compatible: must be "mscc,ocelot-miim"
+- compatible: must be "mscc,ocelot-miim" or "mscc,lan966x-miim"
 - reg: The base address of the MDIO bus controller register bank. Optionally, a
   second register bank can be defined if there is an associated reset register
   for internal PHYs
-- 
2.30.2

