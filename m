Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B022225C4
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgGPOgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:36:00 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:36118 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgGPOf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:35:59 -0400
Received: by mail-ot1-f68.google.com with SMTP id 72so4366454otc.3;
        Thu, 16 Jul 2020 07:35:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Om5ovYOp4gfyp5+GPEwFq1WDhAkoasPOOhUu6A2+EGM=;
        b=YGkwf9INfe8LFvaiNYT5SW4/YwcbzsGzj8AuZMXhCPcjP5dP9rpwWKu7HWL2aJMH90
         +jmLGzMsVyo36e4eZcXLacZvj8MmQw8iW2RvMCCpi4x+JXwZbMfdeHW4yOQhIT7FEk3U
         XtHNORbMLKA48Pu9h1qzUABWBR7w+J9x3w7LVDwuZC4NU9zuGGKZrCo5c/457RkUxoOS
         buiTFL3oACpUgCQipsntkXLKo4fSVg4lgV4VUdeANWwDm4pJvaRmeCwT2H3NdFH9eIta
         FBL42azScK+i9YJGG9h+jSb7KLlbOSNhRXz9p/y4EIKqxz3BCIjnw2SaEFXGsXDNtH9g
         sEEA==
X-Gm-Message-State: AOAM531gkwyB2jIZVVgzEmccSrxkI0prj3vpcRtAvZrhg7QBAof/AkMr
        /MwIU04qThNdCmm2tp1IAyQxMfaJdekDzGlpBINC0tBN6WQ=
X-Google-Smtp-Source: ABdhPJxtRx2txfS+cy94gEtgtG6BjqkgmfEqBFVpYhM4W9ZfKCiNCNqGTnSLQFDTleYE74Mj0krYjex9oCEdOIXEDXU=
X-Received: by 2002:a05:6830:1451:: with SMTP id w17mr4750027otp.250.1594910158295;
 Thu, 16 Jul 2020 07:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-20-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-20-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:35:46 +0200
Message-ID: <CAMuHMdXLMwDNp=cAmFbv-+uwKLBL7na5yDdyoePuoGOi8L9yFQ@mail.gmail.com>
Subject: Re: [PATCH 19/20] dt-bindings: can: rcar_canfd: Document r8a774e1 support
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
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

On Wed, Jul 15, 2020 at 1:11 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Document the support for rcar_canfd on R8A774E1 SoC devices.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
> +++ b/Documentation/devicetree/bindings/net/can/rcar_canfd.txt
> @@ -7,6 +7,7 @@ Required properties:
>    - "renesas,r8a774a1-canfd" for R8A774A1 (RZ/G2M) compatible controller.
>    - "renesas,r8a774b1-canfd" for R8A774B1 (RZ/G2N) compatible controller.
>    - "renesas,r8a774c0-canfd" for R8A774C0 (RZ/G2E) compatible controller.
> +  - "renesas,r8a774e1-canfd" for R8A774E1 (RZ/G2H) compatible controller.
>    - "renesas,r8a7795-canfd" for R8A7795 (R-Car H3) compatible controller.
>    - "renesas,r8a7796-canfd" for R8A7796 (R-Car M3-W) compatible controller.
>    - "renesas,r8a77965-canfd" for R8A77965 (R-Car M3-N) compatible controller.

Please also add R8A774E1 to the list of SoCs that can use the CANFD clock.

With that fixed:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
