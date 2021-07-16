Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B80E3CB3D3
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 10:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237339AbhGPIMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 04:12:48 -0400
Received: from mail-vs1-f52.google.com ([209.85.217.52]:37420 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbhGPIMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 04:12:46 -0400
Received: by mail-vs1-f52.google.com with SMTP id r18so4512162vsa.4;
        Fri, 16 Jul 2021 01:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c+QdXf1Dp8sOLBR9I8aSGTjMZ2mzO+pWnGPEVTmQPOM=;
        b=l9gQd7eQslF5pLhvG02ql28xkiPO43wOdl9QQW94AkB7hzh2zzbepJDR5dXROXYDVz
         cImK4Q8FPNT29SBgkqs5ZF5gcGs+t8bEtIrKjG4Df6NzwDdcYv1LeXXrVhljth/o8CgJ
         W/v7gtRk4ddWf+pY4PAhxQvr2FihIG3jo4yTc3kryzzW/Zma7HRW+M7zHj51rQe7hSTV
         pL47W2YLgZ2HoA8QtZb+HE5Vnk0hFiGEdgrY44yakpXNejKMnd6swznBflNK1iMWOMFh
         QL8MfK69ZaAyPRIynmef1Isls5aN9ae81q9cLgxSN7eornBmJn4MhNrEzD+lKtwwEJXw
         80gA==
X-Gm-Message-State: AOAM532gFM6VNlaucDKb0dRZweGqAFw2R5RM9MQdMsMUZvTLNBgQK6po
        RzL8pQZQecsM4KllNSVk2xVcTBuVaCXlT2BGFkA=
X-Google-Smtp-Source: ABdhPJyNutZONAJmkBuZiUWHR0KYSKAlNfIaOgSO+u5sda16HFYbCuI1u9DY41ZG+s2pa8/+ScFg8p8Ml+HdzmSxgzE=
X-Received: by 2002:a67:3c2:: with SMTP id 185mr11135205vsd.42.1626422991190;
 Fri, 16 Jul 2021 01:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210715182123.23372-5-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210715182123.23372-5-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 16 Jul 2021 10:09:40 +0200
Message-ID: <CAMuHMdXYfAxvdRyn0FaqYSyD4qD2P=Et4-d3bPan9oy_YJ7tfg@mail.gmail.com>
Subject: Re: [PATCH 4/6] clk: renesas: r9a07g044-cpg: Add entry for fixed
 clock P0_DIV2
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
> Add entry for fixed core clock P0_DIV2 and assign LAST_DT_CORE_CLK
> to R9A07G044_LAST_CORE_CLK.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Thanks for your patch!

> --- a/drivers/clk/renesas/r9a07g044-cpg.c
> +++ b/drivers/clk/renesas/r9a07g044-cpg.c
> @@ -16,7 +16,7 @@
>
>  enum clk_ids {
>         /* Core Clock Outputs exported to DT */
> -       LAST_DT_CORE_CLK = R9A07G044_OSCCLK,
> +       LAST_DT_CORE_CLK = R9A07G044_LAST_CORE_CLK,

Please use R9A07G044_CLK_P0_DIV2 instead.

>
>         /* External Input Clocks */
>         CLK_EXTAL,
> @@ -77,6 +77,7 @@ static const struct cpg_core_clk r9a07g044_core_clks[] __initconst = {
>         DEF_FIXED("I", R9A07G044_CLK_I, CLK_PLL1, 1, 1),
>         DEF_DIV("P0", R9A07G044_CLK_P0, CLK_PLL2_DIV16, DIVPL2A,
>                 dtable_1_32, CLK_DIVIDER_HIWORD_MASK),
> +       DEF_FIXED("P0_DIV2", R9A07G044_CLK_P0_DIV2, R9A07G044_CLK_P0, 1, 2),
>         DEF_FIXED("TSU", R9A07G044_CLK_TSU, CLK_PLL2_DIV20, 1, 1),
>         DEF_DIV("P1", R9A07G044_CLK_P1, CLK_PLL3_DIV2_4,
>                 DIVPL3B, dtable_1_32, CLK_DIVIDER_HIWORD_MASK),

The rest looks good to me.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
