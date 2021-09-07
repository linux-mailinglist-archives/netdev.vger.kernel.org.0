Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB70402A8F
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 16:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbhIGORG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 7 Sep 2021 10:17:06 -0400
Received: from mail-vs1-f51.google.com ([209.85.217.51]:43935 "EHLO
        mail-vs1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbhIGORE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 10:17:04 -0400
Received: by mail-vs1-f51.google.com with SMTP id u1so8418946vsq.10;
        Tue, 07 Sep 2021 07:15:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vrUzw3mgPrH9nNYB65b3jL7a0ZFs0GiiNzYJ3pivNBM=;
        b=BRaOlltpGUA3ti8XQMCUQy3RH/G+82OObODVJlVxsbRmKXC0nhrQAHNX3pFeSNZ1l5
         SuyRUTV77HPes2RBgZofVRmUpLzC7AKc8qhMBcCIc4GJ01w+BeJBA/ri9llOeXnu/hnl
         5Prp7Gx8zTTIyltFCmMUKHDmLC8xN6FemSbxZtkdWYveDNHBbhuxW9PThlCdH6rXCk2N
         xXnhXySMYUKRo80nv7SvSF7dGXD1EbKEJx7V0LYpyBevslWRqnna6ULQC1l9EWiMsMU2
         9rZadMjW3wFyShT3Ibx6qU05bAhJr2LO8/29imjAKAXL/JhckwCeSxoGKVtauqNhuHDz
         K3jw==
X-Gm-Message-State: AOAM531nylqa5KKAZ2G3UB0hSmnP8ntR7WKcKemv+BuymgEbjfkt9bcB
        lN7zTL9aIlPFObQ3RfbFyj/OZk/d69AQzzbkTIM=
X-Google-Smtp-Source: ABdhPJx3BvU6MgOZSl5S/ROpD9m3nQQxQuv4FMXJ74LKzWp93g6mcVjk5tVG08S4Y4lrDpSaPv/MsXc0BZEU8TSNkxo=
X-Received: by 2002:a05:6102:b10:: with SMTP id b16mr5405774vst.41.1631024155827;
 Tue, 07 Sep 2021 07:15:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210907134617.185601-1-arnd@kernel.org>
In-Reply-To: <20210907134617.185601-1-arnd@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 Sep 2021 16:15:44 +0200
Message-ID: <CAMuHMdWLYzGs0N_oC6tomH5YjLWukZf-y79dJ6a9n0scJu6aAA@mail.gmail.com>
Subject: Re: [PATCH] [v2] ne2000: fix unused function warning
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Armin Wolf <W_Armin@gmx.de>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 7, 2021 at 3:46 PM Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Geert noticed a warning on MIPS TX49xx, Atari and presuambly other
> platforms when the driver is built-in but NETDEV_LEGACY_INIT is
> disabled:
>
> drivers/net/ethernet/8390/ne.c:909:20: warning: ‘ne_add_devices’ defined but not used [-Wunused-function]
>
> Merge the two module init functions into a single one with an
> IS_ENABLED() check to replace the incorrect #ifdef.
>
> Fixes: 4228c3942821 ("make legacy ISA probe optional")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: do a larger rework to avoid introducing a different build error

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
