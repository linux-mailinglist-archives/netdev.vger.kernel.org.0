Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786462E9693
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 15:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbhADOCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 09:02:02 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:33744 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbhADOCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 09:02:01 -0500
Received: by mail-ot1-f48.google.com with SMTP id b24so26094711otj.0;
        Mon, 04 Jan 2021 06:01:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RVNXv1JYtrW2cW+Rk3LKTTRgi0axGBYEvWkKK+5J8Jw=;
        b=cXs60Ft8B7jmjoznjaq56LTzwhSeSlmRys7cJsjgu/ty908UEum1jDIxUMNQx7eyVt
         fZgqIfx0iRA4yTNcKulV4BmoVx7gqb1sYs5KupvAeSoltYdbWn++l1AQ4LvryzaaDtfh
         +p6LnbMsh3NWZQbXr1mdWkRxRLK5Ukrm2Z45fhqXNHOiZ1ObtPs5fgmYMVw33Ne/kCA9
         AJkQOXtirRJplGDqZcsMtqips3X04TTQq3OSiVZGYlPdvWlYXdVXOmdH03EOtFwFS3YH
         TuBWdVxfW4MSdbCzWq/iYZ4QekzgM2U2Y5RvbXamwUnCSgRGs3ybp5O7QOx0WjeCLWsL
         l28w==
X-Gm-Message-State: AOAM533N/Up2pgnd9Kv94l44C5eWfY5IqUhyPzpWyDB6qslvBXXuAP58
        /2entXKfVCJgXhTBdBeh5+qxwA7QV/KPW8lV7A0=
X-Google-Smtp-Source: ABdhPJyDMju2UJkYL5bM4PCXaH6wMpee73deLVlZGXpnkBGzdMAWwTZ2qtWpYUmfdOx4JI1Slob5FrGHu24jXnoP3HY=
X-Received: by 2002:a9d:c01:: with SMTP id 1mr37670009otr.107.1609768880297;
 Mon, 04 Jan 2021 06:01:20 -0800 (PST)
MIME-Version: 1.0
References: <20201231155957.31165-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <CAMuHMdX2ruikh4voRrHPmi=ti+eHVxXh6N05s1XH6+r5MeeqQw@mail.gmail.com> <CA+V-a8uzTWqOGxMVi+ZJwNWRfj9ANxzAqEhLaQLoDiVcwwCUWQ@mail.gmail.com>
In-Reply-To: <CA+V-a8uzTWqOGxMVi+ZJwNWRfj9ANxzAqEhLaQLoDiVcwwCUWQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 4 Jan 2021 15:01:09 +0100
Message-ID: <CAMuHMdWTtSrK1K9VHoxC+gnSKK82wHx5UyN66rpvnpfm_r7sVQ@mail.gmail.com>
Subject: Re: [PATCH] can: rcar: Update help description for CAN_RCAR_CANFD config
To:     "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc:     Chris Paterson <Chris.Paterson2@renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Mon, Jan 4, 2021 at 2:38 PM Lad, Prabhakar
<prabhakar.csengg@gmail.com> wrote:
> On Mon, Jan 4, 2021 at 10:51 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Thu, Dec 31, 2020 at 5:00 PM Lad Prabhakar
> > <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > > The rcar_canfd driver supports R-Car Gen3 and RZ/G2 SoC's, update the
> > > description to reflect this.
> > >
> > > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > > --- a/drivers/net/can/rcar/Kconfig
> > > +++ b/drivers/net/can/rcar/Kconfig
> > > @@ -10,13 +10,13 @@ config CAN_RCAR
> > >           be called rcar_can.
> > >
> > >  config CAN_RCAR_CANFD
> > > -       tristate "Renesas R-Car CAN FD controller"
> > > +       tristate "Renesas R-Car Gen3 and RZ/G2 CAN FD controller"
> > >         depends on ARCH_RENESAS || ARM
> >
> > Not introduced by this patch, but the "|| ARM" looks strange to me.
> > Is this meant for compile-testing? Doesn't the driver compile on all
> > platforms (it does on m68k), so "|| COMPILE_TEST" is not appropriate?
> > Is the CAN FD controller present on some Renesas arm32 SoCs (but
> > not yet supported by this driver)?
> >
> Good catch. "|| ARM" was probably copied from CAN_RCAR config and I
> can confirm CAN-FD controller doesn't exist on R-Car Gen2 and RZ/G2

G1

> 32bit SoC's (but with a bit of google search RZ/A2M supports CAN-FD I
> am not sure if its the same controller tough), but said that there

Thanks for investigating. I knew about R-Car Gen2 and RZ/G1 not having
CAN-FD.

> shouldn't be any harm in replacing  "|| ARM" with "|| COMPILE_TEST"
> for both CAN_RCAR_CAN{FD}. What are your thoughts?

I'd go for "|| COMPILE_TEST".

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
