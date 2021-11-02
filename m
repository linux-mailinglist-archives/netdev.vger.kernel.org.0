Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BDA4429CE
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 09:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhKBIuX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 2 Nov 2021 04:50:23 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:52797 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhKBIuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 04:50:20 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MQ5aw-1n3k3M3NKq-00M6Oc; Tue, 02 Nov 2021 09:47:44 +0100
Received: by mail-wm1-f45.google.com with SMTP id a20-20020a1c7f14000000b003231d13ee3cso1181160wmd.3;
        Tue, 02 Nov 2021 01:47:44 -0700 (PDT)
X-Gm-Message-State: AOAM533fwbGRJeIemslMRctrj4k57+Gjc12VLllsYWWTDQbchJZLqhuC
        4PVVBaRvcgz9+tRS+6zs075tjcUjGm/QZDCY/0s=
X-Google-Smtp-Source: ABdhPJzG2mAqX/mExGmNm60sI0zUTReCAFteVk+GDIP1zce6bXOh0QlwiX7xjXCdOBcqbmNVUxC/EBfPeuWHsfXoO20=
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr5330698wmb.1.1635842864461;
 Tue, 02 Nov 2021 01:47:44 -0700 (PDT)
MIME-Version: 1.0
References: <20211102082433.3820514-1-geert@linux-m68k.org>
In-Reply-To: <20211102082433.3820514-1-geert@linux-m68k.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 2 Nov 2021 09:47:28 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1x0dU=x=mnBC8JeDG=dsQNfyO7X=16jm0WUwQ8wwLp=w@mail.gmail.com>
Message-ID: <CAK8P3a1x0dU=x=mnBC8JeDG=dsQNfyO7X=16jm0WUwQ8wwLp=w@mail.gmail.com>
Subject: Re: [PATCH] [-next] net: marvell: prestera: Add explicit padding
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Taras Chornyi <tchornyi@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Vadym Kochan <vkochan@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V03:K1:IPsfqvMUvS4ytL4S+TzUv7S87ywKE1eZFsJIKwtDMdoP3b2BiAJ
 wpUvl1URq9LcG1OCPNHGnA7YnF0MKXlLqnvT1Zv9SR1WgXTqhQEUhCVy4Y8uaLQMdp0GiOE
 Jjt2lFuZ9aRMLa4gZGfIy5xDHD38LuV/1BKY7zRTQ0zopywY3QtLCQ1HNG/IO9jeJDvEO2n
 AGB50YgdIPTU8ro/9znSg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:zqZz4GHb8QA=:GdMZoHGGQdVrU56UZAExi/
 uHerS7LViHvJQNToRj9KWg/Zyoo/xOqcgPZaN7q1Bff3Zd85RjZWkHBROwsV2l8OSf1YMCQPY
 ZoLZ++ATbveb5E+wDO1/7vnHAfG5AnkGKy3GieMdxY5wImjvYk//vOP5dQ+Wj2AmvMs9B7D2q
 7NPtReHo5P+rEUGkZENm3knrSlMb78jrOCoWiB+UmX7ecM5J9MUcxeqtWYFCv8/H7rOyTyWUA
 P02XH92ZOusJZpvqnG+jVhP3wxDBzcNTsTa2AOAC9vfQ3ByQRLEMsp3NqgaZN8ZcaSxd763XE
 CUW3rgYuW3RkR+skrM4vom00XgpOUVtkrgvQE4uiEtqSTQn3QpmVCsHg0wkVG8sjkrLHVZ4lo
 XbYujC0fdUgPEn2Y1XS4pDEel1gDsxdG+Lh1ewxniJXps/t1no6QGpRTxx+pZ1OJR+voFdJxo
 j41v1zA9/5O6tH+MaQeXXd747gMG+n69yRhBQkKh5eateJ974ZOOpoZ2Ye8bvT1xmHXdYlmiv
 pG75K2eErsnsDUS7DDbODvMa2let+1FRkcSolw0CTYebNj583kl6eVRDbBdF+Pg10VyydQFG1
 A550tEXbQC+v+O04fP6NuKcZKFxToSTm/AKzguLjW181Tc1OGckOuqT3WbdLDeCe2Uk4DAySJ
 3B9a0vLlHyOKHJ7Xif9zmwyDme9PWxzJHN1IaTe+rmsNevjIii4mtLjL6RpY5o3mYrd8C2tmu
 sQLme8PEMjoGbuhexVke9LvlKHpVxLGx8ua9oBmHiexJTlv4nErUD6+MOQZ2t1Qm1z+xij27u
 E/YamGIO7Cme/gFHuyyusjS19pPCOCiW887m8iB/diYQ6mdoXU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 2, 2021 at 9:24 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> On m68k:
>
>     In function ‘prestera_hw_build_tests’,
>         inlined from ‘prestera_hw_switch_init’ at drivers/net/ethernet/marvell/prestera/prestera_hw.c:788:2:
>     ././include/linux/compiler_types.h:335:38: error: call to ‘__compiletime_assert_345’ declared with attribute error: BUILD_BUG_ON failed: sizeof(struct prestera_msg_switch_attr_req) != 16
>     ...
>
> The driver assumes structure members are naturally aligned, but does not
> add explicit padding, thus breaking architectures where integral values
> are not always naturally aligned (e.g. on m68k, __alignof(int) is 2, not
> 4).
>
> Fixes: bb5dbf2cc64d5cfa ("net: marvell: prestera: add firmware v4.0 support")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Looks good to me,

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

> Compile-tested only.
>
> BTW, I sincerely doubt the use of __packed on structs like:
>
>     union prestera_msg_switch_param {
>             u8 mac[ETH_ALEN];
>             __le32 ageing_timeout_ms;
>     } __packed;
>
> This struct is only used as a member in another struct, where it is
> be naturally aligned anyway.

Agreed, this __packed attribute is clearly bogus and should be removed.

Same for

+struct prestera_msg_event_port_param {
+       union {
+               struct {
+                       u8 oper;
+                       __le32 mode;
+                       __le32 speed;
+                       u8 duplex;
+                       u8 fc;
+                       u8 fec;
+               } __packed mac;
+               struct {
+                       u8 mdix;
+                       __le64 lmode_bmap;
+                       u8 fc;
+               } __packed phy;
+       } __packed;
+} __packed __aligned(4);

This makes no sense at all. I would suggest marking only
the individual fields that are misaligned as __packed, but
not the structure itself.

and then there is this

+       union {
+               struct {
+                       u8 admin:1;
+                       u8 fc;
+                       u8 ap_enable;
+                       union {
+                               struct {
+                                       __le32 mode;
+                                       u8  inband:1;
+                                       __le32 speed;
+                                       u8  duplex;
+                                       u8  fec;
+                                       u8  fec_supp;
+                               } __packed reg_mode;
+                               struct {
+                                       __le32 mode;
+                                       __le32 speed;
+                                       u8  fec;
+                                       u8  fec_supp;
+                               } __packed ap_modes[PRESTERA_AP_PORT_MAX];
+                       } __packed;
+               } __packed mac;
+               struct {
+                       u8 admin:1;
+                       u8 adv_enable;
+                       __le64 modes;
+                       __le32 mode;
+                       u8 mdix;
+               } __packed phy;
+       } __packed link;

which puts misaligned bit fields in the middle of a packed structure!

       Arnd
