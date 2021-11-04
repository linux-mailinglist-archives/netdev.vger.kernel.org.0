Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7772A4453D1
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 14:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhKDN3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 09:29:39 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:40271 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhKDN3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 09:29:38 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M2OEq-1mlMKL0etS-003uxX; Thu, 04 Nov 2021 14:26:59 +0100
Received: by mail-wm1-f43.google.com with SMTP id y84-20020a1c7d57000000b00330cb84834fso7225984wmc.2;
        Thu, 04 Nov 2021 06:26:59 -0700 (PDT)
X-Gm-Message-State: AOAM531S8UMj/QIjG5DNthK+75OVEz5x6DYM5tVys2ecMbP7e9Ps8yYb
        gclSkymV/68dZu1IFC24OYlx6DhNVT4+HxJJ7Lc=
X-Google-Smtp-Source: ABdhPJxdQh+Brd6emLJv5QQ1PelvFFMegvh2Lb/ivrjscxVDEXD2VVdkHJaSSH8WGm7Oyijr4iW3Xiz6VCfOFWOEO6Y=
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr23241643wmb.1.1636032418775;
 Thu, 04 Nov 2021 06:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <1636031398-19867-1-git-send-email-volodymyr.mytnyk@plvision.eu>
In-Reply-To: <1636031398-19867-1-git-send-email-volodymyr.mytnyk@plvision.eu>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 4 Nov 2021 14:26:42 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2nbEFGPRWKwjLYOz3wROLOk1SN-6Wd7-sNkaEuuid==w@mail.gmail.com>
Message-ID: <CAK8P3a2nbEFGPRWKwjLYOz3wROLOk1SN-6Wd7-sNkaEuuid==w@mail.gmail.com>
Subject: Re: [PATCH net v3] net: marvell: prestera: fix hw structure laid out
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     Networking <netdev@vger.kernel.org>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ALzVC8qeXDGCFhnyaNtPDzmMVsNNkPthF3/B56pSDpkdWMyF+Nw
 zyD88feP0gYv4cXPx/48Iwmok4E+ztJEoTd5DjKp5KlgJWFTPshIlPuT7gWjJzzcRfTnAYb
 kZZoQW0KBUdATjf7/5zd5EOaIOiN82/8q31KV04FMIm+Zy2hkHCvnB3aP3pod1O+sPOAyKw
 A8XWkHGZKTyYdc1bQzCkQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aHlr+uROJ7E=:94QhiYJMjx8NMxDQJG1GP6
 L4qPuCKzY4v3ZwPLRjRCHsyemx9mjgeVbheQCD5filxj3ekUhPilHu0BFfhxVIkYufcdHaEK+
 Oza6Z7HlMl3q3MRw48GmHNhiDFONMyPHcVRc5EYb+7emSyFjWhoqOJ4Het6kMzLGKMlzb39YP
 Lgso145wJntzLnH+ots1aMgpkkHNhuRbBxybRBMpWiCrSEFSVvjTBwTwIAVh50ktPdY2T7UIx
 K27hWaPNNE6NjgWTC+BhE55etjAQlhPzh1+nPnJVei1ANsbdqiBM9O3zJK0j1JXo2fc67o2Pf
 V9mEMPMXjF0a/d8BvY4AS7E3k0uNtli/9UIyW7eysWXkdEG1J79Rcn/q1TCW85OqbrtWSJdSw
 iCK1ufUAvK2BKmseCUL4gv5PksFd0X10bnxBC4enYEt83fuZ3ea7mrRmOyBZuRgRNMkd47NfL
 qUeDII7Nf2QwcWcKFlqeQYhGJCEwaLkV1sQ6pVJUiOluPYFSxWHB/nK87snZnxsEjXyFHLXEe
 anMrZv6DXfVvwSv+EfF3Begljls/NXpqMXgdrgEjpGGv3goYwGFgZU5DHoRngE+bizquLGZrK
 RDvLeQh1MlFcdto4nNAUI3532mH5fF82yI8+xDPNaxEoxjToFGwXhUwBs0cs5hvkDm6o7tx/Z
 gbwnRM6W9y+yst8Rk5rAYoCbxqj4AE0Ig0eKV+4vZdn9wmT4RA3q85PHknopQ660Z5FQWHMxp
 7HmULd5kOwGxDAHez9fQsZCLEik9zVMoMfTUO6aMUWhjB2TZyw1FtBdCOF5tNeLlTc529lfLz
 VXcu6h3kdHFl8VT3j+qIJiytoQQZpMbB50ghgn4uy2Q4aHowyY=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 4, 2021 at 2:09 PM Volodymyr Mytnyk
<volodymyr.mytnyk@plvision.eu> wrote:
>
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
>
> The prestera FW v4.0 support commit has been merged
> accidentally w/o review comments addressed and waiting
> for the final patch set to be uploaded. So, fix the remaining
> comments related to structure laid out and build issues.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support")
> Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>

I saw this warning today on net-next:

drivers/net/ethernet/marvell/prestera/prestera_hw.c:285:1: error:
alignment 1 of 'union prestera_msg_port_param' is less than 4
[-Werror=packed-not-aligned]

and this is addressed by your patch.

However, there is still this structure that lacks explicit padding:

struct prestera_msg_acl_match {
        __le32 type;
        /* there is a four-byte hole on most architectures, but not on
x86-32 or m68k */
        union {
                struct {
                        u8 key;
                        u8 mask;
                } __packed u8;
/* The __packed here makes no sense since this one is aligned but the
other ones are not */
                struct {
                        __le16 key;
                        __le16 mask;
                } u16;
                struct {
                        __le32 key;
                        __le32 mask;
                } u32;
                struct {
                        __le64 key;
                        __le64 mask;
                } u64;
                struct {
                        u8 key[ETH_ALEN];
                        u8 mask[ETH_ALEN];
                } mac;
        } keymask;
};

and a minor issue in

struct prestera_msg_event_port_param {
        union {
                struct {
                        __le32 mode;
                        __le32 speed;
                        u8 oper;
                        u8 duplex;
                        u8 fc;
                        u8 fec;
                } mac;
                struct {
                        __le64 lmode_bmap;
                        u8 mdix;
                        u8 fc;
                        u8 __pad[2];
                } __packed phy;
        } __packed;
} __packed;

There is no need to make the outer aggregates __packed, I would
mark only the innermost ones here: mode, speed and lmode_bmap.
Same for prestera_msg_port_cap_param and prestera_msg_port_param.


It would be best to add some comments next to the __packed
attributes to explain exactly which members are misaligned
and why. I see that most of the packed structures are included in
union prestera_msg_port_param, which makes that packed
as well, however nothing that uses this union puts it on a misaligned
address, so I don't see what the purpose is.

       Arnd
