Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BD04405F0
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 01:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhJ2X7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 19:59:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:55256 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229546AbhJ2X7M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 19:59:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="230634267"
X-IronPort-AV: E=Sophos;i="5.87,194,1631602800"; 
   d="scan'208";a="230634267"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 16:56:43 -0700
X-IronPort-AV: E=Sophos;i="5.87,194,1631602800"; 
   d="scan'208";a="487759729"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.3.7])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 16:56:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        pabeni@redhat.com, mptcp@lists.linux.dev
Subject: [PATCH net-next 0/2] mptcp: Some selftest improvements
Date:   Fri, 29 Oct 2021 16:55:57 -0700
Message-Id: <20211029235559.246858-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are a couple of selftest changes for MPTCP.

Patch 1 fixes a mistake where the wrong protocol (TCP vs MPTCP) could be
requested on the listening socket in some link failure tests.

Patch 2 refactors the simulataneous flow tests to improve timing
accuracy and give more consistent results.


Geliang Tang (1):
  selftests: mptcp: fix proto type in link_failure tests

Paolo Abeni (1):
  selftests: mptcp: more stable simult_flows tests

 .../selftests/net/mptcp/mptcp_connect.c       | 72 +++++++++++++++----
 .../testing/selftests/net/mptcp/mptcp_join.sh |  2 +-
 .../selftests/net/mptcp/simult_flows.sh       | 36 ++++------
 3 files changed, 73 insertions(+), 37 deletions(-)


base-commit: 28131d896d6d316bc1f6f305d1a9ed6d96c3f2a1
-- 
2.33.1

