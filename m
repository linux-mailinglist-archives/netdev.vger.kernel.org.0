Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6ABA1783E5
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 21:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbgCCUYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 15:24:04 -0500
Received: from mout.gmx.net ([212.227.17.21]:46049 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730081AbgCCUYE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 15:24:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1583267028;
        bh=QrYr4WHGQhkr0sPNMQBIpvpJ8zplW0R2sig2tXNPwfU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=LpwQ7l6FcB8oEoscGwus/WT2lgxIT0tlwUGCFSTuU518y11dPnOOQUslzSMqBNJrw
         EFhTvWcSNsexd0sIGcMMDmHj7AaCe70dn/RXNdyO2fOpa5W36jd4uLb9DBxJGU4/g+
         9GTJbI0PXLik+RXn/WI6d8I0kgm8qNOYJ4ylPs2Q=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([5.146.195.177]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MhD2Y-1jdJxu3CZ0-00eNsl; Tue, 03
 Mar 2020 21:23:48 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: networking: net_failover: Fix a few typos
Date:   Tue,  3 Mar 2020 21:22:05 +0100
Message-Id: <20200303202205.31751-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Gz1IwegbMj9/2VEHPx0VwXnj0AmZXWBrJagLObbwy/5G00IDG0O
 jdFNphZqXRrUd4ELf3+bRZLNUpEXhVDCYspYjxipd++V/Yq3DZ+DtSBG36icKxDOu/ARYdC
 KESRtM+MdR/aaBWCWU9Q89F0W5zzbsSRvP+YsNfTi+w0r0n+w8RDXB8tllHx4Bwm0r9CeJT
 5e9KivCqcBjVDYeK4R9Dw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Yz3EBYbFolo=:MqKxqIqsQHpiSeK97Q5YXv
 CmfeCsoJA2CIoClzwMKNmTQhccke2lG/zJOuzKe8z1NjPHoeWq8G9oTS5Vy3/PfQ+kVAPH9W2
 x14VzZivcq0l4l8y8AW8usMrgyIQkwF/p7gdyFedhwwdq85DH28u0U5QgkDVRzq/9SakuvD6X
 i/8grJ0RYkAznwnUwy5kPKxtSghR+p6m5WgVCrVEHG2/4MFRBX7fFxB5LJVTG+VYaTF+bD9pp
 X7u0okUgOyS+oSAEdNLmdvYz5hkXMKbnzUN2/FVq6ZDP3sGgHi3Hz9FG6y71sAz/qMdlw86aP
 D0E8lNehB6t0vqf8CCU0LSC3zso2hA0ZOgSFMJxQqmJaIEgXzKdv/t0K9wofBDu5HQzus6ej6
 ImVH6gR1Rdu3Ht5Mx9hMX1JBvJFKq6NLEAWIGdxMrCAf5DqJzYJCHc0AzquCT3duwqqsL8Oh2
 rh962tM8C9V2Iew9pSWPHeOqq56z87HfJjozqSfT4Wd/EGX6PZPLTq+VRX5fVMMOOwHL1nhSf
 2xCS9CwxF8BQbsGgA+h7vpRqbmpovxINb4bvQl2F4X96I28bEN4BBJildF/qxX+6JBY0CaHiO
 tZ9L4DADpe7rXlQTR1BSqT2UH+WRxa56MI88gpEDZr/VUo5Vo9BVhKCZLRsxHK/CtdIH+eeIO
 nPRBj96CW4B6G3NuS/zNiTFDPjF4gds3pAebwpDAjW5L+0uG3aCfAviOXK3x0cjJmoAGMI2jM
 lsJGpagGodD+9nET8v6he3QxLhCO+CySE3oPTe1cyq7WlnVsXT/D/C+NkU954VrV/ZNUoBsor
 gWTmG+8KsjjxxvQXZ5c9wqwIB9Z+oPrth7cgyExw+2YodKfANxSSelhu/z/s+NkXpXuVgfuuB
 0TK06TOaJcYpdu2YTpcdOCqUTxYmW4VCaGZxltqDDEWPZ6NaqVrTmpyf0D2He+QT4nJlTGwXg
 iE1QuFjkXm8y6YwCVXGPDsIdhpLICrlgiG06IPFHzrdMwTme0tGzcvlCTi1oAcWuZSqJa/MAX
 8uQPKE98viEncAm80ppbV5ZikZRUufgMcD6lX79W6DeQ7StzzgIm2ygIsHtlpyZUZsmqZF4oY
 SP+dZT0ce/+qZGUozXJm7ktfDe/1RhX5vIdjadYal9dmr3i2GTRiD8GLOLdePgdMecWTo5nr/
 PEEJC5k5cVgR9CEb5YhURDhpJRjt802ZPO/hUfzRKNV73DtbwUrEe3cRPspAfBog8aQw9ohMd
 YVUZs1dN8OLKbWguo
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/networking/net_failover.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/net_failover.rst b/Documentation/net=
working/net_failover.rst
index 06c97dcb57ca..e143ab79a960 100644
=2D-- a/Documentation/networking/net_failover.rst
+++ b/Documentation/networking/net_failover.rst
@@ -8,9 +8,9 @@ Overview
 =3D=3D=3D=3D=3D=3D=3D=3D

 The net_failover driver provides an automated failover mechanism via APIs
-to create and destroy a failover master netdev and mananges a primary and
+to create and destroy a failover master netdev and manages a primary and
 standby slave netdevs that get registered via the generic failover
-infrastructrure.
+infrastructure.

 The failover netdev acts a master device and controls 2 slave devices. Th=
e
 original paravirtual interface is registered as 'standby' slave netdev an=
d
@@ -29,7 +29,7 @@ virtio-net accelerated datapath: STANDBY mode
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

 net_failover enables hypervisor controlled accelerated datapath to virtio=
-net
-enabled VMs in a transparent manner with no/minimal guest userspace chana=
ges.
+enabled VMs in a transparent manner with no/minimal guest userspace chang=
es.

 To support this, the hypervisor needs to enable VIRTIO_NET_F_STANDBY
 feature on the virtio-net interface and assign the same MAC address to bo=
th
=2D-
2.20.1

