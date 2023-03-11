Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D326B5C22
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 14:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCKNNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 08:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjCKNNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 08:13:49 -0500
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339BAF0FFA;
        Sat, 11 Mar 2023 05:13:47 -0800 (PST)
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 32BDDQI6087811;
        Sat, 11 Mar 2023 07:13:26 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1678540406;
        bh=kEYDSV6Gh2DW14CuXdqw8T1zKsiopR7bs8xtVKOlGYM=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=pOw1S8yQ9Iy7K/XZJyyL1r9f2y+6Lepf4WkVSbBCVgLe6gd9q8udo0vKBFoh8yFhM
         M7p30PpNImBqvHalGis0F7wVbeki5pA0ZFmqfm6NvI9rydurWPitKwsmOJPkEywj8f
         a4Tofw+/2PEWyFcoJSn7phWMLLYNNsqrsHndJOvY=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 32BDDQrY012210
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 11 Mar 2023 07:13:26 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16; Sat, 11
 Mar 2023 07:13:25 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.16 via
 Frontend Transport; Sat, 11 Mar 2023 07:13:26 -0600
Received: from localhost (ileaxei01-snat2.itg.ti.com [10.180.69.6])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 32BDDQiV016530;
        Sat, 11 Mar 2023 07:13:26 -0600
From:   Nishanth Menon <nm@ti.com>
To:     Sekhar Nori <nsekhar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-gpio@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/2] dt-bindings: net: ti: k3-am654-cpsw-nuss: Drop pinmux header
Date:   Sat, 11 Mar 2023 07:13:24 -0600
Message-ID: <20230311131325.9750-2-nm@ti.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230311131325.9750-1-nm@ti.com>
References: <20230311131325.9750-1-nm@ti.com>
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

Drop the pinmux header reference. Examples should just show the node
definition.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

Looks like there are regressions in this yaml file already when checked
with dt_bindings_check, but that is a seperate activity of it's own.

If net maintainers are OK, I'd like to pick this up as part of the
pinctrl fixes series for next..

 Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
index 900063411a20..837d6db299c4 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -222,7 +222,6 @@ additionalProperties: false
 
 examples:
   - |
-    #include <dt-bindings/pinctrl/k3.h>
     #include <dt-bindings/soc/ti,sci_pm_domain.h>
     #include <dt-bindings/net/ti-dp83867.h>
     #include <dt-bindings/interrupt-controller/irq.h>
-- 
2.37.2

