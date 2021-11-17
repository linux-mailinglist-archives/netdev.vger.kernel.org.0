Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155C6454498
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 11:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhKQKHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 05:07:15 -0500
Received: from mail-vk1-f178.google.com ([209.85.221.178]:39862 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233163AbhKQKHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 05:07:15 -0500
Received: by mail-vk1-f178.google.com with SMTP id 84so1286247vkc.6;
        Wed, 17 Nov 2021 02:04:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u2KwZ2nxmh1qFKKfRQctgNhN3BE0/LT7YSD8syEjPEM=;
        b=MZHslUmEqf2Ng26iwlYBYBwtefv9fX/jqaDwDSeV94WOur9GrZK2lRtRmSqS4htBJv
         EKfSahnH8VuYRtC6wg3vZJ4DQYrDhQ6TWjTIPTuSW9PkitgbAQ54PunvrQjCCPYzTR/N
         XqZ81feiS/tJ9UzDYJj8MimY68e3qC0wyKMVSHEIS6vD2SHGs6fUywUD4RQrUQvMszy0
         +XoqlQ59qxunjgleNJNQ8i+aVcWRS7qYrFeEalua+qtO4VHem+ofrz53hxQR6WdbJKks
         dLQbVw0cGKj5eDSL6p1+KWRCxlAcYChGvSEYhbqctD3cYer7jvbYU08Yxjji9sp/9i+h
         T/gA==
X-Gm-Message-State: AOAM5310jtlybVUYh2hnJvMhf66H+ACZW99JQWXEyum9cpoa35GVLQty
        7kpVQhyy+ZuXFYU1KGT1sY1vsHzJLztddA==
X-Google-Smtp-Source: ABdhPJyKKPPIsoojqddbmDkWUTu7ImA2o26RsTqHB1meaAuSTKcNE68DhX4zh5zeBbYfkaTch2rbGQ==
X-Received: by 2002:a05:6122:98d:: with SMTP id g13mr86720612vkd.15.1637143456252;
        Wed, 17 Nov 2021 02:04:16 -0800 (PST)
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com. [209.85.221.181])
        by smtp.gmail.com with ESMTPSA id t189sm12086227vsb.13.2021.11.17.02.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 02:04:15 -0800 (PST)
Received: by mail-vk1-f181.google.com with SMTP id d130so1328673vke.0;
        Wed, 17 Nov 2021 02:04:15 -0800 (PST)
X-Received: by 2002:a05:6122:7d4:: with SMTP id l20mr85285079vkr.26.1637143455269;
 Wed, 17 Nov 2021 02:04:15 -0800 (PST)
MIME-Version: 1.0
References: <20211117135800.0b7072cd@canb.auug.org.au> <268ae204-efae-3081-a5dd-44fc07d048ba@infradead.org>
 <CAMuHMdUdA6cJkWWKypvn7nGQw+u=gW_oRNWB-=G8g2T3VixJFQ@mail.gmail.com>
 <CANn89iLXQWR_F6v39guPftY=jhs4XHsERifhZPOTjR3zDNkJyg@mail.gmail.com>
 <CAMuHMdXHo5boecN7Y81auC0y=_xWyNXO6tq8+U4AJq-z17F1nw@mail.gmail.com>
 <CANn89iKSZKvySL6+-gk7UGCowRoApJQmvUpYfiKChSSbxr=LYw@mail.gmail.com> <CANn89iLAu9QAgqS_qzZYSHLmmPdL_2uD0RSmtrq4mPgkWzV8hQ@mail.gmail.com>
In-Reply-To: <CANn89iLAu9QAgqS_qzZYSHLmmPdL_2uD0RSmtrq4mPgkWzV8hQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 17 Nov 2021 11:04:03 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUy1ua+KB4XKh89huRg7a5CoNbZNZWbBRmQhzWsYF+FrA@mail.gmail.com>
Message-ID: <CAMuHMdUy1ua+KB4XKh89huRg7a5CoNbZNZWbBRmQhzWsYF+FrA@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 17 (uml, no IPV6)
To:     Eric Dumazet <edumazet@google.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Wed, Nov 17, 2021 at 10:56 AM Eric Dumazet <edumazet@google.com> wrote:
> On Wed, Nov 17, 2021 at 1:50 AM Eric Dumazet <edumazet@google.com> wrote:
> > I don't know, apparently on UM, csum_ipv6_magic() is only found in
> > arch/x86/um/asm/checksum_32.h,
> > no idea why...
> >
>
> Oh, maybe this is the missing part :
>
> diff --git a/include/net/gro.h b/include/net/gro.h
> index d0e7df691a807410049508355230a4523af590a1..9c22a010369cb89f9511d78cc322be56170d7b20
> 100644
> --- a/include/net/gro.h
> +++ b/include/net/gro.h
> @@ -6,6 +6,7 @@
>  #include <linux/indirect_call_wrapper.h>
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>
> +#include <net/ip6_checksum.h>
>  #include <linux/skbuff.h>
>  #include <net/udp.h>

Thanks, that fixes the ARCH=m68k m5272c3_defconfig issue for me.

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
