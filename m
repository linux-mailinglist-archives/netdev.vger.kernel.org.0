Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9DE222795
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgGPPjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:39:10 -0400
Received: from mail-oo1-f68.google.com ([209.85.161.68]:37090 "EHLO
        mail-oo1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbgGPPjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:05 -0400
Received: by mail-oo1-f68.google.com with SMTP id t6so1257906ooh.4;
        Thu, 16 Jul 2020 08:39:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4LrRL/OWFuVfhHNu2nauYQQFtFCQrHsVXHq0n4+BNnU=;
        b=eZwKc4f9MixV87et9vjy0pqkJwBVqBoMZvImcDNEeUGBgqxiUUGeE9ASofGM1q9nQi
         hf7JKu4ntw9zfr3/7Zm0BrnfRQomhR2j9F7R7ogsCqvTgPXE6+sp+AnCm/Wk4dd33DYF
         zvfxpNJfBXTJthCtjqdBBRif7nF5aZGaREIlP1TFs1hFp4z/hnznfVt+xxrdzsplG+cz
         BQIs8jV8nKXlyLvnLwnV9c6CZ52DlfIVc6lK4nqtILyt+/RVdy+FWbgujwISFYEwIoEY
         26UH0+91a9bP8YlMi2lMp1hga95vjsp2hNomBIOpqSssrYhcymBSy8UTXxItIAfedUXv
         3Guw==
X-Gm-Message-State: AOAM533ab9mbMJfpimNI5DR+VPlrjmfBhMYGwL/ydLeCeMojNQ7H1zg0
        D/Ck2tcuCpoSHSOaQiRg6vKxSDaG+F+MP3Xgx88=
X-Google-Smtp-Source: ABdhPJwsIQgMnFHyeYC2Mob7tatUJLiAfHETR2cM0YIIHKykVq2LUvqmbenn0R82jwmOiWqzyNsLsGAIu2pEG4GS8hY=
X-Received: by 2002:a4a:5209:: with SMTP id d9mr4775708oob.40.1594913942493;
 Thu, 16 Jul 2020 08:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:38:51 +0200
Message-ID: <CAMuHMdX0iXv5=Po1d2LwJFo7ezOnfYi9vjf=wFe9YFY0xyLCWg@mail.gmail.com>
Subject: Re: [PATCH 06/20] arm64: dts: renesas: r8a774e1: Add CMT device nodes
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

On Wed, Jul 15, 2020 at 1:09 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> This patch adds the CMT[0123] device tree nodes to the
> r8a774e1 SoC specific DT.
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
