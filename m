Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79733CF81A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 12:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237569AbhGTKBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 06:01:20 -0400
Received: from mail-vs1-f52.google.com ([209.85.217.52]:43676 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236747AbhGTJ6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 05:58:40 -0400
Received: by mail-vs1-f52.google.com with SMTP id a66so10953111vsd.10;
        Tue, 20 Jul 2021 03:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CSO/icj4gzKZwgdBUMKYFWUyTK7NvNCfOpft3VKskeo=;
        b=SM08hSXDDv8IqRMCcmrpiyln7SaM2x80Dx31aLUACyGNZ/djx9JXyTFFx4Ad37BlTK
         P1SXbq4ns0CJOuJr8LUeoMS1PdKete/G3GqIlblv+TtbRZF57e61GeFRNXHzF+bYAg8f
         ORAUGvV6pTTz6q/S+fCX8xbj5ZoQV/E/sLj6AQ3eodPo3uVaNpkI57Td5xPPDQIN3Xrz
         gRjGByHKXZ80HAObrlOPVPeTLdNTh4ewaoPHqyckOJcu3A1X/qMAv8uKuVhrR6s2K+rL
         s9s7BsBmmyzw2oQO4HbnxboLyrrwq2poKetWoCh6ZdqS5xLl8xAsfMgb3Lds0UT6daKU
         181g==
X-Gm-Message-State: AOAM531/ftU7XlFuYnYRCUffR0xI8n4ssYSU/BNtzpVUvHY6fj7ZyKIr
        fpWksK77fEAbblueFTJa9ILiA1s7BMiV6qVZT8E=
X-Google-Smtp-Source: ABdhPJzRtcoT6owd3KcZf2ajJSjrqyZ2Ebluu5PNlZ7DbDPKNJmE2zJ7L7+yaj41O8uhqDPC+tueEC0bnsNjhfTlvzY=
X-Received: by 2002:a67:1542:: with SMTP id 63mr28883617vsv.40.1626777558174;
 Tue, 20 Jul 2021 03:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210719143811.2135-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210719143811.2135-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210719143811.2135-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 20 Jul 2021 12:39:07 +0200
Message-ID: <CAMuHMdWkeCxyaSfD2aQ346DV0n1JsxxUCB1jBD92evBYVVLFNg@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] dt-bindings: clk: r9a07g044-cpg: Add entry for
 P0_DIV2 core clock
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

On Mon, Jul 19, 2021 at 4:39 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add P0_DIV2 core clock required for CANFD module. CANFD core clock is
> sourced from P0_DIV2 referenced from HW manual Rev.0.50.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-r9a07g044-dt-binding-defs, to be shared by
renesas-clk-for-v5.15 and renesas-devel for v5.15.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
