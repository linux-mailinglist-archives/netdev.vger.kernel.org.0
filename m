Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567CF48DB29
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 16:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbiAMP4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 10:56:23 -0500
Received: from mout.gmx.net ([212.227.17.20]:56221 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236394AbiAMP4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 10:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1642089370;
        bh=TPK3RG4Q46BDr/GLL7HiS8mGm5Q5Aj7lutu8wrsnhI4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Kwy7zaGhyLwAhVKJ1+WaIWQmJNJ2xJI7iyW+apTn1BwhiHKE6s+scyCYN22aQfxA+
         x0bRriHwkZcDMuYeky9KpQzgRlMS5ApQ4KT91x9oM4AiU4HmMYKNLqfzYSYmTyRxty
         jZQcuhHIE7m0FKyVK8eVolZ3QEAeo39ep7eFhmdM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.72.196] ([80.245.72.196]) by web-mail.gmx.net
 (3c-app-gmx-bap49.server.lan [172.19.172.119]) (via HTTP); Thu, 13 Jan 2022
 16:56:10 +0100
MIME-Version: 1.0
Message-ID: <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Aw: Re:  Re:  Re: [PATCH net-next v4 11/11] net: dsa: realtek:
 rtl8365mb: multiple cpu ports, non cpu extint
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 13 Jan 2022 16:56:10 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <87v8ynbylk.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk>
 <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk>
 <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:KIptX2RHt9iKbuhyJ7t5mIjRVQe86YPvj07WQm+sWiSonQgwQgjdTFMWzkyybYoUl9/ZU
 uDXRdk0ohB/bq87Y3rCkkHOXpV0LcumPGiVANv8WuObbnxTRn+nwaZ9vRyeOBGsjIoUXc1sEIpaw
 PmDKX3xvnVJuSKmNY+WmTWBFbsFnDjrjT19Ke4mcvVI5KuGS4z1UNKMYcT/OCERluWkYaj8Up1h5
 gHmLAPzQM0d1C2kvJAr+WG4qsTPyJBxY3+QkrW7fKxkc43kUo97m1UGR9D4Nw38jmSCsYYB7+w2B
 t0=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1h6Mb4h0wD0=:6H7O2xAodWXys6hW8QUaLr
 +dJ4gyWHDd/AQvTIRBYQAiwpYtNxFfa1Eo643Bv50aaaPx7e6lFvO1Wwd/tJs1AC8OSUe4TZI
 kRNw9mEQj6BupqI6QBBFqcTTjMY9cZN1qPqe68Sf81XoLfv5ZeqaP2a+3JW/jpSpxf8ujnXyS
 jBRX+0+z5FKIkwN028G6R5eGGOqNadCBji2f+oxkunwmX5ieDErN5AWAe0duXb0e9uOc/x9iS
 e/UVGbary3KEkOLQME4C1DtlLmUw4nUZTvsHbnI4fTBdo2u+/tlO7920bhVm3X98v4/ziPxkN
 dHD1/xzOqituV5v6MNF7ePqQ1FiwfHpuATydaHUjhr5R4uRsKaNXm/+2dbEzMgcE9WGZ0ON/e
 fdgJ+vCIx8LD9U5gaT47mPWN2KmyQL32epqOUkBGxP8fw+yYe0XMgewk2fFNhSCJr0WRnBidW
 ksB71KxYRJmR/IbC1GcYCNxL0oMeoLhbppO+5BXNyjrl2wLiQMjinmlXYTpps/iG4V9fJtwP5
 XDZIvcsbNcw2m8phPNwi36CALPtNzO5Rf6gU3plV/yxyPVzxsg5Ji8X11OCTuhmRxZPVj9vuz
 pzODUStxKkpfVAncxJKSEDSk2ezujghqK9gM5GwL5S9OyYbvtCrlXt4UgZsgyDzVh8CAiv14+
 K1YGetIga2pwU0fN/xZF2Hze74grD7rzOsHvpYP2Lh6iwgXZCeDpm/ZuwSYfdmswk0PPHu3J4
 n1d5RZDfey3IceHogKUhKpN8zs1Y7tmwZj15Ra2clbWxsAnsqG57tG7d9qXM8eCg0N9mdazoH
 11SmK6a
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

the problem is checksum offloading on the gmac (soc-side)

