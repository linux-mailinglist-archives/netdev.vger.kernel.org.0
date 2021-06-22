Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED543AFA33
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 02:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhFVAfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 20:35:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:8652 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230175AbhFVAfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 20:35:31 -0400
IronPort-SDR: sjnnTvAyD7ziWK6Oo4bzgj0ilKc/so4Hl+3GFvTQ6Mw+PF1GVLxlMUtL76E39Rk5epmaMDbkGU
 KqFAM2XvjRig==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="203944693"
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="203944693"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 17:33:14 -0700
IronPort-SDR: ifWrKQun0x/KqCSKstUD1fh4aB6zLHqi80f3XYqZpkK1Db6QNvDEKDqy2sazZeWxATB4MW4mnO
 IaFd0flXANXg==
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="417234897"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.74.136])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 17:33:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, pabeni@redhat.com, fw@strlen.de,
        dcaratti@redhat.com
Subject: [PATCH net 0/2] mptcp: Fixes for v5.13
Date:   Mon, 21 Jun 2021 17:33:07 -0700
Message-Id: <20210622003309.71224-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here are two MPTCP fixes from Paolo.

Patch 1 fixes some possible connect-time race conditions with
MPTCP-level connection state changes.

Patch 2 deletes a duplicate function declaration.


Paolo Abeni (2):
  mptcp: avoid race on msk state changes
  mptcp: drop duplicate mptcp_setsockopt() declaration

 net/mptcp/protocol.c |  5 +++++
 net/mptcp/protocol.h |  5 ++---
 net/mptcp/subflow.c  | 30 ++++++++++++++++++++++--------
 3 files changed, 29 insertions(+), 11 deletions(-)


base-commit: 0cd58e5c53babb9237b741dbef711f0a9eb6d3fd
-- 
2.32.0

