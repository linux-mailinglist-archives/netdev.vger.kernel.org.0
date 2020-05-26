Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7771B718A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 12:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgDXKHh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 06:07:37 -0400
Received: from mga03.intel.com ([134.134.136.65]:53046 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726808AbgDXKHg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 06:07:36 -0400
IronPort-SDR: sbyXEKFkS2eqBx5N0JhMV63KMwhr3pqeV+PzL9yzs3DLk8oredz/JJd0ExrE9GziMaWg42YWhG
 4x+Gn2TC2kbg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 03:07:33 -0700
IronPort-SDR: iqpJQBt4RyCbuxg/Er9EZDf02Fi1kIQAK37+Wk6ATAN9jt4gJ5Zv2V7tkrxj5+gEPkQFGOm+NG
 wEJrHqwd6mtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="280755901"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by fmsmga004.fm.intel.com with ESMTP; 24 Apr 2020 03:07:30 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/2] Config interrupt support in VDPA and IFCVF 
Date:   Fri, 24 Apr 2020 18:04:17 +0800
Message-Id: <1587722659-1300-1-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes two patches, one introduced
config interrupt support in VDPA core, the other
one implemented config interrupt in IFCVF.

Zhu Lingshan (2):
  vdpa: Support config interrupt in vhost_vdpa
  vdpa: implement config interrupt in IFCVF

 drivers/vdpa/ifcvf/ifcvf_base.c  |  3 +++
 drivers/vdpa/ifcvf/ifcvf_base.h  |  2 ++
 drivers/vdpa/ifcvf/ifcvf_main.c  | 22 ++++++++++++++++-
 drivers/vhost/vdpa.c             | 53 ++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/vhost.h       |  2 ++
 include/uapi/linux/vhost_types.h |  2 ++
 6 files changed, 83 insertions(+), 1 deletion(-)

-- 
1.8.3.1

