Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AE73E4928
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 17:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235872AbhHIPti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 11:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235826AbhHIPtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 11:49:07 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5B5C0613D3;
        Mon,  9 Aug 2021 08:48:46 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id j77so30390773ybj.3;
        Mon, 09 Aug 2021 08:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CttDxHiCnPodE+fRVXutDrc3UtK9OxegaBoQba6T7pg=;
        b=HSNxa2u8osQbqxNs8P6Yow3+3cv6sFFXG7vuRpeSOrtXnoQ9NIs1NzgEQ3bPz9vrF8
         CzUzTyZ/kpguld6CZ2y6TpVHCA0J/WQUjGCBnK6eT8r6wdyso6LNH6MlLwyEteO9Ki+M
         XQIpH1yVy9eB/16PnXa40PlU+GDorTpOKWWXsJRo1Ev9hCfPDGIwWW+X/wB5btHSh78A
         HRXaCwxwdvewUK/Qj8OUAGwzlIHGj+PJSfuaBu9d876+cZ9vZ6WyIj/RfgboWgvDKidT
         4Yqsce1J40lFu73UHz+bVpWONsl0qiJz4trpIddBFEtaUsjyysL1XodCku/3ZVnRZYUb
         UHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CttDxHiCnPodE+fRVXutDrc3UtK9OxegaBoQba6T7pg=;
        b=GOlq8tbrYSghkYNumIvCmcqzP9j6N5MTE3MSjE+BkTnPdEThs8tuJo4i3/uT2I9g87
         FyGomH9ioeZa1kyXrA6Rqmg5rR1ow1KOhvfREqFpryV6QDaxiW8eKdk9lIbHnjChTlNL
         ss0HBNUFgEtPRX2UokKuDDhhBzKupxnJkANZhhNuu2E7g+2uBSwjW70SA+Z+Rzuq7j9t
         KzXkC1Hwq0zdPCow6/GZEmFL8xkNAhzJzdc6dHqbG+LMhDCB9mkCNFFxCW1+jAd3ztNC
         0iCgOni9kt0fTYmyNXXysG5/lB0IQtut3OlhXdj2d+fVo/YcU/HW1WuuANQewQ2pNZms
         NizQ==
X-Gm-Message-State: AOAM532gXUtjcoRDdp7z6DAjzEKXQARzLKfMZqy11R4ElUy1GJ1WP1Np
        j6pME4lJAIOJKfRQwvtvsYCsSrQZsBFCfYG0GQ4=
X-Google-Smtp-Source: ABdhPJx2fmwsYZrAdA/dVqw0R46k9XdivjCwFnQGurTZ8bcpvGyuWuvhsRqVC4wmjDtleYKdnU8JdnU9oa37iK0Uajc=
X-Received: by 2002:a5b:2cf:: with SMTP id h15mr25624687ybp.426.1628524126062;
 Mon, 09 Aug 2021 08:48:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20210727133022.634-2-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210809132605.m76mnxkp6bdcn77c@pengutronix.de>
In-Reply-To: <20210809132605.m76mnxkp6bdcn77c@pengutronix.de>
From:   "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date:   Mon, 9 Aug 2021 16:48:20 +0100
Message-ID: <CA+V-a8uDPn83W6wi2Jq8VFrBeGSVMPMiFmXGV2z=L8xxZteFNQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Mon, Aug 9, 2021 at 2:26 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 27.07.2021 14:30:20, Lad Prabhakar wrote:
> > Add CANFD binding documentation for Renesas RZ/G2L SoC.
> >
> > Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> > Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> > Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > ---
> >  .../bindings/net/can/renesas,rcar-canfd.yaml  | 69 +++++++++++++++++--
> >  1 file changed, 63 insertions(+), 6 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> > index 0b33ba9ccb47..546c6e6d2fb0 100644
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
> > @@ -91,6 +92,62 @@ required:
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
> > +        - const: g_err
> > +        - const: g_recc
> > +        - const: ch0_err
> > +        - const: ch0_rec
> > +        - const: ch0_trx
> > +        - const: ch1_err
> > +        - const: ch1_rec
> > +        - const: ch1_trx
> > +
> > +    resets:
> > +      maxItems: 2
> > +
> > +    reset-names:
> > +      items:
> > +        - const: rstp_n
> > +        - const: rstc_n
> > +
> > +  required:
> > +    - interrupt-names
> > +    - reset-names
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
> Are you adding the new interrupt-names to the existing DTs, too?
> Otherwise this patch will generate more warnings in the existing DTs.
>
For non RZ/G2L family interrupt-names property is not marked as
required property so dtbs_check won't complain. Once we have added
interrupt names in all the SoC DTSI's we will mark it as required
property for the rest of the SoC's.

Cheers,
Prabhakar

> regards,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
