Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFE028D1EA
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 18:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731597AbgJMQMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 12:12:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:24134 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgJMQMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 12:12:47 -0400
IronPort-SDR: hnYRiGojH8f/NCzb4791suF+7pCiytAeKyrD0u5PB+waqEfEvuNJ6we+vqLe4FheVPgEocFXsI
 8tRwwZK9mBwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="153768918"
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="153768918"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 09:12:46 -0700
IronPort-SDR: 3GPpZsVUK4yaLqbcSuY5s+ZiMBjEdoEuWfsjVvmiUCexumqv01Jb7SxDV3Pe/bef6DE0qr2zbH
 YFpOJio6hV6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,371,1596524400"; 
   d="scan'208";a="313854600"
Received: from lkp-server02.sh.intel.com (HELO c57e4c60a28b) ([10.239.97.151])
  by orsmga003.jf.intel.com with ESMTP; 13 Oct 2020 09:12:44 -0700
Received: from kbuild by c57e4c60a28b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1kSMup-000019-Sc; Tue, 13 Oct 2020 16:12:43 +0000
Date:   Wed, 14 Oct 2020 00:11:53 +0800
From:   kernel test robot <lkp@intel.com>
To:     Reji Thomas <rejithomas@juniper.net>, kuba@kernel.org
Cc:     kbuild-all@lists.01.org, david.lebrun@uclouvain.be,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rejithomas@juniper.net,
        rejithomas.d@gmail.com
Subject: [RFC PATCH] IPv6: sr: seg6_strict_lookup_nexthop() can be static
Message-ID: <20201013161153.GA54884@b456307fa776>
References: <20201013120151.9777-1-rejithomas@juniper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013120151.9777-1-rejithomas@juniper.net>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 seg6_local.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 1a669f12d56c9d..e949d24036c2cd 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -219,8 +219,8 @@ int seg6_lookup_nexthop(struct sk_buff *skb,
 	return seg6_lookup_any_nexthop(skb, nhaddr, 0, tbl_id, false);
 }
 
-int seg6_strict_lookup_nexthop(struct sk_buff *skb,
-			       struct in6_addr *nhaddr, int oif, u32 tbl_id)
+static int seg6_strict_lookup_nexthop(struct sk_buff *skb,
+				      struct in6_addr *nhaddr, int oif, u32 tbl_id)
 {
 	return seg6_lookup_any_nexthop(skb, nhaddr, oif, tbl_id, false);
 }
