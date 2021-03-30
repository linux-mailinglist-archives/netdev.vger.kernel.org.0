Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F82F34EEDF
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 19:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbhC3RBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 13:01:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:6414 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232579AbhC3RAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 13:00:39 -0400
IronPort-SDR: JBR5oLpywyAnFcBFLn5Dcdukjy+A24nJBTLHLB2Macec4Wv6R2BptuQSXV0J32LWhm4uoROc1H
 NheTnOhqvFUA==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="189569403"
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="189569403"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 10:00:39 -0700
IronPort-SDR: bzSzYAC06WSLe9xOI0IeB+FrHdttxPQPLi66jT5X+Sw0vTk56AxMp65WyMvBskNHbs0sKbSYvS
 /Nk4gR4IKo+g==
X-IronPort-AV: E=Sophos;i="5.81,291,1610438400"; 
   d="scan'208";a="610174946"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.209.112.111])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 10:00:38 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v3 23/23] RDMA/irdma: Update MAINTAINERS file
Date:   Tue, 30 Mar 2021 11:59:22 -0500
Message-Id: <20210330165922.2006-24-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210330165922.2006-1-shiraz.saleem@intel.com>
References: <20210330165922.2006-1-shiraz.saleem@intel.com>
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
index 211fbc4..6b0aeaf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8958,6 +8958,14 @@ F:	drivers/net/ethernet/intel/*/
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

