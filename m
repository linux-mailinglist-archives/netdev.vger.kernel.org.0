Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295701D7676
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgERLOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:14:37 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:44064 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726895AbgERLOe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:14:34 -0400
Received: by mail-oi1-f195.google.com with SMTP id y85so3827343oie.11;
        Mon, 18 May 2020 04:14:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2knah10lYJPRFPQUQWZ2BsD37uk3fKBevsfxNnl6fDY=;
        b=piK8VM8t8dw4XW3AMpzVu0auvO/zE8l5DySfPisZX2/nvLcVHk29PBDY1ifJza7ziX
         LDZjH6jIrfL4IxiaX0Abyh5ELVp+E91gZ9LoXUtDW5NQZ1i2n3g/7ATaiBaAZIkegt2Q
         9pOQmmZcDf41P1aI+M1argEfhJO8prrBgd1rkn5PO4ueGPeCWBGeGPcskAaw5snF2el9
         Ljb2HpiHrD/hD2VbqEv63BnOSBGYgji2b9iRh/Z9OkALIJ/Tf2GUddRoB6HdvaOot0G4
         LFF7kjSyVUh2Nc2C8zy12v/PXue+4rEf7C++SepLF9Z+dr6+PC3d19DfddQtONkZe2QX
         8Hxg==
X-Gm-Message-State: AOAM532qi/ViJojGF6siTpmgQ0S1UXPgDtiOGGta3NphYLds0nJKYNlc
        fvRyJm1FaEW1w70OU7BJ9ZjkfwEagzXMHuAYNtclA7tx
X-Google-Smtp-Source: ABdhPJxTl7wxYO87S/H74nH9O3VknwoXw0cOySOVUtaGVLXJssZ+fXYYTP2kPG/6e1LdI00CWSd71Y9hbdw1kZ2v1ig=
X-Received: by 2002:aca:cd93:: with SMTP id d141mr10013869oig.148.1589800473025;
 Mon, 18 May 2020 04:14:33 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-11-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-11-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:14:21 +0200
Message-ID: <CAMuHMdWdrnHYCooKeU_NpM-+R6=ZKawaqMoTnQ0zxLw+xbKFxQ@mail.gmail.com>
Subject: Re: [PATCH 10/17] dt-bindings: net: renesas,ravb: Add support for
 r8a7742 SoC
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
