Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666183E9CE8
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 05:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbhHLDb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 23:31:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:65081 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229729AbhHLDb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 23:31:28 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10073"; a="212159216"
X-IronPort-AV: E=Sophos;i="5.84,314,1620716400"; 
   d="scan'208";a="212159216"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 20:31:03 -0700
X-IronPort-AV: E=Sophos;i="5.84,314,1620716400"; 
   d="scan'208";a="527545815"
Received: from unknown (HELO cra01infra01.deacluster.intel.com) ([10.240.192.107])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 20:30:57 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RESEND PATCH V3 0/2] vDPA/ifcvf: implement management netlink framework
Date:   Thu, 12 Aug 2021 11:24:52 +0800
Message-Id: <20210812032454.24486-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Rebase on kernel 5.14-rc5, resend)
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

