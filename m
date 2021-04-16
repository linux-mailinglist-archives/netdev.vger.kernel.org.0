Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19137361A74
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 09:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239201AbhDPHWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 03:22:17 -0400
Received: from mga14.intel.com ([192.55.52.115]:57485 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230466AbhDPHWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 03:22:16 -0400
IronPort-SDR: z8daStGJ5qd75FSECTrJ5DEvNL1OKS+4gOP7WIpNJnkCTRISQSoQl/xFXIRVAJCwCN/B2lmsrg
 7x9oXwCecx6Q==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="194561047"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="194561047"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:21:51 -0700
IronPort-SDR: H/KIcLRhf1m9Jvw4nc0FVMfzl2cgmwTDssmiA06Z1OvItZvPn5AgtrNaqhXxuHQHud5MN976Hg
 vL4++NAAmT1Q==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="425489727"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 00:21:46 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 0/3] vDPA/ifcvf: enables Intel C5000X-PL virtio-blk
Date:   Fri, 16 Apr 2021 15:16:25 +0800
Message-Id: <20210416071628.4984-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enabled Intel FGPA SmartNIC C5000X-PL virtio-blk for vDPA.

This series requires:
Stefano's vdpa block patchset: https://lkml.org/lkml/2021/3/15/2113
my patchset to enable Intel FGPA SmartNIC C5000X-PL virtio-net for vDPA:
https://lkml.org/lkml/2021/3/17/432

changes from V2:
both get_features() and get_config_size() use switch code block
now(Stefano)

changes from V1:
(1)add comments to explain this driver drives virtio modern devices
and transitional devices in modern mode.(Jason)
(2)remove IFCVF_BLK_SUPPORTED_FEATURES, use hardware feature bits
directly(Jason)
(3)add error handling and message in get_config_size(Stefano)

Thanks!


Zhu Lingshan (3):
  vDPA/ifcvf: deduce VIRTIO device ID when probe
  vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA
  vDPA/ifcvf: get_config_size should return dev specific config size

 drivers/vdpa/ifcvf/ifcvf_base.h |  9 ++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 68 ++++++++++++++++++++++++++-------
 2 files changed, 62 insertions(+), 15 deletions(-)

-- 
2.27.0

