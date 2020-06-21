Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DB0202CAD
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 22:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgFUUYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 16:24:46 -0400
Received: from mout.gmx.net ([212.227.17.22]:53849 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730288AbgFUUYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 16:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1592771083;
        bh=cgBslc2ghXmtaTi3tdkSE0LlHb26xDlfGMMSi5wSgPs=;
        h=X-UI-Sender-Class:Reply-To:To:From:Subject:Date;
        b=Sway3p291TbjQiCNp9hvpQW2qWM2P0LZjl+HQqrZUgih04yGl3kI20/Q4XIsYzGhB
         +uKqgcUVDDWaD4NPAgzWGLoAXoIw52YCwCglzebRsOSONjDQWcH+fM77lUKHGfVjNC
         XRfzVYcCCPrSvivFKqqXSAG5Y37rWQnNm9OwvMJc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([134.101.160.167]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MdNcG-1jDllb1Vrs-00ZQW6 for
 <netdev@vger.kernel.org>; Sun, 21 Jun 2020 22:24:43 +0200
Reply-To: vtol@gmx.net
To:     netdev@vger.kernel.org
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Subject: secondary CPU port facing switch does not come up/online
Message-ID: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
Date:   Sun, 21 Jun 2020 20:24:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jwcYgZVjdvUjugKsGpoFVhVE1lmDRXwxn"
X-Provags-ID: V03:K1:ACyfFYQ237yn6WvPxqSjMH28xARMQ7CSqCi5xOs8SvJhUpgnmu4
 miFfezds39De6ZK9hN+PuIaBbE+r88koxMU7rOkmCNhaE9z7Cv6wMycYN9NMDz2vXQyNG5k
 13JlWyoZXaVAeXHGhRxbAZiPo4+HvU5nCxc2jTApg+vvzsGiwcfbJ25Fu/PBFlYkZ4H6zPH
 mProaTv3oFnowYNmEi1sA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JqfSk44wXRg=:pY/OexIOxqxrMNw6Qn42/8
 SPmUmmYTPPx53T265/AKmwPqizeB410mu6wt/yIsDpYoIFQxtt6e8trlxRiwVoitmQzmXZCqU
 UhdKJE6rV8hvGPO4ID7T+UWvKUbKBKQHIxjcN+wIfmrvDqipqh7p0cFwDmH0rnI2u1A1CGP8o
 ANw7qIuCPcFpNVL8dKnNYkXNEQOR/vuBeCbo4Yae1Wa32smQVyfNuWMDBi9dutxatUDBAmUtk
 ZvZ7BWIZ/b1ZyBkxjxcE6GPBp1ZV7I4Symw3e+yErhBM43iKfsRXlsNFBDXWOcMvgUCT6aY7N
 0VCkBuks3LABeIFrT7eQvSSC8Gw7rddA3hmnLLeGcCkrL4YxrZ6N8wBkzNlJlijkK0W+JmcjY
 +fqJx60Nyit6a1spopoQqF09t5KRrcGcZZ+HxkPzmQVrCQ7AiVHVMqXcC0qdYg9wO3gkfAzXF
 FT/PCwI87sqRBA/HTi6AISkk4dlonovDXPz/rxcOngLSNjFQttWKTM1PTeK1PEaVCVlSsH8Bw
 9YsGOvbmw16BChnt0sTZGyoMPyiOxMP8MDi/+nX7iiQRx7W0Yf87f8bdY5Y66TX7OWGFEhqke
 r25zDBxRk+9i/c01SgXpIU+fs7aRo4zqFoTijWNqA0GrRbQewPlQjH3huVq2A5taBCHmxs0r5
 fPjH91nlyQZ+bRm3iFtfXSounDGMo/LfLBZa3tQ4BBZQFZw/tPd8JH7akjcrwqr0EvY1OWUVE
 8T/oOdcRUTqxwkGE7lfguqUnWgsJ7CHEZ07dsHCZRd2pHDccV3aaqyEBA98h6WXcmPXpDFZV0
 e9icNgW3bPeAOx8shBq1NsmzpbLovGpXUHIuPk/0Ljhd5Crl3YWkCeYENf0mSW7V7Ew5QEIBo
 nx172UyWdd/ksg3dUWQ6+QaEMmcys2EilpgnfAlIO41ZVuJCTHexD8ylZNYj/kO7i+CCv4ZFQ
 +wympKeWSYX8PWWb163V3HiDLYDNfE47TufWNF6g0nSjonPvaKsWL55xNInElxLsrCjM6H2N3
 ++XvJFwrlRV7/FibSkctxv5hA6zMVM8opXRu7jywCP4CJlvmkGqg54PTsVcPeM/C8bcsB5R4H
 K+b2Mf/Xn5GgONLqhii7IAzr+efrjoG7lVZXTfK63H6gLM2FlYmwW+V98mqJrbr6AWkOiWfDC
 tifNiZ0odq6ISt4dqVJ7H8SRQaufkZOFQK2LmpDhoK/gTIMVaBB7oxL5iWzd1SR7QGJFs=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jwcYgZVjdvUjugKsGpoFVhVE1lmDRXwxn
Content-Type: multipart/mixed; boundary="bUPq9YjrSDQu0jJrvd0fiyqnwg7b3ezap";
 protected-headers="v1"
From: =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Reply-To: vtol@gmx.net
To: netdev@vger.kernel.org
Message-ID: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
Subject: secondary CPU port facing switch does not come up/online

--bUPq9YjrSDQu0jJrvd0fiyqnwg7b3ezap
Content-Type: multipart/mixed;
 boundary="------------D3C0045A19D403E3C8FD0162"
Content-Language: en-GB

This is a multi-part message in MIME format.
--------------D3C0045A19D403E3C8FD0162
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

{"kernel":"5.4.46","hostname":"OpenWrt","system":"ARMv7 Processor rev 1=20
(v7l)","model":"Turris=20
Omnia","board_name":"cznic,turris-omnia","release":{"distribution":"OpenW=
rt","version":"SNAPSHOT","revision":"r13600-9a477b833a","target":"mvebu/c=
ortexa9","description":"OpenWrt=20
SNAPSHOT r13600-9a477b833a"}}
_____

With the below cited DT both CPU ports facing the node's build-in switch =

are brought online at boot time with kernel 4.14 but since having=20
switched to kernel 5.4 only one CPU port gets online. It is as if the=20
kernel discards the presence of the secondary CPU port. Kernel log only=20
prints for the offline port just a single entry:

mvneta f1070000.ethernet eth0: Using hardware mac address

Swapping eth1 to port6 and eth0 to port6 then eth0 is brought online but =

eth1 is not. Removing port5 then the port6 listed port is brought up/onli=
ne.

Once the node is booted the offline port can brought up with ip l set=20
up. This seems like a regression bug in between the kernel versions.

____
DT

cpu_port5: ports@5 {
 =C2=A0=C2=A0=C2=A0 reg =3D <5>;
 =C2=A0=C2=A0=C2=A0 label =3D "cpu";
 =C2=A0=C2=A0=C2=A0 ethernet =3D <&eth1>;

 =C2=A0=C2=A0=C2=A0 fixed-link {
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 speed =3D <1000>;
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 full-duplex;
 =C2=A0=C2=A0=C2=A0 };
};

cpu_port6: ports@6 {
 =C2=A0=C2=A0=C2=A0 reg =3D <6>;
 =C2=A0=C2=A0=C2=A0 label =3D "cpu";
 =C2=A0=C2=A0=C2=A0 ethernet =3D <&eth0>;

 =C2=A0=C2=A0=C2=A0 fixed-link {
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 speed =3D <1000>;
 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 full-duplex;
 =C2=A0=C2=A0=C2=A0 };
};
------------
kconf

CONFIG_MTD_NAND_MARVELL=3Dy
# CONFIG_PATA_MARVELL is not set
CONFIG_NET_VENDOR_MARVELL=3Dy
CONFIG_MARVELL_PHY=3Dy
# CONFIG_MARVELL_10G_PHY is not set
# CONFIG_WLAN_VENDOR_MARVELL is not set
CONFIG_CRYPTO_DEV_MARVELL_CESA=3Dy

--------------D3C0045A19D403E3C8FD0162
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

--------------D3C0045A19D403E3C8FD0162--

--bUPq9YjrSDQu0jJrvd0fiyqnwg7b3ezap--

--jwcYgZVjdvUjugKsGpoFVhVE1lmDRXwxn
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEemyk2LJ8gvWPJnOR9Pc1kx8Fxc4FAl7vwgwFAwAAAAAACgkQ9Pc1kx8Fxc5E
BA/+I9SWPQw2BKzT8yUgp6mCszjyla+soz68sd+sbbKy1dKYTvjeyMTD05xfovTBWBw3oBMo8iIU
bO3gGmkVvy5gtHlz/pctGHYCEL083JIQMNsmm7gHwDp9/U1kniunKfmkPguivd+j29F1QBj/Qwi2
AqDOmJCS8DTqsyNPUvg1/zwBe0UDQQlPF+QLfMA6aR1nK7pGyH0YlAs5z1KMqyI1tvoFH3EFUObi
J9sPbwieDe2wGgltLa5tMcj0M/g+FA7rjZNnZ1C2TpCJQIQZS/NAmi26H7YrWkiM7tnprFWTgYwW
yOoSlyY91/t2rQ/oRphDcyyKX4Td+1JtLLPCwYfmAwNrIo+1kEE2eB+IViZe8orVNSyVGfb86SQF
2DAIMk2uwRJJPR9djDP3D1rLC4VuJLR/EZqrXKfmUXbsGquAfItXZjb6qz7aA7s+CQthqaDaRBA5
Iy8asgx5ASVoxlv7JJX9Q/EomB8bWFikFqv/U+s8ZBEPbtEiqCOLsoDIRVe9gEFTHIxecG30fopP
XEHJRKZbkAh8XFp2mdUdTygV64f8+iUzN0WNAtvt/aviCo2iXBFtscRuY5KLgBk9G5mdcoFZEEOZ
zklgQlSORshwi4BYC3GPadra8JSSzjrHJNNxLlCMBo5H5PwplmLOZZmlmpP+VWgCzgbEzoZYiBN+
le4=
=2YSP
-----END PGP SIGNATURE-----

--jwcYgZVjdvUjugKsGpoFVhVE1lmDRXwxn--
