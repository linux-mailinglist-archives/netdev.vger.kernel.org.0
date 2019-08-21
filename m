Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB2C982FE
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 20:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbfHUSdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 14:33:22 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:32930 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfHUSdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 14:33:21 -0400
Received: by mail-ot1-f68.google.com with SMTP id q20so3032473otl.0;
        Wed, 21 Aug 2019 11:33:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=egHhqVwtSMDmp9YF4xs0dobfljwNvPw3rwWXCHsf7oo=;
        b=fNDPgh+uo6pDAEosEFEZ/+tABmMmnfF158ptzURV5nI4OGDLf2B8w1P9rOmuZhsjqz
         hCfFiEXw+80JJiS26VSgs0uiz2L1iSlPpMVhDwBZ4mgNsItoY8CKfvj7/AZgDFYnGwqv
         0QvVNbbwPEbcC4yi61AJ7J+CmaH+M3pWCR/IlKnEwfVRt+yNNPAAc8FvPNyLzv1umLFQ
         BE620Fr0k2O9tKYd5sxaznTkR2y92evyiynODo9WCptEjDYVPSJj7oiCyKOJquAxrKzr
         2EZgKWj9dU98fey+86A2b1d1Uy+sJ2sY6uBzcOflZvrs7WZcjqclJJYp7NdzyZ5gyC8a
         6x0Q==
X-Gm-Message-State: APjAAAUopOR423VJonIhbSAyvWw6vTOmBhJlikxhzlrItfFtxiVgPf9M
        uAQ5FPzTTVQdNhUt+b+ixg==
X-Google-Smtp-Source: APXvYqwQIo2Vuh1ftveWru24y3+5VDk13vltqfb28SAYQ4YZfiK4rqCZKAcqCdEvqJ17ZGIKIpXeTA==
X-Received: by 2002:a9d:331:: with SMTP id 46mr23079892otv.8.1566412400760;
        Wed, 21 Aug 2019 11:33:20 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id v24sm7972302otj.78.2019.08.21.11.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 11:33:20 -0700 (PDT)
Date:   Wed, 21 Aug 2019 13:33:19 -0500
From:   Rob Herring <robh@kernel.org>
To:     Avi Fishman <avifishman70@gmail.com>
Cc:     venture@google.com, yuenn@google.com, benjaminfair@google.com,
        davem@davemloft.net, mark.rutland@arm.com,
        gregkh@linuxfoundation.org, tmaimon77@gmail.com,
        tali.perry1@gmail.com, openbmc@lists.ozlabs.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH v1 1/2] dt-binding: net: document NPCM7xx EMC 10/100 DT
 bindings
Message-ID: <20190821183319.GA19310@bogus>
References: <20190801072611.27935-1-avifishman70@gmail.com>
 <20190801072611.27935-2-avifishman70@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801072611.27935-2-avifishman70@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 01, 2019 at 10:26:10AM +0300, Avi Fishman wrote:
> Added device tree binding documentation for
> Nuvoton NPCM7xx Ethernet MAC Controller (EMC) 10/100 RMII
> 
> Signed-off-by: Avi Fishman <avifishman70@gmail.com>
> ---
>  .../bindings/net/nuvoton,npcm7xx-emc.txt      | 38 +++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nuvoton,npcm7xx-emc.txt

Consider converting this to DT schema (YAML).

> 
> diff --git a/Documentation/devicetree/bindings/net/nuvoton,npcm7xx-emc.txt b/Documentation/devicetree/bindings/net/nuvoton,npcm7xx-emc.txt
> new file mode 100644
> index 000000000000..a7ac3ca66de9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nuvoton,npcm7xx-emc.txt
> @@ -0,0 +1,38 @@
> +Nuvoton NPCM7XX 10/100 Ethernet MAC Controller (EMC)
> +
> +The NPCM7XX provides one or two Ethernet MAC RMII Controllers
> +for WAN/LAN applications
> +
> +Required properties:
> +- device_type     : Should be "network"

Drop this. device_type is deprecated for FDT except for a few cases.

> +- compatible      : "nuvoton,npcm750-emc" for Poleg NPCM7XX.
> +- reg             : Offset and length of the register set for the device.
> +- interrupts      : Contain the emc interrupts with flags for falling edge.
> +                    first interrupt dedicated to Txirq
> +                    second interrupt dedicated to Rxirq
> +- phy-mode        : Should be "rmii" (see ethernet.txt in the same directory)
> +- clocks          : phandle of emc reference clock.
> +- resets          : phandle to the reset control for this device.
> +- use-ncsi        : Use the NC-SI stack instead of an MDIO PHY

Vendor prefix needed.

> +
> +Example:
> +
> +emc0: eth@f0825000 {

ethernet@...

> +	device_type = "network";
> +	compatible = "nuvoton,npcm750-emc";
> +	reg = <0xf0825000 0x1000>;
> +	interrupts = <GIC_SPI 16 IRQ_TYPE_LEVEL_HIGH>,
> +	             <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
> +	phy-mode = "rmii";
> +	clocks = <&clk NPCM7XX_CLK_AHB>;
> +
> +	#use-ncsi; /* add this to support ncsi */

Doesn't match the binding.

> +
> +	clock-names = "clk_emc";
> +	resets = <&rstc 6>;
> +	pinctrl-names = "default";
> +	pinctrl-0 = <&r1_pins
> +	             &r1err_pins
> +	             &r1md_pins>;
> +	status = "okay";

Drop status in examples.

> +};
> -- 
> 2.18.0
> 
