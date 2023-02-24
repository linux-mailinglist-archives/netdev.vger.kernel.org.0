Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC766A2186
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjBXSbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBXSbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:31:39 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58816C18D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677263479; i=frank-w@public-files.de;
        bh=z1EHbkHFxM5DnVsMo7G9jTiEB77goAtRJl9cheaMZq8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HkZ5QEsdi7op8moZoNz3bGLi+MVlQAc1OaIL2Z6bLixx07cy1I2/DN804CgQAGfp1
         Hw6WNGq6hOQHgdECPDU1wjR65xRkIMQftJ/NmO5wSeuv0Hhqv5QOZTv4O2tjT7MJ4Z
         HQv/vWYzTg/lCKfgkVEYlx9mQ1T9q4MYcWhPa+sYbvf4fU2Gq+xLlHwZ+byqOjcPu5
         mV7irbz2BIOrvcjuT/fKODJ/oxJQCMjwv1zDhE6DtP5rjfOh/YpivDunTDG1fg2MzO
         w4AO0a9l4z28DujNrQxmloODh/f27QOuc2ULqo4G1/SQUb8eRf8gaNgcaCPG2JbQxQ
         /hpmGz+6Qc3rQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [157.180.225.28] ([157.180.225.28]) by web-mail.gmx.net
 (3c-app-gmx-bap70.server.lan [172.19.172.170]) (via HTTP); Fri, 24 Feb 2023
 19:31:19 +0100
MIME-Version: 1.0
Message-ID: <trinity-ed99385e-32eb-4be6-bbff-91211a38b8fb-1677263479464@3c-app-gmx-bap70>
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
Date:   Fri, 24 Feb 2023 19:31:19 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20230224181326.5lbph42bs566t2ci@skbuf>
References: <20230218205204.ie6lxey65pv3mgyh@skbuf>
 <a4936eb8-dfaa-e2f8-b956-75e86546fbf3@arinc9.com>
 <trinity-4025f060-3bb8-4260-99b7-e25cbdcf9c27-1676800164589@3c-app-gmx-bs35>
 <20230221002713.qdsabxy7y74jpbm4@skbuf>
 <trinity-105e0c2e-38e7-4f44-affd-0bc41d0a426b-1677086262623@3c-app-gmx-bs54>
 <20230222180623.cct2kbhyqulofzad@skbuf>
 <9c9ab755-9b5e-4e76-0e3c-119d567fc39d@arinc9.com>
 <20230222193440.c2vzg7j7r32xwr5l@skbuf>
 <e89af7bd-2f4c-3865-afa5-276a6acbc16f@arinc9.com>
 <trinity-c58a37c3-aa55-48b3-9d6c-71520ad2a81d-1677262043715@3c-app-gmx-bap70>
 <20230224181326.5lbph42bs566t2ci@skbuf>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:+AEd48sf0SM/8Bw4TuoNx8EiYPnQv6YDeH4aeG7ag9BwKD/M6yDAh4Li3db4qqODReSj8
 2zplecEQuSPXKBidfW/mAkA8E9mu7tvPtjBfKIjH77qB7eLOszBWzcfkpuTXczaq69vPRHLL2C1g
 2w0DaqVWUnyN6aBc/uDi4cypwHSoh9Y+j5fBD1ar1Nsph855RQZBaNKvE0oUYKv4CjpFRhs06o1V
 ftDVZ9Gn9++slmIk4XRyNAbwlTckGw6ZoAxa18qVJQCzortuXDdGUmqgf6axn7gVQYV2/3PH3ef4
 04=
