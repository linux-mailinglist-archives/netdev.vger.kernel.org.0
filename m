Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9669F222599
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbgGPObH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:31:07 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38773 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgGPObG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:31:06 -0400
Received: by mail-oi1-f195.google.com with SMTP id r8so5232172oij.5;
        Thu, 16 Jul 2020 07:31:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WqlrFbvqA9D4cngrjrCPvsg/0myDvo5cshnJ/d0TFXI=;
        b=N/9cddSZbnceQfrngHWhiUQlCApV8XCmMZ8USLE7o7mCIHijhBXTVwq6xQtQ8rGUDB
         +jNjeRmweOC0Sn1+swo1xK5GLGhDckJj25r7ll4R7LL70ofguzjXJ6lTgj2imPJRUCmC
         mKFCJwu3otrF79rIqKPynFw/4L9oiS2vrKeCkJz04Q4gvalldDUyTmCVdYLMb3qPqyT4
         b2ZRIKiFkDHyVd5A5+aQQ3LY3kFFkbIxFLOZdfheqoVI0tpdMWYP/RPjbPqNs6ToT9SH
         GAC2StOIiDSBa3UjBTGTsxFqEXbC+7frtiwDS83+g6h/8L5RTgDNNP1aa3wh3ayei1fB
         3jGA==
X-Gm-Message-State: AOAM533z3wAh0d3Bih9JqpqgZrVm566mFIA3jUmv+OP8dRT0bvDdVPoW
        7LzMwzJH4Dul43igV4n4UP3C4X4Qzp9pwxbHLDI=
X-Google-Smtp-Source: ABdhPJzDN7cqk3Qhxsw+uqLdV1Ci8OAOQAFFwq8FXnP/ri1XttXWiaSPIkPG+85MGZsFvOFdldBbU8wmQ942oYe18UY=
X-Received: by 2002:aca:5c41:: with SMTP id q62mr3892778oib.148.1594909865066;
 Thu, 16 Jul 2020 07:31:05 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:30:53 +0200
Message-ID: <CAMuHMdUj=VSZ1n6pbiizdm1cnsDk+c=4LbAvPXg259OAtFz0qw@mail.gmail.com>
Subject: Re: [PATCH 16/20] dt-bindings: watchdog: renesas,wdt: Document
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

On Wed, Jul 15, 2020 at 1:10 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> RZ/G2H (a.k.a. R8A774E1) watchdog implementation is compatible
> with R-Car Gen3, therefore add the relevant documentation.
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
