Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29D51D7D3A
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgERPpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:45:55 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41615 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgERPpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:45:54 -0400
Received: by mail-oi1-f195.google.com with SMTP id 19so9359277oiy.8;
        Mon, 18 May 2020 08:45:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/f/rHROcvUhCw63I5sVVKyGk9toPKIj6soJfQz2EyMk=;
        b=qLeGB4aOl/w5JiRu8iF/OJTmVYQEoafdZUarQZDWXzAC0yq26tJtbUclmzHMpF5CLN
         s4ii1ZweH8SwgT5fzQWSzcO11IYhLuPFk8kj6EUxdGVVzsYVvwH8X7CxjtA6Op36SUgm
         RK2Uxi6fImrCYS+e23jnhkAEWL+TTDD5w1uvO0FuxitaqszyvZUelHifa26i1gyTz6Fc
         AF95uVFYYY7uoIi22QuMZxWRfQn1CWqVVvfrRWW6MYh9T+o5fz19yfaPy7hoFu1QoG9F
         E3NKPBr7e6oq/5Mr6wymi33+Jp0vtfA263Rag5YGl24sYLt5iqsdNrz+2OGdhIw9uPce
         cZ9g==
X-Gm-Message-State: AOAM531QikCru4ApAVm0boY8/2y+33noCex7rbsYb4RqJf4uaC2prQET
        /puod+lhyUKC+M8xb7r261HYweorV2wv65kQbtk=
X-Google-Smtp-Source: ABdhPJwSk1XfmEg5VHimLrZlcq2vUCKSvy8da0C+Vb1NpLhDq1xPj9z+Pbn4JqCRj9XUaY6QJTN5Vm86GhCvioFXK6Y=
X-Received: by 2002:a05:6808:1:: with SMTP id u1mr18216oic.54.1589816752210;
 Mon, 18 May 2020 08:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdVV+2HsgmBytCOFg4pri4XinT_SPWT_Ac6n7FMZN3dR3w@mail.gmail.com>
 <CA+V-a8tmG1LKYqbc7feGZQO2Tj5RCpNUHi9e19vPr+bED0KOyQ@mail.gmail.com>
 <9ab946d2-1076-ed92-0a48-9a95d798d291@cogentembedded.com> <CA+V-a8uuP9d6dNeRpn3O0_aOc15CqWoh0bbAfYze1_hn0dCh8g@mail.gmail.com>
In-Reply-To: <CA+V-a8uuP9d6dNeRpn3O0_aOc15CqWoh0bbAfYze1_hn0dCh8g@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 17:45:40 +0200
Message-ID: <CAMuHMdVkf8vGL-769PvfTkMV=yuqW_V8gjo_ZfwEHVkdDWGTyw@mail.gmail.com>
Subject: Re: [PATCH 17/17] ARM: dts: r8a7742: Add RWDT node
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
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

On Mon, May 18, 2020 at 3:23 PM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> On Mon, May 18, 2020 at 2:17 PM Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com> wrote:
> > On 18.05.2020 15:27, Lad, Prabhakar wrote:
> > >>> Add a device node for the Watchdog Timer (RWDT) controller on the Renesas
> > >>> RZ/G1H (r8a7742) SoC.
> > >>>
> > >>> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > >>> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> > >>
> > >> Thanks for your patch!
> > >>
> > >>> --- a/arch/arm/boot/dts/r8a7742.dtsi
> > >>> +++ b/arch/arm/boot/dts/r8a7742.dtsi
> > >>> @@ -201,6 +201,16 @@
> > >>>                  #size-cells = <2>;
> > >>>                  ranges;
> > >>>
> > >>> +               rwdt: watchdog@e6020000 {
> > >>> +                       compatible = "renesas,r8a7742-wdt",
> > >>> +                                    "renesas,rcar-gen2-wdt";
> > >>> +                       reg = <0 0xe6020000 0 0x0c>;
> > >>> +                       clocks = <&cpg CPG_MOD 402>;
> > >>> +                       power-domains = <&sysc R8A7742_PD_ALWAYS_ON>;
> > >>> +                       resets = <&cpg 402>;
> > >>> +                       status = "disabled";
> > >>
> > >> Missing "interrupts" property.
> > >>
> > > "interrupts" property isn't used by rwdt driver  and can be dropped
> > > from bindings file.
> >
> >     DT describes the hardware, not its driver's abilities.

Thanks for chiming in, Sergei!

> Agreed will add, I had followed it on similar lines of r8a7743/44.

Yeah. I know it's missing for a few other SoCs, too.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
