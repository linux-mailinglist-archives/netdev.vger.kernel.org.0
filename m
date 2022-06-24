Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5B559C54
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 16:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiFXOnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 10:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233251AbiFXOm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 10:42:27 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD94E69983;
        Fri, 24 Jun 2022 07:41:56 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 91F21E0002;
        Fri, 24 Jun 2022 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656081715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FoSJsUOkb08Wd+kRslbIkovos/fLvnCrsl/qKDBg3nc=;
        b=WxW2758WXD8QMf7pby78ZcRMxRWeIbG0QAe6cqfTbGU1TWQrq4KG46hybrV44tX+ZRhuoy
        ch5QO3wX62AGocTBfs+c6LRNX8T8mzo7dj7oaTunAQlESnHABTrl6VlMjdPpGnZCy0x2Jx
        g5ZF/+zjoMZV7XXKCiyK4IR/+M8K8+lascK1PBmiY2LJx/NAp2qkB5OmUC1MX8Iie6LzzS
        Xv+Q2aLLetYwjcDu7soVLyvtqDpB6Jq69QecSHF7LYzJImGr98JgZeQQGcAAQMMX9OPHoW
        KQzEyMmYLR0SrByKBT7cZD3CvQN+tIdy3lsxtAog7opd3Iui0XI4D4uehJJHUw==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?q?Miqu=C3=A8l=20Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next v9 11/16] dt-bindings: net: snps,dwmac: add "renesas,rzn1" compatible
Date:   Fri, 24 Jun 2022 16:39:56 +0200
Message-Id: <20220624144001.95518-12-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220624144001.95518-1-clement.leger@bootlin.com>
References: <20220624144001.95518-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "renesas,rzn1-gmac" and "renesas,r9a06g032-gmac" compatible strings.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 09f97fb5596d..491597c02edf 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -65,6 +65,8 @@ properties:
         - ingenic,x2000-mac
         - loongson,ls2k-dwmac
         - loongson,ls7a-dwmac
+        - renesas,r9a06g032-gmac
+        - renesas,rzn1-gmac
         - rockchip,px30-gmac
         - rockchip,rk3128-gmac
         - rockchip,rk3228-gmac
-- 
2.36.1

