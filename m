Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 250A151FAA0
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiEIK7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiEIK7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:59:38 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAE221FC2EA;
        Mon,  9 May 2022 03:55:39 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23B421480;
        Mon,  9 May 2022 03:55:39 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35BCB3F66F;
        Mon,  9 May 2022 03:55:36 -0700 (PDT)
Date:   Mon, 9 May 2022 11:55:33 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     alexandre.torgue@foss.st.com, andrew@lunn.ch, broonie@kernel.org,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, joabreu@synopsys.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        lgirdwood@gmail.com, linux@armlinux.org.uk, pabeni@redhat.com,
        peppe.cavallaro@st.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev
Subject: Re: [PATCH 4/6] ARM: dts: sunxi: move phy regulator in PHY node
Message-ID: <20220509115533.1493db30@donnerap.cambridge.arm.com>
In-Reply-To: <20220509074857.195302-5-clabbe@baylibre.com>
References: <20220509074857.195302-1-clabbe@baylibre.com>
        <20220509074857.195302-5-clabbe@baylibre.com>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 May 2022 07:48:55 +0000
Corentin Labbe <clabbe@baylibre.com> wrote:

Hi!

> Now that PHY core can handle regulators, move regulator handle in PHY
> node.

Other than this is somewhat more "correct", is it really needed for those
boards? Because it breaks compatibility with older kernels, so when we
update the DTs in U-Boot, we run into problems (again).

IIUC this series is about the OPi3 & friends, which didn't work with older
kernels anyway, so can we just skip this patch (and 5/6), to just enable
the boards that didn't work before?

Cheers,
Andre

> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts      | 2 +-
>  arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts  | 2 +-
>  arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts     | 2 +-
>  arch/arm/boot/dts/sun8i-h3-nanopi-r1.dts          | 2 +-
>  arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts      | 2 +-
>  arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts    | 2 +-
>  arch/arm/boot/dts/sun8i-h3-zeropi.dts             | 2 +-
>  arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts | 2 +-
>  arch/arm/boot/dts/sun8i-r40-oka40i-c.dts          | 2 +-
>  arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts | 2 +-
>  arch/arm/boot/dts/sun9i-a80-cubieboard4.dts       | 2 +-
>  arch/arm/boot/dts/sun9i-a80-optimus.dts           | 2 +-
>  arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi     | 2 +-
>  13 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
> index 5a7e1bd5f825..b450be0a45ed 100644
> --- a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
> +++ b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
> @@ -129,7 +129,6 @@ &ehci0 {
>  &emac {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&emac_rgmii_pins>;
> -	phy-supply = <&reg_sw>;
>  	phy-handle = <&rgmii_phy>;
>  	phy-mode = "rgmii-id";
>  	allwinner,rx-delay-ps = <700>;
> @@ -151,6 +150,7 @@ &mdio {
>  	rgmii_phy: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <1>;
> +		phy-supply = <&reg_sw>;
>  	};
>  };
>  
> diff --git a/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts b/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
> index 870993393fc2..fe70b350cdbb 100644
> --- a/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
> +++ b/arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts
> @@ -181,7 +181,6 @@ &ehci1 {
>  &emac {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&emac_rgmii_pins>;
> -	phy-supply = <&reg_dldo4>;
>  	phy-handle = <&rgmii_phy>;
>  	phy-mode = "rgmii-id";
>  	status = "okay";
> @@ -201,6 +200,7 @@ &mdio {
>  	rgmii_phy: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <1>;
> +		phy-supply = <&reg_dldo4>;
>  	};
>  };
>  
> diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
> index a2f2ef2b0092..c393612f44c6 100644
> --- a/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
> +++ b/arch/arm/boot/dts/sun8i-h3-nanopi-m1-plus.dts
> @@ -103,7 +103,6 @@ &ehci2 {
>  &emac {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&emac_rgmii_pins>;
> -	phy-supply = <&reg_gmac_3v3>;
>  	phy-handle = <&ext_rgmii_phy>;
>  	phy-mode = "rgmii";
>  
> @@ -114,6 +113,7 @@ &external_mdio {
>  	ext_rgmii_phy: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <7>;
> +		phy-supply = <&reg_gmac_3v3>;
>  	};
>  };
>  
> diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-r1.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-r1.dts
> index 26e2e6172e0d..70bde396856b 100644
> --- a/arch/arm/boot/dts/sun8i-h3-nanopi-r1.dts
> +++ b/arch/arm/boot/dts/sun8i-h3-nanopi-r1.dts
> @@ -80,7 +80,6 @@ &ehci2 {
>  &emac {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&emac_rgmii_pins>;
> -	phy-supply = <&reg_gmac_3v3>;
>  	phy-handle = <&ext_rgmii_phy>;
>  	phy-mode = "rgmii-id";
>  	status = "okay";
> @@ -90,6 +89,7 @@ &external_mdio {
>  	ext_rgmii_phy: ethernet-phy@7 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <7>;
> +		phy-supply = <&reg_gmac_3v3>;
>  	};
>  };
>  
> diff --git a/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts b/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts
> index d05fa679dcd3..c6dcf1af3298 100644
> --- a/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts
> +++ b/arch/arm/boot/dts/sun8i-h3-orangepi-plus.dts
> @@ -83,7 +83,6 @@ &ehci3 {
>  &emac {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&emac_rgmii_pins>;
> -	phy-supply = <&reg_gmac_3v3>;
>  	phy-handle = <&ext_rgmii_phy>;
>  	phy-mode = "rgmii-id";
>  
> @@ -94,6 +93,7 @@ &external_mdio {
>  	ext_rgmii_phy: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <0>;
> +		phy-supply = <&reg_gmac_3v3>;
>  	};
>  };
>  
> diff --git a/arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts b/arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts
> index b6ca45d18e51..61eb8c003186 100644
> --- a/arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts
> +++ b/arch/arm/boot/dts/sun8i-h3-orangepi-plus2e.dts
> @@ -65,7 +65,6 @@ reg_gmac_3v3: gmac-3v3 {
>  &emac {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&emac_rgmii_pins>;
> -	phy-supply = <&reg_gmac_3v3>;
>  	phy-handle = <&ext_rgmii_phy>;
>  	phy-mode = "rgmii-id";
>  	status = "okay";
> @@ -75,5 +74,6 @@ &external_mdio {
>  	ext_rgmii_phy: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <1>;
> +		phy-supply = <&reg_gmac_3v3>;
>  	};
>  };
> diff --git a/arch/arm/boot/dts/sun8i-h3-zeropi.dts b/arch/arm/boot/dts/sun8i-h3-zeropi.dts
> index 7d3e7323b661..54174ef18823 100644
> --- a/arch/arm/boot/dts/sun8i-h3-zeropi.dts
> +++ b/arch/arm/boot/dts/sun8i-h3-zeropi.dts
> @@ -65,13 +65,13 @@ &external_mdio {
>  	ext_rgmii_phy: ethernet-phy@7 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <7>;
> +		phy-supply = <&reg_gmac_3v3>;
>  	};
>  };
>  
>  &emac {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&emac_rgmii_pins>;
> -	phy-supply = <&reg_gmac_3v3>;
>  	phy-handle = <&ext_rgmii_phy>;
>  	phy-mode = "rgmii-id";
>  
> diff --git a/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts b/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
> index a6a1087a0c9b..b1f269bbd479 100644
> --- a/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
> +++ b/arch/arm/boot/dts/sun8i-r40-bananapi-m2-ultra.dts
> @@ -130,7 +130,6 @@ &gmac {
>  	pinctrl-0 = <&gmac_rgmii_pins>;
>  	phy-handle = <&phy1>;
>  	phy-mode = "rgmii-id";
> -	phy-supply = <&reg_dc1sw>;
>  	status = "okay";
>  };
>  
> @@ -138,6 +137,7 @@ &gmac_mdio {
>  	phy1: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <1>;
> +		phy-supply = <&reg_dc1sw>;
>  	};
>  };
>  
> diff --git a/arch/arm/boot/dts/sun8i-r40-oka40i-c.dts b/arch/arm/boot/dts/sun8i-r40-oka40i-c.dts
> index 0bd1336206b8..c43476b426df 100644
> --- a/arch/arm/boot/dts/sun8i-r40-oka40i-c.dts
> +++ b/arch/arm/boot/dts/sun8i-r40-oka40i-c.dts
> @@ -93,7 +93,6 @@ &gmac {
>  	pinctrl-0 = <&gmac_rgmii_pins>;
>  	phy-handle = <&phy1>;
>  	phy-mode = "rgmii-id";
> -	phy-supply = <&reg_dcdc1>;
>  	status = "okay";
>  };
>  
> @@ -101,6 +100,7 @@ &gmac_mdio {
>  	phy1: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <1>;
> +		phy-supply = <&reg_dcdc1>;
>  	};
>  };
>  
> diff --git a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
> index 47954551f573..050a649d7bda 100644
> --- a/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
> +++ b/arch/arm/boot/dts/sun8i-v40-bananapi-m2-berry.dts
> @@ -121,7 +121,6 @@ &gmac {
>  	pinctrl-0 = <&gmac_rgmii_pins>;
>  	phy-handle = <&phy1>;
>  	phy-mode = "rgmii-id";
> -	phy-supply = <&reg_dc1sw>;
>  	status = "okay";
>  };
>  
> @@ -129,6 +128,7 @@ &gmac_mdio {
>  	phy1: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <1>;
> +		phy-supply = <&reg_dc1sw>;
>  	};
>  };
>  
> diff --git a/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts b/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
> index c8ca8cb7f5c9..ab9bf4bf7343 100644
> --- a/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
> +++ b/arch/arm/boot/dts/sun9i-a80-cubieboard4.dts
> @@ -130,7 +130,6 @@ &gmac {
>  	pinctrl-0 = <&gmac_rgmii_pins>;
>  	phy-handle = <&phy1>;
>  	phy-mode = "rgmii-id";
> -	phy-supply = <&reg_cldo1>;
>  	status = "okay";
>  };
>  
> @@ -142,6 +141,7 @@ &i2c3 {
>  
>  &mdio {
>  	phy1: ethernet-phy@1 {
> +		phy-supply = <&reg_cldo1>;
>  		reg = <1>;
>  	};
>  };
> diff --git a/arch/arm/boot/dts/sun9i-a80-optimus.dts b/arch/arm/boot/dts/sun9i-a80-optimus.dts
> index 5c3580d712e4..48219b8049b1 100644
> --- a/arch/arm/boot/dts/sun9i-a80-optimus.dts
> +++ b/arch/arm/boot/dts/sun9i-a80-optimus.dts
> @@ -125,13 +125,13 @@ &gmac {
>  	pinctrl-0 = <&gmac_rgmii_pins>;
>  	phy-handle = <&phy1>;
>  	phy-mode = "rgmii-id";
> -	phy-supply = <&reg_cldo1>;
>  	status = "okay";
>  };
>  
>  &mdio {
>  	phy1: ethernet-phy@1 {
>  		reg = <1>;
> +		phy-supply = <&reg_cldo1>;
>  	};
>  };
>  
> diff --git a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
> index d03f5853ef7b..65f0a3c2af3f 100644
> --- a/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
> +++ b/arch/arm/boot/dts/sunxi-bananapi-m2-plus.dtsi
> @@ -125,7 +125,6 @@ &ehci2 {
>  &emac {
>  	pinctrl-names = "default";
>  	pinctrl-0 = <&emac_rgmii_pins>;
> -	phy-supply = <&reg_gmac_3v3>;
>  	phy-handle = <&ext_rgmii_phy>;
>  	phy-mode = "rgmii-id";
>  
> @@ -136,6 +135,7 @@ &external_mdio {
>  	ext_rgmii_phy: ethernet-phy@1 {
>  		compatible = "ethernet-phy-ieee802.3-c22";
>  		reg = <1>;
> +		phy-supply = <&reg_gmac_3v3>;
>  	};
>  };
>  

