Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05A5261A1D7
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiKDUDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiKDUCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:02:55 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F9651C01;
        Fri,  4 Nov 2022 13:02:12 -0700 (PDT)
Received: by mail-oi1-f171.google.com with SMTP id l127so6258350oia.8;
        Fri, 04 Nov 2022 13:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SJDm6ZwA/4FnL4+xX4lXkBOljkX+IoHERBT/+QgPzuE=;
        b=mAKqWnFfnp3qRr8cSZGj6j+DKZL1loJFe0zz70ot3mxYr9psYewn+akmhW2kSe4v8K
         tq4XUNRGWGNj9mFgXuqQLGxJcwoZigCAfttxIJ2jHkw7a7+OKBDbn6lqgnrkMzdvfXWd
         Vi84W4zQHWFXvtdovELe6Jg0oaKtuGuexK2DXzYT57T/jsGu49iFUy4Pl8ACmFzElmS4
         hZwXjXr86rlc8xXduDOgodGhoQMPNXRhiYin1QYf68SVISXdwKVeTAS+PuT9B7nD4j5v
         e7YUEX58wbBju30Rx6mVkmtamjxyyYd0g5XEuoinc4aMUM0NZToxbsb1qXoUC4VbfnzJ
         SL3w==
X-Gm-Message-State: ACrzQf3mMJWfv+UN1oQChByJL5TH4KhPHzbMyl1q2dniqdnEK/oZ8N4h
        ta2bn6REeoGHSnh/xf/VMQ==
X-Google-Smtp-Source: AMsMyM6Ipf6S0fbARxOeLpKUo6SzRbVO9jETbh+4MRfT+gXkGSDVrL16sjzp3xIW9/gcVs7RMXvOIg==
X-Received: by 2002:a05:6808:8e2:b0:35a:2f3e:4210 with SMTP id d2-20020a05680808e200b0035a2f3e4210mr11136724oic.7.1667592131831;
        Fri, 04 Nov 2022 13:02:11 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j36-20020a9d17a7000000b0066c55e23a16sm132454otj.2.2022.11.04.13.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 13:02:11 -0700 (PDT)
Received: (nullmailer pid 2405323 invoked by uid 1000);
        Fri, 04 Nov 2022 20:02:12 -0000
Date:   Fri, 4 Nov 2022 15:02:12 -0500
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?iso-8859-1?Q?n=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH v2 net-next 0/6] dt-binding preparation for ocelot
 switches
