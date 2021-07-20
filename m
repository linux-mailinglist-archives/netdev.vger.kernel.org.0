Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795B03CF7CA
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbhGTJls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 05:41:48 -0400
Received: from mail-vk1-f175.google.com ([209.85.221.175]:35390 "EHLO
        mail-vk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236430AbhGTJk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 05:40:27 -0400
Received: by mail-vk1-f175.google.com with SMTP id d7so4457431vkf.2;
        Tue, 20 Jul 2021 03:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t3ZjcsKyMCs8EAu6vLk3qNYhP9FzOKu10cixbnS0WFM=;
        b=AnXhBPICi8rm1xs6EGPMwaWX4F69FqPJYh1Sd4F15v7LfaoMS70xV+xzeLNFRCeK8m
         g80Fc5fHtrovjDV3DJ+VrlgD1+N+zZoTrHQKyM8bpa1SOojJYS7mRKV88EAtvyHQEtSn
         7l8hOdA1qVom41ch03q6k6pEu56lKZtdYMKMZ3Eyf4RbFR90o0UqkgerZAjslsKKf2aT
         f8Yvi6NXyJGSp/9mT8NLrGZZlddMuyJjKKt7ZQiDSmrqW0F1m+SxKjnbEgXe0XwW4sbC
         RngCLdW/DIBeDH8lhkEgvfXkP4jTxJFQDyKFDmNqW8vsTS9kqx8N2OnErlPLElg+Yet9
         VVSg==
X-Gm-Message-State: AOAM532H2JeV2RsNJnTVPiB0+OxM1q6As5nviXUDloHEKliW6+b5uH5h
        GiPOq7NE7vp/v/bDlmUEFWYYC84Nabo8Ww4u68S2UqhgLak=
X-Google-Smtp-Source: ABdhPJzwKBBMCHAKd1HCgWQzlIm99pF6UYc3GUznLjiSmkL+xSsHOJZ2HsElwYwl6AdrLpRDjH62WLjjBgovo33fffo=
X-Received: by 2002:a1f:2746:: with SMTP id n67mr25101438vkn.5.1626776464175;
 Tue, 20 Jul 2021 03:21:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210719143811.2135-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210719143811.2135-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 20 Jul 2021 12:20:53 +0200
Message-ID: <CAMuHMdV1cLZkvyocVrAo6n6Y73QZBGOUMeJKqjk533gqk_RVLg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] dt-bindings: net: can: renesas,rcar-canfd:
 Document RZ/G2L SoC
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
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
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Mon, Jul 19, 2021 at 4:39 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add CANFD binding documentation for Renesas RZ/G2L SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Just some bikeshedding on the exact naming below ;-)

> --- a/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> +++ b/Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
> @@ -91,6 +92,59 @@ required:
>    - channel0
>    - channel1
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
> +
> +    interrupt-names:
> +      items:
> +        - const: g_error
> +        - const: g_rx_fifo
> +        - const: can0_error

s/error/err/?

> +        - const: can0_tx
> +        - const: can0_tx_rx_fifo_receive_completion
> +        - const: can1_error
> +        - const: can1_tx
> +        - const: can1_tx_rx_fifo_receive_completion

s/receive/rx/?

Some are also a bit long to type.
Perhaps use naming closer to the User's Manual?

INTRCANGERR => g_err
INTRCANGRECC => g_recc
INTRCAN0ERR => ch0_err
INTRCAN0REC => ch0_rec
INTRCAN0TRX => ch0_trx
INTRCAN1ERR => ch1_err
INTRCAN1REC => ch1_rec
INTRCAN1TRX => ch1_trx

These do not have "_int" suffixes...

> +
> +    resets:
> +      items:
> +        - description: CANFD_RSTP_N
> +        - description: CANFD_RSTC_N
> +
> +  required:
> +    - interrupt-names
> +else:
> +  properties:
> +    interrupts:
> +      items:
> +        - description: Channel interrupt
> +        - description: Global interrupt
> +
> +    interrupt-names:
> +      items:
> +        - const: ch_int
> +        - const: g_int

... and these do have "_int" suffixes.

> +
> +    resets:
> +      items:
> +        - description: CANFD reset
> +
>  unevaluatedProperties: false

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
