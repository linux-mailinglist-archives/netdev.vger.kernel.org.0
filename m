Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49DF5EEA8
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 23:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfGCViC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 17:38:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46917 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCViC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 17:38:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so4351431wrw.13;
        Wed, 03 Jul 2019 14:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kKPyzfq2Y+eNxPkYuNMCdyNtlMubNw8hxni2wJ0d9Ro=;
        b=LfGcJKucxzK0dtD06mtf1Xj8mvhd0eEl7RrKxWco2YM757vI9tzzA05KXTh+dhzbHi
         LtowOsDD+EXBiGv7FIaHvMUnRwPwRpLIvzrGgDG5gq4XUajPHRYf0yEMGMb5p7S4Dlue
         wJFJ/8EQ11tyGjse8cnVCPBkdmkmvFTNigZoJOPk8u9Y5VtYSSzJy3yXOI5UlldIwzxa
         IEkphPTLULFPvBMmfCjjGBwkYQpjUcvahpba2C1tUeEP5QBZqQIFF8+bvgfHBS/2LJFf
         9HzaoTuEGyTUm2bTPgA2yVZ/HHSNL36hgAIN/LbPqMDy2Aue3OjWEQ/Px9bNaa4vrbps
         n/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kKPyzfq2Y+eNxPkYuNMCdyNtlMubNw8hxni2wJ0d9Ro=;
        b=U/r60zlbMdmTAYRNwguI00r+A8HrW9zg6WRPDgyDZt14e94m3VZV5Xqiv8Pt3uicbm
         EbbY8XAK5ej9aHFRCjO0IO6TKZm80k5B2hI1iwU7jMoXUXNpqOTF72bLMs6ncajQBt7g
         YFcQRn7vDfVAcBGGO2b1nwohYhNvmsh2mDBh1w5TuNj6Ra/RWG8nFy9HI+ztklaivDFx
         jRlnqCBEO1x46zuw79IhkZpqwC1nEkS5njSgqSj/jfZi8v9uFGch0Uih0SBCfE4A7VNS
         sU1ibI3YbvfRV/UXfwxQdYmqs8yjCcyi4LqBTNseOnKRob16ENBw3IPbOlAvIxtyBV/l
         uKHQ==
X-Gm-Message-State: APjAAAUjwIIlhLWZx0VH21uoDm8ZSdm5/8wbYllFIRTAnktg8w61KVD0
        3/m9aCeA9gn+I4RBO+XunpM=
X-Google-Smtp-Source: APXvYqyE8GnUudq4NV783h6wlEUO4nc0nHuFGFdHEydMSmEqk1yR5wnUXMWFYwemgUwpF7F1OPe9Lg==
X-Received: by 2002:a5d:45d0:: with SMTP id b16mr30294674wrs.209.1562189879389;
        Wed, 03 Jul 2019 14:37:59 -0700 (PDT)
