Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6978517DC86
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 10:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCIJeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 05:34:00 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46323 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCIJeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 05:34:00 -0400
Received: by mail-ot1-f67.google.com with SMTP id 111so4528193oth.13;
        Mon, 09 Mar 2020 02:33:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WvHxGDbM4xXg1EcvuRgNde2oxcAJwP0NhI/8JQp0zEY=;
        b=L3T8/hxC0oDJF+55FZSJ7MCPdYS4iEO54lYy6WoVH1A0iII2t8IhtG8xZw5JFFv8xm
         UBpYW4wxMnhfOwG0mAiAzHFYHKy9iKviy2DREQZGxI7qmH5cDi2XQe91kvb+sE7+s18n
         1UQhsU+TD5gBdWen5J8+TCQ7Jan2IlLAjI4KwA12WWTbSflHa5p4GI37/6I6r1x24qy6
         5jhxvnfnExi29XfXvhvukCRM7vZh8Nblo876BHPKUkLd16+Zam/Yq5laUybcq5KCqegS
         E8jz6qWuE0Zk53w313t/D56zATmYIpFfgkjU5BtuXZIt75hgnOQzALMqUcEK62b7xzLy
         YHCw==
X-Gm-Message-State: ANhLgQ0dnN7miRrXDnsuP/eMiBdCzNqt/LnJSgCPewCj4gS92j7qeRCo
        G8obF2/BcE8LO4RcC8wY22pLteKqaQtiR9XdP0Hvmg==
X-Google-Smtp-Source: ADFU+vvGXVMhNMBu467qKoGTYw07Jrqf4CWMrfjNI5VI/gydRbL/mvE+UHDShNSmuzoQ4WgBSiT0S1tNIZFLWepP+gU=
X-Received: by 2002:a9d:4d02:: with SMTP id n2mr2935668otf.107.1583746438904;
 Mon, 09 Mar 2020 02:33:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200309092950.3042-1-geert@linux-m68k.org>
In-Reply-To: <20200309092950.3042-1-geert@linux-m68k.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 9 Mar 2020 10:33:47 +0100
Message-ID: <CAMuHMdVtNjtuxJYtE9npQheDe58iWwKihkz6xUB3iuzgV8hEWg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v5.6-rc5
To:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     linux-um <linux-um@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 9, 2020 at 10:31 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v5.6-rc5[1] to v5.6-rc4[3], the summaries are:
>   - build errors: +2/-0

  + error: "devm_ioremap_resource"
[drivers/net/ethernet/xilinx/xilinx_emac.ko] undefined!:  => N/A
  + error: "devm_ioremap_resource" [drivers/ptp/ptp_ines.ko] undefined!:  => N/A

um-all{mod,yes}config

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/2c523b344dfa65a3738e7039832044aa133c75fb/ (all 239 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/98d54f81e36ba3bf92172791eba5ca5bd813989b/ (all 239 configs)

>   + error: "devm_ioremap_resource" [drivers/net/ethernet/xilinx/xilinx_emac.ko] undefined!:  => N/A
>   + error: "devm_ioremap_resource" [drivers/ptp/ptp_ines.ko] undefined!:  => N/A
Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
