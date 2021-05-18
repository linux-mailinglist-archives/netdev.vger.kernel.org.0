Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A58387AEF
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 16:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349926AbhEROUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 10:20:52 -0400
Received: from mout.gmx.net ([212.227.17.20]:38427 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349941AbhEROUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 10:20:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1621347569;
        bh=9gdkS+ok6akvdJZ5nD2LelqvZ4Glf/5iO1OJC5Lpn2k=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=BnDoSj9UNos/MtgfD2/YsbYXneNliZM81VTVTy/Rxc1fKU3tmEcQwnI8D4F7I/I/A
         fbfH+XJVbIU7gYqHf3A5pJ1PDjWllTKNT1E/XyZH3XQExJroDs0ZzGbUugNJpvW9Z6
         hofIavpbWwjpEDu8O8ToGEmEjn4INnZFCw+wLQTM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.78.202] ([80.245.78.202]) by web-mail.gmx.net
 (3c-app-gmx-bs02.server.lan [172.19.170.51]) (via HTTP); Tue, 18 May 2021
 16:19:29 +0200
MIME-Version: 1.0
Message-ID: <trinity-ebe68814-ee65-4efc-b059-e59e7fea5200-1621347569206@3c-app-gmx-bs02>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: Aw: Re: Crosscompiling iproute2
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 18 May 2021 16:19:29 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210517123628.13624eeb@hermes.local>
References: <trinity-a96735e9-a95a-45be-9386-6e0aa9955a86-1621176719037@3c-app-gmx-bap46>
 <20210516141745.009403b7@hermes.local>
 <trinity-00d9e9f2-6c60-48b7-ad84-64fd50043001-1621237461808@3c-app-gmx-bap57>
 <20210517123628.13624eeb@hermes.local>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:6NS2NAJt0ncGcYPKhUkkta34Q+lAq5Vyf0qpulH+H6AGSz4IIN6b3kisVxzLUTPPpKTFj
 T76S7xUl+UWDirP8+ERyszYtSeL23EMfa+gxrGxHg3WtupL1Sz49baEMkwCCn/WV6gIAm9++LQJb
 2dBkWggWdl/UhymY5S+/Wz4jG1CrvPq74H5YmlAqjDE+rmFFtzsC9UG/cQht5iuHWYAotI6JLzi1
 U78SpEVYNlRlz5lGeJ2OfKbazVmm9Qzx0QcjZoPPOR48RkF9iRd51ZOrPCGIj9QcCPOVFvmMNORV
 Mw=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:TPLqQzcLsBo=:TCMcVQ/7UTglCu0G1lAlEo
 XLuhg+y03fLbPfwdg7BiGYqF90D4oufQt4QQJdeFVox+bdFtOFO4Sw0uBYWbv4+VM9qF25D8a
 4HqCEyG/ptDEXeoLRSuCvaGLRuo0gb8jzuYI+m30r5TOs98f8otyEZuCrUx8y6fdwiFKin82I
 dGZP9sEQk/RfOED4Bt06j66/pWNZB6oPCdYzHEuzyIZV0Z0vgpYcQ4dKk9nulnIzkvGWtK25S
 O9I070sRXJ70UsBuyYfkREKNj16CrXx4oOQcDKZ7VyGqZYTs1MrvkG2lmZRMsx+2AZAwDio2I
 MaXe324QaVGOn40Kj8wQdPDgDXLYN3jNM1WANKsC3sPD0nJbwON8rgj+R8WeHoEqol8H2p4Wf
 aDbfscwKj3iyUWVspBxdJrbe7EJh7vgkup5b9t1djNr66YYE1ZUFCAFZRWIqhMH7mD2StlZdG
 U/VKGL6JDE0JNL+YVNifIav6n/8uGLhz2aenKt1oK7Q5vbbNlHLgDpEsY/uaH9gxSMDs2wv1f
 LBdYF/lQU5sRafHZOartYjgNU2IadNTlUjPlUebwHEiawFmQnxumhA7Ijt2b2I50zK57StqBp
 8IV8r79xuou6S68qhcno1wlQxf3aix7kF2gYOTNxLZe+s5BwF+/hYovGxhmPJ+mAXSVoJInrv
 FwjAGO47R/GUfNmARl1mxxmnV1zuA5tMhpcwyLNpJZQnLmDR3B4u2Ior0c5EU4JaTsJU6joI7
 Kqk+wKEOA7pnTSuWCjy8rStO0vQbKmX+PpoGavYQnN891hYZiDhV4cvuRYl6IkHsTk9bX0jml
 4wYvciHg64uczD9Da9kzqWd2bSEgyYyVq8M5/ZkLMBAFKNRteE6xPCN4SwssubKqxq6XsGvSv
 Fnq2JGg8ewZez9VVR6BwSbkKYf0l0jRXDA7HbQX/FuGf6ri9cQttAzZSISQnTheOqy58puYH6
 2oxGEzNV5Mw==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Gesendet: Montag, 17. Mai 2021 um 21:36 Uhr
> Von: "Stephen Hemminger" <stephen@networkplumber.org>
> An: "Frank Wunderlich" <frank-w@public-files.de>
> Cc: netdev@vger.kernel.org
> Betreff: Re: Crosscompiling iproute2
> Cross compile needs to know the compiler for building non-cross tools as=
 well.
> This works for me:
>
> make CC=3D"$CC" LD=3D"$LD" HOSTCC=3Dgcc

Thanks, works for me too, also with dynamic linking (without "LDFLAGS=3D-s=
tatic")

CROSS_COMPILE=3Darm-linux-gnueabihf-
make -j8 CC=3D"${CROSS_COMPILE}gcc" LD=3D"${CROSS_COMPILE}-ld" HOSTCC=3Dgc=
c

only see warning

libnetlink.c:154:2: warning: #warning "libmnl required for error support" =
[-Wcpp]

but i guess i can ignore it

regards Frank
