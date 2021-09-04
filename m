Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EBC400B5B
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 14:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbhIDMiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 08:38:05 -0400
Received: from mga06.intel.com ([134.134.136.31]:13228 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231193AbhIDMiE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Sep 2021 08:38:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10096"; a="280644790"
X-IronPort-AV: E=Sophos;i="5.85,268,1624345200"; 
   d="scan'208";a="280644790"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2021 05:37:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,268,1624345200"; 
   d="scan'208";a="603781785"
Received: from lkp-server01.sh.intel.com (HELO 2115029a3e5c) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 04 Sep 2021 05:37:02 -0700
Received: from kbuild by 2115029a3e5c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mMUur-0001V7-Hy; Sat, 04 Sep 2021 12:37:01 +0000
Date:   Sat, 4 Sep 2021 20:36:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Toms Atteka <cpp.code.lv@gmail.com>
Subject: [RFC PATCH] net: openvswitch: IPv6: get_ipv6_ext_hdrs() can be static
Message-ID: <20210904123604.GA7610@e282d3512500>
References: <20210903205332.707905-1-cpp.code.lv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903205332.707905-1-cpp.code.lv@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/openvswitch/flow.c:268:6: warning: symbol 'get_ipv6_ext_hdrs' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 flow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index 9985a1e969d23..a1b06f359d738 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -265,7 +265,7 @@ static bool icmphdr_ok(struct sk_buff *skb)
  *      Destination Options header
  *      upper-layer header
  */
-void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh, u16 *ext_hdrs)
+static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh, u16 *ext_hdrs)
 {
 	u8 next_type = nh->nexthdr;
 	unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
