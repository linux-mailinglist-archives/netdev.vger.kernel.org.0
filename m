Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72469360653
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 11:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbhDOJ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 05:59:21 -0400
Received: from mga12.intel.com ([192.55.52.136]:65315 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229457AbhDOJ7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 05:59:19 -0400
IronPort-SDR: Z+a5BHdyuOw9kXoLgxLf5dDheqs6L/XWCieqFwtV6lLHQroNN2ESPXNS3fp+heWrWhVLwsoJ7C
 tRHSwWBaBSmA==
X-IronPort-AV: E=McAfee;i="6200,9189,9954"; a="174321429"
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="174321429"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 02:58:56 -0700
IronPort-SDR: jFIvrl2mBHKk1u1E8zi7r3oVcQPKM0n00OAcUsbqGMuzeam9tumtafOOFqHz3+NpMQpkWDUfMz
 2cCMEZeWhSew==
X-IronPort-AV: E=Sophos;i="5.82,223,1613462400"; 
   d="scan'208";a="425123440"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 02:58:52 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/3] vDPA/ifcvf: enables Intel C5000X-PL virtio-blk
Date:   Thu, 15 Apr 2021 17:53:33 +0800
Message-Id: <20210415095336.4792-1-lingshan.zhu@intel.com>
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
 drivers/vdpa/ifcvf/ifcvf_main.c | 58 +++++++++++++++++++++++++--------
 2 files changed, 52 insertions(+), 15 deletions(-)

-- 
2.27.0

