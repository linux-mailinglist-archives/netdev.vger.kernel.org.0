Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DCE454428
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhKQJuR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 17 Nov 2021 04:50:17 -0500
Received: from mail-ua1-f50.google.com ([209.85.222.50]:39478 "EHLO
        mail-ua1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbhKQJuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:50:10 -0500
Received: by mail-ua1-f50.google.com with SMTP id i6so4535037uae.6;
        Wed, 17 Nov 2021 01:47:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qXMkSa7k9ktPcVYQslXgieF2A8pEJy/mpadnxUjxBtc=;
        b=qoh++g2zFW/mAnxhIXv90qNflNHZJV5RcEU34FpjfQTDl9MDB50w/sk/VJbJKL2GzQ
         6B2G+w/0Ee6gblYOcBvTPhfjGhCKXzN/M+/mydViYOoctp8HVhGoBhOaEWp2f9Ut1UW9
         U8NktVmWPEt8Y8ZGF/2lVoZI9IjkSWs89P0AGT0QxHf0F1GpV1YXuNMlgrS1G4t7vxP0
         fZ5VeoIPhvk6Pvzz+Rfiiq8737S32JedfYhA8NDyxLnAlIXVNZc/Yj+/WygWcbs2A3Ec
         oD3SoniJPINg3ElOrooP1XQV8U++ir/qoNlIFcgBaSFFJLE8Dw8MXECB3pwqki+XhPl3
         norg==
X-Gm-Message-State: AOAM531CHLRlyy06jIIKPaP16s7vq5D13H9fQqJ04AvkZeY4B6O37b4V
        JcZ3aKuO0Jc+Jid6lbkE5iVp3pJ+JVAsKw==
X-Google-Smtp-Source: ABdhPJyBOmlb+BVCOxdc/T1LfYiuigM2yK/niRdh8sGJVheonsdwUz+3WjtnMUdlH3B4ZvG2SR/E1g==
X-Received: by 2002:a05:6102:38d4:: with SMTP id k20mr67071396vst.42.1637142431727;
        Wed, 17 Nov 2021 01:47:11 -0800 (PST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id r20sm11603951vkq.15.2021.11.17.01.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 01:47:11 -0800 (PST)
Received: by mail-ua1-f52.google.com with SMTP id p2so4468449uad.11;
        Wed, 17 Nov 2021 01:47:11 -0800 (PST)
X-Received: by 2002:a9f:2431:: with SMTP id 46mr21560983uaq.114.1637142430958;
 Wed, 17 Nov 2021 01:47:10 -0800 (PST)
MIME-Version: 1.0
References: <20211117135800.0b7072cd@canb.auug.org.au> <268ae204-efae-3081-a5dd-44fc07d048ba@infradead.org>
 <CAMuHMdUdA6cJkWWKypvn7nGQw+u=gW_oRNWB-=G8g2T3VixJFQ@mail.gmail.com> <CANn89iLXQWR_F6v39guPftY=jhs4XHsERifhZPOTjR3zDNkJyg@mail.gmail.com>
In-Reply-To: <CANn89iLXQWR_F6v39guPftY=jhs4XHsERifhZPOTjR3zDNkJyg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 17 Nov 2021 10:46:59 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXHo5boecN7Y81auC0y=_xWyNXO6tq8+U4AJq-z17F1nw@mail.gmail.com>
Message-ID: <CAMuHMdXHo5boecN7Y81auC0y=_xWyNXO6tq8+U4AJq-z17F1nw@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On Wed, Nov 17, 2021 at 10:38 AM Eric Dumazet <edumazet@google.com> wrote:
> On Wed, Nov 17, 2021 at 12:44 AM Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Wed, Nov 17, 2021 at 6:49 AM Randy Dunlap <rdunlap@infradead.org> wrote:
> > > On 11/16/21 6:58 PM, Stephen Rothwell wrote:
> > > > Changes since 20211116:
> > >
> > > ARCH=um SUBARCH=x86_64:
> > > # CONFIG_IPV6 is not set
> >
> > It doesn't always happen with CONFIG_IPV6=n, so I guess that's why
> > it wasn't detected before.
>
> Thanks for letting me know
>
> I guess the following addition would fix the issue ?
>
> diff --git a/arch/x86/um/asm/checksum_64.h b/arch/x86/um/asm/checksum_64.h
> index 7b6cd1921573c97361b8d486bbba3e8870d53ad6..4f0c15a61925c46b261f87fa319e6aff28f4cfce
> 100644
> --- a/arch/x86/um/asm/checksum_64.h
> +++ b/arch/x86/um/asm/checksum_64.h

Are you sure that's the right fix?
That won't fix the issue with m5272c3_defconfig.

> > > In file included from ../net/ethernet/eth.c:62:0:
> > > ../include/net/gro.h: In function ‘ip6_gro_compute_pseudo’:
> > > ../include/net/gro.h:413:22: error: implicit declaration of function ‘csum_ipv6_magic’; did you mean ‘csum_tcpudp_magic’? [-Werror=implicit-function-declaration]
> > >    return ~csum_unfold(csum_ipv6_magic(&iph->saddr, &iph->daddr,
> > >                        ^~~~~~~~~~~~~~~
> > >                        csum_tcpudp_magic
> > >
> > >
> > > After I made ip6_gro_compute_pseudo() conditional on CONFIG_IPV6,
> > > I got this build error:
> > >
> > > In file included from ../net/ipv6/tcpv6_offload.c:10:0:
> > > ../net/ipv6/tcpv6_offload.c: In function ‘tcp6_gro_receive’:
> > > ../net/ipv6/tcpv6_offload.c:22:11: error: implicit declaration of function ‘ip6_gro_compute_pseudo’; did you mean ‘inet_gro_compute_pseudo’? [-Werror=implicit-function-declaration]
> > >             ip6_gro_compute_pseudo)) {
> > >             ^
> > > ../include/net/gro.h:235:5: note: in definition of macro ‘__skb_gro_checksum_validate’
> > >       compute_pseudo(skb, proto));  \
> > >       ^~~~~~~~~~~~~~
> > > ../net/ipv6/tcpv6_offload.c:21:6: note: in expansion of macro ‘skb_gro_checksum_validate’
> > >        skb_gro_checksum_validate(skb, IPPROTO_TCP,
> > >        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > >
> > >
> > >
> > > This is UML x86_64 defconfig:
> > >
> > > $ make ARCH=um SUBARCH=x86_64 defconfig all
> >
> > noreply@ellerman.id.au reported the same issue for m5272c3_defconfig,
> > and I've bisected the failure to commit 4721031c3559db8e ("net:
> > move gro definitions to include/net/gro.h").

arch/m68k/include/asm/checksum.h defines csum_ipv6_magic()
unconditionally, so it looks like just a missing #include.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
