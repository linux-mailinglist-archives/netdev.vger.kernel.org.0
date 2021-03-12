Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064CD338446
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 04:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhCLDLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 22:11:47 -0500
Received: from mga04.intel.com ([192.55.52.120]:17285 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhCLDLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 22:11:43 -0500
IronPort-SDR: pmt0OkcRBgh4R1A2HyEGyG2YfkBZW72D5OvE/dTqbpLQdc93CJI9rK6h5n+bQtShqkgUUbKf/N
 mv9dXAQw/jGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="186401181"
X-IronPort-AV: E=Sophos;i="5.81,242,1610438400"; 
   d="scan'208";a="186401181"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 19:11:42 -0800
IronPort-SDR: diTdqvs9ADgSeFILntH4F4HT3R0RCSjldSq0gTzM0QGitfk5RhdRdaAaRkLmIGk0TJunPoUIA8
 83I8G9ldIVog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,242,1610438400"; 
   d="scan'208";a="409714603"
Received: from lkp-server02.sh.intel.com (HELO ce64c092ff93) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 19:11:41 -0800
Received: from kbuild by ce64c092ff93 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lKYDE-00017n-Fx; Fri, 12 Mar 2021 03:11:40 +0000
Date:   Fri, 12 Mar 2021 11:10:55 +0800
From:   kernel test robot <lkp@intel.com>
To:     ishaangandhi <ishaangandhi@gmail.com>, davem@davemloft.net
Cc:     kbuild-all@lists.01.org, ishaangandhi@gmail.com,
        netdev@vger.kernel.org, willemb@google.com
Subject: [RFC PATCH] icmp: icmp_identify_arrival_interface() can be static
Message-ID: <20210312031055.GA56313@2b632431e2d5>
References: <20210312004706.33046-1-ishaangandhi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312004706.33046-1-ishaangandhi@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 icmp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 8b63f2853e7b9..8cd003f5c8f59 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -586,8 +586,8 @@ static struct rtable *icmp_route_lookup(struct net *net,
  *  - ICMPv4 Parameter Problem
  */
 
-void icmp_identify_arrival_interface(struct sk_buff *skb, struct net *net, int room,
-				     struct icmphdr *icmph)
+static void icmp_identify_arrival_interface(struct sk_buff *skb, struct net *net, int room,
+					    struct icmphdr *icmph)
 {
 	unsigned int ext_len, if_index, orig_len, offset, extra_space_needed,
 		     word_aligned_orig_len, mtu, name_len, name_subobj_len;
