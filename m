Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC21F33098D
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 09:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhCHIk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 03:40:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:18103 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231629AbhCHIkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 03:40:47 -0500
IronPort-SDR: VP1R2fNgB0H4ROvQN4elXIgzEcSUDGiwox5Ej6QNnJSfdmy3pj2wEfNZQNDOwQPObp5kqdAwh6
 zD4RmtvA9ZTA==
X-IronPort-AV: E=McAfee;i="6000,8403,9916"; a="252017299"
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="252017299"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:40:43 -0800
IronPort-SDR: 5/7mWfhbXQZ9W+tE+3a0S4/vPOpQqcAATcML29BS7DsDhncEUFxBmutrNt3ZPPKSiEa0O1DUhZ
 tE7tAFEo1Aqw==
X-IronPort-AV: E=Sophos;i="5.81,232,1610438400"; 
   d="scan'208";a="508855612"
Received: from unknown (HELO localhost.localdomain.bj.intel.com) ([10.240.193.73])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2021 00:40:40 -0800
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     jasowang@redhat.com, mst@redhat.com, lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [PATCH V2 0/4] vDPA/ifcvf: enables Intel C5000X-PL virtio-net
Date:   Mon,  8 Mar 2021 16:35:21 +0800
Message-Id: <20210308083525.382514-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series enabled Intel FGPA SmartNIC C5000X-PL virtio-net for vDPA

changes from V1:
remove version number string(Leon)
add new device ids and remove original device ids
in separate patches(Jason)

Zhu Lingshan (4):
  vDPA/ifcvf: get_vendor_id returns a device specific vendor id
  vDPA/ifcvf: enable Intel C5000X-PL virtio-net for vDPA
  vDPA/ifcvf: rename original IFCVF dev ids to N3000 ids
  vDPA/ifcvf: remove the version number string

 drivers/vdpa/ifcvf/ifcvf_base.h | 13 +++++++++----
 drivers/vdpa/ifcvf/ifcvf_main.c | 20 +++++++++++++-------
 2 files changed, 22 insertions(+), 11 deletions(-)

-- 
2.27.0

