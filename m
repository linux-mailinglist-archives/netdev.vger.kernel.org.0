Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848F53CB455
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 10:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbhGPIeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 04:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237240AbhGPIeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 04:34:00 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFF7C06175F;
        Fri, 16 Jul 2021 01:31:05 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id g5so13558733ybu.10;
        Fri, 16 Jul 2021 01:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QjjQyZufxkvm/4FnY8ErggVvo5phblypQQ5y56lc8Bc=;
        b=cuq0WO3alXyDsSlh+srE/yCTOOd9pcBEDQYDlbjHgwC1Zk8dPwyQUJHW8/fpSOYVHI
         v2sEWgIKW5zwm9QhMYzzaWG6ogzooKcywroRAeceJuG+RVVFxOmQGuA61/yrblFOw0M9
         /ujre2xc3WOQu2FdzbDrtkzHk9mVvcIfxAceBO3jJo8hU6trZWD4RuE2szX6Le3gYeOj
         ug3UkegE9rmGkFGUdtnXL7dmsmCs7S6R56J9mfK6ECwhUb3D4NNtRa0bxtoEJ+gOMjFj
         T0+uigcuZ2gMFAB+FVfN0ipfh4/TrUCa4JTONqXa3mNsmaRAwlTwMtVn58B5MGigcrsR
         vp4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QjjQyZufxkvm/4FnY8ErggVvo5phblypQQ5y56lc8Bc=;
        b=mkX03HP43xRexKgMtvBRUbqH5qATXe89nMTrJD+ve51FUttAFkMAwXEC831+qp4We5
         1XsDkcgi6cxUb8bWSb3d6reOe7v29mYFkQKlBF5sw0qOHCL+YGVC4g6VQONTxVROOtke
         Qs/5RnYtdEtT5onZsEj5G8fgcCrMW0ZgDXUxJsGTEu1u7T8VCqpa6ARM35ELhnBsTess
         76Dk2LBGtGFRAbz+aEGDDnYBK7q1ooP/EC2aGBDw8byK7asR5n7qcQAEiKWEWlUl20or
         JOfaWzjk7gjxlAIFh8cziHjYXQS2avQElsTd4YTW8hSCALekcUvgt+GOfZZRlwQ5FOGw
         c8vQ==
X-Gm-Message-State: AOAM5327Y5U48RjXJROEeWYHNH+ee2OeI/edP+tixmht06nP5iFL1u1q
        5KycUvkInMuIKwHLCDQoYkitwyUrMcdH1qwxfuB+XakG6UVnkw==
X-Google-Smtp-Source: ABdhPJxlQJksjPJyV51FNmVvfIOljU/i4uBmy//eqWN9Jxqs5lH3GejT/0DmpS9seYOkVZrG7fbQLHEqCT5UAGgTjKA=
X-Received: by 2002:a5b:94d:: with SMTP id x13mr10472941ybq.47.1626424264964;
 Fri, 16 Jul 2021 01:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210715182123.23372-2-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdU7zKFL_qio3vdTUgxPkQjxOW6K1TjPzDQja8ioYXYZNQ@mail.gmail.com>
In-Reply-To: <CAMuHMdU7zKFL_qio3vdTUgxPkQjxOW6K1TjPzDQja8ioYXYZNQ@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Fri, 16 Jul 2021 09:30:39 +0100
Message-ID: <CA+V-a8sLM_rnYps1Wnb=sh5cOGxLz02p9ewmkceK7CQXO1Yk6w@mail.gmail.com>
Subject: Re: [PATCH 1/6] dt-bindings: net: can: renesas,rcar-canfd: Document
 RZ/G2L SoC
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

On Fri, Jul 16, 2021 at 8:38 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > Add CANFD binding documentation for Renesas RZ/G2L SoC.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
>
> Thanks for your patch!
>
> > --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
>
> > @@ -78,6 +79,38 @@ patternProperties:
> >        node.  Each child node supports the "status" property only, which
> >        is used to enable/disable the respective channel.
> >
> > +if:
> > +  properties:
> > +    compatible:
> > +      contains:
> > +        enum:
> > +          - renesas,rzg2l-canfd
> > +then:
> > +  properties:
> > +    interrupts:
> > +      items:
> > +        - description: CAN global error interrupt
> > +        - description: CAN receive FIFO interrupt
> > +        - description: CAN0 error interrupt
> > +        - description: CAN0 transmit interrupt
> > +        - description: CAN0 transmit/receive FIFO receive completion interrupt
> > +        - description: CAN1 error interrupt
> > +        - description: CAN1 transmit interrupt
> > +        - description: CAN1 transmit/receive FIFO receive completion interrupt
>
> Does it make sense to add interrupt-names?
>
Agreed will drop this and add interrupt-names instead. Also I will
update the driver to pick up the interrupts based on names.

> > +
> > +    resets:
> > +      maxItems: 2
>
> Same here, for reset-names?
> Or a list of descriptions, so we know which reset serves what purpose.
>
OK I'll  add the reset-names.

Cheers,
Prabhakar

> > +
> > +else:
> > +  properties:
> > +    interrupts:
> > +      items:
> > +        - description: Channel interrupt
> > +        - description: Global interrupt
> > +
> > +    resets:
> > +      maxItems: 1
> > +
> >  required:
> >    - compatible
> >    - reg
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
