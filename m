Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B453A38B209
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbhETOl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 10:41:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:49445 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241751AbhETOkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 10:40:49 -0400
IronPort-SDR: ieABe0zNRbgsgjtRTj2n+TbwNPsBpILJCwbLislnzuZeJERytpcbLYUrx+BOUjdLvoRO/Dacge
 LPVydGRZVyTA==
X-IronPort-AV: E=McAfee;i="6200,9189,9989"; a="265154257"
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="265154257"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 07:39:25 -0700
IronPort-SDR: xsGSJrrojEHucFxevmSXG4Qj80cq1QM/2VBjKD9SSu/+lrRamaKpgbRhq2i5Ngv9R968PJZNkr
 tO+G9qcFp22A==
X-IronPort-AV: E=Sophos;i="5.82,313,1613462400"; 
   d="scan'208";a="475221556"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.170.3])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2021 07:39:23 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v6 22/22] RDMA/irdma: Update MAINTAINERS file
Date:   Thu, 20 May 2021 09:38:09 -0500
Message-Id: <20210520143809.819-23-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210520143809.819-1-shiraz.saleem@intel.com>
References: <20210520143809.819-1-shiraz.saleem@intel.com>
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

