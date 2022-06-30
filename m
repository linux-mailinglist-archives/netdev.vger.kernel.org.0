Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A4C561444
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiF3IHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiF3IHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:07:36 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E639341311;
        Thu, 30 Jun 2022 01:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656576456; x=1688112456;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cI1dqkKKIpK4yOXV3RMLwr1JkszHV2K1qB9S3WRpgzc=;
  b=Z2B6gyECfWG2blMPuX8EANbDyILdIAMl2ATm84NlIvdoftjYtlyf6p47
   SpXXLchLWJO4AHNtvTtMIEA9kUxTe0x46Lg0y+QnxmAyJ9+CT123j+aw9
   JoZmr6ZhQ5gFhbIJ71ourWwOaUueCkgkZszyC5lUcE8AvEezsem30RpTA
   Qj3dBawyiPfooZYlYYG24BIJO0Fr+9aI7ePJpgY5+9I2kUNIqIS/azIMB
   DDS1wfnEKL4IhR+J7a1JmpP80IrKORHoWO4E8nI6q7ZSyAdN7RBoyJ22Y
   XkJ0zKq1Sd5PBsz/q9hwQSDJrnx/leZexfQ/u/+VNlVDN7CPXhOpgnh9e
   g==;
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="165782000"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 01:07:35 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 01:07:33 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 01:07:30 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        "Nicolas Ferre" <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Daire McNamara" <daire.mcnamara@microchip.com>
CC:     Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>
Subject: [PATCH v1 02/14] dt-bindings: net: cdns,macb: document polarfire soc's macb
Date:   Thu, 30 Jun 2022 09:05:21 +0100
Message-ID: <20220630080532.323731-3-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630080532.323731-1-conor.dooley@microchip.com>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Until now the PolarFire SoC (MPFS) has been using the generic
"cdns,macb" compatible but has optional reset support. Add a specific
compatible which falls back to the currently used generic binding.

Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
---
 Documentation/devicetree/bindings/net/cdns,macb.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 86fc31c2d91b..9c92156869b2 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -28,6 +28,7 @@ properties:
           - enum:
               - cdns,at91sam9260-macb # Atmel at91sam9 SoCs
               - cdns,sam9x60-macb     # Microchip sam9x60 SoC
+              - microchip,mpfs-macb   # Microchip PolarFire SoC
           - const: cdns,macb          # Generic
 
       - items:
-- 
2.36.1

