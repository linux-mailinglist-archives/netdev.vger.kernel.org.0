Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534B624D566
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 14:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbgHUMtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 08:49:36 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:47022 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgHUMte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 08:49:34 -0400
Received: by mail-oi1-f195.google.com with SMTP id v13so1371708oiv.13;
        Fri, 21 Aug 2020 05:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rjOR1LmEKfBAICv/oUVmVt9ScklJwbBO66lk/funKdI=;
        b=nflgJ8t5aXajiMTbTVKHE4YYFNmaLZWWjroY2Jh3KH1xQQuPo8XbHiFr3QFVYz0OHk
         OWM7CephvaT2v8SfN2Pt8+DeiSkkSeS8HdGG0VYdcurmUNb9tBdtU87btIvPFFvaWrj1
         Vp3liG9TZhXkrYUElEhI3zexA9En/6k5J0GIj+VBi2f6ucSh4IPoWLDa4GrTzOGmlDm3
         6G8Z4wci6X3UQBZrCYdJNpske7e8f0jDMQ4mTQyH/E9goQMn5RjMmqEYNEKkd58T67Vu
         N3/RCex/+JhuiNDlD2rPmvsDh5siQc6U+1wS/FNZXkosmsZP+Fa0jgf2X601qd3Mf+3s
         GGuw==
X-Gm-Message-State: AOAM533fYaP1Ma5ogdSJqZye8fEXY76Ar8FrzA7Ew+w61IoTZwmbadrZ
        KjDBFwgKH8JMpakklqCLQxWVB1qB4+WpihPoZNg=
X-Google-Smtp-Source: ABdhPJzz75flJqlcgm/5pJRSwS4KxLsRUf7C3UrU8LFP2uay8UIHgSPAopyMegH8gsFlk8YxFUBtt+e2BRo7+5+sibs=
X-Received: by 2002:aca:adc4:: with SMTP id w187mr1440803oie.153.1598014173372;
 Fri, 21 Aug 2020 05:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200816190732.6905-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20200816190732.6905-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20200816190732.6905-3-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 21 Aug 2020 14:49:22 +0200
Message-ID: <CAMuHMdUmj0W9ELiJXgp6KLjeVAs7hD8C6rahLxFchh+=ny4LhA@mail.gmail.com>
Subject: Re: [PATCH 2/3] dt-bindings: can: rcar_can: Add r8a7742 support
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

On Sun, Aug 16, 2020 at 9:07 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Document RZ/G1H (r8a7742) SoC specific bindings. The R8A7742 CAN module
> is identical to R-Car Gen2 family.
>
> No driver change is needed due to the fallback compatible value
> "renesas,rcar-gen2-can".
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
