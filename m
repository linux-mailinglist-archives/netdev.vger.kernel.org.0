Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C715B265697
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 03:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725795AbgIKBYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 21:24:06 -0400
Received: from mga03.intel.com ([134.134.136.65]:44541 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgIKBXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 21:23:47 -0400
IronPort-SDR: Zbhqr+OwwGYRXcFUNxffrVAJQJ2hh07RW38YTMTTuFo8jYZvQHGbGmte4qc7A2F2Ps3Z0q6yfo
 7dVVrV2S/NiA==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="158704645"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="158704645"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:46 -0700
IronPort-SDR: Lm+zR7IahERATVTFFUZEXgq0Y2sC7ONEt+NDMe4O3ZuF9FitKL++cPqoudQVS9TyQy1JstYTAU
 mdcxfL1UojMg==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="449808157"
Received: from jbrandeb-desk.jf.intel.com ([10.166.244.152])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 18:23:45 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [RFC PATCH net-next v1 09/11] drivers/net/ethernet: add some basic kdoc tags
Date:   Thu, 10 Sep 2020 18:23:35 -0700
Message-Id: <20200911012337.14015-10-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200911012337.14015-1-jesse.brandeburg@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A couple of drivers had a "generic documentation" section that
would trigger a "can't understand" message from W=1 compiles.

Fix by using correct DOC: tags.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/arc/emac_arc.c     | 2 +-
 drivers/net/ethernet/cadence/macb_pci.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_arc.c b/drivers/net/ethernet/arc/emac_arc.c
index 1c7736b7eaf7..800620b8f10d 100644
--- a/drivers/net/ethernet/arc/emac_arc.c
+++ b/drivers/net/ethernet/arc/emac_arc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /**
- * emac_arc.c - ARC EMAC specific glue layer
+ * DOC: emac_arc.c - ARC EMAC specific glue layer
  *
  * Copyright (C) 2014 Romain Perier
  *
diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index cd7d0332cba3..35316c91f523 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /**
- * Cadence GEM PCI wrapper.
+ * DOC: Cadence GEM PCI wrapper.
  *
  * Copyright (C) 2016 Cadence Design Systems - https://www.cadence.com
  *
-- 
2.27.0

