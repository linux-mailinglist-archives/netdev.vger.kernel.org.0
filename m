Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC91470548
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 17:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbhLJQKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 11:10:08 -0500
Received: from mail-oi1-f173.google.com ([209.85.167.173]:39934 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233882AbhLJQKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 11:10:08 -0500
Received: by mail-oi1-f173.google.com with SMTP id bf8so13836899oib.6;
        Fri, 10 Dec 2021 08:06:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dAnAsqrDSDhfamLtx23MuUTnyYgeJjRMBuZI8nDebcE=;
        b=EfFLolP8n/ORGBb8ds194ShPW4gx9UC3FDscuN8qBYvsLvaNV70Tk0MVo9sR6lK7Ji
         iPQBp8Saj2LLQvH8ETeblH/TOKopj33WJZ4veu8pfZMO8nwfsNvzyatB/Stcwwg+9glC
         YkX2D0HJmepOkzHNCUSB26hFEFQgKNCWnrRQIflm2cmYqf6u/Tu/txLPdyqRPOiUzR6z
         m6zD1ZzswjD7npApwNxrpG9/pBnHb5pe7hHd1hNyhwQ42arQbTN54ctAs+L46DyA3jY9
         iJg7AuQlZovFGPe3RPJ+SLOuSrYlvdgS5AweBeAFKVKdvjiX5yqKuGFglWXx/GP2MM/f
         GaEg==
X-Gm-Message-State: AOAM532N/L/arwwhQAAZUbn9F/nMGbb5jlwJ9FBy+UFOksnlSZlKNe/4
        eayTbCuXgscZnevf+gMHTg==
X-Google-Smtp-Source: ABdhPJx/D0lhYrSL3dsY/Ab91GTKDE/ZDm7LRsWk8edmx6lOlOHlR5AxG7FnFFO4BED6RrRQRRESIg==
X-Received: by 2002:a05:6808:180c:: with SMTP id bh12mr13589719oib.152.1639152392520;
        Fri, 10 Dec 2021 08:06:32 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id k8sm599409oon.2.2021.12.10.08.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:06:30 -0800 (PST)
Received: (nullmailer pid 1438117 invoked by uid 1000);
        Fri, 10 Dec 2021 16:06:29 -0000
Date:   Fri, 10 Dec 2021 10:06:29 -0600
From:   Rob Herring <robh@kernel.org>
To:     JosephCHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3, 1/2] yaml: Add dm9051 SPI network yaml file
Message-ID: <YbN7BU7bOKGbvFMK@robh.at.kernel.org>
References: <20211210084021.13993-1-josright123@gmail.com>
 <20211210084021.13993-2-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210084021.13993-2-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 04:40:20PM +0800, JosephCHANG wrote:

Follow the subject style used for the directory. 'dt-bindings: net: ...'

> For support davicom dm9051 device tree configure

Complete sentences please.

> 
> Signed-off-by: JosephCHANG <josright123@gmail.com>

space?                 ^

> ---
>  .../bindings/net/davicom,dm9051.yaml          | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/davicom,dm9051.yaml b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> new file mode 100644
> index 000000000000..4c2dd0362f7a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> @@ -0,0 +1,71 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/davicom,dm9051.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Davicom DM9051 SPI Ethernet Controller
> +
> +maintainers:
> +  - Joseph CHANG <josright123@gmail.com>
> +
> +description: |
> +  The DM9051 is a fully integrated and cost-effective low pin count single
> +  chip Fast Ethernet controller with a Serial Peripheral Interface (SPI).
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    const: davicom,dm9051
> +
> +  reg:
> +    maxItems: 1
> +
> +  spi-max-frequency:
> +    maximum: 45000000
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  local-mac-address: true
> +
> +  mac-address: true
> +
> +required:
> +  - compatible
> +  - reg
> +  - spi-max-frequency
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  # Raspberry Pi platform
> +  - |
> +    /* for Raspberry Pi with pin control stuff for GPIO irq */
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    #include <dt-bindings/gpio/gpio.h>
> +    spi {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        dm9051@0 {

ethernet@...

> +            compatible = "davicom,dm9051";
> +            reg = <0>; /* spi chip select */
> +            local-mac-address = [00 00 00 00 00 00];
> +            pinctrl-names = "default";
> +            pinctrl-0 = <&eth_int_pins>;
> +            interrupt-parent = <&gpio>;
> +            interrupts = <26 IRQ_TYPE_LEVEL_LOW>;
> +            spi-max-frequency = <31200000>;
> +        };
> +    };
> +    gpio {

This part is not relevant to the binding example.

> +        eth_int_pins {
> +            brcm,pins = <26>;
> +            brcm,function = <0>; /* in */
> +            brcm,pull = <0>; /* none */
> +        };
> +    };
> -- 
> 2.20.1
> 
> 
