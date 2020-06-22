Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B1B20375D
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 14:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbgFVM6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 08:58:22 -0400
Received: from mout.gmx.net ([212.227.17.20]:55261 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728165AbgFVM6V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 08:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1592830694;
        bh=Quim3fmlj4kr2L6FuCdj9+KFWrLFSB4sqJqGli4cuCo=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=OV8wiAMW8ZTb5TJxfTibiW4609+NNrTY1peHeH4CLm/vhdITnAli3WC7uVVQjgHpv
         7F+3yBUmw8fN9K3YZE5jqJF3tOdlVf/6HQ6743ZxPRdfxg+WYj6WxHX+xBTRAISzK7
         7yBwMtHhLLcBu7oA8KOceclDoFsH9lTlH8VHeyQ4=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([149.224.28.87]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8hVB-1jjFQa3z4z-004kE8; Mon, 22
 Jun 2020 14:58:14 +0200
Reply-To: vtol@gmx.net
Subject: Re: secondary CPU port facing switch does not come up/online
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Marek Behun <marek.behun@nic.cz>
References: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
 <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>
 <eb0b71bb-4df3-ff3e-2424-a0d92b26741a@gmx.net>
 <20200622143155.2d57d7f7@nic.cz>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <50a02fb5-cb6c-5f37-150f-8ecfccdd473b@gmx.net>
Date:   Mon, 22 Jun 2020 12:58:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
In-Reply-To: <20200622143155.2d57d7f7@nic.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="quT5keco0PAnyN5Boe4RJoXUQwcsMTw9P"
X-Provags-ID: V03:K1:SFh+cV8X8ZZFjC5zznXfSS8X5/UNtMn3DqpkRoIhogzWCVNj07x
 NjbLwkoku+Ius0QpHWRiARD33O4lQsMoJErNIvE6O8thMEFV1GhQC+qqDM2LIKFX6BgmhZs
 AldmC3qzcFda4GbhJyXiJgFuOv8xrWBeQyiCkmJHjllUsMQjrRmGAMdIpdYm8G1oHBnUTU8
 rRVT1mYiik1pSjdG3uQGA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+hJtAUcCDe4=:5e7EnLqN3X8eGvtZAGjSpK
 gI0IaiGVgueQjDpzqIKVT4fnGTtNTHv/yVegmiIIAF4rvRXW/ss5b4cUovZSLrOrXR7F6HQ9y
 D/aiO7IpIcFp0hjP7P92/0vApgIEADzqMFexYIa0x0573uj+HZtVHnMyJ+N/9q7X6VMWeq860
 uAvvaVaoNPKURPCaH89xF0aJj7G/SsADrOp73UkEHRsTGcI6QQ1Kv2wnCtxbo5afjN7OYpYmw
 NlybceDEltQGHS57rwIcmKkTwpeXzT+Z9SGD24/qH6/CvsrG+uQRLDTvzL8e73Wl+AK1Cc5uT
 LfoBVa429XrO40S5ePxAa/FenfzR6KxPU/lvatVO2kJtA+UR+i5WSnhjULyQyRmPr767SSpE3
 CKlgRmgE14d2hfByYnsXEY6x2xaRMqyT9LvfBKUTIox60KFMK+WV+jRBIJRo2R3503DO16Ryr
 RCHZKzH4gr42I5M5FvQcr9iunTPvBEn2hvBkDsFYrBZZJTXsy86k95jCzGWn6IQIbieOPa9G4
 oYoRhgswmfi4YU65eP14SK+xJr4POz4KwaiVB4yv2aGJMoPhziV+TlEoMBw2csF8ykcIyJNQS
 7h/XHRZXpF3Xd/zz/Oedc03o55AEeqwf89Sq7JWBagjgCXs6JrzMXVmGPuOliwLSGFnxakAuL
 X49MXjief9WDl+0IG7w2sKssk6nchaDxh7MxVsWaavwvT8o7Ak9i1yTBQVzA/eFayN5BTv++1
 Acc4vpRhkctd5abQ6nCsxaJPVLD7aMzc2huEoKmR1CHq1+4AbsNGy/uz347TJxWJXgFpjkmId
 B4e5+4uwT7fOZNiRXKk1xB+8pil38iSdR1HRm/rk6awB0g64Ueyjdr94nWAFqJVZ56raDulvq
 p96DcsuL8W0D8ucOji1C14Xqq5+4JJOyWKWgXkU05w9WIZcWtcTJ9zwFh51l612Hqj/Vmh52D
 GLQ1cWCoIdFbG+q0HtnLkThAnP2fxX/hjBVExhRM1puXY/iXctjdaI2XGziqrsd0/Fw0/8hjH
 FtgDZTynjjE3ps2PQF5kouTfJBtrOJ9H5SDGuLgEfIRjdfrVAUqr+xbLRGCvhrk9WzVFRwMk7
 CgNG344oA9bF7lrcL0HqDhmrFJ55V6KRjVv0kb0Sk7VJC9f7S/eYXeDna0URf0Zd/YvcHNojd
 vucrVVZ5NyDYXC4ffnSvERqxIyqKmpwPMsSVqaoYdLP72AfPbUaAx7MKa2tpRMct+hhv8=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--quT5keco0PAnyN5Boe4RJoXUQwcsMTw9P
Content-Type: multipart/mixed; boundary="z46nhkktAv1NbOReJQd2DjdDpf4D0tSlv";
 protected-headers="v1"
From: =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Reply-To: vtol@gmx.net
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
 Vivien Didelot <vivien.didelot@gmail.com>, Marek Behun <marek.behun@nic.cz>
Message-ID: <50a02fb5-cb6c-5f37-150f-8ecfccdd473b@gmx.net>
Subject: Re: secondary CPU port facing switch does not come up/online
References: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
 <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>
 <eb0b71bb-4df3-ff3e-2424-a0d92b26741a@gmx.net>
 <20200622143155.2d57d7f7@nic.cz>
In-Reply-To: <20200622143155.2d57d7f7@nic.cz>

--z46nhkktAv1NbOReJQd2DjdDpf4D0tSlv
Content-Type: multipart/mixed;
 boundary="------------D23907777805D89DAB0CAF9B"
Content-Language: en-GB

This is a multi-part message in MIME format.
--------------D23907777805D89DAB0CAF9B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Thank you for the input and pointer to patches.

The problem is that it would require TOS deployed on the device, which=20
is not the case and the repo being twice removed from the kernel source=20
-> OpenWrt -> TOS, patches are neither available in mainline or OpenWrt=20
whilst the Marvell SoC chipset is not unique to the CZ.NIC manufactured=20
devices but leveraged by other vendors as well.

It seems a bit strange to be nudged to the deployment of a particular=20
repo, unless self-compiling kernel with those patch sets, instead of the =

same functionality being provided straight from mainline. Are those=20
patch sets being introduced to mainline?

On 22/06/2020 12:31, Marek Behun wrote:
> TurrisOS has patches adding multi-CPU DSA support, look at those if you=

> want this functionality.
>
> These patches apply on openwrt, after patching there should be kernel
> patches created in target/linux/mvebu/patches-{4.14,5.4}
>
> For 4.14 kernel:
> https://gitlab.labs.nic.cz/turris/turris-build/-/blob/hbd/patches/openw=
rt/wip/0009-mvebu-turris-omnia-multi-cpu-dsa.patch
>
> (this creates
> target/linux/mvebu/patches-4.14/90500-net-dsa-multi-cpu.patch
> target/linux/mvebu/patches-4.14/90501-omnia-dts-dsa-multi-cpu.patch
> )
>
> For 5.4 kernel:
> https://gitlab.labs.nic.cz/turris/turris-build/-/blob/fix/hbd-omnia-5.4=
-kernel/patches/openwrt/wip/0005-mvebu-initial-support-for-Omnia-on-5.4-k=
ernel.patch
>
> (this creates
> target/linux/mvebu/patches-5.4/9950-net-dsa-allow-for-multiple-CPU-port=
s.patch
> target/linux/mvebu/patches-5.4/9951-net-add-ndo-for-setting-the-iflink-=
property.patch
> target/linux/mvebu/patches-5.4/9952-net-dsa-implement-ndo_set_netlink-f=
or-chaning-port-s.patch
> target/linux/mvebu/patches-5.4/9953-net-dsa-mv88e6xxx-support-multi-CPU=
-DSA.patch
> )
>
> On Mon, 22 Jun 2020 07:39:00 +0000
> =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=E2=84=A0 <vtol@gmx.net> wrote:
>
>> On 21/06/2020 21:08, Florian Fainelli wrote:
>>> Le 2020-06-21 =C3=A0 13:24, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=E2=84=A0 a=
 =C3=A9crit=C2=A0:
>>>> {"kernel":"5.4.46","hostname":"OpenWrt","system":"ARMv7 Processor re=
v 1
>>>> (v7l)","model":"Turris
>>>> Omnia","board_name":"cznic,turris-omnia","release":{"distribution":"=
OpenWrt","version":"SNAPSHOT","revision":"r13600-9a477b833a","target":"mv=
ebu/cortexa9","description":"OpenWrt
>>>> SNAPSHOT r13600-9a477b833a"}}
>>>> _____
>>>>
>>>> With the below cited DT both CPU ports facing the node's build-in sw=
itch
>>>> are brought online at boot time with kernel 4.14 but since having
>>>> switched to kernel 5.4 only one CPU port gets online. It is as if th=
e
>>>> kernel discards the presence of the secondary CPU port. Kernel log o=
nly
>>>> prints for the offline port just a single entry:
>>>>
>>>> mvneta f1070000.ethernet eth0: Using hardware mac address
>>>>
>>>> Swapping eth1 to port6 and eth0 to port6 then eth0 is brought online=
 but
>>>> eth1 is not. Removing port5 then the port6 listed port is brought
>>>> up/online.
>>>>
>>>> Once the node is booted the offline port can brought up with ip l se=
t
>>>> up. This seems like a regression bug in between the kernel versions.=

>>> There can only be one CPU port at a time active right now, so I am no=
t
>>> sure why it even worked with kernel 4.14.
>> What is the reasoning, because DSA is not coded to handle multi-ports?=

>> DSA can be patched downstream (proposed patches to mainline kernel wer=
e
>> not accepted) and is so is for the 4.14 instance but there is DSA patc=
h
>> available for the 5.4 instance yet. That aside I would assume that DSA=

>> is not in charge of handling the state of the CPU ports but rather PHY=

>> or PHYLINK?
>>
>> I understand that dual CPU port chipset design is somewhat unusual but=

>> it is something unique and therefore a fringe case that is not support=
ed
>> by the kernel?
>>
>>>    Could you please share kernel
>>> logs and the output of ip link show in both working/non-working cases=
?
>> Sure, does the ML accept attachments, if so which format, or you want
>> two full kernel logs in the message body? Meantime, the short version:=

>>
>> 4.14
>> dmesg -t | grep mvneta
>> mvneta f1070000.ethernet eth0: Using hardware mac address d8:58:d7:00:=
79:7c
>> mvneta f1030000.ethernet eth1: Using hardware mac address d8:58:d7:00:=
79:7a
>> mvneta f1034000.ethernet eth2: Using hardware mac address d8:58:d7:00:=
79:7b
>> mvneta f1034000.ethernet eth2: switched to 802.3z/1000base-x link mode=

>> mvneta f1070000.ethernet eth0: configuring for fixed/rgmii link mode
>> mvneta f1070000.ethernet eth0: Link is Up - 1Gbps/Full - flow control =
off
>> mvneta f1030000.ethernet eth1: Disable IP checksum for MTU greater tha=
n
>> 1600B
>> mvneta f1030000.ethernet eth1: configuring for fixed/rgmii link mode
>> mvneta f1030000.ethernet eth1: Link is Up - 1Gbps/Full - flow control =
off
>> mvneta f1034000.ethernet eth2: configuring for 802.3z/1000base-x link =
mode
>> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control =
off
>> mvneta f1034000.ethernet eth2: Link is Down
>> mvneta f1034000.ethernet eth2: configuring for 802.3z/1000base-x link =
mode
>> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control =
off
>> mvneta f1034000.ethernet eth2: Link is Down
>> mvneta f1034000.ethernet eth2: configuring for 802.3z/1000base-x link =
mode
>> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control =
off
>>
>> 5.4
>> dmesg -t | grep mvneta
>> mvneta f1070000.ethernet eth0: Using hardware mac address d8:58:d7:00:=
79:7c
>> mvneta f1030000.ethernet eth1: Using hardware mac address d8:58:d7:00:=
79:7a
>> mvneta f1034000.ethernet eth2: Using hardware mac address d8:58:d7:00:=
79:7b
>> mvneta f1034000.ethernet eth2: switched to inband/1000base-x link mode=

>> mvneta f1030000.ethernet eth1: Disable IP checksum for MTU greater tha=
n
>> 1600B
>> mvneta f1030000.ethernet eth1: configuring for fixed/rgmii link mode
>> mvneta f1030000.ethernet eth1: Link is Up - 1Gbps/Full - flow control =
off
>> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link =
mode
>> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control =
off
>> mvneta f1034000.ethernet eth2: Link is Down
>> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link =
mode
>> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link =
mode
>> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control =
off
>> mvneta f1034000.ethernet eth2: Link is Down
>> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link =
mode
>> mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link =
mode
>> mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control =
off
>>
>>


--------------D23907777805D89DAB0CAF9B
Content-Type: application/pgp-keys;
 name="OpenPGP_0xF4F735931F05C5CE.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="OpenPGP_0xF4F735931F05C5CE.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----

xsFNBFnciLoBEADBsoGGx8dPCw216OeILh7+4A851grJgGjBpjv2bjGGxJlCpnevyCHf+D3SM=
fsz
ASwV23B1TXsp3YM4X2JVnRr9RAqr8+U8pUDb6c58U1Il182/vlk6utD8q1221o3XDp3RXhEqC=
FR1
K+0BlnFnE2//CPnEs94BJ94cksaxy14QpY4VL9w9u1O02KkSXA2f0j/R6sxnHGk6SAWTn7OE7=
l57
rJsiklq6AYuEQ2j/5rEa9rMe6yfryXsiuY++bUbAhlhnsWSalA56yl1FbfCW/lXNay9yrjYwi=
/44
nEMmuj79kXmMMMX87PpoaoQUGFI0PbkOhO2TkVXqSBY8lolTtMHeGm3XSRUo3LVEFWf2K4zWX=
AKo
K4rFg8zKEGzYZy2dlHbY777h6nqLjJ84tSQH7eimouPjuaklwK0ilmyBvpcWRnUpGuZbLv89s=
p5S
ThqZ+eYaur4p3mXOXift+vPM9sN9ycXg3SUBcq+Kz+Vo32dAd5jJhiNzW+FqaKMQMNfAsu/9s=
WgP
lwVBYywcW+oqN+T+94Vb4qJ8VjooVfSFSGZ+VEkxW9nDXh9TTQb6b0eDysgGiJ2ZaZbrzSQUE=
fUl
nAhvFLlfcxWI02EA9Dnj3vPuNPt6/mSV3d83tt8mE9gWMxYkY/aWyGWohczkMlj9vY+G+2k9+=
AG1
4BpNiGK7svsr9QARAQABzQx2dG9sQGdteC5uZXTCwZQEEwEIAD4WIQR6bKTYsnyC9Y8mc5H09=
zWT
HwXFzgUCWdyIugIbAwUJBhEmdgULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRD09zWTHwXFz=
o0Y
EACzVvOGrxWq7Igv7s1ikPhrzYLjGqfETgejkfpJ4Sm6A2siidOSvFZYB8UOso2+JSxq1SRIg=
MvV
MK/3tObL7yX0lcslg7PDoJ2ZLWIBqWmrtLWHPEubYYkZnPBtEsio/z4lt04Qmz/Ydx2zjR2cS=
3+0
k+Jb9qXxHAGynWiaUV4iQ/sIKjBki6okgM3cJTBRr3Y2mvQuf1WoekolqavHp+8yD9ESnGAGw=
25K
2Ya4BVQmzvSoK32xLbqIBe+sFfKtc8sjjk7ZR3rliM7+BTqvEYOMlMX9JKTKD9yIh8cYnonkq=
EP+
6OqrZFmk7qWVq33PGvl/JLLIA6lNDhDalWhlM5026Ti4g1dtnf6C2vvpPAQZuqKc3DboKkkPi=
+tl
hyfmnLltUnHVAeu6h1lQjESNuNY0jpKDukchL+9jRBjWg4Tf6PbG5m0z/wMsF6rqJ7MF9V9hT=
pbX
hMH1LgA1HMibszs9kNufhZzIp1/ZYtgQp1L4+BDRDtWv1n32C7SBrTVNdhmCqOFGv047g9QIL=
WlK
JYUrCby70Lk74xGJeHpPvftXeoR157adv8T1h3o5dc5sLI/FnGJAa6HRRt5PetLc/pTC7qwT2=
bTS
tZtpF6KGLHcxR64BAu4uCUbgnl89Q3etEmHU3akDQIhJiM3rG5XjDuq3j6Kb0GPmWElTXWqX+=
l7V
Nc7BTQRZ3Ii6ARAA5XGN+cUiahtr/8q4pj7lB5FHlOUmLYRf+rN25Fg0Pr3lxx840wKLHYNxD=
7Cj
2XTmsxJseMPy9SbAKgA9uyBe5AaPQA8J2sP6tM0DuIssfuc+uGMgIXb3SnZvLL1ER849HtDGV=
Jzn
Oq7Aja5MACNCjWfY4xOA8ReAKK6MaDTO3xKoNSiLrFpA9nvMvMFDPK67pAdM/yeE844mzk4s9=
UCT
7fRUkf60YdoxUC6/kHz+6HInerqZQHEBxGkHVq3lkzo5InC0FrWDwmjG+Ol6PlwsWKn3uhMQI=
6vm
RlOetr00qRLFTQoGcVmOfZRgk2AoAiBanf9CWYWlRTGS0cgO7UsaLbuhAi24eR+cZccqFQ05V=
aNN
hCXZwHJa03riIJoz7LN9RCjd91e5uMs0qjKiMypgRD3K+xjf62VIAEn2d/BM+BwNirwwppqYl=
d6h
n4+igv5+ZHcotL7QBZF6+I0pcl4UVjAIJXV/ekW5g/OX0YwyesCh6xG/MukvISrmHadnY5UC8=
lPA
8rgNYahAx4jOMsmOdDcBz4gaEBJnssGCfSFvf6BEt2KjLGao7N0Z0s4dyHDosR6lJZEI3XLeq=
Rgu
6ZAGaK50V073hQ4GIFeclRA3uNcMUR6jEYw+PFh4KMD1NXuAJy9LI6r1+PBZfgk2F4GFh2rWK=
Tnf
kylyGhPqboLrxkUAEQEAAcLBfAQYAQgAJhYhBHpspNiyfIL1jyZzkfT3NZMfBcXOBQJZ3Ii6A=
hsM
BQkGESZ2AAoJEPT3NZMfBcXOgdkP/02/0ONJGu6i0lFnIJJ9gPZ4MkJqAqMwY8oUorXtNmmJg=
YLE
0CPugmcfSw+ozzPqbNbuPWYLf9UUv1sMI8HyCI4Me7WgUf7FDPU1+Os77W+5Si7o9u/Nuvh8T=
jn2
3O6Y+axTzzqdcB4MugkZMlENHdULfizL82SEONng9vK2Q5S76b6Hh0VjNUTv1ZMUjEXrPvFk2=
Coq
b+J3Myin3ptT+FKOjOn4UG4ItM88q5IfqPxawWNpbfrXbArmyOT5R9bSldgPejdAEglLSwoBY=
7gW
duf1vb28ik9iF1lFK19PYwy0gOQGgWzQTaEgTzREG3PUASeYrvR0O9zs+8jgxDwY9qWt5onsv=
sLm
rEkyuOXJYTxuITQ9z7Jgc8Qn0Hum+SvGPyL9n0ONL95X3bWjS8igkSOBopniayWq2Nd2s2fNW=
mZP
Nx7da6dJM1wbaeff7QNz8T8H/n62fifjcxWc5et0PH35/fM6u98EdzyUTiaGG+zxbX8AmwSGo=
h4o
9yxqayBp5yZ4ovW+tUlXWD6s0MZRdbCixLB18tQlC8VJdPtc2mHPCoC6aQ+XZwypG0j3K2JQp=
xbH
0M7nJopBOJZPDWR6TmwgtYjWbYjP23CxaIIgpw+wbWXIFQ9QFJUZlnR3XOBjmxWEHyq/jGqP6=
68A
6g49RhefId/b4RJ51vwUuFPvDlmm
=3DEVfn
-----END PGP PUBLIC KEY BLOCK-----

--------------D23907777805D89DAB0CAF9B--

--z46nhkktAv1NbOReJQd2DjdDpf4D0tSlv--

--quT5keco0PAnyN5Boe4RJoXUQwcsMTw9P
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEemyk2LJ8gvWPJnOR9Pc1kx8Fxc4FAl7wquUFAwAAAAAACgkQ9Pc1kx8Fxc5D
hRAAl47rgCPITZMCyqmQqggYeX/7rpALtb2+cdEfDjrIohjO1X3nsK8yFmGjsCB2SMQbquzufnyh
FlNLAgry39pjabY57IDoeqS06kWta+x65YjNoHFcR5l0vNJka4xJBwacprsNWpdAOj/vgxiMUthy
c8+aI0t1OIfhh9q/CtRgafZ+M3zGKTpI+PTC0i+yGrntwexFQMsRGBoKSE/gQruOjahTZs3bK1oX
NiZdEHOo9F7osi3ugsYi5mTRrMKiMzlOIfCw/HfQsIX103ioLzZr+uJV7SpScrcCrkwe8krjX4IR
qnCuE5PNMPn1NYGLTFXEp5b9zqSZVPQlm1LEY27WZLS7JxfrhdT7mtDgPP95B+dp6tlQwforK2Ze
fCxtrBPDilR+Dnyu486NWxV4aaEWiEnge9jh81qWl4AqsVFw6fGsWYe+36Zsus4M82GjIhShx0YI
u2ECnGaHpPs5OFGu/+rvjNE9Ru4FqEAKGvN8Add1Lh6oj+OccxL+yo5XqTlZqQzyUe/IodH3kuNx
Lyalg466aL/xsrYa/KVczadngRg8SPUcbj7syRmqvJa1EpPWmGwYjcF7ZdtVOrpczhM6HFxVOkE2
GA5zTHTu8i4xzvdXaf6mqSs/hP573eJa6vQvgAXZcx08QBdJWjsljqt6odZM5wnc5a/WEJeQMsvM
p5s=
=tTpH
-----END PGP SIGNATURE-----

--quT5keco0PAnyN5Boe4RJoXUQwcsMTw9P--
