Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC72596C48
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiHQJrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiHQJrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:47:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13AD6B161;
        Wed, 17 Aug 2022 02:47:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F399B81BAB;
        Wed, 17 Aug 2022 09:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BF1C433D7;
        Wed, 17 Aug 2022 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660729636;
        bh=Qcruij7g38NyR2lHzkGqFZ8XU8XPZecu7Higao6ZkKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDSDvSPOpWDQ0dJ0qNKhdgc29+ejPMevlBuXxi4pal5VBqNzkzGygWNAWZ6PSIQBi
         NGRY/+Hg3BxKPrHBoIu7lyWzA3iJyQtjaq1+p0pkzr7QD+5ucwPvSqY3xP3b7z1rzl
         Ufq5FrRwEV4s1+chv28Er16uLSIIl/YYzFSwi4VJWsXkE1GJPP6qKN/iLyg3pLEtRP
         6ToyiBs2JNB/QkfQ8/a9WXcrpqmSaLhVj5/eeFYjgWd2t+4zZUahPWkSG+rl4nJMv+
         6Wa34mfh2rIvPSxy8LAxblKCHUvQT2lsTHiX9KaB+37clhVu/R5ksJ2XlRjvhtFmZ0
         3hemODx1pPL8w==
Date:   Wed, 17 Aug 2022 17:47:08 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: Re: [PATCH V4 2/3] arm64: dts: imx8ulp: Add the fec support
Message-ID: <20220817094708.GC149610@dragon>
References: <20220726143853.23709-1-wei.fang@nxp.com>
 <20220726143853.23709-3-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726143853.23709-3-wei.fang@nxp.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 12:38:52AM +1000, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Add the fec support on i.MX8ULP platforms.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> V2 change:
> Remove the external clocks which is related to specific board.
> V3 change:
> No change.
> V4 Change:
> Add Reviewed-by tag.
> ---
>  arch/arm64/boot/dts/freescale/imx8ulp.dtsi | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
> index 60c1b018bf03..3e8a1e4f0fc2 100644
> --- a/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
> +++ b/arch/arm64/boot/dts/freescale/imx8ulp.dtsi
> @@ -16,6 +16,7 @@ / {
>  	#size-cells = <2>;
>  
>  	aliases {
> +		ethernet0 = &fec;
>  		gpio0 = &gpiod;
>  		gpio1 = &gpioe;
>  		gpio2 = &gpiof;
> @@ -365,6 +366,16 @@ usdhc2: mmc@298f0000 {
>  				bus-width = <4>;
>  				status = "disabled";
>  			};
> +
> +			fec: ethernet@29950000 {
> +				compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec", "fsl,imx6q-fec";

Since imx8ulp-fec is compatible with imx6ul-fec, what's the point of
having imx6q-fec in there?  It can be dropped, I guess?

Shawn

> +				reg = <0x29950000 0x10000>;
> +				interrupts = <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>;
> +				interrupt-names = "int0";
> +				fsl,num-tx-queues = <1>;
> +				fsl,num-rx-queues = <1>;
> +				status = "disabled";
> +			};
>  		};
>  
>  		gpioe: gpio@2d000080 {
> -- 
> 2.25.1
> 
