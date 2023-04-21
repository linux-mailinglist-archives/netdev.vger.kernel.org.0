Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F69B6EA75E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjDUJnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbjDUJni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:43:38 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDCAAF03;
        Fri, 21 Apr 2023 02:43:31 -0700 (PDT)
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L9YXL6011295;
        Fri, 21 Apr 2023 09:43:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=qcppdkim1;
 bh=19ESNR3TsxANJYkCY15manVG4ppwsIK/BnpzgcictJw=;
 b=E9ir8kfmx5L0FfQY1uD3GdQO161BKdF4TNpKwivcuDbbBO61JeyXWsCipesMHjyv1I+I
 BiLLKXNevM9Jh1XsV8Z0+hybzrnOhXMc2avGl8GEpVMFX8KR/2yU4lceSGFGnUqT3bzY
 g1rlh946Mqan/if+86FhMAPzpAXMSMtQaeJA3kOFrjNL9MBhYqzeOQTiFifKS7tcKN+T
 UlKWuLz6cvVTrfYgHLXzisdWc/9IQ6g61cny6f7ySAa3z+QmTOALVYXv4YnV2/Vm+LiS
 pUF+b4eej15QIg9G1CqtocTW4regwuKrUyTf/Sp2rSV6Lq6FmHELhn+1MKcRbBTDZlRs ag== 
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q3f3ts3cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 09:43:27 +0000
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
        by APBLRPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTP id 33L9hN9O025479;
        Fri, 21 Apr 2023 09:43:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 3pyn0kpscn-1;
        Fri, 21 Apr 2023 09:43:23 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33L9hNfL025430;
        Fri, 21 Apr 2023 09:43:23 GMT
Received: from hu-sgudaval-hyd.qualcomm.com (hu-rohiagar-hyd.qualcomm.com [10.213.106.138])
        by APBLRPPMTA02.qualcomm.com (PPS) with ESMTP id 33L9hMo9025419;
        Fri, 21 Apr 2023 09:43:23 +0000
Received: by hu-sgudaval-hyd.qualcomm.com (Postfix, from userid 3970568)
        id 83BB150A2; Fri, 21 Apr 2023 15:13:22 +0530 (+0530)
From:   Rohit Agarwal <quic_rohiagar@quicinc.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org
Cc:     linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Rohit Agarwal <quic_rohiagar@quicinc.com>
Subject: [PATCH v2 1/2] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl devicetree compatible
Date:   Fri, 21 Apr 2023 15:13:15 +0530
Message-Id: <1682070196-980-2-git-send-email-quic_rohiagar@quicinc.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1682070196-980-1-git-send-email-quic_rohiagar@quicinc.com>
References: <1682070196-980-1-git-send-email-quic_rohiagar@quicinc.com>
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 29lBEQnk13GdR_0c0PxB9A4oGSKWdqjW
X-Proofpoint-ORIG-GUID: 29lBEQnk13GdR_0c0PxB9A4oGSKWdqjW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_03,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 adultscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210083
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree binding Documentation details for Qualcomm SDX75
pinctrl driver.

Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
---
 .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          | 177 +++++++++++++++++++++
 1 file changed, 177 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml

diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
new file mode 100644
index 0000000..8a9ceb6
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
@@ -0,0 +1,177 @@
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
+    maxItems: 105
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
+
+    properties:
+      pins:
+        description:
+          List of gpio pins affected by the properties specified in this
+          subnode.
+        items:
+          oneOf:
+            - pattern: "^gpio([0-9]|[1-9][0-9]|1[0-9][0-9]|20[0-9])$"
+            - enum: [ ufs_reset, sdc2_clk, sdc2_cmd, sdc2_data ]
+        minItems: 1
+        maxItems: 36
+
+      function:
+        description:
+          Specify the alternative function to be configured for the specified
+          pins.
+        enum: [ gpio, eth0_mdc, eth0_mdio, eth1_mdc, eth1_mdio,
+                qlink0_wmss_reset, qlink1_wmss_reset, rgmii_rxc, rgmii_rxd0,
+                rgmii_rxd1, rgmii_rxd2, rgmii_rxd3,rgmii_rx_ctl, rgmii_txc,
+                rgmii_txd0, rgmii_txd1, rgmii_txd2, rgmii_txd3, rgmii_tx_ctl,
+                adsp_ext_vfr, atest_char_start, atest_char_status0,
+                atest_char_status1, atest_char_status2, atest_char_status3,
+                audio_ref_clk, bimc_dte_test0, bimc_dte_test1,
+                char_exec_pending, char_exec_release, coex_uart2_rx,
+                coex_uart2_tx, coex_uart_rx, coex_uart_tx, cri_trng_rosc,
+                cri_trng_rosc0, cri_trng_rosc1, dbg_out_clk, ddr_bist_complete,
+                ddr_bist_fail, ddr_bist_start, ddr_bist_stop, ddr_pxi0_test,
+                ebi0_wrcdc_dq2, ebi0_wrcdc_dq3, ebi2_a_d, ebi2_lcd_cs,
+                ebi2_lcd_reset, ebi2_lcd_te, emac0_mcg_pst0, emac0_mcg_pst1,
+                emac0_mcg_pst2, emac0_mcg_pst3, emac0_ptp_aux, emac0_ptp_pps,
+                emac1_mcg_pst0, emac1_mcg_pst1, emac1_mcg_pst2, emac1_mcg_pst3,
+                emac1_ptp_aux0, emac1_ptp_aux1, emac1_ptp_aux2, emac1_ptp_aux3,
+                emac1_ptp_pps0, emac1_ptp_pps1, emac1_ptp_pps2, emac1_ptp_pps3,
+                emac_cdc_dtest0, emac_cdc_dtest1, emac_pps_in, ext_dbg_uart,
+                gcc_125_clk, gcc_gp1_clk, gcc_gp2_clk, gcc_gp3_clk,
+                gcc_plltest_bypassnl, gcc_plltest_resetn, i2s_mclk,
+                jitter_bist_ref, ldo_en, ldo_update, m_voc_ext, mgpi_clk_req,
+                native0, native1, native2, native3, native_char_start,
+                native_tsens_osc, native_tsense_pwm1, nav_dr_sync, nav_gpio_0,
+                nav_gpio_1, nav_gpio_2, nav_gpio_3, pa_indicator_1, pci_e_rst,
+                pcie0_clkreq_n, pcie1_clkreq_n, pcie2_clkreq_n, pll_bist_sync,
+                pll_clk_aux, pll_ref_clk, pri_mi2s_data0, pri_mi2s_data1,
+                pri_mi2s_sck, pri_mi2s_ws, prng_rosc_test0, prng_rosc_test1,
+                prng_rosc_test2, prng_rosc_test3, qdss_cti_trig0,
+                qdss_cti_trig1, qdss_gpio_traceclk, qdss_gpio_tracectl,
+                qdss_gpio_tracedata0, qdss_gpio_tracedata1,
+                qdss_gpio_tracedata10, qdss_gpio_tracedata11,
+                qdss_gpio_tracedata12, qdss_gpio_tracedata13,
+                qdss_gpio_tracedata14, qdss_gpio_tracedata15,
+                qdss_gpio_tracedata2, qdss_gpio_tracedata3,
+                qdss_gpio_tracedata4, qdss_gpio_tracedata5,
+                qdss_gpio_tracedata6, qdss_gpio_tracedata7,
+                qdss_gpio_tracedata8, qdss_gpio_tracedata9, qlink0_b_en,
+                qlink0_b_req, qlink0_l_en, qlink0_l_req, qlink1_l_en,
+                qlink1_l_req, qup_se0_l0, qup_se0_l1, qup_se0_l2, qup_se0_l3,
+                qup_se1_l2, qup_se1_l3, qup_se2_l0, qup_se2_l1, qup_se2_l2,
+                qup_se2_l3, qup_se3_l0, qup_se3_l1, qup_se3_l2, qup_se3_l3,
+                qup_se4_l2, qup_se4_l3, qup_se5_l0, qup_se5_l1, qup_se6_l0,
+                qup_se6_l1, qup_se6_l2, qup_se6_l3, qup_se7_l0, qup_se7_l1,
+                qup_se7_l2, qup_se7_l3, qup_se8_l2, qup_se8_l3, sdc1_tb_trig,
+                sdc2_tb_trig, sec_mi2s_data0, sec_mi2s_data1, sec_mi2s_sck,
+                sec_mi2s_ws, sgmii_phy_intr0, sgmii_phy_intr1, spmi_coex_clk,
+                spmi_coex_data, spmi_vgi_hwevent, tgu_ch0_trigout,
+                tri_mi2s_data0, tri_mi2s_data1, tri_mi2s_sck, tri_mi2s_ws,
+                uim1_clk, uim1_data, uim1_present, uim1_reset, uim2_clk,
+                uim2_data, uim2_present, uim2_reset, usb2phy_ac_en,
+                vsense_trigger_mirnat]
+
+      bias-disable: true
+      bias-pull-down: true
+      bias-pull-up: true
+      drive-strength: true
+      input-enable: true
+      output-high: true
+      output-low: true
+
+    required:
+      - pins
+
+    additionalProperties: false
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
+        gpio-ranges = <&tlmm 0 0 134>;
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

