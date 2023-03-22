Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E702A6C4072
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 03:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCVCiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 22:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCVCh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 22:37:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B7059436;
        Tue, 21 Mar 2023 19:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B51D461F25;
        Wed, 22 Mar 2023 02:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62DDC433EF;
        Wed, 22 Mar 2023 02:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679452671;
        bh=ahMSQCrkvdtTzmw3vLAN58JOl0U83Mm+lJR6IhMp+pY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MnnyXCLlmTGLJb511gFy7XMUwbkT8RPYP3iaZ5+i+qV2cl2AiULWTUZHu/f9JuHBA
         zVX0koAWRxjsQggOkbpjK6iOrP05QAOR+uOhXgrqOTucdYja/1wYYBNDxPP7HhTjAC
         ErltnuvPPketKfZoed+UixkwMfFqXZUynFQM9cCg85R28OkMoeQOcmlemJNOCDqX4a
         Sr7+hVU+zE1r5tfgmgLddo/db1AMbqamnNnxKnPttMMQacRmjk8Hg3J0du5bdAzwi0
         Pb0gNa5R1NL2B4GuLBMkOqUvHVVO6n1+2S+CmRk79ATw8+CT7YWL+Gswvq9e538lmx
         4IPIntVLXG7eg==
Date:   Tue, 21 Mar 2023 19:41:03 -0700
From:   Bjorn Andersson <andersson@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v7 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Message-ID: <20230322024103.fxht7qgaan4m2z5b@ripper>
References: <20230322011442.34475-1-steev@kali.org>
 <20230322011442.34475-5-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322011442.34475-5-steev@kali.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
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

Reviewed-by: Bjorn Andersson <andersson@kernel.org>

Regards,
Bjorn

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
> +
>  		vreg_l1c: ldo1 {
>  			regulator-name = "vreg_l1c";
>  			regulator-min-microvolt = <1800000>;
> @@ -918,6 +927,32 @@ &qup0 {
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
> +		cts-pins {
> +			pins = "gpio121";
> +			function = "qup2";
> +			bias-bus-hold;
> +		};
> +
> +		rts-pins {
> +			pins = "gpio122";
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
> +
> +		tx-pins {
> +			pins = "gpio123";
> +			function = "qup2";
> +			drive-strength = <2>;
> +			bias-disable;
> +		};
> +	};
> +
>  	i2c21_default: i2c21-default-state {
>  		pins = "gpio81", "gpio82";
>  		function = "qup21";
> -- 
> 2.39.2
> 
