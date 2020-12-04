Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE132CED55
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388034AbgLDLnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgLDLnR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 06:43:17 -0500
Date:   Fri, 4 Dec 2020 12:43:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607082151;
        bh=58EdiEWizU8rH/sFj3qecOi3Uqqil5hYN2rXS0Wrdmo=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=msxL+hB8ICggWRcC3ig1n4i7dx32RAjr2jNo98zH44dUwEQUrHs86mw3yfrySErr7
         2EFBqT3GXBWbebagU9L2ntEDva+cIO5npNSKEG4DEOU7rGP6CRnLVFZlcN+SQgxPb3
         vQYRI71PBAeTkUSnmbVI6JXykMLib6pPDcYsjIi4=
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     broonie@kernel.org, lgirdwood@gmail.com, davem@davemloft.net,
        kuba@kernel.org, jgg@nvidia.com,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] driver core: auxiliary bus: move slab.h from include file
Message-ID: <X8og8xi3WkoYXet9@kroah.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8ogtmrm7tOzZo+N@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

No need to include slab.h in include/linux/auxiliary_bus.h, as it is not
needed there.  Move it to drivers/base/auxiliary.c instead.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/auxiliary.c      | 1 +
 include/linux/auxiliary_bus.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/auxiliary.c b/drivers/base/auxiliary.c
index ef2af417438b..eca36d6284d0 100644
--- a/drivers/base/auxiliary.c
+++ b/drivers/base/auxiliary.c
@@ -9,6 +9,7 @@
 
 #include <linux/device.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
diff --git a/include/linux/auxiliary_bus.h b/include/linux/auxiliary_bus.h
index 282fbf7bf9af..3580743d0e8d 100644
--- a/include/linux/auxiliary_bus.h
+++ b/include/linux/auxiliary_bus.h
@@ -10,7 +10,6 @@
 
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
-#include <linux/slab.h>
 
 struct auxiliary_device {
 	struct device dev;
-- 
2.29.2

