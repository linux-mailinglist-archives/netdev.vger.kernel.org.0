Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B18F532C08
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 16:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbiEXOMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 10:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiEXOME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 10:12:04 -0400
Received: from baptiste.telenet-ops.be (baptiste.telenet-ops.be [IPv6:2a02:1800:120:4::f00:13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E06750006
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 07:12:01 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed30:4593:272c:6293:e2cc])
        by baptiste.telenet-ops.be with bizsmtp
        id aeBv270132jQL2A01eBvKB; Tue, 24 May 2022 16:11:59 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ntVGN-001Uwr-33; Tue, 24 May 2022 16:11:55 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ntVGM-000POV-KT; Tue, 24 May 2022 16:11:54 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Michael Hennerich <michael.hennerich@analog.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: net: adin: Fix adi,phy-output-clock description syntax
Date:   Tue, 24 May 2022 16:11:53 +0200
Message-Id: <6fcef2665a6cd86a021509a84c5956ec2efd93ed.1653401420.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"make dt_binding_check":

    Documentation/devicetree/bindings/net/adi,adin.yaml:40:77: [error] syntax error: mapping values are not allowed here (syntax)

The first line of the description ends with a colon, hence the block
needs to be marked with a "|".

Fixes: 1f77204e11f8b9e5 ("dt-bindings: net: adin: document phy clock output properties")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
index 77750df0c2c45e19..88611720545df2ce 100644
--- a/Documentation/devicetree/bindings/net/adi,adin.yaml
+++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
@@ -37,7 +37,8 @@ properties:
     default: 8
 
   adi,phy-output-clock:
-    description: Select clock output on GP_CLK pin. Two clocks are available:
+    description: |
+      Select clock output on GP_CLK pin. Two clocks are available:
       A 25MHz reference and a free-running 125MHz.
       The phy can alternatively automatically switch between the reference and
       the 125MHz clocks based on its internal state.
-- 
2.25.1

