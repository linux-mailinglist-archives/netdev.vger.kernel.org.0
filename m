Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FA51D7893
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 14:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgERM2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 08:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgERM2E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 08:28:04 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF748C061A0C;
        Mon, 18 May 2020 05:28:03 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id 19so8779290oiy.8;
        Mon, 18 May 2020 05:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knD02Z+9tC//YVd/yYg62jSva7tZ6kZO0J1cHOboZm0=;
        b=tyJZJSdScYatoaiD3+nk8CaRyh/JcfmnCgYlKTcucGjbqGbNfJuy/pfaeFbWIiPvAE
         Sn8UvhLxfP7wDSCX5CFCI/uWIPmOMWwv5D2RLwMwD2Emng16expUeCaEKjbsgCWOgjAz
         RZx3PDskmOhc2BvEfg3adwjssmO0Bju9slSd+an6tw851Oh0t4/EEvxoMLWvE1ymqY29
         GBYHNvJ1XhiTPz8BwcBUPjr1/BNQl6fgddkDDeSd/EMbIeDscKxA0WmyBMO6mbluT+YD
         nowhn8OeLyNEVShUCCuaDVn/IFhpufgHp6oDyPXDtcaqdU+nkLga/mtxwLHyvR+v0AIB
         U0FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=knD02Z+9tC//YVd/yYg62jSva7tZ6kZO0J1cHOboZm0=;
        b=RMmeitidF0VFigiYzwAVTww5NeCztTBeux3D067yWghIRHIl0rC7zaGPogmzr+DfSd
         95KRDndpwHgteZb02iYatrp8lJ83OxRmuZm16rX6XVOSufP5pAsCfLvyMBKX1MXWf+qs
         zfI5zknvbiJmt1Fe/N3NCN0nZFiepKMrfsQwjYkuT3V6hprMbaeqBe5bfOT4n6a8hXxt
         Z7suuKEgDAdpX0wPyjPHYBrqjpXCa4ujQylZQGWn/6mrNrQjixBidimQmbhwzcVkWazO
         b/ljSz9Wpmo41P0TfIE+iLSTLeuR28+kVNJXvXLbPCWQ8DTKgOvAU6mH6edwgxk/plMA
         J52w==
X-Gm-Message-State: AOAM533iGzbZdwAavS2lIPIOk3FheZWNQUYxzEVSN0FCb04Q+MTEB1SF
        WH8mJEW1AuiQ90HTrbaQHi8h5hJfPWl2YKKlNyE=
X-Google-Smtp-Source: ABdhPJzZ2lS0ejqPsWuIGn043vBk+9V7Kj1deZdI5q/OaKt45cHvC56EYzI/9nBuanFZEV1fpAhD/jFUNkKMy5Tat5g=
X-Received: by 2002:a05:6808:106:: with SMTP id b6mr4197157oie.142.1589804882884;
 Mon, 18 May 2020 05:28:02 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdVV+2HsgmBytCOFg4pri4XinT_SPWT_Ac6n7FMZN3dR3w@mail.gmail.com>
In-Reply-To: <CAMuHMdVV+2HsgmBytCOFg4pri4XinT_SPWT_Ac6n7FMZN3dR3w@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Mon, 18 May 2020 13:27:36 +0100
Message-ID: <CA+V-a8tmG1LKYqbc7feGZQO2Tj5RCpNUHi9e19vPr+bED0KOyQ@mail.gmail.com>
Subject: Re: [PATCH 17/17] ARM: dts: r8a7742: Add RWDT node
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thank you for the review.

On Mon, May 18, 2020 at 12:47 PM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Fri, May 15, 2020 at 5:10 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > Add a device node for the Watchdog Timer (RWDT) controller on the Renesas
> > RZ/G1H (r8a7742) SoC.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> Thanks for your patch!
>
> > --- a/arch/arm/boot/dts/r8a7742.dtsi
> > +++ b/arch/arm/boot/dts/r8a7742.dtsi
> > @@ -201,6 +201,16 @@
> >                 #size-cells = <2>;
> >                 ranges;
> >
> > +               rwdt: watchdog@e6020000 {
> > +                       compatible = "renesas,r8a7742-wdt",
> > +                                    "renesas,rcar-gen2-wdt";
> > +                       reg = <0 0xe6020000 0 0x0c>;
> > +                       clocks = <&cpg CPG_MOD 402>;
> > +                       power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
> > +                       resets = <&cpg 402>;
> > +                       status = "disabled";
>
> Missing "interrupts" property.
>
"interrupts" property isn't used by rwdt driver  and can be dropped
from bindings file.

Cheers,
--Prabhakar

> > +               };
> > +
> >                 gpio0: gpio@e6050000 {
> >                         compatible = "renesas,gpio-r8a7742",
> >                                      "renesas,rcar-gen2-gpio";
>
> The rest looks fine, so with the above fixed:
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
