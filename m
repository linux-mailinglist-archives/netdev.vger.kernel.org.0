Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B5E28A3F4
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729545AbgJJWze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:34 -0400
Received: from mout.gmx.net ([212.227.17.22]:45559 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732031AbgJJTj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:39:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1602358761;
        bh=AApVCtlqtqWGGNb3ANJf2NnDeT6a9yMTji/2Rze6QZM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ECfWVyxCnbTu60x3szySXIHsGlEITCNRxCrVgT2JAXSXXhgru/RHo7IPer5G+PYPA
         eaeIqFzrymCbjCZVCCJ1qHQOKfbvNYWCUbQMJd0n16A5qWhxLpv50hv3n/IdNrCTXq
         riSZ44CD7AeYit40AKfg99k5/WBcqB4mNvekO56A=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mx-linux-amd.fritz.box ([84.154.218.232]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MOzOm-1kqTwa2yUu-00PK2N; Sat, 10 Oct 2020 18:17:28 +0200
From:   Armin Wolf <W_Armin@gmx.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2] ne2k: Enable RW-Bugfix
Date:   Sat, 10 Oct 2020 18:17:11 +0200
Message-Id: <20201010161711.19129-1-W_Armin@gmx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+VRMbdYAzzt9FNkqnc+8hrGObyQJHaIYWwUQoZJAuTRQ723VT5S
 nrKhZHh6lBy88XQs15rYzcJcXYen/aX4EXznHg/jle0RdCvAosB5X2Xg1OHzc9pejJgATAJ
 YjDkQI1cbnBXNRHoRPLGRYUwZKJXwApwP8MsmNlNyDDLYp8CNB2r64xi0umCgc+bWQWjzuL
 LozL/3qM3n6hemubYY4/A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8GagYgj6eX0=:DLsFxhIZCXeR1OGqADAiAq
 bev6VjQYEfly5INDLqQWvx/KcdSI7HvKErcU4PfYKOa63vpwapuNrWYS1XykayDb/j0GPCb/R
 4em/Oy7BGR88BynkLOiFRvDrx4/zMiQKY88QSyIDbLNghcrJFxod8F0a6OX4qs+r8m07IUwiu
 YrRD9ishmAskIsOwAI+Sit6nefk8BL7QCGha6UbenjNm7lStiAAhXYwReo5GnXRZLDrOUDEKG
 gkppvAzrtWqtQRcvisQtj1F7BvX8oK4FoDUz0dUtxUA2EgEYJVQH78m5N23QrgY7w1RKrfKC1
 3g5L3uqOHQLMCpjtUtBa4E3d56g/dQ9g3mmeCYmIg4eenptkj9fnJAqwUHdEUQV56PzwRhT5c
 IF8zXRoHD19pon6+/S8mtQfgc1dNqCww35pUqP2wel9aB33w00Dw3TdvHthGK+NVO+kEHx1qq
 y6LQ9+m8PLTc4urLJB+HyqOOgRFiLBnZ4cn9vYw1s/xm6CSYTBe8wAnkKVFUx7InfvujXO9/w
 7Lquye2gcSau2NkTC2sZD1Lt7E30nWgo98JjlSkKw9uthgH23Ty02/5YbJ17oWjG4qhIXv+rr
 3G+lgtqJlbAEsMPZYewfcBF2AZa0CxCrRKwJNMwq6TIb5YYEci5CyMQbPArGA/+KM0xqo9qpf
 4DCCeE63HuBQCEP8Vgnw3mx2BZlxc1iKdBnAHWJO4s/3qqHytfm2/B26p50HFxpCo2OeiyeyD
 vw7RmpIcG31+dWxT9h5ZWXiBk2OylOlviSCS6Wpu4ZqTdrHfrvfmCQSmIUz6fHCx01jZnKhL/
 3N4ShvPPpBImAh8W0vHjo8eDpFig1syrSxXw6y20LbvQrKPqNiE5V1Cft8u2g2Y0ZhSphx3zC
 3IyNpuF4VRfGQ3NvMJQHh4OGiwxJ7sxsXViEPx58mfuZqd7jhK0T23dvPOO0hi+caX5LZx3nA
 HB0YClQpE+/sf5KdUcD9Iw7yqhXVJMzjhdIfXlsu/8aY5NhjBGst3Zu3/MfftdDopH4uuBpf1
 wc3ij8GGcBOGuzJPpgVIHv+NHphN65z/Ta40sEw39B2+OuJ7yTDaubMuZmboVteiU5Z+xYUNm
 CijKfzS7NpPsEqlZByXKD4ieB3QgqK8AaxCbktQ2KY8Ql/QnEadhnrorx9UlF68qltWnTmpZp
 1JUGDHF/7rytHufkXRW6Bw8JQqutkq943FEengZMud9ibXx07NHWk7kzy2iQQaPKzfN0tlkYD
 zzcK86c13PFQYf4fO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct a typo in ne.c and ne2k-pci.c which
prevented activation of the RW-Bugfix.
Also enable the RW-Bugfix by default since
not doing so could (according to the Datasheet)
cause the system to lock up with some chips.

Signed-off-by: Armin Wolf <W_Armin@gmx.de>
=2D--
v2 changes:
- change NE8390_RW_BUGFIX to NE_RW_BUGFIX
=2D--
 drivers/net/ethernet/8390/ne.c       | 4 ++--
 drivers/net/ethernet/8390/ne2k-pci.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne=
.c
index 1c97e39b478e..54b183027900 100644
=2D-- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -90,7 +90,7 @@ MODULE_LICENSE("GPL");
 /* #define NE_SANITY_CHECK */

 /* Do we implement the read before write bugfix ? */
-/* #define NE_RW_BUGFIX */
+#define NE_RW_BUGFIX

 /* Do we have a non std. amount of memory? (in units of 256 byte pages) *=
/
 /* #define PACKETBUF_MEMSIZE	0x40 */
@@ -710,7 +710,7 @@ static void ne_block_output(struct net_device *dev, in=
t count,
 retry:
 #endif

-#ifdef NE8390_RW_BUGFIX
+#ifdef NE_RW_BUGFIX
 	/* Handle the read-before-write bug the same way as the
 	   Crynwr packet driver -- the NatSemi method doesn't work.
 	   Actually this doesn't always work either, but if you have
diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8=
390/ne2k-pci.c
index bc6edb3f1af3..1ed20bb4313a 100644
=2D-- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -91,7 +91,7 @@ MODULE_PARM_DESC(full_duplex, "full duplex setting(s) (1=
)");
 #define USE_LONGIO

 /* Do we implement the read before write bugfix ? */
-/* #define NE_RW_BUGFIX */
+#define NE_RW_BUGFIX

 /* Flags.  We rename an existing ei_status field to store flags!
  * Thus only the low 8 bits are usable for non-init-time flags.
@@ -610,7 +610,7 @@ static void ne2k_pci_block_output(struct net_device *d=
ev, int count,
 	/* We should already be in page 0, but to be safe... */
 	outb(E8390_PAGE0+E8390_START+E8390_NODMA, nic_base + NE_CMD);

-#ifdef NE8390_RW_BUGFIX
+#ifdef NE_RW_BUGFIX
 	/* Handle the read-before-write bug the same way as the
 	 * Crynwr packet driver -- the NatSemi method doesn't work.
 	 * Actually this doesn't always work either, but if you have
=2D-
2.20.1

