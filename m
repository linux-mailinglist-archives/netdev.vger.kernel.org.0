Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D01B6E7ADE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjDSNa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbjDSNaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:30:52 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7644C01;
        Wed, 19 Apr 2023 06:30:50 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33J9WJxe021349;
        Wed, 19 Apr 2023 13:30:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=qcppdkim1;
 bh=u+3vRwj/byIkcFjmAuDOIXKgQOuUWaAcqdgDmJhY9D8=;
 b=OACd2UEonqLqTqsJgQ/irMHPy6kmMpOdhtMkCT52DMwnnWvh432ov3l6r5klMaK9Z9b1
 4Cuc+k+Br5JbaVN/jg5OY7PmMV5Uaa+Qj1mV9jRYrQHvihVxSmlNqpf2E6u3IMp6V5LB
 Cy7HeGkNhliOeSX1OghEuBtBufKDCcdn/q8QJ8LhhMs0UmAdbvm+TKvNVl4U5Ykg2NRr
 s4UmEObHK714QIUQtVkYeGj5hklJucj9MwoPMaT3yUEzsbdzC/LGerRql9CXMffHl8c7
 A9iN82VhKf73iHOfxaahZjNKYu9JkYP2Rt5zrhI8XGCIAHsA3qjspK2ouTGx0D8+O7xs Ug== 
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q234h9tu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 13:30:46 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33JDUjAS010599
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Apr 2023 13:30:45 GMT
Received: from hu-tdas-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Wed, 19 Apr 2023 06:30:40 -0700
From:   Taniya Das <quic_tdas@quicinc.com>
To:     Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        "Bjorn Andersson" <andersson@kernel.org>,
        Andy Gross <agross@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>
CC:     <quic_skakitap@quicinc.com>,
        Imran Shaik <quic_imrashai@quicinc.com>,
        <linux-arm-msm@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Taniya Das <quic_tdas@quicinc.com>,
        <quic_rohiagar@quicinc.com>, <netdev@vger.kernel.org>
Subject: [PATCH 2/4] dt-bindings: clock: Add GCC bindings support for SDX75
Date:   Wed, 19 Apr 2023 19:00:11 +0530
Message-ID: <20230419133013.2563-3-quic_tdas@quicinc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419133013.2563-1-quic_tdas@quicinc.com>
References: <20230419133013.2563-1-quic_tdas@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: psxZzAFp9-ZIkPyXekJh26RFzyOhTiMz
X-Proofpoint-ORIG-GUID: psxZzAFp9-ZIkPyXekJh26RFzyOhTiMz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_08,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 impostorscore=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190121
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Imran Shaik <quic_imrashai@quicinc.com>

Add support for GCC bindings and update documentation for
clock rpmh driver for SDX75.

Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
---
 .../bindings/clock/qcom,gcc-sdx75.yaml        |  69 +++++++
 .../bindings/clock/qcom,rpmhcc.yaml           |   1 +
 include/dt-bindings/clock/qcom,gcc-sdx75.h    | 193 ++++++++++++++++++
 3 files changed, 263 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/qcom,gcc-sdx75.yaml
 create mode 100644 include/dt-bindings/clock/qcom,gcc-sdx75.h

diff --git a/Documentation/devicetree/bindings/clock/qcom,gcc-sdx75.yaml b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx75.yaml
new file mode 100644
index 000000000000..6489d857d5c4
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/qcom,gcc-sdx75.yaml
@@ -0,0 +1,69 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/clock/qcom,gcc-sdx75.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Qualcomm Global Clock & Reset Controller on SDX75
+
+maintainers:
+  - Imran Shaik <quic_imrashai@quicinc.com>
+  - Taniya Das <quic_tdas@quicinc.com>
+
+description: |
+  Qualcomm global clock control module provides the clocks, resets and power
+  domains on SDX75
+
+  See also:: include/dt-bindings/clock/qcom,gcc-sdx75.h
+
+properties:
+  compatible:
+    const: qcom,gcc-sdx75
+
+  clocks:
+    items:
+      - description: Board XO source
+      - description: PCIE20 phy aux clock source
+      - description: PCIE_1 Pipe clock source
+      - description: PCIE_2 Pipe clock source
+      - description: PCIE Pipe clock source
+      - description: Sleep clock source
+      - description: USB3 phy wrapper pipe clock source
+
+  clock-names:
+    items:
+      - const: bi_tcxo
+      - const: pcie20_phy_aux_clk
+      - const: pcie_1_pipe_clk
+      - const: pcie_2_pipe_clk
+      - const: pcie_pipe_clk
+      - const: sleep_clk
+      - const: usb3_phy_wrapper_gcc_usb30_pipe_clk
+
+required:
+  - compatible
+  - clocks
+  - clock-names
+
+allOf:
+  - $ref: qcom,gcc.yaml#
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/qcom,rpmh.h>
+    clock-controller@80000 {
+      compatible = "qcom,gcc-sdx75";
+      reg = <0x80000 0x1f7400>;
+      clocks = <&rpmhcc RPMH_CXO_CLK>, <&pcie20_phy_aux_clk>, <&pcie_1_pipe_clk>,
+               <&pcie_2_pipe_clk>, <&pcie_pipe_clk>, <&sleep_clk>,
+               <&usb3_phy_wrapper_gcc_usb30_pipe_clk>;
+      clock-names = "bi_tcxo", "pcie20_phy_aux_clk", "pcie_1_pipe_clk",
+                    "pcie_2_pipe_clk", "pcie_pipe_clk", "sleep_clk",
+                    "usb3_phy_wrapper_gcc_usb30_pipe_clk";
+      #clock-cells = <1>;
+      #reset-cells = <1>;
+      #power-domain-cells = <1>;
+    };
+...
diff --git a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml b/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
index d5a250b7c2af..267cf8c26823 100644
--- a/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,rpmhcc.yaml
@@ -27,6 +27,7 @@ properties:
       - qcom,sdm845-rpmh-clk
       - qcom,sdx55-rpmh-clk
       - qcom,sdx65-rpmh-clk
