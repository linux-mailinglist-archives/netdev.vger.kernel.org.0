Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A97A2037DB
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgFVNXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:23:51 -0400
Received: from mout.gmx.net ([212.227.15.18]:44843 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727963AbgFVNXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:23:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1592832224;
        bh=fKFu92GpIwoqDxRKku5sm7ElRAgZBtmm/0QAdLah3oQ=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=I6mScZPdZO68MMib4DQeXJbHNf5zGQBv/RjUE8IECDLiSvIMJX5/00cl+7APHANFp
         k0YOLcXCFMf42bflK1k9foYr/Ck21QVZHW495dIstvW8/V4lQKhAYPOb7Tib6QxtUf
         8h7jM4r8PwbqI1DbogD4moZd+n1goEdbZo7ArOJU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([149.224.28.87]) by mail.gmx.com (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MEm2D-1jd99H2DXP-00GJ3E; Mon, 22
 Jun 2020 15:23:44 +0200
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
 <50a02fb5-cb6c-5f37-150f-8ecfccdd473b@gmx.net>
 <20200622150644.232e159b@nic.cz>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <7bab9e25-a0e2-6c51-be01-5bf718afb018@gmx.net>
Date:   Mon, 22 Jun 2020 13:23:00 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0
MIME-Version: 1.0
In-Reply-To: <20200622150644.232e159b@nic.cz>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HY4RgTTZh0razvPs7VVETXjwEAUfzjEz5"
X-Provags-ID: V03:K1:1hDAyIiItUIWfK+uH8YcHOeTmYbiid+2R3JP+5GKd9UMahr29h2
 Uk1r4RtYHPM0lGSk2UG6rDuviF/wA3OenPJ9zrLpa0F8hEkalggvVy2ZePyTaUG1m7gBz1O
 NplRbZaD0yDo+T9lUHlXuEINWOzRTGbUbTzgJlBd0CsaEIoIZN76T+p58Yw79x0vSf716MK
 Ui8immIFKJTwQTHYvScXQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:R4Z2ueHsgAk=:7Cm6SDmMGP9OSY3Wl0M6J4
 3y0raZ1cXsIzrHdWEWV7cndaMPslfKhwmjOT8CWkWLM4owiZ22mu/o+m2/2PWaiarNDcT1fnb
 pE7fk8Hn6zpb9cMnvMMulc2d0iJ9s17DaOR9Xj7G3FivXbPJe1yK6rvGYlGCOlnklIEfn/HFn
 Ujk+N/HWm4hUgLgR4grGJ8K/z4XRUzuYpvshMLn5ZvCNPZsQjLeNkhobKGIPFDTY9EjPhPEA2
 xWN7zCyi0Sh+rEiX/zCZF3M/KLA838foJZkX9xVIbjI56G//0H0FNb1wG60flRuqEqGpqFFT6
 mCj0Jcj/wNPf+Rrsknp0srIkSO0tkbassKx8vlwnOg/2A6oa7RjL3URpp7QSmNy/tR5y+KX75
 2zgKyadiL0Xw2iwkVCk/VRL1OcpyzeagGbQyLr4RgzvRD3mbx7+y3gWfOsQDxkUyRm0Xmcww0
 6mAHtK2OmmL8x9SHT+5Pyedcai+dmih9ZAVHNmK97AuFIpyTOD1bzqQR/iq1KkuEOCjkdGoHf
 c3KrkaKtHpFTni8FXAfxOwxkl6cd5CcCPBCuUqm/Mu8yOXT+UfSSH04YCt1Cf5TBucZeyueXP
 VhtX9S2PyvO9tTe0sQTMfCK7latgJdPpUjI5NWeypOK2v4rjjsYHSunfvEJcLq3TsY+6qivGW
 dPGtfvIhfS9oMFB+4pUYhANNjQaLjJ3D5hteZLBvSoe/KhoLZEWUSFVquJISGKRiVgWWVPaMd
 h/0MF/5lfgQ+28RH+LAPLM1bzW4scaEOFlQjFA8mbI8AM5F0DfALYmNwWpfQI7yq2xsu+CM2q
 ARF4PYDNU3Z+TqteFlgBF6x9Eq6wG5jp8fKW2nlHFwNn44jNN5TpEqX0J1dG2guZHChYgNl9j
 CT0eTlfz7qJPu7vkIrjMYC0C5ILZ2bSMe5NWzdrNQjN50igYiaBjXlGeoNtYqQJRY49tWytMU
 VxkDfRCl0wYypWqpay1OLrOYmYEz7oaw5SbxIGgB7K05aA6LI9VvcCMyONFTKsLKaEhQswDQi
 kPFzsZIaPnv71juZwIRnjZ/khr4xIztqFv1vT3iWYne3xgXfYF0LOIoIb8P7rzPUp5kErq7R8
 I55OLL/wmcoEEw9XF2ZwIPAuJ7z0pE0/pxsSMIJKE+q/3MBUPjTkc6SOV4Pp97Ww4kppGb9TY
 7V/aQWMkQx8G1zMNTho5F9NosefFb3zKPpQt9bIxg4wiReHfjdWGjF54jaW8kxfLDr5eU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HY4RgTTZh0razvPs7VVETXjwEAUfzjEz5
Content-Type: multipart/mixed; boundary="STMYv9Q8YIAUhgfji54NYE9iejspqQ2Vb";
 protected-headers="v1"
From: =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Reply-To: vtol@gmx.net
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
 Vivien Didelot <vivien.didelot@gmail.com>, Marek Behun <marek.behun@nic.cz>
Message-ID: <7bab9e25-a0e2-6c51-be01-5bf718afb018@gmx.net>
Subject: Re: secondary CPU port facing switch does not come up/online
References: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
 <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>
 <eb0b71bb-4df3-ff3e-2424-a0d92b26741a@gmx.net>
 <20200622143155.2d57d7f7@nic.cz>
 <50a02fb5-cb6c-5f37-150f-8ecfccdd473b@gmx.net>
 <20200622150644.232e159b@nic.cz>
In-Reply-To: <20200622150644.232e159b@nic.cz>

--STMYv9Q8YIAUhgfji54NYE9iejspqQ2Vb
Content-Type: multipart/mixed;
 boundary="------------99317C1773716D2454D428AF"
Content-Language: en-GB

This is a multi-part message in MIME format.
--------------99317C1773716D2454D428AF
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 22/06/2020 13:06, Marek Behun wrote:
> On Mon, 22 Jun 2020 12:58:00 +0000
> =D1=BD=D2=89=E1=B6=AC=E1=B8=B3=E2=84=A0 <vtol@gmx.net> wrote:
>
>> Thank you for the input and pointer to patches.
>>
>> The problem is that it would require TOS deployed on the device, which=

>> is not the case and the repo being twice removed from the kernel sourc=
e
>> -> OpenWrt -> TOS, patches are neither available in mainline or OpenWr=
t
>> whilst the Marvell SoC chipset is not unique to the CZ.NIC manufacture=
d
>> devices but leveraged by other vendors as well.
>>
>> It seems a bit strange to be nudged to the deployment of a particular
>> repo, unless self-compiling kernel with those patch sets, instead of t=
he
>> same functionality being provided straight from mainline. Are those
>> patch sets being introduced to mainline?
> Hi,
>
> I sent a RFC patch series last year adding multiCPU DSA to upstream
> kernel, but the problem is a rather complicated.

Tracked those on the ML but did not understand why they fizzled into=20
nothing, least it did not look like that patches been outright rejected. =

But that is perhaps where "complicated" comes in...

> I plan to try again,
> but do not know when.

If time is an issue I suppose it would not just do if I picked up those=20
patches and submit those on your behalf to mainline since it likely=20
would require follow up on a code discussion which is beyond realm.

>
> As for OpenWRT - yes, we will try to add full support for Omnia into
> upstream OpenWRT sometime soon. We were waiting for some other
> patches to be accepted in upstream kernel.
>
> Marek

Will have to wait then and see how that goes. Though it would certainly=20
benefit all device owners with such chip design if mainline would cater=20
for it instead of the various downstream having to patch their end.


--------------99317C1773716D2454D428AF
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

--------------99317C1773716D2454D428AF--

--STMYv9Q8YIAUhgfji54NYE9iejspqQ2Vb--

--HY4RgTTZh0razvPs7VVETXjwEAUfzjEz5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEemyk2LJ8gvWPJnOR9Pc1kx8Fxc4FAl7wsN4FAwAAAAAACgkQ9Pc1kx8Fxc7P
nBAAqJinKlXcv0uK09DiEQxkjM8lNwb0IZTWaggaqiU8wyw6SYmFCs9EqbimaFbyOTMiEGBxc0SD
b0HmEgJgwcNU2Eau2VkBtSLCMZXno6Yiu6IUc8e1YycA693tYGAgC5vAOcvKe3xwnDID/y1pSH5I
aiSJfmCYdXAwRX3elRXRQwHDrKj50qwLeyM1iYEBnu15T1WJY11DXJXQelC0o6/xc5SV6f8GdhzT
fsXBG750zOSdUsaUp1olFlInpwCaXHcoI589k21pZTtejaCgsHepUpwxti4nU01p1MRvE6L+M2zU
A2zvcc2iQ9ImZnbfxe/NChspK6FXXkRm+wW5/Bf0UR1imZs2zfQTWDPuMTZNhzOAmswQ8ceFEVcb
3tiQ4DWK/VsURAZF2fNROlTO2Ey26BVPirP825Mhu/PrgmXf1/k3VqDtTlLpxw9CYDz6f8q/B0r3
wLHr91aDBA6Wr/oEQD2LIFYr9KXr+kefnqa2ETtsfLHP8iDQS0GV3/NXbOVvIvWngkyIAlKTAX7H
6NRczxVNeZkNd0japeuLXQRFoyd5OGEWnmKE6PUATP/3hlneVEehw4JFKPpww1OJe/c6lrA4Wvct
p6YKOl0vXzK+rUcxquUekYWPqU0BZI76F21p5KfB7s4o0s6Z3lBtNyFpELm17pqAWFaMVbuPzRhT
Vuc=
=S+QQ
-----END PGP SIGNATURE-----

--HY4RgTTZh0razvPs7VVETXjwEAUfzjEz5--
