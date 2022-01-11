Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763ED48BAAA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 23:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346167AbiAKWUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 17:20:00 -0500
Received: from mail-oi1-f180.google.com ([209.85.167.180]:40870 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346108AbiAKWT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 17:19:59 -0500
Received: by mail-oi1-f180.google.com with SMTP id w188so999151oib.7;
        Tue, 11 Jan 2022 14:19:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=506v6Xprj7syTiQqAlY2fnFjDQjng6ljCNvJOQAD9zo=;
        b=EfuBbydSdJ2Q49g4zcCb4qYUX8Xo2xnGanyXr7q5WqSPp7ClfLACBW1hUunDCCkQKK
         SrqL3SeG/O0dfl3jQP6ZDmI4SwWk5Zq/GNH9qWjVlOK05lNdeub1tAbLaChxXGevetVy
         f04S3m5ZsyKKFhuMpsCm6/x6KVLZtq58sXm9NxNBh5HX6zaMvQwwCLBActx/KrBva+Gg
         iiRpb9KVV54DvAvu/1sol708+Nil7OUAWUemQDL3udm0gYnCUw8P5Wjw+p1H119krXrM
         LMOaXAqcfXazTt/ghUYG+T1KpkynY3VwQ9HdOCXlGbvgA1bA3UyCNErJwRhERd1NfVAy
         snhg==
X-Gm-Message-State: AOAM533YJGUaPbRPLBW5bA2BBSbiap4ocCjr7OuCFPr4UpLRHWlB1tYR
        7FlHDmdh9sM0UF0o+Fdo/A==
X-Google-Smtp-Source: ABdhPJwlX38O3DGL+NuOlvDakdHxI9C2ckidPXRJYVTVfZQQ2Xe2mIuLqk3juKG5iI2Ir2d7KTBkKA==
X-Received: by 2002:a05:6808:48a:: with SMTP id z10mr3208208oid.137.1641939598502;
        Tue, 11 Jan 2022 14:19:58 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g25sm2134008oou.12.2022.01.11.14.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 14:19:57 -0800 (PST)
Received: (nullmailer pid 3605690 invoked by uid 1000);
        Tue, 11 Jan 2022 22:19:56 -0000
Date:   Tue, 11 Jan 2022 16:19:56 -0600
From:   Rob Herring <robh@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 02/24] dt-bindings: introduce silabs,wfx.yaml
Message-ID: <Yd4CjAM+3/PmLSyY@robh.at.kernel.org>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
 <20220111171424.862764-3-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220111171424.862764-3-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 11, 2022 at 06:14:02PM +0100, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Prepare the inclusion of the wfx driver in the kernel.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  .../bindings/net/wireless/silabs,wfx.yaml     | 138 ++++++++++++++++++
>  1 file changed, 138 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> new file mode 100644
> index 000000000000..d12f262868cf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> @@ -0,0 +1,138 @@
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
> +    Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml for more
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
> +    anyOf:
> +      - const: silabs,wf200    # Chip alone without antenna
> +      - const: silabs,brd4001a # WGM160P Evaluation Board
> +      - const: silabs,brd8022a # WF200 Evaluation Board
> +      - const: silabs,brd8023a # WFM200 Evaluation Board

This still defines that compatible is a single entry. You need something 
like:

items:
  - enum:
      - silabs,brd4001a
      - silabs,brd8022a
      - silabs,brd8023a
  - const: silabs,wf200

You need a separate 'items' list for different number of compatible 
entries (e.g. if a single string is valid) and that is when you need to 
use 'oneOf'. Plenty of examples in the tree.

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

Unless there is a mode you can configure, supporting both is wrong even 
though edge will mostly work for a device that is really level.

What a driver supports is not relevant to the binding.

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

What legacy? This is a new binding.

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
> +      "Platform Data Set" in Silabs jargon). Default depends of "compatible"
> +      string. For "silabs,wf200", the default is 'wf200.pds'.
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

spi {

> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        wifi@0 {
> +            compatible = "silabs,brd4001a", "silabs,wf200";
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

mmc {

> +        mmc-pwrseq = <&wfx_pwrseq>;
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        wifi@1 {
> +            compatible = "silabs,brd8022a", "silabs,wf200";
> +            pinctrl-names = "default";
> +            pinctrl-0 = <&wfx_wakeup>;
> +            reg = <1>;
> +            wakeup-gpios = <&gpio 12 GPIO_ACTIVE_HIGH>;
> +        };
> +    };
> +...
> -- 
> 2.34.1
> 
