Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA461377DC6
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 10:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhEJIQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 04:16:47 -0400
Received: from mga18.intel.com ([134.134.136.126]:57585 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhEJIQr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 04:16:47 -0400
IronPort-SDR: K6IWrOaXO8+7cLdFCy0N9+uBhFsraVyytdFkPz8umDwvBgwpqbRlMy1K+tOT+jjmH7WpHzu+iy
 hd4IuULNyF2g==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="186587919"
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="186587919"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:15:42 -0700
IronPort-SDR: vqby9qWuqvjiN0JM+XxyZ4LIXeNrUYf1nt9zotvqg9xSUy2mDUTmSBNHDDaDIIZmT2++aWYeK6
 sHwCNEh+FROw==
X-IronPort-AV: E=Sophos;i="5.82,287,1613462400"; 
   d="scan'208";a="436040620"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2021 01:15:40 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/2] update virtio id table
Date:   Mon, 10 May 2021 16:10:13 +0800
Message-Id: <20210510081015.4212-1-lingshan.zhu@intel.com>
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

