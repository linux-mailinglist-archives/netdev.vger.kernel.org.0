Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF2D24D754
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 16:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgHUO0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 10:26:53 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33995 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgHUO0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 10:26:51 -0400
Received: by mail-oi1-f195.google.com with SMTP id z22so1660674oid.1;
        Fri, 21 Aug 2020 07:26:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TILjLDOFeAler+h2JDe75/V/0ljXFgjHXl0TyPZmqlw=;
        b=gtnpC0gG1IHWkbOvcHGiohFUG5aL3Q6kSXEwbrIBtwEC0K/5wZBkQXTWMnxc+aX88K
         ZzZabnVOVwh3mqWunLhxcXSp2eB3Z5ePL3FMOmBJY1p0O7lXFmw9ML0FSa1WQwJdr5ZX
         nUYYhPKIsYRTcziMssYgLOEVsf25oOVjE8Lsz7kZxXh7bHsXU7xFidDSoObMXJw1W5+1
         z02dVyOEe7cI0Rawf/moTYecyy32Pl3A4jaioBqoShsvuXyaYqc21AZnnljk3BnAtoxw
         LrGlr5tjoblMNV28hHo9habaQ1Zp0+bQDRyGUtwITis0s+deiHn1pRMyMRF59mW2HuvO
         urGA==
X-Gm-Message-State: AOAM531B+lBoLpr07PDz6R7VnlRN4H5DKmxwL1f7NOc9lF2blQbepVst
        9ymL5pkUTcmRbg+lpInkv4HDoJFtFtlfKLuDKDY=
X-Google-Smtp-Source: ABdhPJw1OdJ74/BIAVR1kJHHGz0iDXZ4xs+zxuj9ys+Af+YYTXEh+bb30Dw3y3w5+bI2uXnRe/YiUSCZFUHzrrP088w=
X-Received: by 2002:aca:4b54:: with SMTP id y81mr1908135oia.54.1598020010626;
 Fri, 21 Aug 2020 07:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200816190732.6905-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdW2RTCi7rAa_tSsY7ukVM2xk6PYD526SRQU1Wd4SSz2Mw@mail.gmail.com> <CA+V-a8u-DrpNPskCwFEfaxtfSHKDGfOhcVf+y4tZ+aw9jFj=eQ@mail.gmail.com>
In-Reply-To: <CA+V-a8u-DrpNPskCwFEfaxtfSHKDGfOhcVf+y4tZ+aw9jFj=eQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 21 Aug 2020 16:26:39 +0200
Message-ID: <CAMuHMdU06OFSgLkrdYPY9zaUkr0gq3wNxkaTMY4QFWwnxruB6w@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: sh-pfc: r8a7790: Add CAN pins, groups and functions
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Fri, Aug 21, 2020 at 4:23 PM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> On Fri, Aug 21, 2020 at 1:52 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Sun, Aug 16, 2020 at 9:07 PM Lad Prabhakar
> > <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > > Add pins, groups and functions for the CAN0 and CAN1 interface.
> > >
> > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > > Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>
> >
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > Don't you want to add the CAN_CLK pins, too?
> >
> Will do. Would you prefer an incremental patch or a v2 ?

Up to you. Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
