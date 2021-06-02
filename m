Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE24399500
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhFBUzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 16:55:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:38832 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229826AbhFBUzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 16:55:19 -0400
IronPort-SDR: sOgABjEQ403B+S3yN508R4IHMWclVNI/YTwc6giH+RTygVcHxoySqT7igkS/2/kJcfgkU2m9xN
 0qLvibvnu7Aw==
X-IronPort-AV: E=McAfee;i="6200,9189,10003"; a="200879838"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="200879838"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 13:53:19 -0700
IronPort-SDR: bK23wGfHprviIE5Yesr0mMbQHkfg0Jyw1pxYdq+WF3wz4+olXDcubbVCiqvWzyjoKLDGdaB+yV
 h30inWtiocnA==
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="447561151"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.38.74])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 13:53:17 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        gustavoars@kernel.org, Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v7 16/16] RDMA/irdma: Update MAINTAINERS file
Date:   Wed,  2 Jun 2021 15:51:38 -0500
Message-Id: <20210602205138.889-17-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210602205138.889-1-shiraz.saleem@intel.com>
References: <20210602205138.889-1-shiraz.saleem@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add maintainer entry for irdma driver.

Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 05cab3b..1dcd0e0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9132,6 +9132,14 @@ F:	drivers/net/ethernet/intel/*/
 F:	include/linux/avf/virtchnl.h
 F:	include/linux/net/intel/iidc.h
 
+INTEL ETHERNET PROTOCOL DRIVER FOR RDMA
+M:	Mustafa Ismail <mustafa.ismail@intel.com>
+M:	Shiraz Saleem <shiraz.saleem@intel.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/irdma/
+F:	include/uapi/rdma/irdma-abi.h
+
 INTEL FRAMEBUFFER DRIVER (excluding 810 and 815)
 M:	Maik Broemme <mbroemme@libmpq.org>
 L:	linux-fbdev@vger.kernel.org
-- 
1.8.3.1

