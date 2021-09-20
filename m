Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DB1411875
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241922AbhITPj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:39:59 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:60214 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241772AbhITPjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:39:54 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 18KFcA4r047476;
        Mon, 20 Sep 2021 10:38:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1632152290;
        bh=+JouLh5Momb6lqq6ZZo85PEEyzhpnL+WYjdTnXEJY88=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=nMyDUsUkwDThVK2yuolN17C6prfWRfTxbwuTxHNE52Wd7qQXhlo7+yKA5dCDeQMfx
         nCQbK7vxDSYzs7wbdPgsmw762o3naIk/Rp0ynTSfZraoGAbLGWLEGWxDbyYfNlSs6M
         6dWn0z9aDHeSw9aYU9O7s5b9eaf6Rgh8sksqxuPg=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 18KFc9pC013167
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 20 Sep 2021 10:38:09 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 20
 Sep 2021 10:38:09 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Mon, 20 Sep 2021 10:38:09 -0500
Received: from gsaswath-HP-ProBook-640-G5.dal.design.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 18KFbPJn104098;
        Mon, 20 Sep 2021 10:38:04 -0500
From:   Aswath Govindraju <a-govindraju@ti.com>
CC:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Aswath Govindraju <a-govindraju@ti.com>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <kristo@kernel.org>,
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
Subject: [PATCH v3 5/6] arm64: dts: ti: k3-am64-main: Add support for MCAN
Date:   Mon, 20 Sep 2021 21:07:22 +0530
Message-ID: <20210920153724.20203-6-a-govindraju@ti.com>
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

Add Support for two MCAN controllers present on the am64x SOC. Both support
classic CAN messages as well as CAN-FD.

Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi | 28 ++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
index 42d1d219a3fd..73862ca847f8 100644
--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -973,4 +973,32 @@
 		clocks = <&k3_clks 53 0>;
 		clock-names = "fck";
 	};
+
+	main_mcan0: can@20701000 {
+		compatible = "bosch,m_can";
+		reg = <0x00 0x20701000 0x00 0x200>,
+		      <0x00 0x20708000 0x00 0x8000>;
+		reg-names = "m_can", "message_ram";
+		power-domains = <&k3_pds 98 TI_SCI_PD_EXCLUSIVE>;
+		clocks = <&k3_clks 98 5>, <&k3_clks 98 0>;
+		clock-names = "hclk", "cclk";
+		interrupts = <GIC_SPI 155 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 156 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "int0", "int1";
+		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+	};
+
+	main_mcan1: can@20711000 {
+		compatible = "bosch,m_can";
+		reg = <0x00 0x20711000 0x00 0x200>,
+		      <0x00 0x20718000 0x00 0x8000>;
+		reg-names = "m_can", "message_ram";
+		power-domains = <&k3_pds 99 TI_SCI_PD_EXCLUSIVE>;
+		clocks =  <&k3_clks 99 5>, <&k3_clks 99 0>;
+		clock-names = "hclk", "cclk";
+		interrupts = <GIC_SPI 158 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 159 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "int0", "int1";
+		bosch,mram-cfg = <0x0 128 64 64 64 64 32 32>;
+	};
 };
-- 
2.17.1

