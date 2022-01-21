Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D3949614B
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381135AbiAUOnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:43:37 -0500
Received: from mail-ua1-f49.google.com ([209.85.222.49]:46911 "EHLO
        mail-ua1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiAUOnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 09:43:35 -0500
Received: by mail-ua1-f49.google.com with SMTP id c36so17213213uae.13;
        Fri, 21 Jan 2022 06:43:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=55AwSfSypaE2CtoXb7L0xkm1j87MyCbe6QHjOqmiD28=;
        b=gljX+jPPXhkLWlxSZemNrIcCZUdyfQJnPoLZnlWjply+68akM3t6P5Fw33+Gfq/ICx
         qWx3UXC0AaUHvd0gQUU0ttVhL4PXduQdy2UelqY7VVdr4sXS9ImXL3tLAjpmDl40Jkp2
         rmOxeva+t3pfWMcRO/BALWCXi0pNooJU/CKCdwIRDh8IBPR6SvjAo/bCnDFMKnttYBFa
         VJ3Q3+UtN01kmmmluqTXkZWlBWHTdd9oBIJqri1JGhxoGEaD3UlEWUs2qbdx+MHYtoVO
         ExvMPn1yRIfLMQqNnTC63yhyVrcPHeP145sxa8AWDA8uKqLZ4YqAKU+tsVNx8KrHW8GU
         U+iQ==
X-Gm-Message-State: AOAM533a8Ur6ofnEhBXM82msE/RuX/zMyemxx+uWeBB5ZsDuwX8/+MwC
        9oLpwDUBIPKD/51hTeP4ktPTlF+GyhrqJQ==
X-Google-Smtp-Source: ABdhPJyXohDcYDK1tlK/7Rd9GTJ72zhebbYr5kZ9KuQM+iBFzNnXsKyV2PkSOIYpMf36LrNO31n3AA==
X-Received: by 2002:ab0:3b0c:: with SMTP id n12mr1876164uaw.26.1642776214158;
        Fri, 21 Jan 2022 06:43:34 -0800 (PST)
Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com. [209.85.222.48])
        by smtp.gmail.com with ESMTPSA id g13sm1392793vkp.15.2022.01.21.06.43.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 06:43:33 -0800 (PST)
Received: by mail-ua1-f48.google.com with SMTP id y4so17302888uad.1;
        Fri, 21 Jan 2022 06:43:33 -0800 (PST)
X-Received: by 2002:a67:e95a:: with SMTP id p26mr1708645vso.38.1642776213391;
 Fri, 21 Jan 2022 06:43:33 -0800 (PST)
MIME-Version: 1.0
References: <20211221094717.16187-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20211221094717.16187-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20211221094717.16187-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 21 Jan 2022 15:43:22 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUZWwKLQAaqOsASUhrVmQ89sLL4K9O7x-crWHzFYqUCTQ@mail.gmail.com>
Message-ID: <CAMuHMdUZWwKLQAaqOsASUhrVmQ89sLL4K9O7x-crWHzFYqUCTQ@mail.gmail.com>
Subject: Re: [PATCH 01/16] dt-bindings: arm: renesas: Document Renesas RZ/V2L SoC
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 10:47 AM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> From: Biju Das <biju.das.jz@bp.renesas.com>
>
> Document Renesas RZ/V2L SoC.
>
> Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.18.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
