Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398853CB4F1
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 11:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238968AbhGPJAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 05:00:47 -0400
Received: from mail-vs1-f52.google.com ([209.85.217.52]:44703 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239301AbhGPI73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 04:59:29 -0400
Received: by mail-vs1-f52.google.com with SMTP id f4so4571480vsh.11;
        Fri, 16 Jul 2021 01:56:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7tHhki3aphTw+T8sH9x98BuGFR0iW2Ee/zuAbvNRS7M=;
        b=txdR+80+jda/XYaoG4jvUqDWRbhrXRJohcFZnwU294zf0Go7Pt2UrSeNVyubDvX0eu
         AK2IdzEyIZoj0qnyy99eJm3RHz2XLO0sYM/BXpCJSdRZRTNICZDL9fkF3OHWkYYmdWAK
         pvkWx51v9551ryyNtczDYMmNcLSGkXI6rfNUbfIWF8Lp+0eN4kjEocpMyz/u9gWtAH5v
         59a0kdOoMuYob2LRhWc6I+/zPFKiud5TO9H9jb5wKL69DMhRKaVmDvRa4HGIy3l4XCNl
         lVcynssYq96PHwWXz7/196faKnlc70xWMv9P+84URboSaSr3bIGvtiFbAVTJpvt+iyi4
         fQ6Q==
X-Gm-Message-State: AOAM532A4jUXrwJipby2eOR24pm+f+QhN7luGUUgS03RykxoehyruMUj
        hwCFM3Aktd8SZjJ0EC8UTLXbyuyttQKSoLnMeWI=
X-Google-Smtp-Source: ABdhPJzEW1+qMwqxtRATj9Y2pkaijw208kCbHNU65ponKqlood1qioSfjhb9EegcS3SsBrTT8JCYmAIgpF+zayfmhQE=
X-Received: by 2002:a67:1542:: with SMTP id 63mr11596800vsv.40.1626425794458;
 Fri, 16 Jul 2021 01:56:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210715182123.23372-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdV3JkV5D5_PsngoLiLPA_B1VBvRKsCz7j2tXKYVE_Bx9A@mail.gmail.com> <CA+V-a8v5m-F-n4E9HpwLe1C9gHWepTc0rCVk5oh5RCJ7oTXe2A@mail.gmail.com>
In-Reply-To: <CA+V-a8v5m-F-n4E9HpwLe1C9gHWepTc0rCVk5oh5RCJ7oTXe2A@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 16 Jul 2021 10:56:23 +0200
Message-ID: <CAMuHMdWBqLcCGWkP9JoALuiXT1m9a1rRwR8ExShUQmJ1HCikZA@mail.gmail.com>
Subject: Re: [PATCH 3/6] dt-bindings: clk: r9a07g044-cpg: Add entry for
 P0_DIV2 core clock
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Fri, Jul 16, 2021 at 10:45 AM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> On Fri, Jul 16, 2021 at 9:08 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
> > <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > > Add P0_DIV2 core clock required for CANFD module. CANFD core clock is
> > > sourced from P0_DIV2 referenced from HW manual Rev.0.50.
> >
> > OK.
> >
> > > Also add R9A07G044_LAST_CORE_CLK entry to avoid changes in
> > > r9a07g044-cpg.c file.
> >
> > I'm not so fond of adding this.  Unlike the other definitions, it is
> > not really part of the bindings, but merely a convenience definition
> > for the driver.  Furthermore it has to change when a new definition
> > is ever added.
> >
> Agreed will drop this.
>
> > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > ---
> > >  include/dt-bindings/clock/r9a07g044-cpg.h | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/include/dt-bindings/clock/r9a07g044-cpg.h b/include/dt-bindings/clock/r9a07g044-cpg.h
> > > index 0728ad07ff7a..2fd20db0b2f4 100644
> > > --- a/include/dt-bindings/clock/r9a07g044-cpg.h
> > > +++ b/include/dt-bindings/clock/r9a07g044-cpg.h
> > > @@ -30,6 +30,8 @@
> > >  #define R9A07G044_CLK_P2               19
> > >  #define R9A07G044_CLK_AT               20
> > >  #define R9A07G044_OSCCLK               21
> > > +#define R9A07G044_CLK_P0_DIV2          22
> > > +#define R9A07G044_LAST_CORE_CLK                23
> >
> > Third issue: off-by-one error, it should be 22 ;-)
> >
> 23 was intentionally as these numbers aren't used for core clock count
> we use r9a07g044_core_clks[] instead.

It ends up as an off-by-one bug in the range check in
rzg2l_cpg_clk_src_twocell_get().

> Said that I'll drop this.

OK.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
