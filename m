Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC64C2E22F9
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 01:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgLXAZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 19:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbgLXAZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 19:25:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F8F22517;
        Thu, 24 Dec 2020 00:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608769469;
        bh=MAsDchMb2B74mJi8EaNjq+4grUjgglbCI5Og/aOCfHw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=glfM9ALiy6As29lszRSEsIdXFhLF7NWzsdtNFpezi+PC60dONOBMBjdJa6/PFUXts
         pqpu1bONYwC1XbfrIOHua4+/Asw/2hyGn5/u4Z/oy4nk/uusZluQFj1oV7xdhQAUGN
         GGEDHcJJj2HXZKTGiia/nNx/Zrr07Oc8gS7IzOlsfveNIzPr3vyEF+ifD/7nsSwKSJ
         7O16oq0NUY55BAejL5otoc9pohkczbIz4gZGKCNwf5GyBWpZoXIusdpcj1EfuRgYe4
         wj5Rnn9wjhqy3TGi3bkvksEBRdMZqYHCHq8fhpm/SdnN3nLz9IJftTDBYbesCzRr0d
         2bOMpJzEF6Qng==
Received: by mail-ed1-f53.google.com with SMTP id j16so834184edr.0;
        Wed, 23 Dec 2020 16:24:29 -0800 (PST)
X-Gm-Message-State: AOAM532yuk/PiQq4ubeJKdOnI4NiW2j5U5WCXlLS8h2Vdzw0Psdeeg5y
        7smWMAj7Vjh/eA1nH2dlnX/WB0uyB5vlbq84Ow==
X-Google-Smtp-Source: ABdhPJxwMzB1b8GV696GPbWzwCEc7NZBMdplOpz9ygAuC+GiK+meDOeYsKDV8XtMfGzxeZ2UDAmh3mivvs2WSMlbbgk=
X-Received: by 2002:a50:c3c5:: with SMTP id i5mr26815360edf.166.1608769467652;
 Wed, 23 Dec 2020 16:24:27 -0800 (PST)
MIME-Version: 1.0
References: <20201216093012.24406-1-chunfeng.yun@mediatek.com> <20201216093012.24406-6-chunfeng.yun@mediatek.com>
In-Reply-To: <20201216093012.24406-6-chunfeng.yun@mediatek.com>
From:   Chun-Kuang Hu <chunkuang.hu@kernel.org>
Date:   Thu, 24 Dec 2020 08:24:16 +0800
X-Gmail-Original-Message-ID: <CAAOTY_9PHEsTa7Vf9ZyQ-JwFYnSi3pBrpOcKE7hBxN=8KWQkeQ@mail.gmail.com>
Message-ID: <CAAOTY_9PHEsTa7Vf9ZyQ-JwFYnSi3pBrpOcKE7hBxN=8KWQkeQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/11] dt-bindings: phy: convert HDMI PHY binding to
 YAML schema
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Min Guo <min.guo@mediatek.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        DTML <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, linux-usb@vger.kernel.org,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Chunfeng:

Chunfeng Yun <chunfeng.yun@mediatek.com> =E6=96=BC 2020=E5=B9=B412=E6=9C=88=
16=E6=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=885:30=E5=AF=AB=E9=81=93=EF=
=BC=9A
>
> Convert HDMI PHY binding to YAML schema mediatek,hdmi-phy.yaml
>

Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>

> Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
> v4: add maintainer Philipp
> v3: add Reviewed-by Rob
> v2: fix binding check warning of reg in example
> ---
>  .../display/mediatek/mediatek,hdmi.txt        | 18 +---
>  .../bindings/phy/mediatek,hdmi-phy.yaml       | 92 +++++++++++++++++++
>  2 files changed, 93 insertions(+), 17 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/mediatek,hdmi-p=
hy.yaml
>
> diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,=
hdmi.txt b/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi=
.txt
> index 6b1c586403e4..b284ca51b913 100644
> --- a/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.tx=
t
> +++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,hdmi.tx=
t
> @@ -53,23 +53,7 @@ Required properties:
>
>  HDMI PHY
>  =3D=3D=3D=3D=3D=3D=3D=3D
> -
> -The HDMI PHY serializes the HDMI encoder's three channel 10-bit parallel
> -output and drives the HDMI pads.
> -
> -Required properties:
> -- compatible: "mediatek,<chip>-hdmi-phy"
> -- the supported chips are mt2701, mt7623 and mt8173
> -- reg: Physical base address and length of the module's registers
> -- clocks: PLL reference clock
> -- clock-names: must contain "pll_ref"
> -- clock-output-names: must be "hdmitx_dig_cts" on mt8173
> -- #phy-cells: must be <0>
> -- #clock-cells: must be <0>
> -
> -Optional properties:
> -- mediatek,ibias: TX DRV bias current for <1.65Gbps, defaults to 0xa
> -- mediatek,ibias_up: TX DRV bias current for >1.65Gbps, defaults to 0x1c
> +See phy/mediatek,hdmi-phy.yaml
>
>  Example:
>
> diff --git a/Documentation/devicetree/bindings/phy/mediatek,hdmi-phy.yaml=
 b/Documentation/devicetree/bindings/phy/mediatek,hdmi-phy.yaml
> new file mode 100644
> index 000000000000..4752517a1446
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/mediatek,hdmi-phy.yaml
> @@ -0,0 +1,92 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (c) 2020 MediaTek
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/phy/mediatek,hdmi-phy.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek High Definition Multimedia Interface (HDMI) PHY binding
> +
> +maintainers:
> +  - Chun-Kuang Hu <chunkuang.hu@kernel.org>
> +  - Philipp Zabel <p.zabel@pengutronix.de>
> +  - Chunfeng Yun <chunfeng.yun@mediatek.com>
> +
> +description: |
> +  The HDMI PHY serializes the HDMI encoder's three channel 10-bit parall=
el
> +  output and drives the HDMI pads.
> +
> +properties:
> +  $nodename:
> +    pattern: "^hdmi-phy@[0-9a-f]+$"
> +
> +  compatible:
> +    enum:
> +      - mediatek,mt2701-hdmi-phy
> +      - mediatek,mt7623-hdmi-phy
> +      - mediatek,mt8173-hdmi-phy
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: PLL reference clock
> +
> +  clock-names:
> +    items:
> +      - const: pll_ref
> +
> +  clock-output-names:
> +    items:
> +      - const: hdmitx_dig_cts
> +
> +  "#phy-cells":
> +    const: 0
> +
> +  "#clock-cells":
> +    const: 0
> +
> +  mediatek,ibias:
> +    description:
> +      TX DRV bias current for < 1.65Gbps
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 63
> +    default: 0xa
> +
> +  mediatek,ibias_up:
> +    description:
> +      TX DRV bias current for >=3D 1.65Gbps
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    minimum: 0
> +    maximum: 63
> +    default: 0x1c
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-names
> +  - clock-output-names
> +  - "#phy-cells"
> +  - "#clock-cells"
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/mt8173-clk.h>
> +    hdmi_phy: hdmi-phy@10209100 {
> +        compatible =3D "mediatek,mt8173-hdmi-phy";
> +        reg =3D <0x10209100 0x24>;
> +        clocks =3D <&apmixedsys CLK_APMIXED_HDMI_REF>;
> +        clock-names =3D "pll_ref";
> +        clock-output-names =3D "hdmitx_dig_cts";
> +        mediatek,ibias =3D <0xa>;
> +        mediatek,ibias_up =3D <0x1c>;
> +        #clock-cells =3D <0>;
> +        #phy-cells =3D <0>;
> +    };
> +
> +...
> --
> 2.18.0
>
