Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16AD951854B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236078AbiECNY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236021AbiECNYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:24:23 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F5732EEA;
        Tue,  3 May 2022 06:20:49 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id EA91E22239;
        Tue,  3 May 2022 15:20:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651584045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QKQ2Vjk8KdDckCR4TKDVeWXPZ4ML8IO5y9dGDQ2irB0=;
        b=V0cu+/1+38N/6igVfGBcOKJzC6ZzZxqneDKEGlTH/8zVVR6rVOZekmJzJJSnk9/HquMi78
        H3NHfBDdplZKl/6j0GOeYcp83MskQ0P2BIA5gccEl/j8Y5WIwPxS+6ysLPZxf52VWUl1Ti
        fyZkon4Ngwux88TNjZOGZyG8VNi2edI=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next] dt-bindings: net: lan966x: fix example
Date:   Tue,  3 May 2022 15:20:38 +0200
Message-Id: <20220503132038.2714128-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 4fdabd509df3 ("dt-bindings: net: lan966x: remove PHY reset")
the PHY reset was removed, but I failed to remove it from the example.
Fix it.

Fixes: 4fdabd509df3 ("dt-bindings: net: lan966x: remove PHY reset")
Reported-by: Rob Herring <robh@kernel.org>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../devicetree/bindings/net/microchip,lan966x-switch.yaml     | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index f3ed708de0eb..dc116f14750e 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -145,8 +145,8 @@ examples:
       reg-names = "cpu", "gcb";
       interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
       interrupt-names = "xtr";
-      resets = <&switch_reset 0>, <&phy_reset 0>;
-      reset-names = "switch", "phy";
+      resets = <&switch_reset 0>;
+      reset-names = "switch";
       ethernet-ports {
         #address-cells = <1>;
         #size-cells = <0>;
-- 
2.30.2

