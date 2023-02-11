Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9297A692DA8
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjBKDSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBKDSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:18:37 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [46.235.227.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F9F35BC;
        Fri, 10 Feb 2023 19:18:36 -0800 (PST)
Received: from localhost (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 68A966602111;
        Sat, 11 Feb 2023 03:18:35 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676085515;
        bh=wsikCNMiZKFgLF8VxbMNAMN5xcuiLSDwJPFjv5RhtwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oG7+IzcdTybxpjx0fCajzTllBsTQirmb2YxPbpyMYNXWSRrIAHC7OipNowaNEiehe
         nsmTXnfkdBTJ0J3ms/SBwjXwha0y8QURPT20tk9pBIRJPSJ6oiJZDjGJdLYtm3/zVq
         6pEbMm+dj3Wk8AAPu8hHutHV9oOZKf47dT+dR7nt0LuuUEhl32SdHwYkKyxuzM+JKs
         cmYUI0CSBL+sVPigjhXrQ4JdiAcv9OZLhfUo0cRs5Eswf1nC7JJfkZlXrBWF9BbBH7
         rZDQ+oxqseId/nIhnNOfqp+COqhx/NzKmuaV5r5smcVl/ukDw2uxlaCtLTvsqvE6eP
         fhlibOa4agYlQ==
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
To:     Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
Subject: [PATCH 01/12] dt-bindings: riscv: sifive-ccache: Add compatible for StarFive JH7100 SoC
Date:   Sat, 11 Feb 2023 05:18:10 +0200
Message-Id: <20230211031821.976408-2-cristian.ciocaltea@collabora.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the compatible for the SiFive Composable Cache Controller found
on the StarFive JH7100 SoC.

This also requires extending the 'reg' property to handle distinct
ranges, as specified via 'reg-names'.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
---
 .../bindings/riscv/sifive,ccache0.yaml        | 28 ++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
index 31d20efaa6d3..2b864b2f12c9 100644
--- a/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
+++ b/Documentation/devicetree/bindings/riscv/sifive,ccache0.yaml
@@ -25,6 +25,7 @@ select:
           - sifive,ccache0
           - sifive,fu540-c000-ccache
           - sifive,fu740-c000-ccache
+          - starfive,jh7100-ccache
 
   required:
     - compatible
@@ -37,6 +38,7 @@ properties:
               - sifive,ccache0
               - sifive,fu540-c000-ccache
               - sifive,fu740-c000-ccache
+              - starfive,jh7100-ccache
           - const: cache
       - items:
           - const: starfive,jh7110-ccache
@@ -70,7 +72,13 @@ properties:
       - description: DirFail interrupt
 
   reg:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+
+  reg-names:
+    items:
+      - const: control
+      - const: sideband
 
   next-level-cache: true
 
@@ -89,6 +97,7 @@ allOf:
           contains:
             enum:
               - sifive,fu740-c000-ccache
+              - starfive,jh7100-ccache
               - starfive,jh7110-ccache
               - microchip,mpfs-ccache
 
@@ -106,12 +115,29 @@ allOf:
             Must contain entries for DirError, DataError and DataFail signals.
           maxItems: 3
 
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: starfive,jh7100-ccache
+
+    then:
+      properties:
+        reg:
+          maxItems: 2
+
+    else:
+      properties:
+        reg:
+          maxItems: 1
+
   - if:
       properties:
         compatible:
           contains:
             enum:
               - sifive,fu740-c000-ccache
+              - starfive,jh7100-ccache
               - starfive,jh7110-ccache
 
     then:
-- 
2.39.1

