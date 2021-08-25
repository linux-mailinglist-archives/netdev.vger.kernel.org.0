Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 984843F7ACC
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242075AbhHYQjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:39:21 -0400
Received: from mail-oo1-f51.google.com ([209.85.161.51]:44621 "EHLO
        mail-oo1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242059AbhHYQjR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 12:39:17 -0400
Received: by mail-oo1-f51.google.com with SMTP id t1-20020a4a54010000b02902638ef0f883so7770271ooa.11;
        Wed, 25 Aug 2021 09:38:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AD/hPSNzIYnzA+6DdM2HAQVIs1u68PymAU53OjEcN5E=;
        b=p1v4oZlWed1r3pi8qdQCrTCTHxpuGf6mhLU580iXbfWeP0K+ER2Fz81LSh9lcB/VtM
         qkZaIheJhOQZqMIBmDTdY3WmAk+IvZqdkLO3MPf/7+sqnxeJNm9kTjXltsmlgRygtk44
         h/V3pCWktZk5fcjLps2xFdOYKCLvpZuxG+pu3K5NGyFYUGK8KiPIew69wXLSJ8g0jmYP
         xrbV+ItU3rK466bItGjbIORqVTOgmWMDAe0ofDEFApGQTLcLGmdebdhQizgq/QsZkqro
         PWoYkVRJs2xYqVskqCDk+lJwJ5GjdvkPPLZFrwsvL9rgrkQAtgN0N77BoMC59TIwd1IQ
         JXaw==
X-Gm-Message-State: AOAM531SEoVZ2oRP404IFedCL7z+VYl2j3l3DYeAR7oIikyi5mgbsMZm
        2cHgBYw2UqQxfvc38ePEcw==
X-Google-Smtp-Source: ABdhPJzfHUhDqS0xr9XhaJ1quQvFLTLm/QkO4W8erZn4nY+BsrBGyg4gLpyaLO3An4YgoGUnZpf4ew==
X-Received: by 2002:a4a:d65b:: with SMTP id y27mr9676424oos.17.1629909511428;
        Wed, 25 Aug 2021 09:38:31 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j17sm60330ots.10.2021.08.25.09.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 09:38:30 -0700 (PDT)
Received: (nullmailer pid 2914154 invoked by uid 1000);
        Wed, 25 Aug 2021 16:38:29 -0000
Date:   Wed, 25 Aug 2021 11:38:29 -0500
From:   Rob Herring <robh@kernel.org>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org,
        Florent Kermarrec <florent@enjoy-digital.fr>,
        "Gabriel L . Somlo" <gsomlo@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: net: Add bindings for LiteETH
Message-ID: <YSZyBVyb+AgDhkua@robh.at.kernel.org>
References: <20210825124655.3104348-1-joel@jms.id.au>
 <20210825124655.3104348-2-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825124655.3104348-2-joel@jms.id.au>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 10:16:54PM +0930, Joel Stanley wrote:
> LiteETH is a small footprint and configurable Ethernet core for FPGA
> based system on chips.
> 
> The hardware is parametrised by the size and number of the slots in it's
> receive and send buffers. These are described as properties, with the
> commonly used values set as the default.
> 
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
> v2:
>  - Fix dtschema check warning relating to registers
>  - Add names to the registers to make it easier to distinguish which is
>    what region
>  - Add mdio description
>  - Include ethernet-controller parent description
> v3:
>  - Define names for reg-names
>  - update example to match common case
>  - describe the hardware using slots and slot sizes. This is how the
>    hardware is pramaterised, and it makes more sense than trying to use
>    the rx/tx-fifo-size properties
> ---
>  .../bindings/net/litex,liteeth.yaml           | 100 ++++++++++++++++++
>  1 file changed, 100 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/litex,liteeth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/litex,liteeth.yaml b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
> new file mode 100644
> index 000000000000..62911b8e913c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/litex,liteeth.yaml
> @@ -0,0 +1,100 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/litex,liteeth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: LiteX LiteETH ethernet device
> +
> +maintainers:
> +  - Joel Stanley <joel@jms.id.au>
> +
> +description: |
> +  LiteETH is a small footprint and configurable Ethernet core for FPGA based
> +  system on chips.
> +
> +  The hardware source is Open Source and can be found on at
> +  https://github.com/enjoy-digital/liteeth/.
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    const: litex,liteeth
> +
> +  reg:
> +    minItems: 3

Don't need minItems if it is equal to 'items' length.

> +    items:
> +      - description: MAC registers
> +      - description: MDIO registers
> +      - description: Packet buffer
> +
> +  reg-names:
> +    minItems: 3

And here.

With that fixed:

Reviewed-by: Rob Herring <robh@kernel.org>

> +    items:
> +      - const: mac
> +      - const: mdio
> +      - const: buffer
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  litex,rx-slots:
> +    description: Number of slots in the receive buffer
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 1
> +    default: 2
> +
> +  litex,tx-slots:
> +    description: Number of slots in the transmit buffer
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 1
> +    default: 2
> +
> +  litex,slot-size:
> +    description: Size in bytes of a slot in the tx/rx buffer
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0x800
> +    default: 0x800
> +
> +  mac-address: true
> +  local-mac-address: true
> +  phy-handle: true
> +
> +  mdio:
> +    $ref: mdio.yaml#
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    mac: ethernet@8020000 {
> +        compatible = "litex,liteeth";
> +        reg = <0x8021000 0x100>,
> +              <0x8020800 0x100>,
> +              <0x8030000 0x2000>;
> +        reg-names = "mac", "mdio", "buffer";
> +        litex,rx-slots = <2>;
> +        litex,tx-slots = <2>;
> +        litex,slot-size = <0x800>;
> +        interrupts = <0x11 0x1>;
> +        phy-handle = <&eth_phy>;
> +
> +        mdio {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          eth_phy: ethernet-phy@0 {
> +            reg = <0>;
> +          };
> +        };
> +    };
> +...
> +
> +#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :
> -- 
> 2.33.0
> 
> 
