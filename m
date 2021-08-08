Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6503E3CDA
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 23:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhHHVKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 17:10:02 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:42177 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhHHVKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 17:10:02 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Ma1HG-1mZvNZ1Wvk-00Vwox; Sun, 08 Aug 2021 23:09:41 +0200
Received: by mail-wr1-f48.google.com with SMTP id b11so2536115wrx.6;
        Sun, 08 Aug 2021 14:09:41 -0700 (PDT)
X-Gm-Message-State: AOAM530eNSPBmMZm6PhOlp3gxnIjtMFbXGKSL78k8JlXzwgJp6sjrOeE
        /MBksqugIuFOr4RlAT5AeMDHr3vpvsWjmP4uMOc=
X-Google-Smtp-Source: ABdhPJybbFYwPOSl9WSB6Pw1W7XUWtRLqh2VSbwy4zR6de8Y7+DcIn+8hflJ283ShEuBwpbjDfEc2ChGjSCbDgJK01o=
X-Received: by 2002:adf:f446:: with SMTP id f6mr22293490wrp.361.1628456980852;
 Sun, 08 Aug 2021 14:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210807145619.832-1-caihuoqing@baidu.com> <05a5ddb5-1c51-8679-60a3-a74e0688b72d@gmail.com>
 <CAK8P3a0FUGbwbWuu0R7-Bm4O0MgNfYmE4FTZY9oE9jnRcMK9xQ@mail.gmail.com> <bd0a1112-af59-16be-3fd3-b0a6aa1f2773@gmail.com>
In-Reply-To: <bd0a1112-af59-16be-3fd3-b0a6aa1f2773@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 8 Aug 2021 23:09:24 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1Ea_6cHKCM3CeDayXsrZPmeiKF-SF3=U-dAadZiMkU7g@mail.gmail.com>
Message-ID: <CAK8P3a1Ea_6cHKCM3CeDayXsrZPmeiKF-SF3=U-dAadZiMkU7g@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: ethernet: Remove the 8390 network drivers
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Cai Huoqing <caihuoqing@baidu.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:gWqbxSGJP4fT9d7Cl9BE14b1I6AY70S0Ecdmi0EMUBNaBYgiUsu
 ew8gvwMQmGiJIspFi5/JabY13hPlwkSCPgJjalMoD/bQF5AqJhif07HTEIShk0ou1ygwHpR
 YCkyzWfwfam+htHGAyChmNJ7SuNodoAGgVfzOmE8tPPRUXsGx+oWNiEUgRGYfhwWYfPT9bA
 Ckv5JejcOSJZTS9eb8T8Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:U9yBVhXJwM0=:bGqJNiGTIaEs6UxR3hux9A
 nf4R1ArwMryOQj/Z5taRNcy5jP4RYk0o7zlpaF66nSAj8qtkW5fXcA+6r92U8xYHVRkPZkjEO
 ZUnlfFd5KFMmBX1cleg6756jW8WWQhcCBUeYIgsNujA1Wqfy5ZMAnQLSgVvA8IWPxRCq6Hpxy
 Mv0eBaULQTUjOrXpgTUJuu/BwU/gudQqDBODU16QNF7VqebxDJyCKjQ4+ZRgBHWzaeAmeO1Fh
 UnKgDRGiQx1TkvsEoDo2QlB9MWaFWw8sdpNGnL8OYBli4QenLrBPyyU6wIvnRZbUUWAvST9ok
 iSV1MhkVWt87PQllR/mrhsykM/3TsvwFz6iogDmk7GNpoB8lBl6E6GUrKSu9f7vFH75drZQgY
 XYKMccngxDA0lXotMVUnbnkFv4HVnCF7MpdQa9ZuVXwnBZwaG14RodVbUcAOrXlXyObPduwPm
 Aa+KvUe4WvA32kCAZdtCc7e1CNY+Tjs/4SaJpKwUisuFoD+3vaHcoG6MMKiVBt0ZLiwc6KQEf
 MmOWaeCGvQW+VoaNCHHXZv0XOOamOApIvkOw3rECFqH2AKlbBDWqxa++NPabdMaFjqPr9bMDY
 PfXYk/RRB0RpZKHRv3AOc10k5CAV+Eg4rEiKJ/8MSb4Z7C+fZVwCElZ2lJOM9kmCkU9uiTB2y
 y7KINKyIiWAxSljBl7Lj0HCiqobLr97cNYsnujC5TSQKlBaUVaHgneXyBGfbBW/Qlyx3OljQ7
 7JySAkcdRp7MlN761mUy4X+T/qUqUsCt/c1W1vz+Wb+cqTxUq1Fn6SS/l0DZ3QRR2TJwl7Y6l
 tcWuO8CAyOQ7R9GTWf8WquysttdUEqoaSr1JOLFsghh42l8mhOU5ziO7GiC1HfiPYP1+qgF
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 8, 2021 at 10:39 PM Michael Schmitz <schmitzmic@gmail.com> wrote:
> > Two candidates I can see for removing would be smc-ultra and
> > wd80x3, both of them fairly rare ISA cards. The only other
> > ISA 8390 variant is the ne2000 driver (ne.c), which is probably
> > the most common ISA card overall, and I'd suggest leaving
> > that in place for as long as we support CONFIG_ISA.
>
> That particular driver is the one I rely on (via a weird ROM-port to ISA
> bridge). Would be useful even after ISA bus support is gone, in that
> case. Just saying. The Amiga and Mac drivers likewise. Though you may
> well argue that once ISA support has been removed, these can all be
> rewritten to support MMIO more directly (and more flexibly).

I don't think we are anywhere near removing ISA support (probably
not before removing EISA, which in turn is required for some platforms),
but that was what I implied: No point removing NE2000 support as long as
there are platforms or bus types using that driver (Q40, Atari, TX49xx),
and even the ISA version of NE2000 may outlive other CONFIG_ISA
itself because it is a typical emulation target.

> > There are a couple of other ISA-only network drivers (localtalk,
> > arcnet,  ethernet/amd) that may be candidates for removal,
> > or perhaps some PCMCIA ones.
>
> ethernet/amd has the other set of network card drivers used on m68k
> (*lance).

Same here, I specifically mean the drivers that are /only/ used for ISA
here: CONFIG_LANCE and CONFIG_NI65, not the various other lance
variants.

       Arnd
