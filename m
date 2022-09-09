Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E993B5B335C
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 11:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiIIJNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 05:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbiIIJNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 05:13:38 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C8C1140511
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 02:13:34 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:91db:705e:cfbc:a001])
        by michel.telenet-ops.be with bizsmtp
        id HlDT2800Q0sKggw06lDTP1; Fri, 09 Sep 2022 11:13:32 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oWa4l-004bai-1M; Fri, 09 Sep 2022 11:13:27 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1oWa4k-004Oco-BZ; Fri, 09 Sep 2022 11:13:26 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] dt-bindings: net: renesas,etheravb: R-Car V3U is R-Car Gen4
Date:   Fri,  9 Sep 2022 11:13:22 +0200
Message-Id: <5355709e0744680d792d1e57e43441cb0b7b7611.1662714607.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662714607.git.geert+renesas@glider.be>
References: <cover.1662714607.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Despite the name, R-Car V3U is the first member of the R-Car Gen4
family.  Hence move its compatible value to the R-Car Gen4 section.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
index acf347f3cdbe2284..cd5998e08e2195be 100644
--- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
+++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
@@ -40,9 +40,13 @@ properties:
               - renesas,etheravb-r8a77980     # R-Car V3H
               - renesas,etheravb-r8a77990     # R-Car E3
               - renesas,etheravb-r8a77995     # R-Car D3
-              - renesas,etheravb-r8a779a0     # R-Car V3U
           - const: renesas,etheravb-rcar-gen3 # R-Car Gen3 and RZ/G2
 
+      - items:
+          - enum:
+              - renesas,etheravb-r8a779a0     # R-Car V3U
+          - const: renesas,etheravb-rcar-gen4 # R-Car Gen4
+
       - items:
           - enum:
               - renesas,etheravb-r9a09g011 # RZ/V2M
-- 
2.25.1

