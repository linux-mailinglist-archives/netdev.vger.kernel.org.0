Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC476A2A18
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 14:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjBYNul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 08:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjBYNuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 08:50:40 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1975013D72
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 05:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677333013; i=frank-w@public-files.de;
        bh=I7cPPMDlMU1/4887lsUcH0bzZhPmhotALsqWlZCo5c4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=nAcE+EzBq6i1Psnzg1qyELabxXBmmXhB5OU4JMDKObSzMn79h3lnRwNt9JDP9nr0C
         fh2NQiRsVs7DUnHXTtFGj/9B+K5lCf0fiVtBkyQQU+1YICkIME5Dyh85MDkXzifdcw
         QiSSYaUDNeCvpANk2pBbPRls3h5d6ADCSQ+Fi/BWe0b+dqgey08mu9bKu5EfuP2bOy
         qH2W20YvmulN5tikXkxkGM8AjjcAZSY9mFuHI9UO4Qf+3D0FgTSFKgMObYhL+xDOoN
         youJamtkNSf3qHIr+HzUN57bajxaCYgHVS+uQz27O9HwJEwy3NpLwK4M0KlUK9/Dcd
         F1M1hz4tGV6lw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.154.5] ([217.61.154.5]) by web-mail.gmx.net
 (3c-app-gmx-bap06.server.lan [172.19.172.76]) (via HTTP); Sat, 25 Feb 2023
 14:50:13 +0100
MIME-Version: 1.0
Message-ID: <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?Q?Ar=C4=B1n=C3=A7_=C3=9CNAL?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Aw: Re: Choose a default DSA CPU port
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 25 Feb 2023 14:50:13 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230224210852.np3kduoqhrbzuqg3@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
 <20230224210852.np3kduoqhrbzuqg3@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:xPw+C06sypM0Tq07WdJbeMieyRn0Uv9bO4h+fKud5u4Zd96uYGM95umvbcM5UcZtqOF8D
 yNXDNNtwnzdTCU/2L53A77/OBSpoZTE/U3NZukbX82+hyiUxWGRUT20mJ5L2m0HYWie9/dyvVVbw
 lyfleS+BamDq0mjp6AhLjZM++sJeKQaX8qdUTDFOihXcLo1R5Te6EXeBQliTMZfX0O81XDJcTmSx
 2y/20XTg7j2541RkHGJ6NsPjkuJhwPHvxOt/+2iwAw++7AgRlPKOcBqATdYG16nlPzAop0gNuF/t
 58=
UI-OutboundReport: notjunk:1;M01:P0:95zdN1OTC5Q=;A1QmV4Og9cU5Pzc250hznWZ45K8
 Bp3XeWJr4horFmRRh1nLcn+jeVI/YfRyo1anuUVAGDGICuMM4JZjOfkWKtT3/a+CvfCTG9LxI
 eZJ7AoeTg7ttU+R9WYoMVWi+aUXkA7EJJ9N+DSKV4w9oxyxRvQMyXk+aaaVRWHb+0VT0Go3OZ
 khyISkRmRm0R+w+IfCu7u3hCwKfqX2jAdq6tOIF0ncn/KnrvcHVkd8NAGn/Wz8+DOnBfaTOae
 ZEPL7Tru8HZihowCvB7EDAriTCcmcIzW1/AHb8FtJuIuvb/Rqx4Ra/sfHNX6wAceQGtrz8c2P
 +WbPfrSGvfJ5iY3obm9Jnnyv6SDhv8FEJxV5QsC2/r4Tk8euVi+FMtnaugLSgMGGKoXTr8fkt
 j/bHLqpZIxfG0UeV8kAKquzNvq8SDgxkWAgjs6Df/8S7c9eZfnA1I7fz5d1r/IL9VwRGwy8J/
 89C1aiyTzOA8juftduH+JBBskxmYTpYPXwKYtt95nWdSEOrzI30zxPqXWLTbRmTCw+66GdK6J
 hdUBFV24BS+exnlqCIxU2hsEGbP+jN20IyMQXCYyWLrQ0+IsCMgB7OW5XQcvvyO1Mxw7Y5xtm
 h1fBjdrk0gln1NHcqjbZ7RguWGFEiGVnmizL88x5d7RyRURwreh8GV0w3KCjhPgSWiQYlYAed
 UjYqQ5ZfQUYE+gZpLwcFZeClKrvjy0nEnrV1ATI2szARZA8gUp9eF2ogSHj7sOeSm3Nra7Vrn
 GlHEzEbM2TdK4mXgz8yVBI8nYY1DBP0bpuFTyhmCXkF4+DcSMIJutFZHBdjHKIcNlBtCyuo1r
 /050I8cIwQR/O3cjVM6a2yhFKZrUjvJc8xxxit9o0TGQs=
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Freitag, 24. Februar 2023 um 22:08 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>

