Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D171C50D28E
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 17:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiDXPA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 11:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239526AbiDXO6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 10:58:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE34D2C66C;
        Sun, 24 Apr 2022 07:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1650812153; x=1682348153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tyCkPocd/n9OpJ3ha9mCf5JpKKkgMlRB3JEWvILbkjQ=;
  b=zgMUcTEzcmY9okRvamPHXAsCP7QF0Bnf3/JmIcvmFaZyWaa8dqVziMjf
   MsWw0zzTFNIouC2kkLlkQal3E7Q2S5HtFE8OxibU8MrBh0GHIGjL7UHoP
   xXWlntJFIlinK9NR0ZAtFFTsQyALMkPeuVW9VGL2Zs3DBNlCFYUKLjJsZ
   8wQns/2yCKriYDkwxSBJ6z7WUaPadiSEjd++KQWBSev9actLELpMFM4wr
   qF3AtQ4mG2O1oJpA7GHroYSIp92YM1JBtIzeQdNYfAg+2SIeNLQtekKMe
   ExDCB00nVhAQH8Z3ZJBM6anetqFJMFG2hbD8skGjWApSbW06C0IQm6kOa
   A==;
X-IronPort-AV: E=Sophos;i="5.90,286,1643698800"; 
   d="scan'208";a="153623563"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Apr 2022 07:55:52 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 24 Apr 2022 07:55:51 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sun, 24 Apr 2022 07:55:49 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/5] dt-bindings: net: lan966x: Extend with the ptp external interrupt.
Date:   Sun, 24 Apr 2022 16:58:20 +0200
Message-ID: <20220424145824.2931449-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220424145824.2931449-1-horatiu.vultur@microchip.com>
References: <20220424145824.2931449-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend dt-bindings for lan966x with ptp external interrupt. This is
generated when an external 1pps signal is received on the ptp pin.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index 13812768b923..131dc5a652de 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -39,6 +39,7 @@ properties:
       - description: frame dma based extraction
       - description: analyzer interrupt
       - description: ptp interrupt
+      - description: ptp external interrupt
 
   interrupt-names:
     minItems: 1
@@ -47,6 +48,7 @@ properties:
       - const: fdma
       - const: ana
       - const: ptp
+      - const: ptp-ext
 
   resets:
     items:
-- 
2.33.0