root@bpi-r64:~# ethtool -k eth1 | grep checksum                           =
                                                                      =20
rx-checksumming: on                                                       =
                                                                      =20
tx-checksumming: on                                                       =
                                                                      =20
        tx-checksum-ipv4: on    #<<<<<<<<<<<<<                          =
=20
        tx-checksum-ip-generic: off [fixed]                               =
                                                                      =20
        tx-checksum-ipv6: on    #<<<<<<<<<<<<<                         =20
        tx-checksum-fcoe-crc: off [fixed]                                 =
                                                                      =20
        tx-checksum-sctp: off [fixed]

in my case i tried ipv4=2E=2E=2E=2Eand after disabling the offload i get a=
 connection

root@bpi-r64:~# ethtool -K eth1 rx off tx off                             =
                                                                      =20
Actual changes:                                                           =
                                                                      =20
tx-checksum-ipv4: off                                                     =
                                                                      =20
tx-checksum-ipv6: off                                                     =
                                                                      =20
tx-tcp-segmentation: off [not requested]                                  =
                                                                      =20
tx-tcp6-segmentation: off [not requested]                                 =
                                                                      =20
rx-checksum: off                                                          =
                                                                      =20
root@bpi-r64:~# telnet 192=2E168=2E1=2E1 22                               =
                                                                           =
 =20
Trying 192=2E168=2E1=2E1=2E=2E=2E                                         =
                                                                           =
       =20
Connected to 192=2E168=2E1=2E1=2E                                         =
                                                                           =
   =20
Escape character is '^]'=2E                                               =
                                                                        =20
SSH-2=2E0-OpenSSH_8=2E2p1 Ubuntu-4ubuntu0=2E3                             =
                                                                           =
 =20
^C

regards Frank


> Gesendet: Donnerstag, 13=2E Januar 2022 um 13:37 Uhr
> Von: "Alvin =C5=A0ipraga" <ALSI@bang-olufsen=2Edk>
> An: "Frank Wunderlich" <frank-w@public-files=2Ede>
> Cc: "Luiz Angelo Daros de Luca" <luizluca@gmail=2Ecom>, "netdev@vger=2Ek=
ernel=2Eorg" <netdev@vger=2Ekernel=2Eorg>, "linus=2Ewalleij@linaro=2Eorg" <=
linus=2Ewalleij@linaro=2Eorg>, "andrew@lunn=2Ech" <andrew@lunn=2Ech>, "vivi=
en=2Edidelot@gmail=2Ecom" <vivien=2Edidelot@gmail=2Ecom>, "f=2Efainelli@gma=
il=2Ecom" <f=2Efainelli@gmail=2Ecom>, "olteanv@gmail=2Ecom" <olteanv@gmail=
=2Ecom>, "arinc=2Eunal@arinc9=2Ecom" <arinc=2Eunal@arinc9=2Ecom>
> Betreff: Re: Aw: Re:  Re: [PATCH net-next v4 11/11] net: dsa: realtek: r=
tl8365mb: multiple cpu ports, non cpu extint
>
> Frank Wunderlich <frank-w@public-files=2Ede> writes:
>=20
> > Hi,
> >
> >> Gesendet: Dienstag, 11=2E Januar 2022 um 19:17 Uhr
> >> Von: "Alvin =C5=A0ipraga" <ALSI@bang-olufsen=2Edk>
> >
> >> Luiz, any comments regarding this? I suppose if the chip ID/revision =
is
> >> the same for both 67S and 67RB, they should work pretty much the same=
,
> >> right?
> >
> > my phy driver is same for both devices and afaik only do different
> > RX/TX delays=2E With the chip-rev-patch 0x0020 i can init the switch,
> > but have no technical documentation except the phy driver code=2E
> >
> >> Ping working but TCP not working is a bit strange=2E You could check =
the
> >> output of ethtool -S and see if that meets your expectations=2E If yo=
u
> >> have a relatively modern ethtool you can also append --all-groups to =
the
> >> comment to get a more standard output=2E
> >
> > as far as i see in tcpdump (suggested by luiz) on target it is a check=
sum error where checksum is always 0x8382 (maybe some kind of fixed tag)=2E
> >
> > 16:39:07=2E994825 IP (tos 0x10, ttl 64, id 54002, offset 0, flags [DF]=
, proto TCP (6), length 60)
> >     192=2E168=2E1=2E2=2E43284 > 192=2E168=2E1=2E1=2E22: Flags [S], cks=
um 0x8382
> > (incorrect -> 0xa6f6), seq 3231275121, win 64240, options [mss
> > 1460,sackOK,TS val 1615921214 ecr 0,nop,wscale 7], length 0
> > 16:39:12=2E154790 IP (tos 0x10, ttl 64, id 54003, offset 0, flags [DF]=
, proto TCP (6), length 60)
> >     192=2E168=2E1=2E2=2E43284 > 192=2E168=2E1=2E1=2E22: Flags [S], cks=
um 0x8382
> > (incorrect -> 0x96b6), seq 3231275121, win 64240, options [mss
> > 1460,sackOK,TS val 1615925374 ecr 0,nop,wscale 7], length 0
>=20
> That's weird, I must admit I do not recognize this issue at all=2E Try
> dumping the whole packet with -x and maybe you can see what kind of data
> you are getting=2E

