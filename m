Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CDF3222745
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgGPPjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:39:03 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46969 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbgGPPjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:00 -0400
Received: by mail-oi1-f195.google.com with SMTP id l63so5391650oih.13;
        Thu, 16 Jul 2020 08:38:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=55jfOQrsK0L1I5YXuMIdr4caeEX2QkxMqO7QLDfDfTE=;
        b=OJNb/3CZdDYdzXBR/FZKOEH1E8x79ukV4KlNK0I9Zvjqcqi8GBZ5P5/mE/v+JZd5y8
         7YGhcalW3migO5YLoZaShePGFX5HXO70CZx1ETbjY6bnN9Dw/rQNXrN1KstprIMB816z
         MeTHoQtCjomtjtYza/aPBsYwUu1v81D44wHqHG0PNxCEAbsrbsm2XKr0l2QwSky7O/UZ
         6YWEu5ock0X31HkwIPBNx0PaLsDo1QwBDokzZjptSOVvocCyOqcC97Wu1IhzAgoZwhl9
         eb+j4W9YRxSfPzF4kRmC5N5VnOC4E0TiAadRJnxcT5RAZQGVXoNNuFtQXbYXHFlWzGuY
         BgHQ==
X-Gm-Message-State: AOAM530c0ORPjHgy3yWtYRoUSRQGvXpJ99Z/Ct60n0oosGCuQgtDXAfO
        Q1OCL7fVxXxbxlawi9KKm5eGOYkZpkrGmyjsISk=
X-Google-Smtp-Source: ABdhPJxlQJRAKwt8VHHL6j/C+ElgfmWMk9g6riN/0HgdloQA+L26Uh68R5kB11G1HZGjTIU8odcycK0XWy9zO26BCZA=
X-Received: by 2002:aca:5c41:: with SMTP id q62mr4141682oib.148.1594913939213;
 Thu, 16 Jul 2020 08:38:59 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-5-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-5-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:38:48 +0200
Message-ID: <CAMuHMdXRHOqtFWgExiksemXXQzxbokbT_nZDp4o4UzOD_gB5yQ@mail.gmail.com>
Subject: Re: [PATCH 04/20] arm64: dts: renesas: r8a774e1: Add RZ/G2H thermal support
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
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> Add thermal support for R8A774E1 (RZ/G2H) SoC.
>
> Based on the work done for r8a774a1 SoC.
>
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.9.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