Received: from [10.67.49.31] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h19sm8776868wrb.81.2019.07.03.14.37.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 14:37:58 -0700 (PDT)
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
To:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 mQGiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz7QnRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+iGYEExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCVF/S8QUJHlwd3wAKCRBhV5kVtWN2DvCVAJ4u4/bPF4P3jxb4qEY8I2gS
 6hG0gACffNWlqJ2T4wSSn+3o7CCZNd7SLSC5BA0ESM+4EhAQAL/o09boR9D3Vk1Tt7+gpYr3
 WQ6hgYVON905q2ndEoA2J0dQxJNRw3snabHDDzQBAcqOvdi7YidfBVdKi0wxHhSuRBfuOppu
 pdXkb7zxuPQuSveCLqqZWRQ+Cc2QgF7SBqgznbe6Ngout5qXY5Dcagk9LqFNGhJQzUGHAsIs
 hap1f0B1PoUyUNeEInV98D8Xd/edM3mhO9nRpUXRK9Bvt4iEZUXGuVtZLT52nK6Wv2EZ1TiT
 OiqZlf1P+vxYLBx9eKmabPdm3yjalhY8yr1S1vL0gSA/C6W1o/TowdieF1rWN/MYHlkpyj9c
 Rpc281gAO0AP3V1G00YzBEdYyi0gaJbCEQnq8Vz1vDXFxHzyhgGz7umBsVKmYwZgA8DrrB0M
 oaP35wuGR3RJcaG30AnJpEDkBYHznI2apxdcuTPOHZyEilIRrBGzDwGtAhldzlBoBwE3Z3MY
 31TOpACu1ZpNOMysZ6xiE35pWkwc0KYm4hJA5GFfmWSN6DniimW3pmdDIiw4Ifcx8b3mFrRO
 BbDIW13E51j9RjbO/nAaK9ndZ5LRO1B/8Fwat7bLzmsCiEXOJY7NNpIEpkoNoEUfCcZwmLrU
 +eOTPzaF6drw6ayewEi5yzPg3TAT6FV3oBsNg3xlwU0gPK3v6gYPX5w9+ovPZ1/qqNfOrbsE
 FRuiSVsZQ5s3AAMFD/9XjlnnVDh9GX/r/6hjmr4U9tEsM+VQXaVXqZuHKaSmojOLUCP/YVQo
 7IiYaNssCS4FCPe4yrL4FJJfJAsbeyDykMN7wAnBcOkbZ9BPJPNCbqU6dowLOiy8AuTYQ48m
 vIyQ4Ijnb6GTrtxIUDQeOBNuQC/gyyx3nbL/lVlHbxr4tb6YkhkO6shjXhQh7nQb33FjGO4P
 WU11Nr9i/qoV8QCo12MQEo244RRA6VMud06y/E449rWZFSTwGqb0FS0seTcYNvxt8PB2izX+
 HZA8SL54j479ubxhfuoTu5nXdtFYFj5Lj5x34LKPx7MpgAmj0H7SDhpFWF2FzcC1bjiW9mjW
 HaKaX23Awt97AqQZXegbfkJwX2Y53ufq8Np3e1542lh3/mpiGSilCsaTahEGrHK+lIusl6mz
 Joil+u3k01ofvJMK0ZdzGUZ/aPMZ16LofjFA+MNxWrZFrkYmiGdv+LG45zSlZyIvzSiG2lKy
 kuVag+IijCIom78P9jRtB1q1Q5lwZp2TLAJlz92DmFwBg1hyFzwDADjZ2nrDxKUiybXIgZp9
 aU2d++ptEGCVJOfEW4qpWCCLPbOT7XBr+g/4H3qWbs3j/cDDq7LuVYIe+wchy/iXEJaQVeTC
 y5arMQorqTFWlEOgRA8OP47L9knl9i4xuR0euV6DChDrguup2aJVU4hPBBgRAgAPAhsMBQJU
 X9LxBQkeXB3fAAoJEGFXmRW1Y3YOj4UAn3nrFLPZekMeqX5aD/aq/dsbXSfyAKC45Go0YyxV
 HGuUuzv+GKZ6nsysJ7kCDQRXG8fwARAA6q/pqBi5PjHcOAUgk2/2LR5LjjesK50bCaD4JuNc
 YDhFR7Vs108diBtsho3w8WRd9viOqDrhLJTroVckkk74OY8r+3t1E0Dd4wHWHQZsAeUvOwDM
 PQMqTUBFuMi6ydzTZpFA2wBR9x6ofl8Ax+zaGBcFrRlQnhsuXLnM1uuvS39+pmzIjasZBP2H
 UPk5ifigXcpelKmj6iskP3c8QN6x6GjUSmYx+xUfs/GNVSU1XOZn61wgPDbgINJd/THGdqiO
 iJxCLuTMqlSsmh1+E1dSdfYkCb93R/0ZHvMKWlAx7MnaFgBfsG8FqNtZu3PCLfizyVYYjXbV
 WO1A23riZKqwrSJAATo5iTS65BuYxrFsFNPrf7TitM8E76BEBZk0OZBvZxMuOs6Z1qI8YKVK
 UrHVGFq3NbuPWCdRul9SX3VfOunr9Gv0GABnJ0ET+K7nspax0xqq7zgnM71QEaiaH17IFYGS
 sG34V7Wo3vyQzsk7qLf9Ajno0DhJ+VX43g8+AjxOMNVrGCt9RNXSBVpyv2AMTlWCdJ5KI6V4
 KEzWM4HJm7QlNKE6RPoBxJVbSQLPd9St3h7mxLcne4l7NK9eNgNnneT7QZL8fL//s9K8Ns1W
 t60uQNYvbhKDG7+/yLcmJgjF74XkGvxCmTA1rW2bsUriM533nG9gAOUFQjURkwI8jvMAEQEA
 AYkCaAQYEQIACQUCVxvH8AIbAgIpCRBhV5kVtWN2DsFdIAQZAQIABgUCVxvH8AAKCRCH0Jac
 RAcHBIkHD/9nmfog7X2ZXMzL9ktT++7x+W/QBrSTCTmq8PK+69+INN1ZDOrY8uz6htfTLV9+
 e2W6G8/7zIvODuHk7r+yQ585XbplgP0V5Xc8iBHdBgXbqnY5zBrcH+Q/oQ2STalEvaGHqNoD
 UGyLQ/fiKoLZTPMur57Fy1c9rTuKiSdMgnT0FPfWVDfpR2Ds0gpqWePlRuRGOoCln5GnREA/
 2MW2rWf+CO9kbIR+66j8b4RUJqIK3dWn9xbENh/aqxfonGTCZQ2zC4sLd25DQA4w1itPo+f5
 V/SQxuhnlQkTOCdJ7b/mby/pNRz1lsLkjnXueLILj7gNjwTabZXYtL16z24qkDTI1x3g98R/
 xunb3/fQwR8FY5/zRvXJq5us/nLvIvOmVwZFkwXc+AF+LSIajqQz9XbXeIP/BDjlBNXRZNdo
 dVuSU51ENcMcilPr2EUnqEAqeczsCGpnvRCLfVQeSZr2L9N4svNhhfPOEscYhhpHTh0VPyxI
 pPBNKq+byuYPMyk3nj814NKhImK0O4gTyCK9b+gZAVvQcYAXvSouCnTZeJRrNHJFTgTgu6E0
 caxTGgc5zzQHeX67eMzrGomG3ZnIxmd1sAbgvJUDaD2GrYlulfwGWwWyTNbWRvMighVdPkSF
 6XFgQaosWxkV0OELLy2N485YrTr2Uq64VKyxpncLh50e2RnyAJ9Za0Dx0yyp44iD1OvHtkEI
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <e8fe7baf-e4e0-c713-7b93-07a3859c33c6@gmail.com>
Date:   Wed, 3 Jul 2019 14:37:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703193724.246854-6-mka@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/19 12:37 PM, Matthias Kaehlcke wrote:
> The LED behavior of some Realtek PHYs is configurable. Add the
> property 'realtek,led-modes' to specify the configuration of the
> LEDs.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v2:
> - patch added to the series
> ---
>  .../devicetree/bindings/net/realtek.txt         |  9 +++++++++
>  include/dt-bindings/net/realtek.h               | 17 +++++++++++++++++
>  2 files changed, 26 insertions(+)
>  create mode 100644 include/dt-bindings/net/realtek.h
> 
> diff --git a/Documentation/devicetree/bindings/net/realtek.txt b/Documentation/devicetree/bindings/net/realtek.txt
> index 71d386c78269..40b0d6f9ee21 100644
> --- a/Documentation/devicetree/bindings/net/realtek.txt
> +++ b/Documentation/devicetree/bindings/net/realtek.txt
> @@ -9,6 +9,12 @@ Optional properties:
>  
>  	SSC is only available on some Realtek PHYs (e.g. RTL8211E).
>  
> +- realtek,led-modes: LED mode configuration.
> +
> +	A 0..3 element vector, with each element configuring the operating
> +	mode of an LED. Omitted LEDs are turned off. Allowed values are
> +	defined in "include/dt-bindings/net/realtek.h".

