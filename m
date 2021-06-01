Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EB3396DAD
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 09:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhFAHEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 03:04:32 -0400
Received: from mga04.intel.com ([192.55.52.120]:1489 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhFAHE1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 03:04:27 -0400
IronPort-SDR: PEjl+a1Rpb3pIvl/KhZUXb2ZYGQv6a+yga3028SpI6SpW3CLsYJdFRf85pENLQld3paUwlV4vQ
 Pdkn+Aby5/Eg==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="201619813"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="201619813"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 00:02:46 -0700
IronPort-SDR: TpFA7Zl5EkJiXcEFW4CauoXkkmIg9YJIxIY7Ag3HkZSl+2CC8HaLc7yf/9kUs1UOwWoQQYt46a
 vaaQN2RXDWrQ==
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="445224681"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 00:02:44 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/2] virtio: update virtio id table
Date:   Tue,  1 Jun 2021 14:57:08 +0800
Message-Id: <20210601065710.224300-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds transitional device ids in virtio pci
header. Then reuses the ids in ifcvf driver

Zhu Lingshan (2):
  virtio-pci: add transitional device ids in virtio pci header
  vDPA/ifcvf: reuse pre-defined macros for device ids and vendor ids

 drivers/vdpa/ifcvf/ifcvf_base.h | 12 ------------
 drivers/vdpa/ifcvf/ifcvf_main.c | 23 +++++++++++++----------
 include/uapi/linux/virtio_pci.h | 12 ++++++++++++
 3 files changed, 25 insertions(+), 22 deletions(-)

-- 
2.27.0

