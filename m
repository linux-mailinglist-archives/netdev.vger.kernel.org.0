Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306161C1EFA
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 22:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgEAUvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 16:51:04 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49238 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgEAUvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 16:51:03 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 041KouFD080776;
        Fri, 1 May 2020 15:50:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588366256;
        bh=LhttJw1JbjTgnmdvEPuQ5xgCDkw1lEfTeMZ9lnsUOOs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=AzWR0avdQVa+SIH4vJtK+qkZQ4OmgWJCjaJyzRMov1mHKc7E7pPJ+aq/5TDX/7mSc
         aa9FrD4umBIX6dkuHJ7w7lnKA9j7ff58oecw7Gvzs2W3wVMv4/ci8zqhHRgmNv70uY
         t8FnNWOLluMH6OaFXdnJ/K0exkWZMThpSL/KzyIU=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 041Kougc049222
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 May 2020 15:50:56 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 1 May
 2020 15:50:55 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 1 May 2020 15:50:55 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 041KosiP099423;
        Fri, 1 May 2020 15:50:55 -0500
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
Subject: [PATCH net-next 7/7] arm64: dts: ti: j721e-main: add main navss cpts node
Date:   Fri, 1 May 2020 23:50:11 +0300
Message-ID: <20200501205011.14899-8-grygorii.strashko@ti.com>
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
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
index 0b9d14b838a1..844a5b50cf09 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-main.dtsi
@@ -254,6 +254,18 @@
 						<0x0c>; /* RX_UHCHAN */
 			ti,sci-rm-range-rflow = <0x00>; /* GP RFLOW */
 		};
+
+		cpts@310d0000 {
+			compatible = "ti,j721e-cpts";
+			reg = <0x0 0x310d0000 0x0 0x400>;
+			reg-names = "cpts";
+			clocks = <&k3_clks 201 1>;
+			clock-names = "cpts";
+			interrupts-extended = <&main_navss_intr 201 0>;
+			interrupt-names = "cpts";
+			ti,cpts-periodic-outputs = <6>;
+			ti,cpts-ext-ts-inputs = <8>;
+		};
 	};
 
 	main_pmx0: pinmux@11c000 {
-- 
2.17.1

