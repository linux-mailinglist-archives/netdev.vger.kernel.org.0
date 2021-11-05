Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA32446767
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 17:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbhKEQ7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 12:59:01 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49055 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233696AbhKEQ7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 12:59:00 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MLyzP-1n0IPi2EGv-00HzgQ; Fri, 05 Nov 2021 17:56:19 +0100
Received: by mail-wm1-f47.google.com with SMTP id c71-20020a1c9a4a000000b0032cdcc8cbafso6864625wme.3;
        Fri, 05 Nov 2021 09:56:19 -0700 (PDT)
X-Gm-Message-State: AOAM5319JCfb4P8VkkKMswy7LLSqENZ5/ldZ/YtndskEazxlPcOrxWGb
        YKXi7B1eBMEojmLQ3YStQAEvMpSHhVfsskPhrA8=
X-Google-Smtp-Source: ABdhPJzCWcqBQFAOtdy87/up3hDxesJBAui20qESnFtHDp6+RJ5ZUn1yaNIx0LWLlxACnyLPS+0+MxDyFNStk332/U4=
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr31696130wmb.1.1636131379131;
 Fri, 05 Nov 2021 09:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <1636031398-19867-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <CAK8P3a2nbEFGPRWKwjLYOz3wROLOk1SN-6Wd7-sNkaEuuid==w@mail.gmail.com> <SJ0PR18MB400959CE08EC6BFB397CAAB3B28D9@SJ0PR18MB4009.namprd18.prod.outlook.com>
In-Reply-To: <SJ0PR18MB400959CE08EC6BFB397CAAB3B28D9@SJ0PR18MB4009.namprd18.prod.outlook.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 5 Nov 2021 17:56:03 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2zsuxZvt3ajzw4u6vpoDbei5xETiB-oCzx5FD4cq=oVQ@mail.gmail.com>
Message-ID: <CAK8P3a2zsuxZvt3ajzw4u6vpoDbei5xETiB-oCzx5FD4cq=oVQ@mail.gmail.com>
Subject: Re: [PATCH net v3] net: marvell: prestera: fix hw structure laid out
To:     "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Networking <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Denis Kirjanov <dkirjanov@suse.de>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:BMDUplX6zSp/RXl9H0Byv+lBATiOD+qjYj5165qj18rJrLYvHFC
 c3NiRKl43rTH8+baG2LUzJKzoafCxcN7QdShVto9m7MYHsB/kOyNCFen9N2qI2tw7yfCXO+
 ni2/EjYW7rTdZI5E9H8JWOcK/6GUY7bQCb2vX/uPg6cgbvib1LzYgFHx1S5nLXEZSnwxK07
 k+ryvd5mUCwmsxb9iKG5Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:I43aGbWE+m0=:GuxhiSs19Z0+QfB9k9dfpL
 UOJ9bVlRIkafqa2tgxeioqOozCUzO2mehf7RhqlEygx5FfkR8Cnc963Iz19BpK28R9RvUhhnb
 5lI6m0x+8bM8bfGnlvSuwABEQGAbpuCdYgRhxfwpqNje707QbwWJrcpVtM1TOcL6HZ3pe3Y3m
 L04+/8RsRpONmSOgCs7liZMK6EWx/yqJhwcNadQQq46NXyOl5E9rBes7YQu611dNkISx147oO
 RhJYqrVKfQ82fpLyf46xdBpUEXkwQ+kSRD2+MzRC8cEEHJhSOZwxzs6xvtyg4rRc0mq2R23ol
 VXCS8x+A3jEow6SPYfauVpMEE1hOhFg3JqXy1utLyVvljQ+89Pqk9hgr/FtoxNMRqfQJG2K8w
 JWSgJy+9gRADgFtHJ8h++S9B/QQiPXTOnFB13Mj/su/voyWHnAVQMasncFm47qtrgUReUt3gp
 FEOHOImHC8leoP0VWeWpRc/V+WZqf1wAPLXmTohnsAFv7FYGm177nimT72f8l4bpXjiTSwHv6
 loBRXqCaCkd8vP5lt4Ekr3jM7BtSS11aLgkuei769MxguRQWDAafDTSLayansCd2n6nSn6iGm
 ZOYrHc98ynqvk3h1Zfdln70OfRljVy34knrdheB7s4VjXW+qE1BmTXGT2WbvSdvOZOCLmXSTn
 qrA3i8vM/gu64IoSbSiYA5Cy9IP2Axwg7LTEnsvaLnIAnUtYmZlYMgB3BgvLgGWzoUJDktGHC
 8x3mgOqQHFEdD8LtEOE+cf1ZxpysczKx9AfiJdk0/S+rw80vR1sPP+YFPg9+72JPI9Pdp3g0u
 mGm2BKEuVNNNA9Vwhz50l8qHRpiD8WIuyWXIFyVO4WZhKtD8l4=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 5, 2021 at 5:33 PM Volodymyr Mytnyk [C] <vmytnyk@marvell.com> wrote:
> >
> > However, there is still this structure that lacks explicit padding:
> >
> > struct prestera_msg_acl_match {
> >         __le32 type;
> >         /* there is a four-byte hole on most architectures, but not on
> > x86-32 or m68k */
>
> Checked holes on x86_64 with pahole, and there is no holes. Maybe on some
> other there will be. Will add 4byte member here to make sure. Thx.

That is very strange, as the union has an __le64 member that should be
64-bit aligned on x86_64.
> >
> > struct prestera_msg_event_port_param {
> >         union {
> >                 struct {
> >                         __le32 mode;
> >                         __le32 speed;
> >                         u8 oper;
> >                         u8 duplex;
> >                         u8 fc;
> >                         u8 fec;
> >                 } mac;
> >                 struct {
> >                         __le64 lmode_bmap;
> >                         u8 mdix;
> >                         u8 fc;
> >                         u8 __pad[2];
> >                 } __packed phy;
> >         } __packed;
> > } __packed;
> >
> > There is no need to make the outer aggregates __packed, I would
> > mark only the innermost ones here: mode, speed and lmode_bmap.
> > Same for prestera_msg_port_cap_param and prestera_msg_port_param.
> >
>
> Will add __packed only to innermost ones. Looks like only phy is required to have __packed.

I think you need it on both lmode_bmap and mode/speed
to get a completely unaligned structure. If you mark phy as __packed,
that will implicitly mark lmode_bmap as packed but leave the
four-byte alignment on mode and speed, so the entire structure
is still four-byte aligned.

       Arnd
