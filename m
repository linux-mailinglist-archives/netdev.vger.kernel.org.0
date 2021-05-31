Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DEA39565D
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbhEaHlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:41:19 -0400
Received: from mga07.intel.com ([134.134.136.100]:63237 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhEaHlD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 03:41:03 -0400
IronPort-SDR: wZm79MtOxrQVH0Ry9qPFC4j/K/uwy5XrvKrsDavYUIDEzG776XjnhAiHzY7u2lYHDCNH+xsVuj
 r9qtyiTYN5dA==
X-IronPort-AV: E=McAfee;i="6200,9189,10000"; a="267194628"
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="267194628"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 00:39:22 -0700
IronPort-SDR: 8mzKjbSk3zBRRTTG/FCo+6jedjy0RykXOVWJfJd3eOxed+w9zvOh3PQ5Li0RtfssqKaPY6Fkl4
 l0bolLC04t1w==
X-IronPort-AV: E=Sophos;i="5.83,236,1616482800"; 
   d="scan'208";a="478811507"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.192.107])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2021 00:39:19 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 RESEND 0/2] vDPA/ifcvf: implement doorbell mapping feature
Date:   Mon, 31 May 2021 15:33:14 +0800
Message-Id: <20210531073316.363655-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements doorbell mapping feature for ifcvf.

Please help review

Thanks!

Chagnes from V1:
calculate the doorbell address per vq than per device(Jason)
let upper layer driver decide how to use the non page_size
aligned doorbell(Jason)

Zhu Lingshan (2):
  vDPA/ifcvf: record virtio notify base
  vDPA/ifcvf: implement doorbell mapping for ifcvf

 drivers/vdpa/ifcvf/ifcvf_base.c |  4 ++++
 drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
 drivers/vdpa/ifcvf/ifcvf_main.c | 17 +++++++++++++++++
 3 files changed, 23 insertions(+)

-- 
2.27.0

