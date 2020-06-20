Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9912021BB
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 07:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgFTFrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 01:47:43 -0400
Received: from mout.gmx.net ([212.227.17.20]:50937 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725290AbgFTFrl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jun 2020 01:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1592632040;
        bh=28IprndcsnIq5y/XDbuX5gDfHk0D4kU7qnN7Nd5NAP4=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=irnDILQB1TThfNu9oXRO/KvGLafOHe63IWEBCLBlKHpzuizzw4U7JSxXpMeKn/rNz
         SCm8S72F64yNM/xxXOXbRHNh+C6T2FxZnIuHSPjqkF29F4lTQSiCkWpuyBYNSwBdr6
         bokBlYWGnETM/UNCm26JDoUX3k8Ksx/UlNtiFfik=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.55] ([95.90.191.74]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N95eJ-1iqPqZ1HVv-01661q; Sat, 20
 Jun 2020 07:47:20 +0200
Subject: Re: [PATCH/RFC 1/5] dt-bindings: net: renesas,ravb: Document internal
 clock delay properties
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20200619191554.24942-1-geert+renesas@glider.be>
 <20200619191554.24942-2-geert+renesas@glider.be>
From:   Oleksij Rempel <linux@rempel-privat.de>
Autocrypt: addr=linux@rempel-privat.de; prefer-encrypt=mutual; keydata=
 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
 Rmpernzn0GXR0xYSTiUvuvpLsoo=
Message-ID: <e6d0bfc5-9d75-2dc9-2bfa-671c32cb0b7c@rempel-privat.de>
Date:   Sat, 20 Jun 2020 07:47:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619191554.24942-2-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gZneUWp1PvM8N00B9TNBuBkcIFQQiq9CbR23S8Ovu+sgLEwGxP9
 fzHfRBiBsK6ZKp6AvSncArwSfLdS9uH1qj5+uD+cfrm9xpaX5ZbRzO14eyVIztEcVcgJm1m
 a01vylivpWRFyc8QO//9hPQdolo2WEpQs2TaiQai1H+Lv2Min+NYMw9/SHvnyjLq5wFFqjN
 jsx9yIWhUKGa6ewCmuh/w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:krpWdAL8DYE=:6ZebNigtlCnlJRPJr0Zhb1
 efuGgT0QYxVFw/Q9quSoMwX+QgiVAHFw7unjGzYTcWS/Xojf+qTMzfeJlky0BJqE+w8iyYtlU
 n1xNVKBxC5m7ZJyJm6kM41ynte7qeMU6VAENPafEFBwNH8cNYmJRzZc/yKQ9aXiTdxdZZPP4Z
 mvxH/5ie4wU4jD12KwbqEC82ODKu4GgmtpZuwHUQs0gOC+bNmDqJwULG012qVBzYoQ2Z0aoXr
 NaJNF9DmH0ePctZhx13Xp3N+GtfnMzJIMaJ3kpwzHIV76tDKwlLGEqJxx5TwMTp+rwL8yvjJw
 01UhRNEZzfCc289Et3WcSTK9hIPaBwfvKGVnHaCK3PkKRjTY3BVEFpjYzMsdaqXMGjJlZpNh/
 yiPntPK1FlCB9WxEfb5AFELWpYgWz+BDkn+hMCbEX2Q6/MWb9wX/Ek1ymgFaJdqKyTp6c4AJk
 8PMX0V49lltNTyXeCyFYOwu0EpBhscfC/hikEqDFIHGlvxp907wg2RWtOZECfhXXIll+I1DXR
 hZ2ovkqM3cAHzS0dFXg82WK9Gk6Z3+X/PtNX9TDAd1gnOzaKoADd20OVMK1niuj+r9RnQGzLM
 WL2raLh4FClkjWFZxb8ukc2wcM+vwNk0BxfPu69cgSQHvmwsCsZ7hA3cE4vBoxoqQHn0tV18G
 HU7MA6vZnvfMSUFW0QOKnTKVNjNYc+Re0YAIAep0b2N/Dzphy3907X38ztMwAVOKvqBePeL70
 4jjA6PaYagVGqkijH171GfBaOYo5v3yVEdob6mjTrh1VTbQwo1A0hVNEccYWZwDPGLuBOITW4
 wBKLrdhgpa28OLAjfTfjDAnr90Fk10rN+uO0xey+XZ7EVBFWZZHXPxhZdg2Ymk7i9Qfw+k10E
 rJlvgzABPAF8BWEQvT3eCiKlAM663MXnIMr+beemdvC+oBZdDFUfURhV1GZpYWWwykMiHCAjb
 xj0xfbhkIXh8zVGm2SXq8ISlv2TrkO2fxoxF3090hUXZp2eNMhgTiNrBtgfNzJJ+YXRKMeL1J
 X6EjGtd/0VXQ3Yll1J59dm6khvloGQ7B24zUfagD5r9Xp5x3GPRC7yRTihiei6Ne9Kk0IV0Ap
 0qWUXCXf441K6X7q8onk2fmWD+H6wFc6Yr+osb957eXQi5qQSuAcP8aU53hijGqc+py78//MH
 Jg74xBKodwhg8odzaHp461P6tctjjw8TwaU/RKRrcBcuTBCL3iJmQEw8ptl6Ucz8wVI3NEqe6
 G3wqoFbKptn5e01nv
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Am 19.06.20 um 21:15 schrieb Geert Uytterhoeven:
> Some EtherAVB variants support internal clock delay configuration, which
> can add larger delays than the delays that are typically supported by
> the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
> properties).
>
> Add properties for configuring the internal MAC delays.
> These properties are mandatory, even when specified as zero, to
> distinguish between old and new DTBs.
>
> Update the example accordingly.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  .../devicetree/bindings/net/renesas,ravb.txt  | 29 ++++++++++---------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/net/renesas,ravb.txt b/Do=
cumentation/devicetree/bindings/net/renesas,ravb.txt
> index 032b76f14f4fdb38..488ada78b6169b8e 100644
> --- a/Documentation/devicetree/bindings/net/renesas,ravb.txt
> +++ b/Documentation/devicetree/bindings/net/renesas,ravb.txt
> @@ -64,6 +64,18 @@ Optional properties:
>  			 AVB_LINK signal.
>  - renesas,ether-link-active-low: boolean, specify when the AVB_LINK sig=
nal is
>  				 active-low instead of normal active-high.
> +- renesas,rxc-delay-ps: Internal RX clock delay.

