Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1664A4F9C
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 20:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377285AbiAaTne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 14:43:34 -0500
Received: from mga03.intel.com ([134.134.136.65]:38309 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229992AbiAaTnd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 14:43:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643658213; x=1675194213;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3MOtd6z21JSlheNCaTNuTYyHwgkEXtxy5XUoT7itdBU=;
  b=Lx2484CkWe54OKzUkYJOMKk/M0ha70qVOBX5ta/HS3ARi92ef8PIWt9v
   mrLMO8mmC5SobmEYly7W6BWLIGCyzaMTJS3hXMF7tcFZyC9oOE61TGWXb
   gScJyC1xYnUBSct5/NulvRgjwYvwqxmBu1ZUmCy4PPmjBhBlfsSTht98p
   JkNce6fcw9vCY4eQC5D3AYZllP0VDYnozXKyW/kkiSdnVKy1AykKFmRo+
   ObTSZYe2Ri4DqOfPQC0p1okzxnVmAaAnsl+LdNsypmBu6Nfabwu6jL/iu
   K3B9U1mJBLxvMOsRppACKjrvPCEB3+k4EoyRXlVj0IENsoWWZ3GUk3bZg
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="247489708"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="247489708"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:43:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="537448396"
Received: from ssaleem-mobl.amr.corp.intel.com ([10.255.33.15])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:43:32 -0800
From:   Shiraz Saleem <shiraz.saleem@intel.com>
To:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc:     Shiraz Saleem <shiraz.saleem@intel.com>
Subject: [PATCH for-next 0/3] Add DSCP QoS mappings for RDMA
Date:   Mon, 31 Jan 2022 13:43:13 -0600
Message-Id: <20220131194316.1528-1-shiraz.saleem@intel.com>
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
 include/linux/net/intel/iidc.h           |  5 ++++
 11 files changed, 80 insertions(+), 23 deletions(-)

-- 
1.8.3.1

