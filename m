Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176406BAA42
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjCOIAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbjCOIAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:00:20 -0400
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4576C184;
        Wed, 15 Mar 2023 01:00:17 -0700 (PDT)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32F80407054869;
        Wed, 15 Mar 2023 03:00:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678867205;
        bh=o1Xy3YzcsNOmVloP5gcFnX+KR+X0F0/tjFEx4dNex18=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=I2PP6IQdxow197DImG2XWC2RMd3yjZ52TsJQRKa8JT7FmPdcqwA962nMFrMkbTS1s
         hGnZrY/SDVonMifzrgzfjcgCgJtaQaoh63q8DiBLnsihWZQV+RaS3sE73GWkuq2c7r
         DuuUyaxbVstIlbYHY3i1JawJSz7Mtyc+amVenLHU=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32F803c8023501
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Mar 2023 03:00:04 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 15
 Mar 2023 03:00:02 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 15 Mar 2023 03:00:02 -0500
Received: from uda0492258.dhcp.ti.com (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32F7xmKd042755;
        Wed, 15 Mar 2023 02:59:58 -0500
From:   Siddharth Vadapalli <s-vadapalli@ti.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski@linaro.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <nsekhar@ti.com>,
        <rogerq@kernel.org>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: [PATCH net-next 2/2] dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J784S4 CPSW9G support
Date:   Wed, 15 Mar 2023 13:29:48 +0530
Message-ID: <20230315075948.1683120-3-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230315075948.1683120-1-s-vadapalli@ti.com>
References: <20230315075948.1683120-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update bindings for TI K3 J784S4 SoC which contains 9 ports (8 external
ports) CPSW9G module and add compatible for it.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml      | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 6f56add1919b..306709bcc9e9 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -59,6 +59,7 @@ properties:
       - ti,j7200-cpswxg-nuss
       - ti,j721e-cpsw-nuss
       - ti,j721e-cpswxg-nuss
+      - ti,j784s4-cpswxg-nuss
 
   reg:
     maxItems: 1
@@ -197,7 +198,9 @@ allOf:
         properties:
           compatible:
             contains:
-              const: ti,j721e-cpswxg-nuss
+              enum:
+                - ti,j721e-cpswxg-nuss
+                - ti,j784s4-cpswxg-nuss
     then:
       properties:
         ethernet-ports:
@@ -217,6 +220,7 @@ allOf:
               enum:
                 - ti,j7200-cpswxg-nuss
                 - ti,j721e-cpswxg-nuss
+                - ti,j784s4-cpswxg-nuss
     then:
       properties:
         ethernet-ports:
-- 
2.25.1

