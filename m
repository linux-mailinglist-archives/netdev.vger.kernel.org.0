Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74CC11D77ED
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgERLxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:53:17 -0400
Received: from mail-oo1-f66.google.com ([209.85.161.66]:35728 "EHLO
        mail-oo1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgERLxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:53:17 -0400
Received: by mail-oo1-f66.google.com with SMTP id c187so1964198ooc.2;
        Mon, 18 May 2020 04:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6tmiQrSrN1NKyct3FGv9e5Q1QdErRlRCkFiMU/GAHic=;
        b=dbU7iI1vccHSwpmxI9rbRAZafUVJVrg4lLVlqh/QFbyWBXWjva3mJoDK/wva3MoHMw
         uVKCo1VxqMtskeHFIBlj4LH7fD5esSBRCtVN2llpgQyrtNrs56MT9gCgNXSNtcOkTYEQ
         azNNcs3RkQ114CgGD7y5dmVt2xsnbJ+pfBv7oS77DQ2utFhzT38Mky60xCxRFORswGF4
         LoNTr/zOvaMNXIYr26eN+BMKvZSliVkZX9Gb8JsZ72tgBJkTu+kzUegiSZnYglz3wXMP
         GmHtG1VJGWjDIV8GxvEY2x6263g+4q7cSIER7lQhcabyWOzJwLCewyjOdHpkZ9rBFx3s
         4diw==
X-Gm-Message-State: AOAM532l4S4bZL+WJi+m76qUhQgv1N1qneCaDNcLxiBQzuchUO3B9wRp
        D1dQKjdqMf0NP7RS5X+Ni9wObHbVTODxEMdj/+Q=
X-Google-Smtp-Source: ABdhPJyXF6RctyH8v633tPbaM/fskt0cVGt4kWfaWsTK4qAeP+mAbZ+GUE55kK+iUkrrF6Wim4t4fUubepqCOJrc6PI=
X-Received: by 2002:a4a:e0d1:: with SMTP id e17mr12502300oot.1.1589802796022;
 Mon, 18 May 2020 04:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:53:04 +0200
Message-ID: <CAMuHMdWEaWs97tSqdpDUbmmyuSyshXypZghWF1oRYoJcjHGEpQ@mail.gmail.com>
Subject: Re: [PATCH 12/17] ARM: dts: r8a7742: Add Ethernet AVB support
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

On Fri, May 15, 2020 at 5:10 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add Ethernet AVB support for R8A7742 SoC.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-devel for v5.9.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
