Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE1749D545
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbiAZWSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbiAZWSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:18:38 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF85C061747
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:18:38 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y27so971192pfa.0
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eBKvYDb6VakQr9I32CgZ8GyjwlSfCMHD5apokqZR7fA=;
        b=sYIv4CgAIFylOPcghyp3zVLMlxw6paLMJSYOOcSluYU+RNsCOcm4WrasH58NWAlL11
         BL5wP7ZsndWamfeADtqcBziDYEq4uRZC25op4bgZYJ/IYGmvbUWDgwPAinvfLqD3qiuJ
         oU65aZ1Ojq9311fR77/01QM0V9dp8ut4El6I39/3T4pPtRzYQHjo9tl26AN8HiEvPxhN
         PjV8/sGN0SmEZmUjAMP6KzuS1gsK6mcMlIGSWZol1aMlB3BwQdvl+ZolhbxpgzfBe92s
         cOLD1KBFf2WQKcqboPUj5nvv8s0fxZghcc0UkF+JMbNkNqqMfXiot7lZTLrTyvDE49GO
         RIIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eBKvYDb6VakQr9I32CgZ8GyjwlSfCMHD5apokqZR7fA=;
        b=j4SVpHKUCDBdWTQi67mOAp7mG0YuJy4V6rPpzlDFbCVRMa5mL6Z4v2AiL0l+1hZUiU
         RZQ3wdKnMjpALnFMgsEllmP96/jF+pg/45mA28VtKDk3jF40O7R1wbntVQsyckpcJErm
         M9an16YvkGpc/phxS509scuDfeg7tqkxZwl/5CqoHzrrLbFFovTU4XLLkJjoKthwVSxE
         XzcC1SutTfnS1BeGrUFpurW6dDpjs/WKy+R8WNqucsCQCPnpBZW50r+7GOZiZN4+MfVU
         Zw7Sr2m0mgEoMdZWbINQHIQ7Z42C27YviSkfr3BttJWLKv4JeGjCBwQx89I5/eO+LQH0
         GIEQ==
X-Gm-Message-State: AOAM532LQTlXJ1jhuWVTs6t0zzDVHSjZ/WnBnD9VuvC/oUod8riwuibq
        +xbhQTsn8530/6vHIKQu7es8Pg==
X-Google-Smtp-Source: ABdhPJyccWVvDDw4dXIfu+AsyrSRolCJ7BageCJSH5N4dEgU/4o/GhWml0R+Qeqlqut9diKItq5hFw==
X-Received: by 2002:a65:4d0f:: with SMTP id i15mr707539pgt.464.1643235518167;
        Wed, 26 Jan 2022 14:18:38 -0800 (PST)
Received: from localhost.localdomain ([2401:4900:1f3a:4e9b:8fa7:36dc:a805:c73f])
        by smtp.gmail.com with ESMTPSA id t17sm4233742pgm.69.2022.01.26.14.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:18:37 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, sboyd@kernel.org,
        tdas@codeaurora.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5/8] arm64: dts: qcom: sa8155p-adp: Enable ethernet node
Date:   Thu, 27 Jan 2022 03:47:22 +0530
Message-Id: <20220126221725.710167-6-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

Enable the etheret node, add the phy node and pinctrl for ethernet.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[bhsharma: Correct ethernet/rgmii related pinmuxs, specify multi-queues and
 plug in the PHY interrupt for WOL]
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts | 144 +++++++++++++++++++++++
 1 file changed, 144 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
index 8756c2b25c7e..474f688f14a2 100644
--- a/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
+++ b/arch/arm64/boot/dts/qcom/sa8155p-adp.dts
@@ -47,6 +47,65 @@ vreg_s4a_1p8: smps4 {
 
 		vin-supply = <&vreg_3p3>;
 	};
