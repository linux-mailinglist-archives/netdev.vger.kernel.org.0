Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025133CB3C7
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 10:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237174AbhGPILC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 04:11:02 -0400
Received: from mail-vs1-f46.google.com ([209.85.217.46]:46698 "EHLO
        mail-vs1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236794AbhGPIK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 04:10:58 -0400
Received: by mail-vs1-f46.google.com with SMTP id e9so4510395vsk.13;
        Fri, 16 Jul 2021 01:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=giyrf2o1FzAiMPZMB+cuWH7FudholsSRDLHqp9OQQrc=;
        b=memBF8z/xVZ2yaFzAYxf8aquIVqzDJib+ig6ALJlM650ZIoq+aiyM2EIU//uG8xoQq
         flzIAmrggD6QF3AHPqE8kC/whBHtams6l+Zo20CGdcD+jMfE/2yctZ8KQU6cv6lEz7GF
         HT68oq8oQAKX+z2TMg5L/EBh77jQEfnYtWdFzA92xme8ROp1oR9RwVRJ4bOt2DJM9NRo
         zl9QcM0x3i9r0DUrk+d27n8/5w/na+p9Mi0qBC4Dqr+ZAzqtP3BFVqYaoznPSCeVv+vW
         /m1V/vv0poOynSVB98zexsUtxAD6BROQMtETz8IN2sZVbCxaJYFY+AeGCPwh6h9zb/up
         QANQ==
X-Gm-Message-State: AOAM532jNCd5B3LJB54Q4w9ydMD5z831nmrG9IHWlfko4yk2q1aZbM+Q
        TLtUgbHXPSezEWdHiwAivDMqOv7/oL2TA7WOsRM=
X-Google-Smtp-Source: ABdhPJyY6lB02joEzt/sNsOSQ95M/LFaERQ9kl8xif6voyXa1qRk8okeVP7gZaEFemB5tiHfFh8Yu6uAyJ75Ov78aZU=
X-Received: by 2002:a05:6102:321c:: with SMTP id r28mr11085935vsf.40.1626422882441;
 Fri, 16 Jul 2021 01:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210715182123.23372-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210715182123.23372-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 16 Jul 2021 10:07:51 +0200
Message-ID: <CAMuHMdV3JkV5D5_PsngoLiLPA_B1VBvRKsCz7j2tXKYVE_Bx9A@mail.gmail.com>
Subject: Re: [PATCH 3/6] dt-bindings: clk: r9a07g044-cpg: Add entry for
 P0_DIV2 core clock
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

Thanks for your patch!

On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add P0_DIV2 core clock required for CANFD module. CANFD core clock is
> sourced from P0_DIV2 referenced from HW manual Rev.0.50.

OK.

> Also add R9A07G044_LAST_CORE_CLK entry to avoid changes in
> r9a07g044-cpg.c file.

I'm not so fond of adding this.  Unlike the other definitions, it is
not really part of the bindings, but merely a convenience definition
for the driver.  Furthermore it has to change when a new definition
is ever added.

> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> ---
>  include/dt-bindings/clock/r9a07g044-cpg.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/dt-bindings/clock/r9a07g044-cpg.h b/include/dt-bindings/clock/r9a07g044-cpg.h
> index 0728ad07ff7a..2fd20db0b2f4 100644
> --- a/include/dt-bindings/clock/r9a07g044-cpg.h
> +++ b/include/dt-bindings/clock/r9a07g044-cpg.h
> @@ -30,6 +30,8 @@
>  #define R9A07G044_CLK_P2               19
>  #define R9A07G044_CLK_AT               20
>  #define R9A07G044_OSCCLK               21
> +#define R9A07G044_CLK_P0_DIV2          22
> +#define R9A07G044_LAST_CORE_CLK                23

Third issue: off-by-one error, it should be 22 ;-)

>
>  /* R9A07G044 Module Clocks */
>  #define R9A07G044_CA55_SCLK            0

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
