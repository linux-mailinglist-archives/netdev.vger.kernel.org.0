Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2999922275E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbgGPPjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 11:39:31 -0400
Received: from mail-oo1-f65.google.com ([209.85.161.65]:40216 "EHLO
        mail-oo1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbgGPPj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:39:27 -0400
Received: by mail-oo1-f65.google.com with SMTP id p26so1262339oos.7;
        Thu, 16 Jul 2020 08:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4pjrfx9t/+IYZDQ9pVA0sHuiwjeFmOxDZhyCh8pthXQ=;
        b=OX5OJTSSVe0LHfJcauygy7wC1E2VDUwrbtN1lR+SMQf8SP/UKikv57m8tG/WpIdblK
         HOxoZWkNnGCJAzIRzrtw7yWnVQISDfd2mCdqiQwHP/U7xxnZ0OLNaAG3SvAbTv6gj47x
         j6s4kaABTGrZ6vu9ZJZ8wHTDJHp7LMLn9ANmma054RyJZE0ayDzhiXNKIcjeGW/8UoWd
         n2iP2MfWdHjqLuEZ+tIKOru0JXzJ2hPX6Br4m6X10J794NT3vCwB54wK6cri2xy3NGuY
         MvfrrSUbn9F6Pnw7VnHTALzNYHOqttdb3Ru8RquSKNZb4AJk27+MQeOdSkVwhMQOPe5m
         aX3g==
X-Gm-Message-State: AOAM532XNNLAlpza/L9aIi6ZRrIqdIv03U++rivc8uc+Iel8bPI+Jboh
        RJGcD7NlCBuUVOlV/SRJtGPEp2a/pZccRgvkdgM=
X-Google-Smtp-Source: ABdhPJz9yIUHOi4Yj7uBIPuCgrIAlPuTnlxz7ythXKj6Ll90hmgrOzNi3DtW8p8hP8QDMl+aj8TmNfiN/dhuCtEUb2g=
X-Received: by 2002:a4a:8381:: with SMTP id h1mr4809506oog.11.1594913966555;
 Thu, 16 Jul 2020 08:39:26 -0700 (PDT)
MIME-Version: 1.0
References: <1594811350-14066-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594811350-14066-21-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594811350-14066-21-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 16 Jul 2020 17:39:15 +0200
Message-ID: <CAMuHMdUCyARFwhEkEhyepoe_r7uk_nVpyshkXR=U4XD8_gMJww@mail.gmail.com>
Subject: Re: [PATCH 20/20] arm64: dts: renesas: r8a774e1: Add CAN[FD] support
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

On Wed, Jul 15, 2020 at 1:11 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add CAN[01] and CANFD support to RZ/G2H (R8A774E1) SoC specific dtsi.
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