UI-OutboundReport: notjunk:1;M01:P0:IGI3mAXdU4s=;oGeWXhZA2/OCg538i7GGZCwuq/B
 RuEuApCVhSgIlIwFmaiaD91LzkmPLRGcimocbiQtjacE5DBn0/ivdx1YlzXTaU8SuW6Z7tHfP
 q4QO/thzn2nIPCGPky3U2UbWp/+6T37uWTSvLDXNzo7nrE6+2uCYQlJmNdygOj9pl9ICdXj5b
 nr37sTogilmzEJsI13F13ujyi9IXKECMs2TTXs00jQIJut3NkSI8mKBht4sQvPWk9qaWlixB8
 uFkR56axcuorrpVVjW7Xx0HH9QEFemHYhWbRdqPdlwxmwIbHDFhyW8NB6uufMbm8HXVlCMCML
 O7EAsl8bYxoYsIG0eprZTZCgfaUN/JpXnnNrfPfZE5NBTVwD7bmG0wYpy/famudOYPm7M/Hmf
 hbSzG1NuUkhwIWTRtVFRGg3odv/2YW7otwue8usS6hJvGEJLCSQZvJLr7Bb7nxa/zJ7qMG96O
 slUms8i4bx0cmqBKqRHy/w0YG7KIaGeLPMDn7sR+NE1/+yJvKRyRSW/3NjlBl+OPyKyq/ur2X
 XphJ+JMX8Kyeskc5NK8VZqnwXUGhQxpvRo6fcmOs1bBoHaYr8+R/QtPmlUAtI+aDbGIW0LLHz
 4jUemdeAkLxlxG80urnYiOdSUXwbhPFDYePtXN4eculDVjj78AXK3ug+cSTmlpnFT3jofXeNU
 FpfCTwZ7I/f6fbH7UjL0iGGmIIEyavMAW6ezeuBTFBZAH6x/JuWUPa82FYM7+ZoLJXuPyAbUF
 vTnd/1mPTOv+VaiuDIBdzuKVZUIq6NCJVo73DsBYxmDAxtcSeSeNv8MaOO6T4bQkB1WFyjxR+
 uzZYOuRL3j0qwgcWinrvC+fQ==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

result is same

root@bpi-r2:~# iperf3 -c 192=2E168=2E0=2E21                               =
           =20
Connecting to host 192=2E168=2E0=2E21, port 5201                          =
           =20
[  5] local 192=2E168=2E0=2E11 port 48882 connected to 192=2E168=2E0=2E21 =
port 5201        =20
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd          =
     =20
[  5]   0=2E00-1=2E00   sec  75=2E3 MBytes   632 Mbits/sec    0    396 KBy=
tes        =20
[  5]   1=2E00-2=2E00   sec  74=2E3 MBytes   623 Mbits/sec    0    396 KBy=
tes        =20
[  5]   2=2E00-3=2E00   sec  74=2E6 MBytes   625 Mbits/sec    0    396 KBy=
tes        =20
[  5]   3=2E00-4=2E00   sec  73=2E9 MBytes   620 Mbits/sec    0    396 KBy=
tes        =20
[  5]   4=2E00-5=2E00   sec  74=2E6 MBytes   626 Mbits/sec    0    396 KBy=
tes        =20
[  5]   5=2E00-6=2E00   sec  74=2E4 MBytes   624 Mbits/sec    0    396 KBy=
tes        =20
[  5]   6=2E00-7=2E00   sec  74=2E4 MBytes   624 Mbits/sec    0    396 KBy=
tes        =20
[  5]   7=2E00-8=2E00   sec  74=2E4 MBytes   624 Mbits/sec    0    396 KBy=
tes        =20
[  5]   8=2E00-9=2E00   sec  73=2E9 MBytes   620 Mbits/sec    0    396 KBy=
tes        =20
[  5]   9=2E00-10=2E00  sec  74=2E6 MBytes   626 Mbits/sec    0    396 KBy=
tes        =20
- - - - - - - - - - - - - - - - - - - - - - - - -                         =
     =20
[ ID] Interval           Transfer     Bitrate         Retr                =
     =20
[  5]   0=2E00-10=2E00  sec   745 MBytes   625 Mbits/sec    0             =
sender   =20
[  5]   0=2E00-10=2E05  sec   744 MBytes   621 Mbits/sec                  =
receiver =20
                                                                          =
     =20
iperf Done=2E                                                             =
       =20
root@bpi-r2:~# ethtool -S eth0 | grep -v ': 0'                            =
     =20
