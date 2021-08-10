Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205343E5789
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhHJJxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:53:46 -0400
Received: from mail-vs1-f42.google.com ([209.85.217.42]:35634 "EHLO
        mail-vs1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhHJJxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:53:45 -0400
Received: by mail-vs1-f42.google.com with SMTP id b138so11968848vsd.2;
        Tue, 10 Aug 2021 02:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S2mwLXgLe34hkbYtljXjTjA3I8KCckCNQbP0HcYtm9A=;
        b=Mjw9MdWQ9n8Ku0vMn4aJ7MyBog0BnIWtNuSyxK+pqf3bNya9KedG3VCGt7VCUc1Q0R
         YGS5CzbRCJGVk23iS5XD3G/9yZ0jmHcWSaqTY/i8nsHYfX9FlbtuolZbuJYOlW4b1pdg
         tm7AX7XnuFGbYFvZZSt3GpbHeOYRM/t4MgbrxR9+29lwM5OM6jQS5gOvVh0rp4/2emkc
         3s0ZmgInG5ooVL52TQ+3zVjfIhzsJ/UnjPBcvf3Eg9kpY5CaGPuza5gMX/gEjuzgcDnL
         yTolgR6Rsnahcpj9q1NbupyH0T+JsHYDbexkyFkxBlmgVX1147lfHaD00Uj1XuSuhx39
         s3Og==
X-Gm-Message-State: AOAM5333h6C9k9GvOLZ6X5hBmRYzWXVJL3oQcti9ACIVMCW/qHJZerC5
        vCwWku0Jg8bnXWxv5b/wqYIwO4DqOUqLpNlmB7E=
X-Google-Smtp-Source: ABdhPJw+OOGkNx22bnwbTSGu3XUk55wtMnmGfEefyDALdGanu14MXj52HaBVsKThqaWtgVAjZr46DwVYcpKhfqn+2kw=
X-Received: by 2002:a67:e2c7:: with SMTP id i7mr20103201vsm.3.1628589202976;
 Tue, 10 Aug 2021 02:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210727133022.634-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210727133022.634-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210727133022.634-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 10 Aug 2021 11:53:11 +0200
Message-ID: <CAMuHMdWhi_Zey-031hhRz_G4wHA_guSg5kZTw+LUdtvF9bbQfA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] arm64: dts: renesas: r9a07g044: Add CANFD node
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 27, 2021 at 3:30 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add CANFD node to R9A07G044 (RZ/G2L) SoC DTSI.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.15.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
