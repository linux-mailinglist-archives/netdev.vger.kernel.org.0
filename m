Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620F724D57C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgHUMzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 08:55:15 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:34586 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHUMzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 08:55:14 -0400
Received: by mail-ot1-f65.google.com with SMTP id k12so1489602otr.1;
        Fri, 21 Aug 2020 05:55:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JQTj75v+t4gH75KqZzioaSEXd+JGBRQy2YtcQ1vRxYw=;
        b=XDH+dN7kZh0cMfSxRHTUWvvzopYLfF0xZYTcvPjh6PnIras/dEGjkjctlo6gZZ1/cw
         I4dz2wLQr7zWik/V7LwKTuon1dc4eTx0k+dHdWPNX/jPADSTltNZ4VEMpMfQw1Cnsf/8
         I46yujmmC8hx3414c5fbE8afJXh02N3zwafrwK7rLUnhcTEkeghwbxKJE630jjpY5/z2
         xhBNK9zzJeWWkx26unUwFsuzIP0UNHT1WqmKBidFfxzXWJORFBU2jQzYCvle8tCfU/u/
         jZ0jdiebu0rR9TLAq7FNNBJz0gQDRz5Kfd2LS5uXFTM4M8JHBnS5/Cv7VRP9SPzcD60r
         CaFQ==
X-Gm-Message-State: AOAM533+kyCHkGWyz4aAA6bDy3UlJeG64o9dLcp3ybXnkCr/ZEelY3OX
        PwcqT07vkvDh8PO9CiLmcw5/5440dZ0dXGB8aI0=
X-Google-Smtp-Source: ABdhPJxqc+ZD71mnoRQsfhaV3KFb+WFTtCicSB4qWqJ8DMecwf9Q2wNYJlJTt2ATIfQ0jf+/cKUpZoMekDAYtOdqD28=
X-Received: by 2002:a9d:7d8c:: with SMTP id j12mr1858350otn.250.1598014513423;
 Fri, 21 Aug 2020 05:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20200816190732.6905-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20200816190732.6905-4-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 21 Aug 2020 14:55:02 +0200
Message-ID: <CAMuHMdXmC0HuJP6fE5mLqTXn9En5moGf-0QEXfkFtiOcnAN5GA@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: dts: r8a7742: Add CAN support
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 9:08 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add the definitions for can0 and can1 to the r8a7742 SoC dtsi.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.10.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
