Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8397122278B
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729547AbgGPPkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:40:15 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46425 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbgGPPjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:10 -0400
Received: by mail-ot1-f68.google.com with SMTP id n24so4515631otr.13;
        Thu, 16 Jul 2020 08:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4gq7GSJniVhk8mm4mZz3V7JCAZZ3pZpPkZrxw8za4mc=;
        b=NZzBcnUC2a7Qq6ZQDGTOGbXD95yf/rvUCYCqqo6EvZa53Xrh27YM91SCTkgxfjZpOX
         V9oO6AXIvUEuY82q/AcGDRKcG7GVqJLO/Y5Bjp6JlmK1eSwP15wQDVvwtyn6uaHWZOLN
         rdElXeD7rh8DFDMuDf3yhIpCKZPgBRn5gjS/z90URHfyQm4YrYVS+0wlA/XsrbTlGVes
         kSJsdtPEMX0qubNpfUcS1JE0d86EpeyOFo1bBKveQpKvSRVoQrii6p43PRsFBtVWfuyA
         kc2Nq+s7H2bpDDIR7APWXnXzEh9DbZE34rzikiOwdZiLYyhGl0I4g31vhjUmyhYaVSnH
         S2vQ==
X-Gm-Message-State: AOAM530X3j5rABiZGBQqS+ek0M7ZJg9zaH4Dd7VGlv+UVKljUvKGJwFQ
        9Rpl1jeBfN8zICGWA3EFKXEbeeHrvZoFEhrP/xI=
X-Google-Smtp-Source: ABdhPJzjcaNBJZkFuzlxl1kgGoNgVPmT0sGhCGl7NN8SpKXFUUYP81EmP822HK0iYVLU0ZlFzTKnLFvhsjQGBidhSag=
X-Received: by 2002:a9d:2646:: with SMTP id a64mr4730882otb.107.1594913949510;
 Thu, 16 Jul 2020 08:39:09 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-10-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-10-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:38:58 +0200
Message-ID: <CAMuHMdXuo_yjb+SsvLYQHKVkHcPPVmu+3Whtj0XNiWaLZ+QMng@mail.gmail.com>
Subject: Re: [PATCH 09/20] arm64: dts: renesas: r8a774e1: Add SCIF and HSCIF nodes
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
> Add the device nodes for RZ/G2H SCIF and HSCIF serial ports,
> including clocks, power domains and DMAs.
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
