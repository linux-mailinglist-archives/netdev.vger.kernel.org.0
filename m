Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8608D45828
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfFNJD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:03:56 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40631 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfFNJD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:03:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so1476461wmj.5
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 02:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HkiejmUNGhm2bVLw0vGSPMpXYSDdJqoN9JnhsnQuFxQ=;
        b=Ok0MD9LiIShUmZ0Nlrof/SCWkZbBDCqwUNS0XTMVJcKu8UVffQ5+eAsdrPEAfpV3q3
         W0LhhOKmbexgARnA9u5E91WPgdCHS9nlrSuqq4sy5ztLHkcBcMQpJS/sQtyY4sUBCmNb
         jj7lLh/eptxoIOy+wa/wG69XMavjNtgneqNXxpR9K2auYDXlvaW1z4VyBVI8rRFGpxB1
         w65+NPEe05+XscuBi71jmINpiAtK+KQL2d39iPOFo4nujiS4ikYtcUpzpcJ0A3IUhM/r
         +IjXn1SDr2O5yUMffTozovTesLim08S0/I7E9qwOfMJ7L77WTbEMAM5jaenSS6nOSA14
         PioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=HkiejmUNGhm2bVLw0vGSPMpXYSDdJqoN9JnhsnQuFxQ=;
        b=csNywefp/len4xFMYWuawP1Y76O6IlrhHzGo5g8hIjArF4tUI0f21sr+UubkvBb424
         YHrCKFfwBmxlBVdGjnstBOMwdaIaWtzl6UL96CtcF9RRk/NTpbTzAU+duVOlQSNvKnct
         bvxElaoIuIRfGB5TmyHY4kwPSP6ck9aB8X4lQ99yzlzg4fbN92FaZWq71HA335tUaj3b
         iZl/moPeKTXvWIQXVanmqXEs6D5/lFm22fQH8VewmMnlBfCJx5d8UsU3KOR19s2NAPb2
         sdmCCUZ48ePb6JmaTKzgaWrVMbr8LmtLVuCuDAAe5UcvNLAHw23iihDlUdqyu6c8adNL
         oi3Q==
X-Gm-Message-State: APjAAAU4O8Yd7CU55VDIKHSPs5bjpt0gxjZjCmIZ2TVpelv9t0dikaF9
        ZAild+c5bEmH2lIdH//oaiiofg==
X-Google-Smtp-Source: APXvYqwXV57Njhh43q5sotSiQAeUlliLJbkYLSO85YZ7R6naq4RynbidijaEwnpZFSecBSR/M3wWVA==
X-Received: by 2002:a1c:7d8e:: with SMTP id y136mr6274145wmc.16.1560503032260;
        Fri, 14 Jun 2019 02:03:52 -0700 (PDT)
