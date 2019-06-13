Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 394D244D0C
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbfFMUJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:09:38 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43525 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729483AbfFMUJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 16:09:38 -0400
Received: by mail-qt1-f193.google.com with SMTP id z24so10862234qtj.10;
        Thu, 13 Jun 2019 13:09:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EsoRqTCzQK8XeT4CpX6/tA1R/n5u3cPoinlZbGIMxfg=;
        b=XDg8fn1AlUSzoRQ5Ycyjdrx2aMC/FuVRtv74/9kcNzJNCh7qfpzdIDO5Z2vllWTGQE
         v5FwdYLjLWbomL5PwX3w+p0G6iTm/ucZSb0ps23gUmUFRzdklhfE5YxROLcL07aCXwnT
         +gWESIm6VMnxOKPYB3CdnR5XnUL/yHsrsrg1R2y4plD6aJWRChVkbnhkO+sGulstoGQh
         iZeL7wX5bau33xw+a1F1fd8cg+LTzLCVLvCuGheDVJmRYWh3YohmXfVgJDzymNTU5dUz
         9lQA6HU4vAe4Gn2O+lfe5JlmQWl4bQ7ylCK2qViX4ow2OBk303YyzGtDcePfi2Wjjweq
         oX6g==
X-Gm-Message-State: APjAAAXlbZc34UQK//B8LK11NNh1b5Um/2ZT80CoiRuk5KSwNhH73/T/
        dFne+0j02CqP4sv6MXCy1A==
X-Google-Smtp-Source: APXvYqwBj3qKm7jFPhoNU8lB+im0laB+BDLfUfdNdKNo4biXs7z8jC8txvk0mfb+BZ6IseYD9aYagw==
X-Received: by 2002:a0c:d24d:: with SMTP id o13mr5132746qvh.86.1560456577255;
        Thu, 13 Jun 2019 13:09:37 -0700 (PDT)
Received: from localhost ([64.188.179.243])
        by smtp.gmail.com with ESMTPSA id u19sm459747qka.35.2019.06.13.13.09.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 13:09:36 -0700 (PDT)
Date:   Thu, 13 Jun 2019 14:09:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     Tristram.Ha@microchip.com, kernel@pengutronix.de,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC 3/3] dt-bindings: net: dsa: document additional Microchip
 KSZ8863 family switches
Message-ID: <20190613200935.GA16851@bogus>
References: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
 <20190508211330.19328-4-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508211330.19328-4-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 11:13:30PM +0200, Michael Grzeschik wrote:
> Document additional Microchip KSZ8863 family switches.
> 
> Show how KSZ8863 switch should be configured as the host port is port 3.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  .../devicetree/bindings/net/dsa/ksz.txt       | 44 +++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/ksz.txt b/Documentation/devicetree/bindings/net/dsa/ksz.txt
> index e7db7268fd0fd..4ac576e1cc34e 100644
> --- a/Documentation/devicetree/bindings/net/dsa/ksz.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/ksz.txt
> @@ -5,6 +5,8 @@ Required properties:
>  
>  - compatible: For external switch chips, compatible string must be exactly one
>    of the following:
> +  - "microchip,ksz8863"
> +  - "microchip,ksz8873"
>    - "microchip,ksz9477"
>    - "microchip,ksz9897"
>    - "microchip,ksz9896"
> @@ -31,6 +33,48 @@ Ethernet switch connected via SPI to the host, CPU port wired to eth0:
>  		};
>  	};
>  
> +	mdio0: mdio-gpio {

Does this example show something new? Examples don't need to instantiate 
every possible option.

> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_mdio_1>;
> +		compatible = "virtual,mdio-gpio";
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		gpios = <&gpio1 31 0 &gpio1 22 0>;
> +
> +		ksz8863@3 {
> +			compatible = "microchip,ksz8863";
> +			interrupt-parrent = <&gpio3>;
> +			interrupt = <30 IRQ_TYPE_LEVEL_HIGH>;
> +			reg = <0>;
> +
> +			ports {
> +				#address-cells = <1>;
> +				#size-cells = <0>;
> +
> +				ports@0 {
> +					reg = <0>;
> +					label = "lan1";
> +				};
> +
> +				ports@1 {
> +					reg = <1>;
> +					label = "lan2";
> +				};
> +
> +				ports@2 {
> +					reg = <2>;
> +					label = "cpu";
> +					ethernet = <&eth0>;
> +
> +					fixed-link {
> +						speed = <100>;
> +						full-duplex;
> +					};
> +				};
> +			};
> +		};
> +	};
> +
>  	spi1: spi@f8008000 {
>  		pinctrl-0 = <&pinctrl_spi_ksz>;
>  		cs-gpios = <&pioC 25 0>;
> -- 
> 2.20.1
> 
