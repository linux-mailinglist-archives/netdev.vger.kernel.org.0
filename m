Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7139B355D97
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347359AbhDFVED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 17:04:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:35348 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243355AbhDFVDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 17:03:51 -0400
IronPort-SDR: Wnuf1s7FhcpkmZjXyTmiUMrJFYzcZUyt4tyBkTsuaCmuugclWQWSxJuxQwViJbqT2bcAKwpFv7
 2Sbi9O1d2mJQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="213532543"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="213532543"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 14:02:47 -0700
IronPort-SDR: 73sIL2jbNY5gZX7BJyTi1RbNb0ECHEZvmzB9yCKwG+AsFleicfuQtkZuUiOYV/IYFW8nZbK4rq
 peftbuN70ADw==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="441066876"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.60.133])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 14:02:45 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v4 22/23] RDMA/irdma: Add irdma Kconfig/Makefile and remove i40iw
Date:   Tue,  6 Apr 2021 16:01:24 -0500
Message-Id: <20210406210125.241-23-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210406210125.241-1-shiraz.saleem@intel.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Kconfig and Makefile to build irdma driver.

Remove i40iw driver and add an alias in irdma.
irdma is the replacement driver that supports X722.

Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 Documentation/ABI/stable/sysfs-class-infiniband |   20 -
 MAINTAINERS                                     |    8 -
 drivers/infiniband/Kconfig                      |    2 +-
 drivers/infiniband/hw/Makefile                  |    2 +-
 drivers/infiniband/hw/i40iw/Kconfig             |    9 -
 drivers/infiniband/hw/i40iw/Makefile            |    9 -
 drivers/infiniband/hw/i40iw/i40iw.h             |  602 ---
 drivers/infiniband/hw/i40iw/i40iw_cm.c          | 4419 -------------------
 drivers/infiniband/hw/i40iw/i40iw_cm.h          |  462 --
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c        | 5243 -----------------------
 drivers/infiniband/hw/i40iw/i40iw_d.h           | 1746 --------
 drivers/infiniband/hw/i40iw/i40iw_hmc.c         |  821 ----
 drivers/infiniband/hw/i40iw/i40iw_hmc.h         |  241 --
 drivers/infiniband/hw/i40iw/i40iw_hw.c          |  851 ----
 drivers/infiniband/hw/i40iw/i40iw_main.c        | 2066 ---------
 drivers/infiniband/hw/i40iw/i40iw_osdep.h       |  195 -
 drivers/infiniband/hw/i40iw/i40iw_p.h           |  129 -
 drivers/infiniband/hw/i40iw/i40iw_pble.c        |  613 ---
 drivers/infiniband/hw/i40iw/i40iw_pble.h        |  131 -
 drivers/infiniband/hw/i40iw/i40iw_puda.c        | 1496 -------
 drivers/infiniband/hw/i40iw/i40iw_puda.h        |  188 -
 drivers/infiniband/hw/i40iw/i40iw_register.h    | 1030 -----
 drivers/infiniband/hw/i40iw/i40iw_status.h      |  101 -
 drivers/infiniband/hw/i40iw/i40iw_type.h        | 1358 ------
 drivers/infiniband/hw/i40iw/i40iw_uk.c          | 1200 ------
 drivers/infiniband/hw/i40iw/i40iw_user.h        |  422 --
 drivers/infiniband/hw/i40iw/i40iw_utils.c       | 1518 -------
 drivers/infiniband/hw/i40iw/i40iw_verbs.c       | 2652 ------------
 drivers/infiniband/hw/i40iw/i40iw_verbs.h       |  179 -
 drivers/infiniband/hw/i40iw/i40iw_vf.c          |   85 -
 drivers/infiniband/hw/i40iw/i40iw_vf.h          |   62 -
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c    |  759 ----
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.h    |  124 -
 drivers/infiniband/hw/irdma/Kconfig             |   11 +
 drivers/infiniband/hw/irdma/Makefile            |   27 +
 include/uapi/rdma/i40iw-abi.h                   |  107 -
 36 files changed, 40 insertions(+), 28848 deletions(-)
 delete mode 100644 drivers/infiniband/hw/i40iw/Kconfig
 delete mode 100644 drivers/infiniband/hw/i40iw/Makefile
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_cm.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_cm.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_ctrl.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_d.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_hmc.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_hmc.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_hw.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_main.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_osdep.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_p.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_pble.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_pble.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_puda.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_puda.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_register.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_status.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_type.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_uk.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_user.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_utils.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_verbs.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_verbs.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_vf.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_vf.h
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
 delete mode 100644 drivers/infiniband/hw/i40iw/i40iw_virtchnl.h
 create mode 100644 drivers/infiniband/hw/irdma/Kconfig
 create mode 100644 drivers/infiniband/hw/irdma/Makefile
 delete mode 100644 include/uapi/rdma/i40iw-abi.h

