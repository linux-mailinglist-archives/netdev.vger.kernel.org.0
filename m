Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F063BBE12
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 16:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231404AbhGEOV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 10:21:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:44987 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhGEOV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 10:21:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="207158040"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="207158040"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 07:19:21 -0700
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="485523454"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 07:19:19 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/2] vDPA/ifcvf: implement management netlink framework
Date:   Mon,  5 Jul 2021 22:13:31 +0800
Message-Id: <20210705141333.9262-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements vDPA management netlink for ifcvf.

Please help review

Thanks!

Changes from V1:
(1)handle adapter related error handling in ifcvf_vdpa_dev_add
(Jason and Michael)
(2)relace vdpa_unregister_device() with vdpa_mgmtdev_unregister()
in ifcvf_remove (Jason)
(3)squash patch 3 to patch 2(Jason)

Zhu Lingshan (2):
  vDPA/ifcvf: introduce get_dev_type() which returns virtio dev id
  vDPA/ifcvf: implement management netlink framework for ifcvf

 drivers/vdpa/ifcvf/ifcvf_base.h |   6 +
 drivers/vdpa/ifcvf/ifcvf_main.c | 188 +++++++++++++++++++++++---------
 2 files changed, 145 insertions(+), 49 deletions(-)

-- 
2.27.0

