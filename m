Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47431D77F7
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgERLxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:53:43 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46306 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgERLxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:53:42 -0400
Received: by mail-ot1-f67.google.com with SMTP id g25so2027413otp.13;
        Mon, 18 May 2020 04:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gLeuUEV87rLj5u4SmWtflP3ainpFoOPWlk4LXLyZJY0=;
        b=nu7bFe/1bGAq5QRQwLPZXJ7glu7LWMz2S/Nm2R3c9xLb6mmpZWiULxMuJDUxsKZhoZ
         dsSON4pSEOHN/hezBuYGjzqWufCbn7hkFqIE5KQrVr3z6nXA+jACIcJNLN2Lsg6BIlv0
         SuxeMgXElbK0cPWrjWNwIin/HYnzYh1Z+hCWCNMOGiN8kN4BFxhm9Tsj6/wIPD3sNJZr
         8jsnHny+yGKq1XZ1bH8WRXEgM0YOsQT/rcNyosnYm0+g5/T6M0u/aOZOP9/SLaOKFNby
         YLzQKaQiirTmJr0h8maxVHoSoyz+C2cMC+ApkTB5h/K2kygBOEu2CtTKLX9//Ti8N5i+
         G/1A==
X-Gm-Message-State: AOAM533UfAJofK4i1y3wuQzT+JovC5Vj+4QF7KSWQbG32WzztpF12Bpe
        UfuWTlqg4k/oGxe/qZaWR3EvJwaW4pQaMpOmWa4=
X-Google-Smtp-Source: ABdhPJy2SY7W6jVbtUNnzZ1VzMYJ0FdYvJiXsIT0cAmbcLSkFh2gCqjZ0r6X8r4D785kvRbXEN2EAeyemHuzGc01nfo=
X-Received: by 2002:a9d:564:: with SMTP id 91mr12000493otw.250.1589802821424;
 Mon, 18 May 2020 04:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-14-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-14-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:53:30 +0200
Message-ID: <CAMuHMdW-Z20Ve2zkBBXBpMn-VF5TmXv7H6PMv2vbJf8havanwg@mail.gmail.com>
Subject: Re: [PATCH 13/17] ARM: dts: r8a7742: Add Ether support
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 5:10 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Define the generic R8A7742 part of the Ether device node.
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
