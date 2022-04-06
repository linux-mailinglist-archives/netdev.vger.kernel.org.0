Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9BC4F5F32
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiDFN0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiDFNZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:25:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF84386A89;
        Tue,  5 Apr 2022 18:13:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67F2F61923;
        Wed,  6 Apr 2022 01:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D82AC385A1;
        Wed,  6 Apr 2022 01:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649207598;
        bh=XhrRwaJr766BJcr+zRvpxYXxBy6jna9TGrTSweXCY1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g8Oqp0wSAhnciHM0lfhuzwuROBlAV0QXRuF062IwHGhpgOFIKfLzrVHCccbzRkOin
         7R0C0T2xEWGUUREEo79Ws2luDtk97Bcv5Ix1hjIqwDgbv7+de+7BD6E+WqzDBDPNRe
         WLEMFqAz1mSdFu+lYXB/7w2enU5on5KfevctBaZCzti1J+5FSBMla8KL9U+coMTrDc
         PT9TDJs3mvxU1JWtZW7ZFa0n0gCUnxc2cb75v7MSxLS7xP52BBXPpbMrZorpTWBtNy
         bV7obvFWjwnCmzqkA00ARtjNoz8YawBqMbRpjx+OerzeqhQ4pFZPyamnWaUQCXhzGN
         Efl3Qn+Ia+nGA==
Date:   Wed, 6 Apr 2022 09:13:10 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Frieder Schrempf <frieder.schrempf@kontron.de>
Cc:     =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Tony Lindgren <tony@atomide.com>, kernel@pengutronix.de,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v5 9/9] arm64: dts: imx8mm-kontron: fix ethernet node name
Message-ID: <20220406011310.GC129381@dragon>
References: <20220216074927.3619425-1-o.rempel@pengutronix.de>
 <20220216074927.3619425-10-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216074927.3619425-10-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ Frieder Schrempf who is the board owner.

On Wed, Feb 16, 2022 at 08:49:27AM +0100, Oleksij Rempel wrote:
> The node name of Ethernet controller should be "ethernet" instead of
> "usbether" as required by Ethernet controller devicetree schema:
>  Documentation/devicetree/bindings/net/ethernet-controller.yaml
> 
> This patch can potentially affect boot loaders patching against full
> node path instead of using device aliases.

Frieder,

Are you okay with that?

Shawn

> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> index d40caf14ac4a..23be1ec538ba 100644
> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
> @@ -182,7 +182,7 @@ usb1@1 {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
>  
> -		usbnet: usbether@1 {
> +		usbnet: ethernet@1 {
>  			compatible = "usb424,ec00";
>  			reg = <1>;
>  			local-mac-address = [ 00 00 00 00 00 00 ];
> -- 
> 2.30.2
> 
