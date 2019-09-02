Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA240A514C
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 10:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbfIBIQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 04:16:43 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40913 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730133AbfIBIQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 04:16:38 -0400
Received: by mail-ot1-f68.google.com with SMTP id y39so2801545ota.7;
        Mon, 02 Sep 2019 01:16:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x5bFP6fqImsucqpUwzF2lv6id1FNdDN/zAQ0TCyv3p8=;
        b=Pm5HVEtrkUBbTJzjdY7F/yKcEzUqL8WSUVL4TOnBZ6/Yj5DY9QcLeHFDDaJ0aCXQ2o
         HXKboMyWxdnXNZ9GeVur9ZBLjZkIpBHhm5yBZl26Nai10Hf1bXxz9ZUw7h+zr/dnu4YH
         UdXyoLUopCAT55/EMlfivXP+PqfFvD3iUUC/hXVpgP9PnxEqWsF2+8wuTmfxhky46lvm
         PUd822tQzXaFpCnXt2KPFAGLx1DRvvOwu+6QVRGXiaD3hUsyw1gnMEy8XCiYTXIx2DZb
         7dV3rxfReu2Pw654mccYa8kjQDv+/UmtjSuX2paaIgIUqtjCfxNC7qRskNC8v+SNIDeC
         8uYQ==
X-Gm-Message-State: APjAAAUrEX4oN3NSNQjfv0qBV4BHCmxAhjBa5cjZZm6xDb4T8j1j4big
        83mm21g6Uq/Hx3FM6epueOjY5UFO1dtR+i7KW+o=
X-Google-Smtp-Source: APXvYqzRgtUQniH4Hc1f2IfWiMKRA1STzqIz4mOrzeKGGw4mnkZS2EaJ4SkKTtR2oZLvktbrgPATOYlAH1pr5HiLjTE=
X-Received: by 2002:a9d:2cc:: with SMTP id 70mr23038848otl.145.1567412196846;
 Mon, 02 Sep 2019 01:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
In-Reply-To: <20190902080603.5636-1-horms+renesas@verge.net.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 2 Sep 2019 10:16:25 +0200
Message-ID: <CAMuHMdXQypGJ_oqUndOcf02GCqxEGEOK15+jnS5ehqdUJ+A8aw@mail.gmail.com>
Subject: Re: [net-next 0/3] ravb: Remove use of undocumented registers
To:     Simon Horman <horms+renesas@verge.net.au>,
        Biju Das <biju.das@bp.renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc:     David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon, Biju, Fabrizio,

On Mon, Sep 2, 2019 at 10:06 AM Simon Horman <horms+renesas@verge.net.au> wrote:
> this short series cleans up the RAVB driver a little.
>
> The first patch corrects the spelling of the FBP field of SFO register.
> This register field is unused and should have no run-time effect.
>
> The remaining two patches remove the use of undocumented registers
> after some consultation with the internal Renesas BSP team.
>
> All patches have been lightly tested on:
> * E3 Ebisu
> * H3 Salvator-XS (ES2.0)
> * M3-W Salvator-XS
> * M3-N Salvator-XS

It would be good if someone could test this on an R-Car Gen2 board
that uses ravb (iwg22d or iwg23s).

Thanks!

> Kazuya Mizuguchi (2):
>   ravb: correct typo in FBP field of SFO register
>   ravb: Remove undocumented processing
>
> Simon Horman (1):
>   ravb: TROCR register is only present on R-Car Gen3

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
