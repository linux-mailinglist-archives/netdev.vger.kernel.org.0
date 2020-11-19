Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1AE2B9EA1
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbgKSXmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 18:42:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726680AbgKSXmt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 18:42:49 -0500
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72CD422254;
        Thu, 19 Nov 2020 23:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605829367;
        bh=JW1A1AIJoN9PpzGhcADx31Z4mx3wWPs74PG/UyKWTyc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WSV37G/uB+kbkh5m4iyZCcetg/i8uGeEVSaynOqAPohVpnxqHuxKuvP/wBMZgh1ci
         ouHmfOT/7dTeLdlrP5cP8tT6hlO22rtZ2FMNwDgTsS9F1z4rDnd6FVcUiLczcTscYf
         iC32Vb8XZCiAl75Ou8QI/5k6bnh8vzIUicztAQVE=
Received: by mail-ed1-f50.google.com with SMTP id e18so7686701edy.6;
        Thu, 19 Nov 2020 15:42:47 -0800 (PST)
X-Gm-Message-State: AOAM530HlfLDeSmhujVoj7LRh1DYMW7R+3XCtWyVmwC+pBOTLvUH/Mjo
        ToyJWVJ+eM6f6T4PvyA10XZDRvBFUxKot82Brw==
X-Google-Smtp-Source: ABdhPJzoOIkdvfjzQ6rnTB9cEDNydznFiETJ7HfdxkLrWoEHgiRI4U2yN3QuxRQN/WPS3HW2x5lbkSbMmlBW5Htu0YE=
X-Received: by 2002:a50:8745:: with SMTP id 5mr32752275edv.49.1605829365718;
 Thu, 19 Nov 2020 15:42:45 -0800 (PST)
MIME-Version: 1.0
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com> <20201118082126.42701-6-chunfeng.yun@mediatek.com>
In-Reply-To: <20201118082126.42701-6-chunfeng.yun@mediatek.com>
From:   Chun-Kuang Hu <chunkuang.hu@kernel.org>
Date:   Fri, 20 Nov 2020 07:42:35 +0800
X-Gmail-Original-Message-ID: <CAAOTY_9dNyySJkyX78tHDQZPaqD+5Jqixbdbohp319FyXO1X5Q@mail.gmail.com>
Message-ID: <CAAOTY_9dNyySJkyX78tHDQZPaqD+5Jqixbdbohp319FyXO1X5Q@mail.gmail.com>
Subject: Re: [PATCH v3 06/11] dt-bindings: phy: convert HDMI PHY binding to
 YAML schema
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
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
        <linux-mediatek@lists.infradead.org>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Chunfeng:

Chunfeng Yun <chunfeng.yun@mediatek.com> =E6=96=BC 2020=E5=B9=B411=E6=9C=88=
18=E6=97=A5 =E9=80=B1=E4=B8=89 =E4=B8=8B=E5=8D=884:21=E5=AF=AB=E9=81=93=EF=
=BC=9A
>
> Convert HDMI PHY binding to YAML schema mediatek,hdmi-phy.yaml
>
> Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
> v3: add Reviewed-by Rob
> v2: fix binding check warning of reg in example
> ---
>  .../display/mediatek/mediatek,hdmi.txt        | 18 +---
>  .../bindings/phy/mediatek,hdmi-phy.yaml       | 91 +++++++++++++++++++
>  2 files changed, 92 insertions(+), 17 deletions(-)
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
> index 000000000000..96700bb8bc00
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/mediatek,hdmi-phy.yaml
> @@ -0,0 +1,91 @@
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
> +  - Chunfeng Yun <chunfeng.yun@mediatek.com>

Please add Philipp Zabel because he is Mediatek DRM driver maintainer.

DRM DRIVERS FOR MEDIATEK
M: Chun-Kuang Hu <chunkuang.hu at kernel.org>
M: Philipp Zabel <p.zabel at pengutronix.de>
L: dri-devel at lists.freedesktop.org
S: Supported
F: Documentation/devicetree/bindings/display/mediatek/

Regards,
Chun-Kuang.

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
