Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6287B33AC93
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 08:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhCOHug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 03:50:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:17801 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230266AbhCOHuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 03:50:17 -0400
IronPort-SDR: HM6hV8WIXIMI7pmxju6O4ESPn9c6gIBQyB47L3/SMymQjDaECFHQn+byUqnug2Na2uGtlrt2Hw
 qZIzYOvoP7KQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="189140884"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="189140884"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:12 -0700
IronPort-SDR: 8Od4S3PDuI3+GsFlkIZOaYGUhx+hDVeI5LuaDeiy0gRJ45NjSqZH2PKcmiIYdacEckCxHaaXVT
 hBXzTiFCgLsQ==
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="411752161"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:50:09 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com,
        leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 0/7] vDPA/ifcvf: enables Intel C5000X-PL virtio-net
Date:   Mon, 15 Mar 2021 15:44:54 +0800
Message-Id: <20210315074501.15868-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enabled Intel FGPA SmartNIC C5000X-PL virtio-net for vDPA.

vDPA requires VIRTIO_F_ACCESS_PLATFORM as a must,
this series verify this feature bit when set features.

Changes from V3:
checks features to set in verify_min_features(Jason)
deduce VIRTIO device ID from pdev ids in get_device_id(Jason)

Changes from V2:
verify VIRTIO_F_ACCESS_PLATFORM when set features(Jason)

Changes from V1:
remove version number string(Leon)
add new device ids and remove original device ids
in separate patches(Jason)


Zhu Lingshan (7):
  vDPA/ifcvf: get_vendor_id returns a device specific vendor id
  vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
  vDPA/ifcvf: rename original IFCVF dev ids to N3000 ids
  vDPA/ifcvf: remove the version number string
  vDPA/ifcvf: fetch device feature bits when probe
  vDPA/ifcvf: verify mandatory feature bits for vDPA
  vDPA/ifcvf: deduce VIRTIO device ID from pdev ids

 drivers/vdpa/ifcvf/ifcvf_base.c | 66 ++++++++++++++++++++++++++++++++-
 drivers/vdpa/ifcvf/ifcvf_base.h | 17 +++++++--
 drivers/vdpa/ifcvf/ifcvf_main.c | 35 +++++++++++++----
 3 files changed, 104 insertions(+), 14 deletions(-)

-- 
2.27.0

