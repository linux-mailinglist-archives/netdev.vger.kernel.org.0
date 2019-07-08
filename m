Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EE861F05
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731061AbfGHMzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:55:48 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:34242 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728892AbfGHMzs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:55:48 -0400
Received: by mail-ot1-f67.google.com with SMTP id n5so16092733otk.1;
        Mon, 08 Jul 2019 05:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CY+RhrJnFubDDbiIrZyXLw75lUiZRz6EsymCdcoavtU=;
        b=Z9up9DnIbbzEPrOeVYd3kVUZBMS2iboPj5o5STcjHMieEqNt/dTfFU4CNU8fU5dzhF
         25RAOwnbV3i5pWDG6mC3nRP+kMyT78l7KyotlymAiu8XgKqu91tWK75oQpL5ooVYgZ8l
         8flq1vMs0tiTjVpt/NDoHV++fZgaGkJczlWzI4dkIbgO7HSNr6jK6cJ2lPglJmxZaOoV
         b59dnAugs4VlN66UkobyfqrY1CJN7OzbsBSAp7mBApX8P0ODUKAvaVoWCYk5wglPCuUr
         qEo7m1S07GboTjQl3KB3OiGAwC3Is708lnEKMKOZsb/Vx/gRMqL/4hpVfd5PojsurdM3
         0+AQ==
X-Gm-Message-State: APjAAAWIxBzaidgWdRsZ1XOeCFNdF+MCq4vP9KIG3ixP9IcsoaFyf+qE
        6hVHK1vhZqlzK988YpmX0IoSjjW6sbSjaLPny1g=
X-Google-Smtp-Source: APXvYqwFL+4zysqtgbh6jv5g14+D5Us7ngVON2WHlU6B+9Snut3IlCo9BTRpnxbrZ0gGR07NZEcR37cPFaCeGkiGBpc=
X-Received: by 2002:a9d:529:: with SMTP id 38mr14377098otw.145.1562590546625;
 Mon, 08 Jul 2019 05:55:46 -0700 (PDT)
MIME-Version: 1.0
References: <1560513214-28031-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1560513214-28031-2-git-send-email-fabrizio.castro@bp.renesas.com> <20190617093023.nhvrvujg52gcglko@verge.net.au>
In-Reply-To: <20190617093023.nhvrvujg52gcglko@verge.net.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 8 Jul 2019 14:55:35 +0200
Message-ID: <CAMuHMdVdKVMiOZJVPyM_Y6YNvDsdTwf+EhmS3VJPUb_zOrf7Yw@mail.gmail.com>
Subject: Re: [PATCH 1/6] dt-bindings: can: rcar_canfd: document r8a774a1 support
To:     Simon Horman <horms@verge.net.au>
Cc:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 11:30 AM Simon Horman <horms@verge.net.au> wrote:
> On Fri, Jun 14, 2019 at 12:53:29PM +0100, Fabrizio Castro wrote:
> > Document the support for rcar_canfd on R8A774A1 SoC devices.
> >
> > Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> > Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> > ---
> > Hello Simon,
> >
> > I think it would make more sense if this patch went through you as it
> > sits on series:
> > https://lkml.org/lkml/2019/5/9/941
> >
> > Do you think that's doable?
>
> That seems reasonable to me.
>
> Dave are you happy with me taking this, and 2/6, through
> the renesas tree?

As the previous change to this file was acked by Dave, and went in through
the Renesas tree, have I applied this patch and patch 2/6, and queued
it for v5.4.

Thanks!

> >  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 9 +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
> > index 32f051f..00afaff 100644
> > --- a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
> > +++ b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
> > @@ -4,6 +4,7 @@ Renesas R-Car CAN FD controller Device Tree Bindings
> >  Required properties:
> >  - compatible: Must contain one or more of the following:
> >    - "renesas,rcar-gen3-canfd" for R-Car Gen3 and RZ/G2 compatible controllers.
> > +  - "renesas,r8a774a1-canfd" for R8A774A1 (RZ/G2M) compatible controller.
> >    - "renesas,r8a774c0-canfd" for R8A774C0 (RZ/G2E) compatible controller.
> >    - "renesas,r8a7795-canfd" for R8A7795 (R-Car H3) compatible controller.
> >    - "renesas,r8a7796-canfd" for R8A7796 (R-Car M3-W) compatible controller.
> > @@ -32,10 +33,10 @@ enable/disable the respective channel.
> >  Required properties for "renesas,r8a774c0-canfd", "renesas,r8a7795-canfd",
> >  "renesas,r8a7796-canfd", "renesas,r8a77965-canfd", and "renesas,r8a77990-canfd"
> >  compatible:
> > -In R8A774C0, R8A7795, R8A7796, R8A77965, and R8A77990 SoCs, canfd clock is a
> > -div6 clock and can be used by both CAN and CAN FD controller at the same time.
> > -It needs to be scaled to maximum frequency if any of these controllers use it.
> > -This is done using the below properties:
> > +In R8A774A1, R8A774C0, R8A7795, R8A7796, R8A77965, and R8A77990 SoCs, canfd
> > +clock is a div6 clock and can be used by both CAN and CAN FD controller at the
> > +same time. It needs to be scaled to maximum frequency if any of these
> > +controllers use it. This is done using the below properties:
> >
> >  - assigned-clocks: phandle of canfd clock.
> >  - assigned-clock-rates: maximum frequency of this clock.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
