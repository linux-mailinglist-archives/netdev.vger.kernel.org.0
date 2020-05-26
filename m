Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7B51B8CD6
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 08:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgDZGNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 02:13:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:31290 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgDZGND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 02:13:03 -0400
IronPort-SDR: uE7c2t05CizW4lAA34B5FbY4xkGTlPhx6LLAy6+6n4ocbmLOkYm8XQNjc9O+OIGwjtcydweCdR
 NnXomUX2GtxA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2020 23:13:03 -0700
IronPort-SDR: AtaG2NgYh4Rn6AOeo+I96LcPsmcLkTwOgVyLR1UF2KHMa1y2+dn5QXvLjFyg8fI+Mclm2zP6Vb
 KEFNx/aLF+zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,319,1583222400"; 
   d="scan'208";a="256865171"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.79])
  by orsmga003.jf.intel.com with ESMTP; 25 Apr 2020 23:13:01 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/2] Config interrupt support in VDPA and IFCVF
Date:   Sun, 26 Apr 2020 14:09:42 +0800
Message-Id: <1587881384-2133-1-git-send-email-lingshan.zhu@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series includes two patches, one introduced
config interrupt support in VDPA core, the other
one implemented config interrupt in IFCVF.

changes from V1:
vdpa: more efficient code to handle eventfd unbind.
ifcvf: add VIRTIO_NET_F_STATUS feature bit.

Zhu Lingshan (2):
  vdpa: Support config interrupt in vhost_vdpa
  vdpa: implement config interrupt in IFCVF

 drivers/vdpa/ifcvf/ifcvf_base.c |  3 +++
 drivers/vdpa/ifcvf/ifcvf_base.h |  3 +++
 drivers/vdpa/ifcvf/ifcvf_main.c | 22 ++++++++++++++++++-
 drivers/vhost/vdpa.c            | 47 +++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.c           |  2 +-
 drivers/vhost/vhost.h           |  2 ++
 include/uapi/linux/vhost.h      |  2 ++
 7 files changed, 79 insertions(+), 2 deletions(-)

-- 
1.8.3.1

