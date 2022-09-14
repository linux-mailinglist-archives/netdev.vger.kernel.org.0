Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C1A5B8594
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 11:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbiINJwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 05:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbiINJv4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 05:51:56 -0400
Received: from fllv0016.ext.ti.com (fllv0016.ext.ti.com [198.47.19.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB2266138;
        Wed, 14 Sep 2022 02:51:50 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 28E9p5nN006774;
        Wed, 14 Sep 2022 04:51:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1663149065;
        bh=CL2cbBVuEBtxASYb7DpsxyZqCktdhjJgBmatAHDUBeQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=yLuqpJ04LtErmTj1lZBXz/FmzWqKn48YD1w4vT/t/G5cFY4q7nrbLWxytz+xHaqCa
         WTzSXLruFOEaO1qO1KBLrSSGuE2VRY8srVyzh9L0Po/3mODK8lSloureiBSE4s1RRQ
         5kAqme2dwmsTTe+vNiTKB6JNqgLfSuRYq6oglKV0=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 28E9p5Mj010314
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 14 Sep 2022 04:51:05 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 14
 Sep 2022 04:51:05 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 14 Sep 2022 04:51:05 -0500
Received: from uda0492258.dhcp.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 28E9osD1046564;
        Wed, 14 Sep 2022 04:51:00 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <grygorii.strashko@ti.com>,
        <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kishon@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH 1/8] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J721e CPSW9G
Date:   Wed, 14 Sep 2022 15:20:46 +0530
Message-ID: <20220914095053.189851-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914095053.189851-1-s-vadapalli@ti.com>
References: <20220914095053.189851-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
---
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 821974815dec..868b7fb58b06 100644
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
@@ -181,6 +182,21 @@ required:
   - '#size-cells'
 
 allOf:
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              const: ti,j721e-cpswxg-nuss
+    then:
+      properties:
+        ethernet-ports:
+          patternProperties:
+            "^port@[5-8]$": false
+            properties:
+              reg:
+                maximum: 4
+
   - if:
       not:
         properties:
@@ -192,6 +208,9 @@ allOf:
         ethernet-ports:
           patternProperties:
             "^port@[3-4]$": false
+            properties:
+              reg:
+                maximum: 2
 
 additionalProperties: false
 
-- 
2.25.1

