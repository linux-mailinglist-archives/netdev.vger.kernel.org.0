Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B4C411864
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241644AbhITPj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:39:28 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60068 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238080AbhITPjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:39:25 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18KFbege047365;
        Mon, 20 Sep 2021 10:37:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1632152260;
        bh=71iTNYvSXz7PJ6/1p3pzVlud0Eg7uyTxPUQOHqjQ5fk=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=NV7ffnl1ecIPnrNQ/JltD+BZ2yCpFJZT8W4QHG54OdD04Vk5Ref/SSM9lDo2PWcKn
         gHqQOFPBTrkduI7v2nhnLq77vSXXv8JyUfOU5iK+0JJBDm/kyTIcZDbFo8mOtyr9Zh
         2k36RLPWI4QqxTzoIBZD6d6o2C9gBcy1ajnsQTcc=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18KFbekB006380
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Sep 2021 10:37:40 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 20
 Sep 2021 10:37:39 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 20 Sep 2021 10:37:39 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18KFbPJj104098;
        Mon, 20 Sep 2021 10:37:34 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Faiz Abbas <faiz_abbas@ti.com>, Nishanth Menon <nm@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: [PATCH v3 1/6] arm64: dts: ti: k3-am65-mcu: Add Support for MCAN
Date:   Mon, 20 Sep 2021 21:07:18 +0530
Message-ID: <20210920153724.20203-2-a-govindraju@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210920153724.20203-1-a-govindraju@ti.com>
References: <20210920153724.20203-1-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

Add Support for two MCAN controllers present on the am65x SOC. Both support
classic CAN messages as well as CAN-FD.

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi | 30 +++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi b/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi
index c93ff1520a0e..8d592bf41d6f 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-mcu.dtsi
@@ -159,6 +159,36 @@
 		};
 	};
 
+	m_can0: mcan@40528000 {
+		compatible = "bosch,m_can";
+		reg = <0x0 0x40528000 0x0 0x400>,
+		      <0x0 0x40500000 0x0 0x4400>;
+		reg-names = "m_can", "message_ram";
+		power-domains = <&k3_pds 102 TI_SCI_PD_EXCLUSIVE>;
+		clocks = <&k3_clks 102 5>, <&k3_clks 102 0>;
+		clock-names = "hclk", "cclk";
+		interrupt-parent = <&gic500>;
+		interrupts = <GIC_SPI 544 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 545 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "int0", "int1";
+		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+	};
+
+	m_can1: mcan@40568000 {
+		compatible = "bosch,m_can";
+		reg = <0x0 0x40568000 0x0 0x400>,
+		      <0x0 0x40540000 0x0 0x4400>;
+		reg-names = "m_can", "message_ram";
+		power-domains = <&k3_pds 103 TI_SCI_PD_EXCLUSIVE>;
+		clocks = <&k3_clks 103 5>, <&k3_clks 103 0>;
+		clock-names = "hclk", "cclk";
+		interrupt-parent = <&gic500>;
+		interrupts = <GIC_SPI 547 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 548 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "int0", "int1";
+		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+	};
+
 	fss: fss@47000000 {
 		compatible = "simple-bus";
 		#address-cells = <2>;
-- 
2.17.1

