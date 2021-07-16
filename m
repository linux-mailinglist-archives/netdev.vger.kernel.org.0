Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5CD23CB363
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 09:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbhGPHlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 03:41:36 -0400
Received: from mail-vs1-f45.google.com ([209.85.217.45]:42681 "EHLO
        mail-vs1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbhGPHld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 03:41:33 -0400
Received: by mail-vs1-f45.google.com with SMTP id u7so4479122vst.9;
        Fri, 16 Jul 2021 00:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/8xw8kA+i02VusdPbd0JDRclj3jeC0DgBPnvEpMrBZo=;
        b=eXRKIlFJb5txJErZQlr54C0z65DSs1meTzz1poPWBkumvap6WBGWeDyCuXCxufOP3y
         jr0xhuE14rkhTTLkOhpcZSCXaGm8R/aRS9SQ5MRBz7SbxGafX8sPKbBhUFFfn0w4ELVG
         Hf2glLV09ggm/u2f5Ymt/S9YiLYFFPg6i8+2wdFNW4NO3uj8sus/1HQqJZ+0gzvVzuGx
         rufNsds94vKYXEb0kTB3GtCyra84Lx0Vjjno/6xK6Eq+FgG24RG9aD8zznYghPNZzQIN
         ddBgxyymAKAUAzjHyw8cFWpPtOrRq2iEvgBYPes7UgKLCoAhH3i/9E6UMTXpO7pZDFGY
         4wHA==
X-Gm-Message-State: AOAM531YEjpLT8Aurm8SG/omQUrJF9S55cVdcIpi449HrAQ1vqC7ABaT
        Vvi4py5yMvcrPsPxU81Jncez7m52AL9jy2xlGbY=
X-Google-Smtp-Source: ABdhPJzATlxh7v3TPVScN/pNQlX1LkPyBHWHSVXqQh9KOM24RerTxuY4NXa4lzjc15K3hgij1fF57C1RZ44OvNYZ4wQ=
X-Received: by 2002:a05:6102:2828:: with SMTP id ba8mr11030321vsb.18.1626421118272;
 Fri, 16 Jul 2021 00:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210715182123.23372-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210715182123.23372-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 16 Jul 2021 09:38:27 +0200
Message-ID: <CAMuHMdU7zKFL_qio3vdTUgxPkQjxOW6K1TjPzDQja8ioYXYZNQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] dt-bindings: net: can: renesas,rcar-canfd: Document
 RZ/G2L SoC
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
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
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add CANFD binding documentation for Renesas RZ/G2L SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml

> @@ -78,6 +79,38 @@ patternProperties:
>        node.  Each child node supports the "status" property only, which
>        is used to enable/disable the respective channel.
>
> +if:
> +  properties:
> +    compatible:
> +      contains:
> +        enum:
> +          - renesas,rzg2l-canfd
> +then:
> +  properties:
> +    interrupts:
> +      items:
> +        - description: CAN global error interrupt
> +        - description: CAN receive FIFO interrupt
> +        - description: CAN0 error interrupt
> +        - description: CAN0 transmit interrupt
> +        - description: CAN0 transmit/receive FIFO receive completion interrupt
> +        - description: CAN1 error interrupt
> +        - description: CAN1 transmit interrupt
> +        - description: CAN1 transmit/receive FIFO receive completion interrupt

Does it make sense to add interrupt-names?

> +
> +    resets:
> +      maxItems: 2

Same here, for reset-names?
Or a list of descriptions, so we know which reset serves what purpose.

> +
> +else:
> +  properties:
> +    interrupts:
> +      items:
> +        - description: Channel interrupt
> +        - description: Global interrupt
> +
> +    resets:
> +      maxItems: 1
> +
>  required:
>    - compatible
>    - reg

The rest looks good to me.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
