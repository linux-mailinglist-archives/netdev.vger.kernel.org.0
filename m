Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CB5410557
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 11:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbhIRJPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 05:15:20 -0400
Received: from mout.gmx.net ([212.227.17.21]:47867 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238246AbhIRJPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Sep 2021 05:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631956430;
        bh=mFkD0OEJA6uT1F0RkgVK0P+3Z6ZEDQgaY+IQrIA10cw=;
        h=X-UI-Sender-Class:From:To:Subject:Date:References;
        b=JuAuh4vtyJhHZg8oGSIvFzKSIuZOFhnHa53SSvSnBcPB19cCj025pGjvm0UqoBrGg
         335NQ+BfW8jGrjPVhLObMGbKliTq6lC6NUpL7aZ2Fcmyxc1S5COeXF0WXKOrWuz7vK
         MADsNwHYj3POxqOgW6dBliDlLHkHsjA8oM+GG//Y=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [91.116.33.250] ([91.116.33.250]) by web-mail.gmx.net
 (3c-app-gmx-bap22.server.lan [172.19.172.92]) (via HTTP); Sat, 18 Sep 2021
 11:13:50 +0200
MIME-Version: 1.0
Message-ID: <trinity-4af44d6e-0702-41de-880a-95b7181570dd-1631956430822@3c-app-gmx-bap22>
From:   Michael Hubmann <michael.hubmann@gmx.net>
To:     netdev@vger.kernel.org
Subject: Adaption request: IP-VRF(8)
Content-Type: text/plain; charset=UTF-8
Date:   Sat, 18 Sep 2021 11:13:50 +0200
Importance: normal
Sensitivity: Normal
References: <trinity-bb3fc75a-1467-4d9d-b3dd-220b88364fda-1631913484949@3c-app-gmx-bs71>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:LHqTXprCtWUIaubWYuph1Wh9u318cXM8vhQW48quy5dbqAA2Csfz8rCtRMbqBvGq59VGU
 odT/VoLJvWzO41dABOcs/z0u4LpIF1cqAaJdQj6VwmTdQH+EVA3krHWhuxT3+nBcl1X7s3Ow2gsV
 aTcZAJeneuTHD6kZHGJ+8Q8yxYdJwUDxy3k3MJXdCaZeJALHA8n9U5caVknyVnCILyafdQ0fHOtU
 mBEs8QxE8NQY/62TBkMEZfu5pexJnMejMrbEtG9TJTVO2kN/OOFUun+bBtxVPs8XEcADbcYLYK5J
 Gc=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DvdJ9PfBMrg=:hdvTzKwfG6/M3CC2kTv4zQ
 bpyNKoI/qbJJFKl+QkzNu0CdrL/Pc9ZgoL0fk6Z2xiNFWA7qbztyix3Z+ykgni5J/ZhDubvpN
 rhFNIdvvwMx5fnBrhR9reScwIpps3HGwGYFrrzaLBhXopiLgvhIZg4+RiwRVgHGjQcDwVV1//
 QH2WVUlU5urq+iUVfCSJyCoaquzcpKuC+VQIHeS/BrZAnoNrQFvO2ajKimOcJ57+sBeP+UFyi
 UrnB6XrrRJc8jG2g4kNVd2MzYUv1SYvgPUGSGlNa4kZuGw/l+U3jZP1/21BAzAAq6fNT/gDOu
 5NQKVEerIRsDeCEhGftSPnie6zt/H+6p11lVAKPK2rJE8UI/rICNYs80/3Ezr1XmNjDu8m+TQ
 +koJUXy9Q+zoVYxvkh2RnQc4FExrBPpPQ/oDhziL+WY94B0L87z5X/LlNZpJciRA15VsLg1YS
 iON9UtP1giOpaNUXgeEGkDuuENdCy0TIQD1kPqkdfN/tHZQRmwbWMFdnmsd12esbtLhVRXGa5
 qmkHzuoe0lDNXtJSGd/Nxapao3+G4whLm1xQsABgqgq398tC/SpAjV/f4O0ksWWZ/s/pVv5XP
 1Y51pIbfif8kiaHPR3A1zrLxuu8OkL3ynRTbBOlZL1W4zmTbLJIviYbp6JBgSj6VWKgb5RTr7
 /D/RoliJjzgaQO7D6vz7urRnbQYA2LXwOe88d16xW3W52PFxbAj5yAWVERPODqiyXDed+FfoV
 ign9RWppuV2r9oG1ijJIf5J74L5Z1tMUx5aBSdbSzRhVwZLzsaAZHlIfnB8g+AlUOI3g3eHbA
 cLUcVIG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
=C2=A0
checking through the man page for the ip vrf command I have detected a wor=
ding issue which should be adapted in my humble opinion=2E
=C2=A0
I am referring to the word 'enslaving' used in the following extract from =
the mentioned man page:
=C2=A0
--------------------------------------------------------------------------=
---------------------------------------------------------------------------=
-------------------------------------------------------

DESCRIPTION
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 A VRF provides traffic isolation at l=
ayer 3 for routing, similar to how a VLAN is used to isolate traffic at lay=
er 2=2E Fundamentally, a VRF is a separate routing table=2E Network devices=
 are associated with a VRF by enslaving the device to the VRF=2E At that po=
int network addresses assigned to the device are local to the VRF with host=
 and connected routes moved to the table associated with the VRF=2E
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 A process can specify a VRF using sev=
eral APIs -- binding the socket to the VRF device using SO_BINDTODEVICE, se=
tting the VRF association using IP_UNICAST_IF or IPV6_UNICAST_IF, or specif=
ying the VRF for a specific message
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 using IP_PKTINFO or IPV6_PKTINFO=2E
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 By default a process is not bound to =
any VRF=2E An association can be set explicitly by making the program use o=
ne of the APIs mentioned above or implicitly using a helper to set SO_BINDT=
ODEVICE for all IPv4 and IPv6 sockets
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (AF_INET and AF_INET6) when the socke=
t is created=2E This ip-vrf command is a helper to run a command against a =
specific VRF with the VRF association inherited parent to child=2E
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ip vrf show [ NAME ] - Show all confi=
gured VRF
--------------------------------------------------------------------------=
---------------------------------------------------------------------------=
-------------------------------------------------------
=C2=A0
Thanks in advance for taking the time for having a look on that=2E
=C2=A0
kr
Michael Hubmann
