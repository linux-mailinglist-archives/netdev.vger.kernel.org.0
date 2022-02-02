Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 067BE4A789D
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345277AbiBBTTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:19:33 -0500
Received: from mga05.intel.com ([192.55.52.43]:29368 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243624AbiBBTTb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 14:19:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643829571; x=1675365571;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=czwVFyBNk0PFhrMIITkqYda6mML26cgDADrcz6eFrsY=;
  b=H0QI7YtF4nvEsFDvpJc121D7laNI+j30pJvvOPWQ6tcSytPYiiyOzTOR
   r5FzGKLZl71nyArBBZj/0V2Ief45CljPKkH96jbIBeajC+V44Po5H60Dv
   FjJe/ATBA8b3p6+fEIznA5AN56kXaE2tM8aQunuuf101Sqrin3cCdfGeL
   JoAdFneUp0ocVeTexZuQEaMxqoKFQzp4a71NkTQ8eEUyRnujsR/FnRGTQ
   FKUCs6hPpX7n4zRiXykcrBnmbfrz7kvIi29XxWYwxVqKXxy6VuuYJ519n
   iVxR9vVGRozkoCDGUUP/fJX86a2ks56KHgPOQrW38hg01Y3ywXAr+3L3a
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="334360866"
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="334360866"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 11:19:31 -0800
X-IronPort-AV: E=Sophos;i="5.88,337,1635231600"; 
   d="scan'208";a="538413509"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.255.33.248])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 11:19:30 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH v1 for-next 0/3] Add DSCP QoS mappings for RDMA
Date:   Wed,  2 Feb 2022 13:19:18 -0600
Message-Id: <20220202191921.1638-1-shiraz.saleem@intel.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for using DSCP QoS mappings for RDMA on Intel
Ethernet 800 Series devices.

Once the series is reviewed, a shared PR will be created from intel-next
for Patch #1.

v0->v1: Remove unused define IIDC_VLAN_PFC_MODE

Dave Ertman (1):
  net/ice: add support for DSCP QoS for IIDC

Mustafa Ismail (2):
  RDMA/irdma: Refactor DCB bits in prep for DSCP support
  RDMA/irdma: Add support for DSCP

 drivers/infiniband/hw/irdma/cm.c         | 24 +++++++++++++++-----
 drivers/infiniband/hw/irdma/cm.h         |  7 ++++++
 drivers/infiniband/hw/irdma/ctrl.c       | 39 ++++++++++++++++++++++----------
 drivers/infiniband/hw/irdma/i40iw_if.c   |  2 +-
 drivers/infiniband/hw/irdma/main.c       | 10 +++++++-
 drivers/infiniband/hw/irdma/main.h       |  2 +-
 drivers/infiniband/hw/irdma/osdep.h      |  1 +
 drivers/infiniband/hw/irdma/type.h       |  4 ++++
 drivers/infiniband/hw/irdma/verbs.c      |  4 ++--
 drivers/net/ethernet/intel/ice/ice_idc.c |  5 ++++
 include/linux/net/intel/iidc.h           |  4 ++++
 11 files changed, 79 insertions(+), 23 deletions(-)

-- 
1.8.3.1

