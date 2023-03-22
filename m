Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDEB6C495C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCVLls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbjCVLlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:41:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0928E5D775;
        Wed, 22 Mar 2023 04:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81A13B81C25;
        Wed, 22 Mar 2023 11:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB87C433EF;
        Wed, 22 Mar 2023 11:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679485300;
        bh=KV7Jg9Jy9M+HzvGb4HuWBzw6Mgf+m1xY4l7N+BLviJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tw6+HLmFoknhV8wFIBm+JPjmRSoGmmA09vlVIJdyGv2FTS5+PUnTEgSGcPMKwtYHt
         1prMWIyy7dXdaPSs4s+Pf99B/LVIYvavbUZVgQGPEquqZh30gLjJG6p23nz0wnkW+M
         0wghGisZCm80ezKLUsJVDMYsfKVN1hsU7iULtX4LWM/a8YaV0zmLffpJw6sejcHKFw
         Svh7pf2KdHVZGYANOJNRV49kyIEcCGq1s17XbC8843SdOJT1xVl9A5Jnj/ZL7SVEYj
         Cj4f3Un7TBvtCSpFfkLsQZOJ9Rh3eH119xS2Xr3NVN914V1NG5rhBuEUsBLJeqRFvX
         XueUPFwkwKinw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pewrx-0004lp-W1; Wed, 22 Mar 2023 12:43:06 +0100
Date:   Wed, 22 Mar 2023 12:43:05 +0100
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
Subject: Re: [PATCH v7 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Message-ID: <ZBrpyXrkHDTQ6Z+l@hovoldconsulting.com>
References: <20230322011442.34475-1-steev@kali.org>
 <20230322011442.34475-5-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322011442.34475-5-steev@kali.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 08:14:42PM -0500, Steev Klimaszewski wrote:
> The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
> add this.
> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> ---
> Changes since v6:
>  * Remove allowed-modes as they aren't needed
>  * Remove regulator-allow-set-load
>  * Set regulator-always-on because the wifi chip also uses the regulator
>  * cts pin uses bias-bus-hold
>  * Alphabetize uart2 pins
> 
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
>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 78 +++++++++++++++++++
>  1 file changed, 78 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> index 92d365519546..05e66505e5cc 100644
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
> @@ -431,6 +432,14 @@ regulators-1 {
>  		qcom,pmic-id = "c";
>  		vdd-bob-supply = <&vreg_vph_pwr>;
>  
> +		vreg_s1c: smps1 {
> +			regulator-name = "vreg_s1c";
> +			regulator-min-microvolt = <1880000>;
> +			regulator-max-microvolt = <1900000>;
> +			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
> +			regulator-always-on;
> +		};

I went through the schematics to check for further problems with
consumers that are not yet described and found a few more bugs:

	https://lore.kernel.org/lkml/20230322113318.17908-1-johan+linaro@kernel.org

Note that that series is now adding the s1c supply as it also used by
some of the pmics.

I'm assuming those fixes may get merged before this patch is, in which
case the above hunk should be dropped.

> +
>  		vreg_l1c: ldo1 {
>  			regulator-name = "vreg_l1c";
>  			regulator-min-microvolt = <1800000>;
> @@ -918,6 +927,32 @@ &qup0 {
>  	status = "okay";
>  };
>  
> +&uart2 {

This node in no longer in alphabetical order and needs to be moved
further down (above &usb_0).

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
> @@ -1192,6 +1227,21 @@ hastings_reg_en: hastings-reg-en-state {
>  &tlmm {
>  	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
>  
> +	bt_default: bt-default-state {
> +		hstp-sw-ctrl-pins {
> +			pins = "gpio132";
> +			function = "gpio";
> +			bias-pull-down;
> +		};

Similarly, this one should go after hstp-bt-en-pins.

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
> @@ -1213,6 +1263,34 @@ i2c4_default: i2c4-default-state {
>  		bias-disable;
>  	};
>  
> +	uart2_default: uart2-default-state {

And this one is also not ordered correctly.

> +	};
> +
>  	i2c21_default: i2c21-default-state {
>  		pins = "gpio81", "gpio82";
>  		function = "qup21";

Johan
