Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1014A398495
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhFBIxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:53:33 -0400
Received: from mga05.intel.com ([192.55.52.43]:29880 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231406AbhFBIxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 04:53:32 -0400
IronPort-SDR: 7TOct9Tp/zHbo5SJYuja3b4Q4Mahdy02Adbux+ETgqSWbtbfCNSumQI+IbukAB52C3akrbjmp4
 XsVRDRWtJ+vA==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="289368375"
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="289368375"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:51:49 -0700
IronPort-SDR: /N/3oaF3y6pRSWxsBHXAhJ1yp4zWEBEe7wH8pP6WVru0XV7+9K2yjuRtGtVvtaFoD0taL6+cnK
 Q+4b1Q9qeviA==
X-IronPort-AV: E=Sophos;i="5.83,241,1616482800"; 
   d="scan'208";a="479628281"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 01:51:47 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RESEND PATCH V4 0/2] vDPA/ifcvf: implement doorbell mapping feature
Date:   Wed,  2 Jun 2021 16:45:48 +0800
Message-Id: <20210602084550.289599-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(resend, add Jason's ack and remove unused vars)

This series implements doorbell mapping feature for ifcvf.

Please help review

Thanks!

Changes from V3:
remove the warning for doorbell non-page-alignment(Jason)

Zhu Lingshan (2):
  vDPA/ifcvf: record virtio notify base
  vDPA/ifcvf: implement doorbell mapping for ifcvf

 drivers/vdpa/ifcvf/ifcvf_base.c |  4 ++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
 drivers/vdpa/ifcvf/ifcvf_main.c | 16 ++++++++++++++++
 3 files changed, 22 insertions(+)

-- 
2.27.0

