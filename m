Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB04728D298
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgJMQtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 12:49:39 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38346 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgJMQti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 12:49:38 -0400
Received: by mail-ot1-f65.google.com with SMTP id i12so650782ota.5;
        Tue, 13 Oct 2020 09:49:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=t3HNao7Z7e7NuJhBeYuaJzFgEjzmb6YkqhZHsBnqQYs=;
        b=VgkHl4mR+32wRGV68lBnzgHMdlQf3EwlUeO+uSWwjrbl5z2k2W6mRCJ1dujYXpPf9z
         8xA5mDo8bBnll6Fee5Z5jQ+N1PIFXKsegj8dYHu1UnqVt5utL3wpms1aYqAoaa7WDbE1
         foGL9NgK1DKf8mpJYFBwWsJePEBbVcF2uUmLZZ6u+ej6GcPku65vEYuqfIeDA3cOY/2C
         5lDMR3PHxeAmshOyxg1qH7avep557WXjuOz5nNlzJUXWr13/HbTmsAK3dsGVLMUBFUS6
         IwAHVWWcxTAQTVimSC7HDv03/uOoUM9Lbq8xDBPfRsZyVmOR87u8CNgRRkFNfcntFrx2
         J6DQ==
X-Gm-Message-State: AOAM5320Hw8CqwvMnt9eBV/taalMMxuNOF40qaZMJLEgVEtanj6JjFZm
        4KA+j7tl8vYvm3SYCvd1x3nls+l3X1Vy
X-Google-Smtp-Source: ABdhPJyH/mGcnXgbLGg8F+zEGrAXfo+6YioxMnkhPYtvGQU8P7FvyNa+0b5j5ZW/MgdzWOgEDxx/dg==
X-Received: by 2002:a9d:66a:: with SMTP id 97mr390825otn.233.1602607776861;
        Tue, 13 Oct 2020 09:49:36 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id a16sm98061otk.39.2020.10.13.09.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 09:49:36 -0700 (PDT)
Received: (nullmailer pid 3675125 invoked by uid 1000);
        Tue, 13 Oct 2020 16:49:35 -0000
Date:   Tue, 13 Oct 2020 11:49:35 -0500
From:   Rob Herring <robh@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 01/23] dt-bindings: introduce silabs,wfx.yaml
Message-ID: <20201013164935.GA3646933@bogus>
References: <20201012104648.985256-1-Jerome.Pouiller@silabs.com>
 <20201012104648.985256-2-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201012104648.985256-2-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 12:46:26PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  .../bindings/net/wireless/silabs,wfx.yaml     | 125 ++++++++++++++++++
>  1 file changed, 125 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> new file mode 100644
> index 000000000000..43b5630c0407
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> @@ -0,0 +1,125 @@
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
> +description:
> +  The WFxxx chip series can be connected via SPI or via SDIO.

What does this chip do? WiFi or some other wireless?

> +
> +  For SDIO':'
> +
> +    The driver is able to detect a WFxxx chip on SDIO bus by matching its Vendor
> +    ID and Product ID. However, driver will only provide limited features in
> +    this case. Thus declaring WFxxx chip in device tree is recommended (and may
> +    become mandatory in the future).
> +
> +    In addition, it is recommended to declare a mmc-pwrseq on SDIO host above
> +    WFx. Without it, you may encounter issues with warm boot. The mmc-pwrseq
> +    should be compatible with mmc-pwrseq-simple. Please consult
> +    Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt for more
> +    information.
> +
> +  For SPI':'
> +
> +    In add of the properties below, please consult
> +    Documentation/devicetree/bindings/spi/spi-controller.yaml for optional SPI
> +    related properties.
> +
> +  Note that in add of the properties below, the WFx driver also supports
> +  `mac-address` and `local-mac-address` as described in
> +  Documentation/devicetree/bindings/net/ethernet.txt

Note what ethernet.txt contains... This should have a $ref to 
ethernet-controller.yaml to express the above.

You can add 'mac-address: true' if you want to be explicit about what 
properties are used.

> +
> +properties:
> +  compatible:
> +    const: silabs,wf200

blank line between each DT property.

> +  reg:
> +    description:
> +      When used on SDIO bus, <reg> must be set to 1. When used on SPI bus, it is
> +      the chip select address of the device as defined in the SPI devices
> +      bindings.
> +    maxItems: 1
> +  spi-max-frequency:
> +    description: (SPI only) Maximum SPI clocking speed of device in Hz.

No need to redefine a common property.

> +    maxItems: 1

Not an array. Just need:

spi-max-frequency: true

> +  interrupts:
> +    description: The interrupt line. Triggers IRQ_TYPE_LEVEL_HIGH and
> +      IRQ_TYPE_EDGE_RISING are both supported by the chip and the driver. When
> +      SPI is used, this property is required. When SDIO is used, the "in-band"
> +      interrupt provided by the SDIO bus is used unless an interrupt is defined
> +      in the Device Tree.
> +    maxItems: 1
> +  reset-gpios:
> +    description: (SPI only) Phandle of gpio that will be used to reset chip
> +      during probe. Without this property, you may encounter issues with warm
> +      boot. (For legacy purpose, the gpio in inverted when compatible ==
> +      "silabs,wfx-spi")
> +
> +      For SDIO, the reset gpio should declared using a mmc-pwrseq.
> +    maxItems: 1
> +  wakeup-gpios:
> +    description: Phandle of gpio that will be used to wake-up chip. Without this
> +      property, driver will disable most of power saving features.
> +    maxItems: 1
> +  config-file:
> +    description: Use an alternative file as PDS. Default is `wf200.pds`. Only
> +      necessary for development/debug purpose.

'firmware-name' is typically what we'd use here. Though if just for 
debug/dev, perhaps do a debugfs interface for this instead. As DT should 
come from the firmware/bootloader, requiring changing the DT for 
dev/debug is not the easiest workflow compared to doing something from 
userspace.

> +    maxItems: 1

Looks like a string, not an array.

> +
> +required:
> +  - compatible
> +  - reg

Will need additionalProperties or unevaluatedProperties depending on 
whether you list out properties from ethernet-controller.yaml or not.

Rob
