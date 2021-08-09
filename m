Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1918A3E4612
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 15:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhHINGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 09:06:04 -0400
Received: from mail-vs1-f42.google.com ([209.85.217.42]:43684 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbhHINGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 09:06:03 -0400
Received: by mail-vs1-f42.google.com with SMTP id s196so4885262vsc.10;
        Mon, 09 Aug 2021 06:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9BYczZr0yfjAeAsaFmWRSoq/nggtxlu5P8r6E3vGSE8=;
        b=Q0O2f/4CLACL0iYk6YVYX8QoHGArHZyP5plDjIj5fzZ9/8GYkoXFlQOUjT3odHZiSm
         6AVKhcjlAn1iyqDoYMSGGV2leVDVndWFYBYqWYGs2AoXBQLVguV6K6HSGL3QysSCHxYd
         aiG4Ojb6cNbu1wOOtz7UxKTaIo1Ec2nuAPpY6hwfoFlxSQtelGf/SqHHMiPW5NLsi2IZ
         k4WuHUqxUTxkRm4EZ/qfxtypATIJ84QguJWTsfg+Ln4dMXHJLbOJ+ZY10tvhOWk9sDci
         8OcTvj6ya2U3u1n3G7dtGaZUcnRo7cUu4iQIz9SBrRKUYTqxsvwrj/UjqzzhNnMfdTjC
         GXQA==
X-Gm-Message-State: AOAM532xuvesAYW32KZgfQ/Rg+pYjxFv8mLgQgN/mU9Ey8mTK3UNtY7t
        xw4dZxoScPS/QpsXQl7RYsYeO2Zut7WALvdKwO0=
X-Google-Smtp-Source: ABdhPJzVo62iWNM+kZ4l3hKNVIhLmyg5P6ZvsJ36M+BaOA89mgFS0yHN3LM/mc7B0rbMG+P6pStB6JLNHvBOAgTqGek=
X-Received: by 2002:a67:b604:: with SMTP id d4mr8931798vsm.40.1628514341988;
 Mon, 09 Aug 2021 06:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210804075855.2vjvfb67kufiibqx@pengutronix.de> <CA+V-a8tWMVfnS3PWeOSqtDddO-M6zDS+WFpUSjv=2MgUV56Qvg@mail.gmail.com>
In-Reply-To: <CA+V-a8tWMVfnS3PWeOSqtDddO-M6zDS+WFpUSjv=2MgUV56Qvg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 9 Aug 2021 15:05:30 +0200
Message-ID: <CAMuHMdU5q0_gC7e_n=+Nq-1q2OkOvEB_iY7bMRnB0ZAcOZk9Eg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] arm64: dts: renesas: r9a07g044: Add CANFD node
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Wed, Aug 4, 2021 at 10:11 AM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> On Wed, Aug 4, 2021 at 8:59 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > On 27.07.2021 14:30:22, Lad Prabhakar wrote:
> > > Add CANFD node to R9A07G044 (RZ/G2L) SoC DTSI.
> > >
> > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > ---
> > >  arch/arm64/boot/dts/renesas/r9a07g044.dtsi | 41 ++++++++++++++++++++++
> > >  1 file changed, 41 insertions(+)
> > >
> > > diff --git a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
> > > index 9a7489dc70d1..51655c09f1f8 100644
> > > --- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
> > > +++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
> > > @@ -13,6 +13,13 @@
> > >       #address-cells = <2>;
> > >       #size-cells = <2>;
> > >
> > > +     /* External CAN clock - to be overridden by boards that provide it */
> > > +     can_clk: can {
> > > +             compatible = "fixed-clock";
> > > +             #clock-cells = <0>;
> > > +             clock-frequency = <0>;
> > > +     };
> > > +
> > >       /* clock can be either from exclk or crystal oscillator (XIN/XOUT) */
> > >       extal_clk: extal {
> > >               compatible = "fixed-clock";
> > > @@ -89,6 +96,40 @@
> > >                       status = "disabled";
> > >               };
> > >
> > > +             canfd: can@10050000 {
> > > +                     compatible = "renesas,r9a07g044-canfd", "renesas,rzg2l-canfd";
> > > +                     reg = <0 0x10050000 0 0x8000>;
> > > +                     interrupts = <GIC_SPI 426 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                  <GIC_SPI 427 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                  <GIC_SPI 422 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                  <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                  <GIC_SPI 428 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                  <GIC_SPI 423 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                  <GIC_SPI 425 IRQ_TYPE_LEVEL_HIGH>,
> > > +                                  <GIC_SPI 429 IRQ_TYPE_LEVEL_HIGH>;
> > > +                     interrupt-names = "g_err", "g_recc",
> > > +                                       "ch0_err", "ch0_rec", "ch0_trx",
> > > +                                       "ch1_err", "ch1_rec", "ch1_trx";
> > > +                     clocks = <&cpg CPG_MOD R9A07G044_CANFD_PCLK>,
> > > +                              <&cpg CPG_CORE R9A07G044_CLK_P0_DIV2>,
> > > +                              <&can_clk>;
> > > +                     clock-names = "fck", "canfd", "can_clk";
> > > +                     assigned-clocks = <&cpg CPG_CORE R9A07G044_CLK_P0_DIV2>;
> > > +                     assigned-clock-rates = <50000000>;
> > > +                     resets = <&cpg R9A07G044_CANFD_RSTP_N>,
> > > +                              <&cpg R9A07G044_CANFD_RSTC_N>;
> > > +                     reset-names = "rstp_n", "rstc_n";
> > > +                     power-domains = <&cpg>;
> > > +                     status = "disabled";
> > > +
> > > +                     channel0 {
> > > +                             status = "disabled";
> > > +                     };
> > > +                     channel1 {
> > > +                             status = "disabled";
> > > +                     };
> > > +             };
> > > +
> > >               i2c0: i2c@10058000 {
> > >                       #address-cells = <1>;
> > >                       #size-cells = <0>;
> >
> > This doesn't apply to net-next/master, the r9a07g044.dtsi doesn't have a
> > i2c0 node at all. There isn't a i2c0 node in Linus' master branch, yet.
> >
> I had based the patch on top [1] (sorry I should have mentioned the
> dependency), usually Geert picks up the DTS/I patches and queues it
> via ARM tree. Shall I rebase it on net-next and re-send ?
>
> @Geert Uytterhoeven Is that OK ?

Please do not take Renesas DTS patches through the netdev tree
(or any other subsystem tree).

> [1] https://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-devel.git/log/?h=renesas-arm-dt-for-v5.15


Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
