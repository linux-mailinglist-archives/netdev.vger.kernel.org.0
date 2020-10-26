Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4D9298F50
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 15:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781505AbgJZOaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 10:30:30 -0400
Received: from mail-oo1-f67.google.com ([209.85.161.67]:43465 "EHLO
        mail-oo1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1781493AbgJZOa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 10:30:28 -0400
Received: by mail-oo1-f67.google.com with SMTP id z14so2134564oom.10;
        Mon, 26 Oct 2020 07:30:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=EvODWLSlZb9Skc/iTD6aHWqmQrjOtvrwcbltSN0DUow=;
        b=rWzr6iN68zpk98U3JGzl0S53BZqRTg7pSa0i2uxs6Yqn9nUnGdkqJk1DCfIdOKZYpQ
         mEFQ7uKSFeaAywz6a6JoydTsZ/h9C17vxrdctJZUBR5xkOTzowlVwYo4PvTj4l25N/Da
         cLh/3S0//dFZ0bEyUlkycYrCGoDIz1SZmjo25ZmCoz5NdjdHfo8oNV2w+4uR8f4mhlgZ
         mYk5rnQnMN7oZedOuc06AdV67Xv0KapKiAvQ6XDxWGkYtHsWblTONaJI7A5kDkBYcCx9
         gEsEfoeyJY6d1rHretYVfJ4eubV2qc59blS0ixf3t+bdT9V1VPNNRj0xotCJ5Q+lBWLZ
         mIUw==
X-Gm-Message-State: AOAM530mGykwy1ahxiUTg5SxoWeqOEcpZC+s9+60kDbtEgo6n4ftxNpb
        DOOO8DGlZ72Oh4bBECCjMg==
X-Google-Smtp-Source: ABdhPJy5jo0OcqXys+08F5mv4GOWXCDsbF7iHCxIexI76vlCOrGJygolE/VWzKBmZPl/afqlzltoDg==
X-Received: by 2002:a4a:c98f:: with SMTP id u15mr14230219ooq.78.1603722625676;
        Mon, 26 Oct 2020 07:30:25 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id b125sm2162575oii.19.2020.10.26.07.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 07:30:25 -0700 (PDT)
Received: (nullmailer pid 112408 invoked by uid 1000);
        Mon, 26 Oct 2020 14:30:24 -0000
Date:   Mon, 26 Oct 2020 09:30:24 -0500
From:   Rob Herring <robh@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v2 02/24] dt-bindings: introduce silabs,wfx.yaml
Message-ID: <20201026143024.GA95610@bogus>
References: <20201020125817.1632995-1-Jerome.Pouiller@silabs.com>
 <20201020125817.1632995-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201020125817.1632995-3-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 20, 2020 at 02:57:55PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  .../bindings/net/wireless/silabs,wfx.yaml     | 133 ++++++++++++++++++
