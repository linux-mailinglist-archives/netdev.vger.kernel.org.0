Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53773EA08E
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 10:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbhHLI1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 04:27:48 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:37486 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234537AbhHLI1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 04:27:46 -0400
Received: by mail-oi1-f172.google.com with SMTP id u10so9179768oiw.4;
        Thu, 12 Aug 2021 01:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Chc1EtA/5xSBngN4tuM8yqAZTFLQsfvJ1HOJL5ltbyY=;
        b=i5Z6m3le7lPZC9lwpb6xLynRSApKf+Lcckz8H1mRYbgwhmiosngA49miiHxDjfdJa+
         D3ly7HPWpb/+P6gHDsOqtUrrNkLvWRa2rox1AjncnBS/QTdzntab4Mv6ec2Ezygz6iq5
         b3j4Q+pnDLdngdphI1Sr5l/yTnq0Ri9wSMl7C2tkfVCg6ZOxwfGLXNTfP/E6C3MKwb2G
         i6d35O+ezoRx7DQMk6i344Ids/3MLWBdewCpfkJG5bqsUAfLAM8c2/qV92WsoYdfm6z6
         iQ+vZh9rVQ0s1CE0U0ddHKKQoYAHqNTJPMSPcMOSH3Ta+J6YdwLG9epogdNJ2VIw77QX
         0zcg==
X-Gm-Message-State: AOAM532a5+2DuwCSqtlRjO32sTLD0ZSfz0Q0FOFDKkjHZi/w9T3gjrPM
        ilFI+zVpMgQCw7Z5Yo1a+ta2L5sGVn2WIKxR4no=
X-Google-Smtp-Source: ABdhPJwkpNCv4jLtBUHf6cafPnLz2FvFiIkPjFhfIQ+eyJQSNqDMXc6E0d6Ef+/HMHoWdep3yNd0kLMBqEe4K/nTil0=
X-Received: by 2002:aca:4e06:: with SMTP id c6mr10938182oib.161.1628756841363;
 Thu, 12 Aug 2021 01:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210727123450.15918-1-biju.das.jz@bp.renesas.com>
In-Reply-To: <20210727123450.15918-1-biju.das.jz@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 12 Aug 2021 10:27:09 +0200
Message-ID: <CAMuHMdVSWks7f31O3y4QuZLnztoQgG04CuCiZ9Beo-qKezNmbw@mail.gmail.com>
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

On Tue, Jul 27, 2021 at 2:35 PM Biju Das <biju.das.jz@bp.renesas.com> wrote:
> Document Gigabit Ethernet IP found on RZ/G2L SoC.
>
> Gigabit Ethernet Interface includes Ethernet controller (E-MAC),
> Internal TCP/IP Offload Engine (TOE) and Dedicated Direct memory
> access controller (DMAC) for transferring transmitted Ethernet
> frames to and received Ethernet frames from respective storage
> areas in the URAM at high speed.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Reviewed-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> +++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml

> @@ -145,14 +142,20 @@ allOf:
>        properties:
>          compatible:
>            contains:
> -            const: renesas,etheravb-rcar-gen2
> +            enum:
> +              - renesas,etheravb-rcar-gen2
> +              - renesas,rzg2l-gbeth
>      then:
>        properties:
>          interrupts:
> -          maxItems: 1
> +          minItems: 1
> +          maxItems: 3
>          interrupt-names:
> +          minItems: 1
>            items:
>              - const: mux
> +            - const: int_fil_n
> +            - const: int_arp_ns_n

I'm aware Rob has already applied this, but should the "int_" prefix
be dropped?
The "_n" suffix is also a bit weird (albeit it matches the
documentation). Usually it is used to indicate an active-low signal,
but the interrupt is declared in the .dtsi with IRQ_TYPE_LEVEL_HIGH.

And the first interrupt is not a mux on RZ/G2L, but called "pif_int_n"
(whatever "pif" might mean).

>          rx-internal-delay-ps: false
>      else:
>        properties:

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
