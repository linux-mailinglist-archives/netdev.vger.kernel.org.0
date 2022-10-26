Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330B760DDC7
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 11:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbiJZJKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 05:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232965AbiJZJKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 05:10:38 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF40440576;
        Wed, 26 Oct 2022 02:10:33 -0700 (PDT)
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 29Q9A8lL114229;
        Wed, 26 Oct 2022 04:10:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1666775408;
        bh=IdNLaLzMZVzW4p9xSgPQZhZew/8sCviXSbaXRCPi30s=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=F7NlJEo8dO6GTtcHGveC2a6Ad/hHTmdLBFBCgr/p3wfZRPxTiMUYRqkuHSDJIEnLf
         c8znn4ziYeog89KYpi3ePvLVde11gyYAdhiXr9/lcxcZVnE/Av9nsz1TxWL9wZkdFb
         kzuECDOgDNWWOXX7jy7HrdAL6rXO+QwYkEanAZh8=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 29Q9A8QZ022848
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Oct 2022 04:10:08 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Wed, 26
 Oct 2022 04:10:08 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Wed, 26 Oct 2022 04:10:08 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 29Q99wxq005870;
        Wed, 26 Oct 2022 04:10:03 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <s-vadapalli@ti.com>
Subject: [PATCH v3 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J721e CPSW9G
Date:   Wed, 26 Oct 2022 14:39:55 +0530
Message-ID: <20221026090957.180592-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221026090957.180592-1-s-vadapalli@ti.com>
References: <20221026090957.180592-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

