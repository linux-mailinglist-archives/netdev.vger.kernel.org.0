Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7FE35602C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242161AbhDGASm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:18:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:29216 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239105AbhDGASk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:18:40 -0400
IronPort-SDR: bpJm6W4AzDqjifraHNVwxkNzy37UU3AJZipLufHWJ4QIQRi/TnZZLtLMkwMPUz+yyutWHUrmFg
 6Sbv3R7ZtbJA==
X-IronPort-AV: E=McAfee;i="6000,8403,9946"; a="257170828"
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="257170828"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:21 -0700
IronPort-SDR: mK+YUOAZ44d2EwHau5aYGSPjMwIoAUBMkqBUvE/rqOK92MG9c8JhNDOZExbHtJQHhkSVlOii/j
 Y/4JdsYKadtA==
X-IronPort-AV: E=Sophos;i="5.82,201,1613462400"; 
   d="scan'208";a="396441045"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.212.32.74])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2021 17:16:20 -0700
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     dledford@redhat.com, jgg@nvidia.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, anthony.l.nguyen@intel.com,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v4 resend 23/23] RDMA/irdma: Update MAINTAINERS file
Date:   Tue,  6 Apr 2021 19:15:02 -0500
Message-Id: <20210407001502.1890-24-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210407001502.1890-1-shiraz.saleem@intel.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
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
index 276cadf..f1a9752 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8957,6 +8957,14 @@ F:	drivers/net/ethernet/intel/*/
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

