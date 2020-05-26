Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8721B8E05
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 10:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgDZIqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 04:46:13 -0400
Received: from mga17.intel.com ([192.55.52.151]:6125 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726108AbgDZIqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 04:46:13 -0400
IronPort-SDR: jt49hWd1uiouWJLoS4+6XrcDhtjez6cG61/stk4af0BsNMh8sXlVG1UDup1c1Gt6DZMVP7x6cR
 XlCsH2cjhvYw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2020 01:46:12 -0700
IronPort-SDR: 4S4pUaJtwHso2B+QBXp5ze3iwV8hFjiOHnRPyTrRnJYyT+7+HweHbT2nuD4LI4iXiisBa5Tt4Q
 rBESQHHA2r0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,319,1583222400"; 
   d="scan'208";a="275128384"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by orsmga002.jf.intel.com with ESMTP; 26 Apr 2020 01:46:10 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 0/2] Config interrupt support in VDPA and IFCVF
Date:   Sun, 26 Apr 2020 16:42:50 +0800
Message-Id: <1587890572-39093-1-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes two patches, one introduced
config interrupt support in VDPA core, the other
one implemented config interrupt in IFCVF.

changes from V2:
move VHOST_FILE_UNBIND to the uapi header.

changes from V1:
vdpa: more efficient code to handle eventfd unbind.
ifcvf: add VIRTIO_NET_F_STATUS feature bit.

Zhu Lingshan (2):
  vdpa: Support config interrupt in vhost_vdpa
  vdpa: implement config interrupt in IFCVF
Zhu Lingshan (2):
  vdpa: Support config interrupt in vhost_vdpa
  vdpa: implement config interrupt in IFCVF

 drivers/vdpa/ifcvf/ifcvf_base.c |  3 +++
 drivers/vdpa/ifcvf/ifcvf_base.h |  3 +++
 drivers/vdpa/ifcvf/ifcvf_main.c | 22 ++++++++++++++++++-
 drivers/vhost/vdpa.c            | 47 +++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.c           |  2 +-
 include/uapi/linux/vhost.h      |  4 ++++
 6 files changed, 79 insertions(+), 2 deletions(-)

-- 
1.8.3.1

