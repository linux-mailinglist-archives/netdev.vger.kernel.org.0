Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76787562C26
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbiGAG6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233818AbiGAG6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:58:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3165A675AF;
        Thu, 30 Jun 2022 23:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656658728; x=1688194728;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cI1dqkKKIpK4yOXV3RMLwr1JkszHV2K1qB9S3WRpgzc=;
  b=0MFUYRR+hgWCaoS9iXbWXxwIUm50/AIpd7FB33e53fU6vbQ37/MlTS/x
   6/e79JH567AEUOG8vWmYM/9QuPMVcdaQGlSPKSYp9ARoxkxnft6qqAZPT
   fkDIij5q9657EHFB0B0JHXHArsxS51Wi7DTatVVSkn9N4qc2nKq8RflGX
   mlXoBBtHiREZ2n6stxnfP2gqibXycPhMy+XP7w4MdmgKpHYRjShNUpD76
   KyIobJWvhwpbX/Lkvia/YBh44qorblPTgbfDXLOEocMmqMBp1BLcHRGoF
   WOTcZiTwQqBR+eAgfUHpwCC0AFavZ/hJRpUL40r/iAZ7zKL8CiCJMYi5S
   A==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="165961240"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 23:58:47 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 23:58:47 -0700
Received: from wendy.microchip.com (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 23:58:44 -0700
From:   Conor Dooley <conor.dooley@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Conor Dooley" <conor.dooley@microchip.com>
Subject: [net-next PATCH RESEND 1/2] dt-bindings: net: cdns,macb: document polarfire soc's macb
Date:   Fri, 1 Jul 2022 07:58:31 +0100
Message-ID: <20220701065831.632785-2-conor.dooley@microchip.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701065831.632785-1-conor.dooley@microchip.com>
References: <20220701065831.632785-1-conor.dooley@microchip.com>
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

