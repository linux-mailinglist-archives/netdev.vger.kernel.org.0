Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E9D1DEFD0
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 21:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbgEVTPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 15:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730840AbgEVTPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 15:15:14 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3549C061A0E;
        Fri, 22 May 2020 12:15:13 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id s198so10225376oie.6;
        Fri, 22 May 2020 12:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hVx1XifLiqzcR3aQze/vFy6FED+f9dHS5bmNRNU3BI4=;
        b=DODxib5KAH/Nd+AyiGl825EhHvcG4yhTievh7rjSrX3My7cKppuNLNm8NxaL3YwXot
         T/MOQsMI0rDLqClT+6RoK8ZpEIAqzowtQSPxfuBHtkixZbrXKvtz4bAB0LsmB9CPJdPe
         PSiPJbv/0CXYjS9HuKP29lklEtuQSIP4enu9s40ncQUNJfhEmPoAldw0XuGYYUwtT0kJ
         C/ZevB8jaweU1tyRwD52p556RsTJHJP3t/vtIFDyF0MmO7YyQpIWkgOMUhuD/giJJzQq
         YQCn73IsOX8xTjpodE9srWBXvJxmALphyESoL6hMrk4kNeewgof8srdZWBrrmb909EBK
         t3kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hVx1XifLiqzcR3aQze/vFy6FED+f9dHS5bmNRNU3BI4=;
        b=G9cBUvcr5d1+oDOJATPZKdvUuDvhC7O4KPhir6kDW8+u4SLl+DU1dK/NET1pu8CHKg
         o+aHfSkgGnjx+qA5KHyjdwHMVsVlCBTyGDod20h920qK3tTkw+HxBX4+4XfO3raVbGtO
         XJGa+r0rzlCsk/RmBsmQbgmVIowfKHYgR8x34ixM+tvnX8yTOyFyd96Cqpmz6of17bns
         9m88lftVAmXxJbjCIM3PosRy0Qcjd74ZRfvIsl0EDyP1vWsjZjt7SLoSGLSri3AInvqq
         Ort+DQ0zMUiR30te0DNsZXjrbTChF4jVgHMUn6LR0HoK8989qE5YOqvLlrurZ4/QgYiy
         Ne5A==
X-Gm-Message-State: AOAM533dsFlP3GJ2vprbxyGkLC+JRM0SAUmv1KyZRJDzfdVwIDgpVzIj
        KhL3z1nOWUX+ZHHo3f1e7c/hMR0XOny7+YM3RUY=
X-Google-Smtp-Source: ABdhPJw6Z5oNxrJWWe2Z/VJ2dyoZ1svG+k7EHt8Gg0jkoo++Q6jrBStOvw/KaCbC6YON1Bc8ZAZfRDt4pi6Pp4vKXfo=
X-Received: by 2002:aca:f550:: with SMTP id t77mr3774172oih.8.1590174913262;
 Fri, 22 May 2020 12:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200515171031.GB19423@ninjato> <CA+V-a8t6rPs4s8uMCpBQEAUvwsVn7Cte-vX3z2atWRhy_RFLQw@mail.gmail.com>
 <20200518092601.GA3268@ninjato> <CAMuHMdVWe1EEAtP64VW+0zXNingM1LiENv_Rfz5qTQ+C0dtGSw@mail.gmail.com>
In-Reply-To: <CAMuHMdVWe1EEAtP64VW+0zXNingM1LiENv_Rfz5qTQ+C0dtGSw@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Fri, 22 May 2020 20:14:45 +0100
Message-ID: <CA+V-a8tVx6D8Vh=rYD2=Z-14GAW0puo009FtjYM++sw8PAtJug@mail.gmail.com>
Subject: Re: [PATCH 03/17] ARM: dts: r8a7742: Add I2C and IIC support
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
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

Hi Wolfram,

On Mon, May 18, 2020 at 11:10 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Wolfram,
>
> On Mon, May 18, 2020 at 11:26 AM Wolfram Sang
> <wsa+renesas@sang-engineering.com> wrote:
> > > > However, both versions (with and without automatic transmission) are
> > > > described with the same "renesas,iic-r8a7742" compatible. Is it possible
> > > > to detect the reduced variant at runtime somehow?
> > > >
> > > I couldn't find anything the manual that would be useful to detect at runtime.
>
> Hence if we really need that (see below), we need a quirk based on compatible
> value + base address.
>
> > > > My concern is that the peculiarity of this SoC might be forgotten if we
> > > > describe it like this and ever add "automatic transmissions" somewhen.
> > > >
> > > Agreed.
> >
> > Well, I guess reading from a register which is supposed to not be there
> > on the modified IP core is too hackish.
>
> According to the Hardware User's Manual Rev. 1.00, the registers do exist
> on all RZ/G1, except for RZ/G1E (see below).
>
>    "(automatic transmission can be used as a hardware function, but this is
>     not meaningful for actual use cases)."
>
> (whatever that comment may mean?)
>
> > Leaves us with a seperate compatible entry for it?
>
> On R-Car E3 and RZ/G2E, which have a single IIC instance, we
> handled that by:
>
>         The r8a77990 (R-Car E3) and r8a774c0 (RZ/G2E)
>         controllers are not considered compatible with
>         "renesas,rcar-gen3-iic" or "renesas,rmobile-iic"
>         due to the absence of automatic transmission registers.
>
> On R-Car E2 and RZ/G1E, we forgot, and used both SoC-specific and
> family-specific compatible values.
>
What are your thoughts on the above.

Cheers,
--Prabhakar

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
