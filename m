Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849D3426807
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbhJHKhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:37:13 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:3359 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239931AbhJHKhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:37:08 -0400
Received: (Authenticated sender: herve.codina@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPA id 972B924000E;
        Fri,  8 Oct 2021 10:35:11 +0000 (UTC)
From:   Herve Codina <herve.codina@bootlin.com>
Cc:     Herve Codina <herve.codina@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 2/4] dt-bindings: net: snps,dwmac: add dwmac 3.40a IP version
Date:   Fri,  8 Oct 2021 12:34:38 +0200
Message-Id: <20211008103440.3929006-3-herve.codina@bootlin.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008103440.3929006-1-herve.codina@bootlin.com>
References: <20211008103440.3929006-1-herve.codina@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dwmac 3.40a is an old ip version that can be found on SPEAr3xx soc.

Signed-off-by: Herve Codina <herve.codina@bootlin.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 42689b7d03a2..c115c95ee584 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -21,6 +21,7 @@ select:
       contains:
         enum:
           - snps,dwmac
+          - snps,dwmac-3.40a
           - snps,dwmac-3.50a
           - snps,dwmac-3.610
           - snps,dwmac-3.70a
@@ -76,6 +77,7 @@ properties:
         - rockchip,rk3399-gmac
         - rockchip,rv1108-gmac
         - snps,dwmac
+        - snps,dwmac-3.40a
         - snps,dwmac-3.50a
         - snps,dwmac-3.610
         - snps,dwmac-3.70a
-- 
2.31.1

