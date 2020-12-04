Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958AE2CEE25
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 13:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388159AbgLDMgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 07:36:05 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16990 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388100AbgLDMgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 07:36:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607085364; x=1638621364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=jY0R1/xfu6HtmxjTgcdxe7QK3p92MvvnE8O6H0jUXmQ=;
  b=Z/8nISejN2IxSRL4Iv0NbelVS3NA4HTu8BR1+TKinpSvgcy0G7MXrE3g
   qA7zwjHdesYBjgyEEtS6nqNqs246c4FB+PjCv880kW2KoD522mc//ByGo
   aPPrumn1yGVEekcBd6GVBbGuufU+Gg252djMC/03Hu61LzNDP0KarbUQ7
   usVZVawZDVoTLLkrRGB0vegJsrYh+0tlhkHfwS7UJTBRwIdCFUfOa7Zov
   kdjFHod8IJfiJ2reYq4vWiK1fohSu1bV+WPYjuo/cFXyOqpY4hiE6so1w
   zBv5dXKTvtEG0YweFocx+Gy+XUl2D9OWJf3NEkDaWrbZXm2dGua+x9mF7
   Q==;
IronPort-SDR: yQcU00xr0zK5tubVLPX5yonEi3W28OoMB75jGJ27XyOAH8cxFiBkx2AQdlqnlsVrC3mRfJea2L
 /mmu1c4UViqAWU9R7q0mkGi7u7WNAsDbgVhpq/DchS5cxVFpoYXq2gmTsImtzf42ODbQrDb7/T
 MNrbFhl7pN9EzZrMNmJcNS77XwPl/i70xht4+qlz4vAgdsPGSP7e+DHmPdm0zi/UyxnH8y30Iw
 1v59h/WuSXPyGdnKdQh+3p/Mdip0w7DSPcMTaH0CP96wUDsIM5qrU9sM1C2qcEh+hsRi0/d1BL
 EQM=
X-IronPort-AV: E=Sophos;i="5.78,392,1599548400"; 
   d="scan'208";a="106188081"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 05:34:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 05:34:59 -0700
Received: from m18063-ThinkPad-T460p.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 4 Dec 2020 05:34:53 -0700
From:   Claudiu Beznea <claudiu.beznea@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <nicolas.ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: [PATCH 4/7] dt-bindings: add documentation for sama7g5 ethernet interface
Date:   Fri, 4 Dec 2020 14:34:18 +0200
Message-ID: <1607085261-25255-5-git-send-email-claudiu.beznea@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for SAMA7G5 ethernet interface.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 0b61a90f1592..26543a4e15d5 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -16,6 +16,7 @@ Required properties:
   Use "cdns,zynq-gem" Xilinx Zynq-7xxx SoC.
   Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
   Use "sifive,fu540-c000-gem" for SiFive FU540-C000 SoC.
+  Use "microchip,sama7g5-emac" for Microchip SAMA7G5 ethernet interface.
   Or the generic form: "cdns,emac".
 - reg: Address and length of the register set for the device
 	For "sifive,fu540-c000-gem", second range is required to specify the
-- 
2.7.4

