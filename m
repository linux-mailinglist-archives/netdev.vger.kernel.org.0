Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BB12E22FD
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 01:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgLXA07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 19:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbgLXA07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 19:26:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 229552253D;
        Thu, 24 Dec 2020 00:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608769578;
        bh=+M1lbUD+xDyopTVHLmYYy1DiKuckD477//1o2Xyfiqw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cKqiFBnxBW/9Bca97FAi1dcq6zuWkUDK5KTqyNJJYToD9qDlYHLqjxIf3T3O3j8Z1
         hH8LnScihsM2eV5YFubNpuxC3pCfVzMqw8GHVAHTH4pfCX7CVpIu83qcigSQoRUgqW
         ZGXBj+7Xd9RtSvAZAi4NHUrNFtWHkOhbqZ2pwkzV/B0DECWfc0bTFXFeN26BsGUWEh
         a6l+emj6+FYeIir6UsyMicd8IAMrJA59rQdBzUmV8nUOWRSDHSLXC6nV/eZaNQjh6N
         4wAQQdH/BKR0ZqdstdMtsGpp/TEUhk3DG+KMl9jzywT95PxoYEcmy1YqK1VNASXcr3
         SiVOZINXicgpg==
Received: by mail-ej1-f49.google.com with SMTP id j22so1352218eja.13;
        Wed, 23 Dec 2020 16:26:18 -0800 (PST)
X-Gm-Message-State: AOAM533Id0Os3MsJW09w+qg9Z923hqgY1hvy/w8MRl4akV3JbMzuUtik
        QSm+xdyaqT2dss7k6XkNhydix//r5Srt7FREVA==
X-Google-Smtp-Source: ABdhPJwHsZgd5LttS8qKUOjhkwe51JqlcqeCFHvZ1o3TseXFh+pQSS88Zda/jJ4iP9Ets0/7uIN1pA2BZBfIGgUn228=
X-Received: by 2002:a17:906:ae4e:: with SMTP id lf14mr26974962ejb.310.1608769576689;
 Wed, 23 Dec 2020 16:26:16 -0800 (PST)
MIME-Version: 1.0
References: <20201216093012.24406-1-chunfeng.yun@mediatek.com> <20201216093012.24406-7-chunfeng.yun@mediatek.com>
In-Reply-To: <20201216093012.24406-7-chunfeng.yun@mediatek.com>
From:   Chun-Kuang Hu <chunkuang.hu@kernel.org>
Date:   Thu, 24 Dec 2020 08:26:05 +0800
X-Gmail-Original-Message-ID: <CAAOTY_85gH4T2=aziG=Ts7+0iO=dHWEYvVCbMTJ_SY0phyDjKw@mail.gmail.com>
Message-ID: <CAAOTY_85gH4T2=aziG=Ts7+0iO=dHWEYvVCbMTJ_SY0phyDjKw@mail.gmail.com>
Subject: Re: [PATCH v4 07/11] dt-bindings: phy: convert MIPI DSI PHY binding
 to YAML schema
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
> Convert MIPI DSI PHY binding to YAML schema mediatek,dsi-phy.yaml
>

Reviewed-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>

> Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
> Cc: Philipp Zabel <p.zabel@pengutronix.de>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v4:
>   1. add maintainer Philipp add support mt8183 suggested by Chun-Kuang
>   2. use keyword multipleOf suggested by Rob
>   3. fix typo of 'MIPI' in title
>
> v3: new patch
> ---
>  .../display/mediatek/mediatek,dsi.txt         | 18 +---
>  .../bindings/phy/mediatek,dsi-phy.yaml        | 85 +++++++++++++++++++
>  2 files changed, 86 insertions(+), 17 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/phy/mediatek,dsi-ph=
y.yaml
>
> diff --git a/Documentation/devicetree/bindings/display/mediatek/mediatek,=
dsi.txt b/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.t=
xt
> index f06f24d405a5..8238a86686be 100644
> --- a/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.txt
> +++ b/Documentation/devicetree/bindings/display/mediatek/mediatek,dsi.txt
> @@ -22,23 +22,7 @@ Required properties:
>  MIPI TX Configuration Module
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
> -The MIPI TX configuration module controls the MIPI D-PHY.
> -
> -Required properties:
> -- compatible: "mediatek,<chip>-mipi-tx"
> -- the supported chips are mt2701, 7623, mt8173 and mt8183.
> -- reg: Physical base address and length of the controller's registers
> -- clocks: PLL reference clock
> -- clock-output-names: name of the output clock line to the DSI encoder
> -- #clock-cells: must be <0>;
> -- #phy-cells: must be <0>.
> -
> -Optional properties:
> -- drive-strength-microamp: adjust driving current, should be 3000 ~ 6000=
. And
> -                                                  the step is 200.
> -- nvmem-cells: A phandle to the calibration data provided by a nvmem dev=
ice. If
> -               unspecified default values shall be used.
> -- nvmem-cell-names: Should be "calibration-data"
> +See phy/mediatek,dsi-phy.yaml
>
>  Example:
>
> diff --git a/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml =
b/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml
> new file mode 100644
> index 000000000000..71d4acea1f66
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml
> @@ -0,0 +1,85 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (c) 2020 MediaTek
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/phy/mediatek,dsi-phy.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek MIPI Display Serial Interface (DSI) PHY binding
> +
> +maintainers:
> +  - Chun-Kuang Hu <chunkuang.hu@kernel.org>
> +  - Philipp Zabel <p.zabel@pengutronix.de>
> +  - Chunfeng Yun <chunfeng.yun@mediatek.com>
> +
> +description: The MIPI DSI PHY supports up to 4-lane output.
> +
> +properties:
> +  $nodename:
> +    pattern: "^dsi-phy@[0-9a-f]+$"
> +
> +  compatible:
> +    enum:
> +      - mediatek,mt2701-mipi-tx
> +      - mediatek,mt7623-mipi-tx
> +      - mediatek,mt8173-mipi-tx
> +      - mediatek,mt8183-mipi-tx
> +
> +  reg:
> +    maxItems: 1
> +
> +  clocks:
> +    items:
> +      - description: PLL reference clock
> +
> +  clock-output-names:
> +    maxItems: 1
> +
> +  "#phy-cells":
> +    const: 0
> +
> +  "#clock-cells":
> +    const: 0
> +
> +  nvmem-cells:
> +    maxItems: 1
> +    description: A phandle to the calibration data provided by a nvmem d=
evice,
> +      if unspecified, default values shall be used.
> +
> +  nvmem-cell-names:
> +    items:
> +      - const: calibration-data
> +
> +  drive-strength-microamp:
> +    description: adjust driving current
> +    multipleOf: 200
> +    minimum: 2000
> +    maximum: 6000
> +    default: 4600
> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - clock-output-names
> +  - "#phy-cells"
> +  - "#clock-cells"
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/mt8173-clk.h>
> +    dsi-phy@10215000 {
> +        compatible =3D "mediatek,mt8173-mipi-tx";
> +        reg =3D <0x10215000 0x1000>;
> +        clocks =3D <&clk26m>;
> +        clock-output-names =3D "mipi_tx0_pll";
> +        drive-strength-microamp =3D <4000>;
> +        nvmem-cells=3D <&mipi_tx_calibration>;
> +        nvmem-cell-names =3D "calibration-data";
> +        #clock-cells =3D <0>;
> +        #phy-cells =3D <0>;
> +    };
> +
> +...
> --
> 2.18.0
>
