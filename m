Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C498309F4
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 10:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfEaIPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 04:15:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:64473 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfEaIPL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 04:15:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 01:15:10 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 May 2019 01:15:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/13] iavf: Rename i40e_adminq* files to iavf_adminq*
Date:   Fri, 31 May 2019 01:15:10 -0700
Message-Id: <20190531081518.16430-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
References: <20190531081518.16430-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

With the rename of the iavf driver, there were some
files that were missed in renaming.  Update these to
be iavf as well.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/Makefile                        | 2 +-
 .../net/ethernet/intel/iavf/{i40e_adminq.c => iavf_adminq.c}    | 2 +-
 .../net/ethernet/intel/iavf/{i40e_adminq.h => iavf_adminq.h}    | 2 +-
 .../intel/iavf/{i40e_adminq_cmd.h => iavf_adminq_cmd.h}         | 0
 drivers/net/ethernet/intel/iavf/iavf_common.c                   | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_type.h                     | 2 +-
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename drivers/net/ethernet/intel/iavf/{i40e_adminq.c => iavf_adminq.c} (99%)
 rename drivers/net/ethernet/intel/iavf/{i40e_adminq.h => iavf_adminq.h} (99%)
 rename drivers/net/ethernet/intel/iavf/{i40e_adminq_cmd.h => iavf_adminq_cmd.h} (100%)

diff --git a/drivers/net/ethernet/intel/iavf/Makefile b/drivers/net/ethernet/intel/iavf/Makefile
index 9cbb5743ed12..c997063ed728 100644
--- a/drivers/net/ethernet/intel/iavf/Makefile
+++ b/drivers/net/ethernet/intel/iavf/Makefile
@@ -12,4 +12,4 @@ subdir-ccflags-y += -I$(src)
 obj-$(CONFIG_IAVF) += iavf.o
 
 iavf-objs := iavf_main.o iavf_ethtool.o iavf_virtchnl.o \
-	     iavf_txrx.o iavf_common.o i40e_adminq.o iavf_client.o
+	     iavf_txrx.o iavf_common.o iavf_adminq.o iavf_client.o
diff --git a/drivers/net/ethernet/intel/iavf/i40e_adminq.c b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
similarity index 99%
rename from drivers/net/ethernet/intel/iavf/i40e_adminq.c
rename to drivers/net/ethernet/intel/iavf/iavf_adminq.c
index fca1ecfd9f71..04b44614ec38 100644
--- a/drivers/net/ethernet/intel/iavf/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.c
@@ -4,7 +4,7 @@
 #include "iavf_status.h"
 #include "iavf_type.h"
 #include "iavf_register.h"
-#include "i40e_adminq.h"
+#include "iavf_adminq.h"
 #include "iavf_prototype.h"
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/i40e_adminq.h b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
similarity index 99%
rename from drivers/net/ethernet/intel/iavf/i40e_adminq.h
rename to drivers/net/ethernet/intel/iavf/iavf_adminq.h
index ee983889eab0..7c06752c0fea 100644
--- a/drivers/net/ethernet/intel/iavf/i40e_adminq.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_adminq.h
@@ -6,7 +6,7 @@
 
 #include "iavf_osdep.h"
 #include "iavf_status.h"
-#include "i40e_adminq_cmd.h"
+#include "iavf_adminq_cmd.h"
 
 #define IAVF_ADMINQ_DESC(R, i)   \
 	(&(((struct i40e_aq_desc *)((R).desc_buf.va))[i]))
diff --git a/drivers/net/ethernet/intel/iavf/i40e_adminq_cmd.h b/drivers/net/ethernet/intel/iavf/iavf_adminq_cmd.h
similarity index 100%
rename from drivers/net/ethernet/intel/iavf/i40e_adminq_cmd.h
rename to drivers/net/ethernet/intel/iavf/iavf_adminq_cmd.h
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 768369c89e77..d9d9f6060353 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -2,7 +2,7 @@
 /* Copyright(c) 2013 - 2018 Intel Corporation. */
 
 #include "iavf_type.h"
-#include "i40e_adminq.h"
+#include "iavf_adminq.h"
 #include "iavf_prototype.h"
 #include <linux/avf/virtchnl.h>
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_type.h b/drivers/net/ethernet/intel/iavf/iavf_type.h
index ca89583613fb..58b3efd1ed04 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_type.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_type.h
@@ -7,7 +7,7 @@
 #include "iavf_status.h"
 #include "iavf_osdep.h"
 #include "iavf_register.h"
-#include "i40e_adminq.h"
+#include "iavf_adminq.h"
 #include "iavf_devids.h"
 
 #define IAVF_RXQ_CTX_DBUFF_SHIFT 7
-- 
2.21.0

