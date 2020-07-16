Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD8522276C
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgGPPjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:39:49 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45808 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729405AbgGPPjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:23 -0400
Received: by mail-ot1-f68.google.com with SMTP id h1so4525494otq.12;
        Thu, 16 Jul 2020 08:39:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GVpF1JP7hmfmz8dV9xIo0IRiEFUiASMPHRs8ERMCI/0=;
        b=jEfQZ/A1ENoCdtdmpDIJV24oe3OmnZ2A77vUGNS0RR/lFrIoaBxkEZuKJEPaDcugdF
         R25j4dPwli9+VMGm6rZi9srKY05czjsLEzfJe4xV1IY05f628IDGinkG+M1Im84agvcs
         TxTmy7swx57GWGDMzoLP4PGT2leQpYelTUMU2g+HNBvYIItNrZSUuUVvxn4xyuEXeQL9
         hvEQ8pkNyrNqRzkPJtgxquVCO5pez9M2HSQzo/AJvsbu3vfs6VlnFX+k8L0ev/mZ28HC
         354OTSrn7G3Ceetf5xgG1fHJ7RXmdku/qgGjtaQCxEiwdI4T5t+7fQ2Q8aTcsdQsfX23
         XiIw==
X-Gm-Message-State: AOAM531oA7OuuPuuvSWrzw/STLM0FloiMXf0D0T98VTx/cMN8DuD+wPj
        ceU3E0IZfVNlkldUK++QLL2NgA/5Q8fKbgu7zck=
X-Google-Smtp-Source: ABdhPJyYR9Hs8SoWN/IY/0wckPT+vzl0qEobKceTMx04PH/pxyrMFIwTwh4FW2EGxXgrpDS62tEG0eweHhoR/N7SO9U=
X-Received: by 2002:a05:6830:1451:: with SMTP id w17mr5040038otp.250.1594913961982;
 Thu, 16 Jul 2020 08:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:39:10 +0200
Message-ID: <CAMuHMdXgU3qCjsXWqiNM=OGrG6jMytZxij7SkesDo+2u==J7GQ@mail.gmail.com>
Subject: Re: [PATCH 17/20] arm64: dts: renesas: r8a774e1: Add RWDT node
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
> Add a device node for the Watchdog Timer (RWDT) controller on the Renesas
> RZ/G2H (r8a774e1) SoC.
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
