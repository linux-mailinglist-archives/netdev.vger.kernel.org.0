Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF061E08B2
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbgEYIXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:23:22 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40463 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgEYIXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:23:21 -0400
Received: by mail-oi1-f196.google.com with SMTP id v128so15405092oia.7;
        Mon, 25 May 2020 01:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=28/BUMdFhJjxsxR1feXVFplXDlF+r6hoIsh+I+AzW0E=;
        b=un18HYLQ7z1tPBCJLUfcvJDsi35hNSYl70745bPTOjIqRFwBqT21L1VEvBnmIrMyJC
         hX7zM0pXtbr/lq7fLTGja1BxlJks+1zpFuBL5GZtKDXW0RZhQG6uxAg34mZUEuKbAOiy
         /KbCfmgzRroOCaU7HQKTC12P5T3w4GD9Eo7vuipUFQkM6WlwdYIF+N0rkGyxPpcZJcuL
         dSzQMLjA8WZaM589mIUJxrmnaFtfFk6im8MvLjkb6BVhbGcUp/oAVSWY0PiweHHgxwTH
         hHbFjVqpidmvwkDE7i+bIN53RQ7Ok4+tr0let3cL9FztTh8UKABiHE2SEW6+A2axIpSv
         4TGw==
X-Gm-Message-State: AOAM5328wcEyAYZb3Z8l6FqeHHpp74wDlvXzCSBRRld9AUP2Tbe6wgPb
        2CJ+rIRNriAXfyEyg/SadlSdsnwKjczhH8H3qDcqLnEo
X-Google-Smtp-Source: ABdhPJyzr0dnWV3MxYv2OKruE8IEE6eIwSdF+vupDK8Z/lgVCl750YPGIPHRJxBhyO31YeNKh1PTPnPf9gE6bcsIQIk=
X-Received: by 2002:aca:cd93:: with SMTP id d141mr9968926oig.148.1590394999938;
 Mon, 25 May 2020 01:23:19 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200515171031.GB19423@ninjato> <CA+V-a8t6rPs4s8uMCpBQEAUvwsVn7Cte-vX3z2atWRhy_RFLQw@mail.gmail.com>
 <20200518092601.GA3268@ninjato> <CAMuHMdVWe1EEAtP64VW+0zXNingM1LiENv_Rfz5qTQ+C0dtGSw@mail.gmail.com>
 <CA+V-a8tVx6D8Vh=rYD2=Z-14GAW0puo009FtjYM++sw8PAtJug@mail.gmail.com> <20200522201727.GA21376@ninjato>
In-Reply-To: <20200522201727.GA21376@ninjato>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 25 May 2020 10:23:08 +0200
Message-ID: <CAMuHMdUDs1DXfKMwDgK3e29vdzhPCPBbms2Hj8t7Pvp4j5D5Tg@mail.gmail.com>
Subject: Re: [PATCH 03/17] ARM: dts: r8a7742: Add I2C and IIC support
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
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

On Fri, May 22, 2020 at 10:17 PM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> > > According to the Hardware User's Manual Rev. 1.00, the registers do exist
> > > on all RZ/G1, except for RZ/G1E (see below).
> > >
> > >    "(automatic transmission can be used as a hardware function, but this is
> > >     not meaningful for actual use cases)."
> > >
> > > (whatever that comment may mean?)
>
> Strange comment, in deed. Given the paragraph before, I would guess Gen1
> maybe had a "fitting" PMIC where SoC/PMIC handled DVFS kind of magically
> with this automatic transfer feature? And Gen2 has not.
>
> > > On R-Car E3 and RZ/G2E, which have a single IIC instance, we
> > > handled that by:
> > >
> > >         The r8a77990 (R-Car E3) and r8a774c0 (RZ/G2E)
> > >         controllers are not considered compatible with
> > >         "renesas,rcar-gen3-iic" or "renesas,rmobile-iic"
> > >         due to the absence of automatic transmission registers.
>
> From a "describe the HW" point of view, this still makes sense to me.
> Although, it is unlikely we will add support for the automatic
> transmission feature (maybe famous last words).

;-)

> > > On R-Car E2 and RZ/G1E, we forgot, and used both SoC-specific and
> > > family-specific compatible values.
>
> Okay, but we can fix DTs when they have bugs, or?

We can.  But we also have to consider DT backwards compatibility: i.e.
using an old DTB with a future kernel implementing the automatic
transmission feature.

Fortunately R-Car E2 and RZ/G1E have SoC-specific compatible values,
so we can easily blacklist it in the driver based on that.
Blacklisting the last instance on the other SoCs is uglier, as it needs a
quirk that checks both the SoC-compatible value and the absence of the
generic compatible value. But it can still be done.

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.9.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
