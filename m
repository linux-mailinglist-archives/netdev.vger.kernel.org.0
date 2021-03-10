Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 719B033381B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 10:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhCJJGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 04:06:03 -0500
Received: from mga03.intel.com ([134.134.136.65]:64352 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229544AbhCJJGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 04:06:01 -0500
IronPort-SDR: 4FZetOKMarS+UDH+t9lRD4sFMo4/L+MG1dHGfrO//N36U/cyeExmK7AGLFzB2VeiELLq52ZDh9
 SDPxiwGeTjig==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188461249"
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="188461249"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:06:00 -0800
IronPort-SDR: C2P/5eS9Tn3+Kw5cuTpUQ8fg1w7HszNPfkveY4eJNXMT88dS+k/pQRnSuoUYUZZKQ5BSIMWm+N
 iUQdVbP4tQvg==
X-IronPort-AV: E=Sophos;i="5.81,237,1610438400"; 
   d="scan'208";a="410110225"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2021 01:05:57 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 0/6] vDPA/ifcvf: enables Intel C5000X-PL virtio-net
Date:   Wed, 10 Mar 2021 17:00:46 +0800
Message-Id: <20210310090052.4762-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enabled Intel FGPA SmartNIC C5000X-PL
virtio-net for vDPA.
vDPA requires VIRTIO_F_ACCESS_PLATFORM as a must, this series
verify this feature bit when set features.

Changes from V2:
verify VIRTIO_F_ACCESS_PLATFORM when set features(Jason)

Changes from V1:
remove version number string(Leon)
add new device ids and remove original device ids in
separate patches(Jason)

Zhu Lingshan (6):
  vDPA/ifcvf: get_vendor_id returns a device specific vendor id
  vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
  vDPA/ifcvf: rename original IFCVF dev ids to N3000 ids
  vDPA/ifcvf: remove the version number string
  vDPA/ifcvf: fetch device feature bits when probe
  vDPA/ifcvf: verify mandatory feature bits for vDPA

 drivers/vdpa/ifcvf/ifcvf_base.c | 20 ++++++++++++++++++--
 drivers/vdpa/ifcvf/ifcvf_base.h | 16 ++++++++++++----
 drivers/vdpa/ifcvf/ifcvf_main.c | 27 ++++++++++++++++++++-------
 3 files changed, 50 insertions(+), 13 deletions(-)

-- 
2.27.0

