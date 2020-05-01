Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4463E1C1F0A
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 22:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgEAUwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 16:52:23 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:35528 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbgEAUwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 16:52:22 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 041KqGqB072046;
        Fri, 1 May 2020 15:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588366336;
        bh=G0LrEdkVkiWRft5NWAGfdDX9uXu9hqB1LoI/z2eu9Kg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=UOVd+AsAqu54ama0yvT6gp3B7jwV7s6GiFUTVGHJN121rj9y9wAil7wJVRUhTzGay
         V76AKMglR3A1ON35kEKcJYJdcpbFvmP0JTULKfzir4MpUI2id5jLl7O7rYOHks/UhR
         QkR885+tjIfs2w4MO5O/uUyFBQHX3h/uAM0i/MB8=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 041KqGhv091976
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 May 2020 15:52:16 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 1 May
 2020 15:50:46 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 1 May 2020 15:50:46 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 041Kojml026584;
        Fri, 1 May 2020 15:50:46 -0500
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
Subject: [PATCH net-next 5/7] arm64: dts: ti: k3-am65-main: add main navss cpts node
Date:   Fri, 1 May 2020 23:50:09 +0300
Message-ID: <20200501205011.14899-6-grygorii.strashko@ti.com>
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

Add DT node for Main NAVSS CPTS module.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 6fbb0f2f1d92..3450006260a6 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -583,6 +583,28 @@
 						<0x5>; /* RX_CHAN */
 			ti,sci-rm-range-rflow = <0x6>; /* GP RFLOW */
 		};
+
+		cpts@310d0000 {
+			compatible = "ti,am65-cpts";
+			reg = <0x0 0x310d0000 0x0 0x400>;
+			reg-names = "cpts";
+			clocks = <&main_cpts_mux>;
+			clock-names = "cpts";
+			interrupts-extended = <&intr_main_navss 163 0>;
+			interrupt-names = "cpts";
+			ti,cpts-periodic-outputs = <6>;
+			ti,cpts-ext-ts-inputs = <8>;
+
+			main_cpts_mux: refclk-mux {
+				#clock-cells = <0>;
+				clocks = <&k3_clks 118 5>, <&k3_clks 118 11>,
+					<&k3_clks 118 6>, <&k3_clks 118 3>,
+					<&k3_clks 118 8>, <&k3_clks 118 14>,
+					<&k3_clks 120 3>, <&k3_clks 121 3>;
+				assigned-clocks = <&main_cpts_mux>;
+				assigned-clock-parents = <&k3_clks 118 5>;
+			};
+		};
 	};
 
 	main_gpio0:  main_gpio0@600000 {
-- 
2.17.1

