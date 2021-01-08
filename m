Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1ECE2EEB47
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 03:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbhAHC27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 21:28:59 -0500
Received: from mail-il1-f170.google.com ([209.85.166.170]:46109 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbhAHC26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 21:28:58 -0500
Received: by mail-il1-f170.google.com with SMTP id 75so8815949ilv.13;
        Thu, 07 Jan 2021 18:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4v0yXGMtjVzg0GR4VJAcMxCAi3C/k0/sDlzwVx/HuwA=;
        b=luowqDt1GljuRW+HqVhWSMjWF6Pe8EcAJYamJCX0tfLoBmIXGWd5/21goBKgRdG+Yt
         j3q33B5m1IC+NAnL398C1Z2C9OTdwJ3Tab11Ie39HJCJ1tc5M+N/i41CFu9e3m7LwBqV
         VeoJIGuSC9Uu/GhfPFKpgxxMsAZ0mWcruvRIEl/1+4bKtebeFgM5hzRF8qA2P4o3YQ/S
         UxKiVriCb5QlKX/rxcx4W/2J3FJ9DxbLWnzYfu4YyBeHD9R1y0fEX+LOs02M5oA+xmU8
         ynDuVUhliI9ZikUFPZyAMh/YCd8Dr6d/x2g2W9rbUJcl2q9iCpzmh6eZ9iHGjj6Kqq5U
         4cUw==
X-Gm-Message-State: AOAM530cf7wznbrK5DJk6olqf2sHSDCnEXp0u/8QDdMK3nbNgSY1VwwE
        bgBuEEXpcQpSy5EiKNaWOs8LfnCWyA==
X-Google-Smtp-Source: ABdhPJyb+2E6oPfTxbL0DlUunHkJR+PHkbpVAfqM8TZJ7y8fTIKJGU5mLf/lOpFwyffXDH0xl2JHsA==
X-Received: by 2002:a92:d6cb:: with SMTP id z11mr1791226ilp.169.1610072897059;
        Thu, 07 Jan 2021 18:28:17 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id s25sm1419581ioe.27.2021.01.07.18.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 18:28:16 -0800 (PST)
Received: (nullmailer pid 1750590 invoked by uid 1000);
        Fri, 08 Jan 2021 02:28:13 -0000
Date:   Thu, 7 Jan 2021 19:28:13 -0700
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
Subject: Re: [PATCH v4 02/24] dt-bindings: introduce silabs,wfx.yaml
Message-ID: <20210108022813.GA1747586@robh.at.kernel.org>
References: <20201223153925.73742-1-Jerome.Pouiller@silabs.com>
 <20201223153925.73742-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201223153925.73742-3-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 04:39:03PM +0100, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>

Commit message?

checkpatch.pl reports trailing whitespace errors.

> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  .../bindings/net/wireless/silabs,wfx.yaml     | 133 ++++++++++++++++++
>  1 file changed, 133 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> new file mode 100644
> index 000000000000..487d46c5fdc0
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
> +  silabs,antenna-config-file:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: Use an alternative file for antenna configuration (aka
> +      "Platform Data Set" in Silabs jargon). Default is 'wf200.pds'.
> +
> +  local-mac-address: true
> +
> +  mac-address: true
> +
> +additionalProperties: false
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
> +        wifi@0 {
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
> +        wifi@1 {
> +            compatible = "silabs,wf200";
> +            pinctrl-names = "default";
> +            pinctrl-0 = <&wfx_wakeup>;
> +            reg = <1>;
> +            wakeup-gpios = <&gpio 12 GPIO_ACTIVE_HIGH>;
> +        };
> +    };
> +...
> -- 
> 2.29.2
> 
