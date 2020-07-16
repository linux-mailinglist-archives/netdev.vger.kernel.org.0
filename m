Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01853222778
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729520AbgGPPkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:40:00 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42150 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729092AbgGPPjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:19 -0400
Received: by mail-oi1-f194.google.com with SMTP id t4so5402620oij.9;
        Thu, 16 Jul 2020 08:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZVj26A778u/qkFwzHHNVLFw5OBJX9iW8thLNG7CeK8M=;
        b=YEaPUOJqazZIklJvpjKAB8p0kk+syFx/25gzwKd7IPQn9/713qqumwYu1FLsBq08BO
         RskCtxSFIOW50fP1gdVps+/4Ao1jgMcGbQRERMaA3YlxZXppCzdgb31zjfj4BNvnpodW
         PnFOuZVlS0CTs25ZeNV9+qOSszDzA6Z3kl+XrNzkGCAEk8too5IvwAfzAeP2WS3hgQHa
         +XOt9BywS2CjzSwCTh0DJYCcGjxZW3FizYwlAHPYdaLbGb3D9P1FRq0QpaGZ97MApsoe
         XkE25X6vm6lOH7M1xz00/7rXtnBnsAmhXZ4xxZ20k4yhS0/bXJZqDc/ctwKKE3D3jKk/
         FBtg==
X-Gm-Message-State: AOAM533cbyGLJRI/TVUPFeKF6Iuuf6Ko7kbuRyxHUSL/OStuHV5xvlsg
        zy5bOzWNVGJNP0QEXSKbwOBVTHjgHz4R52KaMC8=
X-Google-Smtp-Source: ABdhPJy4WUbUbrXDMyLOMudXcFJZ2Xc6Htuh8Qdks0vx0aIZnAn3UtVk52VOzIh1G265cl2z9rT1cE/EmCqOEcmzlzs=
X-Received: by 2002:aca:5c41:: with SMTP id q62mr4142704oib.148.1594913958746;
 Thu, 16 Jul 2020 08:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-16-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-16-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:39:07 +0200
Message-ID: <CAMuHMdUBMTM2VmVb9EbtVP6Qszi-BH71gCqQs3Z6UrbwTmdhdQ@mail.gmail.com>
Subject: Re: [PATCH 15/20] arm64: dts: renesas: r8a774e1: Add MSIOF nodes
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
> Add the DT nodes needed by MSIOF[0123] interfaces to the SoC dtsi.
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
