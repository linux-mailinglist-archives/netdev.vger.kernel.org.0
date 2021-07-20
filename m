Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69AA53CFDB2
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241887AbhGTOzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:55:02 -0400
Received: from mail-vs1-f50.google.com ([209.85.217.50]:42544 "EHLO
        mail-vs1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240561AbhGTObQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 10:31:16 -0400
Received: by mail-vs1-f50.google.com with SMTP id u7so11389813vst.9;
        Tue, 20 Jul 2021 08:11:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ud/jDpbWklsc8Hf2Dzjkflmuwd+BBYaeIXuiJzYWq2A=;
        b=WAhK67oBrC8Xq8LM1dDPWyG5p4PeVWZbCGSac+mJWx0V6vsXy4n47bAYyq1V3RJCyI
         UIK05tSOOdQPZCA8pLk5DR+v4m9Ou6PUKDm8AJcWe+rPPEb5uLgpU+YqHNLjYsDnBjz3
         qLfgawIlRGEWyQpm2YSJOIaqig8T8WvyVVX1yWIeTvnhuhWXteWUCvutqZ35WD8zlxSb
         prbo4+xAI32KtQyiaXvcn7LWU+Ikx6KPL0rss4qTwTMo5EH1fypAvzXtmkJ/geDvD2MV
         yq4U8OddKf6HeRmf2kXx2+wc1F2UDB4/hccLzFngjLelIjOar5PeQdJKlta41aX5JdG/
         3fiQ==
X-Gm-Message-State: AOAM531MbQnRsUMXcd44GC4EUYB4xF/FdWlRsDO0Lwlrv3iUIGSviO/s
        2o8YA78Nb3XU39x9Vu03nAfnq5ItnUZ+c6SphEY=
X-Google-Smtp-Source: ABdhPJzDV7RCsmS0DanONbIYjgNYMSonYXpaVrJCcp+FI4tvthBs4jcZ455c5S5FgTmyDPRujYPJ19p+lYL23omZSqw=
X-Received: by 2002:a67:8702:: with SMTP id j2mr29900001vsd.3.1626793913446;
 Tue, 20 Jul 2021 08:11:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210719143811.2135-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <dc2de27b087c7030ea7e76dd31bb3d8bce18d97f.camel@pengutronix.de> <CA+V-a8v-54QXtcT-gPy5vj9drqZ6Ntr0-3j=42Dedi-kojNtXQ@mail.gmail.com>
In-Reply-To: <CA+V-a8v-54QXtcT-gPy5vj9drqZ6Ntr0-3j=42Dedi-kojNtXQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 20 Jul 2021 17:11:42 +0200
Message-ID: <CAMuHMdVFarkF49=Vvcv-6NLhxbLUE33PXnqhAiPxpaCNN7u4Bw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Tue, Jul 20, 2021 at 4:31 PM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> On Tue, Jul 20, 2021 at 11:22 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > On Mon, 2021-07-19 at 15:38 +0100, Lad Prabhakar wrote:
> > > Add CANFD binding documentation for Renesas RZ/G2L SoC.
> > >
> > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

> > > --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > > +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml

> > > +    resets:
> > > +      items:
> > > +        - description: CANFD_RSTP_N
> > > +        - description: CANFD_RSTC_N
> >
> > Do you know what the "P" and "C" stands for? It would be nice if the
> > description could tell us what the reset lines are used for.
> >
> unfortunately the HW manual does not mention  anything about "P" and "C" :(
>
> > I would prefer if you used these names (or shortened versions, for
> > example "rstp_n", "rstc_n") as "reset-names" and let the driver
> > reference the resets by name instead of by index.
> >
> OK will do that and maxItems:2 for resets.
>
> @Geert, for R-Car Gen3 does "canfd_rst" (as it's a module reset)
> sounds good for reset-names? Or do you have any other suggestions?

I wouldn't bother with reset-names on R-Car, as there is only a
single reset.

BTW, does there exist a generally-accepted reset-equivalent of "fck"
("Functional ClocK")?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