> On Fri, Feb 24, 2023 at 09:44:43PM +0100, Frank Wunderlich wrote:
> > 6.1.12 is clean and i get 940 Mbit/s over gmac0/port6
>
> Sounds like something which could be bisected?

managed to do a full bisect...

most steps needed the fix from Vladimir (1a3245fe0cf84e630598da4ab110a5f8a=
2d6730d net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port=
 0)

here is the result:

f63959c7eec3151c30a2ee0d351827b62e742dcb is the first bad commit
commit f63959c7eec3151c30a2ee0d351827b62e742dcb
Author: Felix Fietkau <nbd@nbd.name>
Date:   Wed Nov 16 09:07:32 2022 +0100

    net: ethernet: mtk_eth_soc: implement multi-queue support for per-port=
 queues

    When sending traffic to multiple ports with different link speeds, que=
ued
    packets to one port can drown out tx to other ports.
    In order to better handle transmission to multiple ports, use the hard=
ware
    shaper feature to implement weighted fair queueing between ports.
    Weight and maximum rate are automatically adjusted based on the link s=
peed
    of the port.
    The first 3 queues are unrestricted and reserved for non-DSA direct tx=
 on
    GMAC ports. The following queues are automatically assigned by the MTK=
 DSA
    tag driver based on the target port number.
    The PPE offload code configures the queues for offloaded traffic in th=
e same
    way.
    This feature is only supported on devices supporting QDMA. All queues =
still
    share the same DMA ring and descriptor pool.

    Signed-off-by: Felix Fietkau <nbd@nbd.name>
    Link: https://lore.kernel.org/r/20221116080734.44013-5-nbd@nbd.name
    Signed-off-by: Jakub Kicinski <kuba@kernel.org>

 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 281 +++++++++++++++++++++++=
=2D----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  26 ++-
 2 files changed, 258 insertions(+), 49 deletions(-)
frank@frank-G5:/media/data_nvme/git/kernel/BPI-R2-4.14 (HEAD) [1M46U]
$ git bisect log
git bisect start
# good: [830b3c68c1fb1e9176028d02ef86f3cf76aa2476] Linux 6.1
git bisect good 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
# good: [830b3c68c1fb1e9176028d02ef86f3cf76aa2476] Linux 6.1
git bisect good 830b3c68c1fb1e9176028d02ef86f3cf76aa2476
# bad: [c9c3395d5e3dcc6daee66c6908354d47bf98cb0c] Linux 6.2
git bisect bad c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
# good: [1ca06f1c1acecbe02124f14a37cce347b8c1a90c] Merge tag 'xtensa-20221=
213' of https://github.com/jcmvbkbc/linux-xtensa
git bisect good 1ca06f1c1acecbe02124f14a37cce347b8c1a90c
# bad: [b83a7080d30032cf70832bc2bb04cc342e203b88] Merge tag 'staging-6.2-r=
c1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
git bisect bad b83a7080d30032cf70832bc2bb04cc342e203b88
# bad: [7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91] Merge tag 'net-next-6.2'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
git bisect bad 7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91
# bad: [7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91] Merge tag 'net-next-6.2'=
 of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
