Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57373F0EB9
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 01:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhHRXnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 19:43:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:17429 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235060AbhHRXnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 19:43:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="196031724"
X-IronPort-AV: E=Sophos;i="5.84,333,1620716400"; 
   d="scan'208";a="196031724"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 16:42:47 -0700
X-IronPort-AV: E=Sophos;i="5.84,333,1620716400"; 
   d="scan'208";a="449944706"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.117.66])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 16:42:47 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, geliangtang@gmail.com
Subject: [PATCH net 0/2] mptcp: Bug fixes
Date:   Wed, 18 Aug 2021 16:42:35 -0700
Message-Id: <20210818234237.242266-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are two bug fixes for the net tree:

Patch 1 fixes a memory leak that could be encountered when clearing the
list of advertised MPTCP addresses.

Patch 2 fixes a protocol issue early in an MPTCP connection, to ensure
both peers correctly understand that the full MPTCP connection handshake
has completed even when the server side quickly sends an ADD_ADDR
option.


Matthieu Baerts (1):
  mptcp: full fully established support after ADD_ADDR

Paolo Abeni (1):
  mptcp: fix memory leak on address flush

 net/mptcp/options.c    | 10 +++-------
 net/mptcp/pm_netlink.c | 44 ++++++++++++------------------------------
 2 files changed, 15 insertions(+), 39 deletions(-)


base-commit: fb4b1373dcab086d0619c29310f0466a0b2ceb8a
-- 
2.33.0

