Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918FC26974F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgINVDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:03:01 -0400
Received: from mout.gmx.net ([212.227.17.22]:50365 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726154AbgINVCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:02:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1600117319;
        bh=Pw/W9LlgS7Yv7ifJv5o2A8bKo74NTKirp/rlrO7ug8M=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HywVThE6o331I48kmiGuBm0UYRxBodXZNGdz3dtFtthLu7rrGxO6lHFH9VQ+3PzjI
         /TJrOp+jqfXQ443Egj0qbdPEJ/goRHYY1f7cxy/ScQgqVwudDajCTRupkWSRu7Icm8
         HOLU7NuvqxmRvHj1WphtGh1S60gd5wEOYZ2RmNRk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([79.242.188.32]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MUXpQ-1k95uB04Ho-00QV1T; Mon, 14 Sep 2020 23:01:59 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v5 6/6] 8390: Remove version string
Date:   Mon, 14 Sep 2020 23:01:28 +0200
Message-Id: <20200914210128.7741-7-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200914210128.7741-1-W_Armin@gmx.de>
References: <20200914210128.7741-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Yduu6o6nC3JlHTKh3ODgBOObrYiqfMfFK9gkHVTMYjmU/9rXzBb
 2oSu5OvISqv91HtSE11vKZ/unqlNiwX9MsGHXX9euaJmYoQg4j22CFmGvu6Y/9LV314+Pr8
 XvfxoWiDeD0Ygo6Lo56yuvbeIGy6V14ysFzZ9qiU7+1FDJALOI7sCFAkzfRMIRSDnWZIQ2J
 VKkphduavO5ccvls0XdhA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:pbPyEJeFXfI=:ulof0SpGhB/31L696iLX5N
 cTEqtWrlSOMPNsnvpsYAXW0HV477U5VQbyFoVuzwZyv94MmRY1O8smyD7ewFk62sen8Fndrq2
 Jp0kp7HlRsBbm9uhfX3uOlVi+ehZ0DK0YUzcoOuPVZLJL551BssiGmgnvQOZSVDr2sDCq17Ue
 qn3Gf70CS9vUov/ixq6ePn2BX0H0OGXxgYYbrVGUYv1EK5g0ddhiwB0BPn1CdhYASEyzWfu0Q
 maxexKfP8mT8fB2UpFhIInRb8YbCzYb3OSSmrNOcHWSFFRtMI7zrLP2zVotPaoeb5wr8XXgNi
 sUwiW4uWj+vUMKoedZRcXkMxlbrTSYcyRRXvP94et+qAj29XmbsbJUA0BC5dQH0HKnJh6DedO
 ncd54QegW8W511W27IADhWtBPYEwufDsqYymAfVJZQikhIVcXTJbdWMMX736V5Jh4d7zOjYlP
 kPvbWQj5B6JfO8NBdKUILxCitk/47YvT6+/QmlnvrZBuQ4tjYBYyhTwg4wh10USCtkyE4rUwB
 JOgzt71j4Fp9ksgSQcNp+bW3lBRCMgKPjpze5SJg0uqBhngwCQA6pthg0450evb2+kpYJM+Xy
 aWF2bvQsez8vx8j2r9uUHmjvEQZDKlZzBw6MBtvNtCl7d/mhKAxjTyuYk1DHwJJaciMi9j7Fh
 ORnC6x//wwvB78h1MxPMUPaC2aQV+YFHxLGrUspxA0Fg1NKaPkzuU0WpRYJ+v5GcYvDGkOezX
 jsy2TVzgBUJdi1XEkXdILBuX4HDjuqJJN3pZqw9skcO7D1l2kg6HqMZxBtKU/6dya5K2Oe6+D
 WA2O+mjHAFrEgygwXx7C36PH1VzpjmYhk/iq5H1NBllcwitAJUpVLwOB0wCokMm2vcHEuFnrh
 kNrr3jcFeoAxK2E+Nmo7G033GIVZ+JBQWgy2YkxVXivkZ24G9CecsB6hWI4axmhgSR6BPGWmd
 Ms7lpZ5K/iNu/xH1s4WpQ2JV5wGMnugNEcvmJIFE28b1bsJTANvyGNS/pab2elkvydb23HYkY
 IHqQaa6qm7NeHy09LBCllv7SQr/OObNosTBw/YDl2GZbg6e2FWPp/azU5zG9gooMzuBaHaKib
 rqst1xoD8zhOzvqym4xLgGjQKoJ7xmLnGFdauX0h2bRhm5gGbyRQu8Qrs0mbTCIIyXGJke8Iw
 eZZyfBJFwt9BpXKzcXF3WT4x6qrK5Jrj5JlbmoPUfKbGTMmlCrLGS3zVQ+cEgfn5KBeBc/+Iu
 lxAt5+I67BVypLged
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused version string in modules which are
including lib8390 and replace him with MODULE_* macros
if necessary.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/8390p.c     | 15 ++++++++++++---
 drivers/net/ethernet/8390/ax88796.c   |  3 ---
 drivers/net/ethernet/8390/etherh.c    |  3 ---
 drivers/net/ethernet/8390/hydra.c     |  7 +++++--
 drivers/net/ethernet/8390/mac8390.c   |  3 ---
 drivers/net/ethernet/8390/mcf8390.c   |  3 ---
 drivers/net/ethernet/8390/xsurf100.c  |  3 ---
 drivers/net/ethernet/8390/zorro8390.c |  5 +++--
 8 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390p.c b/drivers/net/ethernet/8390=
/8390p.c
index 6834742057b3..2305dbf74d79 100644
=2D-- a/drivers/net/ethernet/8390/8390p.c
+++ b/drivers/net/ethernet/8390/8390p.c
@@ -1,14 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* 8390 core for ISA devices needing bus delays */

-static const char version[] =3D
-    "8390p.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)=
\n";
+#define DRV_DESCRIPTION "8390 core for ISA devices needing bus delays"
+#define DRV_AUTHOR "Donald Becker (becker@cesdis.gsfc.nasa.gov)"

 #define ei_inb(_p)	inb(_p)
 #define ei_outb(_v, _p)	outb(_v, _p)
 #define ei_inb_p(_p)	inb_p(_p)
 #define ei_outb_p(_v, _p) outb_p(_v, _p)

+#include <linux/etherdevice.h>
+#include <linux/export.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
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
index 941754ea78ec..28b55ac578c9 100644
=2D-- a/drivers/net/ethernet/8390/hydra.c
+++ b/drivers/net/ethernet/8390/hydra.c
@@ -36,11 +36,14 @@
 #define ei_inb_p(port)   in_8(port)
 #define ei_outb_p(val,port)  out_8(port,val)

-static const char version[] =3D
-    "8390.c:v1.10cvs 9/23/94 Donald Becker (becker@cesdis.gsfc.nasa.gov)\=
n";
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

