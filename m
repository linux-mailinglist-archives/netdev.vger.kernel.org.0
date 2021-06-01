Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A08396D67
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 08:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhFAGgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 02:36:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:35631 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233019AbhFAGgK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 02:36:10 -0400
IronPort-SDR: ypPe3nG26+eddRDQsAqNymBTTp6YVEFRFzReBfhD+R8uqWPIutAQ1qiIwgoNWQBMoQb5jofQcv
 LeogC7cBkv4g==
X-IronPort-AV: E=McAfee;i="6200,9189,10001"; a="267361140"
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="267361140"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 23:34:29 -0700
IronPort-SDR: HuKn10lOFx+Yrc1kbdT/aYbN6H2JbvJYxSw/dQAl40Wkx1gSFC3rBOieSfXkNwIk9WL8gwfWhs
 DnY8sQ4kVLRg==
X-IronPort-AV: E=Sophos;i="5.83,239,1616482800"; 
   d="scan'208";a="446839303"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 23:34:26 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V3 0/2] vDPA/ifcvf: implement doorbell mapping feature
Date:   Tue,  1 Jun 2021 14:28:48 +0800
Message-Id: <20210601062850.4547-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements doorbell mapping feature for ifcvf.

Please help review

Thanks!
Changes from V2:
assign notify_off_multiplier to notification.size first than
use PAGE_SIZE directly(Jason)

Chagnes from V1:
calculate the doorbell address per vq than per device(Jason)
let upper layer driver decide how to use the non page_size
aligned doorbell(Jason)

Zhu Lingshan (2):
  vDPA/ifcvf: record virtio notify base
  vDPA/ifcvf: implement doorbell mapping for ifcvf

 drivers/vdpa/ifcvf/ifcvf_base.c |  4 ++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
 drivers/vdpa/ifcvf/ifcvf_main.c | 21 +++++++++++++++++++++
 3 files changed, 27 insertions(+)

-- 
2.27.0

