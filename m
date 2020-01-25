Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C0514923A
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 01:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbgAYAES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 19:04:18 -0500
Received: from mga14.intel.com ([192.55.52.115]:45732 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729367AbgAYAES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 19:04:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Jan 2020 16:04:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,359,1574150400"; 
   d="scan'208";a="251447330"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.22.36])
  by fmsmga004.fm.intel.com with ESMTP; 24 Jan 2020 16:04:17 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.01.org, edumazet@google.com
Subject: [PATCH net-next 0/2] MPTCP: Fixups for part 2
Date:   Fri, 24 Jan 2020 16:04:01 -0800
Message-Id: <20200125000403.251894-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few fixes for MPTCP code that are needed before more features are
added in part 3.

Florian Westphal (1):
  mptcp: do not inherit inet proto ops

Mat Martineau (1):
  mptcp: Fix code formatting

 include/net/ipv6.h   |  3 ++
 net/mptcp/protocol.c | 72 ++++++++++++++++++++++++++++++++------------
 net/mptcp/subflow.c  |  4 +--
 3 files changed, 57 insertions(+), 22 deletions(-)

-- 
2.25.0

