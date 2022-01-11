Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA0C48B1FF
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349927AbiAKQXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:23:13 -0500
Received: from mail-vk1-f181.google.com ([209.85.221.181]:46638 "EHLO
        mail-vk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343692AbiAKQXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:23:11 -0500
Received: by mail-vk1-f181.google.com with SMTP id bj47so5699666vkb.13;
        Tue, 11 Jan 2022 08:23:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ibmuXY2d4QvS3H2IyD2t1BJ8+qE8/4OrKlqbySBpfZw=;
        b=ylhhRGbEhSPbcK4ThoW9iayv006f31oxB20wWz0R9WqZozvAVnQNCqlInGnQpSCVvr
         H4mJnUkLY0bJvNtAPyJZsib95cSPLp/gRhCnqels13DjMAyqSp4qOVfC143opebBwfGs
         BLaEmo9dPs1hHbzWFSCmpTGGnpu31aPNRzX/eqlYLMcnHWIXnOm8T0mzwH8ys0DpUV2B
         /8rRdrCOslHB9wtm4QZ2R/cyVE9iYjJu5oCXxBGmPYqm/YLa5OPMM/NW5dyg2gwweJKm
         3UsNaD1d6P16cA0Qy79GMiFBXZTwST7TIJt8wWf7q0VJDewK+6oEPj0plvOySnQv2PqO
         ZrHA==
X-Gm-Message-State: AOAM532+NziSDCHV9kb8LHAOehVDRzRw+14YVMbtbcDrG7JiPpBsTGFt
        +oLOscPwhm6uTmy3O1d7dCki5SvF+v7kxQ==
X-Google-Smtp-Source: ABdhPJz6Xep7GQaFwxXXg6FUTH81husz/nDPykOeiqNGzei76rMt++y0edT5C90dPr5u5VVGvRfC5g==
X-Received: by 2002:a05:6122:2225:: with SMTP id bb37mr2380426vkb.27.1641918190405;
        Tue, 11 Jan 2022 08:23:10 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id l27sm3593845vko.17.2022.01.11.08.23.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 08:23:09 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id c36so30643243uae.13;
        Tue, 11 Jan 2022 08:23:09 -0800 (PST)
X-Received: by 2002:a67:e985:: with SMTP id b5mr2267085vso.77.1641918189316;
 Tue, 11 Jan 2022 08:23:09 -0800 (PST)
MIME-Version: 1.0
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20211221094717.16187-7-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20211221094717.16187-7-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 11 Jan 2022 17:22:58 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUB-wK_0Vqn4fmqQ0jaHWmo9OTRPT1bwWsZh76U1J729A@mail.gmail.com>
Message-ID: <CAMuHMdUB-wK_0Vqn4fmqQ0jaHWmo9OTRPT1bwWsZh76U1J729A@mail.gmail.com>
Subject: Re: [PATCH 06/16] dt-bindings: serial: renesas,scif: Document RZ/V2L SoC
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>,
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
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Tue, Dec 21, 2021 at 10:48 AM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
>
> Add SCIF binding documentation for Renesas RZ/V2L SoC. SCIF block on RZ/V2L
> is identical to one found on the RZ/G2L SoC. No driver changes are required
> as RZ/G2L compatible string "renesas,scif-r9a07g044" will be used as a
> fallback.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/serial/renesas,scif.yaml
> +++ b/Documentation/devicetree/bindings/serial/renesas,scif.yaml
> @@ -67,6 +67,12 @@ properties:
>        - items:
>            - enum:
>                - renesas,scif-r9a07g044      # RZ/G2{L,LC}
> +              - renesas,scif-r9a07g054      # RZ/V2L

As the idea is to rely on the RZ/G2L fallback for matching, cfr. below,
the above addition is not needed or wanted.

> +
> +      - items:
> +          - enum:
> +              - renesas,scif-r9a07g054      # RZ/V2L
> +          - const: renesas,scif-r9a07g044   # RZ/G2{L,LC} fallback for RZ/V2L
>
>    reg:
>      maxItems: 1
> @@ -154,6 +160,7 @@ if:
>            - renesas,rcar-gen2-scif
>            - renesas,rcar-gen3-scif
>            - renesas,scif-r9a07g044
> +          - renesas,scif-r9a07g054

This addition is not needed if the fallback is always present.

>  then:
>    required:
>      - resets

Given Greg already applied your patch, I think you have to send a
follow-up patch.
Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
