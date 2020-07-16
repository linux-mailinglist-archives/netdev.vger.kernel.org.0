Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6376A222512
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgGPORa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:17:30 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36367 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgGPOR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:17:28 -0400
Received: by mail-ot1-f65.google.com with SMTP id 72so4316466otc.3;
        Thu, 16 Jul 2020 07:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DrqiNMBsGi/HNN30jDiwSUWwg4kVmwk2J9s//T7Tkvc=;
        b=o0ZmdxGftDltEpTsSh4Iw525OSEItnyKIMx+JPw0wH4MaQ3KXvgP3WyzsSvkul31xu
         KIYgJ8Fz9gLDHn/pjWLgl9t2vA8JV4ArjFZKy6MzLzPyelzFVPxqK0D43xPXWMTtG8pX
         yXQLUaV1H29wL7tBdJJaHavS7mSCBRbvm+cLxdPQwv6ePQB7OFkNd8H+493N9tZOM6iW
         FOaj1cKRqpiSv/rExBHEeFZ1HkpcRSG8dw85Sg59PUPvLOzVGwN6ZivsojTVYItBSY6p
         04YHyzgh+qzNiLRl/W5mByUGUxNjAxV25dyrG/Vr9Pyr4ZWxbC84JYQMMRXL92v1V2d0
         pyBA==
X-Gm-Message-State: AOAM531gWj5C1OZTRDsypkR1QtWHpabeB5G6NB6O3JLYVygxXas0bs4u
        5ngHC+IL6TrV3doR5nVtaqi4CTWKW3xoEXd3WI6BgtMDhYU=
X-Google-Smtp-Source: ABdhPJy2q/OwGoev25fZLTs7zrm9JHf5kK23kuRHKHfyjw1GYLKUOQGfPvXJjeNkx35UdWecOAFaFYoc2Wk4VzMvvtA=
X-Received: by 2002:a9d:1b0d:: with SMTP id l13mr4539438otl.145.1594909047078;
 Thu, 16 Jul 2020 07:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:17:16 +0200
Message-ID: <CAMuHMdVs0AjatSHVuz8E1TeAFG5eu9jrjOKyKjHjY79K_OrviQ@mail.gmail.com>
Subject: Re: [PATCH 05/20] dt-bindings: timer: renesas,cmt: Document r8a774e1
 CMT support
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
> Document SoC specific bindings for RZ/G2H (r8a774e1) SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
