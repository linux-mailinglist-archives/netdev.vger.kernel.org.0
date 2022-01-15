Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389CC48F43C
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 02:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiAOBqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 20:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiAOBqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 20:46:47 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F54C061574;
        Fri, 14 Jan 2022 17:46:47 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id v186so28686783ybg.1;
        Fri, 14 Jan 2022 17:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tWKYqjMToQiYNKjbuCtLFgDL3xooRgPiVQeOXmHwMgs=;
        b=nwt9fdkM8Jjyr8Qk9lQ3nikJt45z3ZIWItehvNMCq582HhZP8/Oh6b6RjDfJmYArPe
         ieCs/E6lFaO4d6AriWHvI+bzTth+kfSwjf1RnbHxYyyUKCIpNxKoe/QHJ9Q5jzcdFpfd
         FbGlZuzaiA44s0JyKbeHGe8aFfrl4DydWRmdRXsCOFni4zYlF/L493G0jeeKCEW+f/o2
         shvM/YO1PgtuMiXhu5GPDb4eobmjPwBx/YQMSvNEwy99/99y3mPq1RpE+EI9V9Zyoqe+
         I5XffLZuCwrZ2TllmVItNccGKkOw8Ve/hLX7dU2qKMm6ar7xWxxke9c9amp96VLpnUB5
         u7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tWKYqjMToQiYNKjbuCtLFgDL3xooRgPiVQeOXmHwMgs=;
        b=JzZDj96o6lX7kNjMFDSNhC0z3/j9GYl/544DuqZ5NEisNAU9C5ZTcnOTudbYWOjOkw
         dbjRaYeRAI0d2BfC4LaZAJQjWM+tazgs3JhRpvKSZyE/TEY+6dhMA8+2EwEc06pg1O5Q
         qdnke2dQg4dmyJdUWAjjrU7nPsjN1FO6Z8l+Lw7XdVRfbYQfi481AbhgOUCfXQ2d+w5N
         DEOiPIC+FyuKNNL1MNkIOjzNn/1PIYhSPI3wVif17g/5cOsHi/6aTOaHmi2mtn88+wot
         Vlw+Gik8QAmR6RE5tb4QFRPIwa4M9Dv88mPacmIRrx2OV4leY8nrurIKEJ6S3yCfGHRC
         OKoA==
X-Gm-Message-State: AOAM531/z/2M8M8qurQz34LOI9os+2GDjkx4N0xBpOrywUlAVYgtxdMA
        mQD2xoAPBjrQFpu6VbStbJvjAIGI9DPcUKyafaU=
X-Google-Smtp-Source: ABdhPJwgzZLZHSnjfCYS1rIjQLZjd5tRg1w+jXNopdsIY1kj6ZrznRiU7nGR8CaxCU3f3tXLpA+HKePIHs69ZRR2jjU=
X-Received: by 2002:a25:874a:: with SMTP id e10mr16006654ybn.422.1642211206642;
 Fri, 14 Jan 2022 17:46:46 -0800 (PST)
MIME-Version: 1.0
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-7-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdUB-wK_0Vqn4fmqQ0jaHWmo9OTRPT1bwWsZh76U1J729A@mail.gmail.com>
In-Reply-To: <CAMuHMdUB-wK_0Vqn4fmqQ0jaHWmo9OTRPT1bwWsZh76U1J729A@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Sat, 15 Jan 2022 01:46:20 +0000
Message-ID: <CA+V-a8sMfAT8DAxQJeAM6BvGOvrBE5sqVfm6ErS4y3wqT-UwVQ@mail.gmail.com>
Subject: Re: [PATCH 06/16] dt-bindings: serial: renesas,scif: Document RZ/V2L SoC
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thank you for the review.

On Tue, Jan 11, 2022 at 4:23 PM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Tue, Dec 21, 2021 at 10:48 AM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > From: Biju Das <biju.das.jz@bp.renesas.com>
> >
> > Add SCIF binding documentation for Renesas RZ/V2L SoC. SCIF block on RZ/V2L
> > is identical to one found on the RZ/G2L SoC. No driver changes are required
> > as RZ/G2L compatible string "renesas,scif-r9a07g044" will be used as a
> > fallback.
> >
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>
> Thanks for your patch!
>
> > --- a/Documentation/devicetree/bindings/serial/renesas,scif.yaml
> > +++ b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
> > @@ -67,6 +67,12 @@ properties:
> >        - items:
> >            - enum:
> >                - renesas,scif-r9a07g044      # RZ/G2{L,LC}
> > +              - renesas,scif-r9a07g054      # RZ/V2L
>
> As the idea is to rely on the RZ/G2L fallback for matching, cfr. below,
> the above addition is not needed or wanted.
>
Agreed I will drop that.

> > +
> > +      - items:
> > +          - enum:
> > +              - renesas,scif-r9a07g054      # RZ/V2L
> > +          - const: renesas,scif-r9a07g044   # RZ/G2{L,LC} fallback for RZ/V2L
> >
> >    reg:
> >      maxItems: 1
> > @@ -154,6 +160,7 @@ if:
> >            - renesas,rcar-gen2-scif
> >            - renesas,rcar-gen3-scif
> >            - renesas,scif-r9a07g044
> > +          - renesas,scif-r9a07g054
>
> This addition is not needed if the fallback is always present.
>
Ditto.
> >  then:
> >    required:
> >      - resets
>
> Given Greg already applied your patch, I think you have to send a
> follow-up patch.
Will do.

Cheers,
Prabhakar
