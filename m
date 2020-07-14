Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4A21EA63
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgGNHjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:39:43 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:41212 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgGNHjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:39:40 -0400
Received: by mail-oi1-f193.google.com with SMTP id y22so13188853oie.8;
        Tue, 14 Jul 2020 00:39:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dCYnWiBfrUG0V4QV9bfy3mtM9Gw/6z5cymsRyqfOxPU=;
        b=qH/1FIlN+DJH4FNmhUoS7tmmK6M/URGpHYWNJAy3Mb44wZiS8hmILq834C2QfxiBev
         5wxeR/tplU0cLeQwL7TOwORTx/No9dbYn/O12Ben4/WH6T2x+l7f2jjmmyc7cV+gykT2
         7lGobbFVkO0qGam55RFFxM/fv/oNdLJDtwqYjoI/oEivY9y2xdGNE2KML9la63CrzeQ9
         EbiBQWVhMZSafn2O0Mv6Ub1fZQgMymQ8dmBXLuU9UygADKTYbbz+YzsyeNdDlw1TiCM+
         wfYhL2VoViWMzpQGMCmYq12J3CQILK5yXMWscylb8Te0URo+EaSkWnnc09LMK0nZHfAh
         EIAg==
X-Gm-Message-State: AOAM53284iKjupKdrQ1a0mF9Os3HxzeD1yPYYctW9K9oAaD0F2TfCtv7
        VM0H6Z96FW4XYXy3kqjsG8ftuuzCC9n/hgIgt9A=
X-Google-Smtp-Source: ABdhPJx5dphEyeiFZMm6iXlEYQPyjm7HBBuh4FxBXEBpFTIMln0CZySUEMQ/80bez3KevRXtht7yiFFsC0OTtXhX8oU=
X-Received: by 2002:aca:5c41:: with SMTP id q62mr2546599oib.148.1594712379512;
 Tue, 14 Jul 2020 00:39:39 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-5-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-5-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jul 2020 09:39:28 +0200
Message-ID: <CAMuHMdVyJTZ2-YS-WvjAr0ca_EfNdLk3+PEOSK8L5vShd97VWg@mail.gmail.com>
Subject: Re: [PATCH 4/9] dt-bindings: dma: renesas,rcar-dmac: Document
 R8A774E1 bindings
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Vinod Koul <vkoul@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        dmaengine <dmaengine@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 11:35 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Renesas RZ/G2H (R8A774E1) SoC also has the R-Car gen3 compatible
> DMA controllers, therefore document RZ/G2H specific bindings.
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
