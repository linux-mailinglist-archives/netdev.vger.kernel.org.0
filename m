Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B903CFC8A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhGTOAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239541AbhGTN5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 09:57:21 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E66FC061574;
        Tue, 20 Jul 2021 07:37:46 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id v189so33052668ybg.3;
        Tue, 20 Jul 2021 07:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=twAcJwRNZdn+hWF5eUUfRv0NDfKoXSW2Ryat6Jwflqo=;
        b=sfbDpPPNijKyZ6UiRIh5zgydDChl1eYmSO177LQ0yoCG6RUj36kmUTPJo+RIz+wFnq
         zp/s6taOtwOiSasGeavhSCYtFQ864wSdmGwUbs9tKPPqHyWGc72LysIzT1pzskxE4QR0
         pAXwrdRllNJ8YTQkbwiPT3J8BFMXSPxJ4STzyDjhm1x+lMdncyosKw+ZU3MTtcMPBpqt
         2KtxPeKnmyjR9vWroZ2zo+8MX9la4ndE7gDmTK+4C+6i/Uyu7fEcKhbtEdwcDFUDKD1x
         QpqirVBkaAolKP3ls5aMwrakG5GcvxcSisq87W0XMiiHhvOsFyEgbu2phzdlFMZbb1yT
         RBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=twAcJwRNZdn+hWF5eUUfRv0NDfKoXSW2Ryat6Jwflqo=;
        b=XTfHCE04ZHXxdbAHZdNMrIVpJAvoGf2Wg2GAwOEoLPvMHVazJapiVAmhhjtVP4KMpl
         l2hB3JnoE0E+kTOlzWwxT3K1/TYnBsN7cREL/WuJZpjT4foO5/ZaWTUnG7rjqAP2idOv
         AJRBsGUj+fALaEYVZN1euF9kSl5l5FyVnqCI+RteTmlC1TQxxf2oLCRHvqqFeMJ/XlRr
         iNQ6m4B4M1G0Fpb9k9xl/ZGDTgmlqaAfiptdTntqwosvgGA2eCsFLjcwXPX73dS+whjO
         n6qEoXn7yYwV5JOw/CNs10RzSuS17Bg1YGYkGg7llje0ETde1/wGmKOXfrKp3qGDaePd
         H8Lw==
X-Gm-Message-State: AOAM530n2VB1ctg9vh01ITtDpmH9iwar2gzxqsnk7VQ4PcPjD9Xi3icT
        HeXwvrGbaViVVoUn97tI0AHSrmJnB9eLL9jJOMYAJPyJs3k=
X-Google-Smtp-Source: ABdhPJyAcO8dYvfHnYTMIJBpgaNLQrfDXOatIRgq5EcoKOshwfU5hDRIuaNZ9zCFEILzu6oKVT0xeH75bB2s95FlkyE=
X-Received: by 2002:a25:d491:: with SMTP id m139mr38146443ybf.156.1626791865876;
 Tue, 20 Jul 2021 07:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210719143811.2135-2-prabhakar.mahadev-lad.rj@bp.renesas.com> <CAMuHMdV1cLZkvyocVrAo6n6Y73QZBGOUMeJKqjk533gqk_RVLg@mail.gmail.com>
In-Reply-To: <CAMuHMdV1cLZkvyocVrAo6n6Y73QZBGOUMeJKqjk533gqk_RVLg@mail.gmail.com>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Tue, 20 Jul 2021 15:37:20 +0100
Message-ID: <CA+V-a8s8gO5M_+2XBWoknxDL0nnY9PNtPr0PYfqYgv_SeRd7Sg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
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

On Tue, Jul 20, 2021 at 11:21 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Prabhakar,
>
> On Mon, Jul 19, 2021 at 4:39 PM Lad Prabhakar
> <prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> > Add CANFD binding documentation for Renesas RZ/G2L SoC.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
>
> Thanks for your patch!
>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Just some bikeshedding on the exact naming below ;-)
>
> > --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
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
>
> s/error/err/?
>
> > +        - const: can0_tx
> > +        - const: can0_tx_rx_fifo_receive_completion
> > +        - const: can1_error
> > +        - const: can1_tx
> > +        - const: can1_tx_rx_fifo_receive_completion
>
> s/receive/rx/?
>
> Some are also a bit long to type.
> Perhaps use naming closer to the User's Manual?
>
> INTRCANGERR => g_err
> INTRCANGRECC => g_recc
> INTRCAN0ERR => ch0_err
> INTRCAN0REC => ch0_rec
> INTRCAN0TRX => ch0_trx
> INTRCAN1ERR => ch1_err
> INTRCAN1REC => ch1_rec
> INTRCAN1TRX => ch1_trx
>
> These do not have "_int" suffixes...
>
Agreed thanks for the input.

> > +
> > +    resets:
> > +      items:
> > +        - description: CANFD_RSTP_N
> > +        - description: CANFD_RSTC_N
> > +
> > +  required:
> > +    - interrupt-names
> > +else:
> > +  properties:
> > +    interrupts:
> > +      items:
> > +        - description: Channel interrupt
> > +        - description: Global interrupt
> > +
> > +    interrupt-names:
> > +      items:
> > +        - const: ch_int
> > +        - const: g_int
>
> ... and these do have "_int" suffixes.
>
indeed

Cheers,
Prabhakar
> > +
> > +    resets:
> > +      items:
> > +        - description: CANFD reset
> > +
> >  unevaluatedProperties: false
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
