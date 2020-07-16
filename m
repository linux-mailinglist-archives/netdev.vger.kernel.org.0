Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2211A222581
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgGPO3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:29:12 -0400
Received: from mail-oo1-f68.google.com ([209.85.161.68]:45704 "EHLO
        mail-oo1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgGPO3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:29:11 -0400
Received: by mail-oo1-f68.google.com with SMTP id a9so1202769oof.12;
        Thu, 16 Jul 2020 07:29:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wbLycxU+N0h95t3MHG+c9KvWEt/sZuHeu2nuR80b1nw=;
        b=oZMPHTGFougK3XHEVEJsQOPHwbzAVzBWgBgrTp4zBnNtvFdsay3DqSKBul2w+0OG+8
         d0VxTy17fqju2Pp2W4zKOWw4pliJyfVPNu8QjJnYdWgrU+1CVhSfERYyZPVLMO7NmCa3
         SfMdkgWicxijikkANBhBq6XQq1YundO38mv86zwTCcSdayzjfPoBQvdgFllc1HKYyAVX
         fqfsritQivsJWCVs0xnr8hl7GMU1zVrEMZq+mJRAtl6qcWX3epcOMAe81kawYf/GkeaJ
         6rEZoniARpMXV/x8lAmpFsbTK6xKaY87tt5Yz8dZHCnBRoc2R2tDA8xCf3HF+XrPaWIT
         moEA==
X-Gm-Message-State: AOAM530zmC6Gow7Bxi83DikDdF0iGR0mr3QR+ob+SAC+W1PwI8DdeMCw
        95GSvuA7RZnzCln84ICwDkDQPsE7Dm6Rmm8o09k=
X-Google-Smtp-Source: ABdhPJxgpqG3VxzPzTYPatOvZfYeSh1wMMWCs1sv4nhFJKhZhzppSv70Xifb8MB7fpIeWUkupymjehrXXlJuOxdCMU0=
X-Received: by 2002:a4a:675a:: with SMTP id j26mr1440477oof.1.1594909750520;
 Thu, 16 Jul 2020 07:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:28:59 +0200
Message-ID: <CAMuHMdUsVKLABUYgG1EBtXHdg-PTuBfntvN8hw_PDLj+ybufmQ@mail.gmail.com>
Subject: Re: [PATCH 12/20] dt-bindings: i2c: renesas,iic: Document r8a774e1 support
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
> Document IIC controller for RZ/G2H (R8A774E1) SoC, which is compatible
> with R-Car Gen3 SoC family.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
