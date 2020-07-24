Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E447222BD12
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 06:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgGXEds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 00:33:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:42603 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbgGXEdr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 00:33:47 -0400
IronPort-SDR: bELaA7SBaA7xqaQGimB02VEoxaM5GDjSxoJzuyWyBXUgKvLQWAqamvc98HvBt6YLrzspCRvdga
 yf00nJl6uzbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="148149744"
X-IronPort-AV: E=Sophos;i="5.75,389,1589266800"; 
   d="scan'208";a="148149744"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 21:33:47 -0700
IronPort-SDR: knjCVN75adbp20BcHA5P2JRvr4+b7s5AK0gZorrnCEGXmFu3BTK3tMcSwUknrE+Z2LbixG3JzC
 IjUFTD+K0NWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,389,1589266800"; 
   d="scan'208";a="288872743"
Received: from lkp-server01.sh.intel.com (HELO df0563f96c37) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 23 Jul 2020 21:33:46 -0700
Received: from kbuild by df0563f96c37 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1jypOz-00003X-G6; Fri, 24 Jul 2020 04:33:45 +0000
Date:   Fri, 24 Jul 2020 12:33:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH] icmp6: ipv6_icmp_error_rfc4884() can be static
Message-ID: <20200724043308.GA2668@a9ba65664c75>
References: <20200723143357.451069-4-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723143357.451069-4-willemdebruijn.kernel@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: kernel test robot <lkp@intel.com>
---
 datagram.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index dd1d71e12b61a5..cc8ad7ddecdaa3 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -285,8 +285,8 @@ int ip6_datagram_connect_v6_only(struct sock *sk, struct sockaddr *uaddr,
 }
 EXPORT_SYMBOL_GPL(ip6_datagram_connect_v6_only);
 
-void ipv6_icmp_error_rfc4884(const struct sk_buff *skb,
-			     struct sock_ee_data_rfc4884 *out)
+static void ipv6_icmp_error_rfc4884(const struct sk_buff *skb,
+				    struct sock_ee_data_rfc4884 *out)
 {
 	switch (icmp6_hdr(skb)->icmp6_type) {
 	case ICMPV6_TIME_EXCEED:
