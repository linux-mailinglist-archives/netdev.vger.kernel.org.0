Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F31D77CD
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgERLvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:51:50 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42741 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgERLvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:51:49 -0400
Received: by mail-oi1-f196.google.com with SMTP id l6so2819201oic.9;
        Mon, 18 May 2020 04:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wY/drxDltfg0qmuAfUHX6Sgk6MzClUGXI5sT1yEj9jk=;
        b=ZHBw0RjL+R7lXVW7Y6F6Bu35gVW2PKwO2mhtRUjRQr//Q8RmasrerPnUgGw3KcsH0W
         mXgDS9LIZG9J9Y99cSbv/dNzzFcALgAPZ4rhJWCH0J8FeigeQy18/ncLe0BUc70NZdRm
         Hn0yq7Ca1iJRKb8reapEZLHR1WD413XNSSBOljt5jdLcarG7bZeMLwmJcwzk+LUeEYxG
         jDrVIkl2kF31I+wE41cCBUIDgfgME0t0BuPIGdPgC7gNSH+nmBI612wcJ1Z9fI/hS/fK
         NIT6NMPz6FNSMZLFhQeaJ056K+LEKg0PTSxgyKmFlgnHrnW63C55KxTl6gtrM3MAMZH2
         /esA==
X-Gm-Message-State: AOAM533zLGrJLZA4neUZsLK5xYJwPdCXoQIKCVle8fBRfInAeQandiOT
        qKXzaRBNFzGXY5LxrAwldF5Btry3YHYL9no4x+Q=
X-Google-Smtp-Source: ABdhPJyKfkl0BYyXn4kFtQpjLO3inMmyFkCAoPtuUDMN20SMjegRhY8TN78g4kafTLxOUT994Q+yRWULPw9El6LNYus=
X-Received: by 2002:aca:895:: with SMTP id 143mr10154801oii.153.1589802708356;
 Mon, 18 May 2020 04:51:48 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:51:36 +0200
Message-ID: <CAMuHMdWA_x1Sb2PitvLoX=b1+_tFEtPnAPNQdb50GUdBwme+Cw@mail.gmail.com>
Subject: Re: [PATCH 06/17] ARM: dts: r8a7742: Add SDHI nodes
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

On Fri, May 15, 2020 at 5:09 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add the SDHI devices nodes to the R8A7742 device tree.
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
