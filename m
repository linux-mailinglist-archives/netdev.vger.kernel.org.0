Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC64428238A
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 12:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJCKKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 06:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgJCKKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 06:10:10 -0400
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DB35206DB;
        Sat,  3 Oct 2020 10:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601719809;
        bh=4uc/yvgQ0Bg2rkjDtTSRMtPCAxTyxmhc3nyBiJXwIp0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WDzokKxhT2P5YFYukQBAb+AdsJuSG5RYTi/TLJUFAIPUNSS7FPWreUOZJPhduUgaI
         IdxgzcQkOb0cNucRjsC+j3lE2zfFwKFgr6gSepkwrGFmGFW/fVw+LLTE6YujRgLjNx
         r3O7NsYGeKbVugZmLsP7edh6M90bbWgQ6JiXYSpE=
Received: by mail-ej1-f46.google.com with SMTP id p15so5084039ejm.7;
        Sat, 03 Oct 2020 03:10:09 -0700 (PDT)
X-Gm-Message-State: AOAM533y81cjjHObQMy2KJQ1hLfBvCke6X2WsGSpf0mdYOen+5UZVCk6
        +qv/Qz6wr9iRpWCdr076mPjU1f9m6b1hQnPheUc=
X-Google-Smtp-Source: ABdhPJzsmojD/sHn318W+3K8GmWS4SrdOb2+YB41wl8ewmNenZaBBjddwx/tEamQQEtD4UTCIX8d2tfHG5kC/ZRLua0=
X-Received: by 2002:a17:906:14db:: with SMTP id y27mr6295897ejc.148.1601719807676;
 Sat, 03 Oct 2020 03:10:07 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20201002192215eucas1p2c1d2baebfe2a9caa11d88175a2899fea@eucas1p2.samsung.com>
 <20201002192210.19967-1-l.stelmach@samsung.com> <20201002192210.19967-2-l.stelmach@samsung.com>
In-Reply-To: <20201002192210.19967-2-l.stelmach@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Sat, 3 Oct 2020 12:09:55 +0200
X-Gmail-Original-Message-ID: <CAJKOXPeLiKQLSud4f9zxqBdR9a1sk04K56_=jtQr1FGxyDmDuQ@mail.gmail.com>
Message-ID: <CAJKOXPeLiKQLSud4f9zxqBdR9a1sk04K56_=jtQr1FGxyDmDuQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] dt-bindings: net: Add bindings for AX88796C SPI
 Ethernet Adapter
To:     =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        =?UTF-8?Q?Bart=C5=82omiej_=C5=BBolnierkiewicz?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Oct 2020 at 21:22, =C5=81ukasz Stelmach <l.stelmach@samsung.com> =
wrote:
>
> Add bindings for AX88796C SPI Ethernet Adapter.
>
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../bindings/net/asix,ax88796c-spi.yaml       | 76 +++++++++++++++++++
>  .../devicetree/bindings/vendor-prefixes.yaml  |  2 +
>  2 files changed, 78 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c-s=
pi.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml=
 b/Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml
> new file mode 100644
> index 000000000000..50a488d59dbf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/asix,ax88796c-spi.yaml
> @@ -0,0 +1,76 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/asix,ax88796c-spi.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: ASIX AX88796C SPI Ethernet Adapter
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#

Order of top-level entries please:
1. id, schema
2. title
3. maintainers
4. description
and then allOf. See example-schema.yaml.

> +
> +description: |
> +  ASIX AX88796C is an Ethernet controller with a built in PHY. This
> +  describes SPI mode of the chip.
> +
> +  The node for this driver must be a child node of a SPI controller, hen=
ce
> +  all mandatory properties described in ../spi/spi-bus.txt must be speci=
fied.
> +
> +maintainers:
> +  - =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> +
> +properties:
> +  compatible:
> +    const: asix,ax99796c-spi
> +
> +  reg:
> +    description:
> +      SPI device address.

Skip description, it's trivial.

> +    maxItems: 1
> +
> +  spi-max-frequency:
> +    maximum: 40000000
> +
> +  interrupts:
> +    description:
> +     GPIO interrupt to which the chip is connected.

Skip the description. It's trivial and might be not accurate (does not
have to be a GPIO).

> +    maxItems: 1
> +
> +  interrupt-parrent:
> +    description:
> +      A phandle of an interrupt controller.

Skip description.

> +    maxItems: 1
> +
> +  reset-gpios:
> +    description:
> +      A GPIO line handling reset of the chip. As the line is active low,
> +      it should be marked GPIO_ACTIVE_LOW.
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
> +  - interrupt-parrent
> +  - reset-gpios

Additional properties false.

> +
> +examples:
> +  # Artik5 eval board
> +  - |
> +    ax88796c@0 {
> +        compatible =3D "asix,ax88796c";
> +        local-mac-address =3D [00 00 00 00 00 00]; /* Filled in by a boo=
tloader */
> +        interrupt-parent =3D <&gpx2>;
> +        interrupts =3D <0 IRQ_TYPE_LEVEL_LOW>;
> +        spi-max-frequency =3D <40000000>;
> +        reg =3D <0x0>;
> +        reset-gpios =3D <&gpe0 2 GPIO_ACTIVE_LOW>;
> +        controller-data {
> +            samsung,spi-feedback-delay =3D <2>;
> +        };
> +    };
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Doc=
umentation/devicetree/bindings/vendor-prefixes.yaml
> index 2baee2c817c1..5ce5c4a43735 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
> @@ -117,6 +117,8 @@ patternProperties:
>      description: Asahi Kasei Corp.
>    "^asc,.*":
>      description: All Sensors Corporation
> +  "^asix,.*":
> +    description: ASIX Electronics Corporation

Separate patch please.

Best regards,
Krzysztof

>    "^aspeed,.*":
>      description: ASPEED Technology Inc.
>    "^asus,.*":
> --
> 2.26.2
>