This should probably be made more general and we should define LED modes
that makes sense regardless of the PHY device, introduce a set of
generic functions for validating and then add new function pointer for
setting the LED configuration to the PHY driver. This would allow to be
more future proof where each PHY driver could expose standard LEDs class
devices to user-space, and it would also allow facilities like: ethtool
-p to plug into that.

Right now, each driver invents its own way of configuring LEDs, that
does not scale, and there is not really a good reason for that other
than reviewing drivers in isolation and therefore making it harder to
extract the commonality. Yes, I realize that since you are the latest
person submitting something in that area, you are being selected :)

> +
>  Example:
>  
>  mdio0 {
> @@ -20,5 +26,8 @@ mdio0 {
>  		reg = <1>;
>  		realtek,eee-led-mode-disable;
>  		realtek,enable-ssc;
> +		realtek,led-modes = <RTL8211E_LINK_ACTIVITY
> +				     RTL8211E_LINK_100
> +				     RTL8211E_LINK_1000>;
>  	};
>  };
> diff --git a/include/dt-bindings/net/realtek.h b/include/dt-bindings/net/realtek.h
> new file mode 100644
> index 000000000000..8d64f58d58f8
> --- /dev/null
> +++ b/include/dt-bindings/net/realtek.h
> @@ -0,0 +1,17 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _DT_BINDINGS_REALTEK_H
> +#define _DT_BINDINGS_REALTEK_H
> +
> +/* LED modes for RTL8211E PHY */
> +
> +#define RTL8211E_LINK_10		1
> +#define RTL8211E_LINK_100		2
> +#define RTL8211E_LINK_1000		4
> +#define RTL8211E_LINK_10_100		3
> +#define RTL8211E_LINK_10_1000		5
> +#define RTL8211E_LINK_100_1000		6
> +#define RTL8211E_LINK_10_100_1000	7
> +
> +#define RTL8211E_LINK_ACTIVITY		(1 << 16)
> +
> +#endif
> 


-- 
Florian
