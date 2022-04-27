Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97EE5111A9
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358356AbiD0GvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358340AbiD0GvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:51:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAC814D29C;
        Tue, 26 Apr 2022 23:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651042092; x=1682578092;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tyCkPocd/n9OpJ3ha9mCf5JpKKkgMlRB3JEWvILbkjQ=;
  b=MNvHzFxLrSNGqvcog7PqkXfEY7dcVhrH4ldSgD8ykJXUm2Vq+k6Bd3d1
   gW/wUqrrlS0BdmAzA1xCbi5Go/ZSSUWqHOCTLYIRGCx2S+EImjxVZFvxo
   48VTNrBZlhKcbObLiwn5ldn5oyR4Oij/LYYOg4cI4fTFS09sNPJFp8KcZ
   79o41Kkz4Af9jzkQ3pqLlnARCC1hXVpwMkv0SqSKIBYN546p1hbJAxmFN
   7s7haIwDpamiSj5UXlfq3tciRAuADT2q2VA7ToHDAiWsSgvNbQzmNxnTB
   FPSlq78YituzzaqBCu23RqgxNw49PuJtUwx+1OYug8VD2q/zSIrks1uLz
   A==;
X-IronPort-AV: E=Sophos;i="5.90,292,1643698800"; 
   d="scan'208";a="161876549"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Apr 2022 23:48:11 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 26 Apr 2022 23:48:11 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 26 Apr 2022 23:48:09 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <UNGLinuxDriver@microchip.com>, <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/5] dt-bindings: net: lan966x: Extend with the ptp external interrupt.
Date:   Wed, 27 Apr 2022 08:51:23 +0200
Message-ID: <20220427065127.3765659-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220427065127.3765659-1-horatiu.vultur@microchip.com>
References: <20220427065127.3765659-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

