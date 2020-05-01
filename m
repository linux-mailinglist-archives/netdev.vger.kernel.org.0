Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB771C1EF8
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 22:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgEAUvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 16:51:01 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:35446 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgEAUvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 16:51:00 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 041KosCN071718;
        Fri, 1 May 2020 15:50:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588366254;
        bh=0xkcc0doKGwbrKG85FZWXCmTENNzrWbpiBRtDHniyeE=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=wPIVT1koIPSRPyQGiS5DGTL5ysutGFSGNdJeU5781PgIhbuNud+lwpq3qbc3F1ptz
         H6L/tVgZs62Z34SJv/kSisDGCDGBzFlEArKyACkY8U6+6A2s3l9yMlj44eM7nwnq2j
         9ob1IT8NTVzLMJKW4R9KjfPzgN2xKZ3UkOFA2jDE=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 041KosW4088978
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 May 2020 15:50:54 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 1 May
 2020 15:50:53 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 1 May 2020 15:50:53 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 041KoqaG029008;
        Fri, 1 May 2020 15:50:53 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Tero Kristo <t-kristo@ti.com>
CC:     Lokesh Vutla <lokeshvutla@ti.com>, <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 6/7] arm64: dts: ti: k3-j721e-mcu: add mcu cpsw cpts node
Date:   Fri, 1 May 2020 23:50:10 +0300
Message-ID: <20200501205011.14899-7-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200501205011.14899-1-grygorii.strashko@ti.com>
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DT node for The TI J721E MCU CPSW CPTS which is part of MCU CPSW NUSS.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
index 3d6064125b40..37c355e5a833 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
@@ -338,5 +338,14 @@
 			clock-names = "fck";
 			bus_freq = <1000000>;
 		};
+
+		cpts {
+			clocks = <&k3_clks 18 2>;
+			clock-names = "cpts";
+			interrupts-extended = <&gic500 GIC_SPI 858 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "cpts";
+			ti,cpts-ext-ts-inputs = <4>;
+			ti,cpts-periodic-outputs = <2>;
+		};
 	};
 };
-- 
2.17.1

