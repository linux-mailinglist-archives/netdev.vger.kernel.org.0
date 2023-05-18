Return-Path: <netdev+bounces-3581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 76715707F22
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3850F280F1F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 11:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A70519900;
	Thu, 18 May 2023 11:23:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D83119524
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:23:54 +0000 (UTC)
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124211717;
	Thu, 18 May 2023 04:23:52 -0700 (PDT)
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34IAGqcq003590;
	Thu, 18 May 2023 11:23:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=qcppdkim1;
 bh=F4n7gAeewlfEthSs/XPO6zbOmNJymLw0HFpA1TauuHE=;
 b=VnrEPs4O1tIUNfrwHyG8oleXZvrmV+xNpIlMyaO+PQ6ne49Vqzxt+89dDFWGKBrZwTYf
 zMSZHeLwdL9kTupYEsVxjVn2XtnZdLXTbCD3f8ijBM1FNe6LhbtZsqMyf7oJ47hmhl3x
 4Onkq6v5dYqGn6UQTBEhlsPE2tvh57b1N0HCVNKiMaNY01CECE789MEqS2ePP8Lgs868
 riGyDf+R0aZm8NdovIJFD58XjOyViOW6eD/i41YCYy7m2YR8V8DMdB4+2uRQwTwGLaTp
 pCWHaiMEdlmc7gac4OvxBtGdODE+MteZ0fgP63RFlsGjYs5GkNlxEwUg04fzd34Iu1Tz wA== 
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3qnb7h8wp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 May 2023 11:23:41 +0000
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 34IBNcXC026076;
	Thu, 18 May 2023 11:23:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3qj3mk9nvh-1;
	Thu, 18 May 2023 11:23:37 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34IBNbPV026068;
	Thu, 18 May 2023 11:23:37 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 34IBNbLo026064;
	Thu, 18 May 2023 11:23:37 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
	id 04D665EB8; Thu, 18 May 2023 16:53:37 +0530 (+0530)
From: Rohit Agarwal <quic_rohiagar@quicinc.com>
To: agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
        richardcochran@gmail.com, manivannan.sadhasivam@linaro.org
Cc: linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH 1/2] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
Date: Thu, 18 May 2023 16:53:34 +0530
Message-Id: <1684409015-25196-2-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1684409015-25196-1-git-send-email-quic_rohiagar@quicinc.com>
References: <1684409015-25196-1-git-send-email-quic_rohiagar@quicinc.com>
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: pF6_QCzKfubVcTOkac4ffNSDUHFuhLoc
X-Proofpoint-GUID: pF6_QCzKfubVcTOkac4ffNSDUHFuhLoc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-18_08,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 phishscore=0 clxscore=1011 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305180088
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

Add device tree binding Documentation details for Qualcomm SDX75
pinctrl driver.

Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          | 137 +++++++++++++++++++++
 1 file changed, 137 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
