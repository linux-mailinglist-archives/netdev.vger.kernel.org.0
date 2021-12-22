Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9636847D779
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 20:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345116AbhLVTK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 14:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233746AbhLVTK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 14:10:58 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B067C061574;
        Wed, 22 Dec 2021 11:10:58 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id y68so9589955ybe.1;
        Wed, 22 Dec 2021 11:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q1hdt0rDFdHxjRFH+PlDJWOqrqXjNMYQgzxO9JoTv1M=;
        b=FH2OIxLlfjCXKeNd/w+tj2e0QGACBuGzCP0Fhd3T/Tf2/WdQsKb4rYZVS+uTdEgxjj
         O8FmiismtHSnMdjGL8U7TWJ7AuREpe6l+UTCVnut4l7vAUjTvISWXO4RJPWd1jOBRJMH
         sR2+14tkAKlD7YIqeMmFFzYoHWu6OCqOZPGUl6z5rR7yJdsI2czfK2MiJ2TRCownNX0r
         Ux8sjsqDU6wwIxuKIeX1dJTdiKnS3s1OKu+6pNjudwWl6zXpFfkP5v66ZVq2d8Apho6W
         FOeJD42qUSwtcdx9n1MmOYObey+UGMeNvY6UAq6hZi8RTmTn2GT7AIJDb6SsXuaVZy8t
         Cu1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q1hdt0rDFdHxjRFH+PlDJWOqrqXjNMYQgzxO9JoTv1M=;
        b=19U+CsRDxhx9V1Q8Cat4jEibhW0BS+9+PMDwhcDqQI+vNdnU9maajMmlF0+vMsCWfd
         5y3TVbDhxSLbTg11QzIjzeFzDgJijdOk1rv6+DOM7whB3PX46bm0qYxI1sIMUsr2ujW/
         PR7RICQM/MX5+Rq8OKgH3IIvvl+GV7kuE7AWz2G+15O05MoeZjDf47domItn361g9hUa
         BT9Wu6YAzB8qjyLWtsrQfGceEc+AxK3+oVrJcN8E5Ak/Sqlno+ql9JJPnWqvG5QscYGU
         FAQ2HILM1DX2SlpaBR2qNojGQ/6X2c4PCCXqMIF0swCB1Y97X5O+YAYMm6z777KDZwQx
         N6XA==
X-Gm-Message-State: AOAM5323Zg4Nn7Lfa/t/ESzjidVjjlBM4c2+D9LAaen/piFCkA5Y1fVq
        1vka1SL0EKgATlExOeEjHBnTt43E/OwgBZo1zLo=
X-Google-Smtp-Source: ABdhPJz//MnasOLSuKMhIkomj1Wv97uOQxSUzI7hnBEHjkfeiJQY3u0+Z4FPT5sDi7cOY5fXd4ytr3iALOVPk1fQlgM=
X-Received: by 2002:a5b:ecd:: with SMTP id a13mr6058913ybs.251.1640200257217;
 Wed, 22 Dec 2021 11:10:57 -0800 (PST)
MIME-Version: 1.0
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20211221094717.16187-2-prabhakar.mahadev-lad.rj@bp.renesas.com> <YcNtAtVZgM+Z9i3X@robh.at.kernel.org>
In-Reply-To: <YcNtAtVZgM+Z9i3X@robh.at.kernel.org>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Wed, 22 Dec 2021 19:10:31 +0000
Message-ID: <CA+V-a8sjY7JOYuXhh50nfk9U+QdF0vQ5w-O9aLHGURfU8hKc0Q@mail.gmail.com>
Subject: Re: [PATCH 01/16] dt-bindings: arm: renesas: Document Renesas RZ/V2L SoC
To:     Rob Herring <robh@kernel.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
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
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thank you for the review.

On Wed, Dec 22, 2021 at 6:23 PM Rob Herring <robh@kernel.org> wrote:
>
> On Tue, Dec 21, 2021 at 09:47:02AM +0000, Lad Prabhakar wrote:
> > From: Biju Das <biju.das.jz@bp.renesas.com>
> >
> > Document Renesas RZ/V2L SoC.
> >
> > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > ---
> >  Documentation/devicetree/bindings/arm/renesas.yaml | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/arm/renesas.yaml b/Documentation/devicetree/bindings/arm/renesas.yaml
> > index 6a9350ee690b..55a5aec418ab 100644
> > --- a/Documentation/devicetree/bindings/arm/renesas.yaml
> > +++ b/Documentation/devicetree/bindings/arm/renesas.yaml
> > @@ -421,6 +421,13 @@ properties:
> >                - renesas,r9a07g044l2 # Dual Cortex-A55 RZ/G2L
> >            - const: renesas,r9a07g044
> >
> > +      - description: RZ/V2L (R9A07G054)
> > +        items:
> > +          - enum:
> > +              - renesas,r9a07g054l1 # Single Cortex-A55 RZ/V2L
> > +              - renesas,r9a07g054l2 # Dual Cortex-A55 RZ/V2L
>
> I'd assume this is just a fuse difference and with cpu nodes you can
> distinguish how many cores.
>
Yes and there is a register too which tells the CPU count.

Cheers,
Prabhakar

> > +          - const: renesas,r9a07g054
> > +
> >  additionalProperties: true
> >
> >  ...
> > --
> > 2.17.1
> >
> >
