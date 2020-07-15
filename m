Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD742209D1
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbgGOKU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:20:57 -0400
Received: from mail-oo1-f65.google.com ([209.85.161.65]:42828 "EHLO
        mail-oo1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbgGOKU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:20:56 -0400
Received: by mail-oo1-f65.google.com with SMTP id y9so353203oot.9;
        Wed, 15 Jul 2020 03:20:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bQ8og4Y29TXoYrT84mpNUb21SIh4pzwr3Vk3bzaUpgw=;
        b=EDrtqKLUHVML1sA6LFFP5MJ8mIoChGo5GFPqc8ZOaS0WdBMHKDrR85YW7RWoAExsRC
         QXl00GBCrlXL5UZqSlnx252iAC5fSCmvudbJaIilcbmx2sqhyd0ONPCLWE+qplzJoZ/T
         yaFToaViut6ifyrZuPCiVIrtBpcEbApmNE2VXHtwguw0gmEnAFitWke3XotOM3iDi+BG
         vMUomMYhrUCCnzoiV5D8rdNdvt4CNTkiHCmlNBguKmwcL68v+uifgTSk9Tq8h6155wLU
         BFXf3P9ocqKk0AFFf36tRJEenL7IwMqSHdphYcbVBUc3Qh7mHDc9y8iGFmAp6CdPbjD2
         Y7CA==
X-Gm-Message-State: AOAM533cSn8OY79gR2dQuwr31WZqGTb308oKZGtkQz8YEl5DU2cKhtTJ
        FrY5+9+qkTVbdobn0kGw/xzbwFwSpVyW3UAIXRg=
X-Google-Smtp-Source: ABdhPJyb4SMwBgCFiNmagYeq0Muv3wO8z33UP0pKZzErUJ07FKnvbqzYlypWRcKQX2l2bgobbQLJvYCZywzLmfV6Mbk=
X-Received: by 2002:a4a:5209:: with SMTP id d9mr8763133oob.40.1594808455307;
 Wed, 15 Jul 2020 03:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Jul 2020 12:20:44 +0200
Message-ID: <CAMuHMdVsYmi1ixBrk=gfgnsfC=MHDagXJKUTyGr14xxhHh-Jkg@mail.gmail.com>
Subject: Re: [PATCH 5/9] arm64: dts: renesas: r8a774e1: Add SYS-DMAC device nodes
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
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> Add sys-dmac[0-2] device nodes for RZ/G2H (R8A774E1) SoC.
>
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.9.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
