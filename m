Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4B0222755
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgGPPjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:39:17 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39637 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgGPPjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:14 -0400
Received: by mail-ot1-f65.google.com with SMTP id 18so4534548otv.6;
        Thu, 16 Jul 2020 08:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QUEyDKlDZNvRoiU1fFM07SvFHaZIbC8OgvI/9CGbWN4=;
        b=OgKBM4FLsld0wj/83VYVcyHx1Xna13S3NY76Jg7gTq+OthhJWGcdQjnxyIKZOJDMFO
         0i16PFFVN7pQpR4SC51djDOEpK3LRk90Hylwtxhmms/G6YdeNfbUFEFuhFoZQ1z3OxT9
         WX7FUh54jJkBoDMQrteiQDuWAqtU1uOI+ew34TA9OZSZPYmJaNQYhJFnygHdjiBOX4zw
         oExa/LjCpZ6CeQQ4C6vk9IEqQP/2qoyO/KcVRnkDybsAvfJBZQQPtqPkDixgqErJCXbt
         YS1z+LaF2dv0Wv6ArCYCMbJBISXo6xfN2SqtHDNVoz5utuUspa8NAbXBqt0ww3Gz4CK8
         A8TQ==
X-Gm-Message-State: AOAM531uzML0+SIVbGb8ekjOKds5oHOIToZ8tClZCxOLCeVyLuAbmjRy
        f4Mdg6N7gJ9nQbtdrHgEErZO7XiO/tha1YuCJms=
X-Google-Smtp-Source: ABdhPJxO13GvpQ5DwTMOvoE8Qpm+751RgACNt3acgLGDelMbxf0nO5oqfl8C3y4iF9T2pIScvbkcfebiQYM3NK52iIw=
X-Received: by 2002:a9d:1b0d:: with SMTP id l13mr4903038otl.145.1594913952905;
 Thu, 16 Jul 2020 08:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-11-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-11-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:39:01 +0200
Message-ID: <CAMuHMdVcraSYGg29XkEPM52UuKq5be34CsKyFzSLQfCAYQOaKg@mail.gmail.com>
Subject: Re: [PATCH 10/20] arm64: dts: renesas: r8a774e1: Add SDHI nodes
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
> Add SDHI[0-2] device nodes to R8A774E1 SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.9.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
