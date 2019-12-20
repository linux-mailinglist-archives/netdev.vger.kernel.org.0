Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5DA127EEB
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfLTPCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:02:03 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:36542 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfLTPCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 10:02:03 -0500
Received: by mail-yb1-f193.google.com with SMTP id w126so1734475yba.3;
        Fri, 20 Dec 2019 07:02:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9+yJIs61uTtVkL5Q2MF9OiCFB3ec6TR53AfD5tfm3Cg=;
        b=fGYvK95pA0TXswY6Ep6OinKdHJEbgfJHf1a/o2uNtlH7e+K/0r5y+y2PIVlJNEDknX
         dGfERj2YGl9bWREj+KjCKJ9Jn4Ob010kO+vF/uv/pSPLo4ZCFa/uZ8KJMxDQ0JhsxHS6
         VmLgXugct+6z97kWX/t7VVFdq2PrhqWhlIT6CTZllrJH7Qxxmi4Cx4yxc7KuTHkniBd4
         XoDwazIZ2QZMk0ZeB3nEJADYApwhVQaJyKrWxogAmV/QVno3Y8F/qVExVnyX9TLm0eTS
         prvgdU84AawHAsRWOpsMgSxmfYajZGlNTmCk57W1W7gopKVZeq90sHsMeVul4rb65Jpi
         B8iw==
X-Gm-Message-State: APjAAAUKWSj63SKBhT4QRwsxayjX8Nuyly9OIh2BKHfNsOiyYUoXS5p2
        9OQhJO6boRPkx3HqqrdvQ44oLgVePHdzM0GLiA4NnGlV
X-Google-Smtp-Source: APXvYqxVy21uSMBnj7B1hu+1IUPq4Ooe3nX8ZjvBvYNAAHzz9bOo6wnWDTMrvPGcC8rFpCoT1G8tI7CV7bJSSBD4ODg=
X-Received: by 2002:a9d:2073:: with SMTP id n106mr5635097ota.145.1576854120427;
 Fri, 20 Dec 2019 07:02:00 -0800 (PST)
MIME-Version: 1.0
References: <1570717560-7431-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1570717560-7431-3-git-send-email-fabrizio.castro@bp.renesas.com>
 <20191014181035.GA2613@bogus> <TY1PR01MB17703B32045654CB46C2FC8BC0530@TY1PR01MB1770.jpnprd01.prod.outlook.com>
In-Reply-To: <TY1PR01MB17703B32045654CB46C2FC8BC0530@TY1PR01MB1770.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 Dec 2019 16:01:49 +0100
Message-ID: <CAMuHMdXZ9pM5VUaJXMtcJ9dD1ZVkvmxQZ0zxT7SvT95Fd-QZ3Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: can: rcar_canfd: document
 r8a774b1 support
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     Rob Herring <robh@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Fabrizio,

On Wed, Dec 18, 2019 at 4:16 PM Fabrizio Castro
<fabrizio.castro@bp.renesas.com> wrote:
> Do you think you can take this patch?

Sure, queuing in renesas-dt-bindings-for-v5.6.

> > From: linux-renesas-soc-owner@vger.kernel.org <linux-renesas-soc-owner@vger.kernel.org> On Behalf Of Rob Herring
> > Sent: 14 October 2019 19:11
> > Subject: Re: [PATCH net-next v2 2/3] dt-bindings: can: rcar_canfd: document r8a774b1 support
> >
> > On Thu, 10 Oct 2019 15:25:59 +0100, Fabrizio Castro wrote:
> > > Document the support for rcar_canfd on R8A774B1 SoC devices.
> > >
> > > Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > ---
> > > v1->v2:
> > > * Added the R8A774B1 to the clock paragraph according to Geert's comment
> > >
> > >  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 5 +++--
> > >  1 file changed, 3 insertions(+), 2 deletions(-)
> > >
> >
> > Acked-by: Rob Herring <robh@kernel.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
