Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5D621EAD0
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 10:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgGNIBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 04:01:45 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:40395 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgGNIBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 04:01:45 -0400
Received: by mail-oi1-f195.google.com with SMTP id t198so13241269oie.7;
        Tue, 14 Jul 2020 01:01:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gr/9MPACjcXFT200AbtYNpFbRXhHlr2mT2NBQiQX2q0=;
        b=GJB3CYih7xT3IlYFa7400ocVQ2KeusdMh9yAPhscWmL1A/WIx/bWVv/0ArpDtMkhDj
         1hA1rMKmTbD0Sr/I/chUjWGc/Tn3v3wsLsUMIwMoHY3R8JsScqIJdr//c7fHKdrTUv9h
         NKRhTxJvBw+6sNrrd1kZhr5TW5A2L9ui/nM/dW9xy/5Gj6E2dV696gfEw06v5fuaekKk
         aw2aNfDnSfghUWwWWgRaZUDZGLaVNeTogfiV7IhtcBDTI7RKC9I4I4l0kBhmFA3UcgX8
         BVflkxBPWciufeEazXOxthOvShvyILsMMaLo3O+DEVl174mYmhPdnCvmJxlwCyR8pBwn
         IQhw==
X-Gm-Message-State: AOAM530x5CCU5uwQKC2utfMDbvA8Mfh6h6lEogUufZlecrQZ3HttpmIN
        luHCFSqa/cIQN2bnP7v6GCac7msoEtQKObmYBqA=
X-Google-Smtp-Source: ABdhPJy7kkdABSF7lhv0xD5jUKEhCpyXc6ADui6HtYdgbv0IJdB1SlTSer1oVhB10kFqgYGdnLSY0z0w3jWdAStYu0g=
X-Received: by 2002:a05:6808:64a:: with SMTP id z10mr2727113oih.54.1594713703757;
 Tue, 14 Jul 2020 01:01:43 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jul 2020 10:01:32 +0200
Message-ID: <CAMuHMdXV65Nmq8263LE-006gBeKErktAt0Fmrsurm+dLZxQs1Q@mail.gmail.com>
Subject: Re: [PATCH 8/9] dt-bindings: net: renesas,ravb: Add support for
 r8a774e1 SoC
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
> Document RZ/G2H (R8A774E1) SoC bindings.
>
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
