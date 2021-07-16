Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419D63CB4B0
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 10:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbhGPItq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 04:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhGPItp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 04:49:45 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7009C06175F;
        Fri, 16 Jul 2021 01:46:49 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id r132so13664595yba.5;
        Fri, 16 Jul 2021 01:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mEkDurH6BuGEH4gDwLaFvBfzHto5jjTCNrq+0Yx2I5Y=;
        b=AOQ1b2YZ2Y6qApxpfsoLFQ2Y5ZeVPOJyew2YyXjt3iz996WQIbZcXWFzgyqERYIUsv
         6woAI+vav3GHatj0VDNQWZ6hppZmQu5o0j6gYhM4NOQChdbkkdh3zCYcc0EHJUtIrF2F
         TbJ362K19pzeV/vyKWKw7g+LLKWS862GMK2s2g5y26lTBNhbnpBIQs9FbI2e19GkTyB5
         uOQsfG6pubrCzurrJa+oRcU1LAjynQ8MLxempdVnsQqhBeJCnZXzNDNSN2NpPIaVTwlg
         UDcT2L/H7loUkr1gSshSfu96TpXGrEEu8WzL6c41+dGsat0UE68fOJY9pPgq9+ia3sI+
         j9Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mEkDurH6BuGEH4gDwLaFvBfzHto5jjTCNrq+0Yx2I5Y=;
        b=hk+J9LcDzoSGYwX1HOnVBZEQ29AegjS53ziP4OOzAWuNSWvPYjEzVM7vdsBK/j/9+v
         jBv8q9j29qj8WIEgdIIa4hvAAo4aJwKc35ar1zW3sAwaK7RW0CdhAU8l6B0Yof812KFj
         rJiMDJb8jtbkoQm9FGngV1Ba9Cd8BDUpV6xv9MlsO2IjIoia1gsT5pYXzM97Gdsi0UAo
         nTlWFev50V0agmXyjaFenEFhv8mvyb+tfUui4hXItAiHpfHywi7zh214WKYl1DOatcqw
         2PMBak60AyToST0fia4TNkk5vTrp8vUJyiWntX0SUYQEfvK4eOkMyg245yUyZHvIwL4W
         nm3w==
X-Gm-Message-State: AOAM531lawMV06OSAa3T3Fd0hEvpwciwlKDnUDLhTZCAJtac7lVF7bIR
        YjRvtvm4ThpYEpSZlVosf9Wt5tgF+qrVc4a8I/s=
X-Google-Smtp-Source: ABdhPJwEwBc5l1454QguN3MLGOEdfBsfoKJW2Mu3HRNqW5pslfSVZKQ//QhrJvF0EX1e7HbxaYcojI0eYjHoip5G3uQ=
X-Received: by 2002:a25:cc52:: with SMTP id l79mr11280859ybf.476.1626425209092;
 Fri, 16 Jul 2021 01:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210715182123.23372-5-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdXYfAxvdRyn0FaqYSyD4qD2P=Et4-d3bPan9oy_YJ7tfg@mail.gmail.com>
In-Reply-To: <CAMuHMdXYfAxvdRyn0FaqYSyD4qD2P=Et4-d3bPan9oy_YJ7tfg@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Fri, 16 Jul 2021 09:46:23 +0100
Message-ID: <CA+V-a8vdFLee5fLYvOkLfzNJojDBO31TN9bjHYnjFf5t63YyOA@mail.gmail.com>
Subject: Re: [PATCH 4/6] clk: renesas: r9a07g044-cpg: Add entry for fixed
 clock P0_DIV2
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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

Hi Geert,

Thank you for the review.

On Fri, Jul 16, 2021 at 9:09 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > Add entry for fixed core clock P0_DIV2 and assign LAST_DT_CORE_CLK
> > to R9A07G044_LAST_CORE_CLK.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
>
> Thanks for your patch!
>
> > --- a/drivers/clk/renesas/r9a07g044-cpg.c
> > +++ b/drivers/clk/renesas/r9a07g044-cpg.c
> > @@ -16,7 +16,7 @@
> >
> >  enum clk_ids {
> >         /* Core Clock Outputs exported to DT */
> > -       LAST_DT_CORE_CLK = R9A07G044_OSCCLK,
> > +       LAST_DT_CORE_CLK = R9A07G044_LAST_CORE_CLK,
>
> Please use R9A07G044_CLK_P0_DIV2 instead.
>
Ok, I will update it.

Cheers,
Prabhakar

> >
> >         /* External Input Clocks */
> >         CLK_EXTAL,
> > @@ -77,6 +77,7 @@ static const struct cpg_core_clk r9a07g044_core_clks[] __initconst = {
> >         DEF_FIXED("I", R9A07G044_CLK_I, CLK_PLL1, 1, 1),
> >         DEF_DIV("P0", R9A07G044_CLK_P0, CLK_PLL2_DIV16, DIVPL2A,
> >                 dtable_1_32, CLK_DIVIDER_HIWORD_MASK),
> > +       DEF_FIXED("P0_DIV2", R9A07G044_CLK_P0_DIV2, R9A07G044_CLK_P0, 1, 2),
> >         DEF_FIXED("TSU", R9A07G044_CLK_TSU, CLK_PLL2_DIV20, 1, 1),
> >         DEF_DIV("P1", R9A07G044_CLK_P1, CLK_PLL3_DIV2_4,
> >                 DIVPL3B, dtable_1_32, CLK_DIVIDER_HIWORD_MASK),
>
> The rest looks good to me.
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
