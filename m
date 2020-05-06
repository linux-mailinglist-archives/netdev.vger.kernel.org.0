Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706091C791A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbgEFSOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:14:39 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35006 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbgEFSOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 14:14:38 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046IEWbf113157;
        Wed, 6 May 2020 13:14:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588788872;
        bh=BqMkVbEYuFaecKA7rKJabagbooFKYyBAcXaS1sUncZU=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=iohR2VXfroinko+5Qu1QQtZEqSvOcWGk8rQcO8/4/M6OuiHfmz7CEuwKTQK1+r9P9
         JvOCrXcIJxzXrQA6wEQ3Kiq+vWeLcbVOBKWNuqsrf2EPF27pEAnXvk/5BoyBeFPh5Z
         xuccM5U/YgxGM52vp7rektyYT8yjiN+9R2nOdF0M=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046IEWwY094194
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 13:14:32 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 13:14:31 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 13:14:31 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046IEUhO049102;
        Wed, 6 May 2020 13:14:31 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Tero Kristo <t-kristo@ti.com>
CC:     <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 3/3] arm64: dts: ti: k3-am65/j721e-mcu: update cpts node
Date:   Wed, 6 May 2020 21:14:01 +0300
Message-ID: <20200506181401.28699-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506181401.28699-1-grygorii.strashko@ti.com>
References: <20200506181401.28699-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update CPTS node following DT binding update:
 - add reg and compatible properties
 - fix node name

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi         | 4 +++-
 arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi b/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi
index 0e773e0b3f89..ae5f813d0cac 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi
@@ -248,7 +248,9 @@
 			bus_freq = <1000000>;
 		};
 
-		cpts {
+		cpts@3d000 {
+			compatible = "ti,am65-cpts";
+			reg = <0x0 0x3d000 0x0 0x400>;
 			clocks = <&mcu_cpsw_cpts_mux>;
 			clock-names = "cpts";
 			interrupts-extended = <&gic500 GIC_SPI 570 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
index 37c355e5a833..dc31bd0434cb 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721e-mcu-wakeup.dtsi
@@ -339,7 +339,9 @@
 			bus_freq = <1000000>;
 		};
 
-		cpts {
+		cpts@3d000 {
+			compatible = "ti,am65-cpts";
+			reg = <0x0 0x3d000 0x0 0x400>;
 			clocks = <&k3_clks 18 2>;
 			clock-names = "cpts";
 			interrupts-extended = <&gic500 GIC_SPI 858 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.17.1

