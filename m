Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 898A315AF9F
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 19:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgBLSUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 13:20:06 -0500
Received: from bin-mail-out-06.binero.net ([195.74.38.229]:52861 "EHLO
        bin-mail-out-06.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbgBLSUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 13:20:06 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2020 13:20:05 EST
X-Halon-ID: 6c8bfab5-4dc3-11ea-aa6d-005056917f90
Authorized-sender: niklas@soderlund.pp.se
Received: from bismarck.berto.se (p4fca2392.dip0.t-ipconnect.de [79.202.35.146])
        by bin-vsp-out-02.atm.binero.net (Halon) with ESMTPA
        id 6c8bfab5-4dc3-11ea-aa6d-005056917f90;
        Wed, 12 Feb 2020 19:13:58 +0100 (CET)
From:   =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
To:     "Daniel W . S . Almeida" <dwlsalmeida@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] Documentation: nfsroot.rst: Fix references to nfsroot.rst
Date:   Wed, 12 Feb 2020 19:13:32 +0100
Message-Id: <20200212181332.520545-1-niklas.soderlund+renesas@ragnatech.se>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When converting and moving nfsroot.txt to nfsroot.rst the references to
the old text file was not updated to match the change, fix this.

Fixes: f9a9349846f92b2d ("Documentation: nfsroot.txt: convert to ReST")
Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 Documentation/admin-guide/kernel-parameters.txt | 8 ++++----
 Documentation/filesystems/cifs/cifsroot.txt     | 2 +-
 fs/nfs/Kconfig                                  | 2 +-
 net/ipv4/Kconfig                                | 6 +++---
 net/ipv4/ipconfig.c                             | 2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index dbc22d68462751d2..afabc0bc4231b407 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1879,7 +1879,7 @@
 			No delay
 
 	ip=		[IP_PNP]
-			See Documentation/filesystems/nfs/nfsroot.txt.
+			See Documentation/admin-guide/nfs/nfsroot.rst.
 
 	ipcmni_extend	[KNL] Extend the maximum number of unique System V
 			IPC identifiers from 32,768 to 16,777,216.
@@ -2849,13 +2849,13 @@
 			Default value is 0.
 
 	nfsaddrs=	[NFS] Deprecated.  Use ip= instead.
-			See Documentation/filesystems/nfs/nfsroot.txt.
+			See Documentation/admin-guide/nfs/nfsroot.rst.
 
 	nfsroot=	[NFS] nfs root filesystem for disk-less boxes.
-			See Documentation/filesystems/nfs/nfsroot.txt.
+			See Documentation/admin-guide/nfs/nfsroot.rst.
 
 	nfsrootdebug	[NFS] enable nfsroot debugging messages.
-			See Documentation/filesystems/nfs/nfsroot.txt.
+			See Documentation/admin-guide/nfs/nfsroot.rst.
 
 	nfs.callback_nr_threads=
 			[NFSv4] set the total number of threads that the
diff --git a/Documentation/filesystems/cifs/cifsroot.txt b/Documentation/filesystems/cifs/cifsroot.txt
index 0fa1a2c36a4053ea..947b7ec6ce9e0f9d 100644
--- a/Documentation/filesystems/cifs/cifsroot.txt
+++ b/Documentation/filesystems/cifs/cifsroot.txt
@@ -13,7 +13,7 @@ network by utilizing SMB or CIFS protocol.
 
 In order to mount, the network stack will also need to be set up by
 using 'ip=' config option. For more details, see
-Documentation/filesystems/nfs/nfsroot.txt.
+Documentation/admin-guide/nfs/nfsroot.rst.
 
 A CIFS root mount currently requires the use of SMB1+UNIX Extensions
 which is only supported by the Samba server. SMB1 is the older
diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 40b6c5ac46c0cc17..88e1763e02f35668 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -164,7 +164,7 @@ config ROOT_NFS
 	  If you want your system to mount its root file system via NFS,
 	  choose Y here.  This is common practice for managing systems
 	  without local permanent storage.  For details, read
-	  <file:Documentation/filesystems/nfs/nfsroot.txt>.
+	  <file:Documentation/admin-guide/nfs/nfsroot.rst>.
 
 	  Most people say N here.
 
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index f96bd489b362ab7a..fb1dc8d02f6d4490 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -129,7 +129,7 @@ config IP_PNP_DHCP
 
 	  If unsure, say Y. Note that if you want to use DHCP, a DHCP server
 	  must be operating on your network.  Read
-	  <file:Documentation/filesystems/nfs/nfsroot.txt> for details.
+	  <file:Documentation/admin-guide/nfs/nfsroot.rst> for details.
 
 config IP_PNP_BOOTP
 	bool "IP: BOOTP support"
@@ -144,7 +144,7 @@ config IP_PNP_BOOTP
 	  does BOOTP itself, providing all necessary information on the kernel
 	  command line, you can say N here. If unsure, say Y. Note that if you
 	  want to use BOOTP, a BOOTP server must be operating on your network.
-	  Read <file:Documentation/filesystems/nfs/nfsroot.txt> for details.
+	  Read <file:Documentation/admin-guide/nfs/nfsroot.rst> for details.
 
 config IP_PNP_RARP
 	bool "IP: RARP support"
@@ -157,7 +157,7 @@ config IP_PNP_RARP
 	  older protocol which is being obsoleted by BOOTP and DHCP), say Y
 	  here. Note that if you want to use RARP, a RARP server must be
 	  operating on your network. Read
-	  <file:Documentation/filesystems/nfs/nfsroot.txt> for details.
+	  <file:Documentation/admin-guide/nfs/nfsroot.rst> for details.
 
 config NET_IPIP
 	tristate "IP: tunneling"
diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 4438f6b123352cbb..561f15b5a944ecae 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1621,7 +1621,7 @@ late_initcall(ip_auto_config);
 
 /*
  *  Decode any IP configuration options in the "ip=" or "nfsaddrs=" kernel
- *  command line parameter.  See Documentation/filesystems/nfs/nfsroot.txt.
+ *  command line parameter.  See Documentation/admin-guide/nfs/nfsroot.rst.
  */
 static int __init ic_proto_name(char *name)
 {
-- 
2.25.0

