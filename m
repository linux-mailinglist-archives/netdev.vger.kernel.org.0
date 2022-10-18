Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B566027B3
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 10:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiJRI6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 04:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiJRI6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 04:58:46 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB97B5601B;
        Tue, 18 Oct 2022 01:58:44 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 29I8wKVS043072;
        Tue, 18 Oct 2022 03:58:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1666083500;
        bh=fiJqSuC8rqk4lF90DGjukNBCSWf2butQagXjLdw25pw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=UD34uEE5FF+e7q48GYYHr2joWia1WkYWGYJG3ogPrvRlCNAPe9TPOoK2jDvEmtd9f
         w6zQfdtbHJktURQF8Yj6gmlkVRaJ3oQG2AJrmbzX24JN4bP/uQbyYQbZiQFJmMxm5z
         xOkUN3CGk+0Gc9OcIR3rmLlmXyDOrEk/g0DD2+to=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 29I8wKk2014881
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Oct 2022 03:58:20 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6; Tue, 18
 Oct 2022 03:58:20 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.6 via
 Frontend Transport; Tue, 18 Oct 2022 03:58:20 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 29I8wAcP010100;
        Tue, 18 Oct 2022 03:58:15 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <linux@armlinux.org.uk>,
        <vladimir.oltean@nxp.com>, <vigneshr@ti.com>, <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <s-vadapalli@ti.com>
Subject: [PATCH v2 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J721e CPSW9G
Date:   Tue, 18 Oct 2022 14:28:08 +0530
Message-ID: <20221018085810.151327-2-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221018085810.151327-1-s-vadapalli@ti.com>
References: <20221018085810.151327-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 821974815dec..ec4b57e43e88 100644
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
+              properties:
+                reg:
+                  maximum: 4
+
   - if:
       not:
         properties:
@@ -192,6 +208,9 @@ allOf:
         ethernet-ports:
           patternProperties:
             "^port@[3-4]$": false
+              properties:
+                reg:
+                  maximum: 2
 
 additionalProperties: false
 
-- 
2.25.1

