Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5263C282390
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 12:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbgJCKOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 06:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgJCKOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Oct 2020 06:14:09 -0400
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 668AC20738;
        Sat,  3 Oct 2020 10:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601720048;
        bh=qRvUkj+Z7HtRrE01y1vsySzwjPKH0VMBYkgUjmU+ifg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nnHnpbiPCRfbO0D1ohx7K75obAXoGp3jDf/YiT7rueXeYf9mR3AexVlZiOoHWeVz5
         tUkel4UhCFWcB4wt6otr4QWViyKqvl5I3K9qCmDiaqeIiNoBlKY2fSQ9QtbU1okCtC
         8aZGqaNYJkeB0BkGFbmZJxGBL6nvaxwJwPPvnThQ=
Received: by mail-ed1-f42.google.com with SMTP id dn5so4433829edb.10;
        Sat, 03 Oct 2020 03:14:08 -0700 (PDT)
X-Gm-Message-State: AOAM532mxFNuajalcU1Q58TOOwNJo975SF9BThtdE/x+K9x7bUFe9ztD
        Wm5UtjGF3RjnU1b5JxoyWB0XQWto58aupiZq7lE=
X-Google-Smtp-Source: ABdhPJzfrZqEkCCwj1sZuNMnQ59N/xkyE4DwT0Gvr6zwUOa6/pc8z/bWzQl9H/Af2SmHONHCknS3RSSlNtoYOMRO+KU=
X-Received: by 2002:a50:d0d0:: with SMTP id g16mr1801553edf.18.1601720047001;
 Sat, 03 Oct 2020 03:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20201002192216eucas1p16933608dcb0fb8ceee21caa3455cbaf1@eucas1p1.samsung.com>
 <20201002192210.19967-1-l.stelmach@samsung.com> <20201002192210.19967-4-l.stelmach@samsung.com>
In-Reply-To: <20201002192210.19967-4-l.stelmach@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Sat, 3 Oct 2020 12:13:54 +0200
X-Gmail-Original-Message-ID: <CAJKOXPfQHzFb8uUzu2_X=7Jvk9P-z-jahi6csggpZvGsEhNm6Q@mail.gmail.com>
Message-ID: <CAJKOXPfQHzFb8uUzu2_X=7Jvk9P-z-jahi6csggpZvGsEhNm6Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: exynos: Add Ethernet to Artik 5 board
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
> Add node for ax88796c ethernet chip.
>
> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> ---
>  arch/arm/boot/dts/exynos3250-artik5-eval.dts | 21 ++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos3250-artik5-eval.dts b/arch/arm/boot=
/dts/exynos3250-artik5-eval.dts
> index 20446a846a98..7f115c348a2a 100644
> --- a/arch/arm/boot/dts/exynos3250-artik5-eval.dts
> +++ b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
> @@ -37,3 +37,24 @@ &mshc_2 {
>  &serial_2 {
>         status =3D "okay";
>  };
> +
> +&spi_0 {
> +       status =3D "okay";
> +       cs-gpios =3D <&gpx3 4 GPIO_ACTIVE_LOW>, <0>;
> +
> +       assigned-clocks        =3D <&cmu CLK_MOUT_MPLL>, <&cmu CLK_DIV_MP=
LL_PRE>, <&cmu CLK_MOUT_SPI0>,    <&cmu CLK_DIV_SPI0>,  <&cmu CLK_DIV_SPI0_=
PRE>, <&cmu CLK_SCLK_SPI0>;

No spaces before or after '=3D'.

> +       assigned-clock-parents =3D <&cmu CLK_FOUT_MPLL>, <&cmu CLK_MOUT_M=
PLL>,    <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>, <&cmu CLK_DIV_SPI0>=
,     <&cmu CLK_DIV_SPI0_PRE>;

This line is still too long. Please wrap it at 80. Checkpatch should
complain about it... so it seems you did not run it. Please fix all
checkpatch issues.

> +
> +       ax88796c@0 {
> +               compatible =3D "asix,ax88796c";
> +               local-mac-address =3D [00 00 00 00 00 00]; /* Filled in b=
y a boot-loader */
> +               interrupt-parent =3D <&gpx2>;
> +               interrupts =3D <0 IRQ_TYPE_LEVEL_LOW>;
> +               spi-max-frequency =3D <40000000>;
> +               reg =3D <0x0>;

Put reg after compatible.

Best regards,
Krzysztof