NIC statistics:                                                           =
     =20
     tx_bytes: 819999267                                                  =
     =20
     tx_packets: 538815                                                   =
     =20
     rx_bytes: 18338089                                                   =
     =20
     rx_packets: 261984                                                   =
     =20
     p06_TxUnicast: 261974                                                =
     =20
     p06_TxMulticast: 10                                                  =
     =20
     p06_TxPktSz65To127: 261983                                           =
     =20
     p06_TxPktSz256To511: 1                                               =
     =20
     p06_TxBytes: 19386025                                                =
     =20
     p06_RxFiltering: 13                                                  =
     =20
     p06_RxUnicast: 538783                                                =
     =20
     p06_RxMulticast: 31                                                  =
     =20
     p06_RxBroadcast: 1                                                   =
     =20
     p06_RxPktSz64: 3                                                     =
     =20
     p06_RxPktSz65To127: 47                                               =
     =20
     p06_RxPktSz128To255: 2                                               =
     =20
     p06_RxPktSz256To511: 1                                               =
     =20
     p06_RxPktSz512To1023: 2                                              =
     =20
     p06_RxPktSz1024ToMax: 538760                                         =
     =20
     p06_RxBytes: 819999267

just to verify no pause is set (which is working without p5 enabled)

root@bpi-r2:~# ls /sys/firmware/devicetree/base/ethernet\@1b100000/mdio-bu=
s/switch\@1f/ports/port\@6/fixed-link/
full-duplex  name  speed
root@bpi-r2:~# ls /sys/firmware/devicetree/base/ethernet\@1b100000/mac\@0/=
fixed-link/
full-duplex  name  speed

as speed is lower than gmac speed i guess there is no need for pause frame=
s, but yes they can slow down=2E=2E=2E=20

mhm=2E=2E=2Etried again with port5 disabled (pause enabled again) and got =
same result, so this seems not to be the cause as i thought (but have now o=
ther patches in like core-clock dropped and RX fix)=2E

regards Frank


> Gesendet: Freitag, 24=2E Februar 2023 um 19:13 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail=2Ecom>
> An: "Frank Wunderlich" <frank-w@public-files=2Ede>
> Cc: "Ar=C4=B1n=C3=A7 =C3=9CNAL" <arinc=2Eunal@arinc9=2Ecom>, "netdev" <n=
etdev@vger=2Ekernel=2Eorg>, erkin=2Ebozoglu@xeront=2Ecom, "Andrew Lunn" <an=
drew@lunn=2Ech>, "Florian Fainelli" <f=2Efainelli@gmail=2Ecom>, "Felix Fiet=
kau" <nbd@nbd=2Ename>, "John Crispin" <john@phrozen=2Eorg>, "Mark Lee" <Mar=
k-MC=2ELee@mediatek=2Ecom>, "Lorenzo Bianconi" <lorenzo@kernel=2Eorg>, "Mat=
thias Brugger" <matthias=2Ebgg@gmail=2Ecom>, "Landen Chao" <Landen=2EChao@m=
ediatek=2Ecom>, "Sean Wang" <sean=2Ewang@mediatek=2Ecom>, "DENG Qingfang" <=
dqfext@gmail=2Ecom>
> Betreff: Re: Choose a default DSA CPU port
>
> On Fri, Feb 24, 2023 at 07:07:23PM +0100, Frank Wunderlich wrote:
> > root@bpi-r2:~# ethtool -S eth0 | grep -v ': 0'
> > NIC statistics:
> >      tx_bytes: 1643364546
> >      tx_packets: 1121377
> >      rx_bytes: 1270088499
> >      rx_packets: 1338400
> >      p06_TxUnicast: 1338274
> >      p06_TxMulticast: 120
> >      p06_TxBroadcast: 6
> >      p06_TxPktSz65To127: 525948
> >      p06_TxPktSz128To255: 5
> >      p06_TxPktSz256To511: 16
> >      p06_TxPktSz512To1023: 4
> >      p06_Tx1024ToMax: 812427
> >      p06_TxBytes: 1275442099
> >      p06_RxFiltering: 16
> >      p06_RxUnicast: 1121339
> >      p06_RxMulticast: 37
> >      p06_RxBroadcast: 1
> >      p06_RxPktSz64: 3
> >      p06_RxPktSz65To127: 43757
> >      p06_RxPktSz128To255: 3
> >      p06_RxPktSz256To511: 3
> >      p06_RxPktSz1024ToMax: 1077611
> >      p06_RxBytes: 1643364546
>=20
> Looking at the drivers, I see pause frames aren't counted in ethtool -S,
> so we wouldn't know this=2E However the slowdown *is* lossless, so the
> hypothesis is still not disproved=2E
>=20
> Could you please test after removing the "pause" property from the
> switch's port@6 device tree node?
>
