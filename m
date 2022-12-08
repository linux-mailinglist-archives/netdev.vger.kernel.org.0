Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7326F646649
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 02:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiLHBLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 20:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLHBLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 20:11:35 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55718BD2E
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 17:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670461893; x=1701997893;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ggg+9YdDNAQC1pljNjl+WN9A3GbUHBe5a1cPKv75nh4=;
  b=DGrQVmXmRo3B/cIIyi+ryxXHoGbie0ZIZLr+LqASn0hVOVeZBuzrcs1T
   DQoF99MBHbKJwGsgaj7kQlDUe2XIVM5Pib1qf75SKEE8E+BmtrCQuWqc8
   4X5ReZ+UY+dgTUtD1fADFlMHTvfaypdi99oLJ8LTt+cbEtV+kyGdOdJZT
   yLLDu03EfxcYofcthZ2U03ppireEe9BYcXEuB/E/RDuF4LILrTy1DXm1o
   yiWUcwHtJ5mdndyhggO2+usEch4UCzg/y0dcWCvOWAlLLUtI4ar589lHm
   yIV/aPw8RyAi2V2jQbFn2SzZBcuiEe3Xr7q412otnquvjAafF5VYwjHoH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="304672872"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="304672872"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="640445329"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="640445329"
Received: from jbrandeb-coyote30.jf.intel.com ([10.166.29.19])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 17:11:30 -0800
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH ethtool v2 01/13] ethtool: convert boilerplate licenses to SPDX
Date:   Wed,  7 Dec 2022 17:11:10 -0800
Message-Id: <20221208011122.2343363-2-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
References: <20221208011122.2343363-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used scancode (ScanCode-Toolkit) to find some licenses that have
old boilerplate style.

In the interests of enabling better automated code License scanning,
convert these to SPDX as the Linux kernel source has done.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 json_print.c    | 6 +-----
 json_print.h    | 6 +-----
 qsfp.c          | 6 +-----
 qsfp.h          | 7 +------
 sfc.c           | 5 +----
 sff-common.c    | 6 +-----
 sff-common.h    | 6 +-----
 sfpid.c         | 5 +----
 stmmac.c        | 5 +----
 test-cmdline.c  | 5 +----
 test-common.c   | 5 +----
 test-features.c | 5 +----
 tse.c           | 5 +----
 13 files changed, 13 insertions(+), 59 deletions(-)

diff --git a/json_print.c b/json_print.c
index 4f62767bdbc9..ac19765d53b3 100644
--- a/json_print.c
+++ b/json_print.c
@@ -1,11 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * json_print.c		"print regular or json output, based on json_writer".
  *
- *             This program is free software; you can redistribute it and/or
- *             modify it under the terms of the GNU General Public License
- *             as published by the Free Software Foundation; either version
- *             2 of the License, or (at your option) any later version.
- *
  * Authors:    Julien Fortin, <julien@cumulusnetworks.com>
  */
 
diff --git a/json_print.h b/json_print.h
index df15314bafe2..18e9beb251fe 100644
--- a/json_print.h
+++ b/json_print.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * json_print.h		"print regular or json output, based on json_writer".
  *
- *             This program is free software; you can redistribute it and/or
- *             modify it under the terms of the GNU General Public License
- *             as published by the Free Software Foundation; either version
- *             2 of the License, or (at your option) any later version.
- *
  * Authors:    Julien Fortin, <julien@cumulusnetworks.com>
  */
 
diff --git a/qsfp.c b/qsfp.c
index 1fe5de1a863f..fb94202757d3 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * qsfp.c: Implements SFF-8636 based QSFP+/QSFP28 Diagnostics Memory map.
  *
