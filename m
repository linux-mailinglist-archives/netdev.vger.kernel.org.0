Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78600222560
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbgGPOYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:24:47 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46266 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgGPOYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:24:43 -0400
Received: by mail-oi1-f194.google.com with SMTP id l63so5186168oih.13;
        Thu, 16 Jul 2020 07:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nnjKMypguJ4/5J3zi+nKWFTG5kpjunUyDYMlZ/jwgmI=;
        b=fljkMAfPrYpQHm6VSG9c4mw47QxwvwLX2xcyThbqNeOX0Ub890r4mKq2raSy+Kjumi
         e0Po3Gz2uX5SmyqxQW/kbWsJe0LqKwty9vaTTM11BcgfEuRbPa0zrrJQajz2bOx8DJYE
         sk4ZkXDuySgxHZ+4Epfturpaq0V4TDSr0RwKEgJc1hIY6kkgADcUl2Ve62C2XnZwPI6l
         zx3hgZ1W4qPut0+6muJG3AfHCzujDD4T645a3zmslqib4BQ+y5qFrOyZ31IppDOzloGa
         i7d3y4W/PK+KgRNhYbo9X/AMK52ztH2DArl0MCYzIL3AiIIxeCF7+p5aiLF1NPXx4E0k
         8dXQ==
X-Gm-Message-State: AOAM531CnzAXl+i/5IvbH6pGr5FJz0BHKzCVGeSI9CLIuAZ1JWn2aec6
        5IWqNAGLiYIe2an6uI+ysih/OhzilYaBUW3c9oc=
X-Google-Smtp-Source: ABdhPJyuNSqQvBAEiTGasOgiHD3JNckbgGTJFnCjccv3IdfLUIQhxKYJFQ1pLgsPHo273k3ak0/gYQzGEMNEPFjDFtA=
X-Received: by 2002:aca:5c41:: with SMTP id q62mr3871180oib.148.1594909482264;
 Thu, 16 Jul 2020 07:24:42 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-8-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-8-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:24:27 +0200
Message-ID: <CAMuHMdXJFkWn--wvuxG_o4THHiq5jtnLjNc_4LUWUSMF2mSdEQ@mail.gmail.com>
Subject: Re: [PATCH 07/20] dt-bindings: timer: renesas,tmu: Document r8a774e1 bindings
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
> Document RZ/G2H (R8A774E1) SoC in the Renesas TMU bindings.
>
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> ---
>  Documentation/devicetree/bindings/timer/renesas,tmu.txt | 1 +

Daniel: looks like "[PATCH v3] dt-bindings: timer: renesas: tmu: Convert
to json-schema"[1] hasn't made it into linux-next yet?

[1] https://lore.kernel.org/r/20200518081506.23423-1-geert+renesas@glider.be

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
