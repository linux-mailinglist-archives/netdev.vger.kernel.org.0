Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF1A5A0B48
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbiHYIX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238831AbiHYIXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:23:50 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19019A572E;
        Thu, 25 Aug 2022 01:23:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661415798; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Q4NsZdlp0PPYf6Y5oln8AWAGrH4eDRWjF6zy5nyNF0fjs9NSJuis1L6v6fRIOSEP/YXywkIPZdfLzlOZceKJllAjB5ccyg0Ig3n+gqQqXtlbq9CboP4R5vyCKbPonvvcoIM0U025Jmv2Es5CinAFzSvgpW0QZoOy4hb73pKD2Uo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1661415798; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=WgdOW7ryOZz5p4feBiY6z2PhhWL00d5o0elsMpsRC4I=; 
        b=SUprM0ZIgWGOdXEqhk0Pdk/qYMFMauCZ5JEc0b0ms1djj4CuoNZ00Ag8UmluxN/E57z+j/TpFB7BjeSeWyopPk3ir09Yio0CP1fWmuJBht+XomaQTkBuk7Pfqv+KqI7fRNIdYHYnp/0e1gVZJYfwcIsAHlRXExLLdc4wZKowxXQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1661415798;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
        bh=WgdOW7ryOZz5p4feBiY6z2PhhWL00d5o0elsMpsRC4I=;
        b=goSE6zIhEp9Ejgy8m4bYMvZ3/vrnuDZcccwDRjn6RLJeTQ1WQTHOHatHAK04TpoN
        vWWgKNnRa6NPQ1S3AdpZFnpaVohATOGqD81Ro2LZAmMjB0DF2guheTWzR45HtPt3Ldw
        f3CeAooirAOucrh7jNcSwymNbsDbtJpvf3hJUTUY=
Received: from arinc9-PC.lan (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1661415796720114.84929287702482; Thu, 25 Aug 2022 01:23:16 -0700 (PDT)
From:   =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH v6 1/6] dt-bindings: net: dsa: mediatek,mt7530: make trivial changes
Date:   Thu, 25 Aug 2022 11:22:56 +0300
Message-Id: <20220825082301.409450-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220825082301.409450-1-arinc.unal@arinc9.com>
References: <20220825082301.409450-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make trivial changes on the binding.

- Update title to include MT7531 switch.
- Add me as a maintainer. List maintainers in alphabetical order by first
name.
- Add description to compatible strings.
- Stretch descriptions up to the 80 character limit.
- Remove lists for single items.
- Remove requiring reg as it's already required by dsa-port.yaml.
- Define acceptable reg values for the CPU ports.
- Remove quotes from $ref: "dsa.yaml#".

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 .../bindings/net/dsa/mediatek,mt7530.yaml     | 50 ++++++++++++-------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 17ab6c69ecc7..c1dc712706c4 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -4,12 +4,13 @@
 $id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Mediatek MT7530 Ethernet switch
+title: Mediatek MT7530 and MT7531 Ethernet Switches
 
 maintainers:
-  - Sean Wang <sean.wang@mediatek.com>
+  - Arınç ÜNAL <arinc.unal@arinc9.com>
   - Landen Chao <Landen.Chao@mediatek.com>
   - DENG Qingfang <dqfext@gmail.com>
+  - Sean Wang <sean.wang@mediatek.com>
 
 description: |
   Port 5 of mt7530 and mt7621 switch is muxed between:
@@ -61,10 +62,18 @@ description: |
 
 properties:
   compatible:
-    enum:
-      - mediatek,mt7530
-      - mediatek,mt7531
-      - mediatek,mt7621
+    oneOf:
+      - description:
+          Standalone MT7530 and multi-chip module MT7530 in MT7623AI SoC
+        const: mediatek,mt7530
+
+      - description:
+          Standalone MT7531
+        const: mediatek,mt7531
+
+      - description:
+          Multi-chip module MT7530 in MT7621AT, MT7621DAT and MT7621ST SoCs
+        const: mediatek,mt7621
 
   reg:
     maxItems: 1
@@ -79,7 +88,7 @@ properties:
   gpio-controller:
     type: boolean
     description:
-      if defined, MT7530's LED controller will run on GPIO mode.
+      If defined, MT7530's LED controller will run on GPIO mode.
 
   "#interrupt-cells":
     const: 1
@@ -92,8 +101,8 @@ properties:
   io-supply:
     description:
       Phandle to the regulator node necessary for the I/O power.
-      See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt
-      for details for the regulator setup on these boards.
+      See Documentation/devicetree/bindings/regulator/mt6323-regulator.txt for
+      details for the regulator setup on these boards.
 
   mediatek,mcm:
     type: boolean
@@ -110,8 +119,8 @@ properties:
 
   resets:
     description:
-      Phandle pointing to the system reset controller with line index for
-      the ethsys.
+      Phandle pointing to the system reset controller with line index for the
+      ethsys.
     maxItems: 1
 
 patternProperties:
@@ -128,27 +137,31 @@ patternProperties:
         properties:
           reg:
             description:
-              Port address described must be 5 or 6 for CPU port and from 0
-              to 5 for user ports.
+              Port address described must be 5 or 6 for CPU port and from 0 to 5
+              for user ports.
 
         allOf:
           - $ref: dsa-port.yaml#
           - if:
               properties:
                 label:
-                  items:
-                    - const: cpu
+                  const: cpu
             then:
               required:
-                - reg
                 - phy-mode
 
+              properties:
+                reg:
+                  enum:
+                    - 5
+                    - 6
+
 required:
   - compatible
   - reg
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#
   - if:
       required:
         - mediatek,mcm
@@ -163,8 +176,7 @@ allOf:
   - if:
       properties:
         compatible:
-          items:
-            - const: mediatek,mt7530
+          const: mediatek,mt7530
     then:
       required:
         - core-supply
-- 
2.34.1

