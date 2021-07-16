Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BF43CB3A8
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 09:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhGPH7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 03:59:17 -0400
Received: from mail-vk1-f178.google.com ([209.85.221.178]:45704 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbhGPH7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 03:59:07 -0400
Received: by mail-vk1-f178.google.com with SMTP id t5so1887818vkm.12;
        Fri, 16 Jul 2021 00:56:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GfIcMH/HAQMHZKZh3T0F/Q8s2vTdDmlb0JJKxnVxJ30=;
        b=I3ghQnkamdUTYoaorfPn/N7lzZuMSkfnN61x/bUHHrJiFvtz9XjZrvAvQPRNXCBGcu
         mrjh+psGZds0G+e/yXKm76ugaFG88nAwdE6ACEFw0yog8BwAZpjEsBQ7BZwzR6C6b01I
         Rwl8zy0ehRRAB3xzF/TTc9lGi7Ph6RigbP3B9xY1YbbNgpEH6LtMZsCPd6hvRI3GTtPB
         mYuoDirwKhndqQI/2qkmV9xXrt4CtwevM9X99jXIFnFZDFll2G0wLOxu1C8fnNEEgunP
         W0iEElVy42Nx5BACOuG3ZH/ZV2QsQ6m7SYeBZpqn88AU8bqrYen4CXqUrq+BeZVqopTu
         NJrA==
X-Gm-Message-State: AOAM533raV4JF96pEfkPVPJq8QqndzQNW1uPDNlGxr3NIQMpZlcZEG+D
        jgvPjqXJ/UuvU0cUs+u9MvNHFYxR/pw+IxJyH3E=
X-Google-Smtp-Source: ABdhPJyoJIo6URHdxvsz+sHVGfhZRbJ1dj7VYB/Hfsm76MYvTf4rTTSJkzEDwPnudg0LkZAYVI9T1p+1kF4oGPYrJ30=
X-Received: by 2002:ac5:cd9b:: with SMTP id i27mr9886840vka.1.1626422170814;
 Fri, 16 Jul 2021 00:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210715182123.23372-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20210715182123.23372-6-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20210715182123.23372-6-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 16 Jul 2021 09:55:59 +0200
Message-ID: <CAMuHMdVdnXbzROzgDAX83mp8v1K6+nUB9tQAT7iGW2Ey8xfS_g@mail.gmail.com>
Subject: Re: [PATCH 5/6] clk: renesas: r9a07g044-cpg: Add clock and reset
 entries for CANFD
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-can@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 8:21 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> Add clock and reset entries for CANFD in CPG driver.
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
i.e. will queue in renesas-clk-for-v5.15.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
