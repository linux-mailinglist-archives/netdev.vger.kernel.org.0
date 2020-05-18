Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6901D768B
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgERLQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:16:40 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:37297 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgERLQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:16:39 -0400
Received: by mail-oi1-f194.google.com with SMTP id r25so8637651oij.4;
        Mon, 18 May 2020 04:16:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1/HilGgHkl1jCxtedKq/0pptMWLFImSD0AHrita6e6w=;
        b=buTdOg+fjMehxXbBeLdtM8Lt5hJJ7x5ryLaPsITcps2DNxU+717UYUynJphv0qLHyb
         e+lxWk6sA/PeXfLi5kWC6NACH/ivxy2i7CeFvFswuN1T/6lzWVGOo1tJdPpTMashOPdJ
         F7MFyEh/ht25QAa4biG0aOBPBn8ogYcm9srQaOn/HqIebvXsBhJvl8LPstP6irGvtMVp
         pqLopjiJslvzlqWEM1+ccMKwLhrVapmfG+G/U8cIgpV2GfpSRJlHl4Xt7W+H61e81mbw
         +4vIba6vw0itHDzyoHwGKc69EVwxlk7Zfz7gOIWwMYgcqdxAFsRlhsA4L5vYnhoONAou
         1UiQ==
X-Gm-Message-State: AOAM532zL/MpPH5SOJfTdl8iFjQdXP1228ucjol/4Q4snVnG0r+WLoEC
        GF3l3VCsbclmIxeldQgIogvFKIJTntJLVU4Lvz4=
X-Google-Smtp-Source: ABdhPJya5dUMheDePeTXyKkbG5bhj8dhjBibHG2nWzIITvpqaMMt6KKZ2+SxVKpkTvE/76tmn9aQ36g3F6ppRQsAmtM=
X-Received: by 2002:aca:cd93:: with SMTP id d141mr10018491oig.148.1589800597643;
 Mon, 18 May 2020 04:16:37 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-15-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-15-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:16:26 +0200
Message-ID: <CAMuHMdXocwo=0ttfQ1N=nFgdEfZnJGP+Kj8HmL5iaEmecxaFKQ@mail.gmail.com>
Subject: Re: [PATCH 14/17] dt-bindings: power: renesas,apmu: Document r8a7742 support
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
> Document APMU and SMP enable method for RZ/G1H (also known as r8a7742)
> SoC.
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
