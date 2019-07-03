Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E6B5E7D0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfGCP0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 11:26:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45017 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbfGCP0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 11:26:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id i18so1412604pgl.11;
        Wed, 03 Jul 2019 08:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6QROen4N3MxmsNite+g7qwf/F2DzBAOrXmr+wrgNUV0=;
        b=mL4FL2ocXEMUft2oJQXTLNkmp2DMQhRFIDfUUudoCHFYlSIrh6ynFfZlCuB+8NOMim
         VMk9y7HplpNPFC6KGuTDgS6dN8TuY0uxMMdes5b9KmZGrzUiZGiaxWrWNJVy4prSIHHm
         EStziaTU3MfmVowvDCqYVV6LvbKF/35GxNu7JH78aAPAJWUgbZYIdpXbVU+5xnPvG27X
         hxbdI4InhdFTJmwB9CBPRdoD9eLEvdQ8oL0wG7ftUT2i9Xk8p1/xNX2Huh82tc6DK0gO
         Ze2D7YCXmmd35uGFHjWxQNENe8fZI3z5nHbp48GVshQkZUvqiWXJVAmYWkq8tAORAnGI
         A5cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6QROen4N3MxmsNite+g7qwf/F2DzBAOrXmr+wrgNUV0=;
        b=r1mvjbIZh5tvyZJ2n4KCnCgZMvLjELDByJX2IPMVagERhZvrzGOPbVP2ZW8SK+5zMy
         JvXY1NrFnFDnm9vvFwXo5+Q1m7wg41ksW9CMkpOdHOP6CxjME36+4KtEwSyOPdBn3vnx
         3peaFIDn9d1AgdZx9q2b/knq6UroPHbSI4pugFVxHaFhDkmsS3Wgrn7gtwOMbQc08NHy
         ywQXxbYvhlb19OdsQAZ0izA3ImLo4l86X0ojM+5kRkLVF1SM5POxJz1F5ceBYdaQ9U9d
         V1elTaz2e6UaGJ4IpTCzH4gfd5EPLTh8D9+W33fw/VAkGqAU9IYho/YLotMHRxJ0wCnD
         beyg==
X-Gm-Message-State: APjAAAVlCUzlHX5RzAFZiTOqM/9IUeaI25Q/2vIUj84zRbku7YVgh0NK
        bxDHPFl++/Q+NZzxh6nXCPYEeC1f
X-Google-Smtp-Source: APXvYqwyIwTtUGuTTdJ9VDhykSgyTtX+5oH5cD/Vk+9O8Lfm6DJ0XbWSbihJbPJDOXwi1P6wrXn71w==
X-Received: by 2002:a63:125c:: with SMTP id 28mr28274843pgs.255.1562167581005;
        Wed, 03 Jul 2019 08:26:21 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r27sm6054940pgn.25.2019.07.03.08.26.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 08:26:20 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] net: dsa: Change DT bindings for Vitesse VSC73xx
 switches
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linus.walleij@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190701152723.624-1-paweldembicki@gmail.com>
 <20190703085757.1027-1-paweldembicki@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <97789626-8371-703b-b515-7eef5cdf198d@gmail.com>
Date:   Wed, 3 Jul 2019 08:26:18 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703085757.1027-1-paweldembicki@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/3/2019 1:57 AM, Pawel Dembicki wrote:
> This commit introduce how to use vsc73xx platform driver.
> 
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>

Pawel, please resubmit your patches starting a new thread, not as reply
to the existing ones, see
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst#n134
for details. Also, David Miller typically likes to have a cover letter
for patch count > 1.

Thanks!

> ---
> Changes in v2:
> - Drop -spi and -platform suffix
> - Change commit message
> 
>  .../bindings/net/dsa/vitesse,vsc73xx.txt      | 57 +++++++++++++++++--
>  1 file changed, 53 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
> index ed4710c40641..c55e0148657d 100644
> --- a/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/vitesse,vsc73xx.txt
> @@ -2,8 +2,8 @@ Vitesse VSC73xx Switches
>  ========================
>  
>  This defines device tree bindings for the Vitesse VSC73xx switch chips.
> -The Vitesse company has been acquired by Microsemi and Microsemi in turn
> -acquired by Microchip but retains this vendor branding.
> +The Vitesse company has been acquired by Microsemi and Microsemi has
> +been acquired Microchip but retains this vendor branding.
>  
>  The currently supported switch chips are:
>  Vitesse VSC7385 SparX-G5 5+1-port Integrated Gigabit Ethernet Switch
> @@ -11,8 +11,13 @@ Vitesse VSC7388 SparX-G8 8-port Integrated Gigabit Ethernet Switch
>  Vitesse VSC7395 SparX-G5e 5+1-port Integrated Gigabit Ethernet Switch
>  Vitesse VSC7398 SparX-G8e 8-port Integrated Gigabit Ethernet Switch
>  
> -The device tree node is an SPI device so it must reside inside a SPI bus
> -device tree node, see spi/spi-bus.txt
> +This switch could have two different management interface.
> +
> +If SPI interface is used, the device tree node is an SPI device so it must
> +reside inside a SPI bus device tree node, see spi/spi-bus.txt
> +
> +If Platform driver is used, the device tree node is an platform device so it
> +must reside inside a platform bus device tree node.
>  
>  Required properties:
>  
> @@ -38,6 +43,7 @@ and subnodes of DSA switches.
>  
>  Examples:
>  
> +SPI:
>  switch@0 {
>  	compatible = "vitesse,vsc7395";
>  	reg = <0>;
> @@ -79,3 +85,46 @@ switch@0 {
>  		};
>  	};
>  };
> +
> +Platform:
> +switch@2,0 {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	compatible = "vitesse,vsc7385";
> +	reg = <0x2 0x0 0x20000>;
> +	reset-gpios = <&gpio0 12 GPIO_ACTIVE_LOW>;
> +
> +	ports {
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		port@0 {
> +			reg = <0>;
> +			label = "lan1";
> +		};
> +		port@1 {
> +			reg = <1>;
> +			label = "lan2";
> +		};
> +		port@2 {
> +			reg = <2>;
> +			label = "lan3";
> +		};
> +		port@3 {
> +			reg = <3>;
> +			label = "lan4";
> +		};
> +		vsc: port@6 {
> +			reg = <6>;
> +			label = "cpu";
> +			ethernet = <&enet0>;
> +			phy-mode = "rgmii";
> +			fixed-link {
> +				speed = <1000>;
> +				full-duplex;
> +				pause;
> +			};
> +		};
> +	};
> +
> +};
> 

-- 
Florian
