Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B903222764
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgGPPjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:39:24 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43672 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbgGPPjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:16 -0400
Received: by mail-oi1-f194.google.com with SMTP id x83so5402233oif.10;
        Thu, 16 Jul 2020 08:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ABlALKobOQOce18O21B/ci3oKkHtUakyJEO3uiaKWF0=;
        b=m0shfbOA/wP7FaAIFeUBUiXc40l1OjklIsxI9L1NFPaLs4k6Dtw1ZWad+52pgOZbBF
         Qb6ctIxwtHb9QqVGT+MjoU8glWqsSlae9eYEyEXWT9tHogPpaGtIRm/shhdf9IJ40jtO
         n5k2Acb37NdWA9iGGYopIU67CXwQphFJHHWnSWYvyc8/Y+t8SD4JYxjl21ZW3SMshom+
         EdjvdFWkN8Z0wiavfpfOdiF6M1i6CDxMKD3gyy7rbf5NC+PAIKad4cn0vTN0aK3+uhJa
         SoTOvQC/un4pLsM+xlsJXlhSlDuvy+bF1RD4TGkDEuq3OyIPsFaPAoLa+Ho+H6MA0e42
         BEZw==
X-Gm-Message-State: AOAM533cqFfR6inpFp1+jNUOqR63RbHfo7qqLdnPZoDqX4qy+TbvB+2u
        knNXJ3ll5eySRGkN4/osyn8sA/uWG1apmRYseGs=
X-Google-Smtp-Source: ABdhPJxxNcLqwe5ufrWrQfAi+rKNQXGnyYM6euVeBGvLki0QvAmsckab6v2wnNPU7hNWmHJbgs4v5qJfwJwZm050ooc=
X-Received: by 2002:aca:ac10:: with SMTP id v16mr4083776oie.153.1594913955522;
 Thu, 16 Jul 2020 08:39:15 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-14-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-14-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:39:04 +0200
Message-ID: <CAMuHMdWBAmCLzfiKzqKzbQ_gi4DpLdMg4JqhxkHCEMbOMg7eUg@mail.gmail.com>
Subject: Re: [PATCH 13/20] arm64: dts: renesas: r8a774e1: Add I2C and IIC-DVFS support
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
> Add the I2C[0-6] and IIC Bus Interface for DVFS (IIC for DVFS)
> devices nodes to the r8a774e1 device tree.
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
