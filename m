Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A2131009B
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 00:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhBDXZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 18:25:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:57465 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhBDXZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 18:25:22 -0500
IronPort-SDR: l7i6Lhkjj7v+84LFjW/ztD9pnImuYqiAX9h25y7oeJE09/iAbVhhCdlybAVpA8++Abf1SQsfL+
 EgjWBm/KuTRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="168462968"
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="168462968"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 15:23:36 -0800
IronPort-SDR: pgzViljtDpu/u9+slU+ErP/tV2y33dCz28MzZX9NoyrqK1qkLqp0K0wxbauGGBN58jvLpzVJB4
 iYTJARuoG1lg==
X-IronPort-AV: E=Sophos;i="5.81,153,1610438400"; 
   d="scan'208";a="415560534"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.255.231.23])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2021 15:23:36 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        matthieu.baerts@tessares.net
Subject: [PATCH net-next 0/2] mptcp: Misc. updates for tests & lock annotation
Date:   Thu,  4 Feb 2021 15:23:28 -0800
Message-Id: <20210204232330.202441-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are two fixes we've collected in the mptcp tree.

Patch 1 refactors a MPTCP selftest script to allow running a subset of
the tests.

Patch 2 adds some locking & might_sleep assertations.


Florian Westphal (1):
  mptcp: pm: add lockdep assertions

Geliang Tang (1):
  selftests: mptcp: add command line arguments for mptcp_join.sh

 net/mptcp/pm.c                                |    2 +
 net/mptcp/pm_netlink.c                        |   13 +
 net/mptcp/protocol.c                          |    4 +
 net/mptcp/protocol.h                          |    5 +
 .../testing/selftests/net/mptcp/mptcp_join.sh | 1068 +++++++++--------
 5 files changed, 614 insertions(+), 478 deletions(-)


base-commit: e93fac3b51617401df46332499daae000e322ff8
-- 
2.30.0

