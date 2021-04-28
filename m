Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA0A36D3E7
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237401AbhD1I1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:27:42 -0400
Received: from mga04.intel.com ([192.55.52.120]:7991 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231635AbhD1I1l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 04:27:41 -0400
IronPort-SDR: GV4zPRzt18lYSfuj9k66bqi1VfLDjUDe5Skko7GPdtucHOsB/B30Vssloj6UGFCki9fnTXBbm6
 mkz6etNK3XfA==
X-IronPort-AV: E=McAfee;i="6200,9189,9967"; a="194573420"
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="194573420"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 01:26:57 -0700
IronPort-SDR: YjGMFsJNq223qMC1ebGzPDpsavJXVWkcNwLS/EBYCkjZqq73lfcboVBxk14WyFJsMokTj3hoa6
 05bwGXoyJTiw==
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="430192218"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2021 01:26:53 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH 0/2] vDPA/ifcvf: implement doorbell mapping feature
Date:   Wed, 28 Apr 2021 16:21:31 +0800
Message-Id: <20210428082133.6766-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements doorbell mapping feature for ifcvf.

Please help review

Thanks!

Zhu Lingshan (2):
  vDPA/ifcvf: record virtio notify base
  vDPA/ifcvf: implement doorbell mapping for ifcvf

 drivers/vdpa/ifcvf/ifcvf_base.c |  1 +
 drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
 drivers/vdpa/ifcvf/ifcvf_main.c | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+)

-- 
2.27.0

