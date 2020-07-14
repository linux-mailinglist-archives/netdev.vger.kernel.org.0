Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9D821EA25
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgGNHff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:35:35 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37998 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgGNHfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:35:34 -0400
Received: by mail-ot1-f65.google.com with SMTP id t18so12322555otq.5;
        Tue, 14 Jul 2020 00:35:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NZcIe/n8EL1l/9gxEVLtkEGOYa9jYbE3R0xJVcLLVWo=;
        b=j4y5YOKdYxchN0eLO3lRBM21Oyn7kngpzLh2b8M2BHcqvx9PN9ZhstrOXMuA9ph/Wk
         q3s4PybHWP8BMp+2Yl40TpR6W2qCO4qIF4l3/uuwm6PsUHeNwJMghRjWlzEERImdvE9g
         mrg/AdSa0ktC+pI9VpsHp450Z1/8bTJQhjJLSL+vFVn79bB4acGxi6iuR+heEt+deioB
         645Z+beFDd0U9YiZeCFXJS/ZlsXkDDT2XDzwRNBslO+BIbcJr1jDVkNTZupVjB2Vmh5G
         X7fAJ1/Ee+T7+Arg2xFLNPw+Zn9u+3/tzFQZLcAwykpSgYaWmrbqESN3kR9i3D2wbvp8
         +7ew==
X-Gm-Message-State: AOAM530Ev7Eo3YcMcx5kfyQj+vnCg55obvCBcv8JpCrQ9w67FuesCD62
        1vOMLNJI9+ayhIb4ZKKtLwkK+vj7V4oDVBteQPQ=
X-Google-Smtp-Source: ABdhPJzA6FPp5jleEWzm/FeVEe/oRoGYj9B6NSxQuasfiLs2MoznFs7U6TgH+op0h6Q480AB2MO5mvvOiAIGabzifls=
X-Received: by 2002:a9d:2646:: with SMTP id a64mr2793065otb.107.1594712133696;
 Tue, 14 Jul 2020 00:35:33 -0700 (PDT)
MIME-Version: 1.0
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1594676120-5862-2-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jul 2020 09:35:22 +0200
Message-ID: <CAMuHMdX2w+N4=UNEbK_yELvgs0BZ4rXM=QdAwvgWbZokHN+s0Q@mail.gmail.com>
Subject: Re: [PATCH 1/9] dt-bindings: iommu: renesas,ipmmu-vmsa: Add r8a774e1 support
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

Hi Prabhakar,

On Mon, Jul 13, 2020 at 11:35 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Document RZ/G2H (R8A774E1) SoC bindings.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml
> +++ b/Documentation/devicetree/bindings/iommu/renesas,ipmmu-vmsa.yaml
> @@ -32,6 +32,7 @@ properties:
>            - enum:
>                - renesas,ipmmu-r8a774a1 # RZ/G2M
>                - renesas,ipmmu-r8a774b1 # RZ/G2N
> +              - renesas,ipmmu-r8a774e1 # RZ/G2H
>                - renesas,ipmmu-r8a774c0 # RZ/G2E

Please preserve alphabetical sort order.

>                - renesas,ipmmu-r8a7795  # R-Car H3
>                - renesas,ipmmu-r8a7796  # R-Car M3-W

With the above fixed:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
