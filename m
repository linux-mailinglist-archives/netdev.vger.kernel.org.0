Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485D62225BE
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgGPOeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:34:22 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37240 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgGPOeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:34:20 -0400
Received: by mail-oi1-f194.google.com with SMTP id 12so5248940oir.4;
        Thu, 16 Jul 2020 07:34:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pQBul9LIU8MvE2AF0ZBFrjqE0P+aZuhV6KfYrZ/uskU=;
        b=RKm1nRGB73CviQmXUFNEoE42Aytg4WCDzTxuBBtTvoOuiduFidq/0D/VFEvQmgjXi6
         UXzSAkT5XOjdFmZ96w9A4IMhpxTqtRWi2aft/odZbg3wKAqeKEuabpcaR1hD+FN8xqQ1
         J6UHqHNlG4aMBwiqPqWXXuNDuGUXFLsF9RE97zxcKvyL1Sx85WSLFJKypnBSGG4sE+NL
         bcz99wYl6yR+L6AqomFHbv5pJ+r4W0GWvnkedG3st5CwbPq3JznUrkmgP+jKHrIZWLEz
         tIHW0074KaWvroYBIACySWlHXp36FSI32alkoJxWHlcwFrhGXcgo3aW5BK7o+gRs9FsQ
         JNfg==
X-Gm-Message-State: AOAM531fxpw2Acw5V+0rT8OBbwFTHgev3JWAqLgY0Q/sXtSQnbU9yE7D
        Yx9zkkwBel15J3MNKx18zMXWrbWEn4AVldvIU0g=
X-Google-Smtp-Source: ABdhPJxkmCvMwt3wH5UA1ImcIc1PzKMQfE7n2mGBjb6iqjzqmjPkGLZPwqGo6D/CrQeRwTxtTINrlpBkgd0p2l6Rwug=
X-Received: by 2002:a05:6808:64a:: with SMTP id z10mr4077163oih.54.1594910058311;
 Thu, 16 Jul 2020 07:34:18 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-19-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-19-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:34:06 +0200
Message-ID: <CAMuHMdXN17TsuMEKh=a7vQeCXMJiq0EANOQqQo_Ykn_4r5NaZA@mail.gmail.com>
Subject: Re: [PATCH 18/20] dt-bindings: can: rcar_can: Document r8a774e1 support
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

On Wed, Jul 15, 2020 at 1:11 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Document SoC specific bindings for RZ/G2H (R8A774E1) SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/net/can/rcar_can.txt
> +++ b/Documentation/devicetree/bindings/net/can/rcar_can.txt
> @@ -9,6 +9,7 @@ Required properties:
>               "renesas,can-r8a774a1" if CAN controller is a part of R8A774A1 SoC.
>               "renesas,can-r8a774b1" if CAN controller is a part of R8A774B1 SoC.
>               "renesas,can-r8a774c0" if CAN controller is a part of R8A774C0 SoC.
> +             "renesas,can-r8a774e1" if CAN controller is a part of R8A774E1 SoC.
>               "renesas,can-r8a7778" if CAN controller is a part of R8A7778 SoC.
>               "renesas,can-r8a7779" if CAN controller is a part of R8A7779 SoC.
>               "renesas,can-r8a7790" if CAN controller is a part of R8A7790 SoC.

Please also add R8A774E1 to the list of SoCs that can use CANFD through "clkp2".

With that fixed:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
