Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C9228372D
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 16:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgJEOBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 10:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgJEOBr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 10:01:47 -0400
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8B8F20874;
        Mon,  5 Oct 2020 14:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601906507;
        bh=IUw5gxZqc6qGN8i7SUlEvnd10BdprX3XZZ7hMxScpnk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GzNUlIuZmK3JFaRwcrqqCiBdtkQZrtEIxiqqqOIk4e9S4OC2mZS5Z7zfyoCFtFSla
         8RPq8cKrW8mVJ0UUjY2JvtRDq90G3pns+FEYImKtRIP5TmXrfpL9Dtuj72ITT/Hujz
         RGF9jdM1bDBasP7tJolcoRMGshT41F+oRXYi6YUM=
Received: by mail-ed1-f50.google.com with SMTP id b12so9428239edz.11;
        Mon, 05 Oct 2020 07:01:46 -0700 (PDT)
X-Gm-Message-State: AOAM532iYqutUlOypqsqYW5Hu1dqIkRhNUAyBlHKu6D1hXuSTPfA6WYq
        hB/T7pnxly/nSy4BuKlqAS9Pn3rlUszOo8Rka6g=
X-Google-Smtp-Source: ABdhPJx2dqmovjzOfxT+9LW1emswS+vMo7h9KFCExlRj/HzmUhCvFZriFFYCrlMs2ZlhjNq3Cv9NtLZoA7y7WCs9+g4=
X-Received: by 2002:aa7:d1d5:: with SMTP id g21mr17816040edp.348.1601906505321;
 Mon, 05 Oct 2020 07:01:45 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20201002192215eucas1p2c1d2baebfe2a9caa11d88175a2899fea@eucas1p2.samsung.com>
 <20201002192210.19967-1-l.stelmach@samsung.com> <20201002192210.19967-2-l.stelmach@samsung.com>
In-Reply-To: <20201002192210.19967-2-l.stelmach@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Mon, 5 Oct 2020 16:01:33 +0200
X-Gmail-Original-Message-ID: <CAJKOXPdGS214XPYXb32QAJgY2jBNgcceb0GjD2XVJJRZZDY84g@mail.gmail.com>
Message-ID: <CAJKOXPdGS214XPYXb32QAJgY2jBNgcceb0GjD2XVJJRZZDY84g@mail.gmail.com>
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
> +    maxItems: 1
> +
> +  spi-max-frequency:
> +    maximum: 40000000
> +
> +  interrupts:
> +    description:
> +     GPIO interrupt to which the chip is connected.
> +    maxItems: 1
> +
> +  interrupt-parrent:
> +    description:
> +      A phandle of an interrupt controller.
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

This and IRQ won't compile without defines, which Rob's robot just
pointed out. It seems you did not test the bindings you post.

Best regards,
Krzysztof
