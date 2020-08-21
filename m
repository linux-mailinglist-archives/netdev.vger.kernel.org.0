Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5377724D572
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 14:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgHUMwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 08:52:18 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:38258 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgHUMwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 08:52:14 -0400
Received: by mail-ot1-f66.google.com with SMTP id q9so1467932oth.5;
        Fri, 21 Aug 2020 05:52:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XStHcO3bN1Cjx01hSjBlwatXDhCzhr4MQAvNLwapbP0=;
        b=RF3xcUVHkE4K4TwDNXLdzIRofwpTqEFlTCm6Nk/WfrHwNF6+il0Cc2PbI1f32fVFD1
         Kg2Exyj9RBhOQr2EftWGkIZDGo0ApKo0BknKwV/rN8w064KqWA1GWRpU8oWyuKKKnly8
         AEeWLxpY1QHjtKGCTBuehPwXDM/B0/28G2d4bjZnpg7uRK2U/6CE+ObisXseS/aKdIhn
         ZTEfdhBG4U7n7mavrbi8noR1XzGvFS0lsIpNGTZo9Unakw83p4MQpnl9A/+29oucgOUU
         jnx15dHDvREuvUhirkZryMZq0uzqGCu3JNeRpA8Z8x2giBF/0YDlFQ7gvER8YSfNx8m4
         7WVA==
X-Gm-Message-State: AOAM531IvmhwechgvFg+1Ns3gJ7U2SBx+Sywz4BwzkHpaB5atq0RP1CT
        RvF43Nbgbx1xVttxdUs8DZZKKqk9GM5tjHedCA0=
X-Google-Smtp-Source: ABdhPJziQqBk58uQyGqBK/37jXkqg84sLRiafHK9TanPnrCQmFw208l3InviG1UskKjtkSlXK4ncbbmuh6Gjfb8CCBU=
X-Received: by 2002:a9d:1b62:: with SMTP id l89mr1747958otl.145.1598014332829;
 Fri, 21 Aug 2020 05:52:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20200816190732.6905-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20200816190732.6905-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 21 Aug 2020 14:52:01 +0200
Message-ID: <CAMuHMdW2RTCi7rAa_tSsY7ukVM2xk6PYD526SRQU1Wd4SSz2Mw@mail.gmail.com>
Subject: Re: [PATCH 1/3] pinctrl: sh-pfc: r8a7790: Add CAN pins, groups and functions
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Prabhakar,

On Sun, Aug 16, 2020 at 9:07 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add pins, groups and functions for the CAN0 and CAN1 interface.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Don't you want to add the CAN_CLK pins, too?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
