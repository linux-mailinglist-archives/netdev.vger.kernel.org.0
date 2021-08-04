Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9263DFC85
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 10:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbhHDIMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 04:12:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbhHDIMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 04:12:00 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AFCC0613D5;
        Wed,  4 Aug 2021 01:11:47 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id z18so2777662ybg.8;
        Wed, 04 Aug 2021 01:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jPCIyaMUeP4YlX+eHOCe2Hk3dvS6J1yRREr3ZpK8PqE=;
        b=mBZXRCJ9MZQM0MB8te1m5lfQcuzIgUJPb7Xs16M5wRmELRwp69N0rffDJeMYpwoJSx
         VBM2jPH21DzzbruKOFYOTj4bKoPSSf8vJM0U4XZXPhpBThjCPGkzkiwUy1Q8QJBBVpC0
         zPTZx8HLYHgQPvyFr8UIXLql7GnJMC9WuMtoHRkE/QT6lC1h0Lhwrz77ncevHQ8BlZ63
         PvpTOtoG5SPZnOqNsRZkq+nwd5ohsAVeFnQQsPFOwJ+HwB28SaS+gYx8FHLy6TEGt4Jo
         AvSqmPOr7CKNEy0JjDP+eBvGiAmKGyngDilCjhDGX6JJPoYj4Zge1ChrJmnf3kvGi/lr
         nagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jPCIyaMUeP4YlX+eHOCe2Hk3dvS6J1yRREr3ZpK8PqE=;
        b=ORfUHKGfyEc9EVIdbEaqg0Y6ZlxHuwy8cdg6Klf3Z2zZkOGQbJjm2b5trw45/TGB6V
         3F4PhFo1tqOfhdNXbV8B7rquytD3K/NdGRNY93qcQj5aK7qYY/WJqqdCfQOj/wM1Bsqv
         qyGWOHQnkMhTLxSmNapS7vdVsQy3sge8v9QcHNbmGW+0xy3MYX+EEsTk8N9hDhmM9Jto
         K40HINA9brFh1QE+r59k9mD+GviWpuNIFqhMTQ+UYk9B0RUfsd1w1CaqWi1UKlRHOa/B
         Mib3W39KQzwpITBw8J0ko1fUFxO9ylpl10FNjFJiKX4BZyCxPOxALYH21QyXfg9IaDvj
         05aQ==
X-Gm-Message-State: AOAM5336cXm0gwlIPxoVFN6t0/P7KLkOioy1/WoS2ZEwIuD7pjEZg3Fu
        gr6pCkymK2XuhfHMr0ZXc0IajqozokJRwW5VEVI=
X-Google-Smtp-Source: ABdhPJw64BR7H6H44pztlxskpaS2F1m6uWL8/z1U+9L2hJwCQ7r3CCvgZV8iT0vTOh9BsbeOkyUYAKMiJMIJWlqew6Q=
X-Received: by 2002:a25:e404:: with SMTP id b4mr34296150ybh.426.1628064706525;
 Wed, 04 Aug 2021 01:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-4-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210804075855.2vjvfb67kufiibqx@pengutronix.de>
In-Reply-To: <20210804075855.2vjvfb67kufiibqx@pengutronix.de>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Wed, 4 Aug 2021 09:11:20 +0100
Message-ID: <CA+V-a8tWMVfnS3PWeOSqtDddO-M6zDS+WFpUSjv=2MgUV56Qvg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] arm64: dts: renesas: r9a07g044: Add CANFD node
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>
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

On Wed, Aug 4, 2021 at 8:59 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 27.07.2021 14:30:22, Lad Prabhakar wrote:
> > Add CANFD node to R9A07G044 (RZ/G2L) SoC DTSI.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > ---
> >  arch/arm64/boot/dts/renesas/r9a07g044.dtsi | 41 ++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >
> > diff --git a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
> > index 9a7489dc70d1..51655c09f1f8 100644
> > --- a/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
> > +++ b/arch/arm64/boot/dts/renesas/r9a07g044.dtsi
> > @@ -13,6 +13,13 @@
> >       #address-cells = <2>;
> >       #size-cells = <2>;
> >
> > +     /* External CAN clock - to be overridden by boards that provide it */
> > +     can_clk: can {
> > +             compatible = "fixed-clock";
> > +             #clock-cells = <0>;
> > +             clock-frequency = <0>;
> > +     };
> > +
> >       /* clock can be either from exclk or crystal oscillator (XIN/XOUT) */
> >       extal_clk: extal {
> >               compatible = "fixed-clock";
> > @@ -89,6 +96,40 @@
> >                       status = "disabled";
> >               };
> >
> > +             canfd: can@10050000 {
> > +                     compatible = "renesas,r9a07g044-canfd", "renesas,rzg2l-canfd";
> > +                     reg = <0 0x10050000 0 0x8000>;
> > +                     interrupts = <GIC_SPI 426 IRQ_TYPE_LEVEL_HIGH>,
> > +                                  <GIC_SPI 427 IRQ_TYPE_LEVEL_HIGH>,
> > +                                  <GIC_SPI 422 IRQ_TYPE_LEVEL_HIGH>,
> > +                                  <GIC_SPI 424 IRQ_TYPE_LEVEL_HIGH>,
> > +                                  <GIC_SPI 428 IRQ_TYPE_LEVEL_HIGH>,
> > +                                  <GIC_SPI 423 IRQ_TYPE_LEVEL_HIGH>,
> > +                                  <GIC_SPI 425 IRQ_TYPE_LEVEL_HIGH>,
> > +                                  <GIC_SPI 429 IRQ_TYPE_LEVEL_HIGH>;
> > +                     interrupt-names = "g_err", "g_recc",
> > +                                       "ch0_err", "ch0_rec", "ch0_trx",
> > +                                       "ch1_err", "ch1_rec", "ch1_trx";
> > +                     clocks = <&cpg CPG_MOD R9A07G044_CANFD_PCLK>,
> > +                              <&cpg CPG_CORE R9A07G044_CLK_P0_DIV2>,
> > +                              <&can_clk>;
> > +                     clock-names = "fck", "canfd", "can_clk";
> > +                     assigned-clocks = <&cpg CPG_CORE R9A07G044_CLK_P0_DIV2>;
> > +                     assigned-clock-rates = <50000000>;
> > +                     resets = <&cpg R9A07G044_CANFD_RSTP_N>,
> > +                              <&cpg R9A07G044_CANFD_RSTC_N>;
> > +                     reset-names = "rstp_n", "rstc_n";
> > +                     power-domains = <&cpg>;
> > +                     status = "disabled";
> > +
> > +                     channel0 {
> > +                             status = "disabled";
> > +                     };
> > +                     channel1 {
> > +                             status = "disabled";
> > +                     };
> > +             };
> > +
> >               i2c0: i2c@10058000 {
> >                       #address-cells = <1>;
> >                       #size-cells = <0>;
>
> This doesn't apply to net-next/master, the r9a07g044.dtsi doesn't have a
> i2c0 node at all. There isn't a i2c0 node in Linus' master branch, yet.
>
I had based the patch on top [1] (sorry I should have mentioned the
dependency), usually Geert picks up the DTS/I patches and queues it
via ARM tree. Shall I rebase it on net-next and re-send ?

@Geert Uytterhoeven Is that OK ?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-devel.git/log/?h=renesas-arm-dt-for-v5.15

Cheers,
Prabhakar

> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
