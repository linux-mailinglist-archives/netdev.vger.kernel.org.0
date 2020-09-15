Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26045269B80
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgIOBpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:45:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:12868 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726186AbgIOBpW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 21:45:22 -0400
IronPort-SDR: sBPx4pDYMx0F6EqQ434CIyFPQUnof9bNuhdvJz3z1KEvrOFYCd2CuPZYB3dVNWc5k26UJ87zB2
 4EUbuwr6rJ4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="220742448"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="220742448"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
IronPort-SDR: WTr3YdkjZZVi0jkPIduTCX677pOQHGXVqUXSKv9PICFhVMIBlgX7JJxpn+v1I/DVwUbIdsnwCj
 AMKC1+vghb0g==
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="482571957"
Received: from jbrandeb-saw1.jf.intel.com ([10.166.28.56])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 18:45:09 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        intel-wired-lan@lists.osuosl.org
Subject: [PATCH net-next v2 07/10] drivers/net/ethernet: add some basic kdoc tags
Date:   Mon, 14 Sep 2020 18:44:52 -0700
Message-Id: <20200915014455.1232507-8-jesse.brandeburg@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
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
2.28.0

