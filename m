Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 205CB6EAB13
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 14:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbjDUM42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 08:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232271AbjDUM4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 08:56:25 -0400
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14808196;
        Fri, 21 Apr 2023 05:56:24 -0700 (PDT)
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-187949fdb1cso1523620fac.0;
        Fri, 21 Apr 2023 05:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682081783; x=1684673783;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WNkmsQxgkXH6mE112zcuABKnLRilEp0QWlma0Pk+25k=;
        b=F4tfOFr1Mv8AmYyh7aqfS0Sc5tXZfRZqNFv27zqiROWN3L5IRnFiVMS93TfqhHIAA9
         pQ9j2Cwdp5SdOf9CF2Jm2VhGZF7eEUif+8PtX92HxmTKBnYZSQES+lIBp+5I/AGZoSLQ
         s+18vfqYqKFUaKCS69DXDUqWy+JTyZ8eHq6HIbOm+NWIB47AV+7OibZ9/m1jWJmVbVtv
         ZK06evf/pUVtmLa5MEVFlzpBcAhaRFMeXT5eVBXmb0tetJ/jwMrAivWl5OA9GaREAOd7
         trEz3BM4tSIuZ/m2NYKnwAl//T6Vrmet3KzmbvOF40kCUAig7HZvRqYsw+1jeNFDSX4v
         Khjw==
X-Gm-Message-State: AAQBX9cc2N2jB2NlK1eh26fPsrLDjxVgU15lYgXrMIG2rDW8eqNg+zlu
        z5XxRy8r4oH0NLfAGP29xw==
X-Google-Smtp-Source: AKy350aUK/1gjVKgIJev0Umt6rsPAzCW08yPNHMub51+2DshvFT6pJz3C1TMAiqoBvJgFFZk+QciSA==
X-Received: by 2002:a05:6871:29b:b0:184:266a:142f with SMTP id i27-20020a056871029b00b00184266a142fmr3806205oae.51.1682081783200;
        Fri, 21 Apr 2023 05:56:23 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id b35-20020a4a98e6000000b0051a6cb524b6sm1740179ooj.2.2023.04.21.05.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 05:56:22 -0700 (PDT)
Received: (nullmailer pid 936707 invoked by uid 1000);
        Fri, 21 Apr 2023 12:56:18 -0000
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc:     andersson@kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, richardcochran@gmail.com,
        netdev@vger.kernel.org, linus.walleij@linaro.org,
        robh+dt@kernel.org, agross@kernel.org, linux-gpio@vger.kernel.org,
        manivannan.sadhasivam@linaro.org,
        krzysztof.kozlowski+dt@linaro.org, konrad.dybcio@linaro.org,
        devicetree@vger.kernel.org
In-Reply-To: <1682070196-980-2-git-send-email-quic_rohiagar@quicinc.com>
References: <1682070196-980-1-git-send-email-quic_rohiagar@quicinc.com>
 <1682070196-980-2-git-send-email-quic_rohiagar@quicinc.com>
Message-Id: <168208107990.922528.1582713033522143366.robh@kernel.org>
Subject: Re: [PATCH v2 1/2] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl
 devicetree compatible