+
+	mtl_rx_setup: rx-queues-config {
+		snps,rx-queues-to-use = <4>;
+		snps,rx-sched-sp;
+
+		queue0 {
+			snps,dcb-algorithm;
+			snps,map-to-dma-channel = <0x0>;
+			snps,route-up;
+			snps,priority = <0x1>;
+		};
+
+		queue1 {
+			snps,dcb-algorithm;
+			snps,map-to-dma-channel = <0x1>;
+			snps,route-ptp;
+		};
+
+		queue2 {
+			snps,avb-algorithm;
+			snps,map-to-dma-channel = <0x2>;
+			snps,route-avcp;
+		};
+
+		queue3 {
+			snps,avb-algorithm;
+			snps,map-to-dma-channel = <0x3>;
+			snps,priority = <0xC>;
+		};
+	};
+
+	mtl_tx_setup: tx-queues-config {
+		snps,tx-queues-to-use = <4>;
+		snps,tx-sched-wrr;
+
+		queue0 {
+			snps,weight = <0x10>;
+			snps,dcb-algorithm;
+			snps,priority = <0x0>;
+		};
+
+		queue1 {
+			snps,weight = <0x11>;
+			snps,dcb-algorithm;
+			snps,priority = <0x1>;
+		};
+
+		queue2 {
+			snps,weight = <0x12>;
+			snps,dcb-algorithm;
+			snps,priority = <0x2>;
+		};
+
+		queue3 {
+			snps,weight = <0x13>;
+			snps,dcb-algorithm;
+			snps,priority = <0x3>;
+		};
+	};
 };
 
 &apps_rsc {
@@ -317,6 +376,42 @@ &remoteproc_cdsp {
 	firmware-name = "qcom/sa8155p/cdsp.mdt";
 };
 
+&ethernet {
+	status = "okay";
+
+	snps,reset-gpio = <&tlmm 79 GPIO_ACTIVE_LOW>;
+	snps,reset-active-low;
+	snps,reset-delays-us = <0 11000 70000>;
+
+	snps,ptp-ref-clk-rate = <250000000>;
+	snps,ptp-req-clk-rate = <96000000>;
+
+	snps,mtl-rx-config = <&mtl_rx_setup>;
+	snps,mtl-tx-config = <&mtl_tx_setup>;
+
+	pinctrl-names = "default";
+	pinctrl-0 = <&ethernet_defaults>;
+
+	phy-handle = <&rgmii_phy>;
+	phy-mode = "rgmii";
+	mdio {
+		#address-cells = <0x1>;
+		#size-cells = <0x0>;
+
+		compatible = "snps,dwmac-mdio";
+
+		/* Micrel KSZ9031RNZ PHY */
+		rgmii_phy: phy@7 {
+			reg = <0x7>;
+
+			interrupt-parent = <&tlmm>;
+			interrupts-extended = <&tlmm 124 IRQ_TYPE_EDGE_FALLING>; /* phy intr */
+			device_type = "ethernet-phy";
+			compatible = "ethernet-phy-ieee802.3-c22";
+		};
+	};
+};
+
 &uart2 {
 	status = "okay";
 };
@@ -407,4 +502,53 @@ mux {
 			drive-strength = <2>;
 		};
 	};
+
+	ethernet_defaults: ethernet-defaults {
+		mdc {
+			pins = "gpio7";
+			function = "rgmii";
+			bias-pull-up;
+		};
+
+		mdio {
+			pins = "gpio59";
+			function = "rgmii";
+			bias-pull-up;
+		};
+
+		rgmii-rx {
+			pins = "gpio117", "gpio118", "gpio119", "gpio120", "gpio115", "gpio116";
+			function = "rgmii";
+			bias-disable;
+			drive-strength = <2>;
+		};
+
+		rgmii-tx {
+			pins = "gpio122", "gpio4", "gpio5", "gpio6", "gpio114", "gpio121";
+			function = "rgmii";
+			bias-pull-up;
+			drive-strength = <16>;
+		};
+
+		phy-intr {
+			pins = "gpio124";
+			function = "emac_phy";
+			bias-disable;
+			drive-strength = <8>;
+		};
+
+		pps {
+			pins = "gpio81";
+			function = "emac_pps";
+			bias-disable;
+			drive-strength = <8>;
+		};
+
+		phy-reset {
+			pins = "gpio79";
+			function = "gpio";
+			bias-pull-up;
+			drive-strength = <16>;
+		};
+	};
 };
-- 
2.34.1

