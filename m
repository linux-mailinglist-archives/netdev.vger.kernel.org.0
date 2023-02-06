Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA4668C861
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 22:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjBFVPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 16:15:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbjBFVPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 16:15:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C26D12855;
        Mon,  6 Feb 2023 13:15:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06E0DB8161D;
        Mon,  6 Feb 2023 21:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59CC4C433EF;
        Mon,  6 Feb 2023 21:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675718101;
        bh=Zhq6cVTt3n8+InQ7RYqBYg1fjFMtOoVV/gNHrgePxXg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hTSHEm0nu/OAsNocJefNNsobCR+E7mCmUe9rAgIctEitW3fJaF8ynQEXqxASrLi8a
         nLm/hGr0dc1/k53Ap/6pkyUec/pi/xrJTbceCMXB64PjjRvOfrZzpv+UC3/AXnRYwL
         Cjh+vCk88bB1dZq5HVGEHSZM8Y0OT8G8WpFqfoRn0kT3J3HcpcxhLmMnVZIoXk58Yb
         V059hporQxkHZ9orhBzLPSbdVZwYQ6NjjK8ifkwOnZr8/Ex6yC7nNBjY27WiaRgP/H
         f4xsGfGwH5j+fgqJj2698QmoP385ahxKnWKdlNedwX3v26zij1aZLM1JdCxwySbW3U
         hWChwpmRDUOSA==
Date:   Mon, 6 Feb 2023 13:17:15 -0800
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
        Mark Pearson <markpearson@lenovo.com>
Subject: Re: [RESEND PATCH v3 4/4] arm64: dts: qcom: thinkpad-x13s: Add
 bluetooth
Message-ID: <20230206211715.sp4kxqzql45m7bbc@ripper>
References: <20230206001634.2566-1-steev@kali.org>
 <20230206001634.2566-5-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206001634.2566-5-steev@kali.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 06:16:34PM -0600, Steev Klimaszewski wrote:
> ---

This marks the end of the commit message, as such your S-o-b is
"missing". Move it above the "---" line.


It's also recommended to include some body in your commit message.
Perhaps just "The ... has a WCN6855 Bluetooth controller on uart2, add
this".

> Changes since v2:

And keep the change log here.

>  - Remove dead code and add TODO comment
>  - Make dtbs_check happy with the pin definitions
> 
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> ---
>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 63 +++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> index f936b020a71d..d351411d3504 100644
> --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
> @@ -24,6 +24,8 @@ / {
>  	aliases {
>  		i2c4 = &i2c4;
>  		i2c21 = &i2c21;
> +		serial0 = &uart17;
> +		serial1 = &uart2;
>  	};
>  
>  	wcd938x: audio-codec {
> @@ -712,6 +714,27 @@ &qup0 {
>  	status = "okay";
>  };
>  
> +&uart2 {
> +	status = "okay";
> +
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&uart2_state>;
> +
> +	bluetooth {
> +		compatible = "qcom,wcn6855-bt";
> +
> +		/* TODO: define regulators */

You have the list of regulators in the driver, and there are people with
the schematics. You should be able to fill this list out.

Regards,
Bjorn

> +
> +		max-speed = <3200000>;
> +
> +		enable-gpios = <&tlmm 133 GPIO_ACTIVE_HIGH>;
> +		swctrl-gpios = <&tlmm 132 GPIO_ACTIVE_HIGH>;
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&bt_en>;
> +	};
> +};
> +
>  &qup1 {
>  	status = "okay";
>  };
> @@ -720,6 +743,12 @@ &qup2 {
>  	status = "okay";
>  };
>  
> +&uart17 {
> +	compatible = "qcom,geni-debug-uart";
> +
> +	status = "okay";
> +};
> +
>  &remoteproc_adsp {
>  	firmware-name = "qcom/sc8280xp/LENOVO/21BX/qcadsp8280.mbn";
>  
> @@ -980,6 +1009,19 @@ hastings_reg_en: hastings-reg-en-state {
>  &tlmm {
>  	gpio-reserved-ranges = <70 2>, <74 6>, <83 4>, <125 2>, <128 2>, <154 7>;
>  
> +	bt_en: bt-en-state {
> +		hstp-sw-ctrl-pins {
> +			pins = "gpio132";
> +			function = "gpio";
> +		};
> +
> +		hstp-bt-en-pins {
> +			pins = "gpio133";
> +			function = "gpio";
> +			drive-strength = <16>;
> +		};
> +	};
> +
>  	edp_reg_en: edp-reg-en-state {
>  		pins = "gpio25";
>  		function = "gpio";
> @@ -1001,6 +1043,27 @@ i2c4_default: i2c4-default-state {
>  		bias-disable;
>  	};
>  
> +	uart2_state: uart2-state {
> +		cts-pins {
> +			pins = "gpio122";
> +			function = "qup2";
> +			bias-disable;
> +		};
> +
> +		rts-tx-pins {
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
> -- 
> 2.39.0
> 