@@ -5,11 +6,6 @@
  * Aurelien Guillaume <aurelien@iwi.me> (C) 2012
  * Copyright (C) 2014 Cumulus networks Inc.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Freeoftware Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  *  Vidya Ravipati <vidya@cumulusnetworks.com>
  *   This implementation is loosely based on current SFP parser
  *   and SFF-8636 spec Rev 2.7 (ftp://ftp.seagate.com/pub/sff/SFF-8636.PDF)
diff --git a/qsfp.h b/qsfp.h
index aabf09fdc623..7960bf26fb07 100644
--- a/qsfp.h
+++ b/qsfp.h
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * SFF 8636 standards based QSFP EEPROM Field Definitions
  *
  * Vidya Ravipati <vidya@cumulusnetworks.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  */
 
 #ifndef QSFP_H__
diff --git a/sfc.c b/sfc.c
index 340800ee0fa0..a33077b4f263 100644
--- a/sfc.c
+++ b/sfc.c
@@ -1,10 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /****************************************************************************
  * Support for Solarflare Solarstorm network controllers and boards
  * Copyright 2010-2012 Solarflare Communications Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation, incorporated herein by reference.
  */
 
 #include <stdio.h>
diff --git a/sff-common.c b/sff-common.c
index e951cf15c1d6..94dc0643d3ec 100644
--- a/sff-common.c
+++ b/sff-common.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * sff-common.c: Implements SFF-8024 Rev 4.0 i.e. Specifcation
  * of pluggable I/O configuration
@@ -9,11 +10,6 @@
  * Aurelien Guillaume <aurelien@iwi.me> (C) 2012
  * Copyright (C) 2014 Cumulus networks Inc.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Freeoftware Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  *  Vidya Sagar Ravipati <vidya@cumulusnetworks.com>
  *   This implementation is loosely based on current SFP parser
  *   and SFF-8024 Rev 4.0 spec (ftp://ftp.seagate.com/pub/sff/SFF-8024.PDF)
diff --git a/sff-common.h b/sff-common.h
index dd12dda7bbce..2f58f91ab7ff 100644
--- a/sff-common.h
+++ b/sff-common.h
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * sff-common.h: Implements SFF-8024 Rev 4.0 i.e. Specifcation
  * of pluggable I/O configuration
@@ -9,11 +10,6 @@
  * Aurelien Guillaume <aurelien@iwi.me> (C) 2012
  * Copyright (C) 2014 Cumulus networks Inc.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Freeoftware Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
  *  Vidya Sagar Ravipati <vidya@cumulusnetworks.com>
  *   This implementation is loosely based on current SFP parser
  *   and SFF-8024 specs (ftp://ftp.seagate.com/pub/sff/SFF-8024.PDF)
diff --git a/sfpid.c b/sfpid.c
index 1bc45c183770..b701e292518d 100644
--- a/sfpid.c
+++ b/sfpid.c
@@ -1,10 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /****************************************************************************
  * Support for Solarflare Solarstorm network controllers and boards
  * Copyright 2010 Solarflare Communications Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation, incorporated herein by reference.
  */
 
 #include <stdio.h>
diff --git a/stmmac.c b/stmmac.c
index 58471200cd80..772d4470a61e 100644
--- a/stmmac.c
+++ b/stmmac.c
@@ -1,13 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /****************************************************************************
  * Support for the Synopsys MAC 10/100/1000 on-chip Ethernet controllers
  *
  * Copyright (C) 2007-2009  STMicroelectronics Ltd
  *
  * Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation, incorporated herein by reference.
  */
 
 #include <stdio.h>
diff --git a/test-cmdline.c b/test-cmdline.c
index cb803ed1a93d..a708f645d748 100644
--- a/test-cmdline.c
+++ b/test-cmdline.c
@@ -1,10 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /****************************************************************************
  * Test cases for ethtool command-line parsing
  * Copyright 2011 Solarflare Communications Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation, incorporated herein by reference.
  */
 
 #include <stdio.h>
diff --git a/test-common.c b/test-common.c
index 1dab0ce9dd10..e4dac3298577 100644
--- a/test-common.c
+++ b/test-common.c
@@ -1,12 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /****************************************************************************
  * Common test functions for ethtool
  * Copyright 2011 Solarflare Communications Inc.
  *
  * Partly derived from kernel <linux/list.h>.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation, incorporated herein by reference.
  */
 
 #include <assert.h>
diff --git a/test-features.c b/test-features.c
index b9f80f073d1f..a1f7c8a58569 100644
--- a/test-features.c
+++ b/test-features.c
@@ -1,10 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /****************************************************************************
  * Test cases for ethtool features
  * Copyright 2012 Solarflare Communications Inc.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation, incorporated herein by reference.
  */
 
 #include <errno.h>
diff --git a/tse.c b/tse.c
index fb00d218ab8a..8fd2d2304ea8 100644
--- a/tse.c
+++ b/tse.c
@@ -1,13 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0-only
 /****************************************************************************
  * Support for the Altera Triple Speed Ethernet 10/100/1000 Controller
  *
  * Copyright (C) 2014 Altera Corporation
  *
  * Author: Vince Bridgers <vbridgers2013@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation, incorporated herein by reference.
  */
 
 #include <stdio.h>
-- 
2.31.1

