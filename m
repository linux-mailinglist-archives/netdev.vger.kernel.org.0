Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A85440455
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhJ2UuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:50:08 -0400
Received: from mga06.intel.com ([134.134.136.31]:9541 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230370AbhJ2Uts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:49:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="291587517"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="291587517"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 13:47:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="448483298"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 29 Oct 2021 13:47:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Tony Brelinski <tony.brelinski@intel.com>
Subject: [PATCH net-next 4/7] virtchnl: Remove unused VIRTCHNL_VF_OFFLOAD_RSVD define
Date:   Fri, 29 Oct 2021 13:45:37 -0700
Message-Id: <20211029204540.3390007-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
References: <20211029204540.3390007-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Remove unused define that is currently marked as reserved. This will
open up space for a new feature if/when it's introduced. Also, there is
no reason to keep unused defines around.

Suggested-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 include/linux/avf/virtchnl.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index db0e099c2399..2e1e1379b569 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -240,7 +240,6 @@ VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_vsi_resource);
  */
 #define VIRTCHNL_VF_OFFLOAD_L2			0x00000001
 #define VIRTCHNL_VF_OFFLOAD_IWARP		0x00000002
-#define VIRTCHNL_VF_OFFLOAD_RSVD		0x00000004
 #define VIRTCHNL_VF_OFFLOAD_RSS_AQ		0x00000008
 #define VIRTCHNL_VF_OFFLOAD_RSS_REG		0x00000010
 #define VIRTCHNL_VF_OFFLOAD_WB_ON_ITR		0x00000020
-- 
2.31.1

