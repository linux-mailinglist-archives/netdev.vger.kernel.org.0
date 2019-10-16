Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2C1D853A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 03:10:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390464AbfJPBKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 21:10:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:43814 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730242AbfJPBKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 21:10:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 18:10:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,301,1566889200"; 
   d="scan'208";a="207749069"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO localhost.localdomain) ([10.249.68.79])
  by orsmga002.jf.intel.com with ESMTP; 15 Oct 2019 18:10:42 -0700
From:   Zhu Lingshan <lingshan.zhu@intel.com>
To:     mst@redhat.com, jasowang@redhat.com, alex.williamson@redhat.com
Cc:     linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernle.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com, Zhu Lingshan <lingshan.zhu@intel.com>
Subject: [RFC 0/2] Intel IFC VF driver for vdpa
Date:   Wed, 16 Oct 2019 09:10:39 +0800
Message-Id: <20191016011041.3441-1-lingshan.zhu@intel.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all:
 
This series intends to introduce Intel IFC VF NIC driver for Vhost
Data Plane Acceleration.
 
Here comes two main parts, one is ifcvf_base layer, which handles
hardware operations. The other is ifcvf_main layer handles VF
initialization, configuration and removal, which depends on
and complys to vhost_mdev https://lkml.org/lkml/2019/9/26/15 
 
This is a first RFC try, please help review.
 
Thanks!
BR
Zhu Lingshan


Zhu Lingshan (2):
  vhost: IFC VF hardware operation layer
  vhost: IFC VF vdpa layer

 drivers/vhost/ifcvf/ifcvf_base.c | 390 ++++++++++++++++++++++++++++
 drivers/vhost/ifcvf/ifcvf_base.h | 137 ++++++++++
 drivers/vhost/ifcvf/ifcvf_main.c | 541 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 1068 insertions(+)
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.c
 create mode 100644 drivers/vhost/ifcvf/ifcvf_base.h
 create mode 100644 drivers/vhost/ifcvf/ifcvf_main.c

-- 
2.16.4