new file mode 100644
index 0000000..7cb96aa
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
@@ -0,0 +1,137 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/pinctrl/qcom,sdx75-tlmm.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Technologies, Inc. SDX75 TLMM block
+
+maintainers:
+  - Rohit Agarwal <quic_rohiagar@quicinc.com>
+
+description:
+  Top Level Mode Multiplexer pin controller in Qualcomm SDX75 SoC.
+
+allOf:
+  - $ref: /schemas/pinctrl/qcom,tlmm-common.yaml#
+
+properties:
+  compatible:
+    const: qcom,sdx75-tlmm
+
+  reg:
+    maxItems: 1
+
+  interrupts: true
+  interrupt-controller: true
+  "#interrupt-cells": true
+  gpio-controller: true
+
+  gpio-reserved-ranges:
+    minItems: 1
+    maxItems: 67
+
+  gpio-line-names:
+    maxItems: 133
+
+  "#gpio-cells": true
+  gpio-ranges: true
+  wakeup-parent: true
+
+patternProperties:
+  "-state$":
+    oneOf:
+      - $ref: "#/$defs/qcom-sdx75-tlmm-state"
+      - patternProperties:
+          "-pins$":
+            $ref: "#/$defs/qcom-sdx75-tlmm-state"
+        additionalProperties: false
+
+$defs:
+  qcom-sdx75-tlmm-state:
+    type: object
+    description:
+      Pinctrl node's client devices use subnodes for desired pin configuration.
+      Client device subnodes use below standard properties.
+    $ref: qcom,tlmm-common.yaml#/$defs/qcom-tlmm-state
+    unevaluatedProperties: false
+
+    properties:
+      pins:
+        description:
+          List of gpio pins affected by the properties specified in this
+          subnode.
+        items:
+          oneOf:
+            - pattern: "^gpio([0-9]|[1-9][0-9]|1[0-2][0-9]|13[0-2])$"
+            - enum: [ sdc1_clk, sdc1_cmd, sdc1_data, sdc1_rclk, sdc2_clk, sdc2_cmd, sdc2_data ]
+        minItems: 1
+        maxItems: 36
+
+      function:
+        description:
+          Specify the alternative function to be configured for the specified
+          pins.
+        enum: [ adsp_ext, atest_char, audio_ref_clk, bimc_dte, char_exec, coex_uart2,
+                coex_uart, cri_trng, cri_trng0, cri_trng1, dbg_out_clk, ddr_bist,
+                ddr_pxi0, ebi0_wrcdc, ebi2_a, ebi2_lcd, ebi2_lcd_te, emac0_mcg,
+                emac0_ptp, emac1_mcg, emac1_ptp, emac_cdc, emac_pps_in, eth0_mdc,
+                eth0_mdio, eth1_mdc, eth1_mdio, ext_dbg, gcc_125_clk, gcc_gp1_clk,
+                gcc_gp2_clk, gcc_gp3_clk, gcc_plltest, gpio, i2s_mclk, jitter_bist,
+                ldo_en, ldo_update, m_voc, mgpi_clk, native_char, native_tsens,
+                native_tsense, nav_dr_sync, nav_gpio, pa_indicator, pci_e,
+                pcie0_clkreq_n, pcie1_clkreq_n, pcie2_clkreq_n, pll_bist_sync,
+                pll_clk_aux, pll_ref_clk, pri_mi2s, prng_rosc, qdss_cti, qdss_gpio,
+                qlink0_b_en, qlink0_b_req, qlink0_l_en, qlink0_l_req, qlink0_wmss,
+                qlink1_l_en, qlink1_l_req, qlink1_wmss, qup_se0, qup_se1_l2_mira,
+                qup_se1_l2_mirb, qup_se1_l3_mira, qup_se1_l3_mirb, qup_se2, qup_se3,
+                qup_se4, qup_se5, qup_se6, qup_se7, qup_se8, rgmii_rx_ctl, rgmii_rxc,
+                rgmii_rxd, rgmii_tx_ctl, rgmii_txc, rgmii_txd, sd_card, sdc1_tb,
+                sdc2_tb_trig, sec_mi2s, sgmii_phy_intr0_n, sgmii_phy_intr1_n,
+                spmi_coex, spmi_vgi, tgu_ch0_trigout, tmess_prng0, tmess_prng1,
+                tmess_prng2, tmess_prng3, tri_mi2s, uim1_clk, uim1_data, uim1_present,
+                uim1_reset, uim2_clk, uim2_data, uim2_present, uim2_reset,
+                usb2phy_ac_en, vsense_trigger_mirnat]
+
+    required:
+      - pins
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    tlmm: pinctrl@f100000 {
+        compatible = "qcom,sdx75-tlmm";
+        reg = <0x0f100000 0x300000>;
+        gpio-controller;
+        #gpio-cells = <2>;
+        gpio-ranges = <&tlmm 0 0 133>;
+        interrupt-controller;
+        #interrupt-cells = <2>;
+        interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
+
+        gpio-wo-state {
+            pins = "gpio1";
+            function = "gpio";
+        };
+
+        uart-w-state {
+            rx-pins {
+                pins = "gpio12";
+                function = "qup_se1_l2_mira";
+                bias-disable;
+            };
+
+            tx-pins {
+                pins = "gpio13";
+                function = "qup_se1_l3_mira";
+                bias-disable;
+            };
+        };
+    };
+...
-- 
2.7.4


