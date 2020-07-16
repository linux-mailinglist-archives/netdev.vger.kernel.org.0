Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B56A22274D
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgGPPjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:39:11 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39240 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbgGPPjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:07 -0400
Received: by mail-oi1-f195.google.com with SMTP id w17so5422731oie.6;
        Thu, 16 Jul 2020 08:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yu8AcriWX3+yo8BiZDGLRtunrtLKttc1XLs4wvDEUps=;
        b=YIrvU9p1o0ANLrdbVqR7qfAi9LJhRI/aw+RWrQdO9tLlSrFIQ2XElpRJwmd6WDL3Da
         xiSreaDXn4GL5nG08pELq9QLwWSJ8uQWQn9M2iUZ8+NRvDrKY6d22W3Iu+P9pfsFGuxb
         FowQ+SLnbl0Mv7f+IZGO+YgbNr5B/261pZLHqKUngKvcF/g+XB81UJS63T4yTHpMeuN0
         grHKEwkMfo7XhaK7hz010apIgBhG5nXIpnNqIwKlG4t+PPT7aDi1Stj0Y7QU/lvIl2cp
         aMf6zF5EFKJML7LFVC55nTuppT/W28Ot5AePA/8i2p7EEC9+En+TAPTB0yTeKbSsr36P
         i0sw==
X-Gm-Message-State: AOAM533xSUtJDkcIFi3M/VCM6CMSNBESE2g4iFWAXju+GlE4yn20DvKH
        aS4aSOSDHsY6KnCr3KHSVA9gIh0EplTTXLmXFrQ=
X-Google-Smtp-Source: ABdhPJz7Nwn+4sTFc6lpaCuTWPVIIEYyDkHi7RbGunkkr/cHBSPm62tq9ZP31mM88tUGaMPM+XdhO5cSQk5iRCsLngU=
X-Received: by 2002:a05:6808:64a:: with SMTP id z10mr4320772oih.54.1594913945890;
 Thu, 16 Jul 2020 08:39:05 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:38:54 +0200
Message-ID: <CAMuHMdVpkkVu61gvgNJGfeGpz+c3dWswg6R1rXqeKv+bx-2SSg@mail.gmail.com>
Subject: Re: [PATCH 08/20] arm64: dts: renesas: r8a774e1: Add TMU device nodes
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Niklas <niklas.soderlund@ragnatech.se>,
        Zhang Rui <rui.zhang@intel.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-can@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 1:10 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> This patch adds TMU[01234] device tree nodes to the r8a774e1
> SoC specific DT.
>
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.9.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