+      - qcom,sdx75-rpmh-clk
       - qcom,sm6350-rpmh-clk
       - qcom,sm8150-rpmh-clk
       - qcom,sm8250-rpmh-clk
diff --git a/include/dt-bindings/clock/qcom,gcc-sdx75.h b/include/dt-bindings/clock/qcom,gcc-sdx75.h
new file mode 100644
index 000000000000..a470e8c4fd41
--- /dev/null
+++ b/include/dt-bindings/clock/qcom,gcc-sdx75.h
@@ -0,0 +1,193 @@
+/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
+/*
+ * Copyright (c) 2022-2023, Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#ifndef _DT_BINDINGS_CLK_QCOM_GCC_SDX75_H
+#define _DT_BINDINGS_CLK_QCOM_GCC_SDX75_H
+
+/* GCC clocks */
+#define GPLL0							0
+#define GPLL0_OUT_EVEN						1
+#define GPLL4							2
+#define GPLL5							3
+#define GPLL6							4
+#define GPLL8							5
+#define GCC_AHB_PCIE_LINK_CLK					6
+#define GCC_BOOT_ROM_AHB_CLK					7
+#define GCC_EEE_EMAC0_CLK					8
+#define GCC_EEE_EMAC0_CLK_SRC					9
+#define GCC_EEE_EMAC1_CLK					10
+#define GCC_EEE_EMAC1_CLK_SRC					11
+#define GCC_EMAC0_AXI_CLK					12
+#define GCC_EMAC0_CC_SGMIIPHY_RX_CLK				13
+#define GCC_EMAC0_CC_SGMIIPHY_RX_CLK_SRC			14
+#define GCC_EMAC0_CC_SGMIIPHY_TX_CLK				15
+#define GCC_EMAC0_CC_SGMIIPHY_TX_CLK_SRC			16
+#define GCC_EMAC0_PHY_AUX_CLK					17
+#define GCC_EMAC0_PHY_AUX_CLK_SRC				18
+#define GCC_EMAC0_PTP_CLK					19
+#define GCC_EMAC0_PTP_CLK_SRC					20
+#define GCC_EMAC0_RGMII_CLK					21
+#define GCC_EMAC0_RGMII_CLK_SRC					22
+#define GCC_EMAC0_RPCS_RX_CLK					23
+#define GCC_EMAC0_RPCS_TX_CLK					24
+#define GCC_EMAC0_SGMIIPHY_MAC_RCLK_SRC				25
+#define GCC_EMAC0_SGMIIPHY_MAC_TCLK_SRC				26
+#define GCC_EMAC0_SLV_AHB_CLK					27
+#define GCC_EMAC0_XGXS_RX_CLK					28
+#define GCC_EMAC0_XGXS_TX_CLK					29
+#define GCC_EMAC1_AXI_CLK					30
+#define GCC_EMAC1_CC_SGMIIPHY_RX_CLK				31
+#define GCC_EMAC1_CC_SGMIIPHY_RX_CLK_SRC			32
+#define GCC_EMAC1_CC_SGMIIPHY_TX_CLK				33
+#define GCC_EMAC1_CC_SGMIIPHY_TX_CLK_SRC			34
+#define GCC_EMAC1_PHY_AUX_CLK					35
+#define GCC_EMAC1_PHY_AUX_CLK_SRC				36
+#define GCC_EMAC1_PTP_CLK					37
+#define GCC_EMAC1_PTP_CLK_SRC					38
+#define GCC_EMAC1_RGMII_CLK					39
+#define GCC_EMAC1_RGMII_CLK_SRC					40
+#define GCC_EMAC1_RPCS_RX_CLK					41
+#define GCC_EMAC1_RPCS_TX_CLK					42
+#define GCC_EMAC1_SGMIIPHY_MAC_RCLK_SRC				43
+#define GCC_EMAC1_SGMIIPHY_MAC_TCLK_SRC				44
+#define GCC_EMAC1_SLV_AHB_CLK					45
+#define GCC_EMAC1_XGXS_RX_CLK					46
+#define GCC_EMAC1_XGXS_TX_CLK					47
+#define GCC_EMAC_0_CLKREF_EN					48
+#define GCC_EMAC_1_CLKREF_EN					49
+#define GCC_GP1_CLK						50
+#define GCC_GP1_CLK_SRC						51
+#define GCC_GP2_CLK						52
+#define GCC_GP2_CLK_SRC						53
+#define GCC_GP3_CLK						54
+#define GCC_GP3_CLK_SRC						55
+#define GCC_PCIE_0_CLKREF_EN					56
+#define GCC_PCIE_1_AUX_CLK					57
+#define GCC_PCIE_1_AUX_PHY_CLK_SRC				58
+#define GCC_PCIE_1_CFG_AHB_CLK					59
+#define GCC_PCIE_1_CLKREF_EN					60
+#define GCC_PCIE_1_MSTR_AXI_CLK					61
+#define GCC_PCIE_1_PHY_RCHNG_CLK				62
+#define GCC_PCIE_1_PHY_RCHNG_CLK_SRC				63
+#define GCC_PCIE_1_PIPE_CLK					64
+#define GCC_PCIE_1_PIPE_CLK_SRC					65
+#define GCC_PCIE_1_PIPE_DIV2_CLK				66
+#define GCC_PCIE_1_PIPE_DIV2_CLK_SRC				67
+#define GCC_PCIE_1_SLV_AXI_CLK					68
+#define GCC_PCIE_1_SLV_Q2A_AXI_CLK				69
+#define GCC_PCIE_2_AUX_CLK					70
+#define GCC_PCIE_2_AUX_PHY_CLK_SRC				71
+#define GCC_PCIE_2_CFG_AHB_CLK					72
+#define GCC_PCIE_2_CLKREF_EN					73
+#define GCC_PCIE_2_MSTR_AXI_CLK					74
+#define GCC_PCIE_2_PHY_RCHNG_CLK				75
+#define GCC_PCIE_2_PHY_RCHNG_CLK_SRC				76
+#define GCC_PCIE_2_PIPE_CLK					77
+#define GCC_PCIE_2_PIPE_CLK_SRC					78
+#define GCC_PCIE_2_PIPE_DIV2_CLK				79
+#define GCC_PCIE_2_PIPE_DIV2_CLK_SRC				80
+#define GCC_PCIE_2_SLV_AXI_CLK					81
+#define GCC_PCIE_2_SLV_Q2A_AXI_CLK				82
+#define GCC_PCIE_AUX_CLK					83
+#define GCC_PCIE_AUX_CLK_SRC					84
+#define GCC_PCIE_AUX_PHY_CLK_SRC				85
+#define GCC_PCIE_CFG_AHB_CLK					86
+#define GCC_PCIE_MSTR_AXI_CLK					87
+#define GCC_PCIE_PIPE_CLK					88
+#define GCC_PCIE_PIPE_CLK_SRC					89
+#define GCC_PCIE_RCHNG_PHY_CLK					90
+#define GCC_PCIE_RCHNG_PHY_CLK_SRC				91
+#define GCC_PCIE_SLEEP_CLK					92
+#define GCC_PCIE_SLV_AXI_CLK					93
+#define GCC_PCIE_SLV_Q2A_AXI_CLK				94
+#define GCC_PDM2_CLK						95
+#define GCC_PDM2_CLK_SRC					96
+#define GCC_PDM_AHB_CLK						97
+#define GCC_PDM_XO4_CLK						98
+#define GCC_QUPV3_WRAP0_CORE_2X_CLK				99
+#define GCC_QUPV3_WRAP0_CORE_CLK				100
+#define GCC_QUPV3_WRAP0_S0_CLK					101
+#define GCC_QUPV3_WRAP0_S0_CLK_SRC				102
+#define GCC_QUPV3_WRAP0_S1_CLK					103
+#define GCC_QUPV3_WRAP0_S1_CLK_SRC				104
+#define GCC_QUPV3_WRAP0_S2_CLK					105
+#define GCC_QUPV3_WRAP0_S2_CLK_SRC				106
+#define GCC_QUPV3_WRAP0_S3_CLK					107
+#define GCC_QUPV3_WRAP0_S3_CLK_SRC				108
+#define GCC_QUPV3_WRAP0_S4_CLK					109
+#define GCC_QUPV3_WRAP0_S4_CLK_SRC				110
+#define GCC_QUPV3_WRAP0_S5_CLK					111
+#define GCC_QUPV3_WRAP0_S5_CLK_SRC				112
+#define GCC_QUPV3_WRAP0_S6_CLK					113
+#define GCC_QUPV3_WRAP0_S6_CLK_SRC				114
+#define GCC_QUPV3_WRAP0_S7_CLK					115
+#define GCC_QUPV3_WRAP0_S7_CLK_SRC				116
+#define GCC_QUPV3_WRAP0_S8_CLK					117
+#define GCC_QUPV3_WRAP0_S8_CLK_SRC				118
+#define GCC_QUPV3_WRAP_0_M_AHB_CLK				119
+#define GCC_QUPV3_WRAP_0_S_AHB_CLK				120
+#define GCC_SDCC1_AHB_CLK					121
+#define GCC_SDCC1_APPS_CLK					122
+#define GCC_SDCC1_APPS_CLK_SRC					123
+#define GCC_SDCC2_AHB_CLK					124
+#define GCC_SDCC2_APPS_CLK					125
+#define GCC_SDCC2_APPS_CLK_SRC					126
+#define GCC_USB2_CLKREF_EN					127
+#define GCC_USB30_MASTER_CLK					128
+#define GCC_USB30_MASTER_CLK_SRC				129
+#define GCC_USB30_MOCK_UTMI_CLK					130
+#define GCC_USB30_MOCK_UTMI_CLK_SRC				131
+#define GCC_USB30_MOCK_UTMI_POSTDIV_CLK_SRC			132
+#define GCC_USB30_MSTR_AXI_CLK					133
+#define GCC_USB30_SLEEP_CLK					134
+#define GCC_USB30_SLV_AHB_CLK					135
+#define GCC_USB3_PHY_AUX_CLK					136
+#define GCC_USB3_PHY_AUX_CLK_SRC				137
+#define GCC_USB3_PHY_PIPE_CLK					138
+#define GCC_USB3_PHY_PIPE_CLK_SRC				139
+#define GCC_USB3_PRIM_CLKREF_EN					140
+#define GCC_USB_PHY_CFG_AHB2PHY_CLK				141
+#define GCC_XO_PCIE_LINK_CLK					142
+
+/* GCC power domains */
+#define GCC_EMAC0_GDSC						0
+#define GCC_EMAC1_GDSC						1
+#define GCC_PCIE_1_GDSC						2
+#define GCC_PCIE_1_PHY_GDSC					3
+#define GCC_PCIE_2_GDSC						4
+#define GCC_PCIE_2_PHY_GDSC					5
+#define GCC_PCIE_GDSC						6
+#define GCC_PCIE_PHY_GDSC					7
+#define GCC_USB30_GDSC						8
+#define GCC_USB3_PHY_GDSC					9
+
+/* GCC resets */
+#define GCC_EMAC0_BCR						0
+#define GCC_EMAC1_BCR						1
+#define GCC_EMMC_BCR						2
+#define GCC_PCIE_1_BCR						3
+#define GCC_PCIE_1_LINK_DOWN_BCR				4
+#define GCC_PCIE_1_NOCSR_COM_PHY_BCR				5
+#define GCC_PCIE_1_PHY_BCR					6
+#define GCC_PCIE_2_BCR						7
+#define GCC_PCIE_2_LINK_DOWN_BCR				8
+#define GCC_PCIE_2_NOCSR_COM_PHY_BCR				9
+#define GCC_PCIE_2_PHY_BCR					10
+#define GCC_PCIE_BCR						11
+#define GCC_PCIE_LINK_DOWN_BCR					12
+#define GCC_PCIE_NOCSR_COM_PHY_BCR				13
+#define GCC_PCIE_PHY_BCR					14
+#define GCC_PCIE_PHY_CFG_AHB_BCR				15
+#define GCC_PCIE_PHY_COM_BCR					16
+#define GCC_PCIE_PHY_NOCSR_COM_PHY_BCR				17
+#define GCC_QUSB2PHY_BCR					18
+#define GCC_TCSR_PCIE_BCR					19
+#define GCC_USB30_BCR						20
+#define GCC_USB3_PHY_BCR					21
+#define GCC_USB3PHY_PHY_BCR					22
+#define GCC_USB_PHY_CFG_AHB2PHY_BCR				23
+#define GCC_EMAC0_RGMII_CLK_ARES				24
+
+#endif
-- 
2.17.1

