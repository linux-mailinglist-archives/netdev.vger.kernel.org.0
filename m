Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAE4539940
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348290AbiEaWBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348273AbiEaWBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:01:30 -0400
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D3653E36;
        Tue, 31 May 2022 15:01:30 -0700 (PDT)
Received: by mail-oi1-f173.google.com with SMTP id k11so189349oia.12;
        Tue, 31 May 2022 15:01:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yTPYbOb0yMJHeBLqtKBwI7gKb2/0mzclqkzefPXu2vQ=;
        b=SmaMPQCdkgzVkh0gg6F/sbpksuwfVrP/MkqfQKrETsW/lxJbCAlpzTnZOV5UshpXjt
         ygEDTXzczEy8s4JaBzjuPNvjsg1nC+xE0vQNpoP3/SfY22WvlMdQwQ9DniYTxdIW4lk1
         R9fBLBUmE6U3kJyXfGwb3AUbNrF1s29NfDyTdM3RLhk+MeBZi/svB0oygduaEJhBplib
         VepHGVtSxUol/AxGU0ivuO2XIIV30g1qeXOdYk5/J9R/BeZELmauGHRDJwIZxr9mMKTH
         Hi99rPW/NdHwDSiiSvOqJTDpzE9rglBMg4TzuyZr4YehCi1yb4tHbI5BptMLR0lJRmt2
         3XdA==
X-Gm-Message-State: AOAM532s3KIsrtw2rqVPRu5GrZlCmWPy2ZyP7mckHgnCiWl1gxQI/tiI
        /vQOWj2GjNf0qtNXv3WB7Q==
X-Google-Smtp-Source: ABdhPJzuQgTE6NkTx9TEe2Ykfufrbi4OVxPBBTw2CU6W/TAl7X0sCz/XqhpsuCdgWY0S037TF2IvSQ==
X-Received: by 2002:aca:428a:0:b0:326:4b9d:7272 with SMTP id p132-20020aca428a000000b003264b9d7272mr13340608oia.30.1654034489255;
        Tue, 31 May 2022 15:01:29 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id o18-20020a4a9592000000b0035eb4e5a6d6sm16746ooi.44.2022.05.31.15.01.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 15:01:28 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>
Cc:     Woojung Huh <Woojung.Huh@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] dt-bindings: net/dsa: Add spi-peripheral-props.yaml references
Date:   Tue, 31 May 2022 17:01:18 -0500
Message-Id: <20220531220122.2412711-1-robh@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SPI peripheral device bindings need to reference spi-peripheral-props.yaml
in order to use various SPI controller specific properties. Otherwise,
the unevaluatedProperties check will reject any controller specific
properties.

Signed-off-by: Rob Herring <robh@kernel.org>
---
v3:
 - Drop duplicate 'allOf'
v2:
 - Also add references in nxp,sja1105.yaml and brcm,b53.yaml as
   pointed out by Vladimir Oltean
---
 .../devicetree/bindings/net/dsa/brcm,b53.yaml | 115 ++++++++++--------
 .../bindings/net/dsa/microchip,ksz.yaml       |   1 +
 .../bindings/net/dsa/nxp,sja1105.yaml         |   1 +
 .../devicetree/bindings/net/dsa/realtek.yaml  |   1 +
 4 files changed, 68 insertions(+), 50 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index c3c938893ad9..23114d691d2a 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -6,9 +6,6 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: Broadcom BCM53xx Ethernet switches
 
-allOf:
-  - $ref: dsa.yaml#
-
 maintainers:
   - Florian Fainelli <f.fainelli@gmail.com>
 
@@ -68,53 +65,71 @@ required:
   - compatible
   - reg
 
-# BCM585xx/586xx/88312 SoCs
-if:
-  properties:
-    compatible:
-      contains:
-        enum:
-          - brcm,bcm58522-srab
-          - brcm,bcm58523-srab
-          - brcm,bcm58525-srab
-          - brcm,bcm58622-srab
-          - brcm,bcm58623-srab
-          - brcm,bcm58625-srab
-          - brcm,bcm88312-srab
-then:
-  properties:
-    reg:
-      minItems: 3
-      maxItems: 3
-    reg-names:
-      items:
-        - const: srab
-        - const: mux_config
-        - const: sgmii_config
-    interrupts:
-      minItems: 13
-      maxItems: 13
-    interrupt-names:
-      items:
-        - const: link_state_p0
-        - const: link_state_p1
-        - const: link_state_p2
-        - const: link_state_p3
-        - const: link_state_p4
-        - const: link_state_p5
-        - const: link_state_p7
-        - const: link_state_p8
-        - const: phy
-        - const: ts
-        - const: imp_sleep_timer_p5
-        - const: imp_sleep_timer_p7
-        - const: imp_sleep_timer_p8
-  required:
-    - interrupts
-else:
-  properties:
-    reg:
-      maxItems: 1
+allOf:
+  - $ref: dsa.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,bcm5325
+              - brcm,bcm53115
+              - brcm,bcm53125
+              - brcm,bcm53128
+              - brcm,bcm5365
+              - brcm,bcm5395
+              - brcm,bcm5397
+              - brcm,bcm5398
+    then:
+      $ref: /schemas/spi/spi-peripheral-props.yaml
+
+    # BCM585xx/586xx/88312 SoCs
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,bcm58522-srab
+              - brcm,bcm58523-srab
+              - brcm,bcm58525-srab
+              - brcm,bcm58622-srab
+              - brcm,bcm58623-srab
+              - brcm,bcm58625-srab
+              - brcm,bcm88312-srab
+    then:
+      properties:
+        reg:
+          minItems: 3
+          maxItems: 3
+        reg-names:
+          items:
+            - const: srab
+            - const: mux_config
+            - const: sgmii_config
+        interrupts:
+          minItems: 13
+          maxItems: 13
+        interrupt-names:
+          items:
+            - const: link_state_p0
+            - const: link_state_p1
+            - const: link_state_p2
+            - const: link_state_p3
+            - const: link_state_p4
+            - const: link_state_p5
+            - const: link_state_p7
+            - const: link_state_p8
+            - const: phy
+            - const: ts
+            - const: imp_sleep_timer_p5
+            - const: imp_sleep_timer_p7
+            - const: imp_sleep_timer_p8
+      required:
+        - interrupts
+    else:
+      properties:
+        reg:
+          maxItems: 1
 
 unevaluatedProperties: false
 
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 184152087b60..6bbd8145b6c1 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -12,6 +12,7 @@ maintainers:
 
 allOf:
   - $ref: dsa.yaml#
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 properties:
   # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of additional
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 1ea0bd490473..1e26d876d146 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -14,6 +14,7 @@ description:
 
 allOf:
   - $ref: "dsa.yaml#"
+  - $ref: /schemas/spi/spi-peripheral-props.yaml#
 
 maintainers:
   - Vladimir Oltean <vladimir.oltean@nxp.com>
diff --git a/Documentation/devicetree/bindings/net/dsa/realtek.yaml b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
index 99ee4b5b9346..4f99aff029dc 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/realtek.yaml
@@ -108,6 +108,7 @@ if:
     - reg
 
 then:
+  $ref: /schemas/spi/spi-peripheral-props.yaml#
   not:
     required:
       - mdc-gpios
-- 
2.34.1