Date:   Fri, 21 Apr 2023 07:56:18 -0500
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 21 Apr 2023 15:13:15 +0530, Rohit Agarwal wrote:
> Add device tree binding Documentation details for Qualcomm SDX75
> pinctrl driver.
> 
> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
> ---
>  .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          | 177 +++++++++++++++++++++
>  1 file changed, 177 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:
./Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml:76:52: [warning] too few spaces after comma (commas)

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.example.dtb: pinctrl@f100000: uart-w-state: 'oneOf' conditional failed, one must be fixed:
	'function' is a required property
	'pins' is a required property
	'rx-pins', 'tx-pins' do not match any of the regexes: 'pinctrl-[0-9]+'
	'qup_se1_l2_mira' is not one of ['gpio', 'eth0_mdc', 'eth0_mdio', 'eth1_mdc', 'eth1_mdio', 'qlink0_wmss_reset', 'qlink1_wmss_reset', 'rgmii_rxc', 'rgmii_rxd0', 'rgmii_rxd1', 'rgmii_rxd2', 'rgmii_rxd3', 'rgmii_rx_ctl', 'rgmii_txc', 'rgmii_txd0', 'rgmii_txd1', 'rgmii_txd2', 'rgmii_txd3', 'rgmii_tx_ctl', 'adsp_ext_vfr', 'atest_char_start', 'atest_char_status0', 'atest_char_status1', 'atest_char_status2', 'atest_char_status3', 'audio_ref_clk', 'bimc_dte_test0', 'bimc_dte_test1', 'char_exec_pending', 'char_exec_release', 'coex_uart2_rx', 'coex_uart2_tx', 'coex_uart_rx', 'coex_uart_tx', 'cri_trng_rosc', 'cri_trng_rosc0', 'cri_trng_rosc1', 'dbg_out_clk', 'ddr_bist_complete', 'ddr_bist_fail', 'ddr_bist_start', 'ddr_bist_stop', 'ddr_pxi0_test', 'ebi0_wrcdc_dq2', 'ebi0_wrcdc_dq3', 'ebi2_a_d', 'ebi2_lcd_cs', 'ebi2_lcd_reset', 'ebi2_lcd_te', 'emac0_mcg_pst0', 'emac0_mcg_pst1', 'emac0_mcg_pst2', 'emac0_mcg_pst3', 'emac0_ptp_aux', 'emac0_ptp_pps', 'emac1_mcg_pst0', 'emac1_mcg_pst1', 'emac1_mcg_ps
 t2', 'emac1_mcg_pst3', 'emac1_ptp_aux0', 'emac1_ptp_aux1', 'emac1_ptp_aux2', 'emac1_ptp_aux3', 'emac1_ptp_pps0', 'emac1_ptp_pps1', 'emac1_ptp_pps2', 'emac1_ptp_pps3', 'emac_cdc_dtest0', 'emac_cdc_dtest1', 'emac_pps_in', 'ext_dbg_uart', 'gcc_125_clk', 'gcc_gp1_clk', 'gcc_gp2_clk', 'gcc_gp3_clk', 'gcc_plltest_bypassnl', 'gcc_plltest_resetn', 'i2s_mclk', 'jitter_bist_ref', 'ldo_en', 'ldo_update', 'm_voc_ext', 'mgpi_clk_req', 'native0', 'native1', 'native2', 'native3', 'native_char_start', 'native_tsens_osc', 'native_tsense_pwm1', 'nav_dr_sync', 'nav_gpio_0', 'nav_gpio_1', 'nav_gpio_2', 'nav_gpio_3', 'pa_indicator_1', 'pci_e_rst', 'pcie0_clkreq_n', 'pcie1_clkreq_n', 'pcie2_clkreq_n', 'pll_bist_sync', 'pll_clk_aux', 'pll_ref_clk', 'pri_mi2s_data0', 'pri_mi2s_data1', 'pri_mi2s_sck', 'pri_mi2s_ws', 'prng_rosc_test0', 'prng_rosc_test1', 'prng_rosc_test2', 'prng_rosc_test3', 'qdss_cti_trig0', 'qdss_cti_trig1', 'qdss_gpio_traceclk', 'qdss_gpio_tracectl', 'qdss_gpio_tracedata0', 'qdss_gpio_tra
 cedata1', 'qdss_gpio_tracedata10', 'qdss_gpio_tracedata11', 'qdss_gpio_tracedata12', 'qdss_gpio_tracedata13', 'qdss_gpio_tracedata14', 'qdss_gpio_tracedata15', 'qdss_gpio_tracedata2', 'qdss_gpio_tracedata3', 'qdss_gpio_tracedata4', 'qdss_gpio_tracedata5', 'qdss_gpio_tracedata6', 'qdss_gpio_tracedata7', 'qdss_gpio_tracedata8', 'qdss_gpio_tracedata9', 'qlink0_b_en', 'qlink0_b_req', 'qlink0_l_en', 'qlink0_l_req', 'qlink1_l_en', 'qlink1_l_req', 'qup_se0_l0', 'qup_se0_l1', 'qup_se0_l2', 'qup_se0_l3', 'qup_se1_l2', 'qup_se1_l3', 'qup_se2_l0', 'qup_se2_l1', 'qup_se2_l2', 'qup_se2_l3', 'qup_se3_l0', 'qup_se3_l1', 'qup_se3_l2', 'qup_se3_l3', 'qup_se4_l2', 'qup_se4_l3', 'qup_se5_l0', 'qup_se5_l1', 'qup_se6_l0', 'qup_se6_l1', 'qup_se6_l2', 'qup_se6_l3', 'qup_se7_l0', 'qup_se7_l1', 'qup_se7_l2', 'qup_se7_l3', 'qup_se8_l2', 'qup_se8_l3', 'sdc1_tb_trig', 'sdc2_tb_trig', 'sec_mi2s_data0', 'sec_mi2s_data1', 'sec_mi2s_sck', 'sec_mi2s_ws', 'sgmii_phy_intr0', 'sgmii_phy_intr1', 'spmi_coex_clk', 'spmi_
 coex_data', 'spmi_vgi_hwevent', 'tgu_ch0_trigout', 'tri_mi2s_data0', 'tri_mi2s_data1', 'tri_mi2s_sck', 'tri_mi2s_ws', 'uim1_clk', 'uim1_data', 'uim1_present', 'uim1_reset', 'uim2_clk', 'uim2_data', 'uim2_present', 'uim2_reset', 'usb2phy_ac_en', 'vsense_trigger_mirnat']
	'qup_se1_l3_mira' is not one of ['gpio', 'eth0_mdc', 'eth0_mdio', 'eth1_mdc', 'eth1_mdio', 'qlink0_wmss_reset', 'qlink1_wmss_reset', 'rgmii_rxc', 'rgmii_rxd0', 'rgmii_rxd1', 'rgmii_rxd2', 'rgmii_rxd3', 'rgmii_rx_ctl', 'rgmii_txc', 'rgmii_txd0', 'rgmii_txd1', 'rgmii_txd2', 'rgmii_txd3', 'rgmii_tx_ctl', 'adsp_ext_vfr', 'atest_char_start', 'atest_char_status0', 'atest_char_status1', 'atest_char_status2', 'atest_char_status3', 'audio_ref_clk', 'bimc_dte_test0', 'bimc_dte_test1', 'char_exec_pending', 'char_exec_release', 'coex_uart2_rx', 'coex_uart2_tx', 'coex_uart_rx', 'coex_uart_tx', 'cri_trng_rosc', 'cri_trng_rosc0', 'cri_trng_rosc1', 'dbg_out_clk', 'ddr_bist_complete', 'ddr_bist_fail', 'ddr_bist_start', 'ddr_bist_stop', 'ddr_pxi0_test', 'ebi0_wrcdc_dq2', 'ebi0_wrcdc_dq3', 'ebi2_a_d', 'ebi2_lcd_cs', 'ebi2_lcd_reset', 'ebi2_lcd_te', 'emac0_mcg_pst0', 'emac0_mcg_pst1', 'emac0_mcg_pst2', 'emac0_mcg_pst3', 'emac0_ptp_aux', 'emac0_ptp_pps', 'emac1_mcg_pst0', 'emac1_mcg_pst1', 'emac1_mcg_ps
 t2', 'emac1_mcg_pst3', 'emac1_ptp_aux0', 'emac1_ptp_aux1', 'emac1_ptp_aux2', 'emac1_ptp_aux3', 'emac1_ptp_pps0', 'emac1_ptp_pps1', 'emac1_ptp_pps2', 'emac1_ptp_pps3', 'emac_cdc_dtest0', 'emac_cdc_dtest1', 'emac_pps_in', 'ext_dbg_uart', 'gcc_125_clk', 'gcc_gp1_clk', 'gcc_gp2_clk', 'gcc_gp3_clk', 'gcc_plltest_bypassnl', 'gcc_plltest_resetn', 'i2s_mclk', 'jitter_bist_ref', 'ldo_en', 'ldo_update', 'm_voc_ext', 'mgpi_clk_req', 'native0', 'native1', 'native2', 'native3', 'native_char_start', 'native_tsens_osc', 'native_tsense_pwm1', 'nav_dr_sync', 'nav_gpio_0', 'nav_gpio_1', 'nav_gpio_2', 'nav_gpio_3', 'pa_indicator_1', 'pci_e_rst', 'pcie0_clkreq_n', 'pcie1_clkreq_n', 'pcie2_clkreq_n', 'pll_bist_sync', 'pll_clk_aux', 'pll_ref_clk', 'pri_mi2s_data0', 'pri_mi2s_data1', 'pri_mi2s_sck', 'pri_mi2s_ws', 'prng_rosc_test0', 'prng_rosc_test1', 'prng_rosc_test2', 'prng_rosc_test3', 'qdss_cti_trig0', 'qdss_cti_trig1', 'qdss_gpio_traceclk', 'qdss_gpio_tracectl', 'qdss_gpio_tracedata0', 'qdss_gpio_tra
 cedata1', 'qdss_gpio_tracedata10', 'qdss_gpio_tracedata11', 'qdss_gpio_tracedata12', 'qdss_gpio_tracedata13', 'qdss_gpio_tracedata14', 'qdss_gpio_tracedata15', 'qdss_gpio_tracedata2', 'qdss_gpio_tracedata3', 'qdss_gpio_tracedata4', 'qdss_gpio_tracedata5', 'qdss_gpio_tracedata6', 'qdss_gpio_tracedata7', 'qdss_gpio_tracedata8', 'qdss_gpio_tracedata9', 'qlink0_b_en', 'qlink0_b_req', 'qlink0_l_en', 'qlink0_l_req', 'qlink1_l_en', 'qlink1_l_req', 'qup_se0_l0', 'qup_se0_l1', 'qup_se0_l2', 'qup_se0_l3', 'qup_se1_l2', 'qup_se1_l3', 'qup_se2_l0', 'qup_se2_l1', 'qup_se2_l2', 'qup_se2_l3', 'qup_se3_l0', 'qup_se3_l1', 'qup_se3_l2', 'qup_se3_l3', 'qup_se4_l2', 'qup_se4_l3', 'qup_se5_l0', 'qup_se5_l1', 'qup_se6_l0', 'qup_se6_l1', 'qup_se6_l2', 'qup_se6_l3', 'qup_se7_l0', 'qup_se7_l1', 'qup_se7_l2', 'qup_se7_l3', 'qup_se8_l2', 'qup_se8_l3', 'sdc1_tb_trig', 'sdc2_tb_trig', 'sec_mi2s_data0', 'sec_mi2s_data1', 'sec_mi2s_sck', 'sec_mi2s_ws', 'sgmii_phy_intr0', 'sgmii_phy_intr1', 'spmi_coex_clk', 'spmi_
 coex_data', 'spmi_vgi_hwevent', 'tgu_ch0_trigout', 'tri_mi2s_data0', 'tri_mi2s_data1', 'tri_mi2s_sck', 'tri_mi2s_ws', 'uim1_clk', 'uim1_data', 'uim1_present', 'uim1_reset', 'uim2_clk', 'uim2_data', 'uim2_present', 'uim2_reset', 'usb2phy_ac_en', 'vsense_trigger_mirnat']
	From schema: /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/1682070196-980-2-git-send-email-quic_rohiagar@quicinc.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.

