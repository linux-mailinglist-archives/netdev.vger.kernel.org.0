Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48241946A6
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgCZShf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:37:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:43777 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgCZShf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:37:35 -0400
IronPort-SDR: TY4dKEntE936j500B+9EV6gWUDa75HgaGdKjVxScSVXkpSnf0FXCoYFWPuxxlFsokVU9q3CZrO
 pMEO+qh1fhXA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 11:37:22 -0700
IronPort-SDR: W5XN3ncv0P1yypSj0E0QiOI6qFEAJrYYHqWbrYfyqpxo5QnWjOSwpV7b3vIVjPbdHVj9t7kn+H
 wvTc1NbjFdbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="358241613"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.33])
  by fmsmga001.fm.intel.com with ESMTP; 26 Mar 2020 11:37:22 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next v3 03/11] devlink: trivial: fix tab in function documentation
Date:   Thu, 26 Mar 2020 11:37:10 -0700
Message-Id: <20200326183718.2384349-4-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200326183718.2384349-1-jacob.e.keller@intel.com>
References: <20200326183718.2384349-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function documentation comment for devlink_region_snapshot_create
included a literal tab character between 'future analyses' that was
difficult to spot as it happened to only display as one space wide.

Fix the comment to use a space here instead of a stray tab appearing in
the middle of a sentence.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
Changes since RFC:
* Picked up Jiri's Reviewed-by

 net/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 84d74fbcff62..73e66a779c13 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7740,7 +7740,7 @@ EXPORT_SYMBOL_GPL(devlink_region_snapshot_id_get);
  *	devlink_region_snapshot_create - create a new snapshot
  *	This will add a new snapshot of a region. The snapshot
  *	will be stored on the region struct and can be accessed
- *	from devlink. This is useful for future	analyses of snapshots.
+ *	from devlink. This is useful for future analyses of snapshots.
  *	Multiple snapshots can be created on a region.
  *	The @snapshot_id should be obtained using the getter function.
  *
-- 
2.24.1

