Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8487849BFCD
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 01:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbiAZAAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 19:00:12 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:49473 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235042AbiAZAAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 19:00:07 -0500
Received: from mail-oi1-f182.google.com ([209.85.167.182]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MNLVU-1mtKzX0Tj0-00OrzA for <netdev@vger.kernel.org>; Wed, 26 Jan 2022
 01:00:05 +0100
Received: by mail-oi1-f182.google.com with SMTP id s9so34311386oib.11
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 16:00:04 -0800 (PST)
X-Gm-Message-State: AOAM532C8qiUREweXQvdbuLivyzVXwiChLlakF4BKKBOerF+ZD0gdvuY
        GLstdg0WtxXfr5hnX8w+3nxuOrCP6cNzTrCd9YQ=
X-Google-Smtp-Source: ABdhPJyRiFbU7WpY5PYwFlC4e0o1Sjytb+06EbYgROlOu5Wx61ygx/Duq3ts7xmUc/sNOf6HZJo2jz4PsLN+bFBJDcc=
X-Received: by 2002:a05:6808:1a26:: with SMTP id bk38mr2254732oib.291.1643155203825;
 Tue, 25 Jan 2022 16:00:03 -0800 (PST)
MIME-Version: 1.0
References: <20220125222317.1307561-1-kuba@kernel.org> <20220125142818.16fe1e11@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220125142818.16fe1e11@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 26 Jan 2022 00:59:47 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2NOr2tGLkf-4uBx4t6zqqZsobY-79nqaeQ-pUC2h5Kvg@mail.gmail.com>
Message-ID: <CAK8P3a2NOr2tGLkf-4uBx4t6zqqZsobY-79nqaeQ-pUC2h5Kvg@mail.gmail.com>
Subject: Re: [PATCH net 0/3] ethernet: fix some esoteric drivers after
 netdev->dev_addr constification
To:     Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, dave@thedillows.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:FA8r3v0IEZ+YbERn8KHkUk2LmMyA9Rc+yidicclc4wycX4R/EUe
 XjlbU2of4wqmdZvN2MVuNNh8Ih9eh+yWQJrm1vH5XOkS8Lze+cYbFBjKRpdT4cl4ZGzIUJk
 UKKT62v2NxwOtEm3Bm7tdXjgzNiUmH7pRLDhYCLMHPoUd7j0sLOR9kE99PXmyUjlGYCkMAq
 2c8JfTKTzI4FH8qmYOYHQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+aPFbYejDLQ=:3/jp4NW8PvpK6/kM38VI5u
 8unBo9BlKj620OgbSxwkAGI4Oq4ygN1a7VwqfLvJWzEYahtkq48raZK8VrSYoA+rLByeHN121
 5y+c0mRGbeaugEDjvaf1X5Ok8whyQuQ63orV1SdbpkhFVJy9rn5M+dF7KuA8bBPUWxXGvNqRF
 wlsxOGErdkAKNQdtqEvca3fFzUJ17dHYKJ+79F2vhp6swmUNpIx7Zyzt+x1hWsoBgI4Bp7GzM
 BGyu+MEPwC8gzlg6qAbgQCUB/3it2e9WkWV+UYX4bnMXufherq/VPheVBThfl/dUzOIZ4VCUM
 Oz/Cd1cslhW3h6z9+ppS2hU6hXOILXdE8vI9s7enPnv8Hyx7lGEhWyHus3Y/d2NG41w+p2k9v
 N1NcUkzp7ptxfnf7nNSxKaYPn2B+Ac7J/y+lbKOzDl39FIUwULYNdKJk0dGtG7NAR21gmKLkg
 zjohwKuXvjtGWN7IsyEOSCjQ0k/ZvgqLkYQHt7klOa1UtJDkg1aC3Vpy28Fh3VjYBnkfs6wSu
 FPF6u9+jE606bDgyWFvjxS2Ww9KNAHlUBb4bvqHdYydKJm55jqtZy2G01S6W+yWoOo1ERDIpb
 8WB8NJZubCze4shcSVayTjBL1OB/4e8wHqKQrCvn5T1tL98AKHGZ/DIL4FEGcErVPx3NcKven
 WtPz/38mF7j+GlZVt8bXP0YLo7pYN2vLd+ZKlxGzCAckfCxVSdp8bUn1On+LeRGF8yUY=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 11:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 25 Jan 2022 14:23:14 -0800 Jakub Kicinski wrote:
> > Looking at recent fixes for drivers which don't get included with
> > allmodconfig builds I thought it's worth grepping for more instances of:
> >
> >   dev->dev_addr\[.*\] =
> >
> > This set contains the fixes.
>
> Hi Arnd, there's another case in drivers/net/ethernet/i825xx/ether1.c
> which will be broken in 5.17, it looks like only RiscPC includes that.
> But when I do:
>
> make ARCH=arm CROSS_COMPILE=$cross/arm-linux-gnueabi/bin/arm-linux-gnueabi- O=build_tmp/ rpc_defconfig
>
> The resulting config is not for ARCH_RPC:
>
> $ grep ARM_ETHER1 build_tmp/.config
> $ grep RPC build_tmp/.config
> # CONFIG_AF_RXRPC is not set
> CONFIG_SUNRPC=y
> # CONFIG_SUNRPC_DEBUG is not set
> CONFIG_XZ_DEC_POWERPC=y
> $ grep ACORN build_tmp/.config
> # CONFIG_ACORN_PARTITION is not set
> CONFIG_FONT_ACORN_8x8=y
>
> Is there an extra smidgen of magic I need to produce a working config
> here?  Is RPC dead and can we send it off to Valhalla?

Support for ARMv3 was removed in gcc-9, so there is a Kconfig
dependency on the compiler version to prevent broken builds.
You can use the gcc-8 builds from kernel.org[1].

Russell still uses this machine with an older compiler though, and
I guess he will keep using newer kernels for as long as gcc-8 can
build them.

No idea which ethernet card he uses, there are at least three of them.

      Arnd

[1] https://mirrors.edge.kernel.org/pub/tools/crosstool/files/bin/x86_64/8.5.0/x86_64-gcc-8.5.0-nolibc-arm-linux-gnueabi.tar.gz
