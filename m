Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B3D362B24
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhDPWis (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:38:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:38335 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231296AbhDPWin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:38:43 -0400
IronPort-SDR: UlvqZMX5/+kQjh2Bki+kNv4cU21p4fyy0paclO1tW1+C7H/2YsOW6Gx5PQakBS86SZsrzE+fyv
 zMrkN6Nenq8A==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="215670598"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="215670598"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:17 -0700
IronPort-SDR: mxYuzjH3ke5K39Wv96+Pxh2xzNh3Za+6ouNh9QBgaz9HNNSU/Y6ifLescYnUg9Yn58Dcrs7Ocx
 /GEfGC+dQ/7g==
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="462107386"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.43.70])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 15:38:17 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: [PATCH net-next 0/8] mptcp: Fixes and tracepoints from the mptcp tree
Date:   Fri, 16 Apr 2021 15:38:00 -0700
Message-Id: <20210416223808.298842-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's one more batch of changes that we've tested out in the MPTCP tree.


Patch 1 makes the MPTCP KUnit config symbol more consistent with other
subsystems.

Patch 2 fixes a couple of format specifiers in pr_debug()s

Patches 3-7 add four helpful tracepoints for MPTCP.

Patch 8 is a one-line refactor to use an available helper macro.


Geliang Tang (7):
  mptcp: fix format specifiers for unsigned int
  mptcp: export mptcp_subflow_active
  mptcp: add tracepoint in mptcp_subflow_get_send
  mptcp: add tracepoint in get_mapping_status
  mptcp: add tracepoint in ack_update_msk
  mptcp: add tracepoint in subflow_check_data_avail
  mptcp: use mptcp_for_each_subflow in mptcp_close

Nico Pache (1):
  kunit: mptcp: adhere to KUNIT formatting standard

 MAINTAINERS                  |   1 +
 include/trace/events/mptcp.h | 173 +++++++++++++++++++++++++++++++++++
 net/mptcp/Kconfig            |   2 +-
 net/mptcp/Makefile           |   2 +-
 net/mptcp/crypto.c           |   2 +-
 net/mptcp/options.c          |   6 ++
 net/mptcp/protocol.c         |  26 ++----
 net/mptcp/protocol.h         |  12 +++
 net/mptcp/subflow.c          |  10 +-
 net/mptcp/token.c            |   2 +-
 10 files changed, 207 insertions(+), 29 deletions(-)
 create mode 100644 include/trace/events/mptcp.h


base-commit: 4ad29b1a484e0c58acfffdcd87172ed17f35c1dd
-- 
2.31.1

