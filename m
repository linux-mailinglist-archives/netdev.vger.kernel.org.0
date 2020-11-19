Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EDC2B9E92
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgKSXiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 18:38:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727028AbgKSXix (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 18:38:53 -0500
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B29C022248;
        Thu, 19 Nov 2020 23:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605829133;
        bh=XJSKtvpgEybgfJcO0SJsTybzoZJuV4CZibv1f3Vm9Q4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=1w6tnffGLWdZheAqgLLRjoFP66HuyXPIcYm238SHq4vJaaDHD5I/G2qoN9AynmR/r
         Zfb0giKkohOvZdwTIHwba6fSf5YO0MvGzc1EQg2mdbXbtn35bBh1NIBbwZLTpYF30i
         dWzoExbrSn5VYaFfD9LEkGHVXdH8mjuOVKAiD6EI=
Received: by mail-ej1-f47.google.com with SMTP id lv15so4510548ejb.12;
        Thu, 19 Nov 2020 15:38:52 -0800 (PST)
X-Gm-Message-State: AOAM531I2WqeosR08ojhNM75lCRmCKRP1ruoJexoJBLCNf4h6zUD1wBO
        buYQ5el9o2bZ7x64krLpVQglleWZgaYacwM1hA==
X-Google-Smtp-Source: ABdhPJyCTosQ1GLHfnPlHYYUBtA/b5PCwSHB1U+bWLkPDbn0q/TbtAXAoCGE19frEgpV/RtrhRZkovX5D61bPOn2L44=
X-Received: by 2002:a17:906:6a4e:: with SMTP id n14mr13380254ejs.194.1605829131052;
 Thu, 19 Nov 2020 15:38:51 -0800 (PST)
MIME-Version: 1.0
References: <20201118082126.42701-1-chunfeng.yun@mediatek.com> <20201118082126.42701-7-chunfeng.yun@mediatek.com>
In-Reply-To: <20201118082126.42701-7-chunfeng.yun@mediatek.com>
From:   Chun-Kuang Hu <chunkuang.hu@kernel.org>
Date:   Fri, 20 Nov 2020 07:38:41 +0800
X-Gmail-Original-Message-ID: <CAAOTY_81uZ7MY1ZyfsyYL_62wkNvG2VCT3+G4Zr1bZBG9_Yg1w@mail.gmail.com>
Message-ID: <CAAOTY_81uZ7MY1ZyfsyYL_62wkNvG2VCT3+G4Zr1bZBG9_Yg1w@mail.gmail.com>
Subject: Re: [PATCH v3 07/11] dt-bindings: phy: convert MIP DSI PHY binding to
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
> Convert MIPI DSI PHY binding to YAML schema mediatek,dsi-phy.yaml
>
> Cc: Chun-Kuang Hu <chunkuang.hu@kernel.org>
> Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
> ---
> v3: new patch
> ---
>  .../display/mediatek/mediatek,dsi.txt         | 18 +---
>  .../bindings/phy/mediatek,dsi-phy.yaml        | 83 +++++++++++++++++++
>  2 files changed, 84 insertions(+), 17 deletions(-)
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
> index 000000000000..87f8df251ab0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/mediatek,dsi-phy.yaml
> @@ -0,0 +1,83 @@
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
> +  - Chunfeng Yun <chunfeng.yun@mediatek.com>

Please add Philipp Zabel because he is Mediatek DRM driver maintainer.

DRM DRIVERS FOR MEDIATEK
M: Chun-Kuang Hu <chunkuang.hu@kernel.org>
M: Philipp Zabel <p.zabel@pengutronix.de>
L: dri-devel@lists.freedesktop.org
S: Supported
F: Documentation/devicetree/bindings/display/mediatek/

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

Add mediatek,mt8183-mipi-tx

Regards,
Chun-Kuang.

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
> +    description: adjust driving current, the step is 200.
> +    $ref: /schemas/types.yaml#/definitions/uint32
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
