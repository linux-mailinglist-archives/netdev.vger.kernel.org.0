Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19FE3A8C39
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 01:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFOXIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 19:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230481AbhFOXIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 19:08:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3446061350;
        Tue, 15 Jun 2021 23:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623798359;
        bh=gX2OAJ87Zhj6xcJSH+HSb/c9JiEnHEpm9jh8ZOCi7GE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GYVRp0Z6E37g7ELIe7G+wNKp6tynscouCV1P20M8FAHBu5VtK1bhTuQZ0MNScOBy/
         99s1+g4jjndvez16c5jL0LPvCqF6X0UNpKJR24uI2GjvgxTgdRX62oKPCsSYdaWJpM
         tfT9DslNk/fYbSwpeXR2v9o+Y7oyx7mM1YUuX78/jOw6epRJTsZ4+6o0kTlCcT3NCY
         BPj4yYseDb7W10wZ8GouJFeqf7siOXm42cSIJ4n2RrnF3ZfGhHGhrufyNreny97Y6c
         Z0knBUlaqvaQhO4eFdYCz6PRpDa6IEFcBEpEQxcthBbkZZLj2bXbMobitZobmV+bdo
         DmUf7Ci1pKx3Q==
Received: by mail-ej1-f50.google.com with SMTP id og14so451837ejc.5;
        Tue, 15 Jun 2021 16:05:59 -0700 (PDT)
X-Gm-Message-State: AOAM5328b3ebu0SKwjqiHHjl7YR0+41BcxDSNnhBFzr8m6o3+ER8aZUo
        cLbL4QrEBsW8Vpm1NcEpLev8gLOy4ptZvjZcYA==
X-Google-Smtp-Source: ABdhPJzpHvXx18Z/9Nse3ofyzq8kUd/ug4pWPECTHvAcqbbUlWOKZtUfGLRKqUtnaDY1vjPghEZEvjkVMh2l9+9oqSE=
X-Received: by 2002:a17:906:9419:: with SMTP id q25mr1926455ejx.341.1623798357795;
 Tue, 15 Jun 2021 16:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com> <1623690937-52389-2-git-send-email-zhouyanjie@wanyeetech.com>
In-Reply-To: <1623690937-52389-2-git-send-email-zhouyanjie@wanyeetech.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 15 Jun 2021 17:05:45 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+7v6GRMfxWhA6g2r0GaZSO_AztgSz7rheJsE9jKYd8uQ@mail.gmail.com>
Message-ID: <CAL_Jsq+7v6GRMfxWhA6g2r0GaZSO_AztgSz7rheJsE9jKYd8uQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
To:     =?UTF-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/STM32 ARCHITECTURE" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 11:18 AM =E5=91=A8=E7=90=B0=E6=9D=B0 (Zhou Yanjie)
<zhouyanjie@wanyeetech.com> wrote:
>
> Add the dwmac bindings for the JZ4775 SoC, the X1000 SoC,
> the X1600 SoC, the X1830 SoC and the X2000 SoC from Ingenic.
>
> Signed-off-by: =E5=91=A8=E7=90=B0=E6=9D=B0 (Zhou Yanjie) <zhouyanjie@wany=
eetech.com>
> ---
>
> Notes:
>     v1->v2:
>     No change.
>
>     v2->v3:
>     Add "ingenic,mac.yaml" for Ingenic SoCs.
>
>  .../devicetree/bindings/net/ingenic,mac.yaml       | 76 ++++++++++++++++=
++++++
>  .../devicetree/bindings/net/snps,dwmac.yaml        | 15 +++++
>  2 files changed, 91 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ingenic,mac.yam=
l
>
> diff --git a/Documentation/devicetree/bindings/net/ingenic,mac.yaml b/Doc=
umentation/devicetree/bindings/net/ingenic,mac.yaml
> new file mode 100644
> index 00000000..5fe2e81
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ingenic,mac.yaml
> @@ -0,0 +1,76 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ingenic,mac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Bindings for MAC in Ingenic SoCs
> +
> +maintainers:
> +  - =E5=91=A8=E7=90=B0=E6=9D=B0 (Zhou Yanjie) <zhouyanjie@wanyeetech.com=
>
> +
> +description:
> +  The Ethernet Media Access Controller in Ingenic SoCs.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - ingenic,jz4775-mac
> +      - ingenic,x1000-mac
> +      - ingenic,x1600-mac
> +      - ingenic,x1830-mac
> +      - ingenic,x2000-mac
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  interrupt-names:
> +    const: macirq
> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    const: stmmaceth
> +
> +  mode-reg:
> +    description: An extra syscon register that control ethernet interfac=
e and timing delay

Needs a vendor prefix and type.

> +
> +  rx-clk-delay-ps:
> +    description: RGMII receive clock delay defined in pico seconds
> +
> +  tx-clk-delay-ps:
> +    description: RGMII transmit clock delay defined in pico seconds
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - interrupt-names
> +  - clocks
> +  - clock-names
> +  - mode-reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/x1000-cgu.h>
> +
> +    mac: ethernet@134b0000 {
> +        compatible =3D "ingenic,x1000-mac", "snps,dwmac";

Doesn't match the schema.

> +        reg =3D <0x134b0000 0x2000>;
> +
> +        interrupt-parent =3D <&intc>;
> +        interrupts =3D <55>;
> +        interrupt-names =3D "macirq";
> +
> +        clocks =3D <&cgu X1000_CLK_MAC>;
> +        clock-names =3D "stmmaceth";
> +
> +        mode-reg =3D <&mac_phy_ctrl>;
> +    };
> +...
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Docu=
mentation/devicetree/bindings/net/snps,dwmac.yaml
> index 2edd8be..9c0ce92 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -56,6 +56,11 @@ properties:
>          - amlogic,meson8m2-dwmac
>          - amlogic,meson-gxbb-dwmac
>          - amlogic,meson-axg-dwmac
> +        - ingenic,jz4775-mac
> +        - ingenic,x1000-mac
> +        - ingenic,x1600-mac
> +        - ingenic,x1830-mac
> +        - ingenic,x2000-mac
>          - rockchip,px30-gmac
>          - rockchip,rk3128-gmac
>          - rockchip,rk3228-gmac
> @@ -310,6 +315,11 @@ allOf:
>                - allwinner,sun8i-r40-emac
>                - allwinner,sun8i-v3s-emac
>                - allwinner,sun50i-a64-emac
> +              - ingenic,jz4775-mac
> +              - ingenic,x1000-mac
> +              - ingenic,x1600-mac
> +              - ingenic,x1830-mac
> +              - ingenic,x2000-mac
>                - snps,dwxgmac
>                - snps,dwxgmac-2.10
>                - st,spear600-gmac
> @@ -353,6 +363,11 @@ allOf:
>                - allwinner,sun8i-r40-emac
>                - allwinner,sun8i-v3s-emac
>                - allwinner,sun50i-a64-emac
> +              - ingenic,jz4775-mac
> +              - ingenic,x1000-mac
> +              - ingenic,x1600-mac
> +              - ingenic,x1830-mac
> +              - ingenic,x2000-mac
>                - snps,dwmac-4.00
>                - snps,dwmac-4.10a
>                - snps,dwmac-4.20a
> --
> 2.7.4
>
