Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC65813634F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgAIWkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:40:31 -0500
Received: from mout.gmx.net ([212.227.17.22]:49521 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgAIWkb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 17:40:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578609625;
        bh=scKjw13Zpdkn0gFUcrq60bT4NxPCU9OIjwel84E2NB8=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=iJaW09GLVysBuFelJ5qeTZCOEBqoo2gB+XX70j40scDeBM6itAii0WBJQnrPqsVS1
         ZDM8M7aqkt0KyQNuH2MtHeWFeyiiRN5ZBcSit3V4tz3CeGkrIeDpKd73ftmGxkJfPq
         xp6uscri5e8fSRJR69PlR1R6GLBsgrdG15gZkODk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([81.25.174.156]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N3KPq-1joclW2sba-010LGc; Thu, 09
 Jan 2020 23:40:25 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
Date:   Thu, 9 Jan 2020 22:40:24 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200109215903.GV25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:aY3I/Ad1qVPESy86D/UghGaj+gQT+ggVPOialsWRV6yL07D9uC6
 jHxrLzNuUYSPSIJ4QPTkMjfWrDhp642COLbCsqOtFOU4HfY3IoMO33cD7lMs1+JihlrQd5k
 Dxn0nYXSpmRYkaRb6kvLfffRFiliruiUgJFhQ6TIW8r8c4dAWcxJJER8gh46PWnigIT8nGT
 Mu5D2ln3Xlv9FGeEKqTVw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ommHQBHmm/Y=:pUXizfsv1RXdE3sSZseR4M
 AUpArPW7Y1w+MfHxiFeKYxUuW93qLDaZeRODbEyCXxh/h3FwEk4UI1VFEFcViXZalcZCUpLtU
 602ooXsz9FsU0YxbhCDc6obAQCFP6uyPwNQgUecvfwoGWzEqLC7LvEr/xq+MESFfloukAc+k/
 Qq1miu6WB0PjO/Q2EOVuupNBgaMXOAKmlGYOVXXrY9Qib7/7+WIDnV48hc6mBNDNnpq+Y4raD
 3telj7nrrUeYtZCYGGISBjDmoNTyYBt98KnwZI3oeWZqHMoZSEL9a5hg1aaBZVwxhkM3QPf4U
 kgK2CqcFnW8VUFllE3bT+eLvwHude6ySyJWaJ01h294y2GLcrR1TGNHS+dZ9q08QiW/CHsM0h
 rDsbVoh91cBfDnQyTw0ZDcaTrrLx/rTEmEVNIlDGO5AVNLczOPrzF41gVzMkYhTaJBbmk4Wmi
 lB70DY2MzaRGQSBP52KEsH98EBtKVCgSGTckEwsvGQJANeGpvJW1uw4Wh50lGLJqhP3aJXl3S
 KTr8PgZ/EkNPw+N3vz/P8JqAdDNW5LtUJqdPKOMnfL7QcFgwKMOFvn/g5Q+0zliH2lWfQkmis
 N3CHhNNYudfGY3m9+zIuZk6Zn0LI0xKkFP3P7qkNABe0Fb4xRkyjnIc2t3i0SetrlPa0wAlBU
 IvMCWcEyptE5GG2IbeXQ0Q1tM/8M2T1dOpLPXKu5NHHbjiSPZPqmMIZEVgF5IqvKR7POc6lSi
 b0BIsL0sCQ5AdE3pRf6KX/lLfIccxoSKlFYbDoecdeDG/051/UUFUfrzwRXSHVPWiSu711kdm
 dqmsd0p3KWCjY2ZM4XtMo0pKSeWbwnlYpXFpBsLDQnxNZzUzewcPnyhYW+hLWaDtwaegoWwNn
 Y1/2oz0wfq0TUm+mGsqA3swiH3m7A6V4uYeyn66Tl6hFsMJGI1HimaTvJ+laI701+Gh7LAoTz
 DUdQKGc7LlPPInnIep0/e+0iFLT7N54jFR/jH+3Bs/Tr9LFA5wJ375fxkmafhlDg2nAkdAd5f
 ULBx2MeALAhDze3qa3SWkGbKSQnQkaC8ByqHVrEOFVIO43sKKpzb15dttpblXRXXkv6Hw92Lr
 qHy9hy8EAHh0d5wAfZOjPJ6R999AiQVoTytGkGmOyME77bNkExsUo8ruf6GH7CErgDTorV5+o
 LAQMYZu0tOLDkwuBFNTNKo5R6EinIm1SBGgmWrzFRAkA2K+jMDHECjp8ZhPGroC3NOqrwL8ah
 1kDsKzqaoBhseqOr8hkOXgd4icQyMQ/JMnLfGEw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/01/2020 21:59, Russell King - ARM Linux admin wrote:
>
> Also, note that the Metanoia MT-V5311 (at least mine) uses 1000BASE-X
> not SGMII. It sends a 16-bit configuration word of 0x61a0, which is:
>
> 		1000BASE-X			SGMII
> Bit 15	0	No next page			Link down
> 	1	Ack				Ack
> 	1	Remote fault 2			Reserved (0)
> 	0	Remote fault 1			Duplex (0 =3D Half)
>
> 	0	Reserved (0)			Speed bit 1
> 	0	Reserved (0)			Speed bit 0 (00=3D10Mbps)
> 	0	Reserved (0)			Reserved (0)
> 	1	Asymetric pause direction	Reserved (0)
>
> 	1	Pause				Reserved (0)
> 	0	Half duplex not supported	Reserved (0)
> 	1	Full duplex supported		Reserved (0)
> 	0	Reserved (0)			Reserved (0)
>
> 	0	Reserved (0)			Reserved (0)
> 	0	Reserved (0)			Reserved (0)
> 	0	Reserved (0)			Reserved (0)
> Bit 0	0	Reserved (0)			Must be 1
>
> So it clearly fits 802.3 Clause 37 1000BASE-X format, reporting 1G
> Full duplex, and not SGMII (10M Half duplex).
>
> I have a platform here that allows me to get at the raw config_reg
> word that the other end has sent which allows analysis as per the
> above.
>

The driver reports also 1000base-x for this Metonia/Allnet module:

mvneta f1034000.ethernet eth2: switched to inband/1000base-x link mode

mii-tool -v eth2 producing

eth2: 1000 Mbit, full duplex, link ok
 =C2=A0 product info: vendor 00:00:00, model 0 rev 0
 =C2=A0 basic mode:=C2=A0=C2=A0 10 Mbit, full duplex
 =C2=A0 basic status: autonegotiation complete, link ok
 =C2=A0 capabilities:
 =C2=A0 advertising:=C2=A0 1000baseT-HD 1000baseT-FD 100baseT4 100baseTx-=
FD=20
100baseTx-HD 10baseT-FD 10baseT-HD flow-control
______

On 09/01/2020 21:34, Russell King - ARM Linux admin wrote:
> You can check the state of the GPIOs by looking at
> /sys/kernel/debug/gpio, and you will probably see that TX_FAULT is
> being asserted by the module.

With OpenWrt trying to save space wherever they can

# CONFIG_DEBUG_GPIO is not set

this avenue is unfortunately is not available. Is there some other way=20
(Linux userland) to query TX_FAULT and RX_LOS and whether either/both=20
being asserted or deasserted?
___

On 09/01/2020 21:34, Russell King - ARM Linux admin wrote:
> BTW, I notice in you original kernel that you have at least one of my
> "experimental" patches on your stable kernel taken from my "phy" branch=

> which has never been in mainline, so I guess you're using the OpenWRT
> kernel?
I am not aware were the code originated from. It is not exactly OpenWrt=20
but TOS (for the Turris Omnia router), being a downstream patchset that=20
builds on top of OpenWrt. The TOS developers might be known at Linux=20
kernel development, recently added their MOX platform and also with=20
regard to Multi-CPU-DSA.
___

On 09/01/2020 21:34, Russell King - ARM Linux admin wrote:
> You're reading/way/  too much into the state machine.

How so? Those intermittent failures cause disruption in the WAN=20
connectivity - nothing life threatening but somewhat inconvenient.
I am trying to get to the bottom of it, with my limited capabilities and =

with your input it has helped. I will ping Allnet again and see whether=20
they bother to respond and shed some light of what their modules does=20
with regard to TX_FAULT and RX_LOS.



