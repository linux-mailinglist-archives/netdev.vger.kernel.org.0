Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1675F2209B6
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbgGOKTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:19:11 -0400
Received: from mail-oo1-f66.google.com ([209.85.161.66]:44296 "EHLO
        mail-oo1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgGOKTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:19:10 -0400
Received: by mail-oo1-f66.google.com with SMTP id o36so350247ooi.11;
        Wed, 15 Jul 2020 03:19:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NAkHhGCBdih32hqt76V0j8Veg+fQ7FChhZOK219jyyg=;
        b=HRl5wwAxXD3aa/M3k9gHxLMLja++2JYkfphFhp49MwX5QEZUmB01bmHiL6U3AQQgBp
         PYp5mlL2JZ7HMDdwcnYGMgzNidvq+hlxlN+KYwRMfYNEK8jRY3kv4uxzLzR6glqm+cjT
         716mYGZsVXpB/1BPXJQp/GXAdPhQPFPmT7s+PL5g/oOT5/iWo77xm71I25Uon9OS10J8
         OxvlqgjypZC+KzrPnkceZRtZ0Kck5G73NdRpsz/VX9fqc9kpJPvjBtbGEXLUBmmQTgAz
         B2Df6nNlqWpjFd3eO+0wEj6MpLlJaQTRYw/JxbJ4HmbZVCLYyh2mHA6G9at/DWYvoIPE
         pT/g==
X-Gm-Message-State: AOAM533FxjB8VOE1z/8HBpDOqPY0GWlsiZ2NcMjiGqnlqS6oYrFAmEKQ
        pQG0hAowT0O/CYR/o7yAxJ6uAdX+Ziuj0EX7jaA=
X-Google-Smtp-Source: ABdhPJwSAaZJfpGKxkLLTXuhq5d9bq9sTol7NAMegIgcAukEn+36YLrrN0ajD7D+Vfxo36peiJOo78hXGiX/3pGPC7k=
X-Received: by 2002:a4a:9552:: with SMTP id n18mr8646494ooi.1.1594808349233;
 Wed, 15 Jul 2020 03:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Jul 2020 12:18:58 +0200
Message-ID: <CAMuHMdUH4yVek8Fn2z1xneTS0Y_vkMv+w7VwEDJvCUXR9qVQRw@mail.gmail.com>
Subject: Re: [PATCH 3/9] arm64: dts: renesas: r8a774e1: Add IPMMU device nodes
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
> Add RZ/G2H (R8A774E1) IPMMU nodes.
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