Message-ID: <20221104200212.GA2315642-robh@kernel.org>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104045204.746124-1-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 03, 2022 at 09:51:58PM -0700, Colin Foster wrote:
> Ocelot switches have the abilitiy to be used internally via
> memory-mapped IO or externally via SPI or PCIe. This brings up issues
> for documentation, where the same chip might be accessed internally in a
> switchdev manner, or externally in a DSA configuration. This patch set
> is perparation to bring DSA functionality to the VSC7512, utilizing as
> much as possible with an almost identical VSC7514 chip.
> 
> During the most recent RFC for internal ethernet switch functionality to
> the VSC7512, there were 10 steps laid out to adequately prepare
> documentation:
> 
> https://lore.kernel.org/all/20221010174856.nd3n4soxk7zbmcm7@skbuf/
> 
> The full context is quoted below. This patch set represents steps 1-7 of
> the 10 steps, with the remaining steps to likely be part of what was the
> original RFC.
> 
> The first two patches are specifically rewording and fixing of the MFD
> bindings. I kept them in this patch set since they might cause conflicts
> with future documentation changes that will be part of the net-next
> tree. I can separate them if desired.
> 
> 
> 
> Context:
> 
> ```
> To end the discussion on a constructive note, I think if I were Colin,
> I would do the following, in the following order, according to what was
> expressed as a constraint:
> 
> 1. Reword the "driver" word out of mscc,vsc7514-switch.yaml and express
>    the description in terms of what the switch can do, not what the
>    driver can do.
> 
> 2. Make qca8k.yaml have "$ref: dsa.yaml#". Remove "$ref: dsa-port.yaml#"
>    from the same schema.

No, you need dsa-port.yaml referenced because it has DSA port properties 
plus custom qca8k properties.

> 
> 3. Remove "- $ref: dsa-port.yaml#" from mediatek,mt7530.yaml. It doesn't
>    seem to be needed, since dsa.yaml also has this. We need this because
>    we want to make sure no one except dsa.yaml references dsa-port.yaml.

You don't seem to need it in mediatek,mt7530.yaml, but only dsa.yaml 
referencing dsa-port.yaml is not what we need. dsa-port.yaml wouldn't 
(and didn't at one time) exist if only dsa.yaml needed it.

Something like the below patch is on top of your changes is what's 
needed. For DSA, there are 2 cases, custom properties in 'port' nodes 
and no custom properties. '(ethernet-)?ports' never has custom 
properties AFAICT (brcm,sf2 had brcm,use-bcm-hdr in the wrong place).

Bindings using only standard DSA properties need to reference 
'dsa.yaml#'. Bindings with custom 'ethernet-port' node properties need 
to use 'dsa.yaml#/$defs/base' and then under the ethernet-port node 
reference dsa-port.yaml, define their custom properties, and set 
'unevaluatedProperties: false'.

Obviously this needs to be refactored into proper patches and/or 
squashed into yours. Probably a patch to fix brcm,sf2 and one to add 
dsa.yaml#/$defs/base, then split out switch stuff.

8<-------------------------------------------------------------------
diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
index 259a0c6547f3..8d5abb05abdf 100644
--- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 maintainers:
   - George McCollister <george.mccollister@gmail.com>
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index 1219b830b1a4..f323fc01b224 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -66,7 +66,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
index d159ac78cec1..eed16e216fb6 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,sf2.yaml
@@ -85,11 +85,16 @@ properties:
   ports:
     type: object
 
-    properties:
-      brcm,use-bcm-hdr:
-        description: if present, indicates that the switch port has Broadcom
-          tags enabled (per-packet metadata)
-        type: boolean
+    patternProperties:
+      '^port@[0-9a-f]$':
+        $ref: dsa-port.yaml#
+        unevaluatedProperties: false
+
+        properties:
+          brcm,use-bcm-hdr:
+            description: if present, indicates that the switch port has Broadcom
+              tags enabled (per-packet metadata)
+            type: boolean
 
 required:
   - reg
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index d97fb87cccb0..0672443ea7a6 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -14,6 +14,8 @@ maintainers:
 description:
   Ethernet switch port Description
 
+$ref: /schemas/net/ethernet-switch-port.yaml#
+
 properties:
   label:
     description:
diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 2290a9d32b21..1b3593a36014 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -21,9 +21,6 @@ select: false
 $ref: "/schemas/net/ethernet-switch.yaml#"
 
 properties:
-  $nodename:
-    pattern: "^(ethernet-)?switch(@.*)?$"
-
   dsa,member:
     minItems: 2
     maxItems: 2
@@ -36,4 +33,20 @@ properties:
 
 additionalProperties: true
 
+$defs:
+  base:
+    description: A DSA without any extra port properties
+    $ref: '#/'
+
+    patternProperties:
+      "^(ethernet-)?ports$":
+        type: object
+
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            description: Ethernet switch ports
+            $ref: /schemas/net/dsa/dsa-port.yaml#
+            unevaluatedProperties: false
+
+
 ...
diff --git a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
index 73b774eadd0b..e27b1619066f 100644
--- a/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Hirschmann Hellcreek TSN Switch Device Tree Bindings
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
index 81f291105660..564783fcb685 100644
--- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
@@ -156,21 +156,15 @@ patternProperties:
 
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        properties:
-          reg:
-            description:
-              Port address described must be 5 or 6 for CPU port and from 0 to 5
-              for user ports.
-
         allOf:
           - if:
               required: [ ethernet ]
             then:
               properties:
                 reg:
+                  description:
+                    Port address described must be 5 or 6 for CPU port and from 0 to 5
+                    for user ports.
                   enum:
                     - 5
                     - 6
@@ -235,7 +229,7 @@ $defs:
                       - sgmii
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
   - if:
       required:
         - mediatek,mcm
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 4da75b1f9533..bfa2b76659c9 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -11,7 +11,7 @@ maintainers:
   - Woojung Huh <Woojung.Huh@microchip.com>
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 properties:
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
index 630bf0f8294b..f4f9798addae 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -10,7 +10,7 @@ maintainers:
   - UNGLinuxDriver@microchip.com
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
index 8d93ed9c172c..a7041ae4d811 100644
--- a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -78,7 +78,7 @@ required:
   - reg
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
   - if:
       properties:
         compatible:
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 1e26d876d146..13a835af9468 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -13,7 +13,7 @@ description:
   depends on the SPI bus master driver.
 
 allOf:
-  - $ref: "dsa.yaml#"
+  - $ref: dsa.yaml#/$defs/base
   - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 maintainers:
diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index d831d5eee437..a33abdb9ead0 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -77,8 +77,7 @@ patternProperties:
     type: object
     patternProperties:
       "^(ethernet-)?port@[0-6]$":
-        type: object
-        description: Ethernet switch ports
+        $ref: dsa-port.yaml#
 
         properties:
           qca,sgmii-rxclk-falling-edge:
@@ -102,7 +101,7 @@ patternProperties:
               SGMII on the QCA8337, it is advised to set this unless a communication
               issue is observed.
 
-        unevaluatedProperties: true
+        unevaluatedProperties: false
 
 oneOf:
   - required:
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 1a7d45a8ad66..ad1793eba31a 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Realtek switches for unmanaged switches
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 maintainers:
   - Linus Walleij <linus.walleij@linaro.org>
diff --git a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
index 7ca9c19a157c..eb9ea25efcb7 100644
--- a/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
@@ -14,7 +14,7 @@ description: |
   handles 4 ports + 1 CPU management port.
 
 allOf:
-  - $ref: dsa.yaml#
+  - $ref: dsa.yaml#/$defs/base
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
index f698857619da..0d417997c163 100644
--- a/Documentation/devicetree/bindings/net/ethernet-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -25,6 +25,8 @@ properties:
 patternProperties:
   "^(ethernet-)?ports$":
     type: object
+    additionalProperties: false
+
     properties:
       '#address-cells':
         const: 1
@@ -36,10 +38,6 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        allOf:
-          - $ref: /schemas/net/dsa/dsa-port.yaml#
-          - $ref: ethernet-switch-port.yaml#
-
 oneOf:
   - required:
       - ports
@@ -48,4 +46,20 @@ oneOf:
 
 additionalProperties: true
 
+$defs:
+  base:
+    description: An Ethernet switch without any extra port properties
+    $ref: '#/'
+
+    patternProperties:
+      "^(ethernet-)?ports$":
+        type: object
+
+        patternProperties:
+          "^(ethernet-)?port@[0-9]+$":
+            description: Ethernet switch ports
+            $ref: ethernet-switch-port.yaml#
+            unevaluatedProperties: false
+
+
 ...
