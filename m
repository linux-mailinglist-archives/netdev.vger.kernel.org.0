Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96743BC4DC
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 04:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhGFCpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 22:45:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:13832 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229793AbhGFCpT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 22:45:19 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="206037246"
X-IronPort-AV: E=Sophos;i="5.83,327,1616482800"; 
   d="scan'208";a="206037246"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 19:42:40 -0700
X-IronPort-AV: E=Sophos;i="5.83,327,1616482800"; 
   d="scan'208";a="496320544"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 19:42:38 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 0/2] vDPA/ifcvf: implement management netlink framework
Date:   Tue,  6 Jul 2021 10:36:47 +0800
Message-Id: <20210706023649.23360-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements vDPA management netlink for ifcvf.

Please help review

Thanks!

Changes from V2:
fix typos in commit messages(Michael)

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

