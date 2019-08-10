Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1269A88C15
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 17:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfHJPzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 11:55:54 -0400
Received: from conuserg-11.nifty.com ([210.131.2.78]:35857 "EHLO
        conuserg-11.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfHJPzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 11:55:53 -0400
Received: from grover.flets-west.jp (softbank126125143222.bbtec.net [126.125.143.222]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id x7AFrG96009713;
        Sun, 11 Aug 2019 00:53:26 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com x7AFrG96009713
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1565452407;
        bh=jmtnAlp5r/W1VjpdNwYulBR6vPbBBKflh9Un7xceSbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jzfo/uJj4NDRwhMy9Cn70CvntcZFbN6G6bFTZlu8kAYtHICAFeeYFz4NS04n8DNNu
         rJ+kowmP2XYeu+aeeYvcbvpoU93G2NaNNmIQdsgic1q3dyblTr6LYyDVM8JOS8aexK
         OXtIvT8XwRBsdpf3REmEBZLVzPtzIiUN62DPDzyt1hE6pDblo9pcPtgiUs9dt4uK20
         ksK7dunb1OxclzbzrtP5gfNdMkNRoM6b2X0FU+5wybzF5Ah/xX55Iu0F5q9xojCLq6
         wwHzoWU6Im4BsdX2MgcOgp/ik9Nl5yt/qWvcv4tUfk2by7i59R90blvFjyqWOJCxST
         /kpvVLZUdCcPg==
X-Nifty-SrcIP: [126.125.143.222]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Sam Ravnborg <sam@ravnborg.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Boris Pismenny <borisp@mellanox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Leon Romanovsky <leon@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: [PATCH 11/11] treewide: remove dummy Makefiles for single targets
Date:   Sun, 11 Aug 2019 00:53:07 +0900
Message-Id: <20190810155307.29322-12-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190810155307.29322-1-yamada.masahiro@socionext.com>
References: <20190810155307.29322-1-yamada.masahiro@socionext.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the single target build descends into sub-directories
in the same ways as the normal build, these dummy Makefiles
are not needed any more.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/net/ethernet/aquantia/atlantic/hw_atl/Makefile      | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/accel/Makefile      | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/diag/Makefile       | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en/Makefile         | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile     | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/Makefile   | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/fpga/Makefile       | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/Makefile      | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/lib/Makefile        | 2 --
 drivers/net/ethernet/netronome/nfp/bpf/Makefile             | 2 --
 drivers/net/ethernet/netronome/nfp/flower/Makefile          | 2 --
 drivers/net/ethernet/netronome/nfp/nfpcore/Makefile         | 2 --
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000/Makefile | 2 --
 drivers/net/ethernet/netronome/nfp/nic/Makefile             | 2 --
 14 files changed, 27 deletions(-)
 delete mode 100644 drivers/net/ethernet/aquantia/atlantic/hw_atl/Makefile
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/accel/Makefile
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/Makefile
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/Makefile
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/Makefile
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fpga/Makefile
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/ipoib/Makefile
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/Makefile
 delete mode 100644 drivers/net/ethernet/netronome/nfp/bpf/Makefile
 delete mode 100644 drivers/net/ethernet/netronome/nfp/flower/Makefile
 delete mode 100644 drivers/net/ethernet/netronome/nfp/nfpcore/Makefile
 delete mode 100644 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000/Makefile
 delete mode 100644 drivers/net/ethernet/netronome/nfp/nic/Makefile

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/Makefile b/drivers/net/ethernet/aquantia/atlantic/hw_atl/Makefile
deleted file mode 100644
index 805fa28f391a..000000000000
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# kbuild requires Makefile in a directory to build individual objects
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/accel/Makefile
deleted file mode 100644
index c78512eed8d7..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-subdir-ccflags-y += -I$(src)/..
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/diag/Makefile
deleted file mode 100644
index c78512eed8d7..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-subdir-ccflags-y += -I$(src)/..
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/en/Makefile
deleted file mode 100644
index c78512eed8d7..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-subdir-ccflags-y += -I$(src)/..
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
deleted file mode 100644
index 5ee42991900a..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-subdir-ccflags-y += -I$(src)/../..
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/Makefile
deleted file mode 100644
index c78512eed8d7..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-subdir-ccflags-y += -I$(src)/..
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/fpga/Makefile
deleted file mode 100644
index c78512eed8d7..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-subdir-ccflags-y += -I$(src)/..
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/Makefile
deleted file mode 100644
index c78512eed8d7..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-subdir-ccflags-y += -I$(src)/..
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/lib/Makefile
deleted file mode 100644
index c78512eed8d7..000000000000
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0-only
-subdir-ccflags-y += -I$(src)/..
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/Makefile b/drivers/net/ethernet/netronome/nfp/bpf/Makefile
deleted file mode 100644
index 805fa28f391a..000000000000
--- a/drivers/net/ethernet/netronome/nfp/bpf/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# kbuild requires Makefile in a directory to build individual objects
diff --git a/drivers/net/ethernet/netronome/nfp/flower/Makefile b/drivers/net/ethernet/netronome/nfp/flower/Makefile
deleted file mode 100644
index 805fa28f391a..000000000000
--- a/drivers/net/ethernet/netronome/nfp/flower/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# kbuild requires Makefile in a directory to build individual objects
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/Makefile b/drivers/net/ethernet/netronome/nfp/nfpcore/Makefile
deleted file mode 100644
index 805fa28f391a..000000000000
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# kbuild requires Makefile in a directory to build individual objects
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000/Makefile b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000/Makefile
deleted file mode 100644
index 805fa28f391a..000000000000
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# kbuild requires Makefile in a directory to build individual objects
diff --git a/drivers/net/ethernet/netronome/nfp/nic/Makefile b/drivers/net/ethernet/netronome/nfp/nic/Makefile
deleted file mode 100644
index 805fa28f391a..000000000000
--- a/drivers/net/ethernet/netronome/nfp/nic/Makefile
+++ /dev/null
@@ -1,2 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-# kbuild requires Makefile in a directory to build individual objects
-- 
2.17.1

