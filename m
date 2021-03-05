Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49E232ED10
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 15:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhCEOZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 09:25:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:51077 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229818AbhCEOZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 09:25:22 -0500
IronPort-SDR: LNWfaa1+t4uQpLCCQhpbfbue4ZatuykL+LHigGAEqGeMmZh1H+z1fx6zmX9Ze+eszgOvp3PIXn
 tCtCB3DR//4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9914"; a="207392732"
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="207392732"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 06:25:22 -0800
IronPort-SDR: cvMtf/qQOEQUJs4oT5VIDPPc9+J+nEP1Rl0oxCchgqUgzRyIRAxKGrp6Y2NBDzG6S6+26RviPy
 JQ/zL0787pWg==
X-IronPort-AV: E=Sophos;i="5.81,225,1610438400"; 
   d="scan'208";a="408315609"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2021 06:25:19 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/3] vDPA/ifcvf: enables Intel C5000X-PL virtio-net
Date:   Fri,  5 Mar 2021 22:19:57 +0800
Message-Id: <20210305142000.18521-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enabled Intel FGPA SmartNIC C5000X-PL virtio-net
for vDPA

Zhu Lingshan (3):
  vDPA/ifcvf: get_vendor_id returns a device specific vendor id
  vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
  vDPA/ifcvf: bump version string to 1.0

 drivers/vdpa/ifcvf/ifcvf_base.h | 13 +++++++++----
 drivers/vdpa/ifcvf/ifcvf_main.c | 20 ++++++++++++++------
 2 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.27.0

