Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D783265D0BF
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 11:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbjADKfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 05:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238864AbjADKfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 05:35:11 -0500
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0D81EC7A;
        Wed,  4 Jan 2023 02:35:09 -0800 (PST)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 304AYhe0089539;
        Wed, 4 Jan 2023 04:34:43 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1672828483;
        bh=f+/hD2UAEmnR3+Go/lOUiJffhqgYnLACZh9HsbiXWfc=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=IRpjrVynZZULfuYE7l1fp7OO2pwYUexKgCgVFlt6fqQI8bQipCY4DH8qA966HM89P
         QNUVVQWTQn6ENZX+4KEv85dUhM+6crECaJDjbmrKSPjhzJULSaxnl04cNBWXQ4/i3w
         YJfli6Mpx6j8AU0L1r5Luts0rRIY9RZiYXNtmIy0=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 304AYhTK049655
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Jan 2023 04:34:43 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 4
 Jan 2023 04:34:43 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 4 Jan 2023 04:34:43 -0600
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 304AYWFX018054;
        Wed, 4 Jan 2023 04:34:38 -0600
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next v6 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J721e CPSW9G support
Date:   Wed, 4 Jan 2023 16:04:30 +0530
Message-ID: <20230104103432.1126403-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230104103432.1126403-1-s-vadapalli@ti.com>
References: <20230104103432.1126403-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update bindings for TI K3 J721e SoC which contains 9 ports (8 external
ports) CPSW9G module and add compatible for it.

Changes made:
    - Add new compatible ti,j721e-cpswxg-nuss for CPSW9G.
    - Extend pattern properties for new compatible.
    - Change maximum number of CPSW ports to 8 for new compatible.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 33 ++++++++++++++++---
 1 file changed, 29 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 821974815dec..900063411a20 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -57,6 +57,7 @@ properties:
       - ti,am654-cpsw-nuss
       - ti,j7200-cpswxg-nuss
       - ti,j721e-cpsw-nuss
+      - ti,j721e-cpswxg-nuss
       - ti,am642-cpsw-nuss
 
   reg:
@@ -111,7 +112,7 @@ properties:
         const: 0
 
     patternProperties:
-      "^port@[1-4]$":
+      "^port@[1-8]$":
         type: object
         description: CPSWxG NUSS external ports
 
@@ -121,7 +122,7 @@ properties:
         properties:
           reg:
             minimum: 1
-            maximum: 4
+            maximum: 8
             description: CPSW port number
 
           phys:
@@ -186,12 +187,36 @@ allOf:
         properties:
           compatible:
             contains:
-              const: ti,j7200-cpswxg-nuss
+              const: ti,j721e-cpswxg-nuss
     then:
       properties:
         ethernet-ports:
           patternProperties:
-            "^port@[3-4]$": false
+            "^port@[5-8]$": false
+            "^port@[1-4]$":
+              properties:
+                reg:
+                  minimum: 1
+                  maximum: 4
+
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              enum:
+                - ti,j721e-cpswxg-nuss
+                - ti,j7200-cpswxg-nuss
+    then:
+      properties:
+        ethernet-ports:
+          patternProperties:
+            "^port@[3-8]$": false
+            "^port@[1-2]$":
+              properties:
+                reg:
+                  minimum: 1
+                  maximum: 2
 
 additionalProperties: false
 
-- 
2.25.1

