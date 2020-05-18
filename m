Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFBC1D77D6
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 13:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgERLwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 07:52:13 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40786 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgERLwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 07:52:13 -0400
Received: by mail-ot1-f67.google.com with SMTP id d26so7753963otc.7;
        Mon, 18 May 2020 04:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zzu6Qk2CYFHzrje39/m1tYbYK6+1LqlCKbB/tGUZS8E=;
        b=gr/EmuWwbooJ9kdHNrzdO4DC4o6yUkgBVv2ZYmLmyXhByaVSJru53LlRF+olfy8wuI
         0gxzu37vzjy7wwHMhGtq5DcPFbbJH0Fc9yHUbxe4bEUk6+PdjVF5ip2a6OJc+D60qZB5
         wwW7XhqfZ3MwAOBDe9xpMP3PPjudAh0VgFDh/895tuQPEZJKj8V1DFznbg1AbmgazJPf
         SV8X62WKYrX/+70P/5DtxDl43qtX5GQGQbMGDBX7GmCV5PDbM28tLz+pnmzLgr8dBn6f
         nJSzYGPYhy8OxrZna7pF2ueC5BgADKskx610QQ4mUXLtL17zG1EBRVLICKHY0r2ghaB+
         5NAw==
X-Gm-Message-State: AOAM533tWvkWRtTV3aG9MRRKLh4+SGYef6mVCg9BjDdN0Ulc8QjhhS4y
        kPa0DMWqnHRwN86gFWmTE26KFGlX0jkcxhefG+M=
X-Google-Smtp-Source: ABdhPJypiGguIQfhFqENHUpAWkG0WkHCg7Icvqyktxlx4dZxcpVwt16bAkLG0RK2kztBZxOeqO2V9x5GzCv/4kWKUik=
X-Received: by 2002:a05:6830:18d9:: with SMTP id v25mr7960917ote.107.1589802732029;
 Mon, 18 May 2020 04:52:12 -0700 (PDT)
MIME-Version: 1.0
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-8-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <1589555337-5498-8-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 18 May 2020 13:52:00 +0200
Message-ID: <CAMuHMdWB=DGQG9ydwGmSuGXMUz9JOm8=+hggGwRgQWRMsw9Mqw@mail.gmail.com>
Subject: Re: [PATCH 07/17] ARM: dts: r8a7742: Add MMC0 node
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
> Describe MMC0 device node in the R8A7742 device tree.
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
