Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D601D769F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgERLRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:17:47 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38957 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgERLRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:17:46 -0400
Received: by mail-oi1-f195.google.com with SMTP id s198so8646090oie.6;
        Mon, 18 May 2020 04:17:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FlikUOjwjSX1sgRQ/d0WkDaMSp6bbBLhvNXBNQlS9ko=;
        b=Kkzuk+mblapggvGo9/oLIQTMoR1YnbcRdzcY9NaWLUMUvE0UWG18CmDxR2M1gwVBES
         0yQMRhMsbYGpzVBsZSbiRFBWQop1zErH3vXi8T+t3l57HSfmEHJgHd+KPDR0roY9Qk4f
         Ni5mSmmIpTdXMPaAJKynTtmUOY61KN1CM3LwD5n1aVvfO1INVH2LVWwUwFECQ9oh7e3+
         bzlvU7FSkWy9khbCyO4/zkDTu+vOyxOsi6qFdCxbB8D8Wh68Djt4M4XdxJuEaFCaT3rh
         DNSZy57PVvPeBGl9Cflb9xYtuhvTGkebRHsJ7k1AF5ngDGARrNl6bx2qHy6P2wEpIFVy
         s07A==
X-Gm-Message-State: AOAM532F0Yn7sPvkt6m7yOqJ3IxG8zWcj/H/jNMdVXn6k0IMA2pB5jaE
        dRHcmIMjfGSNNngghXyEGkjRiSBCHngS+bCWLiY=
X-Google-Smtp-Source: ABdhPJyBPeqZLhSdXUNxn0ug1jJYFyUadv08J27iVRyncXiWWHppDp6a0+pBuGv1SyT6/B8ep1yEV6DOcec8M9SLps0=
X-Received: by 2002:aca:cd93:: with SMTP id d141mr10020873oig.148.1589800665492;
 Mon, 18 May 2020 04:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-17-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:17:34 +0200
Message-ID: <CAMuHMdWaQhwarFLC48JSHjuyszJdQC1xkHB5RiovdDQq5TfwnA@mail.gmail.com>
Subject: Re: [PATCH 16/17] dt-bindings: watchdog: renesas,wdt: Document
 r8a7742 support
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
> RZ/G1H (R8A7742) watchdog implementation is compatible with R-Car Gen2,
> therefore add relevant documentation.
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
