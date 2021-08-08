Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002683E3C91
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 21:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhHHTuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 15:50:18 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55903 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhHHTuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 15:50:18 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M1YpJ-1mFqwg33XP-0032eP; Sun, 08 Aug 2021 21:49:57 +0200
Received: by mail-wr1-f45.google.com with SMTP id h14so18487932wrx.10;
        Sun, 08 Aug 2021 12:49:57 -0700 (PDT)
X-Gm-Message-State: AOAM533VY0EoxiS5viLf6vEpQPJMm9LtNZkRZCi3vucPr9gose2yVK00
        QhL4QyteF1MuyA/PY5K4hmQ5CANHjwjQj2SFr54=
X-Google-Smtp-Source: ABdhPJx6F59rJO1Pery+r6nQDO2xzNpLN7m093anVuScAsNwhXhrgKEl7Ac/J+6VQWafXCkrAPzeB/ANsqaDe3eG/qA=
X-Received: by 2002:a5d:44c7:: with SMTP id z7mr21960891wrr.286.1628452197374;
 Sun, 08 Aug 2021 12:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210807145619.832-1-caihuoqing@baidu.com> <05a5ddb5-1c51-8679-60a3-a74e0688b72d@gmail.com>
In-Reply-To: <05a5ddb5-1c51-8679-60a3-a74e0688b72d@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 8 Aug 2021 21:49:41 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0FUGbwbWuu0R7-Bm4O0MgNfYmE4FTZY9oE9jnRcMK9xQ@mail.gmail.com>
Message-ID: <CAK8P3a0FUGbwbWuu0R7-Bm4O0MgNfYmE4FTZY9oE9jnRcMK9xQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: ethernet: Remove the 8390 network drivers
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Cai Huoqing <caihuoqing@baidu.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:WiU2XRJbHqPgT+V+BhYVDVaiH5BTOP6MKVg/3erGqMb9XmuB/ED
 avNh6N6w5v8gvEggMBsAk8d9lR1VXP856rjuQoRlSD+kDYGwJ4eqYgozv8zBjoWZhVWUWZN
 ZHwhI4VtSZuzhUP8OIEIr3vMSWxNrpfFTs9T3Vy/DvyqIfpkDd7HK4aa/PFebT0GvhO23lg
 xzbHV4YBiUuYHNVr1eBYw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:AGINesSpU3c=:tLx8Yi5ke9gfsO+evGbdj/
 4iGBX7TBGIicU8m/2zz+vNKxOdDrXX0wmA+nPrH5toDFlxYk42B7KwNU0jrzWs3Opap6QeaRR
 QjXXkYdeSsz54+7e+v9qwiNJ/fbTaKDIi3BNPkAQRutZE5XEqQW1cfr6+dulFklmXhrk0RibA
 WkFEMbyOaSDCQlkUi4kd9cBVsN59udylfUezj4o+7dWn6I1hgbxKLDFO9TwfbNHwxpjpsQsKd
 KGMZ2GVhAGP7qS4GCwgKZLmyrgoVg7Ak468XjtrIS9Ff1JjGDg/3r4aNOx0Ss6JdZh4Xx2dx3
 PpQT1HQmNMUOL1e+HkglvA4yttDcjNQJMjePnF8/YwY3RiPp1IDWHzUpqcIl7NDECNN0nAK3H
 UgViL2uXXcA6Ql2yRJ1MBgeT39mYxcSp2Af+K0llzwrnB4qKXqNCnaPLayiUmoaJnWcvuGwEN
 v/7k/z/nYrJUm0MC5zBWk2qzA/rF7azM4+oCUsKrKIHdlpo4XVXQx1KkTdUfabYc1G0uGMBLo
 GPfafZxXImp4qfMVJfldzZ1HpTYmfs4IwdK9sPJMfMTw8+GiIVCziip13U8YaET6nD/d93w6c
 B2yL3jby8yD3YlkeLTuMG4ijggX6iVh8AsZmWD4j1dXlwcXWXVF28DRssHCZI+lrFRmA9m79Z
 eAQuAcHb0YHGwXeYKXlRZpBuoH7ZIFyHJhC7Z33w2f93Et7QG+zwq7TdpozHXn7sUaNpvYqTT
 Cs7XzxvyG8OJDEmHw6huH6ozLodwWUmQW+V+nX7EYhR8vUqoToUtYvJDYCa+6TQnMjDEvEUxj
 YlL70zvESzFfQRF8flGiuo7bppaZ8ntSZjzI1blzsJ82iL8lbfeByGTxAPOrohbIPU3TTLC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 8, 2021 at 12:51 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>
> Removing the 8390 drivers would leave most m68k legacy systems without
> networking support.
>
> Unless there is a clear and compelling reason to do so, these drivers
> should not be removed.

Right, any driver that is tied to a particular machine should generally
be left working as long as we support that machine.

> >  MAINTAINERS                           |    6 -
> >  drivers/net/ethernet/8390/8390.c      |  103 --
> >  drivers/net/ethernet/8390/8390.h      |  236 ----
> >  drivers/net/ethernet/8390/8390p.c     |  105 --
> >  drivers/net/ethernet/8390/Kconfig     |  212 ---
> >  drivers/net/ethernet/8390/Makefile    |   20 -
> >  drivers/net/ethernet/8390/apne.c      |  619 ---------
> >  drivers/net/ethernet/8390/ax88796.c   | 1022 ---------------
> >  drivers/net/ethernet/8390/axnet_cs.c  | 1707 ------------------------
> >  drivers/net/ethernet/8390/etherh.c    |  856 -------------
> >  drivers/net/ethernet/8390/hydra.c     |  273 ----
> >  drivers/net/ethernet/8390/lib8390.c   | 1092 ----------------
> >  drivers/net/ethernet/8390/mac8390.c   |  848 ------------
> >  drivers/net/ethernet/8390/mcf8390.c   |  475 -------
> >  drivers/net/ethernet/8390/ne.c        | 1004 ---------------
> >  drivers/net/ethernet/8390/ne2k-pci.c  |  747 -----------
> >  drivers/net/ethernet/8390/pcnet_cs.c  | 1708 -------------------------
> >  drivers/net/ethernet/8390/smc-ultra.c |  629 ---------
> >  drivers/net/ethernet/8390/stnic.c     |  303 -----
> >  drivers/net/ethernet/8390/wd.c        |  574 ---------
> >  drivers/net/ethernet/8390/xsurf100.c  |  377 ------
> >  drivers/net/ethernet/8390/zorro8390.c |  452 -------

Two candidates I can see for removing would be smc-ultra and
wd80x3, both of them fairly rare ISA cards. The only other
ISA 8390 variant is the ne2000 driver (ne.c), which is probably
the most common ISA card overall, and I'd suggest leaving
that in place for as long as we support CONFIG_ISA.

There are a couple of other ISA-only network drivers (localtalk,
arcnet,  ethernet/amd) that may be candidates for removal,
or perhaps some PCMCIA ones.

      Arnd
