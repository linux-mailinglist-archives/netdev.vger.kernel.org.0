Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2830248B81
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgHRQZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726931AbgHRQYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 12:24:38 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85E9C061389;
        Tue, 18 Aug 2020 09:24:37 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a14so15738161edx.7;
        Tue, 18 Aug 2020 09:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ABFOP25vcfvo4LZNoyXDRVye0sT22qu+YFacCi1B39Q=;
        b=CG9yiwKn3liqDsNzpdCRwGkl4HE6WWUICx8UKbtOTakYd9Iaqvrsd42y6bZK1pqUXy
         GZNfBUysCXAFiarmFGDUkWbw2sf5DdUM+4MbFV0Z8BNfO+2i+TqBi6v/IFC8jIGfYp/q
         N5K9WHvT77zviPudmzqifQ+vsrG35Qi9nsuJoSdvQuIsGgMPRS0joTVoVpGUOirS7dgO
         BKc6Ll1QuKO/FX/LWzu/tjMK8JWF3Gh2ObkkBP8Zc/4BBD6afJKdDC+knjwu356PQS9v
         fQMeT+DsGcYfvWfPX8vHKxbGsxNUZNJAqj6POjpZLhpJybTVqjbpqG3yfgrNoaZmaplU
         IlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ABFOP25vcfvo4LZNoyXDRVye0sT22qu+YFacCi1B39Q=;
        b=oV3Sur9LxpQO7CJ/OFdQDP9mN28bGUsM3NE7LjTVSOKL8H6zyH/p+JlhG8Q+hZhdy9
         0F5c+W38vx9c16pRhDwQQpBFER6FJvOvnB0C2JdhWeThsE/zdB3WvMxs0oNvBcfX6AGQ
         7+H4Ax8vgLxF37UUCIs++Pv3VsMAirk0kFQFhrDexl0LNpRrosGdkG7Yc88c5jFVpFCV
         6OGvHjjKj/IcGlucuJgJwkM9TOIYzhAUAf6NUm2/GM+Q9lohOZ0eXC/9Zy5yvKzhf+tv
         H5av0kuLt3yJZ+BRl+Zl7ZhSzQJmp0PDYvP9yPWNmB8Fh8mJw/D2cji6EerGVZTxssrU
         EETQ==
X-Gm-Message-State: AOAM530F8r6M3J6njXpr36icpBJEFJmk1svyMzmUdKJMrZ93zBN0Gkp5
        XHQ8pF5fndcyF2xzpQ1e7A8=
X-Google-Smtp-Source: ABdhPJzldd7FWN+S/aRQ3C9ERX063zeUx9ZKsaVvZci3HYChB2hIMvVXEVj6gq43KyTwJwOPxJ/rwg==
X-Received: by 2002:aa7:c246:: with SMTP id y6mr21292821edo.78.1597767876264;
        Tue, 18 Aug 2020 09:24:36 -0700 (PDT)
Received: from skbuf ([86.126.22.216])
        by smtp.gmail.com with ESMTPSA id w18sm16697068ejf.37.2020.08.18.09.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 09:24:35 -0700 (PDT)
Date:   Tue, 18 Aug 2020 19:24:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@savoirfairelinux.com, matthias.bgg@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        frank-w@public-files.de, dqfext@gmail.com
Subject: Re: [PATCH net-next v2 7/7] arm64: dts: mt7622: add mt7531 dsa to
 bananapi-bpi-r64 board
Message-ID: <20200818162433.elqh3dxmk6vilq6u@skbuf>
References: <cover.1597729692.git.landen.chao@mediatek.com>
 <2a986604b49f7bfbee3898c8870bb0cf8182e879.1597729692.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a986604b49f7bfbee3898c8870bb0cf8182e879.1597729692.git.landen.chao@mediatek.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 03:14:12PM +0800, Landen Chao wrote:
> Add mt7531 dsa to bananapi-bpi-r64 board for 5 giga Ethernet ports support.
> 
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> ---
>  .../dts/mediatek/mt7622-bananapi-bpi-r64.dts  | 44 +++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
> index d174ad214857..c57b2571165f 100644
> --- a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
> +++ b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
> @@ -143,6 +143,50 @@
>  	mdio: mdio-bus {
>  		#address-cells = <1>;
>  		#size-cells = <0>;
> +
> +		switch@0 {
> +			compatible = "mediatek,mt7531";
> +			reg = <0>;
> +			reset-gpios = <&pio 54 0>;
> +
> +			ports {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				port@0 {
> +					reg = <0>;
> +					label = "wan";
> +				};
> +
> +				port@1 {
> +					reg = <1>;
> +					label = "lan0";
> +				};
> +
> +				port@2 {
> +					reg = <2>;
> +					label = "lan1";
> +				};
> +
> +				port@3 {
> +					reg = <3>;
> +					label = "lan2";
> +				};
> +
> +				port@4 {
> +					reg = <4>;
> +					label = "lan3";
> +				};
> +
> +				port@6 {
> +					reg = <6>;
> +					label = "cpu";
> +					ethernet = <&gmac0>;
> +					phy-mode = "2500base-x";
> +				};

Is there any reason why you're not specifying a fixed-link node here?

> +			};
> +		};
> +
>  	};
>  };
>  
> -- 
> 2.17.1

Thanks,
-Vladimir
