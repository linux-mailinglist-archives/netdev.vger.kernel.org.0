Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417093CFC86
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240198AbhGTOAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240192AbhGTNvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:51:51 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C53C0613DF;
        Tue, 20 Jul 2021 07:31:55 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id a16so32973852ybt.8;
        Tue, 20 Jul 2021 07:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ed1Y4Okvup8k5YO3/YT98hea6PEaLzb9sqfNLq78+zk=;
        b=Nsx7ArD4Rci3ff1BKmU44+pNxlsryzBPiY/+GGrWoPNgzQMO45zmwSS7EWmAuj6eJ7
         PIzgY44+bOmKaNtipp5eOFBN51JrZpY1v5XTSxLlPFF6BtDHFD40Vwh4pGaUw54jLZe+
         Z9xAQdxwAUZFCqrQf4QIwowjSg7duc1XKn31MzT6DOEJSDYAldiszwIw3jHL5v4xZrtj
         Yd1gSUUvgW56j/idv2JoNsqQOmAMOrKuXE3bJq5b2RkZFkc6Ejs2qZJsUPumEMCgJfen
         kVQoR7tZIQBFjhRVXBAzYvwrFSleTiHkP45mpzp+0pNfJXdv7vMqpHlIqU3ISpDCzpc8
         Muvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ed1Y4Okvup8k5YO3/YT98hea6PEaLzb9sqfNLq78+zk=;
        b=VV31NDf80k+7zOZ8VQe6x3Lep29luZdyH5nO2JrOyc95DErTJ3UA6kSpxeqFJeEjXv
         ZcAI3e9/8NIF4ucYK+1ohx8wf/vpBIUfP0eM+R0LqfkTY95JUra/AL47s4xRmJxjiwhk
         SqHk6k+kn7xANd0ZIiwBNifX7x8fv7GEyQgPtaLIGNT+BsPS3ZJJVID9NYUl2XI68ntr
         VKlzE+VvIL8uaQLeS+gpw0F92EzaTBcB2FKFZgc7UtFkBsK6KWdQUByy8h5u5ZY2Rl1K
         nbREVNXYMNN3b0RFluBiuX9GdYNRTer7iCdVvw1n2U0Yco+7rJ7m45ey4if+AG8VdNBk
         9KFQ==
X-Gm-Message-State: AOAM5315EKYHEz5zqMllcsYclb0+T3kwD7L7Ruq6Pbh2prknq2yLdtcD
        EWBkGeVzmEyCBwcdGDOGC8eCrHjii2KFU11le80=
X-Google-Smtp-Source: ABdhPJwCf11Hq0YHSufyO0M1ZyMgmaPERHtjCoh9hI/YsFZqZm99LxXr558BP9gkYHMaHwj1/Wbfm3/vyZdZ6xp33OI=
X-Received: by 2002:a25:7e86:: with SMTP id z128mr38612042ybc.222.1626791514490;
 Tue, 20 Jul 2021 07:31:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210719143811.2135-2-prabhakar.mahadev-lad.rj@bp.renesas.com> <dc2de27b087c7030ea7e76dd31bb3d8bce18d97f.camel@pengutronix.de>
In-Reply-To: <dc2de27b087c7030ea7e76dd31bb3d8bce18d97f.camel@pengutronix.de>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 20 Jul 2021 15:31:28 +0100
Message-ID: <CA+V-a8v-54QXtcT-gPy5vj9drqZ6Ntr0-3j=42Dedi-kojNtXQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
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

Hi Philipp,

Thank you for the review.

On Tue, Jul 20, 2021 at 11:22 AM Philipp Zabel <p.zabel@pengutronix.de> wrote:
>
> Hi Lad,
>
> On Mon, 2021-07-19 at 15:38 +0100, Lad Prabhakar wrote:
> > Add CANFD binding documentation for Renesas RZ/G2L SoC.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > ---
> >  .../bindings/net/can/renesas,rcar-canfd.yaml  | 66 +++++++++++++++++--
> >  1 file changed, 60 insertions(+), 6 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > index 0b33ba9ccb47..4fb6dd370904 100644
> > --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > @@ -30,13 +30,15 @@ properties:
> >                - renesas,r8a77995-canfd     # R-Car D3
> >            - const: renesas,rcar-gen3-canfd # R-Car Gen3 and RZ/G2
> >
> > +      - items:
> > +          - enum:
> > +              - renesas,r9a07g044-canfd    # RZ/G2{L,LC}
> > +          - const: renesas,rzg2l-canfd     # RZ/G2L family
> > +
> >    reg:
> >      maxItems: 1
> >
> > -  interrupts:
> > -    items:
> > -      - description: Channel interrupt
> > -      - description: Global interrupt
> > +  interrupts: true
> >
> >    clocks:
> >      maxItems: 3
> > @@ -50,8 +52,7 @@ properties:
> >    power-domains:
> >      maxItems: 1
> >
> > -  resets:
> > -    maxItems: 1
> > +  resets: true
> >
> >    renesas,no-can-fd:
> >      $ref: /schemas/types.yaml#/definitions/flag
> > @@ -91,6 +92,59 @@ required:
> >    - channel0
> >    - channel1
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
> > +
> > +    interrupt-names:
> > +      items:
> > +        - const: g_error
> > +        - const: g_rx_fifo
> > +        - const: can0_error
> > +        - const: can0_tx
> > +        - const: can0_tx_rx_fifo_receive_completion
> > +        - const: can1_error
> > +        - const: can1_tx
> > +        - const: can1_tx_rx_fifo_receive_completion
> > +
> > +    resets:
> > +      items:
> > +        - description: CANFD_RSTP_N
> > +        - description: CANFD_RSTC_N
>
> Do you know what the "P" and "C" stands for? It would be nice if the
> description could tell us what the reset lines are used for.
>
unfortunately the HW manual does not mention  anything about "P" and "C" :(

> I would prefer if you used these names (or shortened versions, for
> example "rstp_n", "rstc_n") as "reset-names" and let the driver
> reference the resets by name instead of by index.
>
OK will do that and maxItems:2 for resets.

@Geert, for R-Car Gen3 does "canfd_rst" (as it's a module reset)
sounds good for reset-names? Or do you have any other suggestions?

Cheers,
Prabhakar
