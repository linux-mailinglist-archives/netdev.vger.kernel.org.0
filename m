Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584EE4DCDE7
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbiCQSut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237598AbiCQSun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:50:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8A414A913;
        Thu, 17 Mar 2022 11:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647542966; x=1679078966;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PZK7t6renrW3eZPCm7Lk7qffTcGlqKELQtWdjAVV5iw=;
  b=q0Ox4f5zH/04Ef7JuMZNQtPh1iIneWaLI+2Hz00W7v03kdCJeERoaaqO
   OYqt+MfuRAl8mGn03nfcq08+1rQ9EnZqPmTTU+WqublWB9NYDuWQ07Nuk
   IKUgIezssVOqfBgschQ1v2gAgvuiizyCU9ieEQX0uRA4Rijzkgoh9rbSK
   ldCVdLv+zB1aNyg5EmmKLubZipOXPtdsStrzOxZ4g/da5g2PU0lvKJXKg
   nvL4Eh9EGPXOSy/2v+KMtC/qZ0XMtYeTF7x1gXp36apDQYcZeGUrPzue5
   BqkXM2iX91zi4SOmMSmC2xD0GeipA0rWtJzTIJEPuBcMr/BWJKm9Y/Xs/
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="152385615"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 11:49:25 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 11:49:25 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 17 Mar 2022 11:49:23 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/5] dt-bindings: net: lan966x: Extend with FDMA interrupt
Date:   Thu, 17 Mar 2022 19:51:55 +0100
Message-ID: <20220317185159.1661469-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
References: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend dt-bindings for lan966x with FDMA interrupt. This is generated
when receiving a frame or when a frame was transmitted. The interrupt
needs to be enable for each frame.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index 13812768b923..14e0bae5965f 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -39,6 +39,7 @@ properties:
       - description: frame dma based extraction
       - description: analyzer interrupt
       - description: ptp interrupt
+      - description: fdma interrupt
 
   interrupt-names:
     minItems: 1
@@ -47,6 +48,7 @@ properties:
       - const: fdma
       - const: ana
       - const: ptp
+      - const: fdma
 
   resets:
     items:
-- 
2.33.0

