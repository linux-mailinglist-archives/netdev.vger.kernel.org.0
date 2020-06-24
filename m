Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2512096F1
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 01:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgFXXLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 19:11:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:29987 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728035AbgFXXLo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 19:11:44 -0400
IronPort-SDR: gtGQvuDsWGr1hywB5OPmmBIydflzDKSEGQGzscA9NGeYnPF/wg0qZYqkyVSdFCf2pLOpj8eO9k
 tTmuAMDNxnxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="124913563"
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="124913563"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2020 16:11:43 -0700
IronPort-SDR: cwNjev8e0eRsOAM6ZNNWCk00uRGUq1jyBktjAHw1BdKPAltuu3qy6iLDCBrf1jFAcYMnLe3CxN
 RF4oaMvMnDBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,276,1589266800"; 
   d="scan'208";a="265203858"
Received: from lkp-server01.sh.intel.com (HELO 538b5e3c8319) ([10.239.97.150])
  by fmsmga008.fm.intel.com with ESMTP; 24 Jun 2020 16:11:42 -0700
Received: from kbuild by 538b5e3c8319 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1joEYQ-0001Bn-4v; Wed, 24 Jun 2020 23:11:42 +0000
Date:   Thu, 25 Jun 2020 07:11:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        justin.iurman@uliege.be
Subject: [RFC PATCH] ipv6: ioam: ioam6_fill_trace_data_node() can be static
Message-ID: <20200624231122.GA39865@3378fbf3c7a6>
References: <20200624192310.16923-4-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624192310.16923-4-justin.iurman@uliege.be>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 ioam6.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index 406aa78eb504c..4a4e72bb54cc5 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -78,8 +78,8 @@ struct ioam6_namespace *ioam6_namespace(struct net *net, __be16 id)
 	return rhashtable_lookup_fast(&nsdata->namespaces, &id, rht_ns_params);
 }
 
-void ioam6_fill_trace_data_node(struct sk_buff *skb, int nodeoff,
-				u32 trace_type, struct ioam6_namespace *ns)
+static void ioam6_fill_trace_data_node(struct sk_buff *skb, int nodeoff,
+				       u32 trace_type, struct ioam6_namespace *ns)
 {
 	u8 *data = skb_network_header(skb) + nodeoff;
 	struct __kernel_sock_timeval ts;
