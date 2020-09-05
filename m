Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39CA25E98B
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 19:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgIERpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 13:45:18 -0400
Received: from mout.gmx.net ([212.227.17.21]:33693 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIERpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 13:45:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1599327910;
        bh=1fe/vJ1rOHh24CiLrMjB+dgifnnffhJfyrHM1VHj3Wc=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=G0gXi6TVaSrIm0BqCFNFos4Cg3clCCU1nTU3mQBVVZdTVsRGmhrmcHiIHrk6sitsI
         Mqd9VNKvdEAEKCAnvRwC92qHvdVs6ISjBTqgWfUYYwcxa2fXpA51SJYWBfb/2oALVW
         A293rvWQGkRBveLgP34BNjhank1n48eH/40heTNw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd ([84.154.216.33]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MTzfG-1k5EKS1a7e-00R1Px; Sat, 05
 Sep 2020 19:45:10 +0200
Date:   Sat, 5 Sep 2020 19:45:09 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH 3/3 v4 net-next] 8390: Remove version string
Message-ID: <20200905174509.GA6930@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:dDxJ5Y7yEhbPj2fWIZkjrvaXLraa2Zukht3Wm/Wg/ojfm2vu5U/
 MZzcPkSUdgFds/ZGPB/YN4Pggw8uLN1+r7x3XDjuVu/+HB2XDiF/cCfTsq6sQ3b3a4HSAaf
 AOinUqmXLGHT9b7hiKG3ZhXgefhOGhnSQaykZodsQh0TFHc0rql32wwsDGc0X4PCg1ZBb8k
 Axauk1oA2YrMS1cTFvpBw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nDhOBGskwu4=:F4oL2X5eU4gEEMaVFpSTX6
 IL63hBs2qB9DihxGdBVoNNNQjA7Yo6Xpm7aqSK+NYNU1WlkyHB0e24dColQJya1RciQeclcrW
 0YqFpI63XIQI1BhOU3vutkXyQ7gdifOETlC3HDGv4ovkX3oxTq+4VUf4xNVs9vYaK2UU0tdyI
 NqmB4KrOVbUDJh07WqTJmWl6FMiFE1/rjU+99Lk4qCtj38TGGYgHfaNZe6GEAyyZ2Q71om9eK
 DDBFlpzqmWkWV3ZJ8VXYuH7PQRKakBpK0PDDTDp5Hw1mSfWfTYzSOu9RgTnYD/S8xb/IEeum1
 7Q6rOzpU3TDazuYSoO1o0sVLf9fHyZYV+BatVOKunm8odpfSTSZEi6F1OZCHfXLo99DQySRK5
 AKFrEzwix3s51U/tRehU4NYGkQX0s+MNNL80lyb8RdUWTKpQg4OZQLz9RXPGPigAAB3Yqm6WO
 dT7VSDxUaG111YGtTE+PqfgVOmkPYwlwQHTxPQIqYvDO0I+kNRr0Iy/DDYrypQqmcMiMRd/d5
 T7RGeyrCH06p7FsZsZvTaAzosEKeKFGVliuSjWC/Xj2ceEnBOOuifHk7UFYFDRo3c3FkwIGnX
 B1+1yrB1FIsN2mV3atnhF3prZnEvniL0CyKexKeobHEBseKAosI0DxWu6wueRmF2KLJJxgv72
 Lf4nlISPlot5kG7rmzrFTorfFA4J6qMrYqy1a3lQGlRsZR8JNmIZmA+DVPbfso1NSptaOUXf8
 uvkW0XbWURXYbdK5f8jazbtb8wwju0n+BM7S0hZElyvCW4DQNk0+pOiT6nhvmlbpZ986NEBXR
 WpU2kpWhnIXSUAXo6dHpO+2risKBIja2d3tdQ8cVx5lqTKAX1q/g/2XowBM40XfQt0eNhdH5V
 bFPBMXgnRDvrjuydynDPBudPneKktq4uFbowU9RL0If0T5x4QMI0KhBMmoWsEHD+S/J3br6zc
 B5/4k3NqtgZH3FTEhHrkIfZ3YxZQnIn9BjFqgGbXJx4a0ar6lWeKXb4u6WqbUQOYx5sxt14Th
 f4cAHvKOQHUx6aFYA04RdFAEcMCaEiY1n6bCW3TeWJfs0lk9k+Bucf7rdsy1FHQK6P/Vijmo8
 T3sBmNMVUxWDHKXbWZl8nIaJ1SvSafWIHPC9K2RfG6kNqLKomWckuHpv6uB2kPsK7vrD0sAmi
 GaKFNCjckhN/J1SULNvElFZQErid5vIC6YjuTgJFNzVY/u8wsmtrrdlTxalLlVB9h1lYBSsnM
 rZokir8n3iCmKIRMI
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused version string in modules which are
including lib8390 and replace him with MODULE_* macros
if necessary.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/8390p.c     | 18 +++++++++++++++---
 drivers/net/ethernet/8390/ax88796.c   |  3 ---
 drivers/net/ethernet/8390/etherh.c    |  3 ---
 drivers/net/ethernet/8390/hydra.c     |  8 ++++++--
 drivers/net/ethernet/8390/mac8390.c   |  3 ---
 drivers/net/ethernet/8390/mcf8390.c   |  3 ---
 drivers/net/ethernet/8390/xsurf100.c  |  3 ---
 drivers/net/ethernet/8390/zorro8390.c |  5 +++--
 8 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390p.c b/drivers/net/ethernet/8390=
/8390p.c
index 6834742057b3..1afd02c2efb0 100644
=2D-- a/drivers/net/ethernet/8390/8390p.c
+++ b/drivers/net/ethernet/8390/8390p.c
@@ -1,14 +1,26 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* 8390 core for ISA devices needing bus delays */

-static const char version[] =3D
-    "8390p.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)=
\n";
+#define DRV_NAME "8390p"
+#define DRV_DESCRIPTION "8390 core for ISA devices needing bus delays"
+#define DRV_AUTHOR "Donald Becker (becker@cesdis.gsfc.nasa.gov)"
+#define DRV_RELDATE "9/23/1994"

 #define ei_inb(_p)	inb(_p)
 #define ei_outb(_v, _p)	outb(_v, _p)
 #define ei_inb_p(_p)	inb_p(_p)
 #define ei_outb_p(_v, _p) outb_p(_v, _p)

+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/export.h>
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+
+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+
 #include "lib8390.c"

 int eip_open(struct net_device *dev)
diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/83=
90/ax88796.c
index 172947fc051a..f2269c387d14 100644
=2D-- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -27,7 +27,6 @@

 #include <net/ax88796.h>

-
 /* Rename the lib8390.c functions to show that they are in this driver */
 #define __ei_open ax_ei_open
 #define __ei_close ax_ei_close
@@ -55,8 +54,6 @@
 /* Ensure we have our RCR base value */
 #define AX88796_PLATFORM

-static unsigned char version[] =3D "ax88796.c: Copyright 2005,2007 Simtec=
 Electronics\n";
-
 #include "lib8390.c"

 #define DRV_NAME "ax88796"
diff --git a/drivers/net/ethernet/8390/etherh.c b/drivers/net/ethernet/839=
0/etherh.c
index bd22a534b1c0..c801cb13ba44 100644
=2D-- a/drivers/net/ethernet/8390/etherh.c
+++ b/drivers/net/ethernet/8390/etherh.c
@@ -56,9 +56,6 @@
 #define DRV_NAME	"etherh"
 #define DRV_VERSION	"1.11"

-static char version[] =3D
-	"EtherH/EtherM Driver (c) 2002-2004 Russell King " DRV_VERSION "\n";
-
 #include "lib8390.c"

 struct etherh_priv {
diff --git a/drivers/net/ethernet/8390/hydra.c b/drivers/net/ethernet/8390=
/hydra.c
index 941754ea78ec..5b27e36729b2 100644
=2D-- a/drivers/net/ethernet/8390/hydra.c
+++ b/drivers/net/ethernet/8390/hydra.c
@@ -36,11 +36,15 @@
 #define ei_inb_p(port)   in_8(port)
 #define ei_outb_p(val,port)  out_8(port,val)

-static const char version[] =3D
-    "8390.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\=
n";
+#define DRV_NAME "hydra"
+#define DRV_DESCRIPTION "New Hydra driver using generic 8390 core"
+#define DRV_AUTHOR "Peter De Schrijver (p2@mind.be)"

 #include "lib8390.c"

+MODULE_AUTHOR(DRV_AUTHOR);
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+
 #define NE_EN0_DCFG     (0x0e*2)

 #define NESM_START_PG   0x0    /* First page of TX buffer */
diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/83=
90/mac8390.c
index d60a86aa8aa8..1484497e4df5 100644
=2D-- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -41,9 +41,6 @@
 #include <asm/hwtest.h>
 #include <asm/macints.h>

-static char version[] =3D
-	"v0.4 2001-05-15 David Huggins-Daines <dhd@debian.org> and others\n";
-
 #define EI_SHIFT(x)	(ei_local->reg_offset[x])
 #define ei_inb(port)	in_8(port)
 #define ei_outb(val, port)	out_8(port, val)
diff --git a/drivers/net/ethernet/8390/mcf8390.c b/drivers/net/ethernet/83=
90/mcf8390.c
index 4ad8031ab669..7e30a7524cdd 100644
=2D-- a/drivers/net/ethernet/8390/mcf8390.c
+++ b/drivers/net/ethernet/8390/mcf8390.c
@@ -20,9 +20,6 @@
 #include <linux/io.h>
 #include <asm/mcf8390.h>

-static const char version[] =3D
-	"mcf8390.c: (15-06-2012) Greg Ungerer <gerg@uclinux.org>";
-
 #define NE_CMD		0x00
 #define NE_DATAPORT	0x10	/* NatSemi-defined port window offset */
 #define NE_RESET	0x1f	/* Issue a read to reset ,a write to clear */
diff --git a/drivers/net/ethernet/8390/xsurf100.c b/drivers/net/ethernet/8=
390/xsurf100.c
index e2c963821ffe..6f1e3d539346 100644
=2D-- a/drivers/net/ethernet/8390/xsurf100.c
+++ b/drivers/net/ethernet/8390/xsurf100.c
@@ -42,9 +42,6 @@
 /* Ensure we have our RCR base value */
 #define AX88796_PLATFORM

-static unsigned char version[] =3D
-		"ax88796.c: Copyright 2005,2007 Simtec Electronics\n";
-
 #include "lib8390.c"

 /* from ne.c */
diff --git a/drivers/net/ethernet/8390/zorro8390.c b/drivers/net/ethernet/=
8390/zorro8390.c
index 35a500a21521..75df604801cf 100644
=2D-- a/drivers/net/ethernet/8390/zorro8390.c
+++ b/drivers/net/ethernet/8390/zorro8390.c
@@ -41,11 +41,12 @@
 #define ei_inb_p(port)		in_8(port)
 #define ei_outb_p(val, port)	out_8(port, val)

-static const char version[] =3D
-	"8390.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\n";
+#define DRV_DESCRIPTION "Amiga Linux/m68k and Linux/PPC Zorro NS8390 Ethe=
rnet Driver"

 #include "lib8390.c"

+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+
 #define DRV_NAME	"zorro8390"

 #define NE_BASE		(dev->base_addr)
=2D-
2.20.1

