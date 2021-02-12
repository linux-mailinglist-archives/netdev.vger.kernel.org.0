Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F393231A83F
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 00:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhBLXWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 18:22:21 -0500
Received: from mga04.intel.com ([192.55.52.120]:29000 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhBLXWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 18:22:21 -0500
IronPort-SDR: SPaYjivoCFbP5oLzxBP+rXAddw8R5s1nA38n3s5R3hQVxgEU2Im/OI0nxumBkHemYmiheGbYKE
 GHX2wN/t5rYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="179934360"
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="179934360"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:36 -0800
IronPort-SDR: Lw0ku0R1NMsiF2+5HFsAWmKszSHh4uef5PcqWUbJ9E1zPcTOi/nxvLa2rO5j/+/wjxgoOKPr6c
 i7A9mB481ZkQ==
X-IronPort-AV: E=Sophos;i="5.81,175,1610438400"; 
   d="scan'208";a="360595933"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.85.171])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 15:20:35 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org,
        matthieu.baerts@tessares.net
Subject: [PATCH net-next 0/4] mptcp: Selftest enhancement and fixes
Date:   Fri, 12 Feb 2021 15:20:26 -0800
Message-Id: <20210212232030.377261-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a collection of selftest updates from the MPTCP tree.

Patch 1 uses additional 'ss' command line parameters and 'nstat' to
improve output when certain MPTCP tests fail.

Patches 2 & 3 fix a copy/paste error and some output formatting.

Patch 4 makes sure tests still pass if certain connection-related
packets are retransmitted.

Matthieu Baerts (3):
  selftests: mptcp: fix ACKRX debug message
  selftests: mptcp: display warnings on one line
  selftests: mptcp: fail if not enough SYN/3rd ACK

Paolo Abeni (1):
  selftests: mptcp: dump more info on errors

 .../selftests/net/mptcp/mptcp_connect.sh      | 94 +++++++++++++------
 1 file changed, 66 insertions(+), 28 deletions(-)


base-commit: c3ff3b02e99c691197a05556ef45f5c3dd2ed3d6
-- 
2.30.1

