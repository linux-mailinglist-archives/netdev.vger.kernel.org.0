Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8031222507
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgGPOQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:16:30 -0400
Received: from mail-oo1-f65.google.com ([209.85.161.65]:39040 "EHLO
        mail-oo1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgGPOQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:16:27 -0400
Received: by mail-oo1-f65.google.com with SMTP id c4so1198870oou.6;
        Thu, 16 Jul 2020 07:16:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/6f4fxpuOIqe0S7YL5Sq/N7vzVlD0SvX8qPtZ1clkl4=;
        b=GX2lvrxI8UP2giz3ENZD1Ycq+q7dHEL7RfDLy/4BeXUUIYkw1cwLByeFDuxlT+L4Av
         22AobUni+rxw2aZPYBuHwOXrBz30roHVN/yZddfevKw+gVpczBYVZ7Bk+ROxT4YezlHu
         WKNBdbCVNKi5AWwPDSn2dtPbmSCdHhv/mv6j9WW6E42Qlx+2Ah/jPOZsHXRzgE6WZj4q
         KN3zNpMWLgB7SVgNFyWAp3NkxWfNAkzb3L18XXe2NGLiPKY+j2oGXsu4043hFODfMh3R
         o34zEi5/CLhlfh1V6BiT0L85+IxY8odOaAV2ASXE89KEqsywElaprklTSVt1U7+S+65O
         VJ3g==
X-Gm-Message-State: AOAM531J7g0h1jZKMhUrlc6aESRQtx9hrT8ATpWFYdQgFg42Dwz1QwjN
        n1BUPCw0vPuORc79MXBfNnOy4Gftu3Ik9zNKEBM=
X-Google-Smtp-Source: ABdhPJww6iiMPs3/8D8sNMgStD+EAKQa5bkrFXpoiBZPAp01aqe0/RkREuuAfu6/8uCMzgRki30hNlxVM0TBhplD/QE=
X-Received: by 2002:a4a:675a:: with SMTP id j26mr1387815oof.1.1594908986149;
 Thu, 16 Jul 2020 07:16:26 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:16:11 +0200
Message-ID: <CAMuHMdVj5dyKggB=ADi44q76kiJhdfrfXfGR_GJ2SeniLkn-Tg@mail.gmail.com>
Subject: Re: [PATCH 02/20] dt-bindings: thermal: rcar-gen3-thermal: Add
 r8a774e1 support
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
> Document RZ/G2H (R8A774E1) SoC bindings.
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
