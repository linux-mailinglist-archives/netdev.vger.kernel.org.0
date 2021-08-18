Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7DD3F012B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhHRKEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:04:05 -0400
Received: from mga03.intel.com ([134.134.136.65]:28419 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232336AbhHRKED (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 06:04:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="216327746"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="216327746"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 03:03:28 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="520889136"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.62])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 03:03:18 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/2] vDPA/ifcvf: enable multiqueue and control vq
Date:   Wed, 18 Aug 2021 17:57:12 +0800
Message-Id: <20210818095714.3220-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enables multi-queue and control vq features
for ifcvf.

These patches are based on my previous vDPA/ifcvf management link
implementation series:
https://lore.kernel.org/kvm/20210812032454.24486-2-lingshan.zhu@intel.com/T/

Thanks!

Zhu Lingshan (2):
  vDPA/ifcvf: detect and use the onboard number of queues directly
  vDPA/ifcvf: enable multiqueue and control vq

 drivers/vdpa/ifcvf/ifcvf_base.c |  8 +++++---
 drivers/vdpa/ifcvf/ifcvf_base.h | 19 ++++---------------
 drivers/vdpa/ifcvf/ifcvf_main.c | 32 +++++++++++++++-----------------
 3 files changed, 24 insertions(+), 35 deletions(-)

-- 
2.27.0

