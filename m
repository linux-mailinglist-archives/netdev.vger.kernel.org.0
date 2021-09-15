Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5391540C029
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbhIOHJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:09:19 -0400
Received: from mail-vs1-f53.google.com ([209.85.217.53]:37849 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhIOHJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:09:18 -0400
Received: by mail-vs1-f53.google.com with SMTP id i23so1789473vsj.4;
        Wed, 15 Sep 2021 00:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a1ubzPqneCoCRWymQt/DPxsQuqKvhkE5Z8aHIVy6Log=;
        b=mHCJCar4Xon2OJ1uoHuNQ+lpwpABdoMskKqM/zLCiaKEMJ4fnVzMbNPkLzunMtw4Lz
         QDMQXHroqpqhYqC78up5JyhROyfZRNV6uJPxcN6hLm8+Cr0/Z57X26Hm1fBkJd3oPuZG
         bQbG+ZS3zM4CCQQZixicK3rmQFp7x3tbWga54SRYkFvQUwt5jEr58m+P9fpbMFeLK+3t
         H+wzmD92gHTE+cA8tt2ZMlDCUFtzukHB3rOkHwzS+PC3tSVixc3ir1eS6HdJDGMPCdJG
         s0XnY65AmbV00QA7KBLyscTRBkxjn8ei813AZv3EW4gP2FKo0lLJL6Z4CNugfsNczmdP
         uSKg==
X-Gm-Message-State: AOAM530h6oAMhnA8zSz0bmU0UfDfeNqMCl0cp7C72X7O2yaWFSCB64xV
        d5JyvYFOAeF+PbEPtKPKGclfHbgve67A/zXdUIWmXNWD
X-Google-Smtp-Source: ABdhPJxHnxoszY0sDj+hYWU0BjE3kyyw/RQ3D4awXIHnhLApfgsvuSgs5P41V6o+hh5KfRrFWq/4//5doBTkeuIdizM=
X-Received: by 2002:a05:6102:b10:: with SMTP id b16mr2224836vst.41.1631689678872;
 Wed, 15 Sep 2021 00:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210915035227.630204-1-linux@roeck-us.net> <20210915035227.630204-2-linux@roeck-us.net>
In-Reply-To: <20210915035227.630204-2-linux@roeck-us.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Sep 2021 09:07:47 +0200
Message-ID: <CAMuHMdWiAc_8Z5wK07c5Fi3Zf72RpPzqv32QHC=iYtBQpi=3dg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] compiler.h: Introduce absolute_pointer macro
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
> absolute_pointer() disassociates a pointer from its originating symbol
> type and context. Use it to prevent compiler warnings/errors such as
>
> drivers/net/ethernet/i825xx/82596.c: In function 'i82596_probe':
> ./arch/m68k/include/asm/string.h:72:25: error:
>         '__builtin_memcpy' reading 6 bytes from a region of size 0
>                 [-Werror=stringop-overread]
>
> Such warnings may be reported by gcc 11.x for string and memory operations
> on fixed addresses.
>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
