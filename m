Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD55367091
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241630AbhDUQtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:49:52 -0400
Received: from mout.gmx.net ([212.227.15.19]:49523 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237358AbhDUQtu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 12:49:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1619023715;
        bh=40y2ogTwZHjVV2UFcvvi314l227rNstpubsLcSaRYGw=;
        h=X-UI-Sender-Class:Date:In-Reply-To:References:Subject:Reply-to:To:
         CC:From;
        b=RD4rwJLAE+hx8dc2j+xXELvDJe44VQWdkz6RArOIzrmoxQHmULbh+wDgIL1BFhg3Y
         KZNPcHepnC4Jae6Ppw6bBoENc/M9Tk6xUK7/zZwALhLXB607ZmPus9SyeZ7oLxjauE
         7tX9N4UBHJ0Ch9U1GjJh6U2WtwVjpS3HjlOUOcFA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from frank-s9 ([80.245.77.133]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MwQT9-1lJ65W2iwP-00sLhi; Wed, 21
 Apr 2021 18:48:35 +0200
Date:   Wed, 21 Apr 2021 18:48:28 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <CAL_JsqKne=ASOyd0E9GakVvDvaXDauHOOU5NgxU8X8ySvyrAcw@mail.gmail.com>
References: <20210419154659.44096-1-ilya.lipnitskiy@gmail.com> <20210419154659.44096-3-ilya.lipnitskiy@gmail.com> <20210420195132.GA3686955@robh.at.kernel.org> <CALCv0x2SG=0kBRnxfSPxi+FvaBK=QGPHQkHWHvTXOw64KawPUQ@mail.gmail.com> <trinity-47c2d588-093d-4054-a16f-81d76aa667e0-1619013874284@3c-app-gmx-bs34> <CAL_JsqKne=ASOyd0E9GakVvDvaXDauHOOU5NgxU8X8ySvyrAcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: Re: [PATCH net-next v2 2/2] net: ethernet: mediatek: support custom GMAC label
Reply-to: frank-w@public-files.de
To:     linux-mediatek@lists.infradead.org, Rob Herring <robh@kernel.org>
CC:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        =?ISO-8859-1?Q?Ren=E9_van_Dorst?= <opensource@vdorst.com>
From:   Frank Wunderlich <frank-w@public-files.de>
Message-ID: <278445B7-727F-444D-8F5F-986CAD38BA57@public-files.de>
X-Provags-ID: V03:K1:i4lFH21GXNNZAau9Nq++WTeXreXX1sfRjeshPFKYIVVtlsNV0e1
 IMeY+l/cJEiY5tCksT+kTXePvUQkmN3Rwevzn/muTwx8SeR6zdgtVBMrMoYlLr4JS637SG0
 SKZ13gCYiTkam5Zl0Wz3brEPXaqN7gDh/s5x6vzPFue7gDkKI+UNBYFUmeF1+9R+LhIrnfF
 1ytvCuGAUq6JMwbIrTA4A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:o9viHyDaucU=:0rlcnz0e7JdvUX3oF/E7p9
 J1/G+8uMTzTLN6yJCNebZmuNDxl4tmI/GrZWf3xe140dNFsL9LyJndS8gPRATWrxVN+bYyw7t
 w8zikTRkv+QxI+rHBdDYoyJqwd11YxRrQrPvKAoFyIbq5427Ah7UGSDT0swtuli42GH1oxypZ
 DDt1JyjFBRGVfn1O2giVC+oIB1Hc20s4bUlvD9B8mhT75LkQYbzHrh1Bq5eAOhJH3usXHz1Tr
 d1pOc1VEQHagmnjGIiaw3QVpzcqRqd3MynpGKCMv77cX0/ZB/mxddj3R5qYWh9N63m8/ouReX
 pRa/acWLfxWi0CEFG0eDe7DamprjGlZv8nuAJ6x/Ut+FqLZk1faHmTW/tpWWFAWy9ovmLzLvR
 a68NvgC8RWTCIYqNmgoGWDmTR+x+qml+EYzLen0Owz8h4ZKoXTz26NEPG0+16o+2FkTdmPRtN
 s7/YqXEKhbajEJoDtO09uCLYRdB8geyRfO7ceCbA4lzvakEr63DXc7TbKaE87FIZBWhChxmgj
 cIeA455EMmLZ5irtHjCGShxm4Pc4UKowHM+GM5LDAvV5QYgSr0R3fZNKjB20tN57uDeGeA5qn
 2V05j1bMRPoVFgW7uRVJs+44tw3XDw+Ypw1Yd/O5c5ZYnn3AzDZ8pzn7lGd1SVN18VBEDL3IN
 YN5m2PicnkMZKkFvZ+LMVO91Gi0HKMGQTF2UttBnlw7bBq1DXebjGS1vO4mtG1tx84snUV/oR
 M43B00vF4AVldwJsvgY6bymPduJD6PaMIta1YGcHuQ8oY4MIV1kxcTgPPlo/iPXGOCjuynAZA
 waOSiw6WWVz89E5A+BlGJFVJMH48IzpvPy0SORIp2AGHAsUas4gjH4uoVvMwFTSadgkKT9yLi
 yu1apNeAcatOzWgodjIloZB1vPXJ8ynY5onfF/dvHgeDcT9eeHh9jbZoyBh4oXi3/iwtd84dw
 AqBRagZHByPnqYkuVrj4yJxo7ZGU4D2o0H1FYDPc+vfgrRJEOOB0CrEbnAsvi3vqqL21sIfOO
 qkKIX0ct23cGDnCVv+SFSrpSHBsSffM0TJrSCEeK7LSvEBV0tBxY4Z3m8iyTkJneJPuAC7RGy
 LHOlKeKKu5hoP/Tkue4KoO/HXrs6XfLYOU3iCn1rU6uos6BkYB6m4au+94Mh4XBd+oa2viZse
 4P3lc49bw1wYiPKQ8YsTB78S5RVzV4jlbXPhl80YuhNgW0JYl+XT+iOfavig1jjHyia2vLL/A
 3IJFskSsr1P3MJQIA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21=2E April 2021 18:12:41 MESZ schrieb Rob Herring <robh@kernel=2Eorg>:
>On Wed, Apr 21, 2021 at 9:05 AM Frank Wunderlich
><frank-w@public-files=2Ede> wrote:
>>
>> Hi,
>>
>> for dsa slave-ports there is already a property "label", but not for
>master/cpu-ports
>
>Is that because slave ports are external and master are not? If so,
>that makes sense=2E

In my case gmac is internal,yes=2E=2E=2Ei don't know if ilyas device is si=
milar=2E

But in a previous kernel-version the gmac of bpi-r2 can be passed through =
mt7530 switch and gets available external while bypassing dsa core=2E Here =
i wanted renaming of this port (gmac1=3Deth1 mapped as wan-port,while gmac0=
=3Deth0 was splitted by dsa switch driver to lan0-lan3)

>Seems like it could be possible to want to distinguish port types for
>reasons other than just what to name the device=2E Better to describe
>that difference in DT and then base the device name off of that=2E

Interface names should be not only numbering as they can have different me=
aning (wan vs=2E lan)=2E

>If you just want fixed numbering, then 'aliases' node is generally how
>that is done (either because it sneaks in or fatigue from arguing
>fixed /dev nodes are an anti-feature)=2E There's already 'ethernetN'
>which u-boot uses, but the kernel so far does not=2E

Aliases are not yet used as interface name=2E=2E=2Edo you want this way (u=
se alias name as ifname)? imho we can define multiple aliases to one dt nod=
e which is imho not the best way as interface can have only one name, and i=
nterface is created feom target node from where the alias needs to be found=
=2E

regards Frank
