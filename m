Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517E36F289A
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 13:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjD3Lfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 07:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjD3Lfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 07:35:38 -0400
Received: from perseus.uberspace.de (perseus.uberspace.de [95.143.172.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657B2271C
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 04:35:36 -0700 (PDT)
Received: (qmail 18696 invoked by uid 988); 30 Apr 2023 11:28:54 -0000
Authentication-Results: perseus.uberspace.de;
        auth=pass (plain)
From:   David Bauer <mail@david-bauer.net>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        =?UTF-8?q?=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 2/2] dt-bindings: net: dsa: mediatek,mt7530: document MDIO-bus
Date:   Sun, 30 Apr 2023 13:28:33 +0200
Message-Id: <20230430112834.11520-2-mail@david-bauer.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230430112834.11520-1-mail@david-bauer.net>
References: <20230430112834.11520-1-mail@david-bauer.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Bar: /
X-Rspamd-Report: BAYES_HAM(-3) R_MISSING_CHARSET(0.5) MIME_GOOD(-0.1) MID_CONTAINS_FROM(1) SUSPICIOUS_RECIPS(1.5)
X-Rspamd-Score: -0.1
Received: from unknown (HELO unkown) (::1)
        by perseus.uberspace.de (Haraka/3.0.1) with ESMTPSA; Sun, 30 Apr 2023 13:28:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=david-bauer.net; s=uberspace;
        h=from;
        bh=sTYmJdxkbJ6INid41yoAQ9uYdKno4uxUMFR5arFxeCc=;
        b=jOG5PZqyf0Fr/vBRT7d3DIMKD7eTMbfb4F6YNlEPi9GCL326ZHSewYXKDuO5hSwHhWvjJrlDb8
        V9U9sNTecZc3GGlBu3ZBAdFdPPiZ4dCI0YQoJV6oaAlc6GP5SGF0BE+7DbsSTH8WLCX3oINCTVvI
        TJxipRze5M8tl2c65CrX3SKFDBikA4xMg1Xz25Uxh8A4bqTKd7uN47dTk2GP8riZ84aVV31olbAL
        Bnb8pX9sLT+hqrKFAhStBiUgmE1w7UCTCqFLIRmPTF4nlg8BFFzHEUOWQJEJzqIX/in2TtmwMWuD
        JXy/jjU++UOmqBtW5OHXsha20f8d05y0AGWc4s2HOHjwhgXf6FPwBKrRzlUy4Gw5dBC1YOQOWz1f
        cXeIvoXXOSRVdh7C8uN1hY8vq7Qu8ymv2BQgivOg/TFVEAT7TJC1I3U3tRotGcfR+PLw32hLZFlX
        T+/d4EXZm5w1WBjNrFOrsAdpaNg0a1b+d8VaBAcecVjc2OWV3w/ZROGkVJLkwJX+4PmB9cTAvZS0
        bkvL0akVRqCTdZV8exHIQyTzergXnTYH7ZIAsVynx/ZHEoXr1E44g6VfFzmWytA8Tp7P7BzDoyZ7
        eCW4IuxOS3kWXlvJ37cSHw7LKr1XrTcXMFnh6D7ByBe9H4amiCLIhaTnnLkCV8QaXeKxWl5av9xC
        8=
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,MSGID_FROM_MTA_HEADER,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the ability to add nodes for the MDIO bus connecting the
switch-internal PHYs.

Signed-off-by: David Bauer <mail@david-bauer.net>
---
 .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml        | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index e532c6b795f4..50f8f83cc440 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -128,6 +128,12 @@ properties:
       See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt for
       details for the regulator setup on these boards.
 
+  mdio:
+    $ref: /schemas/net/mdio.yaml#
+    unevaluatedProperties: false
+    description:
+      Node for the internal MDIO bus connected to the embedded ethernet-PHYs.
+
   mediatek,mcm:
     type: boolean
     description:
-- 
2.39.2

