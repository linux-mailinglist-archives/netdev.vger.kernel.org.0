Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5285F4542D8
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 09:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhKQIrw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Nov 2021 03:47:52 -0500
Received: from mail-ua1-f48.google.com ([209.85.222.48]:41855 "EHLO
        mail-ua1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbhKQIrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 03:47:52 -0500
Received: by mail-ua1-f48.google.com with SMTP id p37so4216439uae.8;
        Wed, 17 Nov 2021 00:44:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PtFuRAKCbQv7OgOp1yQSUJGB5Sn4NN8paohWKNbQv30=;
        b=vPS13aSQNXSQEynlIySsYOBHpE91h2cSHuS5EO/xQ3PZFFbG58yFNGPUk/HHgtbgqe
         rE1EtCvpA26tcDDxLp4gtw1gGfT3hI08psYOmqW6qE5B948UaML9W/2qcn+Nv9Q69CzQ
         Y1gy2jXAyBQtvLfppcIAgGBVK+Ko+jYYhuAih2SnrlEAoDtLjVp16ePmFuO5jVZqHzGE
         mrpwwR5IoeIVgpERDlnnnHPqZMCgUnwhI6C8BPPHL3P5rS7GyFtoijvOw89bKY8SQvwf
         wJpGeYHEOWfMB4nMqEbnEvHJOqYed3BxK8itJocAgkcrgJ3EhjrS60YnZ226dBJPaiZV
         G33w==
X-Gm-Message-State: AOAM532Z57Fwt60gYyZSXeZeYMT9G4YQ+XOj9b320dSumJnNRDAm2Q9q
        LVLw6E1SpPKrcMK0aZL1wSDRpnrkkfnblw==
X-Google-Smtp-Source: ABdhPJzs1R2BHkuKQdVAXcjLlXhSc7xpfFHEqcObzkzqKPaCK8R2f7uewJLTBf4xXRjLsmCTuMfFJQ==
X-Received: by 2002:ab0:6d8c:: with SMTP id m12mr21521550uah.105.1637138693321;
        Wed, 17 Nov 2021 00:44:53 -0800 (PST)
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com. [209.85.222.44])
        by smtp.gmail.com with ESMTPSA id y22sm12052339vsy.33.2021.11.17.00.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 00:44:52 -0800 (PST)
Received: by mail-ua1-f44.google.com with SMTP id t13so4187609uad.9;
        Wed, 17 Nov 2021 00:44:52 -0800 (PST)
X-Received: by 2002:a05:6102:2910:: with SMTP id cz16mr65726189vsb.9.1637138692315;
 Wed, 17 Nov 2021 00:44:52 -0800 (PST)
MIME-Version: 1.0
References: <20211117135800.0b7072cd@canb.auug.org.au> <268ae204-efae-3081-a5dd-44fc07d048ba@infradead.org>
In-Reply-To: <268ae204-efae-3081-a5dd-44fc07d048ba@infradead.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 17 Nov 2021 09:44:41 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUdA6cJkWWKypvn7nGQw+u=gW_oRNWB-=G8g2T3VixJFQ@mail.gmail.com>
Message-ID: <CAMuHMdUdA6cJkWWKypvn7nGQw+u=gW_oRNWB-=G8g2T3VixJFQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Nov 17 (uml, no IPV6)
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy,

On Wed, Nov 17, 2021 at 6:49 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> On 11/16/21 6:58 PM, Stephen Rothwell wrote:
> > Changes since 20211116:
>
> ARCH=um SUBARCH=x86_64:
> # CONFIG_IPV6 is not set

It doesn't always happen with CONFIG_IPV6=n, so I guess that's why
it wasn't detected before.

> In file included from ../net/ethernet/eth.c:62:0:
> ../include/net/gro.h: In function ‘ip6_gro_compute_pseudo’:
> ../include/net/gro.h:413:22: error: implicit declaration of function ‘csum_ipv6_magic’; did you mean ‘csum_tcpudp_magic’? [-Werror=implicit-function-declaration]
>    return ~csum_unfold(csum_ipv6_magic(&iph->saddr, &iph->daddr,
>                        ^~~~~~~~~~~~~~~
>                        csum_tcpudp_magic
>
>
> After I made ip6_gro_compute_pseudo() conditional on CONFIG_IPV6,
> I got this build error:
>
> In file included from ../net/ipv6/tcpv6_offload.c:10:0:
> ../net/ipv6/tcpv6_offload.c: In function ‘tcp6_gro_receive’:
> ../net/ipv6/tcpv6_offload.c:22:11: error: implicit declaration of function ‘ip6_gro_compute_pseudo’; did you mean ‘inet_gro_compute_pseudo’? [-Werror=implicit-function-declaration]
>             ip6_gro_compute_pseudo)) {
>             ^
> ../include/net/gro.h:235:5: note: in definition of macro ‘__skb_gro_checksum_validate’
>       compute_pseudo(skb, proto));  \
>       ^~~~~~~~~~~~~~
> ../net/ipv6/tcpv6_offload.c:21:6: note: in expansion of macro ‘skb_gro_checksum_validate’
>        skb_gro_checksum_validate(skb, IPPROTO_TCP,
>        ^~~~~~~~~~~~~~~~~~~~~~~~~
>
>
>
> This is UML x86_64 defconfig:
>
> $ make ARCH=um SUBARCH=x86_64 defconfig all

noreply@ellerman.id.au reported the same issue for m5272c3_defconfig,
and I've bisected the failure to commit 4721031c3559db8e ("net:
move gro definitions to include/net/gro.h").

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
