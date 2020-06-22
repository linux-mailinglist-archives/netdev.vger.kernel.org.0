Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0212030BA
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 09:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731421AbgFVHkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 03:40:03 -0400
Received: from mout.gmx.net ([212.227.17.20]:45487 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731354AbgFVHkC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 03:40:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1592811594;
        bh=3pnaW9fEieZYYKgLLWFsLkXrDjFYXjDuRPcZgjnAVsY=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:References:From:Cc:Date:
         In-Reply-To;
        b=OtoQ7du1JvkhZA3p41eObBUwSdapoym+s1+DZR1bpNkdiZnEM6CQArpR4U5Ytf9bi
         Bj6HA/8kRaSMbdp5LDQoE55ptOSTVbaBloJpAoJ7qVvcXnxecoIjMet7aMuabyuX30
         SBMThcvulNyOp3/sbAzI+57TbKyH8KDMNQYVmNCg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([134.101.204.14]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MOA3F-1jThyN2I8n-00OWDi; Mon, 22
 Jun 2020 09:39:54 +0200
Reply-To: vtol@gmx.net
Subject: Re: secondary CPU port facing switch does not come up/online
To:     netdev@vger.kernel.org
References: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
 <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>, marek.behun@nic.cz
Message-ID: <eb0b71bb-4df3-ff3e-2424-a0d92b26741a@gmx.net>
Date:   Mon, 22 Jun 2020 07:39:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
In-Reply-To: <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S2JoXFccBYwwKGYLU1ItUx2jl9aWUH1Yz"
X-Provags-ID: V03:K1:c2SPaVVT8FTH5art4lwY1u9uRshVKk8B/nC44dmR3G8XHHHQVzt
 VzuhFbTDkUa5i+A/Hv6wcicZhwRiuL2gNABp2Y/PeSImv17Ye3s7sU3z5how4HRtpbav7L+
 h7S9zsjyZwv6fN11DNsTWl7seKGKOqwfHI7SNCdXGO9EFFi90oYf5ibwUaX8IxEvb8Yun4J
 lH2m6F4YtJI7PYnG0SVhg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:OLu7mhayznY=:3LvDGseLKs3HDuwvGkGYBz
 rBNUFul33H1X9xE0+XTjU0KhyRYTU3kCFH3wkpvk60A6fO0KJlxN6t1f3v5wlReoNGtOwrR4L
 Kes/wuKQ1hsKZNyB9XYpwm8If1bh/dGUXcZgh/Sej8tWiJp7qEAsxV8qmlmoSENTrANFFccEH
 r5i8+WJawDsHJ42Om2y0pW+v/smaylhYpD2+DnkK7OVM++D5cNZy3bVh3Y1i2f5Xp0sk/psry
 1vtSFtyUkXOfV8asLXUhT3AQOi/BoeXC4s1VDt1QN80b3Y6kgaxZowDqqmp2ptPxrvtXE/EV2
 FD1gjOrnXrrFgTi+z2J7ub1VLLDRcYDFnGRBy3ZjUXbTX86xPeFrrUd540pHfpJQhLfkvjuuV
 r/9OoSqTQHqCW1DkE+dO5LPpby0OSI+2BeelIVedefhrwHx6KTlshkxKgFuBeFiFOounQ9SQH
 3Tbz/rbP8o3OaA43iyJFROtbeR4IEy8xsh9x2uWdzO5ULRIIFTqc2TpWw7AuIfWwk2C080VlP
 raonhBMomVToJdBDZ7Z+vOUx+VVMfGThgYrxAPRdau8plDdP3dM5kQddRfCWicIjLGIQ3hyJw
 uegfOCVzPJnVMbbKnO5gQQUd5dBWvVDxtB7mH2iCaHmeSShTje8wK5sWAQzvDi373/6ye1sQ/
 gkfNPvfXnCmpIIfWONM69+WsnS+2oCY/LpS51+PA96bVNx+U4xUEPGdqdR2kfF2pHRK2EGM17
 OX/2PVjoatDNgRDFf3eI6pvyGccQt9pTgKqwnmx+3rU+lCSKGuFzFA4tHut0Zybo0zPtlIZRz
 RqrbNR+SD6cJoyIM9ucb8jGbmCam5oa2r0ih1EuQAAvCzT6E0ThR4o6qUzgrJ5loNImaxr2YN
 WIgwt5ILUjaFp6qaNKO+UCj8UeZ/l0uDtVcDHaCUHXetKCNm+K7lYtUVr/NKeWW9EpfZWgw7O
 fyRRC0tXCB0xj8GJvVFQ+dctlB9hw7txYBtnaTvYPCqsKPWfv7Pln8VKNPdzLimAfbjocOBiW
 sdEPvAWftzpDqnSsxzbXZ6mx5JgsAlU+DX9LGBhTPCAe/m/vEJchD/53YeZ8MfpLZ59Rk0JGW
 ZdP3rK8ETTyaAPlTxtgo2xnD3Q8aAdl33wqrFEP9lcx2tb3o3qPeGMaTeQYr2gtSUNWDjQzPU
 x2yEtA0fqoHw6MxVVCXs5tahg8KAzGitwrNBQ2aqACWouGxCPtwZWmySGkcEIXtZj65uw=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S2JoXFccBYwwKGYLU1ItUx2jl9aWUH1Yz
Content-Type: multipart/mixed; boundary="pFrWO0Ua7gnxMb8OtoA359Kvtzr6Ol5YN";
 protected-headers="v1"
From: =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Reply-To: vtol@gmx.net
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
 Vivien Didelot <vivien.didelot@gmail.com>, marek.behun@nic.cz
Message-ID: <eb0b71bb-4df3-ff3e-2424-a0d92b26741a@gmx.net>
Subject: Re: secondary CPU port facing switch does not come up/online
References: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
 <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>
In-Reply-To: <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>

--pFrWO0Ua7gnxMb8OtoA359Kvtzr6Ol5YN
Content-Type: multipart/mixed;
 boundary="------------DBE2C538FE2B137D9AC24F7B"
Content-Language: en-GB

This is a multi-part message in MIME format.
--------------DBE2C538FE2B137D9AC24F7B
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 21/06/2020 21:08, Florian Fainelli wrote:
> Le 2020-06-21 =C3=A0 13:24, =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=E2=84=A0 a =C3=
=A9crit=C2=A0:
>> {"kernel":"5.4.46","hostname":"OpenWrt","system":"ARMv7 Processor rev =
1
>> (v7l)","model":"Turris
>> Omnia","board_name":"cznic,turris-omnia","release":{"distribution":"Op=
enWrt","version":"SNAPSHOT","revision":"r13600-9a477b833a","target":"mveb=
u/cortexa9","description":"OpenWrt
>> SNAPSHOT r13600-9a477b833a"}}
>> _____
>>
>> With the below cited DT both CPU ports facing the node's build-in swit=
ch
>> are brought online at boot time with kernel 4.14 but since having
>> switched to kernel 5.4 only one CPU port gets online. It is as if the
>> kernel discards the presence of the secondary CPU port. Kernel log onl=
y
>> prints for the offline port just a single entry:
>>
>> mvneta f1070000.ethernet eth0: Using hardware mac address
>>
>> Swapping eth1 to port6 and eth0 to port6 then eth0 is brought online b=
ut
>> eth1 is not. Removing port5 then the port6 listed port is brought
>> up/online.
>>
>> Once the node is booted the offline port can brought up with ip l set
>> up. This seems like a regression bug in between the kernel versions.
> There can only be one CPU port at a time active right now, so I am not
> sure why it even worked with kernel 4.14.

What is the reasoning, because DSA is not coded to handle multi-ports?=20
DSA can be patched downstream (proposed patches to mainline kernel were=20
not accepted) and is so is for the 4.14 instance but there is DSA patch=20
available for the 5.4 instance yet. That aside I would assume that DSA=20
is not in charge of handling the state of the CPU ports but rather PHY=20
or PHYLINK?

I understand that dual CPU port chipset design is somewhat unusual but=20
it is something unique and therefore a fringe case that is not supported =

by the kernel?

>   Could you please share kernel
> logs and the output of ip link show in both working/non-working cases?

Sure, does the ML accept attachments, if so which format, or you want=20
two full kernel logs in the message body? Meantime, the short version:

4.14
dmesg -t | grep mvneta
mvneta f1070000.ethernet eth0: Using hardware mac address d8:58:d7:00:79:=
7c
mvneta f1030000.ethernet eth1: Using hardware mac address d8:58:d7:00:79:=
7a
mvneta f1034000.ethernet eth2: Using hardware mac address d8:58:d7:00:79:=
7b
mvneta f1034000.ethernet eth2: switched to 802.3z/1000base-x link mode
mvneta f1070000.ethernet eth0: configuring for fixed/rgmii link mode
mvneta f1070000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off=

mvneta f1030000.ethernet eth1: Disable IP checksum for MTU greater than=20
1600B
mvneta f1030000.ethernet eth1: configuring for fixed/rgmii link mode
mvneta f1030000.ethernet eth1: Link is Up - 1Gbps/Full - flow control off=

mvneta f1034000.ethernet eth2: configuring for 802.3z/1000base-x link mod=
e
mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off=

mvneta f1034000.ethernet eth2: Link is Down
mvneta f1034000.ethernet eth2: configuring for 802.3z/1000base-x link mod=
e
mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off=

mvneta f1034000.ethernet eth2: Link is Down
mvneta f1034000.ethernet eth2: configuring for 802.3z/1000base-x link mod=
e
mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off=


5.4
dmesg -t | grep mvneta
mvneta f1070000.ethernet eth0: Using hardware mac address d8:58:d7:00:79:=
7c
mvneta f1030000.ethernet eth1: Using hardware mac address d8:58:d7:00:79:=
7a
mvneta f1034000.ethernet eth2: Using hardware mac address d8:58:d7:00:79:=
7b
mvneta f1034000.ethernet eth2: switched to inband/1000base-x link mode
mvneta f1030000.ethernet eth1: Disable IP checksum for MTU greater than=20
1600B
mvneta f1030000.ethernet eth1: configuring for fixed/rgmii link mode
mvneta f1030000.ethernet eth1: Link is Up - 1Gbps/Full - flow control off=

mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mod=
e
mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off=

mvneta f1034000.ethernet eth2: Link is Down
mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mod=
e
mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mod=
e
mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off=

mvneta f1034000.ethernet eth2: Link is Down
mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mod=
e
mvneta f1034000.ethernet eth2: configuring for inband/1000base-x link mod=
e
mvneta f1034000.ethernet eth2: Link is Up - 1Gbps/Full - flow control off=




--------------DBE2C538FE2B137D9AC24F7B
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

--------------DBE2C538FE2B137D9AC24F7B--

--pFrWO0Ua7gnxMb8OtoA359Kvtzr6Ol5YN--

--S2JoXFccBYwwKGYLU1ItUx2jl9aWUH1Yz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEemyk2LJ8gvWPJnOR9Pc1kx8Fxc4FAl7wYEgFAwAAAAAACgkQ9Pc1kx8Fxc7c
4hAAmR4wTPDhiUqPTE0mHAzmwgQEviJhyJHQ6TbGqmLTpW0kIO6p3vOIidq2sXre+zU8LHlVb39Y
j+amKVbj2I5e3ge9ecWpdFDxNfWkWvSSi0BE9WJMIeiMCCo/B65ygVM8gzcqluvJb3mheSTm94Cp
ijnkPG/Dc2Lzbp04YneHW9koSyP0J7mNx3XNjvvvJ/R5xMNtUXiHPOrNwMKCS0db0f0hUkEfrjdO
2E71x1SR0Ag0u2CeodPRxm2j9cR+ENA9cqYCNckcL0WgqpXjg2r6ZiIEAlyxApfTZr8AaY84zX6U
e0i2EEg6WF+tVocY1mbyaZKOo47WBQmFtERzWSqSCNSDH/NqPrUG09IMy6bVheGSoVdJTkePrqkh
ShJ4tFR/s3+HgQQbyWCpiB53YMzRFDa8jPK8+dVXicqiz2d8LWU7OYgJrDSWczlXfTLNaOeliZoX
s5gh9FqDYGuhKedONKk7pqg/UB2rXhPs7FYh7yqb9GvgMhPe9bZj4uOq1VU77vjUglgV9S77QmdS
tocwLXDAAEPyOQMqQ0yiY9OIQzNk3k11qjSP3q8FlWQCjQulZYivYs4OmEgF4Z+RJFxYFPYK7CrU
5mRjCRgVahCZnw9cHElKVBQyAS9INJDYC02+bxhtmTvszBSVvwb1zc2TBF5PtPw41rJbElAD7k4/
Kvs=
=jVRL
-----END PGP SIGNATURE-----

--S2JoXFccBYwwKGYLU1ItUx2jl9aWUH1Yz--
