Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1DE3432A9
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 14:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhCUNAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 09:00:46 -0400
Received: from mout.gmx.net ([212.227.17.22]:35567 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229903AbhCUNAV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 09:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1616331614;
        bh=pYEGD5aDkwqkETZ565wl6BHWv+40qi9miS5iDIIHvHc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=jId4+iWDHdp1VoiMGFF/Ud6DPmFTSfB83vsWYPsLj71pVyz/e3yUBo5712DG5i50u
         SkZRbIDZi8c3SG+TVzVVCXMKmOGk/GFnebDxuhp9nWWZ+unDG8Tu56VKJE2ciCCh4v
         kZ3nXMx2HRi3fStGNmrwpkYs1C+xEGsWQH1YfqO0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([37.201.215.134]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M8ykg-1lHvo02DKQ-0064j5; Sun, 21
 Mar 2021 14:00:14 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     Coiby Xu <coiby.xu@gmail.com>, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Combine "QLOGIC QLGE 10Gb ETHERNET DRIVER" sections into one
Date:   Sun, 21 Mar 2021 14:00:01 +0100
Message-Id: <20210321130001.1029965-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:RPYTef1eUIr5pXM0RyzrBWMnpIUB1qNgL4njUwoM/YQbIwagrTf
 dogzw5ncl0tU4ku7oXxMo4ePNNwGGBWaseX5iBpMYBlb6S4fXICsQOGf7rY+zjnq4zrbQNl
 PqVdWDIlLI3N52g+gUHWVpd6i3Cy2Ir4IUgKGblldCxUU3I9YAKvkKqd3H/t0AVYX1DaeZu
 4dA5fQwto7FPRXTVSN1eQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:m3nG+Y8rKec=:1s5uwF8l3NLlxFmqhAoyFL
 xzbTD//PNTb5u4vxnmzfne2YDjPxrhG9r2Cj5X3DRvZ1foXv2KUxGWHcr4osm52qRjN2bFv39
 y1O+rW0+mDxhKX3Zz0mEF0U5iRXmlPptiWF1V8yJ9WjorYvsmd9gra9neTCpKHCTEThGzd+5Z
 wwUyKJQDcJUnv+di7cY8h0TzdvBeqDKkpirIS12wZBd96GCFH+badXdi+6tQNkImf6+8Tzikp
 m0eiZZiF/+jyUAx1FtkmP2zA+/bvYEFaTx6+QX4cilj0O9EyGwZHQ+K5456oHj/L8ouI6DPG4
 yD5RTIMwka2DAWXQ/7kW+ilrq2im47cvOet1/qdfr7ymWCNQNJEDtL74oKIhBUcZiQXQi4vCw
 RoCc+yPyjoOWyR4gjpysPuNEc7HtqPKNCoy277oG+UX3c9SFiAI8OWjcmW8PTilKNx/ImsYNP
 JivSAM6wyf/v3RiPU1rkCSqasooUoxDkGjwPcpKj2yl5fptEP32cN7WYn6j1+2VDUYol6bHFF
 C95oNYe+eomHz3DQPYWAQqaLitdahmsOG4c2YG5HYCRdE/xz0Z60qKzEYSomJnutHwEddh3QN
 /V4sx7PuU6Uv141PSUzcNqepw+43Fj38MQUp4SBfRAE7d7qmDjhqObb+1tvkde1d+6eugL8On
 NPUwQ/A8+lSutX299s5HFHsr6jK5Po0I4felcKaFXoexbR32h0IsOcG8fHFml0sJhICG6jtRN
 n28CcvOJ8dH7ZgHGNzWIyiBtUQURxd1u8FQuBNbcB/nT7d9fuI+CiQzzlS0Q9+tXsCXdCQCeW
 QC9NVnYXe+Qn9CKWUAQvgToSVPjowartQoaRBKbG40clsj/OWZgQYCn0GIOmACDPbnxT3JaLZ
 iKp1cnNCFIHVqowF8cbw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There ended up being two sections with the same title. Combine the two
into one section.

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
Cc: Manish Chopra <manishc@marvell.com>
Cc: Coiby Xu <coiby.xu@gmail.com>
=2D--
 MAINTAINERS | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d92f85ca831d3..a922afdf080d9 100644
=2D-- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14708,15 +14708,11 @@ F:	drivers/net/ethernet/qlogic/qlcnic/
 QLOGIC QLGE 10Gb ETHERNET DRIVER
 M:	Manish Chopra <manishc@marvell.com>
 M:	GR-Linux-NIC-Dev@marvell.com
-L:	netdev@vger.kernel.org
-S:	Supported
-F:	drivers/staging/qlge/
-
-QLOGIC QLGE 10Gb ETHERNET DRIVER
 M:	Coiby Xu <coiby.xu@gmail.com>
 L:	netdev@vger.kernel.org
-S:	Maintained
+S:	Supported
 F:	Documentation/networking/device_drivers/qlogic/qlge.rst
+F:	drivers/staging/qlge/

 QM1D1B0004 MEDIA DRIVER
 M:	Akihiro Tsukada <tskd08@gmail.com>
=2D-
2.30.2

