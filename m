Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DF3222569
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729046AbgGPOZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:25:39 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37951 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgGPOZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:25:38 -0400
Received: by mail-oi1-f195.google.com with SMTP id r8so5216728oij.5;
        Thu, 16 Jul 2020 07:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=91Je2qAcGCzgn2zcz7wtNREQl6Cl2nhLo4wLUfE5WtI=;
        b=XtMOE0v7nHTx/6b7/1J2cqW3bb+rQgO8WrZycFFizVY8G0VWj7k6Hk/nX4/vFmTG+e
         d4ad+Z1hNI+lcgFLyZNDbb+Bg38U/k/gTBknid7klI7DBz4zRBsBtY1J0E57KsPan4Vk
         gqOWtWadqrArSikc+d2xJQT6KDDGuGTknIwmGUwOdC3dXtI+oDz2QnAY7eCYsKUsGua9
         tz8vGAlvjagXZDyd9BXzPO0dV8UlKJ7tq9Z7vrPo9m/Hj0xWisr3g/N4ztIKPMKf0FAI
         r0OwhcbdfecTnfIIvII0hjXZp98Vp7Q2SzwnvEvavAYH/RJ4Csi3rytoHdQ/ru5m/kt8
         ic1w==
X-Gm-Message-State: AOAM532DMv9PZHY1VYU2JDTNpz6cRSh/6iochJyLoORTEEvb2cKqWP6M
        bWtpmwRyGGzHBO/S+xjhENl8a7ND7A56ao7nOWI=
X-Google-Smtp-Source: ABdhPJwIAN8f7bRLJuYAyK2do3tAZg+scN8MvNy6h4Jd28iwoL68rvxkRime7NVAhQfqpWkxvClPG0FKsK2Ss5qAiXM=
X-Received: by 2002:a05:6808:64a:: with SMTP id z10mr4044483oih.54.1594909536875;
 Thu, 16 Jul 2020 07:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:25:25 +0200
Message-ID: <CAMuHMdWqmVSgUu6N8vBA8fRwwP0jhFCLBHN+AL4YoHn4yejn3A@mail.gmail.com>
Subject: Re: [PATCH 11/20] dt-bindings: i2c: renesas,i2c: Document r8a774e1 support
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
> Document i2c controller for RZ/G2H (R8A774E1) SoC, which is compatible
> with R-Car Gen3 SoC family.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
