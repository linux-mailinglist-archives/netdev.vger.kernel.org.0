Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16A767143A
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 07:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjARGbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 01:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjARG1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 01:27:17 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 237A3392B0;
        Tue, 17 Jan 2023 22:17:11 -0800 (PST)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id F0DA324DC7D;
        Wed, 18 Jan 2023 14:17:04 +0800 (CST)
Received: from EXMBX073.cuchost.com (172.16.6.83) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 18 Jan
 2023 14:17:04 +0800
Received: from wyh-VirtualBox.starfivetech.com (171.223.208.138) by
 EXMBX073.cuchost.com (172.16.6.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.42; Wed, 18 Jan 2023 14:17:03 +0800
From:   Yanhong Wang <yanhong.wang@starfivetech.com>
To:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Subject: [PATCH v4 1/7] dt-bindings: net: snps,dwmac: Add dwmac-5.20 version
Date:   Wed, 18 Jan 2023 14:16:55 +0800
Message-ID: <20230118061701.30047-2-yanhong.wang@starfivetech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX073.cuchost.com
 (172.16.6.83)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emil Renner Berthing <kernel@esmil.dk>

Add dwmac-5.20 IP version to snps.dwmac.yaml

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 13b984076af5..e26c3e76ebb7 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -30,6 +30,7 @@ select:
           - snps,dwmac-4.10a
           - snps,dwmac-4.20a
           - snps,dwmac-5.10a
+          - snps,dwmac-5.20
           - snps,dwxgmac
           - snps,dwxgmac-2.10
 
@@ -87,6 +88,7 @@ properties:
         - snps,dwmac-4.10a
         - snps,dwmac-4.20a
         - snps,dwmac-5.10a
+        - snps,dwmac-5.20
         - snps,dwxgmac
         - snps,dwxgmac-2.10
 
@@ -393,6 +395,7 @@ allOf:
               - snps,dwmac-3.50a
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
+              - snps,dwmac-5.20
               - snps,dwxgmac
               - snps,dwxgmac-2.10
               - st,spear600-gmac
@@ -447,6 +450,7 @@ allOf:
               - snps,dwmac-4.10a
               - snps,dwmac-4.20a
               - snps,dwmac-5.10a
+              - snps,dwmac-5.20
               - snps,dwxgmac
               - snps,dwxgmac-2.10
               - st,spear600-gmac
-- 
2.17.1

