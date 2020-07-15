Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A362209D9
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 12:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731120AbgGOKVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 06:21:34 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:34546 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgGOKVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 06:21:33 -0400
Received: by mail-oi1-f194.google.com with SMTP id e4so1829623oib.1;
        Wed, 15 Jul 2020 03:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6inM0ocEyZQ5HchWw8zVdrmAmJqjlnWoNUy7SfSkBcE=;
        b=meIiyqJUcAkSWwdFluY+XPfRnwJBwaOF3Dyr23Cp7d/DzqyOZ791+G2msQQbrlKdxw
         8NnC5UugtdXi7eSllJn8hQA8BjLIkPDwIHRcDUDVlwerCuXbGuNCnwo+BCcPC1uzdN+l
         i3jOV4+RzYDvABgeWqggD8nyS3JKhsFdOO7OKanhxNtd1QeVCHSJcXCjTZXe95y53nDN
         Gbhzua+U99tlCu7d4N0X33rzFMYaAC9YMdhWH1iRe+LLyESberD3/cz+VpJGUuWUyn1L
         iRObY8oSuxLKvI2nvmO7Zyjcqjf4kwUMm0/8MZJDI8awZMIKBG+90d8JoOi4+GFkKLAq
         Iing==
X-Gm-Message-State: AOAM530tYhetsPke71IvK7VC6ff/vsxn8qkUzPkXulsQyN+EPTuFY0vr
        QoXWvnZRIDCSlIm9aaTCOzq+VdOta7CPAlTuDkE=
X-Google-Smtp-Source: ABdhPJxYdI5rswCbbqKyGuRp4F+uj/OCEoqH521lJ2O2n+yEpcXSA2cgisjpKCexy5j/wlDx5/JSDUabZJAJaHhTISE=
X-Received: by 2002:a05:6808:64a:: with SMTP id z10mr7225247oih.54.1594808492194;
 Wed, 15 Jul 2020 03:21:32 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-8-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-8-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Jul 2020 12:21:21 +0200
Message-ID: <CAMuHMdV4w75-CNiamJo_nxHBA2kugQj58edPYDh_dx-PN4Vx-w@mail.gmail.com>
Subject: Re: [PATCH 7/9] arm64: dts: renesas: r8a774e1: Add GPIO device nodes
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
> Add GPIO device nodes to the DT of the r8a774e1 SoC.
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
