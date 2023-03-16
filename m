Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872576BCCB5
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjCPKZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCPKZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:25:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F3BBD4DD;
        Thu, 16 Mar 2023 03:25:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF393B820C9;
        Thu, 16 Mar 2023 10:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660EDC433D2;
        Thu, 16 Mar 2023 10:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678962303;
        bh=fbzlKO+X2sefQ2LynJlI2Eu7OSdIGiE5+gSyuITPnq0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WOqyNA9AaiDMXiTO1+8wCOMJ16PjLN0cv2MzroH6sXthFkAMb/5/XUfg29drHtTp2
         AEoZ8au5U2kdXnYrOm0/75ATC0gaVbBzeQny7sYMfAMpe5ijjFlz3/kuk0LLF97Up9
         OFbQ2D281ChNcQWYdqq9FXuDIITnksEa7z1ZuISIWLM2U5eG2XurE0fAm/Zv+yZkdq
         DnsVqDVFflEIoTG4Ggkbc3qIfDwKSXu4jGILT8wgPlL59uwliZb+px/y/AiV3jEv4I
         bxqQqOdreV7mEW378oTZvSOog7iLJsup2/YymmUEq19xHtavXNCT4m0rOSI2tJl7pZ
         bNcnvV4wURjEw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pckoG-0001gb-8T; Thu, 16 Mar 2023 11:26:12 +0100
Date:   Thu, 16 Mar 2023 11:26:12 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <andersson@kernel.org>
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
Subject: Re: [PATCH v6 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Message-ID: <ZBLuxFxFvCY+0XHG@hovoldconsulting.com>
References: <20230316034759.73489-1-steev@kali.org>
 <20230316034759.73489-5-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316034759.73489-5-steev@kali.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 10:47:58PM -0500, Steev Klimaszewski wrote:
> The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
> add this.
> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> ---
> Changes since v5:
>  * Update patch subject
>  * Specify initial mode (via guess) for vreg_s1c
>  * Drop uart17 definition
>  * Rename bt_en to bt_default because configuring more than one pin
>  * Correct (maybe) bias configurations
>  * Correct cts gpio
>  * Split rts-tx into two nodes
>  * Drop incorrect link in the commit message
> 
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
> 
>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> index 53ae75fb52ed..b3221c27903a 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> @@ -24,6 +24,7 @@ / {
>  	aliases {
>  		i2c4 = &i2c4;
>  		i2c21 = &i2c21;
> +		serial1 = &uart2;
>  	};
>  
>  	wcd938x: audio-codec {
> @@ -431,6 +432,16 @@ regulators-1 {
>  		qcom,pmic-id = "c";
>  		vdd-bob-supply = <&vreg_vph_pwr>;
>  
> +		vreg_s1c: smps1 {
> +			regulator-name = "vreg_s1c";
> +			regulator-min-microvolt = <1880000>;
> +			regulator-max-microvolt = <1900000>;
> +			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
> +			regulator-allowed-modes = <RPMH_REGULATOR_MODE_AUTO>,
> +						  <RPMH_REGULATOR_MODE_RET>;
> +			regulator-allow-set-load;

So this does not look quite right still as you're specifying an initial
mode which is not listed as allowed.

Also there are no other in-tree users of RPMH_REGULATOR_MODE_RET and
AUTO is used to switch mode automatically which seems odd to use with
allow-set-load.

This regulator is in fact also used by the wifi part of the chip and as
that driver does not set any loads so we may end up with a regulator in
retention mode while wifi is in use.

Perhaps Bjorn can enlighten us, but my guess is that this should just be
"intial-mode = AUTO" (or even HPM, but I have no idea where this came
from originally).

> +		};
> +
>  		vreg_l1c: ldo1 {
>  			regulator-name = "vreg_l1c";
>  			regulator-min-microvolt = <1800000>;
> @@ -901,6 +912,32 @@ &qup0 {
>  	status = "okay";
>  };
>  
> +&uart2 {
> +	pinctrl-0 = <&uart2_default>;
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
> +		pinctrl-0 = <&bt_default>;
> +		pinctrl-names = "default";
> +	};
> +};
> +
>  &qup1 {
>  	status = "okay";
>  };
> @@ -1175,6 +1212,21 @@ hastings_reg_en: hastings-reg-en-state {
>  &tlmm {
>  	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
>  
> +	bt_default: bt-default-state {
> +		hstp-sw-ctrl-pins {
> +			pins = "gpio132";
> +			function = "gpio";
> +			bias-pull-down;
> +		};
> +
> +		hstp-bt-en-pins {
> +			pins = "gpio133";
> +			function = "gpio";
> +			drive-strength = <16>;
> +			bias-disable;
> +		};
> +	};
> +
>  	edp_reg_en: edp-reg-en-state {
>  		pins = "gpio25";
>  		function = "gpio";
> @@ -1196,6 +1248,34 @@ i2c4_default: i2c4-default-state {
>  		bias-disable;
>  	};
>  
> +	uart2_default: uart2-default-state {
> +		cts-pins {
> +			pins = "gpio121";
> +			function = "qup2";
> +			bias-pull-down;

So I believe this should be 'bias-bus-hold' even if the pinctrl binding
may need to be updated to suppress the corresponding dtb check warning.

I'll send a patch for that.

> +		};
> +
> +		rts-pins {
> +			pins = "gpio122";
> +			function = "qup2";
> +			drive-strength = <2>;
> +			bias-disable;
> +		};
> +
> +		tx-pins {

nit: tx should go after rx for alphabetical sorting.

> +			pins = "gpio123";
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
