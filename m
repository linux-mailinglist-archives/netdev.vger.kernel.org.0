Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE906BB88E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbjCOPx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232721AbjCOPxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:53:17 -0400
Received: from lelv0142.ext.ti.com (lelv0142.ext.ti.com [198.47.23.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5804E7F008;
        Wed, 15 Mar 2023 08:52:43 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32FFqTLd020130;
        Wed, 15 Mar 2023 10:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678895549;
        bh=XCi0sFGU/bZfIGFWcczdfBpZzs0AJQJeF/GJyUhgGhk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=I5d/uvPihmNbnXaAFBLMRXfzw5nr0Tbe9gCYECYyxLYciOr+pFSe17HfPpMqgQNiL
         7wtFrDbJjatEFIXLlRX/RptrfpXju0BVVOkjJN+pidDWkgMTCYv//SD7pbD3n4VHSN
         SC/SlzQPF3P8ddm8FjPfvbicSFGM4jGp0HnUW/sA=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32FFqTBt051769
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Mar 2023 10:52:29 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Wed, 15
 Mar 2023 10:52:29 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Wed, 15 Mar 2023 10:52:29 -0500
Received: from localhost (ileaxei01-snat.itg.ti.com [10.180.69.5])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32FFqTPc080258;
        Wed, 15 Mar 2023 10:52:29 -0500
From:   Nishanth Menon <nm@ti.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-gpio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH V2 1/3] dt-bindings: net: ti: k3-am654-cpsw-nuss: Drop pinmux header
Date:   Wed, 15 Mar 2023 10:52:26 -0500
Message-ID: <20230315155228.1566883-2-nm@ti.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315155228.1566883-1-nm@ti.com>
References: <20230315155228.1566883-1-nm@ti.com>
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

Drop the pinmux header reference as it is not used. Examples should
just show the node definition.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
Changes since V1:
 - Minor update to the commit message to indicate the header reference
   is not used.

V1: https://lore.kernel.org/linux-arm-kernel/20230311131325.9750-2-nm@ti.com/

 Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 628d63e1eb1f..f456093840ed 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -232,7 +232,6 @@ additionalProperties: false
 
 examples:
   - |
-    #include <dt-bindings/pinctrl/k3.h>
     #include <dt-bindings/soc/ti,sci_pm_domain.h>
     #include <dt-bindings/net/ti-dp83867.h>
     #include <dt-bindings/interrupt-controller/irq.h>
-- 
2.40.0