2 example packets from tcpdump (if you still want to see it)

$ sudo tcpdump -i enx00131100063c -vvv -nn -x
tcpdump: listening on enx00131100063c, link-type EN10MB (Ethernet), captur=
e size 262144 bytes


16:43:50=2E297259 IP (tos 0x10, ttl 64, id 19802, offset 0, flags [DF], pr=
oto TCP (6), length 60)
    192=2E168=2E1=2E2=2E38278 > 192=2E168=2E1=2E1=2E22: Flags [S], cksum 0=
x8382 (incorrect -> 0xb704), seq 2565260294, win 64240, options [mss 1460,s=
ackOK,TS val 2917954112 ecr 0,nop,wscale 7], length 0
	0x0000:  4510 003c 4d5a 4000 4006 69fe c0a8 0102
	0x0010:  c0a8 0101 9586 0016 98e6 c406 0000 0000
	0x0020:  a002 faf0 8382 0000 0204 05b4 0402 080a
	0x0030:  adec 7240 0000 0000 0103 0307
16:43:51=2E324255 IP (tos 0x10, ttl 64, id 19803, offset 0, flags [DF], pr=
oto TCP (6), length 60)
    192=2E168=2E1=2E2=2E38278 > 192=2E168=2E1=2E1=2E22: Flags [S], cksum 0=
x8382 (incorrect -> 0xb300), seq 2565260294, win 64240, options [mss 1460,s=
ackOK,TS val 2917955140 ecr 0,nop,wscale 7], length 0
	0x0000:  4510 003c 4d5b 4000 4006 69fd c0a8 0102
	0x0010:  c0a8 0101 9586 0016 98e6 c406 0000 0000
	0x0020:  a002 faf0 8382 0000 0204 05b4 0402 080a
	0x0030:  adec 7644 0000 0000 0103 0307


> >> You can also try adjusting the RGMII TX/RX delay and pause settings -
> >> that might help for the R2 where you aren't getting any packets
> >> through=2E
> >
> > r2pro i got working by setting both delays to 0 as phy-driver does the=
 same (after some calculation)=2E
> >
> > on r64 this is a bit more tricky, because the phy driver uses  tx=3D1 =
and rx=3D3 with this calculation for reg-value
> >
> > regData =3D (regData & 0xFFF0) | ((txDelay << 3) & 0x0008) | (rxDelay =
& 0x0007);
> >
> > but in dts i need the values in picosends (?) and here i do not know
> > how to calculate them
>=20
> Try:
>=20
>     tx-internal-delay-ps =3D <2000>;
>     rx-internal-delay-ps =3D <1000>;
>=20
> This should correspond to internal values tx=3D1 and rx=3D3=2E

thanks i've found out and used tx=3D2000 and rx=3D900 (your 1000 is rounde=
d to 3), but only disabling checksum-offloading fixed the problem=2E need t=
o look how to make it persistent=2E

Afaik switch driver does not do any Checksum-handling so problem lies in t=
he SOC ethernet driver (here i guess the mtk_soc_eth=2Ec for mt7622)=2E may=
be i find an option to disable the offloading in dts because boards with mt=
7531 switch  working=2E maybe DSA-Tag handling can be changed, but this is =
no breaking point from my POV=2E

regards Frank
