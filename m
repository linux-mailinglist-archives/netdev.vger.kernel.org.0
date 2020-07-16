Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645A222258F
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 16:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgGPOaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 10:30:13 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36575 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgGPOaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 10:30:12 -0400
Received: by mail-ot1-f65.google.com with SMTP id 72so4350314otc.3;
        Thu, 16 Jul 2020 07:30:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=115VeKAeRymHtgOQWn1MnLlYGAIf+NEanOtmy9E1NN8=;
        b=nYuz5J1Kfo368fK+VhW9JrZmzZK5Jekhob4cCdtfd0MBi9hXcTbRNx1hsKhLuBDPTr
         OMD8RfG3thdBWOUUJqTuMerOgVGke0LrtlZYwWr4aNH0ZIgtJeEdLFChXJDkBRig+RDX
         PGOesR1HmMpsgz37srN5WhwnVE845ys9EmvsaT4LtipZL+IavQUNqRhRw6c3oLKp8Ye4
         R8gPZJt3oRSKxz0O9U2nwvcx/Kq3Eo3qedeSNlIXVDVmMyGRQttu3BdJ+XW+aDi9AAcM
         k8BwSvYyPjTTeW/VXUlbhD3BPZnmW/Ilo6CiwOqT3i0U1ps3Wksu5lljf9BqqR7swRnS
         VZQQ==
X-Gm-Message-State: AOAM532AXXOuO8EvjVKbnbTBuYIpdny/ArT+r+AwExvbdh85DoxFEoTA
        6CjK6KBcmjK7D0/rkiRZYX+MHEsFO1wIKgI74e0=
X-Google-Smtp-Source: ABdhPJxK8dOUoCV8I3G+DI8G7gXsWY2eAVqdrfu3jQheAGdSQy7ope5CwfXoQmCSabfMV6DABVOZpG+50JDpVWtvhRI=
X-Received: by 2002:a05:6830:1451:: with SMTP id w17mr4722284otp.250.1594909810889;
 Thu, 16 Jul 2020 07:30:10 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-15-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-15-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 16:29:59 +0200
Message-ID: <CAMuHMdW-uX6cSjhy159-EG3N+GD6MZABJbuSXgbvzDPybwNNfw@mail.gmail.com>
Subject: Re: [PATCH 14/20] dt-bindings: spi: renesas,sh-msiof: Add r8a774e1 support
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
> Document RZ/G2H (R8A774E1) SoC bindings.
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
