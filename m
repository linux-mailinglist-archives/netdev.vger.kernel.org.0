Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9285B0069
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiIGJ1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIGJ1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:27:32 -0400
X-Greylist: delayed 98 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Sep 2022 02:27:30 PDT
Received: from sibelius.xs4all.nl (80-61-163-207.fixed.kpn.net [80.61.163.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECB67FF90;
        Wed,  7 Sep 2022 02:27:30 -0700 (PDT)
Received: from localhost (bloch.sibelius.xs4all.nl [local])
        by bloch.sibelius.xs4all.nl (OpenSMTPD) with ESMTPA id b640ccba;
        Wed, 7 Sep 2022 11:27:25 +0200 (CEST)
Date:   Wed, 7 Sep 2022 11:27:25 +0200 (CEST)
From:   Mark Kettenis <mark.kettenis@xs4all.nl>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, alyssa@rosenzweig.io,
        asahi@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
        davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, marcan@marcan.st, kuba@kernel.org,
        kvalo@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, zajec5@gmail.com, robh+dt@kernel.org,
        SHA-cyfmac-dev-list@infineon.com, sven@svenpeter.dev
In-Reply-To: <E1oVpne-005LCR-RJ@rmk-PC.armlinux.org.uk>
        (rmk+kernel@armlinux.org.uk)
Subject: Re: [PATCH net-next 12/12] arm64: dts: apple: Add WiFi module and antenna
 properties
References: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk> <E1oVpne-005LCR-RJ@rmk-PC.armlinux.org.uk>
Message-ID: <d3ced546b81f9820@bloch.sibelius.xs4all.nl>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Date: Wed, 07 Sep 2022 08:48:42 +0100
> 
> From: Hector Martin <marcan@marcan.st>
> 
> Add the new module-instance/antenna-sku properties required to select
> WiFi firmwares properly to all board device trees.
> 
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Mark Kettenis <kettenis@openbsd.org>

> ---
>  arch/arm64/boot/dts/apple/t8103-j274.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-j293.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-j313.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-j456.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-j457.dts  | 4 ++++
>  arch/arm64/boot/dts/apple/t8103-jxxx.dtsi | 2 ++
>  6 files changed, 22 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/apple/t8103-j274.dts b/arch/arm64/boot/dts/apple/t8103-j274.dts
> index 2cd429efba5b..c1f3ba9c39f6 100644
> --- a/arch/arm64/boot/dts/apple/t8103-j274.dts
> +++ b/arch/arm64/boot/dts/apple/t8103-j274.dts
> @@ -21,6 +21,10 @@ aliases {
>  	};
>  };
>  
> +&wifi0 {
> +	brcm,board-type = "apple,atlantisb";
> +};
> +
>  /*
>   * Force the bus number assignments so that we can declare some of the
>   * on-board devices and properties that are populated by the bootloader
> diff --git a/arch/arm64/boot/dts/apple/t8103-j293.dts b/arch/arm64/boot/dts/apple/t8103-j293.dts
> index 49cdf4b560a3..ecb10d237a05 100644
> --- a/arch/arm64/boot/dts/apple/t8103-j293.dts
> +++ b/arch/arm64/boot/dts/apple/t8103-j293.dts
> @@ -17,6 +17,10 @@ / {
>  	model = "Apple MacBook Pro (13-inch, M1, 2020)";
>  };
>  
> +&wifi0 {
> +	brcm,board-type = "apple,honshu";
> +};
> +
>  /*
>   * Remove unused PCIe ports and disable the associated DARTs.
>   */
> diff --git a/arch/arm64/boot/dts/apple/t8103-j313.dts b/arch/arm64/boot/dts/apple/t8103-j313.dts
> index b0ebb45bdb6f..df741737b8e6 100644
> --- a/arch/arm64/boot/dts/apple/t8103-j313.dts
> +++ b/arch/arm64/boot/dts/apple/t8103-j313.dts
> @@ -17,6 +17,10 @@ / {
>  	model = "Apple MacBook Air (M1, 2020)";
>  };
>  
> +&wifi0 {
> +	brcm,board-type = "apple,shikoku";
> +};
> +
>  /*
>   * Remove unused PCIe ports and disable the associated DARTs.
>   */
> diff --git a/arch/arm64/boot/dts/apple/t8103-j456.dts b/arch/arm64/boot/dts/apple/t8103-j456.dts
> index 884fddf7d363..8c6bf9592510 100644
> --- a/arch/arm64/boot/dts/apple/t8103-j456.dts
> +++ b/arch/arm64/boot/dts/apple/t8103-j456.dts
> @@ -21,6 +21,10 @@ aliases {
>  	};
>  };
>  
> +&wifi0 {
> +	brcm,board-type = "apple,capri";
> +};
> +
>  &i2c0 {
>  	hpm2: usb-pd@3b {
>  		compatible = "apple,cd321x";
> diff --git a/arch/arm64/boot/dts/apple/t8103-j457.dts b/arch/arm64/boot/dts/apple/t8103-j457.dts
> index d7c622931627..fe7c0aaf7d62 100644
> --- a/arch/arm64/boot/dts/apple/t8103-j457.dts
> +++ b/arch/arm64/boot/dts/apple/t8103-j457.dts
> @@ -21,6 +21,10 @@ aliases {
>  	};
>  };
>  
> +&wifi0 {
> +	brcm,board-type = "apple,santorini";
> +};
> +
>  /*
>   * Force the bus number assignments so that we can declare some of the
>   * on-board devices and properties that are populated by the bootloader
> diff --git a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
> index fe2ae40fa9dd..3d15b8e2a6c1 100644
> --- a/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
> +++ b/arch/arm64/boot/dts/apple/t8103-jxxx.dtsi
> @@ -71,8 +71,10 @@ hpm1: usb-pd@3f {
>  &port00 {
>  	bus-range = <1 1>;
>  	wifi0: network@0,0 {
> +		compatible = "pci14e4,4425";
>  		reg = <0x10000 0x0 0x0 0x0 0x0>;
>  		/* To be filled by the loader */
>  		local-mac-address = [00 00 00 00 00 00];
> +		apple,antenna-sku = "XX";
>  	};
>  };
> -- 
> 2.30.2
> 
> 
> 
