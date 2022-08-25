Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568F15A197D
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 21:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbiHYT0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 15:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiHYT03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 15:26:29 -0400
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82CDBD4E3;
        Thu, 25 Aug 2022 12:26:28 -0700 (PDT)
Received: by mail-oi1-f174.google.com with SMTP id r10so18655286oie.1;
        Thu, 25 Aug 2022 12:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=m8evNcPhqeLW1A8SLLu6xj2sXofnyyO945zkxtib3kI=;
        b=nD1gDhSFomnSQ5AS24p3iMoq0enDBbyYtjJjpar4DzoaplQ1rMODgS+5eZ5cKTyxls
         kMcIgU54MCe5NGH41J+nbSMJh2TxO78yfH75rcrGSXN1ahq39q9bvaW0DfA3TFFDibOF
         2nk1C6PJtfgON/cP7lU4zD3XzEgPn174zE6zpiiBIRrZSu5M5PTIb9TYqTJI4NhqC4I7
         6QhpzGFYWMKNiWZVX1Cr/woRpJ/9TPZSXG77pveggvuImS4nB0HGpW9g6L0Mo9q7/pA7
         KCeB4k8jeQnN1gNX0kU8lSdXzPELGGffQNjsxIW7sfiPbZoym7DUcFMQLe3hgp9RFSEC
         sX2w==
X-Gm-Message-State: ACgBeo1uxLVC1J8+ZfchZTkE4GYRfuDkDCTcqOkdibFozE4rmm1YekuO
        mEjjdnWPbYo+aIDOex475Q==
X-Google-Smtp-Source: AA6agR7ZlKHQ+OMsmEJY34Wan1BNDGjDWoTiUKzNB4Kp3HelY7I9UU1tq+1OVd38UMqjE/eK98LRuw==
X-Received: by 2002:a05:6808:13d0:b0:343:56a3:cc2b with SMTP id d16-20020a05680813d000b0034356a3cc2bmr241537oiw.99.1661455587956;
        Thu, 25 Aug 2022 12:26:27 -0700 (PDT)
Received: from xps15.. (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.googlemail.com with ESMTPSA id u187-20020acaabc4000000b00342df642fd3sm55523oie.48.2022.08.25.12.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 12:26:27 -0700 (PDT)
From:   Rob Herring <robh@kernel.org>
To:     Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Wells Lu <wellslutw@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] dt-bindings: net: Add missing (unevaluated|additional)Properties on child nodes
Date:   Thu, 25 Aug 2022 14:26:07 -0500
Message-Id: <20220825192609.1538463-1-robh@kernel.org>
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

In order to ensure only documented properties are present, node schemas
must have unevaluatedProperties or additionalProperties set to false
(typically). Add missing properties/$refs as exposed by this addition.

Signed-off-by: Rob Herring <robh@kernel.org>
---
v2:
 - Add microchip,sparx5-switch.yaml and sunplus,sp7021-emac.yaml
---
 .../bindings/net/cortina,gemini-ethernet.yaml |  1 +
 .../bindings/net/microchip,sparx5-switch.yaml | 34 ++++++-------------
 .../bindings/net/sunplus,sp7021-emac.yaml     |  2 ++
 .../bindings/net/ti,cpsw-switch.yaml          |  4 +++
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  1 +
 .../bindings/net/ti,k3-am654-cpts.yaml        |  1 +
 6 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
index cc01b9b5752a..253b5d1407ee 100644
--- a/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
+++ b/Documentation/devicetree/bindings/net/cortina,gemini-ethernet.yaml
@@ -37,6 +37,7 @@ properties:
 patternProperties:
   "^ethernet-port@[0-9]+$":
     type: object
+    unevaluatedProperties: false
     description: contains the resources for ethernet port
     allOf:
       - $ref: ethernet-controller.yaml#
diff --git a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
index 6c86d3d85e99..0807aa7a8f63 100644
--- a/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
@@ -74,16 +74,20 @@ properties:
 
   ethernet-ports:
     type: object
+    additionalProperties: false
+
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
     patternProperties:
       "^port@[0-9a-f]+$":
-        type: object
+        $ref: /schemas/net/ethernet-controller.yaml#
+        unevaluatedProperties: false
 
         properties:
-          '#address-cells':
-            const: 1
-          '#size-cells':
-            const: 0
-
           reg:
             description: Switch port number
 
@@ -93,29 +97,11 @@ properties:
               phandle of a Ethernet SerDes PHY.  This defines which SerDes
               instance will handle the Ethernet traffic.
 
-          phy-mode:
-            description:
-              This specifies the interface used by the Ethernet SerDes towards
-              the PHY or SFP.
-
           microchip,bandwidth:
             description: Specifies bandwidth in Mbit/s allocated to the port.
             $ref: "/schemas/types.yaml#/definitions/uint32"
             maximum: 25000
 
-          phy-handle:
-            description:
-              phandle of a Ethernet PHY.  This is optional and if provided it
-              points to the cuPHY used by the Ethernet SerDes.
-
-          sfp:
-            description:
-              phandle of an SFP.  This is optional and used when not specifying
-              a cuPHY.  It points to the SFP node that describes the SFP used by
-              the Ethernet SerDes.
-
-          managed: true
-
           microchip,sd-sgpio:
             description:
               Index of the ports Signal Detect SGPIO in the set of 384 SGPIOs
diff --git a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
index 62dffee27c3d..8e51dcdb4796 100644
--- a/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
+++ b/Documentation/devicetree/bindings/net/sunplus,sp7021-emac.yaml
@@ -32,6 +32,7 @@ properties:
 
   ethernet-ports:
     type: object
+    additionalProperties: false
     description: Ethernet ports to PHY
 
     properties:
@@ -44,6 +45,7 @@ properties:
     patternProperties:
       "^port@[0-1]$":
         type: object
+        additionalProperties: false
         description: Port to PHY
 
         properties:
diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
index 31bf825c6598..46e330f45768 100644
--- a/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.yaml
@@ -77,6 +77,8 @@ properties:
 
   ethernet-ports:
     type: object
+    additionalProperties: false
+
     properties:
       '#address-cells':
         const: 1
@@ -89,6 +91,7 @@ properties:
         description: CPSW external ports
 
         $ref: ethernet-controller.yaml#
+        unevaluatedProperties: false
 
         properties:
           reg:
@@ -117,6 +120,7 @@ properties:
 
   cpts:
     type: object
+    unevaluatedProperties: false
     description:
       The Common Platform Time Sync (CPTS) module
 
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index b8281d8be940..fb61a2ce0ea8 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -115,6 +115,7 @@ properties:
         description: CPSWxG NUSS external ports
 
         $ref: ethernet-controller.yaml#
+        unevaluatedProperties: false
 
         properties:
           reg:
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
index b783ad0d1f53..e9f78cef6b7f 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -95,6 +95,7 @@ properties:
 
   refclk-mux:
     type: object
+    additionalProperties: false
     description: CPTS reference clock multiplexer clock
     properties:
       '#clock-cells':
-- 
2.34.1

