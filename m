Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941276645EC
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 17:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbjAJQWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 11:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbjAJQWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 11:22:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C38560F5;
        Tue, 10 Jan 2023 08:22:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD8B3B8189A;
        Tue, 10 Jan 2023 16:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC21C433D2;
        Tue, 10 Jan 2023 16:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673367754;
        bh=qDNbGsVF1iuDtf5oq/RNZWeFhJd4UmBBYRdzY/Wm8oY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iR7D2cGb34GHAf53lrVVjf86IULw680O056biqGB0N3I2LiUIqnXUMqcUjIVGTtCb
         lfhe6QCOZL3chvGRvWjrLdKVJzARdnsN/BCsGYqz9TxngOdWtsXfMQqkix2/lHwcod
         o2ZtxUEIszFIAv330opllHj/rzkdsftYw8lmAWbLsou6Zu8lymTqalHRVYPqybUwGW
         i9tC8/tEB2z6C3JvuI0AJ+RWd9IT68XnODlaV6K6zPqHYGw+nNXDjLkpdF2oKbVfj8
         irvPfrJ73t5MYnnd/8F2NJl7wkKOpGLTJebON12p6Uk0xRZwXuzVuWWjxSP+YUi6e+
         /P/oI0aIw+OCA==
Date:   Tue, 10 Jan 2023 10:22:30 -0600
From:   Bjorn Andersson <andersson@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH 09/18] dt-bindings: pinctrl: sa8775p: add bindings for
 qcom,sa8775p-tlmm
Message-ID: <20230110162230.s6xr3vvgkx4diakv@builder.lan>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-10-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109174511.1740856-10-brgl@bgdev.pl>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 06:45:02PM +0100, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add DT bindings for the TLMM controller on sa8775p platforms.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  .../bindings/pinctrl/qcom,sa8775p-tlmm.yaml   | 142 ++++++++++++++++++
>  1 file changed, 142 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sa8775p-tlmm.yaml
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,sa8775p-tlmm.yaml b/Documentation/devicetree/bindings/pinctrl/qcom,sa8775p-tlmm.yaml
> new file mode 100644
> index 000000000000..44abf83b1358
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,sa8775p-tlmm.yaml
> @@ -0,0 +1,142 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/pinctrl/qcom,sa8775p-tlmm.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Technologies, Inc. SA8775P TLMM block
> +
> +maintainers:
> +  - Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> +
> +description: |
> +  Top Level Mode Multiplexer pin controller in Qualcomm SA8775P SoC.
> +
> +allOf:
> +  - $ref: /schemas/pinctrl/qcom,tlmm-common.yaml#
> +
> +properties:
> +  compatible:
> +    const: qcom,sa8775p-tlmm
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts: true
> +  interrupt-controller: true
> +  "#interrupt-cells": true
> +  gpio-controller: true
> +  "#gpio-cells": true
> +  gpio-ranges: true
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +patternProperties:
> +  "-state$":
> +    oneOf:
> +      - $ref: "#/$defs/qcom-sa8775p-tlmm-state"
> +      - patternProperties:
> +          "-pins$":
> +            $ref: "#/$defs/qcom-sa8775p-tlmm-state"
> +        additionalProperties: false
> +
> +$defs:
> +  qcom-sa8775p-tlmm-state:
> +    type: object
> +    description:
> +      Pinctrl node's client devices use subnodes for desired pin configuration.
> +      Client device subnodes use below standard properties.
> +    $ref: qcom,tlmm-common.yaml#/$defs/qcom-tlmm-state
> +
> +    properties:
> +      pins:
> +        description:
> +          List of gpio pins affected by the properties specified in this
> +          subnode.
> +        items:
> +          oneOf:
> +            - pattern: "^gpio([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-1][0-9]|22[0-7])$"

Per the driver, this should be "^gpio([0-9]|[1-9][0-9]|1[0-3][0-9]|14[0-8])$"

Regards,
Bjorn

