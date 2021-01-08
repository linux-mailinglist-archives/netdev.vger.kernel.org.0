Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D49E2EF3C7
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 15:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727481AbhAHOO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 09:14:29 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:37527 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbhAHOO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 09:14:28 -0500
Received: by mail-ot1-f48.google.com with SMTP id o11so9774813ote.4;
        Fri, 08 Jan 2021 06:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H0nGrYPVP/NtKwcnh+n0K4QbzBdAb/GPMR5m73WpAfQ=;
        b=JtU/O4JPkipGTuaPTWcWiUlIoLR1FmVmXXZADznT+DI01CHWbH6U86NE4P91XYhuFA
         i6G9+QvBzIslaiwnmuIpm4hdOkP9PjJJh/Z2T/kjkqI9aYCFa6F5sSLLlmtS2Ak+W4HH
         7+lETw5AhstFJ8t9VHHwaPR7gUhRaAmsqTllPDrvkiBWe4J3cF1EsERiAsXLCPeQjBpZ
         /EG615H/XipA1KXXIjD24S7h6VCQ/YaaHBq2VZTCSdKc4+blr/erUmP3W0u8fZ57PAO4
         U+sqkUARsDa7FD1lY8eNeiIF1N+t7Uk89nuDYW2uZXwJBX5Ym7Kk4SLpzpUZrD22R3a2
         OtvA==
X-Gm-Message-State: AOAM533JpqQiPaYzUn6a6LTSaYECpt3pivf85vOptlk70UodSlK250m4
        Hzdm15Z98xjFITGIye1jtcp8ehGiw7D8kMge4P/ARNwu
X-Google-Smtp-Source: ABdhPJx8WFXvVy4EUxb8CnisFiU/x8zwmp5kWC3RnmpibZr4Yw3BatFdtsD6VIqSzikNb1XncgMWpWd6FNrs9UAEX5w=
X-Received: by 2002:a05:6830:210a:: with SMTP id i10mr2710851otc.145.1610115227270;
 Fri, 08 Jan 2021 06:13:47 -0800 (PST)
MIME-Version: 1.0
References: <20201228213121.2331449-1-aford173@gmail.com> <20201228213121.2331449-4-aford173@gmail.com>
 <CAMuHMdUCsAGYGS8oygT2xySRSm3Op4cJJmcnEK9BC732ZvN6JA@mail.gmail.com> <CAHCN7xJmNU_1XS-hqP1VdaO9j3phepG4eF-S7EiNEzOUyZKX-w@mail.gmail.com>
In-Reply-To: <CAHCN7xJmNU_1XS-hqP1VdaO9j3phepG4eF-S7EiNEzOUyZKX-w@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 8 Jan 2021 15:13:36 +0100
Message-ID: <CAMuHMdVm3Ao7oVeiwXRU-pHFWRjF+GHXFigN9pMA8PDopDrCYg@mail.gmail.com>
Subject: Re: [PATCH 4/4] net: ethernet: ravb: Name the AVB functional clock fck
To:     Adam Ford <aford173@gmail.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Adam Ford-BE <aford@beaconembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Adam,

On Tue, Jan 5, 2021 at 1:53 PM Adam Ford <aford173@gmail.com> wrote:
> On Mon, Jan 4, 2021 at 4:41 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Mon, Dec 28, 2020 at 10:32 PM Adam Ford <aford173@gmail.com> wrote:
> > > The bindings have been updated to support two clocks, but the
> > > original clock now requires the name fck to distinguish it
> > > from the other.
> > >
> > > Signed-off-by: Adam Ford <aford173@gmail.com>
> >
> > Thanks for your patch!
> >
> > > --- a/drivers/net/ethernet/renesas/ravb_main.c
> > > +++ b/drivers/net/ethernet/renesas/ravb_main.c
> > > @@ -2142,7 +2142,7 @@ static int ravb_probe(struct platform_device *pdev)
> > >
> > >         priv->chip_id = chip_id;
> > >
> > > -       priv->clk = devm_clk_get(&pdev->dev, NULL);
> > > +       priv->clk = devm_clk_get(&pdev->dev, "fck");
> >
> > This change is not backwards compatible, as existing DTB files do not
> > have the "fck" clock.  So the driver has to keep on assuming the first
> > clock is the functional clock, and this patch is thus not needed nor
> > desired.
>
> Should I post a V2 with this removed, or can this patch just be excluded?

As far as I am concerned, it can just be excluded.
Patches 1 and 2+3 have to follow different maintainer paths anyway.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
