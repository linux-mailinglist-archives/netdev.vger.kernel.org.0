Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A405F3806C2
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhENKFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:05:55 -0400
Received: from mga04.intel.com ([192.55.52.120]:4949 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232625AbhENKFw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 06:05:52 -0400
IronPort-SDR: Jf50Z092V4IMmWRIjyqckEZeTOc4OTXp+C43zV10IIKMzIKVGqPWj1lGwoH5tpXhNWPzgv2YLo
 CSd7G5BEOSLw==
X-IronPort-AV: E=McAfee;i="6200,9189,9983"; a="198195246"
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="198195246"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 03:04:40 -0700
IronPort-SDR: A4IWqA20U77VG6FTbgwb+VNwWKVpKGidEqjxEffwOWIMbbAVnOrwK67sxI9aUFlyF8/LPiW55p
 l8cTanR8KM2w==
X-IronPort-AV: E=Sophos;i="5.82,299,1613462400"; 
   d="scan'208";a="626910425"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2021 03:04:39 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/2] vDPA/ifcvf: implement doorbell mapping feature
Date:   Fri, 14 May 2021 17:59:11 +0800
Message-Id: <20210514095913.41777-1-lingshan.zhu@intel.com>
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
 drivers/vdpa/ifcvf/ifcvf_main.c | 16 ++++++++++++++++
 3 files changed, 22 insertions(+)

-- 
2.27.0

