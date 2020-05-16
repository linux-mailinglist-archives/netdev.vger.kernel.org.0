Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1561D5DA7
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 03:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgEPBai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 21:30:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:39711 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbgEPBai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 21:30:38 -0400
IronPort-SDR: f7jbuj0qwR2gX+3vcLk33wnZOc8bq6K1y8IZDnc5SL+ZoFdVwZPnR9lzLBMvbb7z5wQMib0C0r
 5wkMnbm/RAhg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2020 18:30:37 -0700
IronPort-SDR: GEVT3CY1XvHqywX8FesHrjH7Sa1NlVsEY7h1MGDM8a+4lKoVasR+5ZzfedqEVhGibllqEatfdY
 q4XsNLUPAZbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,397,1583222400"; 
   d="scan'208";a="307569375"
Received: from wkbertra-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.251.131.129])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2020 18:30:37 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        jeffrey.t.kirsher@intel.com, linville@tuxdriver.com,
        vladimir.oltean@nxp.com, po.liu@nxp.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com
Subject: [ethtool RFC 0/3] ethtool: Add support for frame preemption
Date:   Fri, 15 May 2020 18:30:23 -0700
Message-Id: <20200516013026.3174098-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the userspace side of the series proposing an interface via
ethtool for configuring frame preemption, defined in IEEE 802.1Q-2018
(previously IEEE 802.1Qbu) and 802.3br.

Patch 1 of this RFC is only to help testing, and should not be considered.

Patch 2, adds support for the ETHTOOL_GFP and ETHTOOL_SFP commands.

Patch 2, adds support for the netlink messages ETHTOOL_MSG_PREEMPT_GET
and ETHTOOL_MSG_PREEMPT_SET.


Vinicius Costa Gomes (3):
  uapi: Update headers from the kernel [DO NOT APPLY]
  ethtool: Add support for configuring frame preemption
  ethtool: Add support for configuring frame preemption via netlink

 Makefile.am                  |   2 +-
 ethtool.c                    |  94 ++++++++++++
 netlink/desc-ethtool.c       |  13 ++
 netlink/extapi.h             |   4 +
 netlink/preempt.c            | 148 +++++++++++++++++++
 uapi/linux/ethtool.h         |  49 ++++++-
 uapi/linux/ethtool_netlink.h | 267 +++++++++++++++++++++++++++++++++++
 7 files changed, 575 insertions(+), 2 deletions(-)
 create mode 100644 netlink/preempt.c

-- 
2.26.2

