Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E13453250
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 13:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhKPMll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 07:41:41 -0500
Received: from mout.gmx.net ([212.227.17.21]:51487 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236153AbhKPMli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 07:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637066308;
        bh=IldbH7+Nh8vavQRf4Z1tA5ywCiow6Il6q/UYWGWkhqM=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=QGW9nzuuSXqMNWwED/LRSMpyh1CvueXLjV1Q+t3XFRtK90gRR3lTeltLeswYNSkjh
         yHvyolt6M6BojU+c7WdNWoex57TXqGEQeFvbEkdHmhXMA5+2+JTHRX6xaR6o4T+yAW
         ON+tDlSQ+F1TYnJG5S/lYOThd6HESi+S0huWtW6o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from ls3530 ([92.116.177.193]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N8XU1-1mZP6I3m5J-014Pd0; Tue, 16
 Nov 2021 13:38:27 +0100
Date:   Tue, 16 Nov 2021 13:38:25 +0100
From:   Helge Deller <deller@gmx.de>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Cc:     parisc-linux@vger.kernel.org
Subject: [PATCH] atm: firestream: avoid conversion error during build
Message-ID: <YZOmQf6PM+SXiTHX@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:chRwamAOy1bXyppeb7yz02tFP8eE6FKl/BIReqonkZam0roliVh
 RhoFNhdBlapcHEJFVwPVzN+vYwFfceSRIGu/1O/WsPVwv6HzAFJbAQ+qysI3X6/A52qXFRd
 JSVaqHxE9YsASOdwexSrt/Ilhi30TosBUWoEp9fqbNEGFDEB48rNQ/DYMZ2xZrIQd8a0mPq
 ntAJ9K/GG0B8Mr6gSTQWw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:FzsX9cnBC5Y=:7vAeT6QJZMpsJVb5N+UCZm
 /wCboUjs+aJkH6+1TUW1ftYVjOIUify8M5SNBMcsqBe2rvpegNaMGb+6EYOq9nsV73TGcWtRo
 cgiYmGvuMRToAllKQeIA8BjQL65ROyGh57A4WX4wEPCoBYVVGhkL5QENqPhIpVVnqmouPaaYs
 Jir13BTAvIAThMHPKFC/UC2OthbRy4FGb22qJzG+U2In4a5B1hhb2AqZ8GcKByFK4hGeWlts5
 FL4nz8h/8Ji/ci/G5M5l8JmMSGp57mGTykixoYcBavFzblF3AJnWikmPn4gCcjPJhvbMrazyR
 kBU26CAZ6IsysYsbKkyrY2mRA4Fnh1okgPxrbIHQlN/PXrWLdYryHxcqeKBLvIEbH6nVhXDXD
 Faj+vo8poZDVvO2vTz9wVckd6/qq71NlneldS+trreEpMme+4lgvdFthrB3G0n2Z/3nl5vmG2
 Rp66U90cqOIJX7k/+7uDD3I6VRlI8lKoPqxlVXf8p7AM9cYd5VILGV3ZbtgC0ABydTe6+wvy9
 swOsQlYRIGQrIKNLbGA3vb5euvkv9FFoHc54SgO6F2QiZgok72E72EMth7hOii1SuKfR5Gl98
 OXTBSSxgkIS7/W2amJ0ebIASq93R/Y9nvUMjSiVM88DRLGGTItS9JDNuDWaSplDiAgjtLId27
 hWFwfj/JCp9ayiHRYCp45ppmm3+VmcVQpewCvL3uv7DBOY8NYBKtXgWYCLut+xhFlqXhp349F
 dKjvPKTgr5Ou3efcTziobtjvbATnnndYWsGsz2gUmyIR2im/e5SU1n2ge3mEPPpkNtmWKstJJ
 JgxKMzJGKFZhmP584B933HaZHQRSI8eoDG3/oXe7usP798WSO96rISmcIeNhFrGM5TXNvJjO/
 zGe2BrQYEZB50VmpXqyobQyeaynM9hllY0hB9KCdqy/ZpFzswXH9p9H9m5aBM8qjIPEkdu5oI
 JOwky+azAO6P0fj2fScqYYcvqrkkihaa7DDnezOHUJp/4WwnLXB7FpbO00I9FnDZcbFK4NClb
 Baot8Mf3aT++arI3zCNfnC1/9W1lSDuInOL5/T3N2OeiNbdhWl/6GrGKRplt2otxCbnlqWAcF
 Mq+fw77hFfhPSM=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although the firestream driver isn't relevant for the parisc
architecture, but it generates this compile error when CONFIG_TEST is
defined:

 drivers/atm/firestream.c: In function =E2=80=98top_off_fp=E2=80=99:
 arch/parisc/include/asm/io.h:8:25: error: conversion from =E2=80=98long u=
nsigned int=E2=80=99 to =E2=80=98u32=E2=80=99 {aka =E2=80=98unsigned int=
=E2=80=99} changes value
     from =E2=80=9818446744072635809792=E2=80=99 to =E2=80=983221225472=E2=
=80=99 [-Werror=3Doverflow]
 drivers/atm/firestream.c:1494:29: note: in expansion of macro =E2=80=98vi=
rt_to_bus=E2=80=99
            ne->next  =3D virt_to_bus (NULL);

ne->next is of type u32, so this patch avoids the error by casting
the return value of virt_to_bus() to u32.

Signed-off-by: Helge Deller <deller@gmx.de>

=2D--

diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 3bc3c314a467..8148a4ea194c 100644
=2D-- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -1491,7 +1491,7 @@ static void top_off_fp (struct fs_dev *dev, struct f=
reepool *fp,
 			    skb, ne, skb->data, skb->head);
 		n++;
 		ne->flags =3D FP_FLAGS_EPI | fp->bufsize;
-		ne->next  =3D virt_to_bus (NULL);
+		ne->next  =3D (u32)virt_to_bus (NULL);
 		ne->bsa   =3D virt_to_bus (skb->data);
 		ne->aal_bufsize =3D fp->bufsize;
 		ne->skb =3D skb;
