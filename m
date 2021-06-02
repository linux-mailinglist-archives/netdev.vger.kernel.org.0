Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9822339846F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhFBIqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:46:31 -0400
Received: from mga12.intel.com ([192.55.52.136]:27150 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhFBIq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 04:46:29 -0400
IronPort-SDR: lb1mP7FCYbm0Bh454uSvU1+XMJWglfXL7dP9ge6rqgLTL+/OdSsk2iCHCJVlsnzRklT6L4Pjix
 oA1mCvG4d/5g==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="183419589"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="183419589"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:44:46 -0700
IronPort-SDR: FgtxRTvIC9A90dpDK7UFWPiC5iD0nJitdIWytCYWqIgiJdOSGn7WLKO5g8xORr7Wyxw/Fo+b4M
 Cs9WyERBA9Zg==
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="479626575"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:44:44 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V4 0/2] vDPA/ifcvf: implement doorbell mapping feature
Date:   Wed,  2 Jun 2021 16:39:04 +0800
Message-Id: <20210602083906.289150-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements doorbell mapping feature for ifcvf.

Please help review

Thanks!

Changes from V3:
remove the warning for doorbell non-page-alignment(Jason)

Changes from V2:
assign notify_off_multiplier to notification.size first than use PAGE_SIZE directly(Jason)

Chagnes from V1:
calculate the doorbell address per vq than per device(Jason) let upper layer driver decide how to use the non page_size aligned doorbell(Jason)

Zhu Lingshan (2):
  vDPA/ifcvf: record virtio notify base
  vDPA/ifcvf: implement doorbell mapping for ifcvf

 drivers/vdpa/ifcvf/ifcvf_base.c |  4 ++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
 drivers/vdpa/ifcvf/ifcvf_main.c | 18 ++++++++++++++++++
 3 files changed, 24 insertions(+)

-- 
2.27.0

