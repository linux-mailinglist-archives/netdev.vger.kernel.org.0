Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3787D6D3B6E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 03:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjDCBUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 21:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbjDCBU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 21:20:28 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77190BDDB;
        Sun,  2 Apr 2023 18:19:59 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pj8rT-0004p3-1d;
        Mon, 03 Apr 2023 03:19:55 +0200
Date:   Mon, 3 Apr 2023 02:19:51 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnG5hbA==?= <arinc.unal@arinc9.com>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next v2 14/14] dt-bindings: net: dsa: mediatek,mt7530:
 add mediatek,mt7988-switch
Message-ID: <dffacdb59aea462c9f7d4242cf9563a04cf79807.1680483896.git.daniel@makrotopia.org>
References: <cover.1680483895.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1680483895.git.daniel@makrotopia.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the built-in switch which can be found in the
MediaTek MT7988 SoC.

Signed-off-by: Daniel Golle <daniel@makrotopia.org>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 26 +++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 5ae9cd8f99a24..8d6dfed11d8d6 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -11,16 +11,23 @@ maintainers:
   - Landen Chao <Landen.Chao@mediatek.com>
   - DENG Qingfang <dqfext@gmail.com>
   - Sean Wang <sean.wang@mediatek.com>
+  - Daniel Golle <daniel@makrotopia.org>
 
 description: |
-  There are two versions of MT7530, standalone and in a multi-chip module.
+  There are three versions of MT7530, standalone, in a multi-chip module and
+  built-into a SoC.
 
   MT7530 is a part of the multi-chip module in MT7620AN, MT7620DA, MT7620DAN,
   MT7620NN, MT7621AT, MT7621DAT, MT7621ST and MT7623AI SoCs.
 
+  The MT7988 SoC comes with a built-in switch similar to MT7531 as well as four
+  Gigabit Ethernet PHYs. The switch registers are directly mapped into the SoC's
+  memory map rather than using MDIO. The switch got an internally connected 10G
+  CPU port and 4 user ports connected to the built-in Gigabit Ethernet PHYs.
+
   MT7530 in MT7620AN, MT7620DA, MT7620DAN and MT7620NN SoCs has got 10/100 PHYs
   and the switch registers are directly mapped into SoC's memory map rather than
-  using MDIO. The DSA driver currently doesn't support this.
+  using MDIO. The DSA driver currently doesn't support MT7620 variants.
 
   There is only the standalone version of MT7531.
 
@@ -81,6 +88,10 @@ properties:
           Multi-chip module MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs
         const: mediatek,mt7621
 
+      - description:
+          Built-in switch of the MT7988 SoC
+        const: mediatek,mt7988-switch
+
   reg:
     maxItems: 1
 
@@ -268,6 +279,17 @@ allOf:
       required:
         - mediatek,mcm
 
+  - if:
+      properties:
+        compatible:
+          const: mediatek,mt7988-switch
+    then:
+      $ref: "#/$defs/mt7530-dsa-port"
+      properties:
+        gpio-controller: false
+        mediatek,mcm: false
+        reset-names: false
+
 unevaluatedProperties: false
 
 examples:
-- 
2.40.0

