Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13FE444463
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 16:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhKCPOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 11:14:06 -0400
Received: from ixit.cz ([94.230.151.217]:60862 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhKCPOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 11:14:06 -0400
Received: from localhost.localdomain (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 8A99024E6D;
        Sat, 30 Oct 2021 12:31:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1635589881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FV6kaMmXJI7hmXtbzxAb3gLzpxiYz9+3yEU/207yItU=;
        b=jSvkLdNfVqvjdGiSAWl0hAEgKPx0ui9eW2expt8R32TQr98zG+wKmcXWdIR7NeP7FzJi/E
        pdPB71UAdUQOlH4ux2b00NEnvn4SuXbYh2Ol8OkgpXHqa3YhK+hBQJu8qzbNw452hsLLmO
        skb8Zlffqp6uMxMKxJQWjc8ocKw8tk0=
From:   David Heidelberg <david@ixit.cz>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijeshkumar.singh@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     ~okias/devicetree@lists.sr.ht, David Heidelberg <david@ixit.cz>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] arm64: dts: drop legacy property #stream-id-cells
Date:   Sat, 30 Oct 2021 12:31:16 +0200
Message-Id: <20211030103117.33264-1-david@ixit.cz>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Property #stream-id-cells is legacy leftover and isn't currently
documented nor used.

Signed-off-by: David Heidelberg <david@ixit.cz>
---
 .../boot/dts/amd/amd-seattle-xgbe-b.dtsi      |  2 --
 arch/arm64/boot/dts/qcom/msm8996.dtsi         |  1 -
 arch/arm64/boot/dts/qcom/msm8998.dtsi         |  1 -
 arch/arm64/boot/dts/qcom/sc7180.dtsi          |  1 -
 arch/arm64/boot/dts/qcom/sc7280.dtsi          |  1 -
 arch/arm64/boot/dts/qcom/sdm630.dtsi          |  1 -
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |  1 -
 arch/arm64/boot/dts/qcom/sm8150.dtsi          |  1 -
 arch/arm64/boot/dts/qcom/sm8250.dtsi          |  1 -
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi        | 28 -------------------
 10 files changed, 38 deletions(-)

diff --git a/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi b/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi
index d97498361ce3..3e9faace47f2 100644
--- a/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi
+++ b/arch/arm64/boot/dts/amd/amd-seattle-xgbe-b.dtsi
@@ -55,7 +55,6 @@ xgmac0: xgmac@e0700000 {
 		clocks = <&xgmacclk0_dma_250mhz>, <&xgmacclk0_ptp_250mhz>;
 		clock-names = "dma_clk", "ptp_clk";
 		phy-mode = "xgmii";
-		#stream-id-cells = <16>;
 		dma-coherent;
 	};
 
@@ -81,7 +80,6 @@ xgmac1: xgmac@e0900000 {
 		clocks = <&xgmacclk1_dma_250mhz>, <&xgmacclk1_ptp_250mhz>;
 		clock-names = "dma_clk", "ptp_clk";
 		phy-mode = "xgmii";
-		#stream-id-cells = <16>;
 		dma-coherent;
 	};
 
diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 1ac78d9909ab..91bc974aeb0a 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -962,7 +962,6 @@ hdmi_phy: hdmi-phy@9a0600 {
 
 		gpu: gpu@b00000 {
 			compatible = "qcom,adreno-530.2", "qcom,adreno";
-			#stream-id-cells = <16>;
 
 			reg = <0x00b00000 0x3f000>;
 			reg-names = "kgsl_3d0_reg_memory";
diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index 408f265e277b..f273bc1ff629 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -1446,7 +1446,6 @@ adreno_gpu: gpu@5000000 {
 			iommus = <&adreno_smmu 0>;
 			operating-points-v2 = <&gpu_opp_table>;
 			power-domains = <&rpmpd MSM8998_VDDMX>;
-			#stream-id-cells = <16>;
 			status = "disabled";
 
 			gpu_opp_table: opp-table {
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index faf8b807d0ff..2151cd8c8c7a 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1952,7 +1952,6 @@ glink-edge {
 
 		gpu: gpu@5000000 {
 			compatible = "qcom,adreno-618.0", "qcom,adreno";
-			#stream-id-cells = <16>;
 			reg = <0 0x05000000 0 0x40000>, <0 0x0509e000 0 0x1000>,
 				<0 0x05061000 0 0x800>;
 			reg-names = "kgsl_3d0_reg_memory", "cx_mem", "cx_dbgc";
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 365a2e04e285..2473615bafae 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1747,7 +1747,6 @@ lpass_ag_noc: interconnect@3c40000 {
 
 		gpu: gpu@3d00000 {
 			compatible = "qcom,adreno-635.0", "qcom,adreno";
-			#stream-id-cells = <16>;
 			reg = <0 0x03d00000 0 0x40000>,
 			      <0 0x03d9e000 0 0x1000>,
 			      <0 0x03d61000 0 0x800>;
diff --git a/arch/arm64/boot/dts/qcom/sdm630.dtsi b/arch/arm64/boot/dts/qcom/sdm630.dtsi
index 3e0165bb61c5..d1178e90b15f 100644
--- a/arch/arm64/boot/dts/qcom/sdm630.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm630.dtsi
@@ -1014,7 +1014,6 @@ sd-cd {
 
 		adreno_gpu: gpu@5000000 {
 			compatible = "qcom,adreno-508.0", "qcom,adreno";
-			#stream-id-cells = <16>;
 
 			reg = <0x05000000 0x40000>;
 			reg-names = "kgsl_3d0_reg_memory";
diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 526087586ba4..ff344a9a81a6 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4415,7 +4415,6 @@ dsi1_phy: dsi-phy@ae96400 {
 
 		gpu: gpu@5000000 {
 			compatible = "qcom,adreno-630.2", "qcom,adreno";
-			#stream-id-cells = <16>;
 
 			reg = <0 0x5000000 0 0x40000>, <0 0x509e000 0 0x10>;
 			reg-names = "kgsl_3d0_reg_memory", "cx_mem";
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 81b4ff2cc4cd..6012322a5984 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -1785,7 +1785,6 @@ gpu: gpu@2c00000 {
 			compatible = "qcom,adreno-640.1",
 				     "qcom,adreno",
 				     "amd,imageon";
-			#stream-id-cells = <16>;
 
 			reg = <0 0x02c00000 0 0x40000>;
 			reg-names = "kgsl_3d0_reg_memory";
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 6f6129b39c9c..9e5fc5145191 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1928,7 +1928,6 @@ data {
 		gpu: gpu@3d00000 {
 			compatible = "qcom,adreno-650.2",
 				     "qcom,adreno";
-			#stream-id-cells = <16>;
 
 			reg = <0 0x03d00000 0 0x40000>;
 			reg-names = "kgsl_3d0_reg_memory";
diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 74e66443e4ce..493719f71fb5 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -262,7 +262,6 @@ fpd_dma_chan1: dma@fd500000 {
 			interrupts = <0 124 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <128>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x14e8>;
 			power-domains = <&zynqmp_firmware PD_GDMA>;
 		};
@@ -275,7 +274,6 @@ fpd_dma_chan2: dma@fd510000 {
 			interrupts = <0 125 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <128>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x14e9>;
 			power-domains = <&zynqmp_firmware PD_GDMA>;
 		};
@@ -288,7 +286,6 @@ fpd_dma_chan3: dma@fd520000 {
 			interrupts = <0 126 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <128>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x14ea>;
 			power-domains = <&zynqmp_firmware PD_GDMA>;
 		};
@@ -301,7 +298,6 @@ fpd_dma_chan4: dma@fd530000 {
 			interrupts = <0 127 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <128>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x14eb>;
 			power-domains = <&zynqmp_firmware PD_GDMA>;
 		};
@@ -314,7 +310,6 @@ fpd_dma_chan5: dma@fd540000 {
 			interrupts = <0 128 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <128>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x14ec>;
 			power-domains = <&zynqmp_firmware PD_GDMA>;
 		};
@@ -327,7 +322,6 @@ fpd_dma_chan6: dma@fd550000 {
 			interrupts = <0 129 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <128>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x14ed>;
 			power-domains = <&zynqmp_firmware PD_GDMA>;
 		};
@@ -340,7 +334,6 @@ fpd_dma_chan7: dma@fd560000 {
 			interrupts = <0 130 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <128>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x14ee>;
 			power-domains = <&zynqmp_firmware PD_GDMA>;
 		};
@@ -353,7 +346,6 @@ fpd_dma_chan8: dma@fd570000 {
 			interrupts = <0 131 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <128>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x14ef>;
 			power-domains = <&zynqmp_firmware PD_GDMA>;
 		};
@@ -383,7 +375,6 @@ lpd_dma_chan1: dma@ffa80000 {
 			interrupts = <0 77 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <64>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x868>;
 			power-domains = <&zynqmp_firmware PD_ADMA>;
 		};
@@ -396,7 +387,6 @@ lpd_dma_chan2: dma@ffa90000 {
 			interrupts = <0 78 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <64>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x869>;
 			power-domains = <&zynqmp_firmware PD_ADMA>;
 		};
@@ -409,7 +399,6 @@ lpd_dma_chan3: dma@ffaa0000 {
 			interrupts = <0 79 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <64>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x86a>;
 			power-domains = <&zynqmp_firmware PD_ADMA>;
 		};
@@ -422,7 +411,6 @@ lpd_dma_chan4: dma@ffab0000 {
 			interrupts = <0 80 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <64>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x86b>;
 			power-domains = <&zynqmp_firmware PD_ADMA>;
 		};
@@ -435,7 +423,6 @@ lpd_dma_chan5: dma@ffac0000 {
 			interrupts = <0 81 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <64>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x86c>;
 			power-domains = <&zynqmp_firmware PD_ADMA>;
 		};
@@ -448,7 +435,6 @@ lpd_dma_chan6: dma@ffad0000 {
 			interrupts = <0 82 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <64>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x86d>;
 			power-domains = <&zynqmp_firmware PD_ADMA>;
 		};
@@ -461,7 +447,6 @@ lpd_dma_chan7: dma@ffae0000 {
 			interrupts = <0 83 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <64>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x86e>;
 			power-domains = <&zynqmp_firmware PD_ADMA>;
 		};
@@ -474,7 +459,6 @@ lpd_dma_chan8: dma@ffaf0000 {
 			interrupts = <0 84 4>;
 			clock-names = "clk_main", "clk_apb";
 			xlnx,bus-width = <64>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x86f>;
 			power-domains = <&zynqmp_firmware PD_ADMA>;
 		};
@@ -495,7 +479,6 @@ nand0: nand-controller@ff100000 {
 			interrupts = <0 14 4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x872>;
 			power-domains = <&zynqmp_firmware PD_NAND>;
 		};
@@ -509,7 +492,6 @@ gem0: ethernet@ff0b0000 {
 			clock-names = "pclk", "hclk", "tx_clk";
 			#address-cells = <1>;
 			#size-cells = <0>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x874>;
 			power-domains = <&zynqmp_firmware PD_ETH_0>;
 		};
@@ -523,7 +505,6 @@ gem1: ethernet@ff0c0000 {
 			clock-names = "pclk", "hclk", "tx_clk";
 			#address-cells = <1>;
 			#size-cells = <0>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x875>;
 			power-domains = <&zynqmp_firmware PD_ETH_1>;
 		};
@@ -537,7 +518,6 @@ gem2: ethernet@ff0d0000 {
 			clock-names = "pclk", "hclk", "tx_clk";
 			#address-cells = <1>;
 			#size-cells = <0>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x876>;
 			power-domains = <&zynqmp_firmware PD_ETH_2>;
 		};
@@ -551,7 +531,6 @@ gem3: ethernet@ff0e0000 {
 			clock-names = "pclk", "hclk", "tx_clk";
 			#address-cells = <1>;
 			#size-cells = <0>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x877>;
 			power-domains = <&zynqmp_firmware PD_ETH_3>;
 		};
@@ -621,7 +600,6 @@ pcie: pcie@fd0e0000 {
 					<0x0 0x0 0x0 0x2 &pcie_intc 0x2>,
 					<0x0 0x0 0x0 0x3 &pcie_intc 0x3>,
 					<0x0 0x0 0x0 0x4 &pcie_intc 0x4>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x4d0>;
 			power-domains = <&zynqmp_firmware PD_PCIE>;
 			pcie_intc: legacy-interrupt-controller {
@@ -642,7 +620,6 @@ qspi: spi@ff0f0000 {
 			      <0x0 0xc0000000 0x0 0x8000000>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x873>;
 			power-domains = <&zynqmp_firmware PD_QSPI>;
 		};
@@ -674,7 +651,6 @@ sata: ahci@fd0c0000 {
 			interrupts = <0 133 4>;
 			power-domains = <&zynqmp_firmware PD_SATA>;
 			resets = <&zynqmp_reset ZYNQMP_RESET_SATA>;
-			#stream-id-cells = <4>;
 			iommus = <&smmu 0x4c0>, <&smmu 0x4c1>,
 				 <&smmu 0x4c2>, <&smmu 0x4c3>;
 		};
@@ -686,7 +662,6 @@ sdhci0: mmc@ff160000 {
 			interrupts = <0 48 4>;
 			reg = <0x0 0xff160000 0x0 0x1000>;
 			clock-names = "clk_xin", "clk_ahb";
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x870>;
 			#clock-cells = <1>;
 			clock-output-names = "clk_out_sd0", "clk_in_sd0";
@@ -700,7 +675,6 @@ sdhci1: mmc@ff170000 {
 			interrupts = <0 49 4>;
 			reg = <0x0 0xff170000 0x0 0x1000>;
 			clock-names = "clk_xin", "clk_ahb";
-			#stream-id-cells = <1>;
 			iommus = <&smmu 0x871>;
 			#clock-cells = <1>;
 			clock-output-names = "clk_out_sd1", "clk_in_sd1";
@@ -825,7 +799,6 @@ dwc3_0: usb@fe200000 {
 				interrupt-parent = <&gic>;
 				interrupt-names = "dwc_usb3", "otg";
 				interrupts = <0 65 4>, <0 69 4>;
-				#stream-id-cells = <1>;
 				iommus = <&smmu 0x860>;
 				snps,quirk-frame-length-adjustment = <0x20>;
 				/* dma-coherent; */
@@ -852,7 +825,6 @@ dwc3_1: usb@fe300000 {
 				interrupt-parent = <&gic>;
 				interrupt-names = "dwc_usb3", "otg";
 				interrupts = <0 70 4>, <0 74 4>;
-				#stream-id-cells = <1>;
 				iommus = <&smmu 0x861>;
 				snps,quirk-frame-length-adjustment = <0x20>;
 				/* dma-coherent; */
-- 
2.33.0

