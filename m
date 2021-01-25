Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D9D302B0A
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 20:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbhAYTCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 14:02:24 -0500
Received: from mga05.intel.com ([192.55.52.43]:23607 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727237AbhAYTBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:01:14 -0500
IronPort-SDR: UNZDRfEIonwy3CE5rzhu/WWlSdF3v7VL9yPOZaLcNpaU6Ix4IGWCEnbzVCH1gWcJQT5Y2n4YKM
 +oT5G3PcrVGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="264604204"
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="264604204"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:25 -0800
IronPort-SDR: j1ZAj5kVHfsXUeKH9KG4zyVFTAHO8tihRe/yPEuLYoOpQM8rpXZBHYUdsrH1dy3MchdPXeGGT0
 TB/FWi3COp3w==
X-IronPort-AV: E=Sophos;i="5.79,374,1602572400"; 
   d="scan'208";a="361637469"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.126.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 10:59:25 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.01.org
Subject: [PATCH net-next 0/5] MPTCP: IPv4-mapped IPv6 addressing for subflows
Date:   Mon, 25 Jan 2021 10:58:59 -0800
Message-Id: <20210125185904.6997-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series from the MPTCP tree adds support for IPv4-mapped IPv6
addressing that was missing when multiple subflows were first
implemented.

Patches 1 and 2 handle the conversion and comparison of the mapped
addresses.

Patch 3 contains a minor refactor in the path manager's handling of
addresses.

Patches 4 and 5 add selftests for the new functionality and adjust the
selftest timeout.


Geliang Tang (1):
  selftests: mptcp: add IPv4-mapped IPv6 testcases

Matthieu Baerts (4):
  mptcp: support MPJoin with IPv4 mapped in v6 sk
  mptcp: pm nl: support IPv4 mapped in v6 addresses
  mptcp: pm nl: reduce variable scope
  selftests: increase timeout to 10 min

 net/mptcp/pm_netlink.c                        | 39 +++++++---
 net/mptcp/subflow.c                           | 24 ++++--
 .../testing/selftests/net/mptcp/mptcp_join.sh | 75 +++++++++++++++++++
 tools/testing/selftests/net/mptcp/settings    |  2 +-
 4 files changed, 120 insertions(+), 20 deletions(-)


base-commit: a61e4b60761fa7fa2cfde6682760763537ce5549
-- 
2.30.0