> +            - enum: [ sdc1_rclk, sdc1_clk, sdc1_cmd, sdc1_data, ufs_reset ]
> +        minItems: 1
> +        maxItems: 16
> +
> +      function:
> +        description:
> +          Specify the alternative function to be configured for the specified
> +          pins.
> +
> +        enum: [ atest_char, atest_char0, atest_char1, atest_char2,
> +                atest_char3, atest_usb2, atest_usb20, atest_usb21, atest_usb22,
> +                atest_usb23, audio_ref, cam_mclk, cci_async, cci_i2c,
> +                cci_timer0, cci_timer1, cci_timer2, cci_timer3, cci_timer4,
> +                cci_timer5, cci_timer6, cci_timer7, cci_timer8, cci_timer9,
> +                cri_trng, cri_trng0, cri_trng1, dbg_out, ddr_bist, ddr_pxi0,
> +                ddr_pxi1, ddr_pxi2, ddr_pxi3, ddr_pxi4, ddr_pxi5, edp0_hot,
> +                edp0_lcd, edp1_hot, edp1_lcd, edp2_hot, edp2_lcd, edp3_hot,
> +                edp3_lcd, emac0_mcg0, emac0_mcg1, emac0_mcg2, emac0_mcg3,
> +                emac0_mdc, emac0_mdio, emac0_ptp, emac1_mcg0, emac1_mcg1,
> +                emac1_mcg2, emac1_mcg3, emac1_mdc, emac1_mdio, emac1_ptp,
> +                gcc_gp1, gcc_gp2, gcc_gp3, gcc_gp4, gcc_gp5, hs0_mi2s, hs1_mi2s,
> +                hs2_mi2s, ibi_i3c, jitter_bist, mdp0_vsync0, mdp0_vsync1,
> +                mdp0_vsync2, mdp0_vsync3, mdp0_vsync4, mdp0_vsync5, mdp0_vsync6,
> +                mdp0_vsync7, mdp0_vsync8, mdp1_vsync0, mdp1_vsync1, mdp1_vsync2,
> +                mdp1_vsync3, mdp1_vsync4, mdp1_vsync5, mdp1_vsync6, mdp1_vsync7,
> +                mdp1_vsync8, mdp_vsync, mi2s1_data0, mi2s1_data1, mi2s1_sck,
> +                mi2s1_ws, mi2s2_data0, mi2s2_data1, mi2s2_sck, mi2s2_ws,
> +                mi2s_mclk0, mi2s_mclk1, pcie0_clkreq, pcie1_clkreq, phase_flag0,
> +                phase_flag1, phase_flag10, phase_flag11, phase_flag12,
> +                phase_flag13, phase_flag14, phase_flag15, phase_flag16,
> +                phase_flag17, phase_flag18, phase_flag19, phase_flag2,
> +                phase_flag20, phase_flag21, phase_flag22, phase_flag23,
> +                phase_flag24, phase_flag25, phase_flag26, phase_flag27,
> +                phase_flag28, phase_flag29, phase_flag3, phase_flag30,
> +                phase_flag31, phase_flag4, phase_flag5, phase_flag6,
> +                phase_flag7, phase_flag8, phase_flag9, pll_bist, pll_clk,
> +                prng_rosc0, prng_rosc1, prng_rosc2, prng_rosc3, qdss_cti,
> +                qdss_gpio, qdss_gpio0, qdss_gpio1, qdss_gpio10, qdss_gpio11,
> +                qdss_gpio12, qdss_gpio13, qdss_gpio14, qdss_gpio15, qdss_gpio2,
> +                qdss_gpio3, qdss_gpio4, qdss_gpio5, qdss_gpio6, qdss_gpio7,
> +                qdss_gpio8, qdss_gpio9, qup0_se0, qup0_se1, qup0_se2, qup0_se3,
> +                qup0_se4, qup0_se5, qup1_se0, qup1_se1, qup1_se2, qup1_se3,
> +                qup1_se4, qup1_se5, qup1_se6, qup2_se0, qup2_se1, qup2_se2,
> +                qup2_se3, qup2_se4, qup2_se5, qup2_se6, qup3_se0, sail_top,
> +                sailss_emac0, sailss_ospi, sgmii_phy, tb_trig, tgu_ch0, tgu_ch1,
> +                tgu_ch2, tgu_ch3, tgu_ch4, tgu_ch5, tsense_pwm1, tsense_pwm2,
> +                tsense_pwm3, tsense_pwm4, usb2phy_ac, vsense_trigger]
> +
> +      bias-disable: true
> +      bias-pull-down: true
> +      bias-pull-up: true
> +      drive-strength: true
> +      input-enable: true
> +      output-high: true
> +      output-low: true
> +
> +    required:
> +      - pins
> +
> +    additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    tlmm: pinctrl@f000000 {
> +        compatible = "qcom,sa8775p-pinctrl";
> +        reg = <0xf000000 0x1000000>;
> +        interrupts = <GIC_SPI 208 IRQ_TYPE_LEVEL_HIGH>;
> +        gpio-controller;
> +        #gpio-cells = <2>;
> +        interrupt-controller;
> +        #interrupt-cells = <2>;
> +        gpio-ranges = <&tlmm 0 0 149>;
> +
> +        qup_uart10_state {
> +            pins = "gpio46", "gpio47";
> +            function = "qup1_se3";
> +        };
> +    };
> +...
> -- 
> 2.37.2
> 
