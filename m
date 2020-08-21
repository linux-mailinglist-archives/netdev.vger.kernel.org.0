Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E096124D744
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 16:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgHUOXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 10:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgHUOXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 10:23:36 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08874C061573;
        Fri, 21 Aug 2020 07:23:36 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id i10so1115104ybt.11;
        Fri, 21 Aug 2020 07:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cdaxvWi4S/8iVwLCKzXxlcoFNvM0MXvR3LgfOth28YM=;
        b=H8fThCaiORW/A6/dBnOiF1aHybeA7nMJKaCWASyx7Qpxbq3FPXn/Z5um1ohc1TVj8J
         AishFjqxIOJvvIAK7voJPc/EhLxf3j4BDIzuqUvnCyyat5xEpoRWhnnkH5WwrTroq4xQ
         r8Upzp5AyZNkA620ZlgKimH/Q+mUE6Em11l8+NojkrgA4FUeH2VIKms6iGpA3nVyBOx/
         B2QpdobNAG5BQecsBBoelQyBJZRPIgbXG6XfYHaOIQcC8AQHhtMSLKoUAtGmsG96kaA8
         tOQUQlFX+jDd0IXYpi77m8wZ+wLDbjxpgi8gK2ett/pcAI9wZtGS0PPsMUoEffGlPPOy
         i9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cdaxvWi4S/8iVwLCKzXxlcoFNvM0MXvR3LgfOth28YM=;
        b=N/vRlsmK20LWtuwwqXNB99yedR0WcueZKX4rePTRO2FsODHrldcQZ8qrkI/rEZKfsk
         iumio0E7lKK8Brnujm4FQb+/Dq/GMIUSWOE4GL6Jq7srzGSYVEnt863rM8LVhrL+DItj
         dBc9Kej1ZgWKd54dvadbAsTeLV9DXuZJSzARCvryvcYTweQTJAyjokAJ7haiw0DiWx7N
         8qUxFNNfrzdDU0T1bZkQo8yFOY9lx7xM+YGbkt2W9tdixW2DVDkyusHmBhlGCRn2MUct
         WDaNsMjTYOuWj6SsC/JkvLze5GiP6kzjskMc+LO0NH0/a21Rcc+GViu10jl/vtql/PYy
         SbNw==
X-Gm-Message-State: AOAM531Rln+dw4n5GQNT+hSTXBhjmzT1JRUnJb6M/oJBWYnV11+mE0JB
        t6nNilRn8sDPMJdK1GIvK8IzpeV1BMP6nJW5fi4=
X-Google-Smtp-Source: ABdhPJwFPfytP1/12rYImnxNWcaTXjulE7JutGzwE1bfpqb8FCG2JODT/EUADB/j4bZB4OEPY2qXKAuU5RvsXOQxWrw=
X-Received: by 2002:a25:c743:: with SMTP id w64mr3856261ybe.127.1598019815346;
 Fri, 21 Aug 2020 07:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200816190732.6905-2-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdW2RTCi7rAa_tSsY7ukVM2xk6PYD526SRQU1Wd4SSz2Mw@mail.gmail.com>
In-Reply-To: <CAMuHMdW2RTCi7rAa_tSsY7ukVM2xk6PYD526SRQU1Wd4SSz2Mw@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Fri, 21 Aug 2020 15:23:08 +0100
Message-ID: <CA+V-a8u-DrpNPskCwFEfaxtfSHKDGfOhcVf+y4tZ+aw9jFj=eQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: sh-pfc: r8a7790: Add CAN pins, groups and functions
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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

Hi Geert,

Thank you for the review.

On Fri, Aug 21, 2020 at 1:52 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Sun, Aug 16, 2020 at 9:07 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > Add pins, groups and functions for the CAN0 and CAN1 interface.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>
>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Don't you want to add the CAN_CLK pins, too?
>
Will do. Would you prefer an incremental patch or a v2 ?

Cheers,
Prabhakar

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