may be it make sense to add a generic delay property for MACs and PHYs?

> +			This property is mandatory and valid only on R-Car Gen3
> +			and RZ/G2 SoCs.
> +			Valid values are 0 and 1800.
> +			A non-zero value is allowed only if phy-mode =3D "rgmii".
> +			Zero is not supported on R-Car D3.
> +- renesas,txc-delay-ps: Internal TX clock delay.
> +			This property is mandatory and valid only on R-Car H3,
> +			M3-W, M3-W+, M3-N, V3M, and V3H, and RZ/G2M and RZ/G2N.
> +			Valid values are 0 and 2000.

In the driver i didn't found sanity check for valid values.

> +			A non-zero value is allowed only if phy-mode =3D "rgmii".
> +			Zero is not supported on R-Car V3H.>  Example:
>
> @@ -105,8 +117,10 @@ Example:
>  				  "ch24";
>  		clocks =3D <&cpg CPG_MOD 812>;
>  		power-domains =3D <&cpg>;
> -		phy-mode =3D "rgmii-id";
> +		phy-mode =3D "rgmii";
>  		phy-handle =3D <&phy0>;
> +		renesas,rxc-delay-ps =3D <0>;
> +		renesas,txc-delay-ps =3D <2000>;
>
>  		pinctrl-0 =3D <&ether_pins>;
>  		pinctrl-names =3D "default";
> @@ -115,18 +129,7 @@ Example:
>  		#size-cells =3D <0>;
>
>  		phy0: ethernet-phy@0 {
> -			rxc-skew-ps =3D <900>;
> -			rxdv-skew-ps =3D <0>;
> -			rxd0-skew-ps =3D <0>;
> -			rxd1-skew-ps =3D <0>;
> -			rxd2-skew-ps =3D <0>;
> -			rxd3-skew-ps =3D <0>;
> -			txc-skew-ps =3D <900>;
> -			txen-skew-ps =3D <0>;
> -			txd0-skew-ps =3D <0>;
> -			txd1-skew-ps =3D <0>;
> -			txd2-skew-ps =3D <0>;
> -			txd3-skew-ps =3D <0>;
> +			rxc-skew-ps =3D <1500>;


I'm curios, how this numbers ware taken?
Old configurations was:
TX delay:
(txd*-skew-ps =3D 0) =3D=3D -420ns
(txc-skew-ps =3D 900) =3D=3D 0ns
resulting delays 0.420ns

RX delay:
(rxd*-skew-ps =3D 0) =3D=3D -420ns
(rxc-skew-ps =3D 900) =3D=3D 0ns
internal delay 1.2 + 420ns will be 1.62ns

I was not able to find actual delay values provided by the MAC. But from y=
our patches it looks like 2ns.

So, end result will be:
TXID =3D 2.4ns
RXID =3D 3.62ns

Both values seems to be a bit out of spec. New values are:
TXID =3D PHY 0ns + MAC 2.0ns
RXID =3D
(rxd*-skew-ps =3D no change) =3D=3D 0ns
(rxc-skew-ps =3D 1500) =3D=3D +600ns
internal delay 1.2 + 600ns =3D 1.8ns

=46rom the PHY point of view, it is RGMII_RXID mode. Are you sure, RGMII_I=
D is not working for you?
Till now the numbers was not looking as a fine tuning.
I assume, it is better to use proper phy-mode instead of skew-ps values. I=
 feel like no one had time
to understand real configured values in this PHY.

>  			reg =3D <0>;
>  			interrupt-parent =3D <&gpio2>;
>  			interrupts =3D <11 IRQ_TYPE_LEVEL_LOW>;
>


=2D-
Regards,
Oleksij
