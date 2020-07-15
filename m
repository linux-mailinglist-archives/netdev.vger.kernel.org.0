Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE7F2209E1
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731141AbgGOKWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:22:00 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:34898 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgGOKV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:21:59 -0400
Received: by mail-oi1-f193.google.com with SMTP id k4so1826633oik.2;
        Wed, 15 Jul 2020 03:21:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mglmcsKPXfYjFgkpFQPfnyRmHIvI83yiimMnStaOfVM=;
        b=aYJ0LXYJkqiycUCPoxFYnG/P6/6G0JUpDBvj6VOMILCp7N9aPAiFwrbO+izYLDrMo5
         SigGXhM0clPigEk1O79Xskthtb1e1LOStL5P511GI3tOcgKg5bLjat1rEOYSdfVJDHLe
         5j7HBBnD0gd8O/pXSMiueGZ4E+7Ac8DCR4hQVDDO7CiEHei4zAanKood5JY+HGvliPkK
         BC+YifqsKxcIV8IQlS2u+j9RNH2iPAAxqiyokTCDDxARx8wSI9w865PZxHrp2m1HNEZj
         QchuwGyvsqMAbyqL4RM+qJAxqfWc9SSazKkNfAwea15zFhOrArk2m4xwtrBVhSNFoJYA
         yCNQ==
X-Gm-Message-State: AOAM530UPuY/qkiT5pNqHwABLM13q0m9UOEoSvEjW0xFnsiLGNt8dBxA
        ekv0SLZ2U21XC7OBg8Oerv8aLABdC0QGxJhaa98=
X-Google-Smtp-Source: ABdhPJxetY2zZjsVuoA3jOWHEG6J+zzk5r64HjE7xop1bHsgYqjER5pXa5UqlqTc4KwjUMQB7HpJmP64L5RrgK0EPW4=
X-Received: by 2002:a05:6808:64a:: with SMTP id z10mr7226625oih.54.1594808518858;
 Wed, 15 Jul 2020 03:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-10-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-10-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Jul 2020 12:21:48 +0200
Message-ID: <CAMuHMdX63hYJ=wx08_S++TjfcZCbYrZCBd6PYY8GQmBwVsw_Bg@mail.gmail.com>
Subject: Re: [PATCH 9/9] arm64: dts: renesas: r8a774e1: Add Ethernet AVB node
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

On Mon, Jul 13, 2020 at 11:36 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
>
> This patch adds the SoC specific part of the Ethernet AVB
> device tree node.
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