diff --git a/Documentation/ABI/stable/sysfs-class-infiniband b/Documentation/ABI/stable/sysfs-class-infiniband
index 348c4ac..9b1bdfa 100644
--- a/Documentation/ABI/stable/sysfs-class-infiniband
+++ b/Documentation/ABI/stable/sysfs-class-infiniband
@@ -731,26 +731,6 @@ Description:
 		is the irq number of "sdma3", and M is irq number of "sdma4" in
 		the /proc/interrupts file.
 
-
-sysfs interface for Intel(R) X722 iWARP i40iw driver
-----------------------------------------------------
-
-What:		/sys/class/infiniband/i40iwX/hw_rev
-What:		/sys/class/infiniband/i40iwX/hca_type
-What:		/sys/class/infiniband/i40iwX/board_id
-Date:		Jan, 2016
-KernelVersion:	v4.10
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		=============== ==== ========================
-		hw_rev:		(RO) Hardware revision number
-
-		hca_type:	(RO) Show HCA type (I40IW)
-
-		board_id:	(RO) I40IW board ID
-		=============== ==== ========================
-
-
 sysfs interface for QLogic qedr NIC Driver
 ------------------------------------------
 
diff --git a/MAINTAINERS b/MAINTAINERS
index 27e424e..276cadf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9169,14 +9169,6 @@ L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	drivers/cpufreq/intel_pstate.c
 
-INTEL RDMA RNIC DRIVER
-M:	Faisal Latif <faisal.latif@intel.com>
-M:	Shiraz Saleem <shiraz.saleem@intel.com>
-L:	linux-rdma@vger.kernel.org
-S:	Supported
-F:	drivers/infiniband/hw/i40iw/
-F:	include/uapi/rdma/i40iw-abi.h
-
 INTEL SCU DRIVERS
 M:	Mika Westerberg <mika.westerberg@linux.intel.com>
 S:	Maintained
diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index 04a78d9..33d3ce9 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -82,7 +82,7 @@ source "drivers/infiniband/hw/mthca/Kconfig"
 source "drivers/infiniband/hw/qib/Kconfig"
 source "drivers/infiniband/hw/cxgb4/Kconfig"
 source "drivers/infiniband/hw/efa/Kconfig"
-source "drivers/infiniband/hw/i40iw/Kconfig"
+source "drivers/infiniband/hw/irdma/Kconfig"
 source "drivers/infiniband/hw/mlx4/Kconfig"
 source "drivers/infiniband/hw/mlx5/Kconfig"
 source "drivers/infiniband/hw/ocrdma/Kconfig"
diff --git a/drivers/infiniband/hw/Makefile b/drivers/infiniband/hw/Makefile
index 0aeccd9..fba0b3b 100644
--- a/drivers/infiniband/hw/Makefile
+++ b/drivers/infiniband/hw/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_INFINIBAND_MTHCA)		+= mthca/
 obj-$(CONFIG_INFINIBAND_QIB)		+= qib/
 obj-$(CONFIG_INFINIBAND_CXGB4)		+= cxgb4/
 obj-$(CONFIG_INFINIBAND_EFA)		+= efa/
-obj-$(CONFIG_INFINIBAND_I40IW)		+= i40iw/
+obj-$(CONFIG_INFINIBAND_IRDMA)		+= irdma/
 obj-$(CONFIG_MLX4_INFINIBAND)		+= mlx4/
 obj-$(CONFIG_MLX5_INFINIBAND)		+= mlx5/
 obj-$(CONFIG_INFINIBAND_OCRDMA)		+= ocrdma/
diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/i40iw/Kconfig
deleted file mode 100644
index 7476f3b..0000000
diff --git a/drivers/infiniband/hw/i40iw/Makefile b/drivers/infiniband/hw/i40iw/Makefile
deleted file mode 100644
index 34da9eb..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
deleted file mode 100644
index be4094a..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
deleted file mode 100644
index 2450b7d..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.h b/drivers/infiniband/hw/i40iw/i40iw_cm.h
deleted file mode 100644
index 6e43e4d..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_ctrl.c b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
deleted file mode 100644
index eaea5d5..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_d.h b/drivers/infiniband/hw/i40iw/i40iw_d.h
deleted file mode 100644
index 86d5a33..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hmc.c b/drivers/infiniband/hw/i40iw/i40iw_hmc.c
deleted file mode 100644
index b44bfc1..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hmc.h b/drivers/infiniband/hw/i40iw/i40iw_hmc.h
deleted file mode 100644
index 4c3fdd8..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_hw.c b/drivers/infiniband/hw/i40iw/i40iw_hw.c
deleted file mode 100644
index d167ac1..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
deleted file mode 100644
index 2ebcbb1..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_osdep.h b/drivers/infiniband/hw/i40iw/i40iw_osdep.h
deleted file mode 100644
index d938ccb..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_p.h b/drivers/infiniband/hw/i40iw/i40iw_p.h
deleted file mode 100644
index 4c42956..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_pble.c b/drivers/infiniband/hw/i40iw/i40iw_pble.c
deleted file mode 100644
index 53e5cd1..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_pble.h b/drivers/infiniband/hw/i40iw/i40iw_pble.h
deleted file mode 100644
index 7b1851d..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.c b/drivers/infiniband/hw/i40iw/i40iw_puda.c
deleted file mode 100644
index 88fb68e..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.h b/drivers/infiniband/hw/i40iw/i40iw_puda.h
deleted file mode 100644
index 53a7d58c..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_register.h b/drivers/infiniband/hw/i40iw/i40iw_register.h
deleted file mode 100644
index 5776818..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_status.h b/drivers/infiniband/hw/i40iw/i40iw_status.h
deleted file mode 100644
index 36a19c4..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_type.h b/drivers/infiniband/hw/i40iw/i40iw_type.h
deleted file mode 100644
index 394e182..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
deleted file mode 100644
index f521be1..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_user.h b/drivers/infiniband/hw/i40iw/i40iw_user.h
deleted file mode 100644
index 93fc308..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
deleted file mode 100644
index 9ff825f..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
deleted file mode 100644
index b876d72..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.h b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
deleted file mode 100644
index bab71f3..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_vf.c b/drivers/infiniband/hw/i40iw/i40iw_vf.c
deleted file mode 100644
index e33d481..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_vf.h b/drivers/infiniband/hw/i40iw/i40iw_vf.h
deleted file mode 100644
index 4359559..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.c
deleted file mode 100644
index e34a152..0000000
diff --git a/drivers/infiniband/hw/i40iw/i40iw_virtchnl.h b/drivers/infiniband/hw/i40iw/i40iw_virtchnl.h
deleted file mode 100644
index 24886ef..0000000
diff --git a/drivers/infiniband/hw/irdma/Kconfig b/drivers/infiniband/hw/irdma/Kconfig
new file mode 100644
index 0000000..3fe621b
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/Kconfig
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config INFINIBAND_IRDMA
+	tristate "Intel(R) Ethernet Protocol Driver for RDMA"
+	depends on INET
+	depends on IPV6 || !IPV6
+	depends on PCI
+	select GENERIC_ALLOCATOR
+	select CONFIG_AUXILIARY_BUS
+	help
+	  This is an Intel(R) Ethernet Protocol Driver for RDMA driver
+	  that support E810 (iWARP/RoCE) and X722 (iWARP) network devices.
diff --git a/drivers/infiniband/hw/irdma/Makefile b/drivers/infiniband/hw/irdma/Makefile
new file mode 100644
index 0000000..48c3854
--- /dev/null
+++ b/drivers/infiniband/hw/irdma/Makefile
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+# Copyright (c) 2019, Intel Corporation.
+
+#
+# Makefile for the Intel(R) Ethernet Connection RDMA Linux Driver
+#
+
+obj-$(CONFIG_INFINIBAND_IRDMA) += irdma.o
+
+irdma-objs := cm.o        \
+              ctrl.o      \
+              hmc.o       \
+              hw.o        \
+              i40iw_hw.o  \
+              i40iw_if.o  \
+              icrdma_hw.o \
+              main.o      \
+              pble.o      \
+              puda.o      \
+              trace.o     \
+              uda.o       \
+              uk.o        \
+              utils.o     \
+              verbs.o     \
+              ws.o        \
+
+CFLAGS_trace.o = -I$(src)
diff --git a/include/uapi/rdma/i40iw-abi.h b/include/uapi/rdma/i40iw-abi.h
deleted file mode 100644
index 79890ba..0000000
-- 
1.8.3.1

