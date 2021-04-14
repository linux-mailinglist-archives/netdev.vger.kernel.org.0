Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D479C35F0BC
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 11:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350279AbhDNJYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 05:24:33 -0400
Received: from mga17.intel.com ([192.55.52.151]:26128 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348525AbhDNJYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 05:24:23 -0400
IronPort-SDR: 9NukotK7CH+/DmWwoyCqcSiSwBwbBmVqv2rSSjlr51e4eD/V4hitCydUj0dg+wHz9BwveCcoD9
 AoB7Ptz6X+gw==
X-IronPort-AV: E=McAfee;i="6200,9189,9953"; a="174709601"
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="174709601"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 02:24:02 -0700
IronPort-SDR: iwdI7HnwIdnS0XlZHIxJCGkdcBm6ktLjaxolmmcNJxNuTmEHqlfrEgIYa+k7RMCKwDvIiA5KNa
 Z+jFF7kXoWxw==
X-IronPort-AV: E=Sophos;i="5.82,221,1613462400"; 
   d="scan'208";a="424648438"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2021 02:23:59 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/3] vDPA/ifcvf: enables Intel C5000X-PL virtio-blk
Date:   Wed, 14 Apr 2021 17:18:29 +0800
Message-Id: <20210414091832.5132-1-lingshan.zhu@intel.com>
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

Thanks!

Zhu Lingshan (3):
  vDPA/ifcvf: deduce VIRTIO device ID when probe
  vDPA/ifcvf: enable Intel C5000X-PL virtio-block for vDPA
  vDPA/ifcvf: get_config_size should return dev specific config size

 drivers/vdpa/ifcvf/ifcvf_base.h | 18 +++++++++++++-
 drivers/vdpa/ifcvf/ifcvf_main.c | 43 ++++++++++++++++++++++-----------
 2 files changed, 46 insertions(+), 15 deletions(-)

-- 
2.27.0

