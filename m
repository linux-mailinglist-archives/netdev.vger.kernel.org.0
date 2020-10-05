Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBF5283743
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbgJEOEE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:04:04 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42240 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgJEOEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 10:04:02 -0400
Received: by mail-oi1-f193.google.com with SMTP id 16so1174920oix.9;
        Mon, 05 Oct 2020 07:04:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jcb+2/70PszYHXyW4L95C/uGG2EZ8iNbr9zT465Oa80=;
        b=q2Y3LmguVa0+xeBKieIvGGUXJ7b45Nxs2t3k9l8D/W+mdkOgwA/n3dlmPROLFYOEvK
         ZEjmmKWFOw6NSxozesoralXBgEQC8X6u0Oock23cCsEQzh+9Yg5VtxUMe9M9yJY3iwO+
         lV9CFurod/mQnBw7DyA69bRE43pp28bftI45UfL4HQTQJn3dTTIkd958VI9GLKjv2Hav
         GTCQKbovbKeiOe+iBb2ITaID2OT1cVzPlaebWiOIgdwNKi5sK+RZ2KBx0a/a4PXcpG+O
         KiR8wdcWnay1eZNPlFi6sDlbDRBJ+VlGYruz8ye2LFidj2LOEyMLJq3d4d0shuueH7/6
         xZ+A==
X-Gm-Message-State: AOAM53025B8dIhU37/iJIo7De/zd/2Ww9LDXT4nEef6rHgdVt0fod+qY
        WgzMC1npRwz5ZDuNxWuvFw==
X-Google-Smtp-Source: ABdhPJy3QFjx9s0Phb6R+RWSxq5sCwP+Ktun0EurtTGiFSdb4RaCkut6rj30bR9aJFbk0V23t6U52Q==
X-Received: by 2002:aca:d03:: with SMTP id 3mr7996466oin.112.1601906641296;
        Mon, 05 Oct 2020 07:04:01 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id m205sm53951oib.43.2020.10.05.07.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 07:04:00 -0700 (PDT)
Received: (nullmailer pid 99419 invoked by uid 1000);
        Mon, 05 Oct 2020 14:03:59 -0000
Date:   Mon, 5 Oct 2020 09:03:59 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?utf-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v2 1/4] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
Message-ID: <20201005140359.GB92530@bogus>
References: <CGME20201002192215eucas1p2c1d2baebfe2a9caa11d88175a2899fea@eucas1p2.samsung.com>
 <20201002192210.19967-1-l.stelmach@samsung.com>
 <20201002192210.19967-2-l.stelmach@samsung.com>
 <CAJKOXPeLiKQLSud4f9zxqBdR9a1sk04K56_=jtQr1FGxyDmDuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJKOXPeLiKQLSud4f9zxqBdR9a1sk04K56_=jtQr1FGxyDmDuQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 12:09:55PM +0200, Krzysztof Kozlowski wrote:
> On Fri, 2 Oct 2020 at 21:22, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> >
> > Add bindings for AX88796C SPI Ethernet Adapter.
> >
> > Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> > ---
> >  .../bindings/net/asix,ax88796c-spi.yaml       | 76 +++++++++++++++++++
> >  .../devicetree/bindings/vendor-prefixes.yaml  |  2 +
> >  2 files changed, 78 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml b/Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml
> > new file mode 100644
> > index 000000000000..50a488d59dbf
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml
> > @@ -0,0 +1,76 @@
> > +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/net/asix,ax88796c-spi.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: ASIX AX88796C SPI Ethernet Adapter
> > +
> > +allOf:
> > +  - $ref: ethernet-controller.yaml#
> 
> Order of top-level entries please:
> 1. id, schema
> 2. title
> 3. maintainers
> 4. description
> and then allOf. See example-schema.yaml.
> 
> > +
> > +description: |
> > +  ASIX AX88796C is an Ethernet controller with a built in PHY. This
> > +  describes SPI mode of the chip.
> > +
> > +  The node for this driver must be a child node of a SPI controller, hence
> > +  all mandatory properties described in ../spi/spi-bus.txt must be specified.

Did you read spi-bus.txt?

> > +
> > +maintainers:
> > +  - Łukasz Stelmach <l.stelmach@samsung.com>
> > +
> > +properties:
> > +  compatible:
> > +    const: asix,ax99796c-spi

'spi' is implied by the bus the device is on, so drop.

> > +
> > +  reg:
> > +    description:
> > +      SPI device address.
> 
> Skip description, it's trivial.
> 
> > +    maxItems: 1
> > +
> > +  spi-max-frequency:
> > +    maximum: 40000000
> > +
> > +  interrupts:
> > +    description:
> > +     GPIO interrupt to which the chip is connected.
> 
> Skip the description. It's trivial and might be not accurate (does not
> have to be a GPIO).
> 
> > +    maxItems: 1
> > +
> > +  interrupt-parrent:

Typo. But you don't need to list interrupt-parent.

> > +    description:
> > +      A phandle of an interrupt controller.
> 
> Skip description.

> 
> > +    maxItems: 1
> > +
> > +  reset-gpios:
> > +    description:
> > +      A GPIO line handling reset of the chip. As the line is active low,
> > +      it should be marked GPIO_ACTIVE_LOW.
> > +    maxItems: 1
> > +
> > +  local-mac-address: true
> > +
> > +  mac-address: true
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - spi-max-frequency
> > +  - interrupts
> > +  - interrupt-parrent
> > +  - reset-gpios
> 
> Additional properties false.
> 
> > +
> > +examples:
> > +  # Artik5 eval board
> > +  - |
> > +    ax88796c@0 {

ethernet@0

> > +        compatible = "asix,ax88796c";
> > +        local-mac-address = [00 00 00 00 00 00]; /* Filled in by a bootloader */
> > +        interrupt-parent = <&gpx2>;
> > +        interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
> > +        spi-max-frequency = <40000000>;
> > +        reg = <0x0>;
> > +        reset-gpios = <&gpe0 2 GPIO_ACTIVE_LOW>;
> > +        controller-data {

Not documented.

> > +            samsung,spi-feedback-delay = <2>;
> > +        };
> > +    };
> > diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
> > index 2baee2c817c1..5ce5c4a43735 100644
> > --- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
> > +++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
> > @@ -117,6 +117,8 @@ patternProperties:
> >      description: Asahi Kasei Corp.
> >    "^asc,.*":
> >      description: All Sensors Corporation
> > +  "^asix,.*":
> > +    description: ASIX Electronics Corporation
> 
> Separate patch please.
> 
> Best regards,
> Krzysztof
> 
> >    "^aspeed,.*":
> >      description: ASPEED Technology Inc.
> >    "^asus,.*":
> > --
> > 2.26.2
> >
