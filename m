Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8956022273F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbgGPPi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:38:57 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45742 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbgGPPi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:38:56 -0400
Received: by mail-ot1-f65.google.com with SMTP id h1so4524111otq.12;
        Thu, 16 Jul 2020 08:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U90hHEc54jdrWNma8Ae66aUnovbTk060PhIZQuQR+QY=;
        b=Byt9bKj4gM5ybZPk/tMcE2C+FKnbynrlDnBkbpp8R1bgpyMEkhAptqZutYQ2IrV1oX
         V1NwkwizhYquGkzMpAv1dgDr4pguOftRFEU1V2QAs6QeZFpwk+bSgQUgEZaLUeiQ0axc
         zSnBxbwct4Dr6c2lA9K7fN6Xe2kRCbPzrNCJioVEixDMPvB0N3zfBoW5hk5zEJMpXglY
         J3rZQX+e0KO3MuMxHr5Tpi16xyrGlpxIXH7fLQDQux01lZzPfUt7FezhWnY+2e3TaIT9
         H9YN8X0iMCr9T6t66f2F83c31V6djPGtkpJq377twI+uxy0LT0uC2DlbmGQsLLU1tzwL
         o/mQ==
X-Gm-Message-State: AOAM533lbWJfcbW8dyfxqWJRCwbclNkPqkaXs5wUvyc9OEVSiBoQLXpQ
        nLfH0g2C3ZOK/d0df2h1V+pJRntyddOx5q6SiqQ=
X-Google-Smtp-Source: ABdhPJwZ5OQQ9EGRyQ3xUMXe0z77A9hIeMmqlCkxDKaqcv1Z/fgnXN/N+/X37FauDrLUuxCrtlxdJJObhqTJMAWoTSQ=
X-Received: by 2002:a05:6830:1451:: with SMTP id w17mr5037827otp.250.1594913935397;
 Thu, 16 Jul 2020 08:38:55 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:38:44 +0200
Message-ID: <CAMuHMdWH2y6p3J4S3qeZNFN6v=_Rnz_zg0etG7DzcQ+NhS9RHA@mail.gmail.com>
Subject: Re: [PATCH 01/20] arm64: dts: renesas: r8a774e1: Add operating points
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

Hi Prabhakar,

On Wed, Jul 15, 2020 at 1:09 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> The RZ/G2H (r8a774e1) comes with two clusters of processors, similarly to
> the r8a774a1. The first cluster is made of A57s, the second cluster is made
> of A53s.
>
> The operating points for the cluster with the A57s are:
>
> Frequency | Voltage
> ----------|---------
> 500 MHz   | 0.82V
> 1.0 GHz   | 0.82V
> 1.5 GHz   | 0.82V
>
> The operating points for the cluster with the A53s are:
>
> Frequency | Voltage
> ----------|---------
> 800 MHz   | 0.82V
> 1.0 GHz   | 0.82V
> 1.2 GHz   | 0.82V

I trust you on the actual values...

>
> This patch adds the definitions for the operating points to the SoC
> specific DT.
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
