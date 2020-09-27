Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768EF27A3CA
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 22:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgI0UBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 16:01:38 -0400
Received: from mout.gmx.net ([212.227.15.18]:40363 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726942AbgI0T5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 15:57:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1601236631;
        bh=A37BwhthNeaG9NdH1BxOIfBwiGGWhAtuMmCaW6IwrRE=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=iuITyLgM7rv+ZW+mjcOANoXcUbPs38rWhT7E5yy0E9X0Ffk27Ql18PcGaFNChPPtU
         U7wioBBXwxSSqvR7y+gG4l+/bNmwpVb1rmQXO1rKu3UE4EX6UQmqSHl7XznzW0w30f
         xMVyinsRO99U/voo/GFErRE1sR0t+FyXj27vuFYc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([91.0.109.210]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MStCe-1jzxU048QY-00UNJj; Sun, 27 Sep 2020 21:57:11 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next] lib8390: Replace panic() call with BUILD_BUG_ON
Date:   Sun, 27 Sep 2020 21:56:59 +0200
Message-Id: <20200927195659.4951-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:MXqjNq+vXGcAIs4fLErTURvM3T+nSf2YF7DR4YB6XoX6SoqpF3m
 49V5s3MaC+5xDV40Od7PfNTuzfUnQADIyM4TRtJRJKXigOPZwgBZHt5caFjWBQ2wIZknTDp
 vI6KfmCfnfPQhqa9FVJ/rSASAnpQ+KJhDvUUPqOb5lmcxz5ZKjwGluzeAzlSbTUYxlYboez
 g/IwXsPnTPoDnoKjCy6Yg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gc07HwPTWLU=:+/1gNACtA5i4eO4L9L+Rxj
 s8vu+Kt9x8alZ7x1/SksAU1UgrD7DJ9QMfpr87r0ISbbLOXHBTqQtI8KVKtsPkDzwGPjz+fOB
 FbKpgfQm56ko5hUYCJlbJCbn/n51ajECyMIzvLSz0voQxzrBaoO53jAzZCI+a12MX8cBRczXm
 Cl0uVPD6/FxEoJSDiWj+ob3WyerLX7rw8wLYJBBM8LxvPvH5zyX2btZphI9oXEsx6h5DAfDOZ
 si2BriyvMOkeIaeXsXe+6WjeIQLJJz7AJNnlDy7DDtAuyco5QPFfL4SrQ2x3mu21gpHZ7hWnO
 g78y1ZNn+4ZGb01+98Q/ETdMcmbpskit+MSnwNqwhP5VUuGvh3+3k6b8VLfzvQfVPpwNN9Nna
 3gc5MrNpwL5vDnlZNhmGdZOFYAvGygZYq6Jh53yrWIC2PltASmf9BRueUpg0gx8D4ErtkFkpi
 emBAgOGx5xB91eBiiDQBOlRWhncNZ7z4c/qob1YRqwkG0BofyGD+zDHjjBqH4Niu45zpZ5CJ9
 bWAKa/DzsRnEG+KH/wlXC9inKXsE1jYG3P8jNEN6B887F+aXUqz84Xe0wUdH1Ouz+BHxgtWnX
 lnE2Vtr3qwXn0tYHDFqS6eGa6YuF3dZ3MYw37iNZroA4JkV9LAu8Nfl+TxAry9yeif2HSavEg
 FReykGIJ1AyWfNvAXZtbkbJCC75L7PtW2lPloRJ2t9CQS1pbY7VFQTmCuEmL3RhX+sv2eeVgu
 V3aLkh8BjXHKu4eVqm1TbAZAYqpsS9pz09SmZyUiQia5Q5N68K49gj+mjKuB1Xnle55JeVhgG
 xMLLNhIsLHyi8zwp3pSJa+xH+9qjJBivkhR17vtfkv6uq/OD+GrbpnwrOy6Z830QJFXq86KG2
 3NjFV6XMZ1KRv6JdFia7SoD/Vwui/AmmRDxb/ue9BXVIWZ5vpbOUrodnxUCDHVDn52i1xDBgM
 tFuOuqfwy3ujDDakyre+KZzPOxt2RohT4X7kXgtsedYCZpLlYQSzfZK5MAfyS3ggINJ4IG/8y
 er+pL4gC9CWzNSsgOdWqQs48aohTp9UcjkkHFsyLUb4DHQPcGyWqg81Hvsv3SMMUZiowP+yhM
 uYtYoqw2Y9CaZ7qbc5eQqDE2mvnCEpFG3O06nty7tZvSAttHFv346YHnHFMtchB1Zixy7yoEW
 gopwCiubVNmu5EsrekJVAsEU22oT8zSWTcx74V3ADWuXRRcWUPMe+CDS6WmjQOjgriUI+2wGy
 e4aeMcd7t9YXVGf/U
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace panic() call in lib8390.c with BUILD_BUG_ON()
since checking the size of struct e8390_pkt_hdr should
happen at compile-time. Also add __packed to e8390_pkt_hdr
to prevent padding.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
 drivers/net/ethernet/8390/8390.h    | 2 +-
 drivers/net/ethernet/8390/lib8390.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/8390/8390.h b/drivers/net/ethernet/8390/=
8390.h
index e52264465998..e7d6fd55f6a5 100644
=2D-- a/drivers/net/ethernet/8390/8390.h
+++ b/drivers/net/ethernet/8390/8390.h
@@ -21,7 +21,7 @@ struct e8390_pkt_hdr {
 	unsigned char status; /* status */
 	unsigned char next;   /* pointer to next packet. */
 	unsigned short count; /* header + packet length in bytes */
-};
+} __packed;

 #ifdef CONFIG_NET_POLL_CONTROLLER
 void ei_poll(struct net_device *dev);
diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/83=
90/lib8390.c
index 1f48d7f6365c..deba94d2c909 100644
=2D-- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -50,6 +50,7 @@

   */

+#include <linux/build_bug.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
@@ -1018,8 +1019,7 @@ static void __NS8390_init(struct net_device *dev, in=
t startp)
 	    ? (0x48 | ENDCFG_WTS | (ei_local->bigendian ? ENDCFG_BOS : 0))
 	    : 0x48;

-	if (sizeof(struct e8390_pkt_hdr) !=3D 4)
-		panic("8390.c: header struct mispacked\n");
+	BUILD_BUG_ON(sizeof(struct e8390_pkt_hdr) !=3D 4);
 	/* Follow National Semi's recommendations for initing the DP83902. */
 	ei_outb_p(E8390_NODMA+E8390_PAGE0+E8390_STOP, e8390_base+E8390_CMD); /* =
0x21 */
 	ei_outb_p(endcfg, e8390_base + EN0_DCFG);	/* 0x48 or 0x49 */
=2D-
2.20.1