>  1 file changed, 133 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> new file mode 100644
> index 000000000000..2605e9fed185
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> @@ -0,0 +1,133 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (c) 2020, Silicon Laboratories, Inc.
> +%YAML 1.2
> +---
> +
> +$id: http://devicetree.org/schemas/net/wireless/silabs,wfx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Silicon Labs WFxxx devicetree bindings
> +
> +maintainers:
> +  - Jérôme Pouiller <jerome.pouiller@silabs.com>
> +
> +description: >
> +  Support for the Wifi chip WFxxx from Silicon Labs. Currently, the only device
> +  from the WFxxx series is the WF200 described here:
> +     https://www.silabs.com/documents/public/data-sheets/wf200-datasheet.pdf
> +  
> +  The WF200 can be connected via SPI or via SDIO.
> +  
> +  For SDIO:
> +  
> +    Declaring the WFxxx chip in device tree is mandatory (usually, the VID/PID is
> +    sufficient for the SDIO devices).
> +  
> +    It is recommended to declare a mmc-pwrseq on SDIO host above WFx. Without
> +    it, you may encounter issues during reboot. The mmc-pwrseq should be
> +    compatible with mmc-pwrseq-simple. Please consult
> +    Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt for more
> +    information.
> +  
> +  For SPI:
> +  
> +    In add of the properties below, please consult
> +    Documentation/devicetree/bindings/spi/spi-controller.yaml for optional SPI
> +    related properties.
> +
> +properties:
> +  compatible:
> +    const: silabs,wf200
> +
> +  reg:
> +    description:
> +      When used on SDIO bus, <reg> must be set to 1. When used on SPI bus, it is
> +      the chip select address of the device as defined in the SPI devices
> +      bindings.
> +    maxItems: 1
> +
> +  spi-max-frequency: true
> +
> +  interrupts:
> +    description: The interrupt line. Triggers IRQ_TYPE_LEVEL_HIGH and
> +      IRQ_TYPE_EDGE_RISING are both supported by the chip and the driver. When
> +      SPI is used, this property is required. When SDIO is used, the "in-band"
> +      interrupt provided by the SDIO bus is used unless an interrupt is defined
> +      in the Device Tree.
> +    maxItems: 1
> +
> +  reset-gpios:
> +    description: (SPI only) Phandle of gpio that will be used to reset chip
> +      during probe. Without this property, you may encounter issues with warm
> +      boot. (For legacy purpose, the gpio in inverted when compatible ==
> +      "silabs,wfx-spi")
> +
> +      For SDIO, the reset gpio should declared using a mmc-pwrseq.
> +    maxItems: 1
> +
> +  wakeup-gpios:
> +    description: Phandle of gpio that will be used to wake-up chip. Without this
> +      property, driver will disable most of power saving features.
> +    maxItems: 1
> +
> +  config-file:

If this is antenna data/config, then make the property name more 
specific. And it needs a vendor prefix as it is vendor specific.

> +    description: Use an alternative file as PDS. Default is `wf200.pds`.
> +
> +  local-mac-address:
> +    $ref: /net/ethernet-controller.yaml#/properties/local-mac-address
> +
> +  mac-address:
> +    $ref: /net/ethernet-controller.yaml#/properties/mac-address

I'd rather see these properties refactored out to their own file. We 
should probably have a wifi-controller.yaml that has these as well as 
enforcing the node name 'wifi'.

> +
> +additionalProperties: true

What properties? This shouldn't be true. If you need spi-cpol or 
spi-cpha, then you should list those. Really, if the SPI mode of the 
device is fixed, then you should never use those. 

> +
> +required:
> +  - compatible
> +  - reg
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    spi0 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        wfx@0 {
> +            compatible = "silabs,wf200";
> +            pinctrl-names = "default";
> +            pinctrl-0 = <&wfx_irq &wfx_gpios>;
> +            reg = <0>;
> +            interrupts-extended = <&gpio 16 IRQ_TYPE_EDGE_RISING>;
> +            wakeup-gpios = <&gpio 12 GPIO_ACTIVE_HIGH>;
> +            reset-gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
> +            spi-max-frequency = <42000000>;
> +        };
> +    };
> +
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    wfx_pwrseq: wfx_pwrseq {
> +        compatible = "mmc-pwrseq-simple";
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&wfx_reset>;
> +        reset-gpios = <&gpio 13 GPIO_ACTIVE_LOW>;
> +    };
> +
> +    mmc0 {
> +        mmc-pwrseq = <&wfx_pwrseq>;
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        mmc@1 {

wifi@1

> +            compatible = "silabs,wf200";
> +            pinctrl-names = "default";
> +            pinctrl-0 = <&wfx_wakeup>;
> +            reg = <1>;
> +            wakeup-gpios = <&gpio 12 GPIO_ACTIVE_HIGH>;
> +        };
> +    };
> +...
> -- 
> 2.28.0
> 
