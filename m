Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8536EA867
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjDUKfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjDUKfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:35:39 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED269025;
        Fri, 21 Apr 2023 03:35:37 -0700 (PDT)
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33L9a14x006292;
        Fri, 21 Apr 2023 10:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=BzErLvqPcLnv/szmyIYG/1g3Uggich1GfMl4tlLWRrI=;
 b=a6xblm5c90H/OUvAwDZk66v9u5gsUjLzUHdBg5x2ZA3sel99BDfws3RLEmDbeQPMG0QH
 yKxd2V7mJ/X9rISFxIGwZMCt8ydsTqwCP1AtyDWgqNWvvysQx7HzOR+9nglVkOGYtwqE
 9UBGCFwv735ZMz1vXsCZ6KsssXI18zNI7ydg6+D/dr4T4udD84nuOmHlQW/hPFpBwpTX
 y9MJnrdDlFH4wZ58q3DE11jOJwy2CR3OXxegephiS7SpQCTpFtmC05G2sB4js/FEi70D
 cUCgyWnGdTJY4AAIcKWtGj8NvaNxNpF++VrUAvKmEP+TuU3I7DfHi/JGAVXXbiSN7G3x hg== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3q3cpysde0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 10:35:34 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 33LAZWhU018975
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 10:35:32 GMT
Received: from [10.216.54.119] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.42; Fri, 21 Apr
 2023 03:35:25 -0700
Message-ID: <df304802-bcd9-f241-419a-3345d79bfd1e@quicinc.com>
Date:   Fri, 21 Apr 2023 16:05:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 1/2] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl
 devicetree compatible
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        <agross@kernel.org>, <andersson@kernel.org>,
        <konrad.dybcio@linaro.org>, <linus.walleij@linaro.org>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <richardcochran@gmail.com>, <manivannan.sadhasivam@linaro.org>
CC:     <linux-arm-msm@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1682070196-980-1-git-send-email-quic_rohiagar@quicinc.com>
 <1682070196-980-2-git-send-email-quic_rohiagar@quicinc.com>
 <a68e1bc8-df55-684e-300c-678565ae1dd6@linaro.org>
