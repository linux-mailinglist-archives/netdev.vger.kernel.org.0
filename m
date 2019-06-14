Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65E514581C
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbfFNJCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:02:39 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37517 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbfFNJCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:02:39 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so1488922wmg.2
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 02:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kU0Oe3mS9lODS/B1HgovuM6oRlIvS+0QROUCkgty93A=;
        b=EehtK0cX0h/qNmhFWq3o4yJbQF5nPQHiLZxyJrFgp3xLnyv3y1l+H/ic/9Zi9MRdrL
         sBnQhEqns8L5gJcs1938Gu2sdnAIMqRQXUQ8VEoVKdJ9+/eDtpRX2CSiQGwyueGKjuRv
         fQjLraeiAxwO/6ppyolV/6E/HpxBhuqVm6C5dNXuhN0RECnxxFd2HRwR+ii0A6H/eypY
         /uR0kaDTlEYXMXvH9q3u/58k/gHsIHMs7yGm18XuRNMSv/m3j7Apvbb7G/hc3ekIzEhs
         QDBn1wkuk8Ik0qHJgYbrHJcByPE7aJY9BaDl3hNoEfp2K4Jo+pOhmnghNNX6MGlW3Lmc
         MVfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kU0Oe3mS9lODS/B1HgovuM6oRlIvS+0QROUCkgty93A=;
        b=QF0IhKUCcEPos4FiwwqZ/erRQ/5P3SL9by628zmG3MJ4DkCteM67tWko+0iaVeBBZD
         l70ebYeml6DFskexXkkmoQ9vzJZiylPaNofopUh2W7dTvIRn8OuGN/k2VTSTWwUy/6Ym
         lE/GT0jCD5IXGOQo7GMR8InJG7BhUBE4GnL1FxS3szmatzMjnXraqt0PsFMpMWZQKiZ1
         dfoafsOCIWTjqgRY/oluGYg6cJhIr2cCQ6DAOx4rthpnliemIg2a2YXNhH4ZmMRoLqCO
         /POJHrdjg/WC+LG/rlMQ6wv602fjtxSAlMsZ4kci1OuOpmnXIfa1LkWKO2jqeTKp7Cut
         kIeg==
X-Gm-Message-State: APjAAAXnoynknHGgCx1qr9p5jnnc3AasyoYAac3/M+4ELaFk+RtnqlfR
        uHXZr/PrsXwmLb59KM/D1rycSw==
X-Google-Smtp-Source: APXvYqzeVjQNRi4XceMifvs2Y/4PPbFgSkYdgJDnBCs3lsMa1BnSSSbdDWU/7phnMzQVq8Xje0TyFw==
X-Received: by 2002:a1c:2e0a:: with SMTP id u10mr7509027wmu.92.1560502955657;
        Fri, 14 Jun 2019 02:02:35 -0700 (PDT)
Received: from [10.1.2.12] (lmontsouris-657-1-212-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id q7sm1970145wrs.65.2019.06.14.02.02.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:02:35 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] arm64: dts: meson: g12a: x96-max: fix the Ethernet
 PHY reset line
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-amlogic@lists.infradead.org, khilman@baylibre.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        linux-arm-kernel@lists.infradead.org
References: <20190612205529.19834-1-martin.blumenstingl@googlemail.com>
 <20190612205529.19834-2-martin.blumenstingl@googlemail.com>
From:   Neil Armstrong <narmstrong@baylibre.com>
Openpgp: preference=signencrypt
Autocrypt: addr=narmstrong@baylibre.com; prefer-encrypt=mutual; keydata=
 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
 ZaTUOEkgIor5losDrePdPgE=
Organization: Baylibre
Message-ID: <9ebc1304-70a5-68eb-2d69-4361d3ddc3c8@baylibre.com>
Date:   Fri, 14 Jun 2019 11:02:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612205529.19834-2-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/06/2019 22:55, Martin Blumenstingl wrote:
> The Odroid-N2 schematics show that the following pins are used for the
> reset and interrupt lines:
> - GPIOZ_14 is the PHY interrupt line
> - GPIOZ_15 is the PHY reset line
> 
> The GPIOZ_14 and GPIOZ_15 pins are special. The datasheet describes that
> they are "3.3V input tolerant open drain (OD) output pins". This means
> the GPIO controller can drive the output LOW to reset the PHY. To
> release the reset it can only switch the pin to input mode. The output
> cannot be driven HIGH for these pins.
> This requires configuring the reset line as GPIO_OPEN_DRAIN because
> otherwise the PHY will be stuck in "reset" state (because driving the
> pin HIGH seems to result in the same signal as driving it LOW).
> 
> The reset line works together with a pull-up resistor (R143 in the
> Odroid-N2 schematics). The SoC can drive GPIOZ_14 LOW to assert the PHY
> reset. However, since the SoC can't drive the pin HIGH (to release the
> reset) we switch the mode to INPUT and let the pull-up resistor take
> care of driving the reset line HIGH.
> 
> Switch to GPIOZ_15 for the PHY reset line instead of using GPIOZ_14
> (which actually is the interrupt line).
> Move from the "snps" specific resets to the MDIO framework's
> reset-gpios because only the latter honors the GPIO flags.
> Use the GPIO flags (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN) to match with
> the pull-up resistor because this will:
> - drive the output LOW to reset the PHY (= active low)
> - switch the pin to INPUT mode so the pull-up will take the PHY out of
>   reset
> 
> Fixes: 51d116557b2044 ("arm64: dts: meson-g12a-x96-max: Add Gigabit Ethernet Support")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> ---
>  arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
> index 98bc56e650a0..de58d7817836 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
> +++ b/arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dts
> @@ -176,6 +176,10 @@
>  		reg = <0>;
>  		max-speed = <1000>;
>  		eee-broken-1000t;
> +
> +		reset-assert-us = <10000>;
> +		reset-deassert-us = <30000>;
> +		reset-gpios = <&gpio GPIOZ_15 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
>  	};
>  };
>  
> @@ -186,9 +190,6 @@
>  	phy-mode = "rgmii";
>  	phy-handle = <&external_phy>;
>  	amlogic,tx-delay-ns = <2>;
> -	snps,reset-gpio = <&gpio GPIOZ_14 0>;
> -	snps,reset-delays-us = <0 10000 1000000>;
> -	snps,reset-active-low;
>  };
>  
>  &pwm_ef {
> 

Thanks for spotting this:
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
