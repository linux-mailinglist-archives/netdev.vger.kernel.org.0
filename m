Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075AD1D7637
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgERLKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:10:43 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:41828 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgERLKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:10:42 -0400
Received: by mail-ot1-f66.google.com with SMTP id 63so7664238oto.8;
        Mon, 18 May 2020 04:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hfu5FZwyRMz2cBI6uHSbWSrYNlQoEMc2a4ByBzUOoxc=;
        b=PvGR3H6188VUwbVuqz+U1tSZlDPR4aNMbSZ06UVNUI8IQTFKkxHnw8o4Pi/LYazKFH
         bOAeBjkjJCACmEL2DELOj/ES5BA1AqrhIkfbMeOLfXGX3S+M/Fpy2kpOZbO8yImHWgE+
         P8g9gg/UjbCmSIcSecwOmOiUqmEIsb1l3gbCmN0UmbJ6qR9HD/wQfE2rRHxjRYyd3J37
         gCt7n7ZiL7lkLP2c7pKCvHVYFONib1YE4hCBdv0PnMDS9YgYg5LUzSJpTZvQc5pb/ESm
         Rbw/8ZySz09GZAL86Ix0hFA46BTFVkCXe43vyeL0tLTfFedvib8aCi3o5rDTd0mS8+ym
         H/Kw==
X-Gm-Message-State: AOAM531Rg/GhtPvNQfT7Vqtg4iOX0CIEfl0hJmroFBPaWv72nzpfyDoO
        F7JwwNLIWz6uwoV7xorqFKPlGteUeZTJpgrbgi0=
X-Google-Smtp-Source: ABdhPJzLb9Yd2vPjmp9vAX26Li3ikoW7YmjqcRstw9qLIGMukOAchEat+0yJWN8MFTwBUc3KOSYqxGh1YLmdx/kPZS0=
X-Received: by 2002:a05:6830:18d9:: with SMTP id v25mr7863547ote.107.1589800240402;
 Mon, 18 May 2020 04:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-5-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-5-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:10:23 +0200
Message-ID: <CAMuHMdX_Uo+wMtbpj9o6qM_7j5knOP+qwnRuoWgxJUWWBS074g@mail.gmail.com>
Subject: Re: [PATCH 04/17] dt-bindings: mmc: renesas,sdhi: Document r8a7742 support
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux I2C <linux-i2c@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 5:09 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Document SDHI controller for RZ/G1H (R8A7742) SoC, which is compatible
> with R-Car Gen2 SoC family.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
