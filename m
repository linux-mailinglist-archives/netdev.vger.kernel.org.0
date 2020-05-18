Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13C7C1D7684
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgERLPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:15:43 -0400
Received: from mail-oo1-f68.google.com ([209.85.161.68]:42624 "EHLO
        mail-oo1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgERLPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:15:42 -0400
Received: by mail-oo1-f68.google.com with SMTP id a83so1942721oob.9;
        Mon, 18 May 2020 04:15:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2knah10lYJPRFPQUQWZ2BsD37uk3fKBevsfxNnl6fDY=;
        b=FY56BNXXqEg85TH+Bcmw+ccPmBQtAI2pGGVB2mTK+R4hsMcpNsfwRahDYc9873WO8h
         KBVmIa7+OQuoUhzUHMG2Ejge3FoQc4IQLyPuck3w5855L1jEkDrq6EOo0qgfBLSSJr28
         HUrKUP/Ig9diQOGcy+NT53NlFhGPbhKqwZe/sRuySEwaIirCgMDyqhuRng5PplW/eAMY
         Jax9QdnYlBtP0fYyioRmvSto9YKH3WFAf1dxEEA+wLRrOLCX072YS9qhWZ6UPiFT3eEa
         kXoyR2dYOle04I392jLVUEQX0EoA3fGXBuVEK7/nMjJHBbslKYxxh+JVGis/KlyWe/+y
         QsFw==
X-Gm-Message-State: AOAM530csjlRE0h5jjlsYrY3ikbWdSf8KCKDsgXSsx6358UkSgbwewpb
        OewSJ8uj/0+R0Ot+JdiecoXa2KKVRtr+T2GaMtg=
X-Google-Smtp-Source: ABdhPJxiykjLGbyCdTUmaaWGqaDi8Kkzqq0ytAjLi4UAlN3VnuLtu6yd4zpQUCHKMzaG9VRjKLwUZ65RnGtwkNZfbbs=
X-Received: by 2002:a4a:e0d1:: with SMTP id e17mr12409403oot.1.1589800541367;
 Mon, 18 May 2020 04:15:41 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:15:29 +0200
Message-ID: <CAMuHMdW+Wi7atvwanekJp0mno4F9sbhC0+hM8B80mhxXdbVFNA@mail.gmail.com>
Subject: Re: [PATCH 11/17] dt-bindings: net: renesas,ether: Document R8A7742 SoC
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
> Document RZ/G1H (R8A7742) SoC bindings.
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
