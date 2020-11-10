Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555442ACC20
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbgKJDvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:51:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:53634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgKJDvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 22:51:53 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAE9720721;
        Tue, 10 Nov 2020 03:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980312;
        bh=Oz4U1itVtZOILXDpCElEo3viPuuWDCWcvMatgWU1B7E=;
        h=From:To:Cc:Subject:Date:From;
        b=e1j0IHYcBqkwQzCjNojEEZz80M9ZjtHLHnlYiQaMNpsN4nSWNPHhLCBd4f8z6NJpd
         Z+x/kGtKEmtR0HlHvTrMheRDPPfI7TNmdNWiEvzBx2BRIGFYfTkv4fiWJX3oL6pP20
         YKhKB2NnIWeWERJlvaVFcdVXDWvqzuvtqzWjW9FE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: switch to the kernel.org patchwork instance
Date:   Mon,  9 Nov 2020 19:51:20 -0800
Message-Id: <20201110035120.642746-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move to the kernel.org patchwork instance, it has significantly
lower latency for accessing from Europe and the US. Other quirks
include the reply bot.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
We were in process of transitioning already before Dave had to step
away, so after double checking with him let's complete the process.

Some patches are still pending review on ozlabs, but state of new
ones will be updated on kernel.org.
---
 Documentation/networking/netdev-FAQ.rst       |  4 ++--
 Documentation/process/stable-kernel-rules.rst |  2 +-
 .../it_IT/process/stable-kernel-rules.rst     |  2 +-
 MAINTAINERS                                   | 20 +++++++++----------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index d5c9320901c3..21537766be4d 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -110,7 +110,7 @@ Q: I sent a patch and I'm wondering what happened to it?
 Q: How can I tell whether it got merged?
 A: Start by looking at the main patchworks queue for netdev:
 
-  http://patchwork.ozlabs.org/project/netdev/list/
+  https://patchwork.kernel.org/project/netdevbpf/list/
 
 The "State" field will tell you exactly where things are at with your
 patch.
@@ -152,7 +152,7 @@ networking subsystem, and then hands them off to Greg.
 
 There is a patchworks queue that you can see here:
 
-  http://patchwork.ozlabs.org/bundle/davem/stable/?state=*
+  https://patchwork.kernel.org/bundle/netdev/stable/?state=*
 
 It contains the patches which Dave has selected, but not yet handed off
 to Greg.  If Greg already has the patch, then it will be here:
diff --git a/Documentation/process/stable-kernel-rules.rst b/Documentation/process/stable-kernel-rules.rst
index 06f743b612c4..3973556250e1 100644
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -39,7 +39,7 @@ Procedure for submitting patches to the -stable tree
    submission guidelines as described in
    :ref:`Documentation/networking/netdev-FAQ.rst <netdev-FAQ>`
    after first checking the stable networking queue at
-   https://patchwork.ozlabs.org/bundle/davem/stable/?series=&submitter=&state=*&q=&archive=
+   https://patchwork.kernel.org/bundle/netdev/stable/?state=*
    to ensure the requested patch is not already queued up.
  - Security patches should not be handled (solely) by the -stable review
    process but should follow the procedures in
diff --git a/Documentation/translations/it_IT/process/stable-kernel-rules.rst b/Documentation/translations/it_IT/process/stable-kernel-rules.rst
index 4f206cee31a7..283d62541c4f 100644
--- a/Documentation/translations/it_IT/process/stable-kernel-rules.rst
+++ b/Documentation/translations/it_IT/process/stable-kernel-rules.rst
@@ -46,7 +46,7 @@ Procedura per sottomettere patch per i sorgenti -stable
    :ref:`Documentation/translations/it_IT/networking/netdev-FAQ.rst <it_netdev-FAQ>`;
    ma solo dopo aver verificato al seguente indirizzo che la patch non sia
    già in coda:
-   https://patchwork.ozlabs.org/bundle/davem/stable/?series=&submitter=&state=*&q=&archive=
+   https://patchwork.kernel.org/bundle/netdev/stable/?state=*
  - Una patch di sicurezza non dovrebbero essere gestite (solamente) dal processo
    di revisione -stable, ma dovrebbe seguire le procedure descritte in
    :ref:`Documentation/translations/it_IT/admin-guide/security-bugs.rst <it_securitybugs>`.
diff --git a/MAINTAINERS b/MAINTAINERS
index cd123d0a6a2d..e070afe6912d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1279,7 +1279,7 @@ M:	Igor Russkikh <irusskikh@marvell.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	https://www.marvell.com/
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 F:	Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst
 F:	drivers/net/ethernet/aquantia/atlantic/
 
@@ -11173,7 +11173,7 @@ M:	Tariq Toukan <tariqt@nvidia.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 F:	drivers/net/ethernet/mellanox/mlx4/en_*
 
 MELLANOX ETHERNET DRIVER (mlx5e)
@@ -11181,7 +11181,7 @@ M:	Saeed Mahameed <saeedm@nvidia.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 F:	drivers/net/ethernet/mellanox/mlx5/core/en_*
 
 MELLANOX ETHERNET INNOVA DRIVERS
@@ -11189,7 +11189,7 @@ R:	Boris Pismenny <borisp@nvidia.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 F:	drivers/net/ethernet/mellanox/mlx5/core/accel/*
 F:	drivers/net/ethernet/mellanox/mlx5/core/en_accel/*
 F:	drivers/net/ethernet/mellanox/mlx5/core/fpga/*
@@ -11201,7 +11201,7 @@ M:	Ido Schimmel <idosch@nvidia.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 F:	drivers/net/ethernet/mellanox/mlxsw/
 F:	tools/testing/selftests/drivers/net/mlxsw/
 
@@ -11210,7 +11210,7 @@ M:	mlxsw@nvidia.com
 L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 F:	drivers/net/ethernet/mellanox/mlxfw/
 
 MELLANOX HARDWARE PLATFORM SUPPORT
@@ -11229,7 +11229,7 @@ L:	netdev@vger.kernel.org
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 F:	drivers/net/ethernet/mellanox/mlx4/
 F:	include/linux/mlx4/
 
@@ -11250,7 +11250,7 @@ L:	netdev@vger.kernel.org
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 F:	Documentation/networking/device_drivers/ethernet/mellanox/
 F:	drivers/net/ethernet/mellanox/mlx5/core/
 F:	include/linux/mlx5/
@@ -12130,7 +12130,7 @@ M:	Jakub Kicinski <kuba@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 W:	http://www.linuxfoundation.org/en/Net
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 F:	Documentation/devicetree/bindings/net/
@@ -12175,7 +12175,7 @@ M:	Jakub Kicinski <kuba@kernel.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 W:	http://www.linuxfoundation.org/en/Net
-Q:	http://patchwork.ozlabs.org/project/netdev/list/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/
 B:	mailto:netdev@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
-- 
2.26.2

