Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF4040C030
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhIOHJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:09:50 -0400
Received: from mail-vs1-f51.google.com ([209.85.217.51]:45740 "EHLO
        mail-vs1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236522AbhIOHJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:09:49 -0400
Received: by mail-vs1-f51.google.com with SMTP id k10so1752344vsp.12;
        Wed, 15 Sep 2021 00:08:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GIU4MlqY+ZV8L1PJLV64O5FnoZLkCofL1zHAo2PxhYg=;
        b=t5wSCiuqpIk4aPQChedYveD2Ixlo4w3FAsvzPGsL8KN5d6R9Xu1rvPgruc+OHaDvRT
         c3+3ovFLbHDqnfDgskFvJpy86a4CH0G2BB88g2Fg/bRNJRIhNUoSkVIrVDLEr/fa9OEw
         LPvXNuamgoqQVnwpV3evzaT4eqjiQhloBV8NuVdyjtsiwCPpXe5Ax3nfPJbciBVfSt5A
         e/6UrQrYdFOnWVYHXOARDsdL0BuQlq4Q7IyrC5XawxOKf1fuxf1sKlYqL61/7pcKiVeF
         l3+5cqGet5OFtsdkSBjFb+Yj+sNkNaLRpyWTLVFh14Du/EkwhaPdtkzDDjElSQRi8fDm
         /omA==
X-Gm-Message-State: AOAM533sUdTDgac1v6Wl71w6CjNyUe2qEV1s9YoVT6Bffk+yceEyvHl2
        nEQmWetsGFi1wOV3GTuwcBPkVrL+wokQssaHQJw=
X-Google-Smtp-Source: ABdhPJxesSzI2I48+re8he3GJRZ3I+QfEjMzcC2NyoQom6rY4pH5PLSGwmkFIzYg5Ab5CsbbM/DbX4AQq4TBMx+Hmlc=
X-Received: by 2002:a05:6102:2417:: with SMTP id j23mr2255967vsi.35.1631689710496;
 Wed, 15 Sep 2021 00:08:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210915035227.630204-1-linux@roeck-us.net> <20210915035227.630204-3-linux@roeck-us.net>
In-Reply-To: <20210915035227.630204-3-linux@roeck-us.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Sep 2021 09:08:19 +0200
Message-ID: <CAMuHMdXM8qq-J_jHjkpNByvKqXG5_NbP-G43NsjKBDyFhS6ufQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] net: i825xx: Use absolute_pointer for memcpy from
 fixed memory location
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        alpha <linux-alpha@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-sparse@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 5:52 AM Guenter Roeck <linux@roeck-us.net> wrote:
> gcc 11.x reports the following compiler warning/error.
>
> drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
>     ./arch/m68k/include/asm/string.h:72:25: error:
>             '__builtin_memcpy' reading 6 bytes from a region of size 0
>                     [-Werror=stringop-overread]
>
> Use absolute_pointer() to work around the problem.
>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
