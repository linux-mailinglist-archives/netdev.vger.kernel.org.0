Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FE541A9F8
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 09:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbhI1HmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 03:42:18 -0400
Received: from mail-vs1-f54.google.com ([209.85.217.54]:45632 "EHLO
        mail-vs1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239350AbhI1HmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 03:42:16 -0400
Received: by mail-vs1-f54.google.com with SMTP id x1so230705vsp.12;
        Tue, 28 Sep 2021 00:40:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fU9oYQxlMHaEmrFTAibMQ2psCWZx41wzemKb/HO3LR8=;
        b=Z32P3eB5uU1Ik8MPNgMFTDnTUibW2R3HvSK2VrlG7ne6NBSyj562abZUqu5iFRgjWP
         DWzoX3J7Q1DTkql9mtBJkqLOAVxDB4QZs3No9n9Wup1MIfSiYpnvqNjNxLUt/V7bvfUb
         7ERzMpxnA5K5/ymNI4fX9KUZdoYZkhBrCwuTBZ84YpmQgHYnwCkaBaY/hCq0/h3sfjgZ
         Dxandekw249zI2qQcSxgoWyrXst3D/5C+yvU6bmICYFHxvZhf4JIlzfKN9tnzSF11VK3
         gQeLfTBxT1B8+3B5e0S05YTSw5yyIseq+/hN0ZKxUUbqAtspxnEYM60OC2Gtg0Bg8KL1
         xbpw==
X-Gm-Message-State: AOAM530UnHZ4q6xNOKHGzuwEx/5R7iOzsboNvqjiUKL+2/EjQ7S7MSA7
        hLtDQT9DjUG+YBxwTnsjt+ERpJrMmKNHF8tIRHM=
X-Google-Smtp-Source: ABdhPJx7QKRDdYhuI6YS9EOA8Mi2iLTrovyl/FL5RUqEieA5W05H827uSzJTvVkNa9haVDs97ya+VsOIs1lakJFP/N0=
X-Received: by 2002:a67:cc1c:: with SMTP id q28mr3403521vsl.37.1632814837348;
 Tue, 28 Sep 2021 00:40:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631174218.git.geert+renesas@glider.be> <07bd7e04dda9e84cde0664980f0b1a6d69e03109.1631174218.git.geert+renesas@glider.be>
In-Reply-To: <07bd7e04dda9e84cde0664980f0b1a6d69e03109.1631174218.git.geert+renesas@glider.be>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 28 Sep 2021 09:40:26 +0200
Message-ID: <CAMuHMdU6g984vuU5mq7LAxmfE=QDfKzPDW7kgfR=9X0jYQC_Bg@mail.gmail.com>
Subject: Re: [PATCH 8/9] arm64: dts: renesas: Add compatible properties to
 KSZ9031 Ethernet PHYs
To:     Magnus Damm <magnus.damm@gmail.com>
Cc:     Biju Das <biju.das.jz@bp.renesas.com>,
        Adam Ford <aford173@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 9, 2021 at 10:49 AM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Add compatible values to Ethernet PHY subnodes representing Micrel
> KSZ9031 PHYs on R-Car Gen3 boards.  This allows software to identify the
> PHY model at any time, regardless of the state of the PHY reset line.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> I could not verify the PHY revision number (least significant nibble of
> the ID) on eagle, v3msk, conder, and v3hsk, due to lack of hardware.

In the meantime, I managed to verify the PHY revision number on Eagle.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
