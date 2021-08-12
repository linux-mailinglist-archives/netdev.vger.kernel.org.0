Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01853EA193
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 11:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235617AbhHLJIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 05:08:47 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:38870 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235234AbhHLJIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 05:08:37 -0400
Received: by mail-ot1-f47.google.com with SMTP id 108-20020a9d01750000b029050e5cc11ae3so6920801otu.5;
        Thu, 12 Aug 2021 02:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zPqejfEgwNeF232a7WtoOVNGVMbj63Sq4HJ4EWIWtJM=;
        b=KUJR4LPOWg55N+OGNAIVpf9Qg9i3B5kxfMiycCLrc0I0WmXO4ya/eqycHd4TcJf3bd
         2naSpC7pBMHpsMruEfhhFGELeazyb58O+Bf1m+bFWS+EViMkdBnF618ltqNgQkRnlQrB
         M4NdlaNsg+cxH5C6c3STQnPvi0GKx3ek7k4wcy51B42Kq3I2FKLZUGlAPX/qiRI+eZuA
         4OlSw7lBEpjcppUt/gHjXs99lG6uUjFaKJba4GsDuFnwyqNSzEpeBtYCEu893hkR2mxT
         kgWin4F1QVwLt51a2diCggKJXH8YF2oQ9aJdktJcDhzMk8yzCBTcaaolYqHCA8dIqUqn
         i+yg==
X-Gm-Message-State: AOAM531QnCziDKuuQt2DTINLVD/Kbl1XTN/dael30M11/yB82DWHqs8O
        wAyKV3jnjPLg8olMxkyIQ6EuscaDGORqFz5cMRU=
X-Google-Smtp-Source: ABdhPJyHOdnyAO+AJopBgUjdSWYXUSxoKbddnc9mdhEQJSDd0hJLM0OzNMs6I0NKVoe8w5tKISMEUtPHudD4BcKVBdo=
X-Received: by 2002:a05:6830:154c:: with SMTP id l12mr2640284otp.250.1628759292107;
 Thu, 12 Aug 2021 02:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210727123450.15918-1-biju.das.jz@bp.renesas.com>
 <CAMuHMdVSWks7f31O3y4QuZLnztoQgG04CuCiZ9Beo-qKezNmbw@mail.gmail.com> <OS0PR01MB5922DDDBA73FB25B700B1E2A86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922DDDBA73FB25B700B1E2A86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 12 Aug 2021 11:07:59 +0200
Message-ID: <CAMuHMdU6iO+LkL5WURGMN7kkYLRJe9v3MbrqA_CBp74oskdeyA@mail.gmail.com>
Subject: Re: [PATCH v2] dt-bindings: net: renesas,etheravb: Document Gigabit
 Ethernet IP
To:     Biju Das <biju.das.jz@bp.renesas.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biju,

On Thu, Aug 12, 2021 at 11:00 AM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> > Subject: Re: [PATCH v2] dt-bindings: net: renesas,etheravb: Document
> > Gigabit Ethernet IP
> > On Tue, Jul 27, 2021 at 2:35 PM Biju Das <biju.das.jz@bp.renesas.com>
> > wrote:
> > > Document Gigabit Ethernet IP found on RZ/G2L SoC.
> > >
> > > Gigabit Ethernet Interface includes Ethernet controller (E-MAC),
> > > Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory
> > > access controller (DMAC) for transferring transmitted Ethernet frames
> > > to and received Ethernet frames from respective storage areas in the
> > > URAM at high speed.
> > >
> > > Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> > > Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> >
> > Thanks for your patch!
> >
> > > --- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> > > +++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> >
> > > @@ -145,14 +142,20 @@ allOf:
> > >        properties:
> > >          compatible:
> > >            contains:
> > > -            const: renesas,etheravb-rcar-gen2
> > > +            enum:
> > > +              - renesas,etheravb-rcar-gen2
> > > +              - renesas,rzg2l-gbeth
> > >      then:
> > >        properties:
> > >          interrupts:
> > > -          maxItems: 1
> > > +          minItems: 1
> > > +          maxItems: 3
> > >          interrupt-names:
> > > +          minItems: 1
> > >            items:
> > >              - const: mux
> > > +            - const: int_fil_n
> > > +            - const: int_arp_ns_n
> >
> > I'm aware Rob has already applied this, but should the "int_" prefix be
> > dropped?
>
> OK. I will use "fil" and "arp" instead.
>
> > The "_n" suffix is also a bit weird (albeit it matches the documentation).
> > Usually it is used to indicate an active-low signal, but the interrupt is
> > declared in the .dtsi with IRQ_TYPE_LEVEL_HIGH.
> >
>
> But here on the interrupt mapping table(RZG2L_InterruptMapping_rev01.xlsx). It is mentioned as high. So I guess, it is correct.
>
> > And the first interrupt is not a mux on RZ/G2L, but called "pif_int_n"
> > (whatever "pif" might mean).
>
> As per section 32.5.12 Interrupts, this interrupt include, Descriptor interrupts,
> Error interrupts, reception interrupts and transmission interrupts.
>
> The source status can be checked from individual status register.
>
> For me. This description looks like a mux interrupt.
> Multiple interrupt sources ored together to generate an interrupt and status can be
> Checked from each individual register.
> Please let me know if my understanding is wrong.
>
> I agree, on HW manual it is mentioned as pif_int_n. I can replace mux with pif instead. Please let me know.

Let's keep the mux, like on R-Car Gen2.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