Received: from [10.1.2.12] (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id x17sm2493890wrq.64.2019.06.14.02.03.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:03:51 -0700 (PDT)
Subject: Re: [PATCH v2 3/4] arm64: dts: meson: use the generic Ethernet PHY
 reset GPIO bindings
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        linux-arm-kernel@lists.infradead.org
References: <20190612205529.19834-1-martin.blumenstingl@googlemail.com>
 <20190612205529.19834-4-martin.blumenstingl@googlemail.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Openpgp: preference=signencrypt
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 ZaTUOEkgIor5losDrePdPgE=
Organization: Baylibre
Message-ID: <c0c8f87d-05d3-aa82-c54e-d250c52241b5@baylibre.com>
Date:   Fri, 14 Jun 2019 11:03:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612205529.19834-4-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/06/2019 22:55, Martin Blumenstingl wrote:
> The snps,reset-gpio bindings are deprecated in favour of the generic
> "Ethernet PHY reset" bindings.
> 
> Replace snps,reset-gpio from the &ethmac node with reset-gpios in the
> ethernet-phy node. The old snps,reset-active-low property is now encoded
> directly as GPIO flag inside the reset-gpios property.
> 
> snps,reset-delays-us is converted to reset-assert-us and
> reset-deassert-us. reset-assert-us is the second cell from
> snps,reset-delays-us while reset-deassert-us was the third cell.
> 
> Instead of blindly copying the old values (which seems strange since
> they gave the PHY one second to come out of reset) over this also
> updates the delays based on the datasheets:
> - the Realtek RTL8211F PHY needs a 10ms assert delay (the datasheet
>   mentions: "For a complete PHY reset, this pin must be asserted low
>   for at least 10ms") and a 30ms deassert delay (the datasheet
>   mentions: "Wait for a further 30ms (for internal circuits settling
>   time) before accessing the PHY register". This applies to the
>   following boards: GXBB NanoPi K2, GXBB Odroid-C2, GXBB Vega S95
>   variants, GXBB Wetek variants, GXL P230, GXM Khadas VIM2, GXM Nexbox
>   A1, GXM Q200, GXM RBox Pro boards.
> - the ICPlus IP101GR PHY needs a 10ms assert delay (the datasheet
>   mentions: "Trst | Reset period | 10ms") and a deassert delay of 10ms
>   as well (the datasheet mentions: "Tclk_MII_rdy | MII/RMII clock
>   output ready after reset released | 10ms"). This applies to the GXBB
>   Nexbox A95X board.
> - the Micrel KSZ9031 seems to require a 100us delay but use the same
>   (seemingly safe) values from RTL8211F due to lack of a board to verify
>   this. This applies to the GXBB P200 board.
> 
> The GXBB P201 board is left out from this conversion because it doesn't
> have a dedicated PHY node (because it's not clear which PHY is used on
> that board).
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts  |  9 +++++----
>  .../arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts |  8 ++++----
>  arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts   |  9 +++++----
>  arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts       |  9 +++++----
>  arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi  |  9 +++++----
>  arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi     |  8 ++++----
>  arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts  | 11 ++++++-----
>  arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts | 10 +++++-----
>  arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts   |  8 ++++----
>  arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts        | 11 ++++++-----
>  arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts    |  8 ++++----
>  11 files changed, 53 insertions(+), 47 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
> index 849c01650c4d..c34c1c90ccb6 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
> @@ -154,10 +154,6 @@
>  
>  	amlogic,tx-delay-ns = <2>;
>  
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	mdio {
>  		compatible = "snps,dwmac-mdio";
>  		#address-cells = <1>;
> @@ -166,6 +162,11 @@
>  		eth_phy0: ethernet-phy@0 {
>  			/* Realtek RTL8211F (0x001cc916) */
>  			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <30000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>  			interrupt-parent = <&gpio_intc>;
>  			/* MAC_INTR on GPIOZ_15 */
>  			interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts
> index 3c54f26eef15..b636912a2715 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dts
> @@ -162,10 +162,6 @@
>  	phy-handle = <&eth_phy0>;
>  	phy-mode = "rmii";
>  
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	mdio {
>  		compatible = "snps,dwmac-mdio";
>  		#address-cells = <1>;
> @@ -174,6 +170,10 @@
>  		eth_phy0: ethernet-phy@0 {
>  			/* IC Plus IP101GR (0x02430c54) */
>  			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <10000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
>  		};
>  	};
>  };
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
> index 5a139e7b1c60..9972b1515da6 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dts
> @@ -126,10 +126,6 @@
>  	phy-handle = <&eth_phy0>;
>  	phy-mode = "rgmii";
>  
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	amlogic,tx-delay-ns = <2>;
>  
>  	mdio {
> @@ -140,6 +136,11 @@
>  		eth_phy0: ethernet-phy@0 {
>  			/* Realtek RTL8211F (0x001cc916) */
>  			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <30000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>  			interrupt-parent = <&gpio_intc>;
>  			/* MAC_INTR on GPIOZ_15 */
>  			interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts
> index 9d2406a7c4fa..3c93d1898b40 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dts
> @@ -68,10 +68,6 @@
>  
>  	amlogic,tx-delay-ns = <2>;
>  
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	mdio {
>  		compatible = "snps,dwmac-mdio";
>  		#address-cells = <1>;
> @@ -80,6 +76,11 @@
>  		eth_phy0: ethernet-phy@3 {
>  			/* Micrel KSZ9031 (0x00221620) */
>  			reg = <3>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <30000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>  			interrupt-parent = <&gpio_intc>;
>  			/* MAC_INTR on GPIOZ_15 */
>  			interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
> index 18856f28fd60..43b11e3dfe11 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95.dtsi
> @@ -116,10 +116,6 @@
>  
>  	amlogic,tx-delay-ns = <2>;
>  
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	mdio {
>  		compatible = "snps,dwmac-mdio";
>  		#address-cells = <1>;
> @@ -128,6 +124,11 @@
>  		eth_phy0: ethernet-phy@0 {
>  			/* Realtek RTL8211F (0x001cc916) */
>  			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <30000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>  			interrupt-parent = <&gpio_intc>;
>  			/* MAC_INTR on GPIOZ_15 */
>  			interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
> index 9ef6858779c1..4c539881fbb7 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-wetek.dtsi
> @@ -137,10 +137,6 @@
>  
>  	amlogic,tx-delay-ns = <2>;
>  
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	mdio {
>  		compatible = "snps,dwmac-mdio";
>  		#address-cells = <1>;
> @@ -149,6 +145,10 @@
>  		eth_phy0: ethernet-phy@0 {
>  			/* Realtek RTL8211F (0x001cc916) */
>  			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <30000>;
> +			reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
>  		};
>  	};
>  };
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
> index 767b1763a612..b08c4537f260 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dts
> @@ -70,11 +70,6 @@
>  
>  	amlogic,tx-delay-ns = <2>;
>  
> -	/* External PHY reset is shared with internal PHY Led signals */
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	/* External PHY is in RGMII */
>  	phy-mode = "rgmii";
>  };
> @@ -84,6 +79,12 @@
>  		/* Realtek RTL8211F (0x001cc916) */
>  		reg = <0>;
>  		max-speed = <1000>;
> +
> +		/* External PHY reset is shared with internal PHY Led signal */
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <30000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>  		interrupt-parent = <&gpio_intc>;
>  		interrupts = <29 IRQ_TYPE_LEVEL_LOW>;
>  		eee-broken-1000t;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
> index ff4f0780824d..989d33ac6eae 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
> @@ -239,11 +239,6 @@
>  
>  	amlogic,tx-delay-ns = <2>;
>  
> -	/* External PHY reset is shared with internal PHY Led signals */
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	/* External PHY is in RGMII */
>  	phy-mode = "rgmii";
>  
> @@ -254,6 +249,11 @@
>  	external_phy: ethernet-phy@0 {
>  		/* Realtek RTL8211F (0x001cc916) */
>  		reg = <0>;
> +
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <30000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>  		interrupt-parent = <&gpio_intc>;
>  		/* MAC_INTR on GPIOZ_15 */
>  		interrupts = <25 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
> index 29715eae14a9..c2bd4dbbf38c 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dts
> @@ -101,10 +101,6 @@
>  
>  	amlogic,tx-delay-ns = <2>;
>  
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	/* External PHY is in RGMII */
>  	phy-mode = "rgmii";
>  };
> @@ -114,6 +110,10 @@
>  		/* Realtek RTL8211F (0x001cc916) */
>  		reg = <0>;
>  		max-speed = <1000>;
> +
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <30000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
>  	};
>  };
>  
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
> index 8939c0fc5b62..ea45ae0c71b7 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxm-q200.dts
> @@ -52,11 +52,6 @@
>  
>  	amlogic,tx-delay-ns = <2>;
>  
> -	/* External PHY reset is shared with internal PHY Led signals */
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	/* External PHY is in RGMII */
>  	phy-mode = "rgmii";
>  };
> @@ -66,6 +61,12 @@
>  		/* Realtek RTL8211F (0x001cc916) */
>  		reg = <0>;
>  		max-speed = <1000>;
> +
> +		/* External PHY reset is shared with internal PHY Led signal */
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <30000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
> +
>  		interrupt-parent = <&gpio_intc>;
>  		/* MAC_INTR on GPIOZ_15 */
>  		interrupts = <25 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
> index 13de1e8f58b5..5cd4d35006d0 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dts
> @@ -101,10 +101,6 @@
>  	/* Select external PHY by default */
>  	phy-handle = <&external_phy>;
>  
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	amlogic,tx-delay-ns = <2>;
>  
>  	/* External PHY is in RGMII */
> @@ -116,6 +112,10 @@
>  		/* Realtek RTL8211F (0x001cc916) */
>  		reg = <0>;
>  		max-speed = <1000>;
> +
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <30000>;
> +		reset-gpios = <&gpio GPIOZ_14 GPIO_ACTIVE_LOW>;
>  	};
>  };
>  
> 

Finally... !

This will break u-boot, but it's u-boot's fault not handling the mdio bus !

Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
