Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 780EA45820
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfFNJCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:02:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46550 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfFNJCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:02:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id n4so1624357wrw.13
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 02:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=X6bR96hEQzF4ai4nZZIa7UXlVHw7ftUesKTa06YEbKg=;
        b=QhU8BLqzE3qtjEJQ9Me6KwEktwcRUuHGz7oAJRXSJFUYnceDMUsyOaj1I2YEFBRxjB
         yhIoSl4td2lGr78VSD/19nJlykKeeu8QOrehrVDTIxZb7scACQm3DEcrebtXWkceeoVz
         lWs5IslAZ+xc2734HCIon9bLLP0HWu6xhoFvKs08lbFXeeQuVcqq4bk5oHow+NL8oE31
         d2jdoVzDEvU71yTxVZS183sYssmf+iBURO+k0MBIN316INNWT84XlyfW0AKldWmqpsmA
         /w9W9OAkBOdWuJjc0VyU39rF/ZGqBTBsiSQMI/3Af+SFeiWFhnR5e0bgDMBdqbYdHzPc
         gYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=X6bR96hEQzF4ai4nZZIa7UXlVHw7ftUesKTa06YEbKg=;
        b=AVlSXuMAFQvwW5rnMTr+D6y4j2jhlT1x4PDLztW4SyTh9jub5mIRzTyAaBuzUHQeMT
         H/LBxG5bV/P06pah6LZbnS//Z116KXalHMTQXdCSbAQdmwNZGeEUecAz1uLkpAm3oqVP
         IiEFPgYrQmO1tfIS9EdryCDfRdofemKYfBmOkeCGRLBh9QqOQ+CmWZGHdifBhfhAMGGR
         kTvVHEQjXk6EjWgzfl2pT/5UK8jwEcYuvmakhkUWM28oN5Jl6BVWdqn47jkFA3fakHte
         LikImR+LMSsaxd7fRAP2K2uEVGo5HggODYcuCiEsJtjwqJ8GmGsbWHsUNMjOK6JWJy7T
         cnWA==
X-Gm-Message-State: APjAAAVdEzKk9KvVLZj3v9I8lfYWEwMkS6ZBfYjaiA51daTqogZEt23o
        fx6/l9M+M5nmIGbHSNOMcTPbcduMJ2Hs2A==
X-Google-Smtp-Source: APXvYqwCBb36DBL4D68VjMid5DfoDqMrzS1DxJuTsA8K0dbmYvA4kAH6i5lxYdw7MkRAEkmNWFLT3Q==
X-Received: by 2002:adf:8367:: with SMTP id 94mr13274057wrd.179.1560502970674;
        Fri, 14 Jun 2019 02:02:50 -0700 (PDT)
