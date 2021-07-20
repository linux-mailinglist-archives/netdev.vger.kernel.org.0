Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75EDC3D0534
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbhGTWjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:39:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:50233 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233491AbhGTWhb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:31 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341479"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341479"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407145"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tree Davies <tdavies@darkphysics.net>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com
Subject: [PATCH net-next 07/12] net/e1000e: Fix spelling mistake "The" -> "This"
Date:   Tue, 20 Jul 2021 16:20:56 -0700
Message-Id: <20210720232101.3087589-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tree Davies <tdavies@darkphysics.net>

There is a spelling mistake in the comment block.

Signed-off-by: Tree Davies <tdavies@darkphysics.net>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 152cacbc527e..3c22b509fa79 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7729,7 +7729,7 @@ static int e1000_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
  * @pdev: PCI device information struct
  *
  * e1000_remove is called by the PCI subsystem to alert the driver
- * that it should release a PCI device.  The could be caused by a
+ * that it should release a PCI device.  This could be caused by a
  * Hot-Plug event, or because the driver is going to be removed from
  * memory.
  **/
-- 
2.26.2

