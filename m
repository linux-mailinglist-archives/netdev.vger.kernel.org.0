Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FB321EAC3
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 10:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgGNIAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 04:00:18 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43998 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbgGNIAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 04:00:17 -0400
Received: by mail-oi1-f196.google.com with SMTP id x83so13224780oif.10;
        Tue, 14 Jul 2020 01:00:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QnTe4sZ/BVwx3aWuIY96pK3amPI3OQSt3QidovW9MDg=;
        b=DVnbWK+//JZKX9DIxxeWG9G3CRQTZot4ixyDa7eabiimpmY8Jmd3b3JcQCLaqJWlLL
         9cI3Gai+0CZ2a7c99Sw/7/Nz1rdtm7pgVuGqkyh1CAdhfFRi1Y1muUGDx8maCsU1uBKa
         3d7+RpX2vdD+HjInfwsGg8G++eqfFOt0QcmvJSiWdk6DUevApz1Ew81diTE1mvncr1HF
         6AwD9O7fZqSu0p7D9TWSMn7aua6H09sDRXAJrrXMBYFbW0InbblFsvW/nP/UXmo3Wx51
         sP1GaOizDtns1TqUkL77JPBI4JY3cpXiYQh5GSt+VFX+H3c6uETPatGp9gS+x/DOUNjS
         H4ow==
X-Gm-Message-State: AOAM532bqYv+p9TB+7+q0mpttynDvxj53q7fymfcDVVYTJ0Wm/VNHlQh
        I/3tDl7kcBPjP/B44dNqow3JKphhcnKWO4vHy9g=
X-Google-Smtp-Source: ABdhPJyzIvtstGtIjvnC0xOdHX2BDAwrtjW5pB4zYT3uHZkIF8+JNHYsqpLcM1Tt8jiPySfbt+KukaiWmW7ArIQFH7w=
X-Received: by 2002:a05:6808:64a:: with SMTP id z10mr2722714oih.54.1594713616158;
 Tue, 14 Jul 2020 01:00:16 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jul 2020 10:00:05 +0200
Message-ID: <CAMuHMdUZx56wWTMdpmXhbvJV6_M=jDhQUVvD6b0-5xU-jrGsAA@mail.gmail.com>
Subject: Re: [PATCH 6/9] dt-bindings: gpio: renesas,rcar-gpio: Add r8a774e1 support
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
> Document Renesas RZ/G2H (R8A774E1) GPIO blocks compatibility within the
> relevant dt-bindings.
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
