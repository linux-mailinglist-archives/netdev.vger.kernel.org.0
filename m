Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF164CD2FB
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238416AbiCDLHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238491AbiCDLH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:07:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937381AEEFA;
        Fri,  4 Mar 2022 03:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646392000; x=1677928000;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H0tclyHIfgldFtweIiTINBdh7k3hS+U01t4mgwyX4Zo=;
  b=MwAev0f2L95eU3kN+OQUC+gurY3FEoMTVdFOTaNFz+RE+Lrl9R9jFJnp
   glPbfFvwvlCHnyzUPe8ii5AA1JBnTH9v1oS13Wy13ILMKThe3jFKyLwMN
   4Y0qnJzvdLmCCu/7KhkjbI6PJeqB5uBFAcg93JTB7gOF7hAx2P9qNvoKP
   qsuLfkvmmIEf9QAWqXqTChobbKgYo/9sGYIFmIqW3J/RMErUbdPk63bUp
   zKnbMA3+mW6WHVBUPO3B41+/1vPrzhwziqANDa7zglIOwefUkK+nkehs+
   x3ubSEuajb0oIrG2wFBmqcWVIxiilTRO8PG+GJ/Mbcb6HVJLIm9c60WMh
   A==;
X-IronPort-AV: E=Sophos;i="5.90,155,1643698800"; 
   d="scan'208";a="87822977"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:39 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:39 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:36 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/9] dts: sparx5: Enable ptp interrupt
Date:   Fri, 4 Mar 2022 12:08:54 +0100
Message-ID: <20220304110900.3199904-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for ptp interrupt. This interrupt is used when using 2-step
timestamping. For each timestamp that is added in a queue, an interrupt
is generated.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 arch/arm64/boot/dts/microchip/sparx5.dtsi | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/microchip/sparx5.dtsi b/arch/arm64/boot/dts/microchip/sparx5.dtsi
index 418b32efee6e..e715e2a3c75f 100644
--- a/arch/arm64/boot/dts/microchip/sparx5.dtsi
+++ b/arch/arm64/boot/dts/microchip/sparx5.dtsi
@@ -468,9 +468,10 @@ switch: switch@0x600000000 {
 				<0x6 0x10004000 0x7fc000>,
 				<0x6 0x11010000 0xaf0000>;
 			reg-names = "cpu", "dev", "gcb";
-			interrupt-names = "xtr", "fdma";
+			interrupt-names = "xtr", "fdma", "ptp";
 			interrupts =	<GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>,
-					<GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
+					<GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
+					<GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;
 			resets = <&reset 0>;
 			reset-names = "switch";
 		};
-- 
2.33.0

