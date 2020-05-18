Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B8B1D7494
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 12:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgERKAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 06:00:24 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39665 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgERKAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 06:00:22 -0400
Received: by mail-ot1-f65.google.com with SMTP id d7so1163275ote.6;
        Mon, 18 May 2020 03:00:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nZUgb7w2eqqvzVlgOR0PO/JtnnaWsf26I9iu2kr6czM=;
        b=Spf0QPPZLHEANz5oIJKERFlVEcbRkXAuOKYvvVqxTqLinkxML5xGOQ8ftFpURwz6V3
         NBrBDEIsYtoyf2FFvDah/8BsLg9JcIPoo7nq6Tk0k7K20fXTmWB+zZQnQuN+Syd7+mZa
         VOXURsv2vMWc1I0Xyhae3v7f9EBoVaxLUGNDb1iFxv9tQbeKUsiLC63JhdG9eu3ySg4E
         aBeskM2FxZgioRgk3py7E9/pxEdTcbUPup6k0e923gSFPRAOW6gcg9S5sytLjR5R1KGZ
         0uRmykl0GGPumyNG/8iFKLGWpdH9He0K8UDMhZ4Dpt/0sB2MUH1ghgPQwNeqk5pch5OZ
         W/3Q==
X-Gm-Message-State: AOAM533bGK0wSIvZdq5z24nSWhEflGLWBxx0Fv0tYbq/+kY2cIuLthhw
        /n66EYWGLc7v870avV+2B9q/qdUdu9nBEW8+VTM=
X-Google-Smtp-Source: ABdhPJxk7+cEhfYJg/No1t+pmLbnKMxymTQIyJUVCUlGNn22SWJB1SFO49l1Ln9tKTSycPbC4qQtZsNmvlHboxJD7Co=
X-Received: by 2002:a9d:7e92:: with SMTP id m18mr11386119otp.145.1589796020640;
 Mon, 18 May 2020 03:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 11:59:56 +0200
Message-ID: <CAMuHMdWZ_MWBeb-TYs3A_T0+PkWng+oSW_BRQtzCd-DaYyCrew@mail.gmail.com>
Subject: Re: [PATCH 02/17] dt-bindings: i2c: renesas,iic: Document r8a7742 support
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
> Document IIC controller for RZ/G1H (R8A7742) SoC, which is compatible
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
