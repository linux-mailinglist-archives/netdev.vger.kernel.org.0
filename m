Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0CB284A3D
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 12:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgJFKRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 06:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbgJFKRS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 06:17:18 -0400
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D0220870;
        Tue,  6 Oct 2020 10:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601979437;
        bh=LjlbuXXwVZiOZnh4s8AiRFzOTD9ANSeAEjirAmE6Ijs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TNdguZjsASN3AhbyCcaIXFW6z4k/3XU5Hmc1yusVyUJx+Ho6rrIzvQM7KUvpKeGNQ
         BTJW96WlaTEyY2T7WpQ5QozEknz60csXY/YjdG8qua52OXo8iXCQ6rHdCHU241BpUN
         OGSBGdIVoZ86xv1cpozwyxSgPrFZ0HvXBhJVBxdc=
Received: by mail-ej1-f44.google.com with SMTP id h24so10236188ejg.9;
        Tue, 06 Oct 2020 03:17:17 -0700 (PDT)
X-Gm-Message-State: AOAM530xwAYN+Rj5qFkbPHSajwUHyAtmfNXrm/NS6HPCWiW6M/FOnlqI
        LWwMelqPMQfAOD0a5uMrHwXjppI0uumUBuqhhwg=
X-Google-Smtp-Source: ABdhPJwlwRJfXM/fE2yWBLSzyxvAdx3iSTpcYDDZzKdj0oQdX9ZBfNiA7FQzsxHAYvDsj3Cf4ThgOgnubFLXNR4lgeA=
X-Received: by 2002:a17:906:5247:: with SMTP id y7mr4228617ejm.503.1601979435624;
 Tue, 06 Oct 2020 03:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20201006100556eucas1p2b69f76968a7a5901b5e9c66338c388d4@eucas1p2.samsung.com>
 <CAJKOXPfQHzFb8uUzu2_X=7Jvk9P-z-jahi6csggpZvGsEhNm6Q@mail.gmail.com> <dleftj362rekjw.fsf%l.stelmach@samsung.com>
In-Reply-To: <dleftj362rekjw.fsf%l.stelmach@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 6 Oct 2020 12:17:02 +0200
X-Gmail-Original-Message-ID: <CAJKOXPePumx3-v7Odp8Fv65gzXFZw+EkZCaX-YE-CYrrmyr-8g@mail.gmail.com>
Message-ID: <CAJKOXPePumx3-v7Odp8Fv65gzXFZw+EkZCaX-YE-CYrrmyr-8g@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: dts: exynos: Add Ethernet to Artik 5 board
To:     Lukasz Stelmach <l.stelmach@samsung.com>
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

On Tue, 6 Oct 2020 at 12:06, Lukasz Stelmach <l.stelmach@samsung.com> wrote=
:
>
> It was <2020-10-03 sob 12:13>, when Krzysztof Kozlowski wrote:
> > On Fri, 2 Oct 2020 at 21:22, =C5=81ukasz Stelmach <l.stelmach@samsung.c=
om> wrote:
> >>
> >> Add node for ax88796c ethernet chip.
> >>
> >> Signed-off-by: =C5=81ukasz Stelmach <l.stelmach@samsung.com>
> >> ---
> >>  arch/arm/boot/dts/exynos3250-artik5-eval.dts | 21 +++++++++++++++++++=
+
> >>  1 file changed, 21 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/exynos3250-artik5-eval.dts b/arch/arm/b=
oot/dts/exynos3250-artik5-eval.dts
> >> index 20446a846a98..7f115c348a2a 100644
> >> --- a/arch/arm/boot/dts/exynos3250-artik5-eval.dts
> >> +++ b/arch/arm/boot/dts/exynos3250-artik5-eval.dts
> >> @@ -37,3 +37,24 @@ &mshc_2 {
> >>  &serial_2 {
> >>         status =3D "okay";
> >>  };
> >> +
> >> +&spi_0 {
> >> +       status =3D "okay";
> >> +       cs-gpios =3D <&gpx3 4 GPIO_ACTIVE_LOW>, <0>;
> >> +
> >> +       assigned-clocks        =3D <&cmu CLK_MOUT_MPLL>, <&cmu CLK_DIV=
_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>,    <&cmu CLK_DIV_SPI0>,  <&cmu CLK_DIV_SP=
I0_PRE>, <&cmu CLK_SCLK_SPI0>;
> >
> > No spaces before or after '=3D'.
> >
>
> You mean " =3D ", don't you?

Ah, of course.

>
> >> + assigned-clock-parents =3D <&cmu CLK_FOUT_MPLL>, <&cmu
> >> CLK_MOUT_MPLL>, <&cmu CLK_DIV_MPLL_PRE>, <&cmu CLK_MOUT_SPI0>, <&cmu
> >> CLK_DIV_SPI0>, <&cmu CLK_DIV_SPI0_PRE>;
> >
> > This line is still too long. Please wrap it at 80. Checkpatch should
> > complain about it... so it seems you did not run it. Please fix all
> > checkpatch issues.
>
> My idea was too keep assigned-clocks and assigned-clock-parrent lines
> aligned, so it is clearly visible which parrent applies to which
> clock. Is it inappropriate?

The line gets too long and in the existing DTSes we wrapped item by
item. Solution could be to add comments, e.g.:
assigned-clock-parents =3D <&cmu CLK_FOUT_MPLL>,
           <&cmu CLK_DIV_MPLL_PRE>, /* for: CLK_DIV_MPLL_PRE */
           <&cmu CLK_MOUT_SPI0>, /* for: CLK_MOUT_SPI0 */

but I am not sure if dtc allows such comments.

Best regards,
Krzysztof
