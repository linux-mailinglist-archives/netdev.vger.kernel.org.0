Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113D452E83F
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 11:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347505AbiETJF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 05:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241888AbiETJFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 05:05:25 -0400
X-Greylist: delayed 961 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 May 2022 02:05:22 PDT
Received: from mo-csw-fb.securemx.jp (mo-csw-fb1115.securemx.jp [210.130.202.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBA8EBA97;
        Fri, 20 May 2022 02:05:21 -0700 (PDT)
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1115) id 24K8nLIs003889; Fri, 20 May 2022 17:49:21 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 24K8mix6006635; Fri, 20 May 2022 17:48:44 +0900
X-Iguazu-Qid: 2wHH68dypz2pETqHli
X-Iguazu-QSIG: v=2; s=0; t=1653036523; q=2wHH68dypz2pETqHli; m=4DWdEX+LTA96+LAchSD/5OwZ/gmmYBB9GTdlGYq0WN0=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1111) id 24K8mgeS033499
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 20 May 2022 17:48:42 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH] dt-bindings: net: toshiba,visconti-dwmac: Update the common clock properties
Date:   Fri, 20 May 2022 17:48:23 +0900
X-TSB-HOP2: ON
Message-Id: <20220520084823.620489-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The clock for this driver switched to the common clock controller driver.
Therefore, update common clock properties for ethernet device in the binding
document.

Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../devicetree/bindings/net/toshiba,visconti-dwmac.yaml        | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
index b12bfe61c67a..0988ed8d1c12 100644
--- a/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
@@ -52,6 +52,7 @@ unevaluatedProperties: false
 
 examples:
   - |
+    #include <dt-bindings/clock/toshiba,tmpv770x.h>
     #include <dt-bindings/interrupt-controller/arm-gic.h>
 
     soc {
@@ -63,7 +64,7 @@ examples:
             reg = <0 0x28000000 0 0x10000>;
             interrupts = <GIC_SPI 156 IRQ_TYPE_LEVEL_HIGH>;
             interrupt-names = "macirq";
-            clocks = <&clk300mhz>, <&clk125mhz>;
+            clocks = <&pismu TMPV770X_CLK_PIETHER_BUS>, <&pismu TMPV770X_CLK_PIETHER_125M>;
             clock-names = "stmmaceth", "phy_ref_clk";
             snps,txpbl = <4>;
             snps,rxpbl = <4>;
-- 
2.36.0


