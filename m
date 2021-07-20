Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990843CF810
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbhGTKAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:00:14 -0400
Received: from mail-vs1-f41.google.com ([209.85.217.41]:42647 "EHLO
        mail-vs1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbhGTJ7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 05:59:12 -0400
Received: by mail-vs1-f41.google.com with SMTP id u7so10964636vst.9;
        Tue, 20 Jul 2021 03:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CVIxBg628PAwDy/vo0ZmoulomT3dP+R815FPvXclsao=;
        b=i6zUi2zFGiUf758QvKHeDisW1Yyhw8CN/CJeKYrd1gxzicxiqWeoIpQQSXUbBwL702
         wQd5LLrVzZRIybhYHhVv4cfTcSRD09oaOs9m22Vmj8IAQ4xpPqXYj4xDtbV+Nno/3i+q
         Tm+tx+deC0mReIw8gokcWX5DJ36vsc2Q+4f7fQopIrKGl+SFuNRIIu9T+fBsIRGYe8QI
         iOmlzjv/A2OsTf9H2FeClZI7UVzajvBlDPV9urbtURS56mSJKJ4VrJ3dLCW+MfxYl74t
         fyEl0LSpFC4DO7fiPV2Y8U2d205T6xahLIZYBOynfg5j1XYzeQG4pI5y1B1ouY3nAji7
         jWbw==
X-Gm-Message-State: AOAM533jWVJe/VpoKp/7CZ3xy2Xfbgovf6Izbu5UmnZutSm/t1wgIgaI
        RU4vuVXDll3pjPlxw7CGvhvk1eS+Oh+6FKaTGZc=
X-Google-Smtp-Source: ABdhPJwdSimcy72NVuCQcZHymT6OXIFKfyNe/sBA/FR+wAEOfy6VNjuVPwJUkNefHXoUgy46bedfu9+7qODNk6hj3Zc=
X-Received: by 2002:a05:6102:2828:: with SMTP id ba8mr28494942vsb.18.1626777589760;
 Tue, 20 Jul 2021 03:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210719143811.2135-5-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210719143811.2135-5-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 20 Jul 2021 12:39:38 +0200
Message-ID: <CAMuHMdXQKmG-pdnh+M27CDMfTYrC7eq1kdyAb5P5Pgyc22vs+g@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] clk: renesas: r9a07g044-cpg: Add entry for fixed
 clock P0_DIV2
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

On Mon, Jul 19, 2021 at 4:40 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add entry for fixed core clock P0_DIV2 and assign LAST_DT_CORE_CLK
> to R9A07G044_CLK_P0_DIV2.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-clk-for-v5.15.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
