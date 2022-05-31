Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3BB53986E
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 23:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347877AbiEaVKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 17:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235409AbiEaVKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 17:10:41 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F610D10C;
        Tue, 31 May 2022 14:10:40 -0700 (PDT)
Received: by mail-ot1-f48.google.com with SMTP id r3-20020a9d5cc3000000b0060ae1789875so10390819oti.13;
        Tue, 31 May 2022 14:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jzW1JdSSaJMwGg3qesFwvu8mpZHhPD4+MXniK61Rt3c=;
        b=E1MoRHMgdIaBH/BWBDdqy7BTwcIWpSvjOR6D3V4i2aaj2aI8Q0wRoleHA+YLl3oDtB
         V7hW4/YJ/0G2Cn29SBLs3ggMFDvf7E0Qq9Z/i7EJbnNG3ZVJAWFEStEJ8nmxKpTeleG6
         0YTJSBOBd74iSPm6brgpTIi8xcdU3kEpZRLniogcLE3tUmKPS5GpmB2de0OYOPerj34b
         UrdUyNPtyNEUeaYs9oh+DPUSkUG7hMKRb3r2EZ9P2tKwAhWL8/tgH293amq84ku4mmYF
         q4cHhKOZ5nhQmB+ZsKGHx4YoA9vnQikGEZyEQxIUZ3RbuP0jfQe8CIWmm/XUmwF0xv2C
         tG2w==
X-Gm-Message-State: AOAM53338ZlIiRnx4MDZs6NeAxHrWByV4P5ovP+1averNMtVKSrFcFhV
        2TETj0VWW5uYWPc1xKTfPw==
X-Google-Smtp-Source: ABdhPJxNbIKdjEPRgo4JQ5V9dqSJhYalfYXMYMRH+TkW2RI3oPMZ9jeXHWstJRfOkTdb8QXyB0wqew==
X-Received: by 2002:a05:6830:2705:b0:606:c10:e4b5 with SMTP id j5-20020a056830270500b006060c10e4b5mr23985649otu.74.1654031439450;
        Tue, 31 May 2022 14:10:39 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id l13-20020a9d550d000000b0060adbf4f89dsm6550556oth.77.2022.05.31.14.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 14:10:38 -0700 (PDT)
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
Subject: [PATCH v2] dt-bindings: net/dsa: Add spi-peripheral-props.yaml references
Date:   Tue, 31 May 2022 16:10:14 -0500
Message-Id: <20220531211018.2287964-1-robh@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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
v2:
 - Also add references in nxp,sja1105.yaml and brcm,b53.yaml as
   pointed out by Vladimir Oltean
---
 .../devicetree/bindings/net/dsa/brcm,b53.yaml | 112 ++++++++++--------
 .../bindings/net/dsa/microchip,ksz.yaml       |   1 +
 .../bindings/net/dsa/nxp,sja1105.yaml         |   1 +
 .../devicetree/bindings/net/dsa/realtek.yaml  |   1 +
 4 files changed, 68 insertions(+), 47 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
index c3c938893ad9..09814288c685 100644
--- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
@@ -68,53 +68,71 @@ required:
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

