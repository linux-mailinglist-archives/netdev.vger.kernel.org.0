Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0C03CB4AA
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 10:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238337AbhGPIsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 04:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbhGPIsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 04:48:50 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A190CC06175F;
        Fri, 16 Jul 2021 01:45:54 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id t186so13653322ybf.2;
        Fri, 16 Jul 2021 01:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WawZctLiAJrqVZUxY4eGGxQNTSyE6VsTwpcss0Q0tZw=;
        b=aKRnZ2x5hNC/yE5/m7oMzFKZC1FJo6shdxjTjR96Z0nVKPRP6PUIo4vkOTmcPe4IjY
         K4Ikzz3fQ1JVyyd7wvhC5PKnv3PVCrAH3xhFCRYtSEhvZbCKnXcvUMsk/8g437QXrQok
         tz9u71LYowtDTIU6Q9LFVA25bkCrYEABQBixMmUJ69pHbo0WyIkao7ncf5tbkkoelO6B
         /SkzdJSH+HFW29LML1jqeyu9Dw+GF/vMDGPoDilkMv3gFUe8E5BPeCqg5U3wO0iQ2+aL
         TCTe405BX6Yz4ryENs56QRdPfWV3Rdg0c1CPdVcx2KqeEENeESey+/Z21twFMfvD8E3L
         eWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WawZctLiAJrqVZUxY4eGGxQNTSyE6VsTwpcss0Q0tZw=;
        b=KX7+y3IwNXkqgjEMw9LGOfGv7qFUpeAwiKCLt/3g7VH36IWusWIhxGQ0gHBNeo6/nQ
         Rxkm0bRqxk+xXtzzf4S7YvuNiynRv5vxYolUFqrT1A+GayZ9fJIIs1xWXi9K6qf6bf6R
         /M8SPXnozcixnCBwWo0DhHcJ3zYo8NDTkFKBvAWs06vYYxITbHP+GKKFI2yuwotBHgi6
         IybtoRCNXtLLtj9hCY6/F0+ETFD0A6eAifsuDW/uzJum1wbyLhu5A/XfHFKHKUilH2uL
         c2OK9N4BSxv7oS+pvx7HBTZeZd4fflELsHmbwW7OTO13UiNiM/7OD4d9j7eo4yJXHlNJ
         LN+g==
X-Gm-Message-State: AOAM530QDgnCF/zd/pLxB1BBRjvJq8tObArTfJgW/4HfIB4Ifrmy9FHF
        IiGq68kZ8HB5MaYTAGFT/BTHReWlSYyyryWgsrw=
X-Google-Smtp-Source: ABdhPJwxqwPK+LUmyDchYqVNJXHNcROamwgv09eqq4XijnFVYRMqOvyPF7rVs2ufy9OHqlFTmCsqZGeMFUCOGsaMcic=
X-Received: by 2002:a5b:94d:: with SMTP id x13mr10536216ybq.47.1626425153883;
 Fri, 16 Jul 2021 01:45:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210715182123.23372-4-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdV3JkV5D5_PsngoLiLPA_B1VBvRKsCz7j2tXKYVE_Bx9A@mail.gmail.com>
In-Reply-To: <CAMuHMdV3JkV5D5_PsngoLiLPA_B1VBvRKsCz7j2tXKYVE_Bx9A@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Fri, 16 Jul 2021 09:45:28 +0100
Message-ID: <CA+V-a8v5m-F-n4E9HpwLe1C9gHWepTc0rCVk5oh5RCJ7oTXe2A@mail.gmail.com>
Subject: Re: [PATCH 3/6] dt-bindings: clk: r9a07g044-cpg: Add entry for
 P0_DIV2 core clock
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

On Fri, Jul 16, 2021 at 9:08 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> Thanks for your patch!
>
> On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > Add P0_DIV2 core clock required for CANFD module. CANFD core clock is
> > sourced from P0_DIV2 referenced from HW manual Rev.0.50.
>
> OK.
>
> > Also add R9A07G044_LAST_CORE_CLK entry to avoid changes in
> > r9a07g044-cpg.c file.
>
> I'm not so fond of adding this.  Unlike the other definitions, it is
> not really part of the bindings, but merely a convenience definition
> for the driver.  Furthermore it has to change when a new definition
> is ever added.
>
Agreed will drop this.

> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > ---
> >  include/dt-bindings/clock/r9a07g044-cpg.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/include/dt-bindings/clock/r9a07g044-cpg.h b/include/dt-bindings/clock/r9a07g044-cpg.h
> > index 0728ad07ff7a..2fd20db0b2f4 100644
> > --- a/include/dt-bindings/clock/r9a07g044-cpg.h
> > +++ b/include/dt-bindings/clock/r9a07g044-cpg.h
> > @@ -30,6 +30,8 @@
> >  #define R9A07G044_CLK_P2               19
> >  #define R9A07G044_CLK_AT               20
> >  #define R9A07G044_OSCCLK               21
> > +#define R9A07G044_CLK_P0_DIV2          22
> > +#define R9A07G044_LAST_CORE_CLK                23
>
> Third issue: off-by-one error, it should be 22 ;-)
>
23 was intentionally as these numbers aren't used for core clock count
we use r9a07g044_core_clks[] instead. Said that I'll drop this.

Cheers,
Prabhakar
> >
> >  /* R9A07G044 Module Clocks */
> >  #define R9A07G044_CA55_SCLK            0
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
