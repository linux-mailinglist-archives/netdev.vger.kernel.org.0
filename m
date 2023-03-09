Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8587E6B2BF7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjCIRYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCIRYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:24:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B575F2FA8;
        Thu,  9 Mar 2023 09:24:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03670B8203D;
        Thu,  9 Mar 2023 17:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CA5C433EF;
        Thu,  9 Mar 2023 17:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678382659;
        bh=VWtqIlKHObw1KkATVYaWAZcY7al17UIGC/BCtmz1hxA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lieMofFvyKBoYw8d8lO2KtuYkSfx7Rr9SRbhEsIJ8srQf96dcMCecIm35P9dzVj8U
         SmisPpcjdnahi3DIACxSBuaF+3zMbnoxBTOI9agrQGxCSJikKbEKacHrdUkr3fis1x
         BP53n/2l8sQflCpU3Ri2Vwku8re/4KMm4swsysxemwSr3PByGHVU5ZkJB6vwcOpHIg
         SKED2Cj4VN/cKSc0pG5TtvLW/4hSlNK5f8YiTq6UI/wJXUaf3PWgiVbOlAForWc/9B
         9VSSy6KLQCOX1oV0+T6mN/JrA2o/oNDG0BBJsg2i3KypcCjYdZ8todriC3sOoTuNyj
         IkZX4lb2dqEJg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1paK0r-0002h6-7V; Thu, 09 Mar 2023 18:25:09 +0100
Date:   Thu, 9 Mar 2023 18:25:09 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
Subject: Re: [PATCH v5 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
Message-ID: <ZAoWdR7mppnWclFr@hovoldconsulting.com>
References: <20230209020916.6475-1-steev@kali.org>
 <20230209020916.6475-5-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209020916.6475-5-steev@kali.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 08:09:16PM -0600, Steev Klimaszewski wrote:
> The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
> add this.
> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> Link: https://lore.kernel.org/r/20230207052829.3996-5-steev@kali.org

This link should not be needed.

Also, please update the patch Subject to use the following prefix:

	arm64: dts: qcom: sc8280xp-x13s: ...

> ---
> Changes since v4:
>  * Address Konrad's review comments.
> 
> Changes since v3:
>  * Add vreg_s1c
>  * Add regulators and not dead code
>  * Fix commit message changelog
> 
> Changes since v2:
>  * Remove dead code and add TODO comment
>  * Make dtbs_check happy with the pin definitions
>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 76 +++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> index f936b020a71d..ad20cfb3a830 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> @@ -24,6 +24,8 @@ / {
>  	aliases {
>  		i2c4 = &i2c4;
>  		i2c21 = &i2c21;
> +		serial0 = &uart17;

This is an unrelated change that does not belong in this patch.

> +		serial1 = &uart2;
>  	};
>  
>  	wcd938x: audio-codec {
> @@ -297,6 +299,15 @@ pmc8280c-rpmh-regulators {
>  		qcom,pmic-id = "c";
>  		vdd-bob-supply = <&vreg_vph_pwr>;
>  
> +		vreg_s1c: smps1 {
> +			regulator-name = "vreg_s1c";
> +			regulator-min-microvolt = <1880000>;
> +			regulator-max-microvolt = <1900000>;
> +			regulator-allowed-modes = <RPMH_REGULATOR_MODE_AUTO>,
> +						  <RPMH_REGULATOR_MODE_RET>;
> +			regulator-allow-set-load;

Don't you need to specify initial-mode as well?

> +		};
> +
>  		vreg_l1c: ldo1 {
>  			regulator-name = "vreg_l1c";
>  			regulator-min-microvolt = <1800000>;
> @@ -712,6 +723,32 @@ &qup0 {
>  	status = "okay";
>  };
>  
> +&uart2 {
> +	pinctrl-0 = <&uart2_state>;
> +	pinctrl-names = "default";
> +
> +	status = "okay";
> +
> +	bluetooth {
> +		compatible = "qcom,wcn6855-bt";
> +
> +		vddio-supply = <&vreg_s10b>;
> +		vddbtcxmx-supply = <&vreg_s12b>;
> +		vddrfacmn-supply = <&vreg_s12b>;
> +		vddrfa0p8-supply = <&vreg_s12b>;
> +		vddrfa1p2-supply = <&vreg_s11b>;
> +		vddrfa1p7-supply = <&vreg_s1c>;
> +
> +		max-speed = <3200000>;
> +
> +		enable-gpios = <&tlmm 133 GPIO_ACTIVE_HIGH>;
> +		swctrl-gpios = <&tlmm 132 GPIO_ACTIVE_HIGH>;
> +
> +		pinctrl-0 = <&bt_en>;
> +		pinctrl-names = "default";
> +	};
> +};
> +
>  &qup1 {
>  	status = "okay";
>  };
> @@ -720,6 +757,11 @@ &qup2 {
>  	status = "okay";
>  };
>  
> +&uart17 {
> +	compatible = "qcom,geni-debug-uart";
> +	status = "okay";
> +};

This bit does not belong here either. We don't have any means of
accessing the debug uart on the X13s so we should probably just leave it
disabled.

> +
>  &remoteproc_adsp {
>  	firmware-name = "qcom/sc8280xp/LENOVO/21BX/qcadsp8280.mbn";
>  
> @@ -980,6 +1022,19 @@ hastings_reg_en: hastings-reg-en-state {
>  &tlmm {
>  	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
>  
> +	bt_en: bt-en-state {

As you are configuring more than one pin, please rename this as:

	bt_default: bt-default-state

> +		hstp-sw-ctrl-pins {
> +			pins = "gpio132";
> +			function = "gpio";

You should define the bias configuration as well. I guess we need to
keep the default pull-down enabled.

> +		};
> +
> +		hstp-bt-en-pins {
> +			pins = "gpio133";
> +			function = "gpio";
> +			drive-strength = <16>;

bias-disable?

> +		};
> +	};
> +
>  	edp_reg_en: edp-reg-en-state {
>  		pins = "gpio25";
>  		function = "gpio";
> @@ -1001,6 +1056,27 @@ i2c4_default: i2c4-default-state {
>  		bias-disable;
>  	};
>  
> +	uart2_state: uart2-state {

Rename this one too:

	uart2_default: uart2-default-state

> +		cts-pins {
> +			pins = "gpio122";

This should be gpio121 (gpio122 is rts).

> +			function = "qup2";
> +			bias-disable;

Don't we need a pull-down on this one to avoid a floating input when the
module is powered down?

> +		};
> +
> +		rts-tx-pins {

Please split this in two nodes.

> +			pins = "gpio122", "gpio123";
> +			function = "qup2";
> +			drive-strength = <2>;
> +			bias-disable;
> +		};
> +
> +		rx-pins {
> +			pins = "gpio124";
> +			function = "qup2";
> +			bias-pull-up;
> +		};
> +	};
> +
>  	i2c21_default: i2c21-default-state {
>  		pins = "gpio81", "gpio82";
>  		function = "qup21";

Johan