git bisect bad 7e68dd7d07a28faa2e6574dd6b9dbd90cdeaae91
# good: [c609d739947894d7370eae4cf04eb2c49e910bcf] Merge tag 'wireless-nex=
t-2022-11-18' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wi=
reless-next
git bisect good c609d739947894d7370eae4cf04eb2c49e910bcf
# good: [c609d739947894d7370eae4cf04eb2c49e910bcf] Merge tag 'wireless-nex=
t-2022-11-18' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wi=
reless-next
git bisect good c609d739947894d7370eae4cf04eb2c49e910bcf
# bad: [32163491c0c205ffb1596baf9c308dee5338ae94] Merge branch 'r8169-irq-=
coalesce'
git bisect bad 32163491c0c205ffb1596baf9c308dee5338ae94
# bad: [32163491c0c205ffb1596baf9c308dee5338ae94] Merge branch 'r8169-irq-=
coalesce'
git bisect bad 32163491c0c205ffb1596baf9c308dee5338ae94
# good: [01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1] Merge tag 'net-6.1-rc8-=
2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
git bisect good 01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1
# good: [662233731d66cf41e7494e532e702849c8ce18f3] i2c: core: Introduce i2=
c_client_get_device_id helper function
git bisect good 662233731d66cf41e7494e532e702849c8ce18f3
# good: [d0c006402e7941558e5283ae434e2847c7999378] jump_label: Use atomic_=
try_cmpxchg() in static_key_slow_inc_cpuslocked()
git bisect good d0c006402e7941558e5283ae434e2847c7999378
# bad: [a61474c41e8c530c54a26db4f5434f050ef7718d] nfp: ethtool: support re=
porting link modes
git bisect bad a61474c41e8c530c54a26db4f5434f050ef7718d
# bad: [c672e37279896f570cfa44926d57497e8d16033b] octeontx2-pf: Add suppor=
t to filter packet based on IP fragment
git bisect bad c672e37279896f570cfa44926d57497e8d16033b
# bad: [94ef6fad3bf317b43cdc59ba171dff2486e59975] net: dsa: move headers e=
xported by master.c to master.h
git bisect bad 94ef6fad3bf317b43cdc59ba171dff2486e59975
# bad: [418e0721d408e90564b22d4c74342557b7911d77] Merge branch 'gve-altern=
ate-missed-completions'
git bisect bad 418e0721d408e90564b22d4c74342557b7911d77
# bad: [f63959c7eec3151c30a2ee0d351827b62e742dcb] net: ethernet: mtk_eth_s=
oc: implement multi-queue support for per-port queues
git bisect bad f63959c7eec3151c30a2ee0d351827b62e742dcb
# good: [8cf4f8c7d99addb6c2c2273fac7c20ca7c50db45] Merge tag 'rxrpc-next-2=
0221116' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-f=
s
git bisect good 8cf4f8c7d99addb6c2c2273fac7c20ca7c50db45
# good: [dbc4af768ba1670018c053b35a8613b811874f9c] net: fman: remove refer=
ence to non-existing config PCS
git bisect good dbc4af768ba1670018c053b35a8613b811874f9c
# good: [f4b2fa2c25e1ade78f766aa82e733a0b5198d484] net: ethernet: mtk_eth_=
soc: drop packets to WDMA if the ring is full
git bisect good f4b2fa2c25e1ade78f766aa82e733a0b5198d484
# good: [71ba8e4891c799f9f79ea219f155ac795750af41] net: ethernet: mtk_eth_=
soc: avoid port_mg assignment on MT7622 and newer
git bisect good 71ba8e4891c799f9f79ea219f155ac795750af41
# first bad commit: [f63959c7eec3151c30a2ee0d351827b62e742dcb] net: ethern=
et: mtk_eth_soc: implement multi-queue support for per-port queues