Received: from [10.1.2.12] (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id l1sm2320923wmg.13.2019.06.14.02.02.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:02:50 -0700 (PDT)
Subject: Re: [PATCH v2 2/4] ARM: dts: meson: switch to the generic Ethernet
 PHY reset bindings
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        linux-arm-kernel@lists.infradead.org
References: <20190612205529.19834-1-martin.blumenstingl@googlemail.com>
 <20190612205529.19834-3-martin.blumenstingl@googlemail.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Openpgp: preference=signencrypt
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 ZaTUOEkgIor5losDrePdPgE=
Organization: Baylibre
Message-ID: <cd35d212-ed30-d0f5-5da1-3b16fc814a28@baylibre.com>
Date:   Fri, 14 Jun 2019 11:02:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612205529.19834-3-martin.blumenstingl@googlemail.com>
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
> Instead of blindly copying the old values (which seems strange since
> they gave the PHY one second to come out of reset) over this also
> updates the delays based on the datasheets:
> - RTL8211F PHY on the Odroid-C1 and MXIII-Plus needs a 10ms assert
>   delay (the datasheet mentions: "For a complete PHY reset, this pin
>   must be asserted low for at least 10ms") and a 30ms deassert delay
>   (the datasheet mentions: "Wait for a further 30ms (for internal
>   circuits settling time) before accessing the PHY register"). The
>   old settings used 10ms for assert and 1000ms for deassert.
> - IP101GR PHY on the EC-100 and MXQ needs a 10ms assert delay (the
>   datasheet mentions: "Trst | Reset period | 10ms") and a 10ms deassert
>   delay as well (the datasheet mentions: "Tclk_MII_rdy | MII/RMII clock
>   output ready after reset released | 10ms")). The old settings used
>   10ms for assert and 1000ms for deassert.
> 
> No functional changes intended.
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  arch/arm/boot/dts/meson8b-ec100.dts       | 9 +++++----
>  arch/arm/boot/dts/meson8b-mxq.dts         | 9 +++++----
>  arch/arm/boot/dts/meson8b-odroidc1.dts    | 9 +++++----
>  arch/arm/boot/dts/meson8m2-mxiii-plus.dts | 8 ++++----
>  4 files changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/meson8b-ec100.dts b/arch/arm/boot/dts/meson8b-ec100.dts
> index 9bf4249cb60d..96d239d8334e 100644
> --- a/arch/arm/boot/dts/meson8b-ec100.dts
> +++ b/arch/arm/boot/dts/meson8b-ec100.dts
> @@ -234,10 +234,6 @@
>  	phy-handle = <&eth_phy0>;
>  	phy-mode = "rmii";
>  
> -	snps,reset-gpio = <&gpio GPIOH_4 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	mdio {
>  		compatible = "snps,dwmac-mdio";
>  		#address-cells = <1>;
> @@ -246,6 +242,11 @@
>  		eth_phy0: ethernet-phy@0 {
>  			/* IC Plus IP101A/G (0x02430c54) */
>  			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <10000>;
> +			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
> +
>  			icplus,select-interrupt;
>  			interrupt-parent = <&gpio_intc>;
>  			/* GPIOH_3 */
> diff --git a/arch/arm/boot/dts/meson8b-mxq.dts b/arch/arm/boot/dts/meson8b-mxq.dts
> index ef602ab45efd..bb27b34eb346 100644
> --- a/arch/arm/boot/dts/meson8b-mxq.dts
> +++ b/arch/arm/boot/dts/meson8b-mxq.dts
> @@ -91,10 +91,6 @@
>  	phy-handle = <&eth_phy0>;
>  	phy-mode = "rmii";
>  
> -	snps,reset-gpio = <&gpio GPIOH_4 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	mdio {
>  		compatible = "snps,dwmac-mdio";
>  		#address-cells = <1>;
> @@ -103,6 +99,11 @@
>  		eth_phy0: ethernet-phy@0 {
>  			/* IC Plus IP101A/G (0x02430c54) */
>  			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <10000>;
> +			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
> +
>  			icplus,select-interrupt;
>  			interrupt-parent = <&gpio_intc>;
>  			/* GPIOH_3 */
> diff --git a/arch/arm/boot/dts/meson8b-odroidc1.dts b/arch/arm/boot/dts/meson8b-odroidc1.dts
> index 018695b2b83a..86c4614e0a38 100644
> --- a/arch/arm/boot/dts/meson8b-odroidc1.dts
> +++ b/arch/arm/boot/dts/meson8b-odroidc1.dts
> @@ -176,10 +176,6 @@
>  &ethmac {
>  	status = "okay";
>  
> -	snps,reset-gpio = <&gpio GPIOH_4 GPIO_ACTIVE_HIGH>;
> -	snps,reset-active-low;
> -	snps,reset-delays-us = <0 10000 30000>;
> -
>  	pinctrl-0 = <&eth_rgmii_pins>;
>  	pinctrl-names = "default";
>  
> @@ -195,6 +191,11 @@
>  		/* Realtek RTL8211F (0x001cc916) */
>  		eth_phy: ethernet-phy@0 {
>  			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <30000>;
> +			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
> +
>  			interrupt-parent = <&gpio_intc>;
>  			/* GPIOH_3 */
>  			interrupts = <17 IRQ_TYPE_LEVEL_LOW>;
> diff --git a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
> index 59b07a55e461..d54477b1001c 100644
> --- a/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
> +++ b/arch/arm/boot/dts/meson8m2-mxiii-plus.dts
> @@ -73,10 +73,6 @@
>  
>  	amlogic,tx-delay-ns = <4>;
>  
> -	snps,reset-gpio = <&gpio GPIOH_4 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
> -
>  	mdio {
>  		compatible = "snps,dwmac-mdio";
>  		#address-cells = <1>;
> @@ -85,6 +81,10 @@
>  		eth_phy0: ethernet-phy@0 {
>  			/* Realtek RTL8211F (0x001cc916) */
>  			reg = <0>;
> +
> +			reset-assert-us = <10000>;
> +			reset-deassert-us = <30000>;
> +			reset-gpios = <&gpio GPIOH_4 GPIO_ACTIVE_LOW>;
>  		};
>  	};
>  };
> 

Nice !

Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
