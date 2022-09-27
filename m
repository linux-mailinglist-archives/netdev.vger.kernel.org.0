Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1083E5EB6CC
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 03:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiI0BZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 21:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiI0BY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 21:24:59 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93765A889;
        Mon, 26 Sep 2022 18:24:57 -0700 (PDT)
Received: from tr.lan (ip-86-49-12-201.bb.vodafone.cz [86.49.12.201])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id C4FAD845EF;
        Tue, 27 Sep 2022 03:24:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1664241895;
        bh=Qbar4PN2LNDaYnWve5+IGbY8N/ouTxJqLJBgGyp/dDY=;
        h=From:To:Cc:Subject:Date:From;
        b=xq0CJi0mSWcQfknmt8561ovABRtORwgw6khEAAczjDRPLZW+bMdfclkSPtYORp5ib
         qxlaoiKHk5xcmSjq749r9odlwMyvZJCN8AjQUxf3tnMbjtXDX970S337IvZW7W+pFw
         SxTC7nzOsoOQAi3FF59OIlV0zpf/FiAwPW9MczCqzUEXFGlPThV8u1IbyXouDVAuwG
         gHWtqIIZC0foDK3kfqCZI3ZfT83K6QLjEl80YG7T5gs2gK8TxIjNJfkMNz/mMhFdtj
         hxT4/4nYvE8GjReaHmIZOVTyy3IltjW9xdwUXhB6eWhpuM8OthMGe8guYJmw+ZbgYk
         mSwBnRCxi65jA==
From:   Marek Vasut <marex@denx.de>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Subject: [PATCH] dt-bindings: net: snps,dwmac: Document stmmac-axi-config subnode
Date:   Tue, 27 Sep 2022 03:24:49 +0200
Message-Id: <20220927012449.698915-1-marex@denx.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The stmmac-axi-config subnode is present in multiple dwmac instance DTs,
document its content per snps,axi-config property description which is
a phandle to this subnode.

Signed-off-by: Marek Vasut <marex@denx.de>
---
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: netdev@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
---
 .../devicetree/bindings/net/snps,dwmac.yaml   | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 2d4e7c7c230a5..be8cd44e6a2aa 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -302,6 +302,60 @@ properties:
     required:
       - compatible
 
+  stmmac-axi-config:
+    type: object
+    unevaluatedProperties: false
+    description:
+      AXI BUS Mode parameters.
+
+    properties:
+      snps,lpi_en:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description:
+          enable Low Power Interface
+
+      snps,xit_frm:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description:
+          unlock on WoL
+
+      snps,wr_osr_lmt:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description:
+          max write outstanding req. limit
+
+      snps,rd_osr_lmt:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description:
+          max read outstanding req. limit
+
+      snps,kbbe:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description:
+          do not cross 1KiB boundary.
+
+      snps,blen:
+        $ref: /schemas/types.yaml#/definitions/uint32-array
+        description:
+          this is a vector of supported burst length.
+        minItems: 7
+        maxItems: 7
+
+      snps,fb:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description:
+          fixed-burst
+
+      snps,mb:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description:
+          mixed-burst
+
+      snps,rb:
+        $ref: /schemas/types.yaml#/definitions/flag
+        description:
+          rebuild INCRx Burst
+
 required:
   - compatible
   - reg
-- 
2.35.1