From:   Rohit Agarwal <quic_rohiagar@quicinc.com>
In-Reply-To: <a68e1bc8-df55-684e-300c-678565ae1dd6@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: MKszbAy73jjHqKNP9Hl-zWu4hgtOYdZB
X-Proofpoint-ORIG-GUID: MKszbAy73jjHqKNP9Hl-zWu4hgtOYdZB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_04,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210091
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/21/2023 3:38 PM, Krzysztof Kozlowski wrote:
> On 21/04/2023 11:43, Rohit Agarwal wrote:
>> Add device tree binding Documentation details for Qualcomm SDX75
>> pinctrl driver.
>>
>> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
> Thank you for your patch. There is something to discuss/improve.
>
>> +properties:
>> +  compatible:
>> +    const: qcom,sdx75-tlmm
>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +  interrupts: true
>> +  interrupt-controller: true
>> +  "#interrupt-cells": true
>> +  gpio-controller: true
>> +
>> +  gpio-reserved-ranges:
>> +    minItems: 1
>> +    maxItems: 105
>> +
>> +  gpio-line-names:
>> +    maxItems: 133
> If you have 210 GPIOs, then this should be 210.
>
>> +
>> +  "#gpio-cells": true
>> +  gpio-ranges: true
>> +  wakeup-parent: true
>> +
>> +patternProperties:
>> +  "-state$":
>> +    oneOf:
>> +      - $ref: "#/$defs/qcom-sdx75-tlmm-state"
>> +      - patternProperties:
>> +          "-pins$":
>> +            $ref: "#/$defs/qcom-sdx75-tlmm-state"
>> +        additionalProperties: false
>> +
>> +$defs:
>> +  qcom-sdx75-tlmm-state:
>> +    type: object
>> +    description:
>> +      Pinctrl node's client devices use subnodes for desired pin configuration.
>> +      Client device subnodes use below standard properties.
>> +    $ref: qcom,tlmm-common.yaml#/$defs/qcom-tlmm-state
> unevaluatedProperties: false
>> +
>> +    properties:
>> +      pins:
>> +        description:
>> +          List of gpio pins affected by the properties specified in this
>> +          subnode.
>> +        items:
>> +          oneOf:
>> +            - pattern: "^gpio([0-9]|[1-9][0-9]|1[0-9][0-9]|20[0-9])$"
> This says you have 210 GPIOs.
>
>> +            - enum: [ ufs_reset, sdc2_clk, sdc2_cmd, sdc2_data ]
> Keep these four enum values sorted alphabetically.
>
>> +        minItems: 1
>> +        maxItems: 36
>> +
>> +      function:
>> +        description:
>> +          Specify the alternative function to be configured for the specified
>> +          pins.
>> +        enum: [ gpio, eth0_mdc, eth0_mdio, eth1_mdc, eth1_mdio,
>> +                qlink0_wmss_reset, qlink1_wmss_reset, rgmii_rxc, rgmii_rxd0,
>> +                rgmii_rxd1, rgmii_rxd2, rgmii_rxd3,rgmii_rx_ctl, rgmii_txc,
>> +                rgmii_txd0, rgmii_txd1, rgmii_txd2, rgmii_txd3, rgmii_tx_ctl,
>> +                adsp_ext_vfr, atest_char_start, atest_char_status0,
>> +                atest_char_status1, atest_char_status2, atest_char_status3,
>> +                audio_ref_clk, bimc_dte_test0, bimc_dte_test1,
>> +                char_exec_pending, char_exec_release, coex_uart2_rx,
>> +                coex_uart2_tx, coex_uart_rx, coex_uart_tx, cri_trng_rosc,
>> +                cri_trng_rosc0, cri_trng_rosc1, dbg_out_clk, ddr_bist_complete,
>> +                ddr_bist_fail, ddr_bist_start, ddr_bist_stop, ddr_pxi0_test,
>> +                ebi0_wrcdc_dq2, ebi0_wrcdc_dq3, ebi2_a_d, ebi2_lcd_cs,
>> +                ebi2_lcd_reset, ebi2_lcd_te, emac0_mcg_pst0, emac0_mcg_pst1,
>> +                emac0_mcg_pst2, emac0_mcg_pst3, emac0_ptp_aux, emac0_ptp_pps,
>> +                emac1_mcg_pst0, emac1_mcg_pst1, emac1_mcg_pst2, emac1_mcg_pst3,
>> +                emac1_ptp_aux0, emac1_ptp_aux1, emac1_ptp_aux2, emac1_ptp_aux3,
>> +                emac1_ptp_pps0, emac1_ptp_pps1, emac1_ptp_pps2, emac1_ptp_pps3,
>> +                emac_cdc_dtest0, emac_cdc_dtest1, emac_pps_in, ext_dbg_uart,
>> +                gcc_125_clk, gcc_gp1_clk, gcc_gp2_clk, gcc_gp3_clk,
>> +                gcc_plltest_bypassnl, gcc_plltest_resetn, i2s_mclk,
>> +                jitter_bist_ref, ldo_en, ldo_update, m_voc_ext, mgpi_clk_req,
>> +                native0, native1, native2, native3, native_char_start,
>> +                native_tsens_osc, native_tsense_pwm1, nav_dr_sync, nav_gpio_0,
>> +                nav_gpio_1, nav_gpio_2, nav_gpio_3, pa_indicator_1, pci_e_rst,
>> +                pcie0_clkreq_n, pcie1_clkreq_n, pcie2_clkreq_n, pll_bist_sync,
>> +                pll_clk_aux, pll_ref_clk, pri_mi2s_data0, pri_mi2s_data1,
>> +                pri_mi2s_sck, pri_mi2s_ws, prng_rosc_test0, prng_rosc_test1,
>> +                prng_rosc_test2, prng_rosc_test3, qdss_cti_trig0,
>> +                qdss_cti_trig1, qdss_gpio_traceclk, qdss_gpio_tracectl,
>> +                qdss_gpio_tracedata0, qdss_gpio_tracedata1,
>> +                qdss_gpio_tracedata10, qdss_gpio_tracedata11,
>> +                qdss_gpio_tracedata12, qdss_gpio_tracedata13,
>> +                qdss_gpio_tracedata14, qdss_gpio_tracedata15,
>> +                qdss_gpio_tracedata2, qdss_gpio_tracedata3,
>> +                qdss_gpio_tracedata4, qdss_gpio_tracedata5,
>> +                qdss_gpio_tracedata6, qdss_gpio_tracedata7,
>> +                qdss_gpio_tracedata8, qdss_gpio_tracedata9, qlink0_b_en,
>> +                qlink0_b_req, qlink0_l_en, qlink0_l_req, qlink1_l_en,
>> +                qlink1_l_req, qup_se0_l0, qup_se0_l1, qup_se0_l2, qup_se0_l3,
>> +                qup_se1_l2, qup_se1_l3, qup_se2_l0, qup_se2_l1, qup_se2_l2,
>> +                qup_se2_l3, qup_se3_l0, qup_se3_l1, qup_se3_l2, qup_se3_l3,
>> +                qup_se4_l2, qup_se4_l3, qup_se5_l0, qup_se5_l1, qup_se6_l0,
>> +                qup_se6_l1, qup_se6_l2, qup_se6_l3, qup_se7_l0, qup_se7_l1,
>> +                qup_se7_l2, qup_se7_l3, qup_se8_l2, qup_se8_l3, sdc1_tb_trig,
>> +                sdc2_tb_trig, sec_mi2s_data0, sec_mi2s_data1, sec_mi2s_sck,
>> +                sec_mi2s_ws, sgmii_phy_intr0, sgmii_phy_intr1, spmi_coex_clk,
>> +                spmi_coex_data, spmi_vgi_hwevent, tgu_ch0_trigout,
>> +                tri_mi2s_data0, tri_mi2s_data1, tri_mi2s_sck, tri_mi2s_ws,
>> +                uim1_clk, uim1_data, uim1_present, uim1_reset, uim2_clk,
>> +                uim2_data, uim2_present, uim2_reset, usb2phy_ac_en,
>> +                vsense_trigger_mirnat]
>> +
>> +      bias-disable: true
>> +      bias-pull-down: true
>> +      bias-pull-up: true
>> +      drive-strength: true
>> +      input-enable: true
> This is not allowed. Please rebase on pinctrl maintainer tree or next.
Will do this.
>
>> +      output-high: true
>> +      output-low: true
>> +
>> +    required:
>> +      - pins
>> +
>> +    additionalProperties: false
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +
>> +additionalProperties: false
>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>> +    tlmm: pinctrl@f100000 {
>> +        compatible = "qcom,sdx75-tlmm";
>> +        reg = <0x0f100000 0x300000>;
>> +        gpio-controller;
>> +        #gpio-cells = <2>;
>> +        gpio-ranges = <&tlmm 0 0 134>;
> Wrong number of pins. You have 210, right? This should be number of
> GPIOs + optionally UFS reset.
Thanks for reviewing the patch.
Actually it has 133 pins. Ok. Let me update the above property as well.
And just checked there is no ufs reset pin. So it should be removed 
completely.

Thanks,
Rohit.
>
>
> Best regards,
> Krzysztof
>
