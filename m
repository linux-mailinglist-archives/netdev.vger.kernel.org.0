Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAB6F39562C
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhEaHfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:35:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:35460 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230306AbhEaHf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 03:35:29 -0400
IronPort-SDR: wHt5vwHo5IjwWOv6pkLGWw11NDLjkuDSGsEgiCEdPGTZD3CLHX/XDBu1/AQTYIX6zw/4yMhxhr
 kqmgEJI7Rk5w==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="203316610"
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="203316610"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 00:33:49 -0700
IronPort-SDR: fUMce9IW/gAo8Bbyzk5PZneExi+5BSxd1qXloF9Hy0SUgNbl5ZfnmTASEe8oD/Tv82sgBaXlu/
 VFRH17fJwOnA==
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="478809795"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 00:33:47 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH RESEND 0/2] update virtio id table
Date:   Mon, 31 May 2021 15:27:41 +0800
Message-Id: <20210531072743.363171-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series updates virtio id table by adding
transitional device ids. Then reuses the ids
in ifcvf driver

Zhu Lingshan (2):
  virtio: update virtio id table, add transitional ids
  vDPA/ifcvf: reuse pre-defined macros for device ids and vendor ids

 drivers/vdpa/ifcvf/ifcvf_base.h | 12 ------------
 drivers/vdpa/ifcvf/ifcvf_main.c | 23 +++++++++++++----------
 include/uapi/linux/virtio_ids.h | 12 ++++++++++++
 3 files changed, 25 insertions(+), 22 deletions(-)

-- 
2.27.0

